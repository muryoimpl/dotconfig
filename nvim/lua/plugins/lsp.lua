-- https://zenn.dev/botamotch/articles/21073d78bc68bf
-- nvim-lspconfig のキーバインドを設定する
local on_attach = function(client, bufnr)
  local lspopts = { noremap=true, silent=true }
  vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', lspopts)
  vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', lspopts)
  vim.keymap.set('n', 'K',  '<cmd>lua vim.lsp.buf.hover()<CR>', lspopts)
  vim.keymap.set('n', 'gf', '<cmd>lua vim.lsp.buf.formatting()<CR>', lspopts)
  vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', lspopts)
  vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', lspopts)
  vim.keymap.set('n', 'gt', '<cmd>lua vim.lsp.buf.type_definition()<CR>', lspopts)
  vim.keymap.set('n', 'gn', '<cmd>lua vim.lsp.buf.rename()<CR>', lspopts)
  vim.keymap.set('n', 'ga', '<cmd>lua vim.lsp.buf.code_action()<CR>', lspopts)
  vim.keymap.set('n', 'ge', '<cmd>lua vim.diagnostic.open_float()<CR>', lspopts)
  vim.keymap.set('n', 'g]', '<cmd>lua vim.diagnostic.goto_next()<CR>', lspopts)
  vim.keymap.set('n', 'g[', '<cmd>lua vim.diagnostic.goto_prev()<CR>', lspopts)
end

require('mason').setup()
require('mason-lspconfig').setup_handlers({ function(server)
  local opts = {
    capabilities = require('cmp_nvim_lsp').update_capabilities(
      vim.lsp.protocol.make_client_capabilities()
    ),
    on_attach = on_attach,
  }
  require('lspconfig')[server].setup(opts)
end })

-- LSP handlers
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, { virtual_text = false }
)

vim.cmd 'autocmd BufWritePre * lua vim.lsp.buf.formatting_sync(nil, 1000)'

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

-- comp
vim.opt.completeopt='menu,menuone,noselect'
local cmp = require('cmp')

cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  window = {
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'vsnip' },
  }, {
    { name = 'buffer' },
  })
})