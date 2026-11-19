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

local function exec_result(argv, cwd)
  local result, err
  if cwd and cwd ~= "" then
    result, err = rex.exec(argv, { cwd = cwd })
  else
    result, err = rex.exec(argv)
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

local function run_in_layer(ctx, cwd, argv)
  if not cwd or cwd == "" then error("Cannot determine the working directory", 0) end
  local result, err = rex.session.new_layer {
    bounds = { 0.1, 0.1, 0.8, 0.8 },
    layout = rex.layout.block {
      flavor = "com.superlogical.terminal.shell",
      options = {
        cwd = cwd,
        command = argv,
        exit = { on_completion = false },
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

local function run_pr_review(ctx, args)
  local cwd = repo_cwd(ctx)
  if args.number ~= nil and tostring(args.number) ~= "" then
    return run_in_layer(ctx, cwd, { "python3", pr_script, "--number", tostring(args.number) })
  end
  local data = read_catalog(pr_script, nil, cwd)
  if #(data.items or {}) == 0 then
    pick({
      title = "PR Review",
      items = { { id = "none", title = "レビュー依頼のある PR はありません" } },
    })
    return
  end
  local reject = {}
  for _, id in ipairs(data.reject_ids or {}) do
    reject[tostring(id)] = true
  end
  local title = "PR Review"
  while true do
    local picked = pick({ title = title, items = palette_items(data.items) })
    if picked == nil then return end
    if reject[tostring(picked)] then
      title = "PR #" .. picked .. " はレビュー対象外です。レビュー依頼のある PR を選択してください"
    else
      return run_in_layer(ctx, cwd, { "python3", pr_script, "--number", tostring(picked) })
    end
  end
end

local function run_worktree_switch(ctx)
  local cwd = repo_cwd(ctx)
  local data = read_catalog(picker_script, nil, cwd)
  local items = { { id = "new", title = "New Worktree", icon = "plus" } }
  for _, item in ipairs(data.items or {}) do
    items[#items + 1] = item
  end
  local selected = pick({ title = "Worktree", items = palette_items(items) })
  if selected == nil then return end
  if selected == "new" then
    local name = ask_input({ title = "Worktree name", confirm = "作成" })
    if name == nil then return end
    name = (name:gsub("^%s+", ""):gsub("%s+$", ""))
    if name == "" then return end
    return run_in_layer(ctx, cwd, { "python3", picker_script, "--create", name })
  end
  exec_result({ "python3", picker_script, "--open", selected }, cwd)
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
  local chosen = items
  if not merged then
    local ids = pick({
      title = "Worktree 削除",
      multiple = true,
      confirm = "削除確認へ",
      items = palette_items(items),
    })
    if ids == nil or #ids == 0 then return end
    local wanted = {}
    for _, id in ipairs(ids) do
      wanted[id] = true
    end
    chosen = {}
    for _, item in ipairs(items) do
      if wanted[item.id] then chosen[#chosen + 1] = item end
    end
    if #chosen == 0 then return end
  end
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
