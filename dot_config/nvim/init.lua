vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.g.have_nerd_font = true

-- set line numbers
vim.o.number = true
vim.o.relativenumber = true

-- enable mouse
vim.o.mouse = "a"

-- clipboard
vim.o.clipboard = "unnamedplus"

-- set autochdir
vim.o.autochdir = false

-- Decrease update time
vim.opt.updatetime = 100

-- undo history enabled
vim.o.undofile = true

-- case insensitive search unless capital letters present
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- setup whitespace characters
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- editor options
vim.opt.signcolumn = "yes"
vim.opt.scrolloff = 5
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

-- set blame line color
vim.api.nvim_set_hl(0, "GitSignsCurrentLineBlame", { fg = "#60c2db", italic = true })

-- enable cursor line
vim.o.cursorline = true

-- file options
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false
vim.opt.autoread = true
vim.opt.autowrite = false

-- non plugin keymaps start
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
vim.keymap.set("i", "jk", "<Esc>")

-- highlight search
vim.opt.hlsearch = true
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- disable arrow keys
vim.keymap.set("n", "<left>", '<cmd>echo "Use h to move!"<CR>')
vim.keymap.set("n", "<right>", '<cmd>echo "Use l to move!"<CR>')
vim.keymap.set("n", "<up>", '<cmd>echo "Use k to move!"<CR>')
vim.keymap.set("n", "<down>", '<cmd>echo "Use j to move!"<CR>')

-- center when jumping
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Half page down (centered)" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Half page up (centered)" })

-- move lines up/down
vim.keymap.set("n", "<A-j>", ":m .+1<CR>==")
vim.keymap.set("n", "<A-k>", ":m .-2<CR>==")
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv")

-- indent lines (keep selection)
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- force format buffer
vim.keymap.set("n", "<leader>lf", vim.lsp.buf.format)

-- buffer movement
vim.keymap.set("n", "bn", ":bnext<CR>")
vim.keymap.set("n", "bp", ":bprevious<CR>")

vim.opt.completeopt = { "menu", "menuone", "noselect" }

-- non plugin keymaps end

-- autocommands
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "netrw",
  callback = function()
    vim.keymap.set("n", "<Esc><Esc>", "<C-^>", { buffer = true })
  end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function(args)
    require("conform").format({ bufnr = args.buf })
  end,
})

vim.api.nvim_create_autocmd("User", {
  pattern = "OilActionsPost",
  callback = function(event)
    if event.data.actions.type == "move" then
      Snacks.rename.on_rename_file(event.data.actions.src_url, event.data.actions.dest_url)
    end
  end,
})

-- packages
vim.pack.add({
  { src = "https://github.com/neovim/nvim-lspconfig" },
  { src = "https://github.com/stevearc/conform.nvim.git" },
  { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
  { src = "https://github.com/nvim-tree/nvim-web-devicons" },
})

-- setup plugins
require("conform").setup({
  formatters_by_ft = {
    lua = { "stylua", lsp_format = "fallback" },
    python = { "ruff", "format" },
    rust = { "rustfmt", lsp_format = "fallback" },
  },
})
require("nvim-treesitter.configs").setup({
  ensure_installed = { "lua", "c", "vim" },
  auto_install = true,
})

-- enable lsp
vim.lsp.enable({ "lua_ls", "rust_analyzer" })

-- shell detection
-- Auto-detect shell
local function find_shell()
  local shells = {
    vim.env.HOME .. "/.local/bin/zsh",
    "/usr/bin/zsh",
    "/usr/local/bin/zsh",
  }

  for _, shell in ipairs(shells) do
    if vim.fn.executable(shell) == 1 then
      return shell
    end
  end

  return vim.o.shell -- fallback to default
end

vim.opt.shell = find_shell()
