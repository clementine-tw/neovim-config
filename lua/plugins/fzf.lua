return {
	"ibhagwan/fzf-lua",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	opts = {
		"hide",
		files = {
			cwd_prompt = false,
		},
	},
	keys = {
		{
			"<leader>fh",
			function()
				require("fzf-lua").helptags()
			end,
			desc = "Find help tags",
		},
		{
			"<leader>fm",
			function()
				require("fzf-lua").manpages()
			end,
			desc = "Find man pages",
		},
		{
			"<leader>ff",
			function()
				require("fzf-lua").files()
			end,
			desc = "Find files",
		},
		{
			"<leader>fb",
			function()
				require("fzf-lua").buffers()
			end,
			desc = "Find buffers",
		},
		{
			"<leader>fr",
			function()
				require("fzf-lua").lsp_references()
			end,
			desc = "Find references",
		},
		{
			"<leader>fed",
			function()
				require("fzf-lua").lsp_document_diagnostics()
			end,
		},
		{
			"<leader>few",
			function()
				require("fzf-lua").lsp_workspace_diagnostics()
			end,
		},
	},
}
