vim.pack.add({
  { src = "https://github.com/NMAC427/guess-indent.nvim" },
})

require("guess-indent").setup({
  filetype_exclude = {
    "netrw",
  },
  buftype_exclude = {
    "terminal",
    "prompt",
    "help",
    "nofile",
  },
})
