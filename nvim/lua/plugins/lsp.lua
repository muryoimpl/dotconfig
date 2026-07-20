local cmp_nvim_lsp = require('cmp_nvim_lsp')
---@diagnostic disable:undefined-global
-- https://zenn.dev/botamotch/articles/21073d78bc68bf
--
-- サーバーごとの設定は nvim/after/lsp/<サーバー名>.lua に置く。
-- after/ 側は runtimepath の並びに関係なく nvim-lspconfig 同梱の
-- デフォルト設定より後に読まれるため、上書きが確実になる。
-- https://zenn.dev/ncdc/articles/e920f5306ff3de

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
    keymap.set('n', 'gF', '<cmd>lua vim.lsp.buf.format()<CR>', opts)
    keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    keymap.set('n', 'gt', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    keymap.set('n', 'gn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    keymap.set('n', 'ga', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    keymap.set('n', 'ge', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
    keymap.set('n', 'g]', '<cmd>lua vim.diagnostic.jump({ count = 1, float = true })<CR>', opts)
    keymap.set('n', 'g[', '<cmd>lua vim.diagnostic.jump({ count = -1, float = true })<CR>', opts)
  end,
})

-- 全サーバー共通の設定。"*" はファイルベースの解決対象外なのでここに書く。
vim.lsp.config("*", {
  capabilities = cmp_nvim_lsp.default_capabilities(
    vim.lsp.protocol.make_client_capabilities()
  ),
})

-- gopls は mason-lspconfig の automatic_enable 任せ
vim.lsp.enable({ "lua_ls", "ruby_lsp", "rubocop", "cspell_ls" })

-- Show sign
-- アイコンはここから選んだ https://www.nerdfonts.com/cheat-sheet
vim.diagnostic.config({
  virtual_text = false,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = " ",
      [vim.diagnostic.severity.WARN] = " ",
      [vim.diagnostic.severity.HINT] = " ",
      [vim.diagnostic.severity.INFO] = " ",
    },
    numhl = {
      [vim.diagnostic.severity.ERROR] = "DiagnosticLineNrError",
      [vim.diagnostic.severity.WARN] = "DiagnosticLineNrWarn",
      [vim.diagnostic.severity.INFO] = "DiagnosticLineNrInfo",
      [vim.diagnostic.severity.HINT] = "DiagnosticLineNrHint",
    },
  },
  update_in_insert = true,
  underline = false,
})

vim.cmd [[
  highlight! DiagnosticLineNrError guibg=#51202A guifg=#FF0000 gui=bold
  highlight! DiagnosticLineNrWarn guibg=#51412A guifg=#FFA500 gui=bold
  highlight! DiagnosticLineNrInfo guibg=#1E535D guifg=#00FFFF gui=bold
  highlight! DiagnosticLineNrHint guibg=#1E205D guifg=#0000FF gui=bold
]]
