---@diagnostic disable:undefined-global
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
  function()
    local msg = 'none'
    local buf_clients = vim.lsp.buf_get_clients()
    if next(buf_clients) == nil then
      return msg
    end

    local buf_ft = vim.api.nvim_buf_get_option(0, 'filetype')

    local buf_client_names = {}

    for _, client in pairs(buf_clients) do
      if client.name ~= "null-ls" then
        table.insert(buf_client_names, client.name)
      end
    end

    local s = require "null-ls.sources"
    local available_sources = s.get_available(buf_ft)
    local registered = {}
    for _, source in ipairs(available_sources) do
      for method in pairs(source.methods) do
        registered[method] = registered[method] or {}
        table.insert(registered[method], source.name)
      end
    end

    local null_ls = require "null-ls"
    vim.list_extend(buf_client_names, registered[null_ls.methods.FORMATTING] or {})
    vim.list_extend(buf_client_names, registered[null_ls.methods.DIAGNOSTICS_ON_SAVE] or {})

    local unique_client_names = vim.fn.uniq(buf_client_names)
    local language_servers = table.concat(unique_client_names, ", ")
    return language_servers
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

local diff_opts = {
  'diff',
  colored = true,
  diff_color = {
    added    = 'DiffAdd',    -- Changes the diff's added color
    modified = 'DiffChange', -- Changes the diff's modified color
    removed  = 'DiffDelete', -- Changes the diff's removed color you
  },
  symbols = {added = '+', modified = '~', removed = '-'}, -- Changes the symbols used by the diff.
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
    lualine_b = { diff_opts, 'branch'},
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
