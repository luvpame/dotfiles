return {
  "kamegoro/tobira.nvim",
  event = "VeryLazy",
  keys = {
    {
      "<leader>vn",
      "<cmd>Tobira<CR>",
      desc = "Tobira 次の提案",
    },
    {
      "<leader>vg",
      "<cmd>TobiraGuide<CR>",
      desc = "Tobira ガイド",
    },
    {
      "<leader>vp",
      "<cmd>TobiraProgress<CR>",
      desc = "Tobira 進捗",
    },
    {
      "<leader>vs",
      "<cmd>TobiraStats<CR>",
      desc = "Tobira 統計",
    },
  },
  opts = {
    lang = "ja",
    idle_delay = 1000,
  },
}
