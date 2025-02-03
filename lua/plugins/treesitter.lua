return {
	"nvim-treesitter/nvim-treesitter",
	name = "treesitter",
	build = ":TSUpdate",
	main = "nvim-treesitter.configs",
	opts = {
		ensure_installed = {
			"c",
			"cpp",
			"lua",
			"go",
			"gomod",
			"gosum",
			"gowork",
			"javascript",
			"typescript",
			"tsx",
			"json",
			"css",
			"html",
		},
		highlight = {
			enable = true,
			additional_vim_regex_highlighting = false,
		},
	},
}
