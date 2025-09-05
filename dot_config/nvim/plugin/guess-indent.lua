vim.pack.add({
  { src = "https://github.com/NMAC427/guess-indent.nvim" }
})

vim.cmd('packadd guess-indent.nvim')
require("guess-indent").setup({
  filetype_exluce = {
    "netrw",
  },
  buftype_exclude = {
    "terminal",
    "prompt",
    "help",
    "nofile",
  }
})
