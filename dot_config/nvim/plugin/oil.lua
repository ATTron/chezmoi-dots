vim.pack.add({
  { src = "https://github.com/stevearc/oil.nvim" },
})

require("oil").setup({
  columns = { "icon" },
  default_file_explorer = false,
  view_options = {
    show_hidden = true,
  },
}, vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open Parent Directory" }))
