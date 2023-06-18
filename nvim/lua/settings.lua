---@diagnostic disable:undefined-global
-- 基本的な設定 ---------------------------------------------------------
vim.opt.scrolloff = 5 -- スクロール時の余白確保
vim.opt.hidden = true -- 編集中でも他のファイルを開けるようにする
vim.opt.backspace = { 'indent', 'eol', 'start' } -- バックスペースで何でも消せる
vim.opt.formatoptions = { 'lmoq' } -- テキスト整形オプション、マルチバイト系を追加
vim.opt.browsedir = 'buffer' -- Explorerの初期dir
vim.opt.showcmd = true -- コマンド入力状況表示
vim.opt.showmode = true -- 現在のモードを表示する
vim.opt.number = true -- 行番号を表示
vim.opt.backup = false -- バックアップ/スワップファイルを作成しない。
vim.opt.writebackup = false -- ファイルの上書きの前にバックアップを作らない。
vim.opt.title = true -- タイトルを表示
vim.opt.bomb = false -- BOMを入れない
vim.opt.errorbells = false -- エラーベル無効
vim.opt.shell = 'zsh'
-- ---  検索関連  -------------------------------------------------------
vim.opt.wrapscan = true -- 最後まで検索したら先頭へ
vim.opt.ignorecase = true -- 検索の時に大文字小文字を区別しない。
vim.opt.incsearch = true -- インクリメンタルサーチ
vim.opt.showmatch = true -- 対応する括弧を表示する
vim.opt.hlsearch = true -- 検索の強調表示

-- 全角スペースその他を目立たせる
-- https://gist.github.com/pgtwitter/cb31d497aa02f221164fc2dd846d24dc
vim.cmd([[
  set list
  set listchars=tab:>-,eol:\ ,trail:-

  function! ZenkakuSpace()
    highlight ZenkakuSpace cterm=reverse ctermfg=DarkMagenta gui=reverse guifg=DarkMagenta
  endfunction

  if has('syntax')
      augroup ZenkakuSpace
          autocmd!
          autocmd ColorScheme       * call ZenkakuSpace()
          autocmd VimEnter,WinEnter * match ZenkakuSpace /　/
      augroup END
      call ZenkakuSpace()
  endif
]])

-- 検索のハイライトを消す
vim.api.nvim_set_keymap("n", "<Esc><Esc>", ':set nohlsearch!<CR>', {})

-- 日本語入力設定らしい ------------------------------------------------
vim.opt.imsearch = 0
vim.opt.iminsert = 0
vim.opt.encoding = 'utf-8'
vim.opt.fileencodings = 'utf-8,cp932,euc-jp,iso-2022-jp,ucs-2,latin1'
vim.opt.fileformats = 'unix,dos,mac'

-- 分割の設定
vim.opt.splitright = true
vim.opt.splitbelow = true

-- true color
vim.opt.termguicolors = true

-- gutter系signの表示
vim.opt.signcolumn = "yes"

-- ambiguous width 対応
-- vim.opt.ambiwidth='double'

vim.opt.guifont = 'HackGen Console NF:h12'

-- clipboard
vim.cmd([[
  set clipboard&
  if has("mac")
    set clipboard^=unnamed
  else
    set clipboard^=unnamedplus
  end

  vnoremap <LeftRelease> "*ygv
  vnoremap <2-LeftRelease> "*ygv
]])

-- === 補完 ===================================================
vim.opt.wildmenu = true -- コマンド補完を強化
-- https://github.com/neovim/neovim/issues/18000#issuecomment-1088700694
vim.opt.wildchar = ('<tab>'):byte() -- コマンド補完を開始するキー
vim.opt.wildmode = 'list:full' -- リスト表示, 最長マッチ
vim.opt.history = 1000 -- コマンド・検索パターンの履歴数
vim.opt.complete = vim.opt.complete + { k = true } -- 補完に辞書ファイルを追加

--------  インデント ------------------------------
vim.opt.autoindent = true -- インデントを現在行と同じにする
vim.opt.expandtab = true -- タブの代わりに空白文字を挿入
vim.opt.shiftwidth = 2 -- シフト移動幅は2
vim.opt.smarttab = true -- tabを打ち込むとshiftwidth分だけインデント
vim.opt.smartindent = true -- 高度な自動インデント
vim.opt.tabstop = 2 -- タブの表示を2に
vim.opt.ts = 2 -- タブのスペースを２に
vim.opt.showtabline = 2 -- "タブ表示を常に

-- " swapの作成場所 :echo stdpath('data')
local swpdir = vim.fn.stdpath('data') .. '/tmp'
if vim.fn.empty(vim.fn.glob(swpdir)) > 0 then
  vim.fn.system({ 'mkdir', '-p', swpdir })
end
vim.opt.directory = swpdir
-- " undodir の設定
vim.opt.undofile = true
local undodir = vim.fn.stdpath('data') .. '/undo'
if vim.fn.empty(vim.fn.glob(undodir)) > 0 then
  vim.fn.system({ 'mkdir', '-p', undodir })
end
vim.opt.undodir = undodir

-- " Makefile は tab を tab として入力する
local _filename = vim.fn.expand('%:r')
if _filename == 'Makefile' then
  vim.opt.expandtab = false
end

-- " copen のショートカット
vim.cmd([[
function! ToggleQuickfix()
    let l:nr = winnr('$')
    cwindow
    let l:nr2 = winnr('$')
    if l:nr == l:nr2
        cclose
    endif
endfunction
nnoremap <script> <silent> <Space>o :call ToggleQuickfix()<CR>
]])


-- :T で、terminal を下半分に表示
-- https://zenn.dev/ryo_kawamata/articles/improve-neovmi-terminal
vim.api.nvim_create_user_command(
  'T',
  'split | resize 40 | terminal <args>',
  { nargs = '*' }
)
vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "*",
  command = "setlocal nonumber norelativenumber",
})
vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "*",
  command = "startinsert",
})
vim.api.nvim_set_keymap("n", "<C-W>t", "<cmd>T<cr>", { noremap = true })
vim.api.nvim_set_keymap("n", "<C-W><C-T>", "<cmd>T<cr>", { noremap = true })
vim.api.nvim_set_keymap("t", "<C-W>t", "<cmd>quit<cr>", { noremap = true })
vim.api.nvim_set_keymap("t", "<C-W><C-T>", "<cmd>quit<cr>", { noremap = true })

vim.cmd([[
augroup HighlightTrailingSpaces
  autocmd!
  autocmd VimEnter,WinEnter,ColorScheme * highlight TrailingSpaces term=underline guibg=Red ctermbg=Red
  autocmd VimEnter,WinEnter * match TrailingSpaces /\s\+$/
augroup END
]])
