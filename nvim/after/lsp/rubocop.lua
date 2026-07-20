---@type vim.lsp.Config
return {
  root_markers = { "Gemfile", ".rubocop.yml" },

  -- Gemfile に rubocop があれば bundle exec 経由で起動する。
  -- root_dir はプロジェクトごとに変わるので、cmd を関数にして起動時に判定する。
  cmd = function(dispatchers, config)
    local root_dir = config.root_dir or vim.fn.getcwd()
    local cmd = { "rubocop", "--lsp" }

    local gemfile = root_dir .. "/Gemfile"
    if vim.fn.filereadable(gemfile) == 1 then
      for _, line in ipairs(vim.fn.readfile(gemfile)) do
        if line:match("gem%s+['\"]rubocop") then
          cmd = { "bundle", "exec", "rubocop", "--lsp" }
          break
        end
      end
    end

    return vim.lsp.rpc.start(cmd, dispatchers, { cwd = root_dir })
  end,
}
