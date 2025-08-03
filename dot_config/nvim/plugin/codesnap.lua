vim.pack.add({
  { src = "https://github.com/mistricky/codesnap.nvim" },
})

-- since the generator needs to be built, this confirms that the generator.so is built before setting the plugin up
local function ensure_plugin_built(repo_url, plugin_name, build_cmd, build_check_file)
  local pack_path = vim.fn.stdpath('data') .. '/site/pack/core/opt'
  local plugin_path = pack_path .. '/' .. plugin_name

  vim.fn.mkdir(pack_path, 'p')

  if vim.fn.isdirectory(plugin_path) == 0 then
    print('Installing ' .. plugin_name .. '...')
    vim.fn.system('git clone ' .. repo_url .. ' ' .. plugin_path)
  end

  local build_artifact = plugin_path .. '/' .. build_check_file

  if vim.fn.filereadable(build_artifact) == 0 then
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

local success = ensure_plugin_built(
  'https://github.com/mistricky/codesnap.nvim.git',
  'codesnap.nvim',
  'make',
  'lua/generator.so'
)

if success then
  require("codesnap").setup({
    has_breadcrumbs = true,
    code_font_family = "Berkeley Mono",
    show_workspace = true,
    has_line_number = true,
    bg_theme = "grape",
    watermark = "",
    save_path = "~/Pictures/Code",
  })

  vim.keymap.set("x", "cs", ":CodeSnapSave<CR>")
end
