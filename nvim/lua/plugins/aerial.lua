require('aerial').setup({
  layout = {
    -- These control the width of the aerial window.
    -- They can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
    -- min_width and max_width can be a list of mixed types.
    -- max_width = {40, 0.2} means "the lesser of 40 columns or 20% of total"
    max_width = { 50, 0.4 },
    width = nil,
    min_width = 10,

    -- Determines the default direction to open the aerial window. The 'prefer'
    -- options will open the window in the other direction *if* there is a
    -- different buffer in the way of the preferred direction
    -- Enum: prefer_right, prefer_left, right, left, float
    default_direction = "prefer_right",

    -- Determines where the aerial window will be opened
    --   edge   - open aerial at the far right/left of the editor
    --   window - open aerial to the right/left of the current window
    placement = "window",
  },

  backends = {
    ['_'] = {"treesitter", "lsp"},
  },

  lsp = {
    -- Fetch document symbols when LSP diagnostics update.
    -- If false, will update on buffer changes.
    diagnostics_trigger_update = true,

    -- Set to false to not update the symbols when there are LSP errors
    update_when_errors = true,

    -- How long to wait (in ms) after a buffer change before updating
    -- Only used when diagnostics_trigger_update = false
    update_delay = 500,
  },

  treesitter = {
    -- How long to wait (in ms) after a buffer change before updating
    update_delay = 500,
  },
})

vim.keymap.set('n', '<Space>a', '<cmd>AerialToggle!<CR>', {})
vim.keymap.set('n', '{', '<cmd>AerialPrev<CR>', {})
vim.keymap.set('n', '}', '<cmd>AerialNext<CR>', {})
vim.keymap.set('n', '[[', '<cmd>AerialPrevUp<CR>', {})
vim.keymap.set('n', ']]', '<cmd>AerialNextUp<CR>', {})
