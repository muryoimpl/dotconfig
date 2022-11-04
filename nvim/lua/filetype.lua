---@diagnostic disable:undefined-global
-- go
vim.api.nvim_create_autocmd(
  "FileType",
  { pattern = "go", command = "setlocal tabstop=8 noexpandtab shiftwidth=8" }
)
