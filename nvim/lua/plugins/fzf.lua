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
vim.api.nvim_set_keymap('n', '<space>b',  "<CMD>lua require('fzf-lua').buffers()<CR>",          kopts)
vim.api.nvim_set_keymap('n', '<space>gc', "<CMD>lua require('fzf-lua').git_commits()<CR>",      kopts)
vim.api.nvim_set_keymap('n', '<space>h',  "<CMD>lua require('fzf-lua').command_history()<CR>",  kopts)
vim.api.nvim_set_keymap('n', '<space>lr', "<CMD>lua require('fzf-lua').lsp_references()<CR>",   kopts)
vim.api.nvim_set_keymap('n', '<space>ld', "<CMD>lua require('fzf-lua').lsp_definitions()<CR>",  kopts)

-- resize 時に redraw
-- vim.api.nvim_create_autocmd("VimResized", {
--   pattern = '*',
--   command = 'lua require("fzf-lua").redraw()'
-- })
