vim.pack.add({
  {
    src = "https://github.com/mistricky/codesnap.nvim",
    version = "v1.6.3"
  },
})

local utils = require("utils")

local success =
    utils.ensure_plugin_built("https://github.com/mistricky/codesnap.nvim.git", "codesnap.nvim", "make", "lua/generator")

if success then
  vim.cmd("packadd codesnap.nvim")
  require("codesnap").setup({
    has_breadcrumbs = true,
    code_font_family = "Berkeley Mono",
    show_workspace = true,
    has_line_number = true,
    bg_theme = "grape",
    watermark = "",
    save_path = "~/Pictures/Code",
  })

  vim.keymap.set("x", "ss", ":CodeSnapSave<CR>")
end
