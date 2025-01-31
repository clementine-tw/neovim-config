local M = {}

local state = {
	floating = {
		win = -1,
		buf = -1,
	}
}

local function create_floating_terminal(opts)
	opts = opts or {}

	print(vim.inspect({vim.o.columns, vim.o.lines}))
	local width = opts.width or math.floor(vim.o.columns * 0.8)
	local height = opts.height or math.floor(vim.o.lines * 0.8)

	local col = math.floor((vim.o.columns - width) / 2)
	local row = math.floor((vim.o.lines - height) / 2)

	local buf = nil
	if vim.api.nvim_buf_is_valid(opts.buf) then
		buf = opts.buf
	else
		buf = vim.api.nvim_create_buf(false, true)
	end

	local win_config = {
		relative = "editor",
		height = height,
		width = width,
		col = col,
		row = row,
		style = "minimal",
		border = "rounded",
	}

	local win = vim.api.nvim_open_win(buf, true, win_config)

	return { win = win, buf = buf }
end

M.toggle_floating_terminal = function ()
	if vim.api.nvim_win_is_valid(state.floating.win) then
		vim.api.nvim_win_hide(state.floating.win)
	else
		state.floating = create_floating_terminal({ buf = state.floating.buf })
		if vim.bo[state.floating.buf].buftype ~= "terminal" then
			vim.cmd.terminal()
		end
	end
end

return M
