local colors = {
  yellow = '#ECBE7B',
  cyan = '#008080',
  darkblue = '#081633',
  green = '#98be65',
  orange = '#FF8800',
  violet = '#a9a1e1',
  magenta = '#c678dd',
  blue = '#51afef',
  red = '#ec5f67',
  white = '#ffffff',
}

local fileformat_opts = {
  'fileformat',
  icons_enabled = false,
  symbols = { unix = 'LF', dos = 'CRLF', mac = 'CR', },
}
local filename_opts = { 'filename', path = 1, }
local filetype_opts = { 'filetype', icons_enabled = false }
local lsp_name_opts = {
  -- Lsp server name .
  function()
    local msg = 'No Active Lsp'
    local buf_ft = vim.api.nvim_buf_get_option(0, 'filetype')
    local clients = vim.lsp.get_active_clients()
    if next(clients) == nil then
      return msg
    end
    for _, client in ipairs(clients) do
      local filetypes = client.config.filetypes
      if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
        return client.name
      end
    end
    return msg
  end,
  icon = 'LSP:',
  color = { fg = colors.white, gui = 'bold' },
}
local diagnostics_opts = {
  'diagnostics',
  sources = { 'ale', },
  sections = { 'error', 'warn', 'info' },
  symbols = { error = ' ', warn = ' ', info = ' ' },
  diagnostics_color = {
    color_error = { fg = colors.red },
    color_warn = { fg = colors.yellow },
    color_info = { fg = colors.cyan },
  },
}

local config = {
  options = {
    icons_enabled = true,
    theme = 'powerline',
    component_separators = { left = '|', right = '|'},
    section_separators = { left = '|', right = '|'},
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = false,
    globalstatus = false,
    refresh = {
      statusline = 200,
      tabline = 1000,
      winbar = 1000,
    }
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'diff', 'branch'},
    lualine_c = { lsp_name_opts, filename_opts, },
    lualine_x = { 'location', diagnostics_opts, },
    lualine_y = { fileformat_opts, 'encoding', filetype_opts, },
    lualine_z = {'progress',},
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { filename_opts, },
    lualine_x = {'location'},
    lualine_y = { fileformat_opts, 'encoding', filetype_opts, },
    lualine_z = {}
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {}
}

require('lualine').setup(config)
