return {
  "Kicamon/markdown-table-mode.nvim",
  config = function()
    require("markdown-table-mode").setup({
      filetype = {
        "*.md",
        "*.norg",
      },
    })
  end,
}
