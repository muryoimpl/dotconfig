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
      Search = { fg = '#fff', bg = '#8A2BE2' },
    }
  end
})

vim.cmd([[
colorscheme github_dark_default
]])
