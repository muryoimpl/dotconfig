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
        ensure_installed = { "ruby_lsp", "rubocop", "gopls"},
        automatic_enable = {
          exclude = { "cspell_ls" },
        },
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
    lazy = false,
    config = function()
      require('nvim-treesitter').setup({
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
          "markdown",
          "markdown_inline",
          "python",
          "rbs",
          "regex",
          "ruby",
          "rust",
          "sql",
          "tmux",
          "toml",
          "typescript",
          "yaml",
        },
      })
    end,
  },

  -- git
  {
    'tpope/vim-fugitive',
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
      -- copilot-cmp は self.client.is_stopped() という deprecated 呼び出しを
      -- 残しているため、is_available をメソッド呼び出し形式に差し替える
      local source = require("copilot_cmp.source")
      source.is_available = function(self)
        if not self.client or self.client:is_stopped() or self.client.name ~= "copilot" then
          return false
        end
        return next(vim.lsp.get_clients({
          bufnr = vim.api.nvim_get_current_buf(),
          id = self.client.id,
        })) ~= nil
      end
    end
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
  },
  {
      'MeanderingProgrammer/render-markdown.nvim',
      dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
      ---@module 'render-markdown'
      ---@type render.md.UserConfig
      opts = {},
      config = function()
        vim.keymap.set("n", "<space>mk", function() require('render-markdown').toggle() end,  { silent = true })
      end
  },
  {
    'muryoimpl/daily-memo',
    config = function()
      require("daily-memo").setup({
        base_dir = "~/local/memo",
        placeholders = {
          week = function(date) return os.date('%W', os.time(date)) end,
          wday = function(date)
            local names = { "Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat" }
            return names[date.wday]
          end,
          wday_ja = function(date)
            local names = { "日", "月", "火", "水", "木", "金", "土" }
            return names[date.wday]
          end,
        },
        templates = {
          default = "# {{date}}({{wday}}): 第 {{week}} 週\n\n## TODO\n\n- \n\n## MEMO\n",
          work = table.concat({
            "# {{yyyymmdd}}({{wday_ja}}): 第 {{week}} 週",
            "",
            "## 日報",
            "",
            "```",
            "{{date_ja}}",
            "- やったこと",
            "  - ",
            "  -",
            "- やること",
            "  - ",
            "- 詰まっていること・気づき",
            "  - ",
            "- 一言コメント",
            "  - ",
            "",
            "",
            "```",
            "",
            "## TODO",
            "- [] ",
            "",
            "## その他",
            "",
          }, "\n"),
        }
      })
      vim.keymap.set("n", "<space>dm", function() require("daily-memo").open() end, {})
      vim.keymap.set("n", "<space>dw", "<cmd>DailyMemo work<CR>", { desc = "Open daily memo (work template)" } )

      -- topic ファイルを作成する
      vim.keymap.set("n", "<space>dT", function() require("daily-memo").prompt_topic() end, { desc = "DailyMemo: open topic" })
    end,
  },
  {
    "vim-test/vim-test",
    keys = {
      { "<space>tn", "<cmd>TestNearest<cr>" },
      { "<space>tf", "<cmd>TestFile<cr>" },
      { "<space>ts", "<cmd>TestSuite<cr>" },
      { "<space>tl", "<cmd>TestLast<cr>" },
    },
    init = function()
      vim.g["test#preserve_screen"] = 1
      vim.g["test#strategy"] = "neovim_sticky"
      vim.g["test#neovim#term_position"] = "botright 15"

      vim.g["test#go#runner"] = "delve"

      -- vim.g["test#ruby#rspec#executable"] = "docker compose run --rm web bundle exec rspec"
      vim.g["test#ruby#rspec#options"] = {
        all = "--backtrace",
        suite = "--tag ~slow",
      }
    end,
  },
  {
    "muryoimpl/git-utils.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
      vim.keymap.set("n", "<space>fw", "<cmd>Telescope git_utils worktrees<cr>", {
        desc = "Git worktrees",
      })
    end,
  }
-- {
--   'rcarriga/nvim-notify',
--   config = function()
--     vim.notify = require("notify")
--   end
-- }
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
