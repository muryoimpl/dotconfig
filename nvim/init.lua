---@diagnostic disable:undefined-global
require('settings')
require('plugins')
require('filetype')
require('theme')

-- colorscheme
vim.opt.background = 'dark'

-- underline
vim.opt.cursorline = true
vim.cmd 'highlight CursorLine gui=underline cterm=underline'

-- aerial
vim.cmd([[
  hi AerialLineNC gui=reverse cterm=reverse
  hi AerialLine   gui=reverse cterm=reverse
]])
