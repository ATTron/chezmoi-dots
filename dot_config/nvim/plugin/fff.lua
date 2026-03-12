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

require("fff").setup({
  debug = { enabled = true, show_scores = false },
  prompt = "🦆 ",
  title = "Whaddya Buyin ?",
  layout = {
    prompt_position = "top",
  },
  keymaps = {
    move_up = { "<S-Tab>", "<C-p>" },
    move_down = { "<Tab>", "<C-n>" },
    toggle_select = "<C-Space>",
    cycle_grep_modes = "<C-g>",
  },
})

vim.keymap.set("n", "<leader>sf", function()
  require("fff").find_files()
end)

vim.keymap.set("n", "<leader>sg", function()
  require("fff").live_grep()
end)
