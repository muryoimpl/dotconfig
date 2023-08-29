local filetypes = require("formatter.filetypes")

require("formatter").setup({
  filetype = {
    typescript = {
      filetypes.typescript.prettier,
      filetypes.typescript.eslint_d,
    },
    typescriptreact = {
      filetypes.typescriptreact.prettier,
      filetypes.typescriptreact.eslint_d,
    },
    javascript = {
      filetypes.javascript.prettier,
      filetypes.javascript.eslint_d,
    },
    javascriptreact = {
      filetypes.javascriptreact.prettier,
      filetypes.javascriptreact.eslint_d,
    },
    css = {
      filetypes.css.prettier,
    },
    scss = {
      filetypes.css.prettier,
    },
    go = {
      filetypes.go.goimports,
    },
    ruby = {
      filetypes.ruby.rubocop,
    },
    ["*"] = {
      require("formatter.filetypes.any").remove_trailing_whitespace,
    },
  },
})

vim.cmd([[
  augroup FormatAutogroup
    autocmd!
    autocmd BufWritePost * FormatWrite
  augroup END
]])
