vim.pack.add({
  { src = "https://github.com/dmtrKovalenko/fff.nvim" },
})

vim.api.nvim_create_autocmd("PackChanged", {
  callback = function(event)
    if event.data.updated then
      require("fff.download").download_or_build_binary()
    end
  end,
})

vim.g.fff = {
  debug = { enabled = true, show_scores = true },
}

require("fff").setup({
  prompt = "🦆 ",
  title = "Whaddya Buyin ?",
  layout = {
    prompt_position = "top",
  },
  keymaps = {
    move_up = { "<S-Tab>", "<C-n>" },
    move_down = { "<Tab>", "<C-p>" },
  },
})

vim.keymap.set("n", "<leader>sf", function()
  require("fff").find_files()
end)

vim.keymap.set("n", "<leader>sg", function()
  require("fff").live_grep()
end)
