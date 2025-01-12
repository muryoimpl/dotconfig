local lspconfig = require('lspconfig')
local util = require('lspconfig/util')
local cmp_nvim_lsp = require('cmp_nvim_lsp')
local mason_lspconfig = require('mason-lspconfig')
---@diagnostic disable:undefined-global
-- https://zenn.dev/botamotch/articles/21073d78bc68bf

require('mason').setup()

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    local opts = {} -- { buffer= ev.buf, silent = true }
    local keymap = vim.keymap

    keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
    keymap.set('n', 'K',  '<cmd>lua require("hover").hover()<CR>', opts)
    keymap.set('n', 'gf', '<cmd>lua vim.lsp.buf.format()<CR>', opts)
    keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    keymap.set('n', 'gt', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    keymap.set('n', 'gn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    keymap.set('n', 'ga', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    keymap.set('n', 'ge', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
    keymap.set('n', 'g]', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
    keymap.set('n', 'g[', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
  end,
})

-- Show sign
-- アイコンはここから選んだ https://www.nerdfonts.com/cheat-sheet
local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

local capabilities = cmp_nvim_lsp.default_capabilities(
  vim.lsp.protocol.make_client_capabilities()
)

mason_lspconfig.setup_handlers({
  function(server_name)
    local opts = {
      capabilities = capabilities,
    }
    lspconfig[server_name].setup(opts)
  end,
  ["lua_ls"] = function()
    lspconfig["lua_ls"].setup({
      cappabilities = capabilities,
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
    })
  end,
})

-- LSP handlers
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = false,
    signs = true,
    update_in_insert = true,
    underline = false,
  }
)
vim.diagnostic.config({
  virtual_text = false,
  signs = true,
  update_in_insert = true,
  underline = false,
})

vim.cmd [[
  highlight! DiagnosticLineNrError guibg=#51202A guifg=#FF0000 gui=bold
  highlight! DiagnosticLineNrWarn guibg=#51412A guifg=#FFA500 gui=bold
  highlight! DiagnosticLineNrInfo guibg=#1E535D guifg=#00FFFF gui=bold
  highlight! DiagnosticLineNrHint guibg=#1E205D guifg=#0000FF gui=bold

  sign define DiagnosticSignError text= texthl=DiagnosticSignError linehl= numhl=DiagnosticLineNrError
  sign define DiagnosticSignWarn text= texthl=DiagnosticSignWarn linehl= numhl=DiagnosticLineNrWarn
  sign define DiagnosticSignInfo text= texthl=DiagnosticSignInfo linehl= numhl=DiagnosticLineNrInfo
  sign define DiagnosticSignHint text= texthl=DiagnosticSignHint linehl= numhl=DiagnosticLineNrHint
]]
