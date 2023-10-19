require("aerial").setup({
  -- This can be a filetype map (see :help aerial-filetype-map)
  backends = { "treesitter", "lsp", "markdown", "man" },

  layout = {
    max_width = { 45, 0.25 },
    width = nil,
    min_width = 25,
    -- default_direction = "prefer_right",
    default_direction = "prefer_left",
  },

  -- A list of all symbols to display. Set to false to display all symbols.
  -- This can be a filetype map (see :help aerial-filetype-map)
  -- To see all available values, see :help SymbolKind
  filter_kind = {
    "Class",
    "Constructor",
    "Enum",
    "Function",
    "Interface",
    "Module",
    "Method",
    "Struct",
  },

  autojump = true,

  nerd_font = "auto",

  -- Call this function when aerial attaches to a buffer.
  on_attach = function(bufnr)
    local opts = { buffer = bufnr }
    vim.keymap.set("n", "a<space>", "<cmd>AerialToggle!<CR>", opts)
    vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", opts)
    vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", opts)
  end,

  open_automatic = false,

  -- Run this command after jumping to a symbol (false will disable)
  post_jump_cmd = "normal! zz",

  close_on_select = false,

  update_events = "TextChanged,InsertLeave",

  show_guides = false,

  lsp = {
    diagnostics_trigger_update = true,
    update_when_errors = true,
    update_delay = 200,
  },
  treesitter = {
    update_delay = 200,
    experimental_selection_range = false,
  },
  markdown = {
    update_delay = 200,
  },
  man = {
    update_delay = 200,
  },
})
