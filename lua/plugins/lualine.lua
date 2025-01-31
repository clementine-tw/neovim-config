return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	opts = {
		sections = {
			lualine_a = { "mode" },
			lualine_b = { "branch", "diff", "diagnostics" },
			lualine_c = { "filename" },
			lualine_x = {
				"encoding",
				{
					"fileformat",
					symbols = { unix = "unix", dos = "dos", mac = "mac" },
				},
				"filetype",
				{
					function()
						local clients = vim.lsp.get_active_clients()
						if next(clients) == nil then
							return "No LSP"
						end
						local lsp_names = {}
						for _, client in ipairs(clients) do
							if
								client.attached_buffers[vim.api.nvim_get_current_buf()]
							then
								table.insert(lsp_names, client.name)
							end
						end
						return "[" .. table.concat(lsp_names, ", ") .. "]"
					end,
					icon = "LSP ",
					color = { fg = "#ffaa00", gui = "bold" },
				},
			},
			lualine_y = { "progress" },
			lualine_z = { "location" },
		},
		extensions = {
			"fzf",
			"lazy",
			"man",
			"mason",
		},
	},
}
