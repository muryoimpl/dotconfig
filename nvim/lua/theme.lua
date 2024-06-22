require("github-theme").setup({
  options = {
    styles = {
      comments = "NONE",
      keywords = "NONE",
      functions = "NONE",
      variables = "NONE",
    },
  },
  -- -- Overwrite the highlight groups
  specs = {
    syntax = {
      constant = "#2188ff",
      variable = "#ffffff",
    },
  },
  groups = {
    all = {
      Type = { fg = "#FFA066" },
      Keyword = { fg = "#E46876" },
      Constant = { fg = "#ffffff" },
      Search = { fg = "#ffffff", bg = '#8A2BE2' },

      -- nvim-cmp の配色 start
      PmenuSel = { bg = "#282C34", fg = "NONE" },
      Pmenu = { fg = "#C5CDD9", bg = "#22252A" },

      CmpItemAbbrDeprecated = { fg = "#7E8294", bg = "NONE", strikethrough = true },
      CmpItemAbbrMatch = { fg = "#82AAFF",      bg = "NONE", bold = true },
      CmpItemAbbrMatchFuzzy = { fg = "#82AAFF", bg = "NONE", bold = true },
      CmpItemMenu = { fg = "#C792EA",           bg = "NONE", italic = true },

      CmpItemKindField = { fg = "#EED8DA",       },  -- bg = "#B5585F" },
      CmpItemKindProperty = { fg = "#EED8DA",    },  -- bg = "#B5585F" },
      CmpItemKindEvent = { fg = "#EED8DA",       },  -- bg = "#B5585F" },

      CmpItemKindText = { fg = "#C3E88D",        },   -- bg = "#9FBD73" },
      CmpItemKindEnum = { fg = "#C3E88D",        },   -- bg = "#9FBD73" },
      CmpItemKindKeyword = { fg = "#C3E88D",     },   -- bg = "#9FBD73" },

      CmpItemKindConstant = { fg = "#FFE082",    },   -- bg = "#D4BB6C" },
      CmpItemKindConstructor = { fg = "#FFE082", },   -- bg = "#D4BB6C" },
      CmpItemKindReference = { fg = "#FFE082",   },   -- bg = "#D4BB6C" },

      CmpItemKindFunction = { fg = "#EADFF0", bg = "#A377BF" },
      CmpItemKindStruct = { fg = "#EADFF0",   bg = "#A377BF" },
      CmpItemKindClass = { fg = "#EADFF0",    bg = "#A377BF" },
      CmpItemKindModule = { fg = "#EADFF0",   bg = "#A377BF" },
      CmpItemKindOperator = { fg = "#EADFF0", bg = "#A377BF" },

      CmpItemKindVariable = { fg = "#C5CDD9", bg = "#7E8294" },
      CmpItemKindFile = { fg = "#C5CDD9",     bg = "#7E8294" },

      CmpItemKindUnit = { fg = "#F5EBD9", },
      CmpItemKindSnippet = { fg = "#F5EBD9",  },
      CmpItemKindFolder = { fg = "#F5EBD9",  },

      CmpItemKindMethod = { fg = "#DDE5F5",     bg = "#6C8ED4" },
      CmpItemKindValue = { fg = "#DDE5F5",      bg = "#6C8ED4" },
      CmpItemKindEnumMember = { fg = "#DDE5F5", bg = "#6C8ED4" },

      CmpItemKindInterface = { fg = "#D8EEEB",      bg = "#58B5A8" },
      CmpItemKindColor = { fg = "#D8EEEB",          bg = "#58B5A8" },
      CmpItemKindTypeParameter = { fg = "#D8EEEB",  bg = "#58B5A8" },

      CmpItemKindCopilot = { fg ="#6CC644" },
      -- nvim-cmp の配色 end
    },
  },
})

vim.cmd([[
colorscheme github_dark

let g:terminal_color_8 = "#6e7681"
]])
