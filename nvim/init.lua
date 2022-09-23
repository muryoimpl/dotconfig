require('settings')
require('plugins')

-- colorscheme
vim.opt.background='dark'
vim.cmd 'colorscheme hybrid'

-- underline
vim.opt.cursorline=true
vim.cmd 'highlight CursorLine gui=underline cterm=underline'
