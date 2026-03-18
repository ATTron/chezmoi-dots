local state = {
  last_command = "make",
  buf = -1,
  win = -1,
}

local function open_compile_window()
  if not vim.api.nvim_buf_is_valid(state.buf) then
    state.buf = vim.api.nvim_create_buf(false, true)
    vim.bo[state.buf].buftype = "nofile"
    vim.bo[state.buf].bufhidden = "hide"
    vim.bo[state.buf].swapfile = false
    vim.bo[state.buf].buflisted = false
    vim.keymap.set("n", "q", function()
      if vim.api.nvim_win_is_valid(state.win) then
        vim.api.nvim_win_hide(state.win)
      end
    end, { buffer = state.buf })
  end

  if not vim.api.nvim_win_is_valid(state.win) then
    local height = math.floor(vim.o.lines * 0.3)
    vim.cmd("botright " .. height .. "split")
    state.win = vim.api.nvim_get_current_win()
    vim.api.nvim_win_set_buf(state.win, state.buf)
  else
    vim.api.nvim_set_current_win(state.win)
  end
end

local function append(lines)
  if not vim.api.nvim_buf_is_valid(state.buf) then
    return
  end
  lines = vim.tbl_filter(function(l)
    return l ~= ""
  end, lines)
  if #lines == 0 then
    return
  end
  vim.api.nvim_buf_set_lines(state.buf, -1, -1, false, lines)
  if vim.api.nvim_win_is_valid(state.win) then
    local count = vim.api.nvim_buf_line_count(state.buf)
    vim.api.nvim_win_set_cursor(state.win, { count, 0 })
  end
end

local function compile(command)
  state.last_command = command
  open_compile_window()

  vim.bo[state.buf].modifiable = true
  vim.api.nvim_buf_set_lines(state.buf, 0, -1, false, {
    "-*- Compile: " .. command .. " -*-",
    "",
  })

  local start = vim.uv.hrtime()

  vim.fn.jobstart(command, {
    stdout_buffered = false,
    stderr_buffered = false,
    on_stdout = function(_, data)
      if data then
        vim.schedule(function()
          append(data)
        end)
      end
    end,
    on_stderr = function(_, data)
      if data then
        vim.schedule(function()
          append(data)
        end)
      end
    end,
    on_exit = function(_, code)
      local elapsed = (vim.uv.hrtime() - start) / 1e9
      vim.schedule(function()
        local status = code == 0 and "finished" or ("exited with code " .. code)
        append({ "", string.format("Compilation %s (%.1fs)", status, elapsed) })
        vim.cmd("echo ''")
        vim.fn.setqflist({}, "r", {
          title = command,
          lines = vim.api.nvim_buf_get_lines(state.buf, 0, -1, false),
        })
      end)
    end,
  })
end

vim.keymap.set("n", "<leader>cc", function()
  vim.ui.input({ prompt = "Compile: ", default = state.last_command }, function(input)
    if input and input ~= "" then
      compile(input)
    end
  end)
end, { desc = "Compile" })

vim.keymap.set("n", "<leader>cr", function()
  compile(state.last_command)
end, { desc = "Recompile" })
