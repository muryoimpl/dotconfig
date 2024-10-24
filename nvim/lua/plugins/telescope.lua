local telescope = require("telescope")
local builtin = require('telescope.builtin')
local themes = require("telescope.themes")
local actions = require("telescope.actions")
local telescope_ag = require("telescope-ag")
local fb_actions = require "telescope".extensions.file_browser.actions

local select_dir_for_grep = function(prompt_bufnr)
  local action_state = require("telescope.actions.state")
  local fb = require("telescope").extensions.file_browser
  local live_grep = require("telescope.builtin").live_grep
  local current_line = action_state.get_current_line()

  fb.file_browser({
    files = false,
    depth = false,
    attach_mappings = function(prompt_bufnr)
      actions.select_default:replace(function()
        local entry_path = action_state.get_selected_entry().Path
        local dir = entry_path:is_dir() and entry_path or entry_path:parent()
        local relative = dir:make_relative(vim.fn.getcwd())
        local absolute = dir:absolute()

        live_grep({
          results_title = relative .. "/",
          cwd = absolute,
          default_text = current_line,
        })
      end)

      return true
    end,
  })
end

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
      "--hidden"
    },
    layout_strategy = "cursor",
    mappings = {
      i = {
        ["<C-u>"] = false,
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
        ["<C-c>"] = actions.close,
        ["<C-h>"] = "which_key",
        ["<C-r>"] = actions.to_fuzzy_refine,
      },
      n = {
        ["<C-u>"] = false,
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
        ["<C-c>"] = actions.close,
      },
    },
    file_ignore_patterns = { "^node_modules/", "^.git/", "^vendor/bundle" },
    preview = {
      treesitter = true,
    },
  },
  pickers = {
    find_files                = { theme = "ivy", prompt_prefix="🔍 ",  },
    live_grep                 = {
      theme = "ivy", prompt_prefix="🔍 ",
      mappings = {
        i = {
          ["<C-f>"] = select_dir_for_grep,
        },
        n = {
          ["<C-f>"] = select_dir_for_grep,
        },
      },
    },
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
    buffers                   = {
      theme = "ivy",
      prompt_prefix="🔍 ",
      mappings = {
        i = {
          ["<C-d>"] = actions.delete_buffer,
        },
        n = {
          ["<C-d>"] = actions.delete_buffer,
        },
      },
    },
  },
  extensions = {
    file_browser = {
      theme = "ivy",
      hidden = true,
      no_ignore = true,
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
    aerial = {
      show_nesting = {
        ["_"] = false, -- This key will be the default
        json = true, -- You can set the option for specific filetypes
        yaml = true,
      },
    },
  },
})

local kopts = { noremap = true, silent = true }
local bltin = builtin
vim.keymap.set('n', '<space>ff', function() bltin.find_files()                end, kopts)
vim.keymap.set('n', '<space>bf', function() bltin.buffers()                   end, kopts)
vim.keymap.set('n', '<space>gp', function() bltin.live_grep()                 end, kopts)
vim.keymap.set('n', '<space>gw', function() bltin.grep_string()               end, kopts)
vim.keymap.set('n', '<space>lr', function() bltin.lsp_references()            end, kopts)
vim.keymap.set('n', '<space>ld', function() bltin.lsp_definitions()           end, kopts)
vim.keymap.set('n', '<space>gf', function() bltin.git_files()                 end, kopts)
vim.keymap.set('n', '<space>gc', function() bltin.git_commits()               end, kopts)
vim.keymap.set('n', '<space>bl', function() bltin.current_buffer_fuzzy_find() end, kopts)
vim.keymap.set('n', '<space>hi', function() bltin.command_history()           end, kopts)
vim.keymap.set('n', '<space>qf', function() bltin.quickfix()                  end, kopts)
vim.keymap.set('n', '<space>lc', function() bltin.loclist()                   end, kopts)
vim.keymap.set('n', '<space>au', function() bltin.autocommands()              end, kopts)

-- CopilotChat
vim.keymap.set( -- Show Copilot helps
  "n",
  "<space>ch",
  function()
    local actions = require("CopilotChat.actions")
    require("CopilotChat.integrations.telescope").pick(actions.help_actions())
  end,
  kopts
)
vim.keymap.set( -- Show Copilot actions
  "n",
  "<space>cp",
  function()
    local actions = require("CopilotChat.actions")
    require("CopilotChat.integrations.telescope").pick(actions.prompt_actions())
  end,
  kopts
)

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

-- aerial.nvim
telescope.load_extension("aerial")
vim.keymap.set('n', 'ta<space>', function()
  telescope.extensions.aerial.aerial(themes.get_ivy())
end, kopts)
