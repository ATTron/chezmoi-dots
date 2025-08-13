vim.pack.add({
  { src = "https://github.com/mistricky/codesnap.nvim" },
})

local utils = require("utils")

local success = utils.ensure_plugin_built(
  'https://github.com/mistricky/codesnap.nvim.git',
  'codesnap.nvim',
  'make',
  'lua/generator'
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
