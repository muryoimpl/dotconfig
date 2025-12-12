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

      require('nvim-test.runners.rspec'):setup({
        command = "bundle",
        file_pattern = "\\v(spec_[^.]+|[^.]+_spec)\\.rb$",
        find_files = { "{name}_spec.rb" },
      })
    end
  },
  -- { 'soramugi/auto-ctags.vim' },
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
  { 'neovim/nvim-lspconfig' },
  { 'arkav/lualine-lsp-progress' },
  {
    'williamboman/mason.nvim',
    build = ':MasonUpdate',
    config = function()
      require('mason').setup({
        ui = {
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
          }
        }
      })
    end
  },
  {
    'williamboman/mason-lspconfig.nvim',
    config = function()
      mason_lspconfig = require('mason-lspconfig').setup({
        -- ensure_installed = { "ts_ls", "eslint", "gopls", },
        ensure_installed = { "ruby_lsp", "rubocop", "gopls"}
      })
    end
  },
  {
    "folke/trouble.nvim",
    opts = {},
    cmd = "Trouble",
    keys = {
      {
        "<space>O",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "Diagnostics (Trouble)",
      },
      {
        "<space>o",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        desc = "Diagnostics in current buffer (Trouble)",
      },
    },
    config = function()
      require("trouble").setup({
        mode = 'document_diagnostics',
        auto_open = false,
        auto_close = true,
        use_diagnostic_signs = true,
      })
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
        providers = {
          'hover.providers.diagnostic',
          'hover.providers.lsp',
          'hover.providers.dap',
          'hover.providers.man',
          'hover.providers.dictionary',
          -- Optional, disabled by default:
          -- 'hover.providers.gh',
          -- 'hover.providers.gh_user',
          -- 'hover.providers.jira',
          -- 'hover.providers.fold_preview',
          -- 'hover.providers.highlight',
        },
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
        signs_staged_enable = true,
        signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
        numhl      = true, -- Toggle with `:Gitsigns toggle_numhl`
        linehl     = false,
        -- word_diff  = true,
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
    build = "make tiktoken",
    dependencies = {
      { "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
      { "nvim-lua/plenary.nvim", branch = "master" }, -- for curl, log wrapper
    },
    config = function ()
      local select = require("CopilotChat.select")

      require("CopilotChat").setup({
        -- Shared config starts here (can be passed to functions at runtime and configured via setup function)
        system_prompt = require('CopilotChat.config').system_prompt,

        model = 'Claude Sonnet 4.5', -- Default model to use, see ':CopilotChatModels' for available models (can be specified manually in prompt via $).
        tools = nil,
        resources = 'selection',
        sticky = nil, -- Default sticky prompt or array of sticky prompts to use at start of every new chat.
        diff = 'block',
        language = '日本語',

        temperature = 0.1, -- GPT result temperature
        headless = false, -- Do not write to chat buffer and use history (useful for using custom processing)
        callback = nil, -- Function called when full response is received (retuned string is stored to history)
        remember_as_sticky = true, -- Remember model/agent/context as sticky prompts when asking questions

        -- default window options
        window = {
          layout = 'vertical', -- 'vertical', 'horizontal', 'float', 'replace', or a function that returns the layout
          width = 0.5, -- fractional width of parent, or absolute width in columns when > 1
          height = 0.5, -- fractional height of parent, or absolute height in rows when > 1
          -- Options below only apply to floating windows
          relative = 'editor', -- 'editor', 'win', 'cursor', 'mouse'
          border = 'single', -- 'none', single', 'double', 'rounded', 'solid', 'shadow'
          row = nil, -- row position of the window, default is centered
          col = nil, -- column position of the window, default is centered
          title = 'Copilot Chat', -- title of chat window
          footer = nil, -- footer of chat window
          zindex = 1, -- determines if window is on top or below other floating windows
        },

        show_help = true, -- Shows help message as virtual lines when waiting for user input
        highlight_selection = true, -- Highlight selection
        highlight_headers = true, -- Highlight headers in chat, disable if using markdown renderers (like render-markdown.nvim)
        references_display = 'virtual', -- 'virtual', 'write', Display references in chat as virtual text or write to buffer
        auto_follow_cursor = true, -- Auto-follow cursor in chat
        auto_insert_mode = false, -- Automatically enter insert mode when opening window and on new prompt
        insert_at_end = false, -- Move cursor to end of buffer when inserting text
        clear_chat_on_new_prompt = false, -- Clears chat on every new prompt

        -- Static config starts here (can be configured only via setup function)

        debug = false, -- Enable debug logging (same as 'log_level = 'debug')
        log_level = 'info', -- Log level to use, 'trace', 'debug', 'info', 'warn', 'error', 'fatal'
        proxy = nil, -- [protocol://]host[:port] Use this proxy
        allow_insecure = false, -- Allow insecure server connections

        selection = 'visual',
        chat_autocomplete = true, -- Enable chat autocompletion (when disabled, requires manual `mappings.complete` trigger)

        log_path = vim.fn.stdpath('state') .. '/CopilotChat.log', -- Default path to log file
        history_path = vim.fn.stdpath('data') .. '/copilotchat_history', -- Default path to stored history

        headers = {
          user = 'User', -- Header to use for user questions
          assistant = 'Copilot', -- Header to use for AI answers
          tool = 'Tool', -- Header to use for tool calls
        },

        separator = '───', -- Separator to use in chat

        -- default providers
        providers = require('CopilotChat.config').providers,

        -- default functions
        functions = require('CopilotChat.config').functions,

        -- default prompts
        -- prompts = require('CopilotChat.config.prompts'),

        -- default mappings
        mappings = require('CopilotChat.config').mappings,
        -- prompts
        -- see config/prompts.lua for implementation
        prompts = {
          Explain = {
            prompt = 'このコードの説明を段落を使って書いてください。',
            system_prompt = 'COPILOT_EXPLAIN',
          },
          Review = {
            prompt = '選択したコードをレビューしてください。',
            system_prompt = 'COPILOT_REVIEW',
          },
          Tests = {
            prompt = 'このコードの詳細な単体テストを書いてください。',
          },
          Fix = {
            prompt = 'このコードには問題があります。バグを修正したコードに書き換えてください。',
          },
          Optimize = {
            prompt = '選択したコードを最適化し、パフォーマンスと可読性を向上させてください。また、実施した最適化の戦略と、変更することによる利点を説明してください。',
          },
          Docs = {
            prompt = '選択したコードのドキュメントを書いてください。回答は、ドキュメントをコメントとして追加した元のコードを含むコードブロックでなければなりません。使用するプログラミング言語に最も適したドキュメントスタイルを使用してください（例：RubyのRDoc、JavaScriptのJSDocなど）',
          },
          Commit = {
            prompt = 'コミットメッセージをコミット規約に従って記述します。タイトルは最大25文字で、メッセージは36文字で折り返す。メッセージ全体をgitcommit言語でコードブロックにまとめでください。',
            context = 'git:staged',
          },
          CommitEn = {
            prompt = 'Write commit message for the change with commitizen convention in English. Make sure the title has maximum 50 characters and message is wrapped at 72 characters. Wrap the whole message in code block with language gitcommit.',
            context = 'git:staged',
          },
        },
      })

      vim.api.nvim_create_autocmd('BufEnter', {
        pattern = 'copilot-*',
        callback = function()
          vim.opt_local.relativenumber = true
        end
      })

      -- copilot window toggle
      vim.keymap.set("n", "<Space>cp", ":CopilotChatToggle<CR>", {desc = "Copilot window toggle"})
    end
  },
  {
    "jackMort/ChatGPT.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "folke/trouble.nvim",
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      local home = vim.fn.expand("$HOME")
      local actions_path = home .. "/.config/nvim/lua/plugins/actions.json"
      -- chatbot
      require("chatgpt").setup({
        openai_params = {
          model = "Claude Sonnet 4.5",
          frequency_penalty = 0,
          presence_penalty = 0,
          max_tokens = 4095,
          temperature = 0.2,
          top_p = 0.1,
          n = 1,
        },
        popup_input = {
          submit = "<C-s>",
        },
        actions_paths = {
          actions_path
        },
      })
    end
  },
  {
    "coder/claudecode.nvim",
    dependencies = {
      "folke/snacks.nvim", -- Required for git operations
    },
    config = true,
    keys = {
      { "<space>c", nil, desc = "AI/Claude Code" },
      { "<space>cc", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
      { "<space>cf", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
      { "<space>cr", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
      { "<space>cC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
      { "<space>cm", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },
      { "<space>cb", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
      { "<space>cs", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
      {
        "<space>cs",
        "<cmd>ClaudeCodeTreeAdd<cr>",
        desc = "Add file",
        ft = { "NvimTree", "neo-tree", "oil", "minifiles", "netrw" },
      },
      -- Diff management
      { "<space>ca", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
      { "<space>cd", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
    },
  },
  {
    "MaximilianLloyd/tw-values.nvim",
  },

  -- telescope
  {
    "nvim-telescope/telescope-file-browser.nvim",
    dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" }
  },

  {
    'nvim-telescope/telescope.nvim', tag = 'v0.1.9',
    dependencies = {
      "nvim-lua/plenary.nvim"
    },
  },

  {
    'nvim-telescope/telescope-ui-select.nvim'
  },

  {
    'rebelot/terminal.nvim',
    config = function()
      require("terminal").setup()

      local term_map = require("terminal.mappings")
      vim.keymap.set({ "n", "t" }, "<space>T", term_map.toggle)
    end
  },
  {
    'mfussenegger/nvim-dap',
    config = function()
      local dap = require('dap')

      vim.keymap.set("n", "<F5>",      function() dap.continue() end,                                                    { silent= true })
      vim.keymap.set("n", "<F10>",     function() dap.step_over() end,                                                   { silent= true })
      vim.keymap.set("n", "<F11>",     function() dap.step_into() end,                                                   { silent= true })
      vim.keymap.set("n", "<F12>",     function() dap.step_out() end,                                                    { silent= true })
      vim.keymap.set("n", "<Space>tb", function() dap.toggle_breakpoint() end,                                           { silent= true })
      vim.keymap.set("n", "<Space>bc", function() dap.set_breakpoint(vim.fn.input('Breakpoint condition: ')) end,        { silent= true })
      vim.keymap.set("n", "<Space>lg", function() dap.set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end, { silent= true })
    end
  },
  {
    'rcarriga/nvim-dap-ui',
    dependencies = { 'mfussenegger/nvim-dap', 'nvim-neotest/nvim-nio' },
    config = function()

      local dapui = require('dapui')
      vim.keymap.set("n", "<Space>du", function() dapui.toggle() end, { silent = true })
      vim.keymap.set("n", "<Space>de", function() dapui.eval() end,   { silent = true })
    end
  },
  {
    'leoluz/nvim-dap-go',
    dependencies = { 'mfussenegger/nvim-dap' },
    config = function()
      local dap_go = require('dap-go')

      dap_go.setup({
        dap_configurations = {
          {
            type = 'go',
            name = 'Debug (Build Flags)',
            request = 'launch',
            program = '${file}',
            args = dap_go.get_arguments,
            buildFlags = dap_go.get_build_flags,
          },
        },
      })

      -- dap-go key map
      vim.keymap.set("n", "<Space>dt", function() dap_go.debug_test() end,  { silent = true })
    end
  }
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

require('plugins.lualine')
require('plugins.telescope')
require('plugins.lsp')
--require('plugins.efm')
require('plugins.null_ls')
require('plugins.cmp')
require('plugins.bqf')
