-- LSP efm
local on_attach = require('plugins.on_attach')
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
    {
      lintCommand = 'ruby-lsp',
      rootMarkers = {
        "Gemfile",
        ".rubocop.yml"
      },
    },
    {
      formatCommand = 'bundle exec rubocop -a -f quiet --stderr --stdin ${INPUT}',
      formatStdin = true,
      rootMarkers = {
        "Gemfile",
        ".rubocop.yml"
      },
    },
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

require('lspconfig').efm.setup(vim.tbl_extend('force', efmls_config, { on_attach = on_attach}))
