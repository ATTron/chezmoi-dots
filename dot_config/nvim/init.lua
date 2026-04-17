require("vim._core.ui2").enable({})

vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.have_nerd_font = true

vim.opt.showmode = false
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.clipboard = "unnamedplus"
vim.opt.updatetime = 100
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
vim.opt.signcolumn = "yes"
vim.opt.scrolloff = 5
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.breakindent = true
vim.opt.inccommand = "split"
vim.opt.cursorline = true

-- keymaps
vim.keymap.set("n", "-", vim.cmd.Ex)
vim.keymap.set("i", "jk", "<Esc>")
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "[m", "[mzz")
vim.keymap.set("n", "]m", "]mzz")
vim.keymap.set("n", "<A-j>", ":m .+1<CR>==")
vim.keymap.set("n", "<A-k>", ":m .-2<CR>==")
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv")
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")
vim.keymap.set("n", "bn", ":bnext<CR>")
vim.keymap.set("n", "bp", ":bprevious<CR>")
vim.keymap.set("n", "<C-Left>", ":vertical resize -2<CR>")
vim.keymap.set("n", "<C-Right>", ":vertical resize +2<CR>")
vim.keymap.set("n", "<leader>pp", vim.pack.update)

-- autocommands

vim.api.nvim_create_autocmd("FileType", {
  pattern = "netrw",
  callback = function()
    local bsr = { buffer = true, remap = true, silent = true }
    vim.api.nvim_set_hl(0, "netrwMarkFile", { reverse = true, italic = true, bold = true })

    vim.keymap.set("n", "q", "<cmd>bd<CR>", { buffer = true, silent = true, nowait = true })
    vim.keymap.set("n", "<Tab>", "mf", bsr)
    vim.keymap.set("n", "S-Tab", "mF", bsr)

    vim.keymap.set("n", "%", function()
      local dir = vim.b.netrw_curdir or vim.fn.expand("%:p:h")
      vim.ui.input({ prompt = "Enter filename: " }, function(input)
        if input and input ~= "" then
          local filepath = dir .. "/" .. input
          local file_dir = vim.fn.fnamemodify(filepath, ":p:h")
          vim.fn.mkdir(file_dir, "p")
          vim.cmd("!touch " .. vim.fn.shellescape(filepath))
          vim.api.nvim_feedkeys("<C-l>", "n", false)
        end
      end)
    end, { buffer = true, silent = true })
  end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function(args)
    require("conform").format({ bufnr = args.buf })
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
  virtual_text = false,
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
})

-- packages
vim.pack.add({
  { src = "https://github.com/ellisonleao/gruvbox.nvim" },
  { src = "https://github.com/ATTron/bebop.nvim" },
  { src = "https://github.com/neovim/nvim-lspconfig" },
  { src = "https://github.com/stevearc/conform.nvim.git" },
  { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
  { src = "https://github.com/nvim-tree/nvim-web-devicons" },
})

require("conform").setup({
  formatters_by_ft = {
    lua = { "stylua", lsp_format = "fallback" },
    python = { "ruff", "format" },
    rust = { "rustfmt", lsp_format = "fallback" },
    typescript = { "oxfmt", lsp_format = "fallback" },
    javascript = { "oxfmt", lsp_format = "fallback" },
    typescriptreact = { "oxfmt", lsp_format = "fallback" },
    javascriptreact = { "oxfmt", lsp_format = "fallback" },
    c = { lsp_format = "fallback" },
    zig = { lsp_format = "zig", "fmt" },
  },
})

require("nvim-treesitter.configs").setup({
  ensure_installed = { "lua", "c", "vim", "typescript", "tsx", "javascript", "zig", "rust", "python" },
  auto_install = true,
  highlight = { enable = true },
  indent = { enable = true, disable = { "c" } },
})

vim.opt.background = "dark"

local colorschemes = { "gruvbox", "bebop" }

require("gruvbox").setup({
  terminal_colors = true,
  transparent_mode = true,
})

-- see you <leader> cowboy
require("bebop").setup({
  transparent = true,
  terminal_colors = true,
  preset = "default",
})
vim.cmd([[colorscheme bebop]])

vim.keymap.set("n", "<leader>cs", function()
  vim.ui.select(colorschemes, {
    prompt = "Select colorscheme:",
    format_item = function(item)
      local current = vim.g.colors_name or "default"
      return (item == current and "● " or "  ") .. item
    end,
  }, function(choice)
    if choice then
      vim.cmd("colorscheme " .. choice)
    end
  end)
end, { desc = "Select colorscheme" })

vim.lsp.enable({ "lua_ls", "tsgo", "oxlint", "rust_analyzer", "zls", "ty", "clangd", "gopls", "gleam" })

vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" },
      },
    },
  },
})

vim.filetype.add({
  extension = {
    h = "c",
  },
})

-- shell detection
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

  return vim.opt.shell
end

vim.opt.shell = find_shell()

function BebopReload(p)
  for k, _ in pairs(package.loaded) do
    if k:match("^bebop") then
      package.loaded[k] = nil
    end
  end
  require("bebop").setup({ preset = p or "default" })
end

-- netrw things
vim.g.netrw_liststyle = 1
vim.g.netrw_sort_by = "size"
vim.g.netrw_banner = 1
vim.g.netrw_sizestyle = "H"
vim.g.netrw_bufsettings = "noma nomod nonu nobl nowrap"
