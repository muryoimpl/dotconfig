local has_words_before = function()
  if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then return false end
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_text(0, line-1, 0, line-1, col, {})[1]:match("^%s*$") == nil
end

local feedkey = function(key, mode)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

-- comp
vim.opt.completeopt = 'menu,menuone,noselect'
local kind_icons = {
  Text = "",
  Method = "󰆧",
  Function = "󰊕",
  Constructor = "",
  Field = "󰇽",
  Variable = "󰂡",
  Class = "󰠱",
  Interface = "",
  Module = "",
  Property = "󰜢",
  Unit = "",
  Value = "󰎠",
  Enum = "",
  Keyword = "󰌋",
  Snippet = "",
  Color = "󰏘",
  File = "󰈙",
  Reference = "",
  Folder = "󰉋",
  EnumMember = "",
  Constant = "󰏿",
  Struct = "",
  Event = "",
  Operator = "󰆕",
  TypeParameter = "󰅲",
  Copilot = "",
}
local cmp = require('cmp')
cmp.setup({
  formatting = {
    fields = { "kind", "abbr", "menu" },
    format = function(entry, vim_item)
      vim_item.menu = ({
        buffer = "[Buffer]",
        nvim_lsp = "[LSP]",
        vsnip = "[VSnip]",
      })[entry.source.name]

      vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind)
      return vim_item
--    nvim-web-devicons 使うならこちら
--     if vim.tbl_contains({ 'path' }, entry.source.name) then
--       local icon, hl_group = require('nvim-web-devicons').get_icon(entry:get_completion_item().label)
--       if icon then
--         vim_item.kind = icon
--         vim_item.kind_hl_group = hl_group
--         return vim_item
--       end
--     end
--
--     local lspkind = require('lspkind')
--     return lspkind.cmp_format({
--       mode = "symbol",
--       symbol_map = { Copilot = "" },
--     })(entry, vim_item)
    end
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
    ["<Tab>"] = vim.schedule_wrap(function(fallback)
      if cmp.visible() and has_words_before() then
        cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
      else
        fallback()
      end
    end),
  }),
  sorting = {
    priority_weight = 2,
    comparators = {
      require("copilot_cmp.comparators").prioritize,

      -- Below is the default comparitor list and order for nvim-cmp
      cmp.config.compare.offset,
      -- cmp.config.compare.scopes, --this is commented in nvim-cmp too
      cmp.config.compare.exact,
      cmp.config.compare.score,
      cmp.config.compare.recently_used,
      cmp.config.compare.locality,
      cmp.config.compare.kind,
      cmp.config.compare.sort_text,
      cmp.config.compare.length,
      cmp.config.compare.order,
    },
  },
  sources = cmp.config.sources({
    { name = "copilot", group_index = 2 },
    { name = "nvim_lsp", group_index = 2 },
    { name = "vsnip", group_index = 2 },
    { name = "buffer", group_index = 2 },
  },
  {}),
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
