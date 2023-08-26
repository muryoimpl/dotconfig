local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end
local packer_bootstrap = ensure_packer()

require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'
  -- theme
  use { 'projekt0n/github-nvim-theme' }

  -- util
  use { "nvim-lua/plenary.nvim" }
  use { 'kyazdani42/nvim-web-devicons' }
  use { 'vim-test/vim-test' }
  use { 'soramugi/auto-ctags.vim' }
  use {
    'Yggdroot/indentLine',
    config = function()
      -- indent
      vim.cmd([[
        " https://github.com/Yggdroot/indentLine#customization
        let g:indentLine_enabled = 1
        let g:indentLine_color_term = 239
        let g:indentLine_char_list = ['|']
        let g:indentLine_fileTypeExclude = ['markdown']
      ]])
    end,
  }
  use {
    'nvim-lualine/lualine.nvim',
    config = function()
      require('plugins/lualine')
    end,
  }
  use {
    'akinsho/bufferline.nvim',
    tag = "*",
    requires = 'nvim-tree/nvim-web-devicons',
    config = function()
      local bufferline = require('bufferline')
      bufferline.setup({
        options = {
          mode = "buffers", -- set to "tabs" to only show tabpages instead
          style_preset = bufferline.style_preset.no_italic, -- bufferline.style_preset.default, -- or bufferline.style_preset.minimal,
          themable = true,
          numbers = "none",
          diagnostics = "nvim_lsp",
          color_icons = true,
          separator_style = "thick", -- "splant" | "slope" | "thick" | "thin" | { 'any', 'any' },
          always_show_bufferline = true,
          diagnostics_indicator = function(count, level)
            local icon = level:match("error") and " " or ""
            return " " .. icon .. count
          end,
          indicator = {
            icon = '▎',
            style = "underline",
          },
          show_tab_indicators = true,
        },
        highlights = {
          buffer_selected = {
            bg = "#494949",
            bold = true,
            italic = false,
          },
          indicator_selected = {
            fg = '#a9a1e1',
            bg = '#a9a1e1',
          },
        },
      })

      local kopts = { silent = true, noremap = true }
      vim.keymap.set('n', '<space>1', function() bufferline.go_to(1,  true); end, kopts)
      vim.keymap.set('n', '<space>2', function() bufferline.go_to(2,  true); end, kopts)
      vim.keymap.set('n', '<space>3', function() bufferline.go_to(3,  true); end, kopts)
      vim.keymap.set('n', '<space>4', function() bufferline.go_to(4,  true); end, kopts)
      vim.keymap.set('n', '<space>5', function() bufferline.go_to(5,  true); end, kopts)
      vim.keymap.set('n', '<space>6', function() bufferline.go_to(6,  true); end, kopts)
      vim.keymap.set('n', '<space>7', function() bufferline.go_to(7,  true); end, kopts)
      vim.keymap.set('n', '<space>8', function() bufferline.go_to(8,  true); end, kopts)
      vim.keymap.set('n', '<space>9', function() bufferline.go_to(9,  true); end, kopts)
      vim.keymap.set('n', '<space>$', function() bufferline.go_to(-1, true); end, kopts)

      vim.keymap.set('n', 'tn', function() bufferline.cycle(1, true);  end, kopts)
      vim.keymap.set('n', 'tp', function() bufferline.cycle(-1, true); end, kopts)
    end
  }

  -- filer
  use {
    'luukvbaal/nnn.nvim' ,
    opt = true,
    keys = { "<space>n", "<space>p" },
    config = function()
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
    end,
  }

  -- lsp
  use { 'arkav/lualine-lsp-progress' }
  use { 'williamboman/mason.nvim' }
  use { 'williamboman/mason-lspconfig.nvim' }
  use { 'neovim/nvim-lspconfig' }
  use {
    "folke/trouble.nvim",
    config = function()
      require("trouble").setup({
        auto_open = true,
        auto_close = true,
        use_diagnostic_signs = true,
      })
      vim.keymap.set("n", "<space>O", "<cmd>TroubleToggle<cr>",
        { silent = true, noremap = true }
      )
    end
  }
  use {
    'adoyle-h/lsp-toggle.nvim',
    opt = true,
    cmd = { 'ToggleLSP', 'ToggleNullLSP' },
    config = function()
      require('lsp-toggle').setup {
        create_cmds = true,
        telescope = true,
      }
    end
  }
  require('plugins/lsp')

  -- completion
  use { 'hrsh7th/nvim-cmp' }
  use { 'hrsh7th/cmp-vsnip' }
  use { 'hrsh7th/vim-vsnip' }
  use { 'hrsh7th/cmp-nvim-lsp' }
  use { 'hrsh7th/cmp-buffer' }
  use {
    'hrsh7th/cmp-cmdline',
    config = function()
      -- cmp-cmdline
      local cmp = require('cmp')
      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),

        sources = {
          { name = 'cmdline' }
        }
      })
    end,
  }

  -- function list
  use {
    'stevearc/aerial.nvim',
    keys = { "<space>a" },
    config = function()
      require('plugins/aerial')
    end,
  }
  use { 'onsails/lspkind-nvim' }

  -- color
  use {
    'NvChad/nvim-colorizer.lua',
    config = function()
      require 'colorizer'.setup()
    end,
  }
  use {
    't9md/vim-quickhl',
    config = function()
      vim.cmd([[
      nmap <Space>m <Plug>(quickhl-manual-this)
      xmap <Space>m <Plug>(quickhl-manual-this)
      nmap <Space>M <Plug>(quickhl-manual-reset)
      xmap <Space>M <Plug>(quickhl-manual-reset)
      ]])
    end,
  }
  use {
    'nvim-treesitter/nvim-treesitter',
    requires = {
      'nvim-treesitter/playground'
    },
    run = ':TSUpdate',
    config = function()
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
    end,
  }

  -- git
  use {
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
  }
  use {
    'lewis6991/gitsigns.nvim',
    config = function()
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
    end,
  }

  -- conding
  use { 'ii14/neorepl.nvim', opt = true, cmd = ':Repl' }
  use {
    'github/copilot.vim',
    config = function()
      -- github/copilit
      vim.cmd([[
      " nodenv の指定: https://rcmdnk.com/blog/2022/09/28/computer-vim/
      function! CheckNodeForCopilot(nodev)
        let l:nodev = split(a:nodev, '\.')[0]
        if stridx(l:nodev, 'v') == 0
          let l:nodev = nodev[1:]
        endif
        return l:nodev > 11 && l:nodev < 18
      endfunction

      let s:nodev = system('node --version')
      if !CheckNodeForCopilot(s:nodev)
        let s:nodev = system('nodenv whence node|sort -n|tail -n1|tr -d "\n"')
        if CheckNodeForCopilot(s:nodev)
          let g:copilot_node_command = "~/.nodenv/versions/" . s:nodev . "/bin/node"
        endif
      endif

      " copilot の候補を表示する
      imap <silent> <M-n> <Plug>(copilot-next)
      imap <silent> <M-p> <Plug>(copilot-previous)
      imap <silent> <S-Tab> <Plug>(copilot-dismiss)
      ]])
    end,
  }
  use {
    "jackMort/ChatGPT.nvim",
    requires = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
    },
    cmd = { "ChatGPT", "ChatGPTEdit" },
    config = function()
      -- chatbot
      require("chatgpt").setup({
        yank_register = "+",
        edit_with_instructions = {
          diff = false,
          keymaps = {
            accept = "<C-y>",
            toggle_diff = "<C-d>",
            toggle_settings = "<C-o>",
            cycle_windows = "<Tab>",
            use_output_as_input = "<C-i>",
          },
        },
        chat = {
          max_line_length = 120,
          keymaps = {
            close = { "<C-c>" },
            yank_last = "<C-y>",
            yank_last_code = "<C-k>",
            scroll_up = "<C-u>",
            scroll_down = "<C-d>",
            toggle_settings = "<C-o>",
            new_session = "<C-n>",
            cycle_windows = "<Tab>",
            select_session = "<Space>",
            rename_session = "r",
            delete_session = "d",
          },
        },
        popup_input = {
          submit = "<C-t>",
        },
        openai_params = {
          model = "gpt-3.5-turbo",
          frequency_penalty = 0,
          presence_penalty = 0,
          max_tokens = 300,
          temperature = 0,
          top_p = 1,
          n = 1,
        },
        openai_edit_params = {
          model = "code-davinci-edit-001",
          temperature = 0,
          top_p = 1,
          n = 1,
        },
      })
    end
  }

  -- telescope
  use {
    "kelly-lin/telescope-ag",
    requires = { "nvim-telescope/telescope.nvim" },
  }
  use {
    "nvim-telescope/telescope-file-browser.nvim",
    requires = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" }
  }

  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.x',
    requires = { {'nvim-lua/plenary.nvim'} },
    config = function()
      local telescope = require("telescope")
      local builtin = require('telescope.builtin')
      local themes = require("telescope.themes")
      local actions = require("telescope.actions")
      local telescope_ag = require("telescope-ag")
      local fb_actions = require "telescope".extensions.file_browser.actions

      telescope.setup({
        defaults = {
          initial_mode = "normal",
          vimgrep_arguments = {
            "ag",
            "--vimgrep",
            "--nocolor",
            "--noheading",
            "--filename",
            "--numbers",
            "--column",
            "--smart-case",
          },
          layout_strategy = "cursor",
          mappings = {
            i = {
              ["<C-u>"] = false,
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
              ["<C-c>"] = actions.close,
              ["<C-h>"] = "which_key"
            },
            n = {
              ["<C-u>"] = false,
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
              ["<C-c>"] = actions.close,
            },
          },
          file_ignore_patterns = { "^node_modules", "^.git" },
          preview = {
            treesitter = true,
          },
        },
        pickers = {
          find_files                = { theme = "ivy", prompt_prefix="🔍 ",  },
          buffers                   = { theme = "ivy", prompt_prefix="🔍 ",  },
          live_grep                 = { theme = "ivy", prompt_prefix="🔍 ",  },
          grep_string               = { theme = "ivy", prompt_prefix="🔍 ",  },
          lsp_references            = { theme = "ivy", prompt_prefix="🔍 ",  },
          lsp_definitions           = { theme = "ivy", prompt_prefix="🔍 ",  },
          git_files                 = { theme = "ivy", prompt_prefix="🔍 ",  },
          git_commits               = { theme = "ivy", prompt_prefix="🔍 ",  },
          current_buffer_fuzzy_find = { theme = "ivy", prompt_prefix="🔍 ",  },
          command_history           = { theme = "ivy", prompt_prefix="🔍 ",  },
          quickfix                  = { theme = "ivy", prompt_prefix="🔍 ",  },
          loclist                   = { theme = "ivy", prompt_prefix="🔍 ",  },
          autocommands              = { theme = "ivy", prompt_prefix="🔍 ",  },
        },
        extensions = {
          file_browser = {
            theme = "ivy",
            hidden = true,
            hijack_netrw = false,
            prompt_prefix="🔍 ",
            mappings = {
              ["i"] = {
                ["<A-c>"] = fb_actions.create,
                ["<S-CR>"] = fb_actions.create_from_prompt,
                ["<A-r>"] = fb_actions.rename,
                ["<A-m>"] = fb_actions.move,
                ["<A-y>"] = fb_actions.copy,
                ["<A-d>"] = fb_actions.remove,
                ["<C-o>"] = fb_actions.open,
                ["<C-g>"] = fb_actions.goto_parent_dir,
                ["<C-e>"] = fb_actions.goto_home_dir,
                ["<C-w>"] = fb_actions.goto_cwd,
                ["<C-t>"] = fb_actions.change_cwd,
                ["<C-f>"] = fb_actions.toggle_browser,
                ["<C-h>"] = fb_actions.toggle_hidden,
                ["<C-s>"] = fb_actions.toggle_all,
                ["<bs>"] = fb_actions.backspace,
              },
              ["n"] = {
                ["c"] = fb_actions.create,
                ["r"] = fb_actions.rename,
                ["m"] = fb_actions.move,
                ["y"] = fb_actions.copy,
                ["d"] = fb_actions.remove,
                ["o"] = fb_actions.open,
                -- ["g"] = fb_actions.goto_parent_dir,
                ["e"] = fb_actions.goto_home_dir,
                ["w"] = fb_actions.goto_cwd,
                ["t"] = fb_actions.change_cwd,
                ["f"] = fb_actions.toggle_browser,
                ["h"] = fb_actions.toggle_hidden,
                ["s"] = fb_actions.toggle_all,
                ["-"] = fb_actions.goto_parent_dir,
              },
            },
          },
        },
      })

      local kopts = { noremap = true, silent = true }
      vim.keymap.set('n', '<space>ff', function() builtin.find_files()                end, kopts)
      vim.keymap.set('n', '<space>bf', function() builtin.buffers()                   end, kopts)
      vim.keymap.set('n', '<space>gp', function() builtin.live_grep()                 end, kopts)
      vim.keymap.set('n', '<space>gw', function() builtin.grep_string()               end, kopts)
      vim.keymap.set('n', '<space>lr', function() builtin.lsp_references()            end, kopts)
      vim.keymap.set('n', '<space>ld', function() builtin.lsp_definitions()           end, kopts)
      vim.keymap.set('n', '<space>gf', function() builtin.git_files()                 end, kopts)
      vim.keymap.set('n', '<space>gc', function() builtin.git_commits()               end, kopts)
      vim.keymap.set('n', '<space>bl', function() builtin.current_buffer_fuzzy_find() end, kopts)
      vim.keymap.set('n', '<space>ch', function() builtin.command_history()           end, kopts)
      vim.keymap.set('n', '<space>qf', function() builtin.quickfix()                  end, kopts)
      vim.keymap.set('n', '<space>lc', function() builtin.loclist()                   end, kopts)
      vim.keymap.set('n', '<space>au', function() builtin.autocommands()              end, kopts)

      -- https://github.com/nvim-telescope/telescope.nvim/issues/1923
      function vim.getVisualSelection()
        vim.cmd('noau normal! "vy"')
        local text = vim.fn.getreg('v')
        vim.fn.setreg('v', {})

        text = string.gsub(text, "\n", "")
        if #text > 0 then
          return text
        else
          return ''
        end
      end

      vim.keymap.set('v', '<space>gp', function()
        local text = vim.getVisualSelection()
        builtin.live_grep(themes.get_ivy({ default_text = text}))
      end, kopts)

      telescope.load_extension('ag')
      telescope_ag.setup({
        cmd = telescope_ag.cmds.ag,
      })

      telescope.load_extension("file_browser")
      vim.api.nvim_set_keymap('n', '<space>fb', ":Telescope file_browser<CR>", kopts)
      vim.api.nvim_set_keymap('n', '-', ":Telescope file_browser path=%:p:h<CR>", kopts)
    end,
  }

  if packer_bootstrap then
    require('packer').sync()
  end
end)

vim.cmd([[
  let files = [
  \  "tags.vim",
  \  "vim-test.vim",
  \]

  for f in files
    exe "source" "~/.config/nvim/lua/plugins/".f
  endfor
]])

