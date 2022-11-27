require("github-theme").setup({
  theme_style = "dark_default",
  comment_style = "NONE",
  keyword_style = "NONE",
  function_style = "NONE",
  variable_style = "NONE",
  -- -- Overwrite the highlight groups
  colors = {
    syntax = {
      constant = "#2188ff",
      variable = "#fff",
    },
  },
  overrides = function(_)
    return {
      Type = { fg = "#FFA066" },
      Keyword = { fg = "#E46876" },
      Constant = { fg = '#fff' },
    }
  end
})
