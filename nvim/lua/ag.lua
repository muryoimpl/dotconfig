local M = {}

local config = {
  ag_prg = { 'ag', '--vimgrep', '--noheading', '--column' },
  ag_format = '%f:%l:%c:%m',
}

local function deep_extend(...)
  local result = {}
  for _, t in ipairs({...}) do
    for k, v in pairs(t) do
      if type(v) == 'table' then
        result[k] = deep_extend(result[k] or {}, v)
      else
        result[k] = v
      end
    end
  end
  return result
end

M.ag = function(args)
-- local opts = config.ag_prg
-- table.insert(opts, args)
-- table.insert(opts, config.ag_format)
-- vim.fn.jobstart(opts, {
--   on_stdout = function(_, data, _)
--     vim.fn.setqflist({}, ' ', { title = 'ag', lines = data })
--     vim.cmd('copen')
--   end,
-- })
end

M.setup = function(opts)
  local overrides = config.deep_extend(config, opt)
end

-- vim.api.nvim_create_user_command('Ag', 'lua M.ag(<f-args>)')
