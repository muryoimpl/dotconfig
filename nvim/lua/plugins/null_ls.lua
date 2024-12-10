local null_ls = require('null-ls')
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
null_ls.setup({
  sources = {
    null_ls.builtins.diagnostics.rubocop.with({
      diagnostic_config = {
        virtual_text = false,
      },
      command = 'bundle',
      args = vim.list_extend({ 'exec', 'rubocop' }, null_ls.builtins.diagnostics.rubocop._opts.args),
      condition = function(utils)
        return utils.root_has_file({".rubocop.yml"})
      end
    }),

    require("none-ls.diagnostics.eslint").with({
      command = 'yarn',
      args = { 'eslint', '-f', 'json', '--stdin', '--stdin-filename', '$FILENAME' },
      diagnostic_config = {
        virtual_text = false,
      },
      condition = function(utils)
        return utils.root_has_file({".eslintrc.js", ".eslintrc.yml"})
      end,
    }),

    null_ls.builtins.diagnostics.golangci_lint,

    null_ls.builtins.formatting.rubocop.with({
      command = "bundle",
      args = vim.list_extend({ 'exec', 'rubocop' }, null_ls.builtins.formatting.rubocop._opts.args),
      condition = function(utils)
        return utils.root_has_file({".rubocop.yml"})
      end
    }),

    require("none-ls.formatting.eslint").with({
      command = 'yarn',
      args = { "eslint", "--fix-dry-run", "--format", "json", "--stdin", "--stdin-filename", "$FILENAME" },
      condition = function(utils)
        return utils.root_has_file({".eslintrc.js", ".eslintrc.yml"})
      end,
    }),
    null_ls.builtins.formatting.goimports,

    null_ls.builtins.diagnostics.textlint.with({
      command = "npx",
      args = vim.list_extend(
               { 'textlint' },
               null_ls.builtins.diagnostics.textlint._opts.args),
      diagnostic_config = {
        virtual_text = false,
      }
    }),
    null_ls.builtins.formatting.textlint.with({
      command = 'npx',
      args = vim.list_extend(
               { 'textlint' },
               null_ls.builtins.formatting.textlint._opts.args),
      diagnostic_config = {
        virtual_text = false,
      },
    }),
  },
  auto_open = true,
  auto_preview = true,
  -- you can reuse a shared lspconfig on_attach callback here
  on_attach = function(client, bufnr)
    if client.supports_method("textDocument/formatting") then
      vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup,
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format({
            bufnr = bufnr,
            timeout_ms = 5000,
          })
        end,
      })
    end
  end,
})
