local M = {}
function M.ensure_plugin_built(repo_url, plugin_name, build_cmd, build_check_file)
  local pack_path = vim.fn.stdpath('data') .. '/site/pack/core/opt'
  local plugin_path = pack_path .. '/' .. plugin_name
  vim.fn.mkdir(pack_path, 'p')

  if vim.fn.isdirectory(plugin_path) == 0 then
    print('Installing ' .. plugin_name .. '...')
    vim.fn.system('git clone ' .. repo_url .. ' ' .. plugin_path)
  end

  local base_path = plugin_path .. '/' .. build_check_file
  local so_file = base_path .. '.so'
  local dylib_file = base_path .. '.dylib'
  local lua_file = base_path .. '.lua'

  local artifact_exists = vim.fn.filereadable(so_file) == 1 or vim.fn.filereadable(dylib_file) == 1 or vim.fn.filereadable(lua_file) == 1

  if not artifact_exists then
    print('Building ' .. plugin_name .. '...')
    local result = vim.fn.system('cd ' .. plugin_path .. ' && ' .. build_cmd)
    if vim.v.shell_error == 0 then
      print(plugin_name .. ' built successfully!')
    else
      print('Build failed: ' .. result)
      return false
    end
  end

  return true
end

return M

