---@diagnostic disable:undefined-global
-- https://github.com/ibhagwan/fzf-lua#commands
-- https://github.com/ibhagwan/fzf-lua#customization
require('fzf-lua').setup({
  winopts = {
    split = "belowright new",
    height = 0.4,
    border = { " ", " ", " ", " ", " ", " ", " ", " " },
  },
  fzf_opts = {
    ['--border'] = 'none',
    ['--layout'] = 'reverse',
  },
  show_cwd_header=true,
  cwd=vim.loop.cwd(),
  grep = {
    glob_flag = "--iglob",
    search = "",
    continue_last_search = true,
  },
  lsp = {
    sync = true,
  },
})

-- keymap
local kopts = { noremap = true, silent = true }
vim.api.nvim_set_keymap('n', '<space>f',  "<CMD>lua require('fzf-lua').files()<CR>",            kopts)
vim.api.nvim_set_keymap('n', '<space>g',  "<CMD>lua require('fzf-lua').git_files()<CR>",        kopts)
vim.api.nvim_set_keymap('n', '<space>B',  "<CMD>lua require('fzf-lua').buffers()<CR>",          kopts)
vim.api.nvim_set_keymap('n', '<space>bl', "<CMD>lua require('fzf-lua').blines()<CR>",           kopts)
vim.api.nvim_set_keymap('n', '<space>gc', "<CMD>lua require('fzf-lua').git_commits()<CR>",      kopts)
vim.api.nvim_set_keymap('n', '<space>h',  "<CMD>lua require('fzf-lua').command_history()<CR>",  kopts)
vim.api.nvim_set_keymap('n', '<space>lr', "<CMD>lua require('fzf-lua').lsp_references()<CR>",   kopts)
vim.api.nvim_set_keymap('n', '<space>ld', "<CMD>lua require('fzf-lua').lsp_definitions()<CR>",  kopts)
vim.api.nvim_set_keymap('n', '<space>gp', "<CMD>lua require('fzf-lua').live_grep()<CR>",        kopts)
vim.api.nvim_set_keymap('n', '<space>gw', "<CMD>lua require('fzf-lua').grep_cword()<CR>",       kopts)
vim.api.nvim_set_keymap('n', '<space>tg', "<CMD>lua require('fzf-lua').tags_grep_cword()<CR>",  kopts)
vim.api.nvim_set_keymap('v', '<space>g',  "<CMD>lua require('fzf-lua').grep_visual()<CR>",      kopts)
vim.api.nvim_set_keymap('v', '<space>tg', "<CMD>lua require('fzf-lua').tags_grep_visual()<CR>", kopts)

-- resize 時に redraw
-- vim.api.nvim_create_autocmd("VimResized", {
--   pattern = '*',
--   command = 'lua require("fzf-lua").redraw()'
-- })
