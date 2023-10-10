local has_words_before = function()
  unpack = unpack or table.unpack
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local feedkey = function(key, mode)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

-- comp
vim.opt.completeopt = 'menu,menuone,noselect'
local cmp = require('cmp')
cmp.setup({
  formatting = {
    format = require('lspkind').cmp_format({
      mode = "symbol",
      max_width = 50,
      symbol_map = { Copilot = "" },
    }),
  },
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  window = {
    completion = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-y>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
    ['<Tab>'] = nil,
    ['<S-Tab>'] = nil,
  }),
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "vsnip" },
    { name = "copilot" },
  },
  {
    { name = "buffer" },
  }),
})

-- cmdline & path source
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),

  sources = {
    { name = 'cmdline' }
  }
})

-- buffer source
cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

-- vsnip config
-- NOTE: vsnip は $1:/capitalize みたいな transform はできない
vim.g.vsnip_snippet_dirs = {
  vim.fn.expand('~/.config/nvim/lua/snippets'),
}
vim.g.vsnip_filetypes = {
  javascriptreact = { "javascript", "typescript" },
  typescriptreact = { "typescript" },
}
