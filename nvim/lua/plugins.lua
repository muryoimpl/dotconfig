-- https://github.com/folme/lazy.nvim#-installation
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  -- theme
  { 'projekt0n/github-nvim-theme' },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      -- add any options here
    },
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
    config = function()
      require('noice').setup({
        messages = { enabled = false },
        popupmenu = { enabled = false },
        notify = { enabled = false },
        lsp = {
          progress = { enabled = true },
          hover = { enabled = false },
          signature = { enabled = false },
          message = { enabled = false },
        },
        views = {
          cmdline_popup = {
            position = { row = "40%", col = "50%" }
          }
        }
      })
    end
  },

  -- util
  { "nvim-lua/plenary.nvim" },
  {
    "szw/vim-maximizer",
    keys = {
      { "<Space>sm", "<cmd>MaximizerToggle<CR>", desc = "Maximize/minimize a split" }
    },
  },
  {
    "klen/nvim-test", config = function()
      require("nvim-test").setup({
        silent = true,
        termOpts = {
          direction = "horizontal",
          stopinsert = false,
        },
      })

      -- vim-test のキーマッピングを継承する
      local t_opts = { noremap = true, silent = true }
      vim.api.nvim_set_keymap('n', '<space>tn', "<cmd>:TestNearest<CR>", t_opts);
      vim.api.nvim_set_keymap('n', '<space>tf', "<cmd>:TestFile<CR>",    t_opts);
      vim.api.nvim_set_keymap('n', '<space>ts', "<cmd>:TestSuite<CR>",   t_opts);
      vim.api.nvim_set_keymap('n', '<space>tl', "<cmd>:TestLast<CR>",    t_opts);
      vim.api.nvim_set_keymap('n', '<space>tg', "<cmd>:TestVisit<CR>",   t_opts);
    end
  },
  { 'soramugi/auto-ctags.vim' },
  {
    'lukas-reineke/indent-blankline.nvim',
    main = "ibl",
    opts = {},
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("ibl").setup({
        indent = {
          char = "│",
          tab_char = "│",
        },
        scope = {
          enabled = true,
          highlight = { "DiffAdd" },
          show_start = false,
        },
      })
    end,
  },
  { 'nvim-lualine/lualine.nvim' },
  { 'AndreM222/copilot-lualine' },
  { 'nvim-tree/nvim-web-devicons' },
  {
    'tomiis4/BufferTabs.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require("buffertabs").setup({
        border = 'single',
        padding = 0,
        display = 'column',
        horizontal = 'right',
        vertical = 'bottom',
      })
    end,
  },
  {
    "sontungexpt/stcursorword",
    event = "VeryLazy",
    config = function()
      require("stcursorword").setup({
        excluded = {
          buftypes = {
            "terminal",
          },
        },
        highlight = {
          underline = false,
          fg = "#ffffff",
          bg = "#5055F9",
        },
      })
    end,
  },
  {
    'stevearc/aerial.nvim',
    opts = {},
    -- Optional dependencies
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons"
    },
  },
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("todo-comments").setup({
        signs = false,
      })

      vim.keymap.set("n", "<space>td", "<cmd>TodoTelescope<cr>",
        { silent = true, noremap = true }
      )
    end,
  },
  {
    'numToStr/Comment.nvim',
    lazy = false,
    config = function()
      require('Comment').setup({
        ---Add a space b/w comment and the line
        padding = true,
        ---Whether the cursor should stay at its position
        sticky = true,
        ---Lines to be ignored while (un)comment
        ignore = nil,
        ---LHS of toggle mappings in NORMAL mode
        toggler = {
            ---Line-comment toggle keymap
            line = 'gcc',
            ---Block-comment toggle keymap
            block = 'gbc',
        },
        ---LHS of operator-pending mappings in NORMAL and VISUAL mode
        opleader = {
            ---Line-comment keymap
            line = 'gc',
            ---Block-comment keymap
            block = 'gb',
        },
        ---LHS of extra mappings
        extra = {
            ---Add comment on the line above
            above = 'gcO',
            ---Add comment on the line below
            below = 'gco',
            ---Add comment at the end of line
            eol = 'gcA',
        },
        ---Enable keybindings
        ---NOTE: If given `false` then the plugin won't create any mappings
        mappings = {
            ---Operator-pending mapping; `gcc` `gbc` `gc[count]{motion}` `gb[count]{motion}`
            basic = true,
            ---Extra mapping; `gco`, `gcO`, `gcA`
            extra = true,
        },
        ---Function to call before (un)comment
        pre_hook = nil,
        ---Function to call after (un)comment
        post_hook = nil,
      })
    end,
  },
  {
    'cappyzawa/trim.nvim',
    config = function()
      require('trim').setup({
        trim_on_write = true,
        highlight = true
      })
    end
  },
  {
    'kevinhwang91/nvim-bqf',
    ft = 'qf'
  },

  -- lsp
  { 'arkav/lualine-lsp-progress' },
  {
    'williamboman/mason.nvim',
    build = ':MasonUpdate',
  },
  { 'williamboman/mason-lspconfig.nvim' },
  {
    'neovim/nvim-lspconfig',
    event = { "BufReadPre", "BufNewFile" },
  },
  {
    "folke/trouble.nvim",
    config = function()
      require("trouble").setup({
        mode = 'document_diagnostics',
        auto_open = false,
        auto_close = true,
        use_diagnostic_signs = true,
      })
      vim.keymap.set("n", "<space>O", "<cmd>Trouble diagnostics toggle<cr>",
        { silent = true, noremap = true }
      )
    end
  },
  {
    'adoyle-h/lsp-toggle.nvim',
    lazy = true,
    cmd = { 'ToggleLSP', 'ToggleNullLSP' },
    config = function()
      require('lsp-toggle').setup {
        create_cmds = true,
        telescope = true,
      }
    end
  },
  {
    "lewis6991/hover.nvim",
    config = function()
      require("hover").setup({
        init = function()
          require("hover.providers.lsp")
        end,
        preview_opts = {
          border = nil,
        },
        preview_window = false,
        title = true,
      })

      -- Setup keymaps
      vim.keymap.set("n", "K", require("hover").hover, {desc = "hover.nvim"})
      vim.keymap.set("n", "gK", require("hover").hover_select, {desc = "hover.nvim (select)"})
    end
  },
-- { -- 使う際は Mason から efm を再インストールすること
--   'creativenull/efmls-configs-nvim',
--   version = 'v1.x.x', -- version is optional, but recommended
--   dependencies = { 'neovim/nvim-lspconfig' },
-- },
  {
    'nvimtools/none-ls.nvim',
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvimtools/none-ls-extras.nvim",
    },
  },

  -- completion
  { 'hrsh7th/cmp-vsnip' },
  { 'hrsh7th/vim-vsnip' },
  { 'hrsh7th/vim-vsnip-integ' },
  { 'hrsh7th/cmp-nvim-lsp' },
  { 'hrsh7th/cmp-buffer' },
  { 'hrsh7th/cmp-cmdline' },
  { 'hrsh7th/cmp-path' },
  { 'hrsh7th/nvim-cmp' },

  -- function list
  { 'onsails/lspkind-nvim' },

  -- color
  {
    'NvChad/nvim-colorizer.lua',
    config = function()
      require 'colorizer'.setup()
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter.configs').setup({
        sync_install = false,
        auto_install = true,
        indent = { enable = false },
        highlight = {
          enable = true,
          disable = function(lang, buf)
            -- 特定ファイルのみdisableにする
            -- if lang == "lua" then
            --   return true
            -- end

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
        autotag = { enable = true },
        ensure_installed = {
          "bash",
          "c",
          "cpp",
          "css",
          "csv",
          "dockerfile",
          "go",
          "html",
          "javascript",
          "json",
          "lua",
          "python",
          "ruby",
          "rust",
          "typescript",
          "yaml",
          "sql",
          "markdown",
          "markdown_inline",
          "typescript",
        },
      })
    end,
  },

  -- git
  {
    'tpope/vim-fugitive',
    keys = { "<space>gb" },
    config = function()
      vim.cmd([[
        nnoremap <Space>gd :<C-u>Gdiff<Enter>
        nnoremap <Space>gs :<C-u>Git<Enter>
        nnoremap <Space>gl :<C-u>Gclog<Enter>
        nnoremap <Space>ga :<C-u>Gwrite<Enter>
        nnoremap <Space>gb :<C-u>Git blame<Enter>
      ]])
    end,
  },
  {
    'lewis6991/gitsigns.nvim',
    config = function()
      -- gitsigns.nvim
      require('gitsigns').setup({
        signs      = {
          add          = {  text = '+',  },
          change       = {  text = '+',  },
          delete       = {  text = '_',  },
          topdelete    = {  text = '‾',  },
          changedelete = {  text = '~',  },
          untracked    = {  text = '┆',  },
        },
        signs_staged = {
          add          = {  text = '+',  },
          change       = {  text = '+',  },
          delete       = {  text = '_',  },
          topdelete    = {  text = '‾',  },
          changedelete = {  text = '~',  },
          untracked    = {  text = '┆',  },
        },
        signs_staged_enabled = true,
        signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
        numhl      = true, -- Toggle with `:Gitsigns toggle_numhl`
        linehl     = false,
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
    end,
  },
  {
    "yutkat/git-rebase-auto-diff.nvim",
    ft = { "gitrebase" },
    config = function()
      require("git-rebase-auto-diff").setup()
    end,
  },

  -- coding
  {
    "zbirenbaum/copilot.lua",
    cmd = { "Copilot" },
    event = { "InsertEnter", "LspAttach" },
    config = function()
      require("copilot").setup({
        suggestion = { enabled = false },
        panel = { enabled = false },
      })
    end,
  },
  {
    "zbirenbaum/copilot-cmp",
    config = function ()
      require("copilot_cmp").setup()
    end
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "main",
    build = "make tiktoken",
    dependencies = {
      { "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
      { "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
    },
    config = function ()
      local prompts = require("CopilotChat")
      local select = require('CopilotChat.select')

      prompts.setup({
        -- See Configuration section for rest
        debug = true, -- Enable debug logging

        system_prompt = prompts.COPILOT_INSTRUCTIONS, -- System prompt to use
        model = 'gpt-4o-mini', -- GPT model to use, 'gpt-4o' or 'gpt-4o-mini'
        temperature = 0.1, -- GPT temperature

        auto_follow_cursor = true, -- Auto-follow cursor in chat
        clear_chat_on_new_prompt = false, -- Clears chat on every new prompt

        history_path = vim.fn.stdpath('data') .. '/copilotchat_history', -- Default path to stored history

        -- default prompts
        prompts = {
          Explain = {
            prompt = '/COPILOT_EXPLAIN 上記のコードの説明を段落を使って書いてください。',
          },
          Tests = {
            prompt = '/COPILOT_TESTS 上記のコードの詳細な単体テストを書いてください。',
          },
          Fix = {
            prompt = '/COPILOT_FIX このコードには問題があります。バグを修正したコードに書き換えてください。',
          },
          Optimize = {
            prompt = '/COPILOT_REFACTOR 選択したコードを最適化し、パフォーマンスと可読性を向上させてください。',
          },
          Docs = {
            prompt = '/COPILOT_REFACTOR 選択したコードのドキュメントを書いてください。回答は、ドキュメントをコメントとして追加した元のコードを含むコードブロックでなければなりません。使用するプログラミング言語に最も適したドキュメントスタイルを使用してください（例：RubyのRDoc、JavaScriptのJSDocなど）',
          },
          FixDiagnostic = {
            prompt = '以下にある、このファイルに関するdiagnosticの問題を解決してください:',
            selection = select.diagnostics,
          },
          Commit = {
            prompt = 'コミットメッセージをコミット規約に従って記述します。タイトルは最大25文字で、メッセージは36文字で折り返す。メッセージ全体をgitcommit言語でコードブロックにまとめでください。',
            selection = select.gitdiff,
          },
          CommitStaged = {
            prompt = 'コミットメッセージをコミット規約に従って記述します。タイトルは最大25文字で、メッセージは36文字で折り返す。メッセージ全体をgitcommit言語でコードブロックにまとめでください。',
            selection = function(source)
              return select.gitdiff(source, true)
            end,
          },
          CommitStagedEn = {
            prompt = 'Write commit message for the change with commitizen convention in English. Make sure the title has maximum 50 characters and message is wrapped at 72 characters. Wrap the whole message in code block with language gitcommit.',
            selection = function(source)
              return select.gitdiff(source, true)
            end,
          },
        },
      })

      vim.api.nvim_create_autocmd('BufEnter', {
        pattern = 'copilot-*',
        callback = function()
          vim.opt_local.relativenumber = true
        end
      })
    end
  },
  {
    "jackMort/ChatGPT.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "folke/trouble.nvim",
      "nvim-telescope/telescope.nvim",
    },
    cmd = { "ChatGPT", "ChatGPTEdit" },
    config = function()
      -- chatbot
      require("chatgpt").setup({
        popup_input = {
          submit = "<C-t>",
        },
        openai_params = {
          model = "gpt-4o-mini"
        },
      })
    end
  },
  {
    "MaximilianLloyd/tw-values.nvim",
  },

  -- telescope
  {
    "kelly-lin/telescope-ag",
    dependencies = { "nvim-telescope/telescope.nvim" },
  },
  {
    "nvim-telescope/telescope-file-browser.nvim",
    dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" }
  },

  {
    'nvim-telescope/telescope.nvim', tag = '0.1.8', branch = '0.1.x',
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
  },

  {
    'uga-rosa/ugaterm.nvim',
    config = function()
      require('ugaterm').setup({
        open_cmd = function()
          local height = vim.api.nvim_get_option("lines")
          local width = vim.api.nvim_get_option("columns")
          vim.api.nvim_open_win(0, true, {
            win = 0,
            split = 'below',
          })
        end
      })

      vim.api.nvim_set_keymap("n", "<space>T", "<cmd>UgatermOpen -toggle<CR>", { noremap = true })
      vim.api.nvim_set_keymap("t", "<space>T", "<cmd>UgatermOpen -toggle<CR>", { noremap = true })
    end
  },
},
{
  ui = {
    icons = {
      cmd = "⌘",
      config = "🛠",
      event = "📅",
      ft = "📂",
      init = "⚙",
      keys = "🗝",
      plugin = "🔌",
      runtime = "💻",
      source = "📄",
      start = "🚀",
      task = "📌",
      lazy = "💤 ",
    },
  },
})

vim.cmd([[
  let files = [
  \  "tags.vim",
  \]

  for f in files
    exe "source" "~/.config/nvim/lua/plugins/".f
  endfor
]])

-- aerial
vim.cmd([[
  hi AerialLineNC gui=reverse cterm=reverse
  hi AerialLine   gui=reverse cterm=reverse
]])

require('plugins.lualine')
require('plugins.telescope')
require('plugins.lsp')
--require('plugins.efm')
require('plugins.null_ls')
require('plugins.cmp')
require('plugins.aerial')
require('plugins.bqf')
