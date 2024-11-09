---@diagnostic disable:undefined-global

if vim.fn.has('wsl') == 1 then
  vim.g.clipboard = {
    name = 'win32yank-wsl',
    copy = {
       ['+'] = "win32yank.exe -i --crlf",
       ['*'] = "win32yank.exe -i --crlf",
     },
    paste = {
       ['+'] = 'win32yank.exe -o --lf',
       ['*'] = 'win32yank.exe -o --lf',
    },
    cache_enabled = 0
  }
end

require('settings')
require('plugins')

if ( not vim.g.vscode ) then
  require('filetype')
  require('theme')
end

-- colorscheme
vim.opt.background = 'dark'

-- underline
vim.opt.cursorline = true
