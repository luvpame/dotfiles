-- nvim-lspconfig のサーバー定義を使い、Neovim 標準 LSP API で有効化します。
-- LSP サーバー本体は Nix/Home Manager やプロジェクト環境側で管理します。
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
        "css",
        "scss",
        "less",
        "javascript",
        "javascriptreact",
        "typescript",
        "typescriptreact",
        "sh",
        "bash",
        "zsh",
      },
    })

    local css_capabilities = vim.lsp.protocol.make_client_capabilities()
    css_capabilities.textDocument.completion.completionItem.snippetSupport = true

    vim.lsp.config("cssls", {
      capabilities = css_capabilities,
    })

    vim.lsp.config("css_variables", {
      settings = {
        cssVariables = {
          lookupFiles = { "packages/design-system/build/css/variables.css" },
          blacklistFolders = {},
        },
      },
    })

    local formatters = {
      bash = "efm",
      css = "efm",
      javascript = "efm",
      javascriptreact = "efm",
      less = "efm",
      lua = "efm",
      nix = "efm",
      ruby = "ruby_lsp",
      scss = "efm",
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
          timeout_ms = 3000,
        })
      end,
    })

    vim.api.nvim_create_autocmd("BufWritePost", {
      group = format_group,
      callback = function(args)
        if not vim.bo[args.buf].endofline then
          vim.bo[args.buf].endofline = true
        end
      end,
    })

    vim.lsp.enable({
      "nixd",
      "lua_ls",
      "efm",
      "just",
      "ruby_lsp",
      "tsgo",
      "cssls",
      "css_variables",
    })
  end,
}
