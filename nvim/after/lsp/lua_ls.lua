---@type vim.lsp.Config
return {
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" },
      },
      completion = {
        callSnippet = "Replace",
      }
    },
  },
}
