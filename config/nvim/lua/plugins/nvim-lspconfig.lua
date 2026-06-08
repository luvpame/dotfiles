-- nvim-lspconfig のサーバー定義を使い、Neovim 標準 LSP API で有効化します。
-- LSP サーバー本体は Nix/Home Manager 側で宣言的に管理します。
return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    vim.lsp.config("efm", {
      init_options = {
        documentFormatting = true,
        documentRangeFormatting = true,
      },
      filetypes = {
        "nix",
        "yaml",
        "lua",
        "sh",
        "bash",
        "zsh",
      },
    })

    local efm_format_filetypes = {
      bash = true,
      lua = true,
      nix = true,
      sh = true,
      zsh = true,
    }

    local efm_format_group = vim.api.nvim_create_augroup("EfmFormat", { clear = true })
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = efm_format_group,
      callback = function(args)
        if not efm_format_filetypes[vim.bo[args.buf].filetype] then
          return
        end

        if #vim.lsp.get_clients({ bufnr = args.buf, name = "efm" }) == 0 then
          return
        end

        vim.lsp.buf.format({
          bufnr = args.buf,
          name = "efm",
          timeout_ms = 1000,
        })
      end,
    })

    vim.lsp.enable({ "nixd", "lua_ls", "efm", "just", "ruby_lsp" })
  end,
}
