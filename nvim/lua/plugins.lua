-- Download and load if jetpack-vim is not installed.
local fn = vim.fn
local jetpackfile = fn.stdpath('data') .. '/site/pack/jetpack/opt/vim-jetpack/plugin/jetpack.vim'
local jetpackurl = 'https://raw.githubusercontent.com/tani/vim-jetpack/master/plugin/jetpack.vim'
if fn.filereadable(jetpackfile) == 0 then
  fn.system('curl -fsSLo ' .. jetpackfile .. ' --create-dirs ' .. jetpackurl)
end

-- Load plugins with pqcker style
vim.cmd('packadd vim-jetpack')
require('jetpack').startup(function (use)
  use { 'tani/vim-jetpack', opt = 1 }
  use {'w0ng/vim-hybrid', }
  use { 'tpope/vim-fugitive' }
  use { 'itchyny/lightline.vim' }
  use { 'airblade/vim-gitgutter' }
  use { 'bronson/vim-trailing-whitespace' }
  use { 'nvim-treesitter/nvim-treesitter' }
  use { 'justinmk/vim-dirvish' }
  use { 'Yggdroot/indentLine' }
  use { 'junegunn/fzf', run = 'fzf#install()' }
  use { 'junegunn/fzf.vim' }

  use { 'dense-analysis/ale' }
  use { 'vim-test/vim-test' }
end)

-- Install plugins if they are not installed.
vim.cmd([[
  for name in jetpack#names()
    if !jetpack#tap(name)
      call jetpack#sync()
      break
    endif
  endfor
]])

vim.cmd([[
  source ~/.config/nvim/lua/plugins/fugitive.vim
  source ~/.config/nvim/lua/plugins/fzf.vim
  source ~/.config/nvim/lua/plugins/gitgutter.vim
  source ~/.config/nvim/lua/plugins/lightline.vim
  source ~/.config/nvim/lua/plugins/ale.vim
]])

-- whitespace
vim.cmd([[
  let g:extra_whitespace_ignored_filetypes = ['mkd']
  let g:strip_whitespace_on_save = 1
]])

-- dirvish
vim.cmd([[
  let g:dirvish_mode = ':sort ,^\v(.*[\/])|\ze,'
]])

-- indent
vim.cmd([[
  " https://github.com/Yggdroot/indentLine#customization
  let g:indentLine_enabled = 1
  let g:indentLine_color_term = 239
  let g:indentLine_char_list = ['|']
]])

-- tags
vim.cmd([[
  set tags=./.tags,.tags
  set tags+=./ruby.tags,ruby.tags
  set tags+=./go.tags,go.tags
  set tags+=./typescript.tags,typescript.tags
  set tags+=./typescriptreact.tags,typescriptreact.tags
  set tags+=./javascript.tags,javascript.tags
  set tags+=./javascriptreact.tags,javascriptreact.tags

  "飛ぶ
  nnoremap tt  <C-]>
  "「進む」
  nnoremap tj  :tag<Return>
  "「戻る」
  nnoremap tk  :pop<Return>
  "履歴一覧
  nnoremap tl  :tags<Return>
]])

-- vim-test
vim.cmd([[
  " these "Ctrl mappings" work well when Caps Lock is mapped to Ctrl
  nmap <silent> t<C-n> :TestNearest<CR>
  nmap <silent> t<C-f> :TestFile<CR>
  nmap <silent> t<C-s> :TestSuite<CR>
  nmap <silent> t<C-l> :TestLast<CR>
  nmap <silent> t<C-g> :TestVisit<CR>

  let g:test#preserve_screen = 1
  let test#strategy = 'neovim'
]])
