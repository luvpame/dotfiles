-- octo.nvim で現在ブランチの GitHub PR を差分レビューします。
return {
  "pwntester/octo.nvim",
  cmd = "Octo",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
    "nvim-tree/nvim-web-devicons",
  },
  opts = {
    picker = "telescope",
    file_panel = {
      size = 20,
    },
    mappings = {
      review_diff = {
        toggle_viewed = {
          lhs = "<localleader>v",
          desc = "ファイルの閲覧済み状態を切り替える",
        },
      },
      file_panel = {
        toggle_viewed = {
          lhs = "<localleader>v",
          desc = "ファイルの閲覧済み状態を切り替える",
        },
      },
    },
  },
  keys = {
    {
      "<leader>gr",
      "<cmd>Octo review browse<cr>",
      desc = "現在ブランチのPR差分レビュー",
    },
  },
}
