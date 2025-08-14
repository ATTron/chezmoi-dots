vim.pack.add({
  { src = "https://github.com/dmtrKovalenko/fff.nvim" },
})

local utils = require("utils")

local success = utils.ensure_plugin_built(
  "https://github.com/dmtrKovalenko/fff.nvim",
  "fff.nvim",
  "cargo build --release",
  "target/release/libfff_nvim"
)

if success then
  require("fff").setup({
    prompt = '🦆 ',
    title = 'Whaddya Buyin',
    frecency = {
      enabled = true,                                   -- Enable frecency tracking
      db_path = vim.fn.stdpath('cache') .. '/fff_nvim', -- Database location
    },
    layout = {
      prompt_position = 'top',    -- Position of prompt ('top' or 'bottom')
      preview_position = 'right', -- Position of preview ('right' or 'left')
      preview_width = 0.4,        -- Width of preview pane
      height = 0.8,               -- Window height
      width = 0.8,                -- Window width
    },
    keymaps = {
      close = '<Esc>',
      select = '<CR>',
      select_split = '<C-s>',
      select_vsplit = '<C-v>',
      select_tab = '<C-t>',
      move_up = { '<Tab>', '<C-p>' }, -- Multiple bindings supported
      move_down = { '<S-Tab>', '<C-n>' },
      preview_scroll_up = '<C-u>',
      preview_scroll_down = '<C-d>',
      toggle_debug = '<F2>', -- Toggle debug scores display
    },
  })

  vim.keymap.set("n", "<leader>sf", "<cmd>FFFFind<CR>")
end
