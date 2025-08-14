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
    enabed = false,
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

-- setup lsp commands
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
  callback = function(event)
    vim.keymap.set("n", "gd", "<cmd>lua Snacks.picker.lsp_definitions()<cr>")
    vim.keymap.set("n", "gD", "<cmd>lua Snacks.picker.lsp_declarations()<cr>")
    vim.keymap.set("n", "gr", "<cmd>lua Snacks.picker.lsp_references()<cr>")
    vim.keymap.set("n", "<leader>K", vim.lsp.buf.hover)

    local client = vim.lsp.get_client_by_id(event.data.client_id)
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
      vim.lsp.inlay_hint.enable(true)
    end
  end,
})

-- file picker
-- vim.keymap.set("n", "<leader>sf", "<cmd>lua Snacks.picker.files({})<cr>")
