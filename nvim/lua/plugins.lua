-- Download and load if jetpack-vim is not installed.
local fn = vim.fn
local jetpackfile = fn.stdpath('data') .. '/site/pack/jetpack/opt/vim-jetpack/plugin/jetpack.vim'
local jetpackurl = 'https://raw.githubusercontent.com/tani/vim-jetpack/master/plugin/jetpack.vim'
if fn.filereadable(jetpackfile) == 0 then
  fn.system('curl -fsSLo ' .. jetpackfile .. ' --create-dirs ' .. jetpackurl)
end

-- Load plugins with pqcker style
vim.cmd('packadd vim-jetpack')
require('jetpack.packer').startup(function (use)
  use { 'tani/vim-jetpack', opt = 1 }
  use { 'tpope/vim-fugitive' }
  use { 'airblade/vim-gitgutter' }
  use { 'bronson/vim-trailing-whitespace' }
  use { 'justinmk/vim-dirvish' }
  use { 'roginfarrer/vim-dirvish-dovish', ft = 'dirvish' }
  use { 'Yggdroot/indentLine' }

  use { 'nvim-lualine/lualine.nvim' }
  use { 'arkav/lualine-lsp-progress' }

  use { 'ibhagwan/fzf-lua' }
  use { 'kyazdani42/nvim-web-devicons' }

  use { 'dense-analysis/ale' }
  use { 'vim-test/vim-test' }

  use { 'soramugi/auto-ctags.vim' }

  -- lsp
  use { 'williamboman/mason.nvim' }
  use { 'williamboman/mason-lspconfig.nvim' }
  use { 'neovim/nvim-lspconfig' }

  use { 'hrsh7th/nvim-cmp' }
  use { 'hrsh7th/cmp-vsnip' }
  use { 'hrsh7th/vim-vsnip' }
  use { 'hrsh7th/cmp-nvim-lsp' }
  use { 'hrsh7th/cmp-buffer' }
  use { 'hrsh7th/cmp-cmdline' }

  -- function list
  use { 'stevearc/aerial.nvim' }
  use { 'onsails/lspkind-nvim' }

  use { 'NvChad/nvim-colorizer.lua' }

  use { 't9md/vim-quickhl' }

  use ({ 'projekt0n/github-nvim-theme' })
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
  \  "tags.vim",
  \  "vim-test.vim",
  \]
  "lightline.vim",
  "\  "ale.vim",

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

-- lualine
require('plugins/lualine')
-- aerial
require('plugins/aerial')
-- LSP
require('plugins/lsp')
-- fzf
require('plugins/fzf')

-- colorizer
require 'colorizer'.setup()

-- quickhl
vim.cmd([[
nmap <Space>m <Plug>(quickhl-manual-this)
xmap <Space>m <Plug>(quickhl-manual-this)
nmap <Space>M <Plug>(quickhl-manual-reset)
xmap <Space>M <Plug>(quickhl-manual-reset)
]])

-- cmp-cmdline
local cmp = require('cmp')
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),

  sources = {
    { name = 'cmdline' }
  }
})

-- nvim-treesitter
require('nvim-treesitter.configs').setup({
  sync_install = true,
  auto_install = true,
  highlight = {
    enable= true,
    disable = function(lang, buf)
      -- 特定ファイルのみdisableにする
      if lang == "ruby" or lang == "eruby" then
        return true
      end

      -- サイズ制限
      local max_filesize = 100 * 1024 -- 100 KB
      local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
      if ok and stats and stats.size > max_filesize then
        return true
      end
    end,
  },
  incremental_selection = { enable = true },
  textobjects = { enable = true },
})

require("github-theme").setup({
  theme_style = "dark_default",
 -- -- Overwrite the highlight groups
  overrides = function(c)
    return {
      Type = { fg = '#dc143c' },
    }
  end
})
