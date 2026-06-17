-- Neovim 全体のキーマップを設定するファイルです。

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.keymap.set("i", "jj", "<Esc>", { desc = "インサートモードを抜ける" })
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR><Esc>", { desc = "検索ハイライトを消す", silent = true })
vim.keymap.set({ "n", "x" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "コードアクション" })

local delete_register_mappings = {
  d = { '"dd', "削除を d レジスタへ保存" },
  D = { '"dD', "行末までの削除を d レジスタへ保存" },
  x = { '"dx', "1 文字削除を d レジスタへ保存" },
  X = { '"dX', "前方削除を d レジスタへ保存" },
  c = { '"dc', "変更を d レジスタへ保存" },
  C = { '"dC', "行末までの変更を d レジスタへ保存" },
  s = { '"ds', "置換を d レジスタへ保存" },
  S = { '"dS', "行置換を d レジスタへ保存" },
}

for lhs, mapping in pairs(delete_register_mappings) do
  vim.keymap.set({ "n", "x" }, lhs, mapping[1], { desc = mapping[2] })
end
