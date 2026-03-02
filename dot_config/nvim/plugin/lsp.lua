vim.pack.add({
  { src = "https://github.com/DNLHC/glance.nvim" },
})

require("glance").setup({
  border = {
    enable = true,
  },
  list = {
    position = "left",
    width = 0.3,
  },
  theme = {
    enable = true,
    mode = "darken",
  },
  winbar = {
    enable = true,
  },
  hooks = {
    before_open = function(results, open, jump, method)
      if #results == 1 then
        jump(results[1])
      else
        open(results)
      end
    end,
  },
})

-- setup lsp commands
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
  callback = function(event)
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    vim.keymap.set("n", "gd", "<cmd>Glance definitions<CR>")
    vim.keymap.set("n", "gD", "<cmd>Glance type_definitions<CR>")
    vim.keymap.set("n", "gr", "<cmd>Glance references<CR>")
    vim.keymap.set("n", "<leader>R", vim.lsp.buf.rename)
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
