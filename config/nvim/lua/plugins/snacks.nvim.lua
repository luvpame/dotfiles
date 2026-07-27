-- snacks.nvim で小さな QoL 機能をまとめて導入します。
-- 有効化するもの:
-- 大きなファイル対策と、ファイル指定起動時の初期表示高速化。
-- 起動画面、ファイル選択、入力欄、通知など普段使いの表示を Snacks に寄せる。
-- インデント、スコープ、スクロール、ステータス列、参照ジャンプで編集画面を補助する。
-- スクラッチバッファ、ターミナル、Ziggity、GitHub 連携、ブラウザ表示、集中モードはキーマップから呼び出す。
-- 現在行の Git blame は Snacks の小さなターミナルウィンドウで確認する。
-- コマンドラインそのもののリッチ表示は Snacks ではなく noice.nvim 側に任せる。
vim.env.GIT_OPTIONAL_LOCKS = vim.env.GIT_OPTIONAL_LOCKS or "0"

local function lsp_preview_opts()
  return {
    auto_confirm = false,
    layout = { preset = "dropdown" },
  }
end

local function dashboard_header_gradient(item)
  local lines = vim.split(item.header or "", "\n", { plain = true, trimempty = false })
  local width = 0

  for _, line in ipairs(lines) do
    width = math.max(width, vim.api.nvim_strwidth(line))
  end

  local chunks = {}
  for line_index, line in ipairs(lines) do
    local column = 0

    for _, char in ipairs(vim.fn.split(line, [[\zs]])) do
      local char_width = vim.api.nvim_strwidth(char)
      local gradient_index = math.floor((column + char_width / 2) * 67 / math.max(width - 1, 1)) + 1

      table.insert(chunks, {
        char,
        hl = char == " " and nil or ("SnacksDashboardHeaderGradient%d"):format(math.min(68, gradient_index)),
      })
      column = column + char_width
    end

    if line_index < #lines then
      table.insert(chunks, { "\n" })
    end
  end

  return chunks
end

return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    bigfile = { enabled = true },
    dashboard = {
      enabled = true,
      preset = {
        header = [[
 ██╗      ██╗   ██╗ ██╗   ██╗ ██████╗   █████╗  ███╗   ███╗ ███████╗
 ██║      ██║   ██║ ██║   ██║ ██╔══██╗ ██╔══██╗ ████╗ ████║ ██╔════╝
 ██║      ██║   ██║ ██║   ██║ ██████╔╝ ███████║ ██╔████╔██║ █████╗  
 ██║      ██║   ██║ ╚██╗ ██╔╝ ██╔═══╝  ██╔══██║ ██║╚██╔╝██║ ██╔══╝  
 ███████╗ ╚██████╔╝  ╚████╔╝  ██║      ██║  ██║ ██║ ╚═╝ ██║ ███████╗
 ╚══════╝  ╚═════╝    ╚═══╝   ╚═╝      ╚═╝  ╚═╝ ╚═╝     ╚═╝ ╚══════╝

 ███╗   ██╗ ███████╗  ██████╗  ██╗   ██╗ ██╗ ███╗   ███╗
 ████╗  ██║ ██╔════╝ ██╔═══██╗ ██║   ██║ ██║ ████╗ ████║
 ██╔██╗ ██║ █████╗   ██║   ██║ ██║   ██║ ██║ ██╔████╔██║
 ██║╚██╗██║ ██╔══╝   ██║   ██║ ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║
 ██║ ╚████║ ███████╗ ╚██████╔╝  ╚████╔╝  ██║ ██║ ╚═╝ ██║
 ╚═╝  ╚═══╝ ╚══════╝  ╚═════╝    ╚═══╝   ╚═╝ ╚═╝     ╚═╝
        ]],
        keys = {
          { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
          { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
          { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
          { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
          {
            icon = " ",
            key = "c",
            desc = "Config",
            action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
          },
          { icon = " ", key = "s", desc = "Restore Session", section = "session" },
          { icon = "󰒲 ", key = "L", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
          { icon = " ", key = "q", desc = "Quit", action = ":qa" },
        },
      },
      formats = {
        header = dashboard_header_gradient,
      },
    },
    explorer = { enabled = false },
    gh = {},
    indent = { enabled = true },
    input = { enabled = true },
    notifier = {
      enabled = true,
      timeout = 3000,
    },
    picker = {
      enabled = true,
      sources = {
        files = { hidden = true },
      },
    },
    quickfile = { enabled = true },
    scope = { enabled = true },
    scroll = { enabled = true },
    statuscolumn = {
      enabled = true,
      left = { "git", "mark", "sign" },
      right = { "fold" },
    },
    words = { enabled = true },
    dim = { enabled = true },
    styles = {
      terminal = {
        border = "rounded",
        backdrop = 60,
        width = 0.85,
        height = 0.85,
        on_win = function(win)
          vim.wo[win.win].winblend = 20
        end,
        wo = {
          winblend = 20,
          winhighlight = "Normal:SnacksTerminalNormal,NormalNC:SnacksTerminalNormal,FloatBorder:SnacksTerminalBorder",
        },
      },
      blame_line = {
        width = 0.6,
        height = 0.6,
        border = true,
        title = " Git Blame ",
        title_pos = "center",
        ft = "git",
      },
    },
  },
  keys = {
    {
      "<leader><space>",
      function()
        Snacks.picker.smart()
      end,
      desc = "スマート検索",
    },
    {
      "<leader>,",
      function()
        Snacks.picker.buffers()
      end,
      desc = "バッファ一覧",
    },
    {
      "<leader>/",
      function()
        Snacks.picker.grep()
      end,
      desc = "文字列検索",
    },
    {
      "<leader>:",
      function()
        Snacks.picker.command_history()
      end,
      desc = "コマンド履歴",
    },
    {
      "<leader>n",
      function()
        Snacks.notifier.show_history()
      end,
      desc = "通知履歴",
    },

    {
      "<leader>fc",
      function()
        Snacks.picker.files({ cwd = vim.fn.stdpath("config") })
      end,
      desc = "設定ファイルを探す",
    },
    {
      "<leader>ff",
      function()
        Snacks.picker.files()
      end,
      desc = "ファイルを探す",
    },
    {
      "<leader>fg",
      function()
        Snacks.picker.git_files()
      end,
      desc = "Git管理ファイルを探す",
    },
    {
      "<leader>fr",
      function()
        Snacks.picker.recent()
      end,
      desc = "最近使ったファイル",
    },

    {
      "<leader>gb",
      function()
        Snacks.picker.git_branches()
      end,
      desc = "Gitブランチ一覧",
    },
    {
      "<leader>gl",
      function()
        Snacks.picker.git_log()
      end,
      desc = "Gitログ",
    },
    {
      "<leader>gL",
      function()
        Snacks.git.blame_line({ count = vim.v.count > 0 and vim.v.count or nil })
      end,
      desc = "現在行のGit blame",
    },
    {
      "<leader>gs",
      function()
        Snacks.picker.git_status()
      end,
      desc = "Git状態",
    },
    {
      "<leader>gd",
      function()
        Snacks.picker.git_diff()
      end,
      desc = "Git差分ハンク",
    },
    {
      "<leader>gB",
      function()
        Snacks.gitbrowse()
      end,
      desc = "Gitの場所をブラウザで開く",
      mode = { "n", "v" },
    },
    {
      "<leader>gg",
      function()
        Snacks.terminal("ziggity", {
          cwd = Snacks.git.get_root() or vim.fn.getcwd(),
        })
      end,
      desc = "Ziggityを開く",
    },
    {
      "<leader>gi",
      function()
        Snacks.picker.gh_issue()
      end,
      desc = "GitHub Issue一覧",
    },
    {
      "<leader>gI",
      function()
        Snacks.picker.gh_issue({ state = "all" })
      end,
      desc = "GitHub Issue一覧（全件）",
    },
    {
      "<leader>gp",
      function()
        Snacks.picker.gh_pr()
      end,
      desc = "GitHub PR一覧",
    },
    {
      "<leader>gP",
      function()
        Snacks.picker.gh_pr({ state = "all" })
      end,
      desc = "GitHub PR一覧（全件）",
    },

    {
      "<leader>sb",
      function()
        Snacks.picker.lines()
      end,
      desc = "バッファ内の行を探す",
    },
    {
      "<leader>sB",
      function()
        Snacks.picker.grep_buffers()
      end,
      desc = "開いているバッファを検索",
    },
    {
      "<leader>sd",
      function()
        Snacks.picker.diagnostics()
      end,
      desc = "診断一覧",
    },
    {
      "<leader>sD",
      function()
        Snacks.picker.diagnostics_buffer()
      end,
      desc = "現在バッファの診断一覧",
    },
    {
      "<leader>sh",
      function()
        Snacks.picker.help()
      end,
      desc = "ヘルプを探す",
    },
    {
      "<leader>sk",
      function()
        Snacks.picker.keymaps()
      end,
      desc = "キーマップ一覧",
    },
    {
      "<leader>sC",
      function()
        Snacks.picker.commands()
      end,
      desc = "コマンド一覧",
    },
    {
      "<leader>sR",
      function()
        Snacks.picker.resume()
      end,
      desc = "前回のピッカーを再開",
    },
    {
      "<leader>sw",
      function()
        Snacks.picker.grep_word()
      end,
      desc = "単語または選択範囲を検索",
      mode = { "n", "x" },
    },

    {
      "gd",
      function()
        Snacks.picker.lsp_definitions(lsp_preview_opts())
      end,
      desc = "定義をプレビュー",
    },
    {
      "gD",
      function()
        Snacks.picker.lsp_declarations(lsp_preview_opts())
      end,
      desc = "宣言をプレビュー",
    },
    {
      "gr",
      function()
        Snacks.picker.lsp_references(lsp_preview_opts())
      end,
      nowait = true,
      desc = "参照をプレビュー",
    },
    {
      "gI",
      function()
        Snacks.picker.lsp_implementations(lsp_preview_opts())
      end,
      desc = "実装をプレビュー",
    },
    {
      "gy",
      function()
        Snacks.picker.lsp_type_definitions(lsp_preview_opts())
      end,
      desc = "型定義をプレビュー",
    },
    {
      "<leader>ss",
      function()
        Snacks.picker.lsp_symbols()
      end,
      desc = "言語サーバーのシンボル一覧",
    },
    {
      "<leader>sS",
      function()
        Snacks.picker.lsp_workspace_symbols()
      end,
      desc = "ワークスペースのシンボル一覧",
    },

    {
      "<leader>z",
      function()
        Snacks.zen()
      end,
      desc = "集中モードを切り替え",
    },
    {
      "<leader>Z",
      function()
        Snacks.zen.zoom()
      end,
      desc = "ズームを切り替え",
    },
    {
      "<leader>bd",
      function()
        Snacks.bufdelete()
      end,
      desc = "バッファを削除",
    },
    {
      "<leader>cR",
      function()
        Snacks.rename.rename_file()
      end,
      desc = "ファイル名を変更",
    },
    {
      "<leader>un",
      function()
        Snacks.notifier.hide()
      end,
      desc = "すべての通知を閉じる",
    },
    {
      "<leader>t",
      function()
        Snacks.terminal(vim.o.shell)
      end,
      desc = "ターミナルを切り替え",
    },
    {
      "]]",
      function()
        Snacks.words.jump(vim.v.count1)
      end,
      desc = "次の参照へ移動",
      mode = { "n", "t" },
    },
    {
      "[[",
      function()
        Snacks.words.jump(-vim.v.count1)
      end,
      desc = "前の参照へ移動",
      mode = { "n", "t" },
    },
  },
}
