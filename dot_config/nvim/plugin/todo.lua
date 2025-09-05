vim.pack.add({
  { src = "https://github.com/folke/todo-comments.nvim" }
})

vim.cmd('packadd todo-comments.nvim')
require("todo-comments").setup({})
