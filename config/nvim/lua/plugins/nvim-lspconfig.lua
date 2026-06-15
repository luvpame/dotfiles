-- nvim-lspconfig のサーバー定義を使い、Neovim 標準 LSP API で有効化します。
-- LSP サーバー本体は Nix/Home Manager 側で宣言的に管理します。
return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    vim.lsp.config("ruby_lsp", {
      init_options = {
        formatter = "rubocop",
      },
    })

    vim.lsp.config("efm", {
      init_options = {
        documentFormatting = true,
        documentRangeFormatting = true,
      },
      filetypes = {
        "nix",
        "yaml",
        "lua",
        "typescript",
        "typescriptreact",
        "sh",
        "bash",
        "zsh",
      },
    })

    local formatters = {
      bash = "efm",
      lua = "efm",
      nix = "efm",
      ruby = "ruby_lsp",
      sh = "efm",
      typescript = "efm",
      typescriptreact = "efm",
      zsh = "efm",
    }

    local format_group = vim.api.nvim_create_augroup("LspFormat", { clear = true })
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = format_group,
      callback = function(args)
        local formatter = formatters[vim.bo[args.buf].filetype]
        if not formatter then
          return
        end

        if #vim.lsp.get_clients({ bufnr = args.buf, name = formatter }) == 0 then
          return
        end

        vim.lsp.buf.format({
          bufnr = args.buf,
          name = formatter,
          timeout_ms = 1000,
        })
      end,
    })

    vim.lsp.enable({ "nixd", "lua_ls", "efm", "just", "ruby_lsp", "tsgo" })
  end,
}
