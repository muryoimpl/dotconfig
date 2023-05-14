local M = {}

M.path_separator = "/"
M.is_windows = vim.fn.has("win32") == 1 or vim.fn.has("win32unix") == 1
if M.is_windows == true then
  M.path_separator = "\\"
end

---Split string into a table of strings using a separator.
---@param inputString string The string to split.
---@param sep string The separator to use.
---@return table table A table of strings.
M.split = function(inputString, sep)
  local fields = {}

  local pattern = string.format("([^%s]+)", sep)
  local _ = string.gsub(inputString, pattern, function(c)
    fields[#fields + 1] = c
  end)

  return fields
end

---Joins arbitrary number of paths together.
---@param ... string The paths to join.
---@return string
M.path_join = function(...)
  local args = {...}
  if #args == 0 then
    return ""
  end

  local all_parts = {}
  if type(args[1]) =="string" and args[1]:sub(1, 1) == M.path_separator then
    all_parts[1] = ""
  end

  for _, arg in ipairs(args) do
    arg_parts = M.split(arg, M.path_separator)
    vim.list_extend(all_parts, arg_parts)
  end
  return table.concat(all_parts, M.path_separator)
end



M.find_root_path = function()
  local buffer_path = vim.fn.expand("%:p")

  -- プロジェクトルートを探索するディレクトリのリスト
  local search_dirs = { buffer_path, vim.loop.cwd() }

  -- プロジェクトルートを探索する
  for _, dir in ipairs(search_dirs) do
      local root = vim.fn.finddir(".git", dir .. ";")
      if root ~= "" and root ~= nil then
          return vim.fn.fnamemodify(root, ":h")
      end
  end

  return nil
end


M.open_test_file = function()
  -- 現在のバッファのパスを取得する
  local buffer_path = vim.api.nvim_buf_get_name(0)

  -- テストファイルが置かれるディレクトリのパスを取得する
  local test_dir_path = vim.fn.substitute(buffer_path, "/app/", "/test/", "")

  -- テストファイルのパスを生成する
  local test_file_path = vim.fn.substitute(test_dir_path, "/\\zs[^/]*\\.\\w\\+$\\ze", "/test_\\0", "")

  vim.api.nvim_command("edit " .. test_file_path)

  -- テストファイルが存在するかチェックする
  -- if vim.fn.filereadable(test_file_path) == 1 then
  --   -- テストファイルが存在する場合は開く
  --   vim.api.nvim_command("edit " .. test_file_path)
  -- else
  --   -- テストファイルが存在しない場合はエラーメッセージを表示する
  --   print("Test file not found: " .. test_file_path)
  -- end


end














-- register command 
vim.api.nvim_create_user_command("EditTestFile",
  function()
    local root_path = M.find_root_path()

    if root_path == nil then
      return nil
    end



  end,
  { nargs = 0 }
)
