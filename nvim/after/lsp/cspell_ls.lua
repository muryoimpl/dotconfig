local config_path = ".cspell/cspell.config.yml"

---@type vim.lsp.Config
return {
  -- .cspell/cspell.config.yml を置いているリポジトリでのみ起動する。
  -- on_dir を呼ばなければ、この config は有効化されない。
  root_dir = function(bufnr, on_dir)
    local root_dir = vim.fs.root(bufnr, { ".git" })
    if not root_dir then return end
    if vim.fn.filereadable(root_dir .. "/" .. config_path) ~= 1 then return end

    on_dir(root_dir)
  end,

  init_options = {
    config = config_path,
  },
}
