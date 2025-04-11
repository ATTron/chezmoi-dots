return {
  "nvim-neorg/neorg",
  lazy = false, -- Disable lazy loading as some `lazy.nvim` distributions set `lazy = true` by default
  version = "*", -- Pin Neorg to the latest stable release
  config = function()
    require("neorg").setup({
      load = {
        ["core.defaults"] = {},
        ["core.summary"] = {},
        ["core.qol.toc"] = {},
        ["core.qol.todo_items"] = {},
        ["core.concealer"] = {
          config = {
            folds = true,
            icon_preset = "varied",
            init_open_folds = "never",
          },
        },
        ["core.dirman"] = {
          config = {
            workspaces = {
              notes = "~/notes",
            },
            default_workspace = "notes",
          },
        },
        ["core.esupports.metagen"] = { config = { update_date = false } },
      },
    })

    vim.api.nvim_create_autocmd("Filetype", {
      pattern = "norg",
      callback = function()
        vim.keymap.set("i", "<S-CR>", "<Plug>(neorg.itero.next-iteration)", { buffer = true })
      end,
    })
    -- vim.wo.foldlevel = 0
    -- vim.wo.conceallevel = 2
  end,
}
