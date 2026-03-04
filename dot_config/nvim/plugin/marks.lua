vim.pack.add({
  { src = "https://github.com/cbochs/grapple.nvim" },
})

vim.keymap.set("n", "<leader>a", "<cmd>Grapple toggle<cr>")
vim.keymap.set("n", "<c-e>", "<cmd>Grapple toggle_tags<cr>")

vim.keymap.set("n", "<c-h>", "<cmd>Grapple select index=1<cr>")
vim.keymap.set("n", "<c-t>", "<cmd>Grapple select index=2<cr>")
vim.keymap.set("n", "<c-n>", "<cmd>Grapple select index=3<cr>")
vim.keymap.set("n", "<c-s>", "<cmd>Grapple select index=4<cr>")

vim.keymap.set("n", "<c-s-n>", "<cmd>Grapple cycle_tags next<cr>")
vim.keymap.set("n", "<c-s-p>", "<cmd>Grapple cycle_tags prev<cr>")
