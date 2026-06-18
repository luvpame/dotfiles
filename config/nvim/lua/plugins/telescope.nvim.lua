-- telescope.nvim の Git 差分プレビューを delta 表示に寄せます。
local function delta_command()
  return {
    "delta",
    "--no-gitconfig",
    "--paging=never",
    "--syntax-theme",
    "Catppuccin Latte",
    "--light",
    "--line-numbers",
  }
end

local function git_status_delta_previewer(opts)
  local previewers = require("telescope.previewers")
  opts = opts or {}

  return previewers.new_termopen_previewer(vim.tbl_extend("force", opts, {
    title = "Git Delta Preview",
    get_command = function(entry)
      local path = entry.value
      if not path or path == "" then
        return nil
      end

      local quoted_path = vim.fn.shellescape(path)
      local diff_command = ("GIT_OPTIONAL_LOCKS=0 git --no-pager diff --no-ext-diff --color=never HEAD -- %s"):format(quoted_path)

      if entry.status == "??" then
        diff_command = ("GIT_OPTIONAL_LOCKS=0 git --no-pager diff --no-index --color=never -- /dev/null %s"):format(quoted_path)
      end

      if vim.fn.executable("delta") == 1 then
        return {
          "sh",
          "-c",
          diff_command .. " | " .. table.concat(vim.tbl_map(vim.fn.shellescape, delta_command()), " ") .. " || true",
        }
      end

      return { "sh", "-c", diff_command .. " || true" }
    end,
  }))
end

return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = function(_, opts)
    require("telescope").setup(opts)

    require("telescope.previewers").git_file_diff = {
      new = git_status_delta_previewer,
    }
  end,
}
