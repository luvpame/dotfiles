-- pr.nvim で Neovim から GitHub Pull Request レビューを行います。
local function write_temp_diff(lines)
  local diff_file = vim.fn.tempname()
  vim.fn.writefile(lines, diff_file)
  return diff_file
end

local function patch_file_picker()
  local picker = require("pr.picker")

  picker._telescope_files = function(files, current)
    local pickers = require("telescope.pickers")
    local finders = require("telescope.finders")
    local conf = require("telescope.config").values
    local actions = require("telescope.actions")
    local action_state = require("telescope.actions.state")
    local entry_display = require("telescope.pickers.entry_display")
    local previewers = require("telescope.previewers")

    local displayer = entry_display.create({
      separator = " ",
      items = {
        { width = 3 },
        { remaining = true },
      },
    })

    local full_diff = require("pr.github").get_diff(current.owner, current.repo, current.number)

    local function extract_file_diff(file)
      if not full_diff then
        return { "No diff available" }
      end

      local lines = vim.split(full_diff, "\n")
      local result = {}
      local in_file = false
      local escaped = vim.pesc(file)

      for _, line in ipairs(lines) do
        if line:match("^diff %-%-git") then
          if line:match("b/" .. escaped .. "$") then
            in_file = true
          elseif in_file then
            break
          else
            in_file = false
          end
        end

        if in_file then
          table.insert(result, line)
        end
      end

      return #result > 0 and result or { "No diff for " .. file }
    end

    local function entry_maker(file)
      return {
        value = file,
        display = function()
          local status = current.reviewed[file] and "●" or "○"
          return displayer({
            { status, current.reviewed[file] and "DiagnosticOk" or "Comment" },
            file,
          })
        end,
        ordinal = file,
      }
    end

    pickers
      .new({
        layout_strategy = "horizontal",
        layout_config = {
          width = 0.85,
          height = 0.8,
          preview_width = 0.55,
          prompt_position = "top",
        },
        sorting_strategy = "ascending",
      }, {
        prompt_title = string.format("PR #%d Files (%d)", current.number, #files),
        finder = finders.new_table({
          results = files,
          entry_maker = entry_maker,
        }),
        sorter = conf.generic_sorter({}),
        previewer = previewers.new_termopen_previewer({
          title = "Diff",
          get_command = function(entry)
            local diff_file = write_temp_diff(extract_file_diff(entry.value))

            if vim.fn.executable("hunk") == 1 then
              return { "sh", "-c", ("hunk pager < %s"):format(vim.fn.shellescape(diff_file)) }
            end

            return { "cat", diff_file }
          end,
        }),
        attach_mappings = function(prompt_bufnr, map)
          actions.select_default:replace(function()
            actions.close(prompt_bufnr)
            local selection = action_state.get_selected_entry()
            require("pr.review").open_file(selection.value)
          end)

          local function toggle_reviewed()
            local selection = action_state.get_selected_entry()
            if not selection then
              return
            end

            local selected_file = selection.value
            current.reviewed[selected_file] = current.reviewed[selected_file] and nil or true

            local selected_idx = 1
            for i, file in ipairs(files) do
              if file == selected_file then
                selected_idx = i
                break
              end
            end

            local current_picker = action_state.get_current_picker(prompt_bufnr)
            current_picker:refresh(
              finders.new_table({
                results = files,
                entry_maker = entry_maker,
              }),
              { reset_prompt = false }
            )

            vim.defer_fn(function()
              current_picker = action_state.get_current_picker(prompt_bufnr)
              if current_picker then
                current_picker:set_selection(selected_idx - 1)
              end
            end, 10)
          end

          map("i", "<C-v>", toggle_reviewed)
          map("n", "<C-v>", toggle_reviewed)
          map("n", "v", toggle_reviewed)

          return true
        end,
      })
      :find()
  end
end

return {
  "0xKitsune/pr.nvim",
  cmd = "PR",
  dependencies = {
    "nvim-telescope/telescope.nvim",
  },
  config = function(_, opts)
    require("pr").setup(opts)
    patch_file_picker()
  end,
}
