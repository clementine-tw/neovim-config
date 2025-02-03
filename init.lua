require("config.lazy")
-- leader key
-- vim.g.mapleader = " "
-- vim.g.maplocalleader = " "

-- [[ vim options ]]
-- line number
vim.opt.number = true
vim.opt.relativenumber = true

-- Save undo history
vim.opt.undofile = true

-- Open signcolumn by default
vim.opt.signcolumn = "yes"

-- Decrease update time
vim.opt.updatetime = 500

-- Decrease timeoutlen
vim.opt.timeoutlen = 300

-- Enable "List mode" in editor
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Preview substitutions live in a split window, as you type!
vim.opt.inccommand = "split"

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor
vim.opt.scrolloff = 10

-- Set tab size
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4

-- Don't insert "spaces" when I type "<TAB>" in insert mode
vim.opt.expandtab = false

-- [[ Keymaps ]]

vim.keymap.set("n", "<leader>ee", ":Ex<cr>")

-- insert next line
vim.keymap.set("i", "<S-CR>", "<ESC>o")

-- Clear highlights on search
vim.keymap.set("n", "<ESC>", "<cmd>nohlsearch<cr>")

-- Exit "Terminal" mode
vim.keymap.set("t", "<ESC><ESC>", "<C-\\><C-n>", { noremap = true })
-- Toggle terminal window
vim.keymap.set(
	{ "n", "t" },
	"<C-/>",
	require("floaterminal").toggle_floating_terminal
)

-- Write buffer
vim.keymap.set("n", "<C-s>", "<cmd>w<cr>")
vim.keymap.set("i", "<C-s>", "<ESC><cmd>w<cr>", { noremap = true })

vim.keymap.set("v", "J", ":m '>+1<cr>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<cr>gv=gv")

-- [[ Basic Autocommands ]]
-- see `:h lua-guide-autocommands`

-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup(
		"kickstart-highlight-yank",
		{ clear = true }
	),
	callback = function()
		vim.highlight.on_yank()
	end,
})
