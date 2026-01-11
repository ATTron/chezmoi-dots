vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.g.have_nerd_font = true

vim.opt.showmode = false

-- set line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- enable mouse
vim.opt.mouse = "a"

-- clipboard
vim.opt.clipboard = "unnamedplus"

-- set autochdir
vim.opt.autochdir = false

-- Decrease update time
vim.opt.updatetime = 100

-- undo history enabled
vim.opt.undofile = true

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
vim.opt.breakindent = true
vim.opt.inccommand = "split"

-- enable cursor line
vim.opt.cursorline = true

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

-- center when jumping with lsp movement
vim.keymap.set("n", "[m", "[mzz")
vim.keymap.set("n", "]m", "]mzz")

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

-- resize vertical windows
vim.keymap.set("n", "<C-Left>", ":vertical resize -2<CR>", { desc = "Decrease window size" })
vim.keymap.set("n", "<C-Right>", ":vertical resize +2<CR>", { desc = "Increase window size" })

-- update packages
vim.keymap.set("n", "<leader>pp", vim.pack.update)
vim.opt.completeopt = { "menu", "menuone", "noselect" }

-- non plugin keymaps end

-- autocommands
-- treat .h files as C instead of C++
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*.h",
  callback = function()
    vim.bo.filetype = "c"
  end,
})

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
    vim.lsp.buf.format()
  end,
})

vim.api.nvim_create_autocmd("BufEnter", {
  callback = function()
    if vim.bo.filetype == "" then
      vim.cmd("filetype detect")
    end
  end,
})

vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function()
    vim.api.nvim_set_hl(0, "GitSignsCurrentLineBlame", { fg = "#60c2db", italic = true })
  end,
})

vim.diagnostic.config({
  severity_sort = true,
  float = { border = "rounded", source = "if_many" },
  underline = { severity = vim.diagnostic.severity.ERROR },
  signs = vim.g.have_nerd_font and {
    text = {
      [vim.diagnostic.severity.ERROR] = "󰅚 ",
      [vim.diagnostic.severity.WARN] = "󰀪 ",
      [vim.diagnostic.severity.INFO] = "󰋽 ",
      [vim.diagnostic.severity.HINT] = "󰌶 ",
    },
  } or {},
  virtual_text = {
    source = "if_many",
    spacing = 2,
    format = function(diagnostic)
      local diagnostic_message = {
        [vim.diagnostic.severity.ERROR] = diagnostic.message,
        [vim.diagnostic.severity.WARN] = diagnostic.message,
        [vim.diagnostic.severity.INFO] = diagnostic.message,
        [vim.diagnostic.severity.HINT] = diagnostic.message,
      }
      return diagnostic_message[diagnostic.severity]
    end,
  },
})

vim.fn.sign_define("DiagnosticSignError", { text = "󰅚", texthl = "DiagnosticSignError" })
vim.fn.sign_define("DiagnosticSignWarn", { text = "󰀪", texthl = "DiagnosticSignWarn" })
vim.fn.sign_define("DiagnosticSignInfo", { text = "󰋽", texthl = "DiagnosticSignInfo" })
vim.fn.sign_define("DiagnosticSignHint", { text = "󰌶", texthl = "DiagnosticSignHint" })

-- packages
vim.pack.add({
  { src = "https://github.com/ellisonleao/gruvbox.nvim" },
  { src = "https://github.com/ATTron/bebop.nvim" },
  { src = "https://github.com/neovim/nvim-lspconfig" },
  { src = "https://github.com/stevearc/conform.nvim.git" },
  { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
  { src = "https://github.com/nvim-tree/nvim-web-devicons" },
  { src = "https://github.com/chomosuke/typst-preview.nvim" },
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
  highlight = {
    enable = true,
  },
  indent = { enable = true },
})

-- set colorscheme
vim.opt.background = "dark"

require("solarized-osaka").setup({
  transparent = true,
  terminal_colors = true,
})
-- vim.cmd([[colorscheme solarized-osaka]])

require("oldworld").setup({
  terminal_colors = true,
  variant = "default",
  highlight_overrides = {
    Normal = { bg = 'NONE' },
    NormalNC = { bg = 'NONE' },
    CursorLine = { bg = '#222128' },
  },
})
-- vim.cmd([[colorscheme oldworld]])

require("gruvbox").setup({
  terminal_colors = true,
  transparent_mode = true,
})
-- vim.cmd([[colorscheme gruvbox]])

require("bebop").setup({
  transparent = true,
  terminal_colors = true,
  preset = "default",
})
vim.cmd([[colorscheme bebop]])

-- setup lsp servers
vim.lsp.enable({ "lua_ls", "ts_ls", "rust_analyzer", "zls", "ruff", "zuban", "clangd", "gopls", "tinymist", "gleam" })

-- disable the annoying undefined global vim warning
vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" },
      },
    },
  },
})

-- force .h files to be c
vim.filetype.add({
  extension = {
    h = "c",
  },
})


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

  return vim.opt.shell -- fallback to default
end

vim.opt.shell = find_shell()
