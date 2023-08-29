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
