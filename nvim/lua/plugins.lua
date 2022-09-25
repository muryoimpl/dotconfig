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

  use { 'ibhagwan/fzf-lua' }
  use { 'kyazdani42/nvim-web-devicons' }

  use { 'dense-analysis/ale' }
  use { 'vim-test/vim-test' }

  use { 'soramugi/auto-ctags.vim' }

  -- lsp
  use { 'neovim/nvim-lspconfig' }
  use { 'williamboman/mason.nvim' }
  use { 'williamboman/mason-lspconfig.nvim' }

  use { 'hrsh7th/nvim-cmp' }
  use { 'hrsh7th/cmp-vsnip' }
  use { 'hrsh7th/vim-vsnip' }
  use { 'hrsh7th/cmp-nvim-lsp' }
  use { 'hrsh7th/cmp-buffer' }
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
  let files = [
  \  "fugitive.vim",
  \  "gitgutter.vim",
  \  "lightline.vim",
  \  "ale.vim",
  \  "tags.vim",
  \  "vim-test.vim",
  \]

  for f in files
    exe "source" "~/.config/nvim/lua/plugins/".f
  endfor
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

-- LSP
require('plugins/lsp')
-- fzf
require('plugins/fzf')
