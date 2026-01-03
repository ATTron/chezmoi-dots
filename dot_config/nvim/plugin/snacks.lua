vim.pack.add({
  { src = "https://github.com/folke/snacks.nvim" },
})

require("snacks").setup({
  bigfile = { enabled = false },
  dashboard = { enabled = false },
  explorer = { enabled = false },
  git = { enabled = true },
  indent = { enabled = false },
  input = { enabled = false },
  lazygit = { enabled = false },
  picker = {
    prompt = "🦆 ",
    ui_select = false,
    enabled = true,
    formatters = {
      file = {
        truncate = 80,
      },
    },
    win = {
      input = {
        keys = {
          ["<Tab>"] = { "list_down", mode = { "n", "i" } },
          ["<S-Tab>"] = { "list_up", mode = { "n", "i" } },
        },
      },
    },
  },
  notifier = { enabled = false },
  quickfile = { enabled = true },
  rename = { enabled = true },
  scope = { enabled = true },
  scroll = { enabled = false },
  statuscolumn = { enabled = true },
  toggle = { enabled = true },
  words = { enabled = false },
})

-- rename autocmd
local Snacks = require("snacks")
vim.api.nvim_create_autocmd("User", {
  pattern = "OilActionsPost",
  callback = function(event)
    if event.data.actions.type == "move" then
      Snacks.rename.on_rename_file(event.data.actions.src_url, event.data.actions.dest_url)
    end
  end,
})

-- setup lsp commands
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
  callback = function(event)
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    vim.keymap.set("n", "gd", "<cmd>lua Snacks.picker.lsp_definitions()<cr>")
    vim.keymap.set("n", "gD", "<cmd>lua Snacks.picker.lsp_declarations()<cr>")
    vim.keymap.set("n", "gr", "<cmd>lua Snacks.picker.lsp_references()<cr>")
    vim.keymap.set({ "n", "x" }, "<Leader>ca", vim.lsp.buf.code_action)
    vim.keymap.set("n", "<leader>K", vim.lsp.buf.hover)

    if client and client.server_capabilities.documentHighlightProvider then
      vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
        buffer = event.buf,
        callback = vim.lsp.buf.document_highlight,
      })

      vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
        buffer = event.buf,
        callback = vim.lsp.buf.clear_references,
      })
    end
    if client.server_capabilities.inlayHintProvider then
      vim.g.inlay_hints_visible = true
      vim.lsp.inlay_hint.enable(true, { bufnr = event.buf })
    end
  end,
})
