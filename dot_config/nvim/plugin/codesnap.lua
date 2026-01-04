vim.pack.add({
  {
    src = "https://github.com/mistricky/codesnap.nvim",
    version = "v2.0.0-beta.17"
  },
})

vim.cmd("packadd codesnap.nvim")
require("codesnap").setup({
  has_breadcrumbs = true,
  code_font_family = "Berkeley Mono",
  show_workspace = true,
  has_line_number = true,
  snapshot_config = {
    bg_theme = "grape",
    watermark = "",
    save_path = "~/Pictures/Code",
  },
  save_path = "~/Pictures/Code",
})

vim.keymap.set("x", "ss", ":CodeSnapSave<CR>")
