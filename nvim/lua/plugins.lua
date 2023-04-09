---@diagnostic disable:undefined-global
-- Download and load if jetpack-vim is not installed.
local fn = vim.fn
local jetpackfile = fn.stdpath('data') .. '/site/pack/jetpack/opt/vim-jetpack/plugin/jetpack.vim'
local jetpackurl = 'https://raw.githubusercontent.com/tani/vim-jetpack/master/plugin/jetpack.vim'
if fn.filereadable(jetpackfile) == 0 then
  fn.system('curl -fsSLo ' .. jetpackfile .. ' --create-dirs ' .. jetpackurl)
end

-- Load plugins with pqcker style
vim.cmd('packadd vim-jetpack')
require('jetpack.packer').startup(function(use)
  use { 'tani/vim-jetpack' }
  use { 'tpope/vim-fugitive' }
  -- use { 'bronson/vim-trailing-whitespace' }
  use { 'justinmk/vim-dirvish' }
  use { 'roginfarrer/vim-dirvish-dovish', ft = 'dirvish' }
  use { 'Yggdroot/indentLine' }

  use { 'nvim-lualine/lualine.nvim' }
  use { 'arkav/lualine-lsp-progress' }

  use { 'ibhagwan/fzf-lua' }
  use { 'kyazdani42/nvim-web-devicons' }

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

  use { 'jose-elias-alvarez/null-ls.nvim' }
  use { "nvim-lua/plenary.nvim" }

  -- function list
  use { 'stevearc/aerial.nvim' }
  use { 'onsails/lspkind-nvim' }

  use { 'NvChad/nvim-colorizer.lua' }

  use { 't9md/vim-quickhl' }

  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
  use { 'nvim-treesitter/playground', }

  use { "folke/trouble.nvim" }

  use { 'lewis6991/gitsigns.nvim' }

  -- theme
  use { 'projekt0n/github-nvim-theme' }
  -- use "rebelot/kanagawa.nvim"

  use { 'terrortylor/nvim-comment' }

  use { 'luukvbaal/nnn.nvim' }

  use { 'ii14/neorepl.nvim', on = ':Repl' }

  use { 'nvim-pack/nvim-spectre' }

  use { 'github/copilot.vim' }
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
  let g:indentLine_fileTypeExclude = ['markdown']
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
    enable = true,
    disable = function(lang, buf)
      -- 特定ファイルのみdisableにする
      if lang == "lua" then
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

  -- playground
  playground = {
    enable = true,
    disable = {},
    updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
    persist_queries = false, -- Whether the query persists across vim sessions
    keybindings = {
      toggle_query_editor = 'o',
      toggle_hl_groups = 'i',
      toggle_injected_languages = 't',
      toggle_anonymous_nodes = 'a',
      toggle_language_display = 'I',
      focus_language = 'f',
      unfocus_language = 'F',
      update = 'R',
      goto_node = '<cr>',
      show_help = '?',
    },
  },
  query_linter = {
    enable = true,
    use_virtual_text = true,
    lint_events = { "BufWrite", "CursorHold" },
  },
})

require("trouble").setup({
  auto_open = true,
  auto_close = true,
})
vim.keymap.set("n", "<space>O", "<cmd>TroubleToggle<cr>",
  { silent = true, noremap = true }
)

-- gitsigns.nvim
require('gitsigns').setup({
  signs      = {
    add          = { hl = 'GitSignsAdd', text = '+', numhl = 'GitSignsAddNr', linehl = 'GitSignsAddLn' },
    change       = { hl = 'GitSignsChange', text = '+', numhl = 'GitSignsChangeNr', linehl = 'GitSignsChangeLn' },
    delete       = { hl = 'GitSignsDelete', text = '_', numhl = 'GitSignsDeleteNr', linehl = 'GitSignsDeleteLn' },
    topdelete    = { hl = 'GitSignsDelete', text = '‾', numhl = 'GitSignsDeleteNr', linehl = 'GitSignsDeleteLn' },
    changedelete = { hl = 'GitSignsChange', text = '~', numhl = 'GitSignsChangeNr', linehl = 'GitSignsChangeLn' },
    untracked    = { hl = 'GitSignsAdd', text = '┆', numhl = 'GitSignsAddNr', linehl = 'GitSignsAddLn' },
  },
  signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
  numhl      = true, -- Toggle with `:Gitsigns toggle_numhl`
  on_attach  = function(bufnr)
    local gs = package.loaded.gitsigns

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    map('n', '<Space>]', function()
      if vim.wo.diff then return '<Space>]' end
      vim.schedule(function() gs.next_hunk() end)
      return '<Ignore>'
    end, { expr = true })

    map('n', '<Space>[', function()
      if vim.wo.diff then return '<Space>[' end
      vim.schedule(function() gs.prev_hunk() end)
      return '<Ignore>'
    end, { expr = true })
  end,
})

-- nvim-comment
require("nvim_comment").setup({
  line_mapping = "<leader>cl",
  operator_mapping = "<leader>c",
})

-- nnn.nvim
local builtin = require("nnn").builtin
require("nnn").setup({
  mappings = {
    { "<C-s>", builtin.open_in_split },     -- open file(s) in split
    { "<C-v>", builtin.open_in_vsplit },    -- open file(s) in vertical split
    { "<C-p>", builtin.open_in_preview },   -- open file in preview split keeping nnn focused
    { "<C-w>", builtin.cd_to_path },        -- cd to file directory
  },
  auto_close = true,
})
vim.keymap.set("n", "<space>n", "<cmd>NnnExplorer<cr>",
  { silent = true, noremap = true }
)
vim.keymap.set("n", "<space>p", "<cmd>NnnPicker<cr>",
  { silent = true, noremap = true }
)

-- nvim-spectre
require('spectre').setup()

vim.keymap.set('n', '<space>S', '<cmd>lua require("spectre").open()<CR>', {
    desc = "Open Spectre"
})
vim.keymap.set('n', '<space>sw', '<cmd>lua require("spectre").open_visual({select_word=true})<CR>', {
    desc = "Search current word"
})
vim.keymap.set('v', '<space>sw', '<esc><cmd>lua require("spectre").open_visual()<CR>', {
    desc = "Search current word"
})
-- vim.keymap.set('n', '<space>sp', '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>', {
--     desc = "Search on current file"
-- })
