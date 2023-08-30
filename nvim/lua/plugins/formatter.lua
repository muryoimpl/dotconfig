local filetypes = require("formatter.filetypes")
local util = require("formatter.util")

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
      -- bundle exec rubocop (null-lsのformatterを参考にした)
      -- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/0010ea927ab7c09ef0ce9bf28c2b573fc302f5a7/lua/null-ls/builtins/formatting/rubocop.lua#L15-L26
      function()
        return {
          exe = "bundle",
          args = {
            "exec",
            "rubocop",
            "-a",
            "-f quiet",
            "--stderr",
            "--stdin",
            util.escape_path(util.get_current_buffer_file_path()),
          },
          stdin = true,
        }
      end
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
