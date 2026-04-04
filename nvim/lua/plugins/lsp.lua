-- local lspconfig = require('lspconfig')
-- local util = require('lspconfig/util')
local cmp_nvim_lsp = require('cmp_nvim_lsp')
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

local capabilities = cmp_nvim_lsp.default_capabilities(
  vim.lsp.protocol.make_client_capabilities()
)

vim.api.nvim_create_autocmd("FileType", {
  pattern = "ruby",
  callback = function(args)
    local root_dir = vim.fs.root(args.buf, { "Gemfile", ".rubocop.yml" })
    if not root_dir then return end

    local cmd = { "rubocop", "--lsp" }
    local gemfile = root_dir .. "/Gemfile"
    if vim.fn.filereadable(gemfile) == 1 then
      local lines = vim.fn.readfile(gemfile)
      for _, line in ipairs(lines) do
        if line:match("gem%s+['\"]rubocop") then
          cmd = { "bundle", "exec", "rubocop", "--lsp" }
          break
        end
      end
    end

    vim.lsp.start({
      name = "rubocop",
      cmd = cmd,
      root_dir = root_dir,
      capabilities = capabilities,
    })
  end,
})

vim.lsp.config("lua_ls", {
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

local cspell_config_path = ".cspell/cspell.config.yml"
vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
  group = vim.api.nvim_create_augroup("CspellLsp", {}),
  callback = function(args)
    local root = vim.fs.root(args.buf, { ".git" })
    if not root then return end
    if vim.fn.filereadable(root .. "/" .. cspell_config_path) ~= 1 then return end

    vim.lsp.start({
      name = "cspell_ls",
      cmd = { "cspell-lsp", "--stdio" },
      root_dir = root,
      capabilities = capabilities,
      init_options = {
        config = cspell_config_path,
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
