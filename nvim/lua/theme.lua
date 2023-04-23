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
    },
  },
})

vim.cmd([[
colorscheme github_dark
]])
