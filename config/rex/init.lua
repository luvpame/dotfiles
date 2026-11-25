rex.bind("ctrl+j>c", "client.tab.new")
rex.bind("ctrl+j>tab", "pane.focus_next")
rex.bind("ctrl+j>shift+\\", "pane.split", { direction = "right" })
rex.bind("ctrl+j>-", "pane.split", { direction = "down" })
rex.bind("ctrl+j>h", "pane.focus", { direction = "left" })
rex.bind("ctrl+j>j", "pane.focus", { direction = "down" })
rex.bind("ctrl+j>k", "pane.focus", { direction = "up" })
rex.bind("ctrl+j>l", "pane.focus", { direction = "right" })
rex.bind("ctrl+j>r", "client.mode.enter", { name = "resize" })
rex.bind("ctrl+j>t", "floating_terminal")
rex.bind("ctrl+j>g", "lazygit_pane")
rex.bind("ctrl+j>d", "hunk_diff")
rex.bind("ctrl+j>b", "repository_picker")
rex.bind("ctrl+j>p", "worktree_picker")
rex.bind("ctrl+j>shift+r", "pr_review")

local scripts = os.getenv("HOME") .. "/.config/rex/scripts"
local pr_script = scripts .. "/pr-review.py"
local picker_script = scripts .. "/worktree-picker.py"
local remove_script = scripts .. "/worktree-remove.py"
local wide_pick_script = scripts .. "/worktree-pick.sh"

-- Rex.app の rex.exec は PATH が /usr/bin:/bin:/usr/sbin:/sbin だけなので、
-- git は見つかるが rex と gh は見つからない。ログインシェルと同じ場所を前置し、
-- 呼び出し元の PATH はその後ろに残す。
local function command_path_prefix()
  local home = os.getenv("HOME") or ""
  local user = os.getenv("USER") or os.getenv("LOGNAME") or ""
  return table.concat({
    home .. "/.nix-profile/bin",
    "/etc/profiles/per-user/" .. user .. "/bin",
    "/run/current-system/sw/bin",
    "/nix/var/nix/profiles/default/bin",
    "/opt/homebrew/bin",
    "/opt/homebrew/sbin",
    home .. "/.local/bin",
    home .. "/go/bin",
    home .. "/Library/Application Support/com.superlogical.rex/RexServer/Versions/Current/Rex Server.app/Contents/MacOS",
  }, ":")
end

local function exec_argv(argv)
  local command = {
    "/bin/sh", "-c",
    'export PATH="$1${PATH:+:$PATH}"; shift; exec "$@"',
    "rex-exec",
    command_path_prefix(),
  }
  for _, arg in ipairs(argv) do
    command[#command + 1] = arg
  end
  return command
end

local function exec_result(argv, cwd)
  local command = exec_argv(argv)
  local result, err
  if cwd and cwd ~= "" then
    result, err = rex.exec(command, { cwd = cwd })
  else
    result, err = rex.exec(command)
  end
  if result == nil then error(err, 0) end
  if not result.ok then error(result.stderr ~= "" and result.stderr or result.stdout, 0) end
  return result.stdout
end

local function exec_json(argv, cwd)
  local decoded, err = rex.json.decode(exec_result(argv, cwd))
  if decoded == nil then error(err, 0) end
  return decoded
end

local function pick(spec)
  local value, why, detail = rex.ui.pick(spec)
  if value == nil then
    if why ~= "cancelled" then
      rex.log("warn", spec.title .. ": " .. tostring(why) .. (detail and (" " .. detail) or ""))
    end
    return nil
  end
  return value
end

-- rex.ui.pick の幅は Rex.app が固定していて、パスや PR タイトルが途中で切れる。
-- 一覧はウィンドウ幅の 92% のペインで出す。
-- init.lua の action は 30 秒で打ち切られるので選択を待たず、
-- 選んだ ID はペインが wide_pick_done へ渡し、after_pick[to] が続きを行う。
local function pick_wide(ctx, cwd, to, spec)
  local list_path = os.tmpname()
  local file, open_err = io.open(list_path, "w")
  if not file then error(open_err, 0) end
  for _, item in ipairs(spec.items or {}) do
    local label = item.title or ""
    if item.subtitle and item.subtitle ~= "" and item.subtitle ~= item.title then
      label = label .. "    " .. item.subtitle
    end
    if item.detail and item.detail ~= "" then
      label = label .. "    " .. item.detail
    end
    file:write((item.id or ""):gsub("[\t\r\n]", " "), "\t", label:gsub("[\t\r\n]", " "), "\n")
  end
  file:close()

  local layout = rex.layout.block {
    flavor = "com.superlogical.terminal.shell",
    options = {
      cwd = cwd,
      command = {
        "/bin/bash", wide_pick_script, list_path, spec.title or ">",
        spec.multiple and "multi" or "",
        spec.header or "",
        to, cwd,
      },
      exit = { on_completion = true },
    },
  }
  layout.block.label = spec.title
  local layer_args = {
    bounds = { 0.04, 0.12, 0.92, 0.76 },
    focus = true,
    layout = layout,
  }
  if ctx.session_id then layer_args.session_id = ctx.session_id end
  local opened, layer_err = rex.session.new_layer(layer_args)
  if layer_err then
    os.remove(list_path)
    error(layer_err, 0)
  end
  return opened
end

local function ask_input(spec)
  local value, why, detail = rex.ui.input(spec)
  if value == nil then
    if why ~= "cancelled" then
      rex.log("warn", spec.title .. ": " .. tostring(why) .. (detail and (" " .. detail) or ""))
    end
    return nil
  end
  return value
end

local function palette_items(items)
  local copy = {}
  for _, item in ipairs(items or {}) do
    local entry = { id = item.id, title = item.title, icon = item.icon }
    if item.subtitle and item.subtitle ~= "" then entry.subtitle = item.subtitle end
    if item.detail and item.detail ~= "" then entry.detail = item.detail end
    if item.selected then entry.selected = true end
    copy[#copy + 1] = entry
  end
  return copy
end

local function read_catalog(script, extra, cwd)
  local argv = { "python3", script, "--catalog" }
  if extra then
    for _, arg in ipairs(extra) do
      argv[#argv + 1] = arg
    end
  end
  return exec_json(argv, cwd)
end

-- rex.exec の既定 cwd はサーバプロセスのディレクトリなので、git はフォーカス中の端末で実行する。
local function focused_cwd(ctx)
  if not ctx.block_id then return nil end
  local process, err = rex.block.call("com.superlogical.terminal", "process", { block_id = ctx.block_id })
  if err or not process then return nil end
  local foreground = process.foreground and process.foreground.cwd
  if foreground then return foreground end
  return process.child and process.child.cwd
end

local function repo_cwd(ctx)
  local cwd = focused_cwd(ctx)
  if not cwd or cwd == "" then
    error("Cannot determine the focused terminal's working directory", 0)
  end
  return cwd
end

-- 成功したら float window を閉じる。失敗したときはエラーを読めるよう Enter まで残す。
local function run_in_layer(ctx, cwd, argv)
  if not cwd or cwd == "" then error("Cannot determine the working directory", 0) end
  local command = {
    "/bin/sh", "-c",
    '"$@" && exit 0; status=$?; printf "\\n失敗しました（終了コード %s）。Enter で閉じる" "$status"; read _; exit "$status"',
    "run-in-layer",
  }
  for _, arg in ipairs(argv) do
    command[#command + 1] = arg
  end
  local result, err = rex.session.new_layer {
    bounds = { 0.1, 0.1, 0.8, 0.8 },
    layout = rex.layout.block {
      flavor = "com.superlogical.terminal.shell",
      options = {
        cwd = cwd,
        command = command,
        exit = { on_completion = true },
      },
    },
    focus = true,
  }
  if err then error(err, 0) end
  return result
end

local function terminal_layout(ctx, command)
  local process, err = rex.block.call("com.superlogical.terminal", "process", { block_id = ctx.block_id })
  if err then error(err, 0) end
  local cwd = process.foreground and process.foreground.cwd
  if not cwd then error("Cannot determine the focused terminal's working directory", 0) end
  return rex.layout.block {
    flavor = "com.superlogical.terminal.shell",
    options = { cwd = cwd, command = command },
  }
end

local function switch_repository(path)
  local listed = exec_json({ "rex", "ls", "--json" })
  for _, session in ipairs(listed.sessions or {}) do
    local blocks = exec_json({ "rex", "block", "ls", "-s", session.session_id, "--json" })
    for _, block in ipairs(blocks.blocks or {}) do
      if block.creator_name == "com.superlogical.terminal" then
        local process = exec_json({
          "rex", "block", "call", "-s", session.session_id, "-b", block.block_id, "process",
        })
        local cwd = (process.foreground and process.foreground.cwd) or (process.child and process.child.cwd)
        if cwd == path then
          exec_result({ "rex", "do", "session.select", "session_id=" .. session.session_id })
          return
        end
      end
    end
  end
  local name = path:match("([^/]+)$")
  local created = exec_json({ "rex", "new", name, "-c", path, "--json" })
  exec_result({ "rex", "do", "session.select", "session_id=" .. created.session_id })
end

local after_pick = {}

-- レビューは別セッションのタブで進むので、起動用の float window は最小化して脇に置く。
local function start_pr_review(ctx, cwd, number)
  local opened = run_in_layer(ctx, cwd, { "python3", pr_script, "--number", number })
  local state_args = { layer_id = opened.layer_id, state = "minimized" }
  if ctx.session_id then state_args.session_id = ctx.session_id end
  local _, err = rex.session.set_layer_state(state_args)
  if err then error(err, 0) end
  return opened
end

local function pick_pr(ctx, cwd, data, notice)
  return pick_wide(ctx, cwd, "pr_review", { title = "PR Review", header = notice, items = data.items })
end

local function run_pr_review(ctx, args)
  local cwd = repo_cwd(ctx)
  if args.number ~= nil and tostring(args.number) ~= "" then
    return start_pr_review(ctx, cwd, tostring(args.number))
  end
  local data = read_catalog(pr_script, nil, cwd)
  if #(data.items or {}) == 0 then
    pick({
      title = "PR Review",
      items = { { id = "none", title = "レビュー依頼のある PR はありません" } },
    })
    return
  end
  return pick_pr(ctx, cwd, data, nil)
end

after_pick.pr_review = function(ctx, cwd, ids)
  local picked = ids[1]
  local data = read_catalog(pr_script, nil, cwd)
  for _, id in ipairs(data.reject_ids or {}) do
    if tostring(id) == picked then
      return pick_pr(ctx, cwd, data, "PR #" .. picked .. " はレビュー対象外です。レビュー依頼のある PR を選択してください")
    end
  end
  return start_pr_review(ctx, cwd, picked)
end

local function run_worktree_switch(ctx)
  local cwd = repo_cwd(ctx)
  local data = read_catalog(picker_script, nil, cwd)
  local items = { { id = "new", title = "New Worktree", icon = "plus" } }
  for _, item in ipairs(data.items or {}) do
    items[#items + 1] = item
  end
  return pick_wide(ctx, cwd, "worktree_switch", { title = "Worktree", items = items })
end

after_pick.worktree_switch = function(ctx, cwd, ids)
  local selected = ids[1]
  if selected == "new" then
    local name = ask_input({ title = "Worktree name", confirm = "作成" })
    if name == nil then return end
    name = (name:gsub("^%s+", ""):gsub("%s+$", ""))
    if name == "" then return end
    return run_in_layer(ctx, cwd, { "python3", picker_script, "--create", name })
  end
  exec_result({ "python3", picker_script, "--open", selected }, cwd)
end

local function confirm_worktree_remove(ctx, cwd, chosen, merged)
  local dirty = false
  for _, item in ipairs(chosen) do
    if item.dirty then dirty = true end
  end
  local title = "削除確認 · " .. tostring(#chosen) .. " 件"
  if dirty then
    title = title .. "（未コミットの変更がある worktree を含みます。削除すると変更は破棄されます）"
  end
  local confirm_items = {}
  for _, item in ipairs(chosen) do
    confirm_items[#confirm_items + 1] = {
      id = item.id,
      title = item.title,
      subtitle = item.subtitle,
      icon = item.icon,
      detail = item.detail,
      selected = true,
    }
  end
  local final = pick({
    title = title,
    multiple = true,
    confirm = "削除",
    items = palette_items(confirm_items),
  })
  if final == nil or #final == 0 then return end
  local argv = { "python3", remove_script, "--remove" }
  if merged then argv[#argv + 1] = "--merged" end
  for _, id in ipairs(final) do
    argv[#argv + 1] = id
  end
  return run_in_layer(ctx, cwd, argv)
end

local function run_worktree_remove(ctx, merged)
  local cwd = repo_cwd(ctx)
  local extra = merged and { "--merged" } or nil
  local data = read_catalog(remove_script, extra, cwd)
  local items = data.items or {}
  if #items == 0 then
    pick({
      title = "Worktree 削除",
      items = { { id = "none", title = "削除対象の worktree はありません" } },
    })
    return
  end
  if merged then return confirm_worktree_remove(ctx, cwd, items, true) end
  return pick_wide(ctx, cwd, "worktree_remove", {
    title = "Worktree 削除",
    multiple = true,
    items = items,
  })
end

after_pick.worktree_remove = function(ctx, cwd, ids)
  local wanted = {}
  for _, id in ipairs(ids) do
    wanted[id] = true
  end
  local chosen = {}
  for _, item in ipairs(read_catalog(remove_script, nil, cwd).items or {}) do
    if wanted[item.id] then chosen[#chosen + 1] = item end
  end
  if #chosen == 0 then return end
  return confirm_worktree_remove(ctx, cwd, chosen, false)
end

rex.action {
  name = "wide_pick_done",
  title = "Continue Wide Pick (internal)",
  args = { to = "string", cwd = "string", picked = "string" },
  run = function(ctx, args)
    local handler = after_pick[args.to]
    if handler == nil then error("wide_pick_done: unknown to=" .. tostring(args.to), 0) end
    local ids = {}
    for id in args.picked:gmatch("[^\n]+") do
      ids[#ids + 1] = id
    end
    if #ids == 0 then return end
    return handler(ctx, args.cwd, ids)
  end,
}

rex.action {
  name = "floating_terminal",
  title = "Open Floating Terminal",
  run = function(ctx)
    local result, err = rex.session.new_layer {
      bounds = { 0.1, 0.1, 0.8, 0.8 },
      layout = terminal_layout(ctx, { "fish" }),
      focus = true,
    }
    if err then error(err, 0) end
    return result
  end,
}

rex.action {
  name = "hunk_diff",
  title = "Open Hunk Diff",
  run = function(ctx)
    local result, err = rex.session.new_layer {
      bounds = { 0, 0, 1, 1 },
      layout = terminal_layout(ctx, { "hunk", "diff" }),
      focus = true,
    }
    if err then error(err, 0) end
    return result
  end,
}

rex.action {
  name = "repository_picker",
  title = "Switch Repository",
  args = { path = "string?" },
  run = function(ctx, args)
    local path = args.path
    if path == nil or path == "" then
      local items = {}
      local raw = exec_result({ "ghq", "list", "--full-path" })
      for line in raw:gmatch("[^\r\n]+") do
        items[#items + 1] = {
          id = line,
          title = line:match("([^/]+)$"),
          subtitle = line,
          icon = "folder",
        }
      end
      if #items == 0 then
        pick({ title = "Switch Repository", items = { { id = "none", title = "リポジトリはありません" } } })
        return
      end
      path = pick({ title = "Switch Repository", items = items })
      if path == nil or path == "none" then return end
    end
    switch_repository(path)
  end,
}

rex.action {
  name = "worktree_picker",
  title = "Worktree and PR Review",
  run = function(ctx, args)
    local action = pick({
      title = "Repository",
      items = {
        { id = "pr_review", title = "PR Review", icon = "code" },
        { id = "switch", title = "Worktree 作成・移動", icon = "branch" },
        { id = "root", title = "Original Root", icon = "folder" },
        { id = "remove", title = "Worktree 削除", icon = "branch" },
        { id = "remove_merged", title = "マージ済み PR の Worktree を一括削除", icon = "branch" },
      },
    })
    if action == nil then return end
    if action == "pr_review" then return run_pr_review(ctx, args) end
    if action == "root" then
      exec_result({ "python3", picker_script, "--root" }, repo_cwd(ctx))
      return
    end
    if action == "switch" then return run_worktree_switch(ctx) end
    if action == "remove" then return run_worktree_remove(ctx, false) end
    if action == "remove_merged" then return run_worktree_remove(ctx, true) end
    error("選択された操作が一覧にありません。", 0)
  end,
}

rex.action {
  name = "pr_review",
  title = "PR Review",
  args = { number = "string?" },
  run = function(ctx, args)
    return run_pr_review(ctx, args)
  end,
}

rex.action {
  name = "lazygit_pane",
  title = "Open Lazygit Pane",
  run = function(ctx)
    local view, err = rex.session.view {}
    if err then error(err, 0) end
    for _, window in ipairs(view.windows) do
      if window.window_id == view.active_window_id then
        for _, layer in ipairs(window.layers) do
          for _, block in ipairs(layer.blocks) do
            if layer.kind == "floating" and block.label == "lazygit-popup" then
              local result, close_err = rex.session.close_layer { layer_id = layer.layer_id }
              if close_err then error(close_err, 0) end
              return result
            end
          end
        end
      end
    end
    local layout = terminal_layout(ctx, { "lazygit" })
    layout.block.label = "lazygit-popup"
    local result, new_err = rex.session.new_layer {
      bounds = { 0.1, 0.1, 0.8, 0.8 },
      layout = layout,
      focus = true,
    }
    if new_err then error(new_err, 0) end
    return result
  end,
}

rex.mode("resize", { exclusive = true })
rex.bind("resize/h", "pane.resize", { direction = "left" })
rex.bind("resize/j", "pane.resize", { direction = "down" })
rex.bind("resize/k", "pane.resize", { direction = "up" })
rex.bind("resize/l", "pane.resize", { direction = "right" })
rex.bind("resize/left", "pane.resize", { direction = "left" })
rex.bind("resize/down", "pane.resize", { direction = "down" })
rex.bind("resize/up", "pane.resize", { direction = "up" })
rex.bind("resize/right", "pane.resize", { direction = "right" })
rex.bind("resize/enter", "client.mode.exit")
