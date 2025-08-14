vim.pack.add({
  { src = "https://github.com/nvim-orgmode/orgmode" }
})

require('orgmode').setup({
  org_agenda_files = '~/notes/**/*'
})
