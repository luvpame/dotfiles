-- Neovim 全体の基本オプションを設定するファイルです。
-- 行番号を表示する
vim.opt.number = true

-- 現在行からの相対行番号を表示する
vim.opt.relativenumber = true

-- カーソル行をハイライトする
vim.opt.cursorline = true

-- ターミナルの 24 ビットカラーを有効にする
vim.opt.termguicolors = true

-- サインカラムを常に表示して表示の揺れを防ぐ
vim.opt.signcolumn = "yes"

-- 長い行を折り返す
vim.opt.wrap = true

-- カーソル上下に最低 10 行の余白を保つ
vim.opt.scrolloff = 10

-- カーソル左右に最低 10 桁の余白を保つ
vim.opt.sidescrolloff = 10

-- 対応する括弧を一時的に強調表示する
vim.opt.showmatch = true

-- ステータスラインを全ウィンドウで 1 本にまとめる
vim.opt.laststatus = 3

-- 入力中のコマンドを画面下部に表示する
vim.opt.showcmd = true

-- 不可視文字を表示する
vim.opt.list = true

-- タブ、行末スペース、ノーブレークスペースの表示文字を設定する
vim.opt.listchars = { tab = "»·", trail = "·", nbsp = "␣" }

-- タブ入力をスペースに変換する
vim.opt.expandtab = true

-- タブ文字の表示幅を 2 桁にする
vim.opt.tabstop = 2

-- 自動インデントやシフト操作の幅を 2 桁にする
vim.opt.shiftwidth = 2

-- 構文に応じて賢くインデントする
vim.opt.smartindent = true

-- 改行時に前行のインデントを引き継ぐ
vim.opt.autoindent = true

-- 検索時に大文字小文字を区別しない
vim.opt.ignorecase = true

-- 検索語に大文字が含まれる場合は大文字小文字を区別する
vim.opt.smartcase = true

-- 検索結果をハイライトする
vim.opt.hlsearch = true

-- 入力中の検索語に一致する箇所へ逐次移動する
vim.opt.incsearch = true

-- スワップファイルを作成しない
vim.opt.swapfile = false

-- バックアップファイルを作成しない
vim.opt.backup = false

-- アンドゥ履歴をファイルに保存して再起動後も保持する
vim.opt.undofile = true

-- アンドゥ履歴ファイルの保存先を指定する
vim.opt.undodir = vim.fn.stdpath("data") .. "/undo"

-- マウス操作を有効にする
vim.opt.mouse = "a"

-- システムのクリップボードと連携する
vim.opt.clipboard = "unnamedplus"

-- バックスペースでインデント、改行、挿入開始位置を越えて削除できるようにする
vim.opt.backspace = { "indent", "eol", "start" }

-- 横分割を現在ウィンドウの下に開く
vim.opt.splitbelow = true

-- 縦分割を現在ウィンドウの右に開く
vim.opt.splitright = true

-- カーソル停止などのイベント発火までの待ち時間を短くする
vim.opt.updatetime = 250

-- キーマップ入力待ちのタイムアウト時間を 500 ミリ秒にする
vim.opt.timeoutlen = 500

-- 未保存バッファがあっても別バッファへ切り替えられるようにする
vim.opt.hidden = true
