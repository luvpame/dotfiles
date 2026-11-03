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
  run = function(ctx)
    local result, err = rex.session.new_layer {
      bounds = { 0.1, 0.1, 0.8, 0.8 },
      layout = terminal_layout(ctx, { "fish", os.getenv("HOME") .. "/.config/rex/repository-picker.fish" }),
      focus = true,
    }
    if err then error(err, 0) end
    return result
  end,
}

rex.action {
  name = "worktree_picker",
  title = "Worktree and PR Review",
  run = function(ctx)
    local result, err = rex.session.new_layer {
      bounds = { 0.1, 0.1, 0.8, 0.8 },
      layout = terminal_layout(ctx, { "python3", os.getenv("HOME") .. "/.config/rex/scripts/worktree-picker.py" }),
      focus = true,
    }
    if err then error(err, 0) end
    return result
  end,
}

rex.action {
  name = "pr_review",
  title = "PR Review",
  run = function(ctx)
    local result, err = rex.session.new_layer {
      bounds = { 0.1, 0.1, 0.8, 0.8 },
      layout = terminal_layout(ctx, { "python3", os.getenv("HOME") .. "/.config/rex/scripts/pr-review.py" }),
      focus = true,
    }
    if err then error(err, 0) end
    return result
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
