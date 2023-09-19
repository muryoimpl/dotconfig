-- LSP efm
--- linter
local eslint = require('efmls-configs.linters.eslint')
local golangci_lint = require('efmls-configs.linters.golangci_lint')
local jq_lint = require('efmls-configs.linters.jq')
local rubocop = require('efmls-configs.linters.rubocop')
local stylelint = require('efmls-configs.linters.stylelint')

--- formatter
local prettier = require('efmls-configs.formatters.prettier')
local jq_fmt = require('efmls-configs.formatters.jq')
local goimports = require('efmls-configs.formatters.goimports')
local eslint_fmt = require('efmls-configs.formatters.eslint')
local stylelint_fmt = {
  formatCommand = 'stylelint --fix --stdin --stdin-filename ${INPUT}',
  formatStdin = true,
}
local ruby_lsp = {
  lintCommand = 'ruby-lsp',
  rootMarkers = {
    "Gemfile",
    ".rubocop.yml"
  },
}
local rubocop_formatter = {
  formatCommand = 'bundle exec rubocop -a -f quiet --stderr --stdin ${INPUT}',
  formatStdin = true,
  rootMarkers = {
    "Gemfile",
    ".rubocop.yml"
  },
}

local languages = {
  css = {
    stylelint,
    stylelint_fmt,
    prettier,
  },
  scss = {
    stylelint,
    stylelint_fmt,
    prettier,
  },
  javascript = {
    eslint,
    prettier,
    eslint_fmt,
  },
  typescript = {
    eslint,
    prettier,
    eslint_fmt,
  },
  json = {
    jq_lint,
    jq_fmt,
  },
  go = {
    golangci_lint,
    goimports,
  },
  ruby = {
    rubocop,
    ruby_lsp,
    rubocop_formatter,
  },
}

local efmls_config = {
  filetypes = vim.tbl_keys(languages),
  settings = {
    rootMarkers = { '.git/' },
    languages = languages,
  },
  init_options = {
    documentFormatting = true,
    documentRangeFormatting = true,
  },
}

local lspconfig = require('lspconfig')
local util = require('lspconfig/util')
---@diagnostic disable:undefined-global
-- https://zenn.dev/botamotch/articles/21073d78bc68bf
-- nvim-lspconfig のキーバインドを設定する
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

  -- print(client.name)
  local lspopts = { noremap = true, silent = true, buffer = ev.buf }
  vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', lspopts)
  vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', lspopts)
  vim.keymap.set('n', 'K',  '<cmd>lua vim.lsp.buf.hover()<CR>', lspopts)
  vim.keymap.set('n', 'gf', '<cmd>lua vim.lsp.buf.format()<CR>', lspopts)
  vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', lspopts)
  vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', lspopts)
  vim.keymap.set('n', 'gt', '<cmd>lua vim.lsp.buf.type_definition()<CR>', lspopts)
  vim.keymap.set('n', 'gn', '<cmd>lua vim.lsp.buf.rename()<CR>', lspopts)
  vim.keymap.set('n', 'ga', '<cmd>lua vim.lsp.buf.code_action()<CR>', lspopts)
  vim.keymap.set('n', 'ge', '<cmd>lua vim.diagnostic.open_float()<CR>', lspopts)
  vim.keymap.set('n', 'g]', '<cmd>lua vim.diagnostic.goto_next()<CR>', lspopts)
  vim.keymap.set('n', 'g[', '<cmd>lua vim.diagnostic.goto_prev()<CR>', lspopts)
  -- vim.keymap.set('n', '<space>o', '<cmd>lua vim.diagnostic.setqflist()<CR>', lspopts)
  vim.keymap.set('n', '<space>t', function()
    vim.lsp.buf.format { async = true }
  end, lspopts)
end

require('lspconfig').efm.setup(vim.tbl_extend('force', efmls_config, { on_attach = on_attach}))
