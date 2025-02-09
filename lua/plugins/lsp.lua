return {
	{
		"mfussenegger/nvim-lint",
		lazy = true,
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			local lint = require("lint")

			lint.linters_by_ft = {
				go = { "golangcilint" },
			}

			local lint_augroup =
				vim.api.nvim_create_augroup("lint", { clear = true })
			-- 自動在 Buffer 儲存時執行 Lint
			vim.api.nvim_create_autocmd(
				{ "BufWritePost", "BufReadPost", "InsertLeave" },
				{
					group = lint_augroup,
					callback = function()
						require("lint").try_lint()
					end,
				}
			)

			-- open full message
			vim.keymap.set("n", "<leader>em", function()
				vim.diagnostic.open_float({ border = "rounded" })
			end, { desc = "Open full diagnostic message in float window" })
		end,
	},
	{
		"williamboman/mason.nvim",
		build = ":MasonUpdate",
	},
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = { { "mason.nvim", opts = {} } },
		opts = {
			ensure_installed = {
				"lua_ls",
				"gopls",
				"ts_ls",
				"eslint",
				"tailwindcss",
			},
			automatic_installation = true,
		},
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"mason.nvim",
			"mason-lspconfig.nvim",
			{
				"folke/lazydev.nvim",
				ft = "lua", -- only load on lua files
				opts = {
					library = {
						-- See the configuration section for more details
						-- Load luvit types when the `vim.uv` word is found
						{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
					},
				},
			},
			"saghen/blink.cmp",
		},
		config = function()
			-- 自動重新顯示偵錯訊息
			vim.api.nvim_create_autocmd({ "BufEnter" }, {
				callback = function()
					vim.diagnostic.open_float(nil, { focusable = false })
				end,
			})

			-- 確保 `LspAttach` 只執行一次
			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(args)
					local client = vim.lsp.get_client_by_id(args.data.client_id)
					if not client then
						return
					end

					vim.lsp.handlers["textDocument/hover"] =
						vim.lsp.with(vim.lsp.handlers.hover, {
							border = "rounded", -- 圓角邊框（可用 "single", "double", "solid" 等）
						})
				end,
			})

			-- Set up lspconfig.
			local capabilities = require("blink.cmp").get_lsp_capabilities()
			local lspconfig = require("lspconfig")

			lspconfig.lua_ls.setup({
				capabilities = capabilities,
				on_init = function(client)
					if client.workspace_folders then
						local path = client.workspace_folders[1].name
						if
							vim.loop.fs_stat(path .. "/.luarc.json")
							or vim.loop.fs_stat(path .. "/.luarc.jsonc")
						then
							return
						end
					end

					client.config.settings.Lua = vim.tbl_deep_extend(
						"force",
						client.config.settings.Lua,
						{
							runtime = {
								-- Tell the language server which version of Lua you're using
								-- (most likely LuaJIT in the case of Neovim)
								version = "LuaJIT",
							},
							-- Make the server aware of Neovim runtime files
							workspace = {
								checkThirdParty = false,
								library = {
									vim.env.VIMRUNTIME,
									-- Depending on the usage, you might want to add additional paths here.
									-- "${3rd}/luv/library"
									-- "${3rd}/busted/library",
								},
								-- or pull in all of 'runtimepath'. NOTE: this is a lot slower and will cause issues when working on your own configuration (see https://github.com/neovim/nvim-lspconfig/issues/3189)
								-- library = vim.api.nvim_get_runtime_file("", true)
							},
						}
					)
				end,
				settings = {
					Lua = {},
				},
			})

			lspconfig.gopls.setup({
				capabilities = capabilities,
				cmd = { "gopls" },
				filetypes = { "go", "gomod", "gowork", "gotmpl" },
				root_dir = lspconfig.util.root_pattern(
					"go.work",
					"go.mod",
					".git"
				),
				settings = {
					gopls = {
						analyses = {
							unusedparams = true, -- 檢查未使用的參數
							unusedwrite = true, -- 檢查未使用的變數賦值
							shadow = true, -- 檢查變數遮蔽（shadowing）
							nilness = true, -- 檢查 nil 相關問題
						},
						staticcheck = true, -- 啟用 Staticcheck（更強大的靜態分析）
						gofumpt = true, -- 使用 gofumpt 格式化代碼
						usePlaceholders = false, -- 自動補全時插入參數占位符
						completeUnimported = true, -- 自動補全時建議未匯入的套件
						directoryFilters = { "-node_modules" }, -- 避免掃描 node_modules
						semanticTokens = true, -- 啟用語義高亮
						hints = {
							assignVariableTypes = true, -- 顯示變數類型提示
							compositeLiteralFields = true, -- 顯示 struct 欄位名稱提示
							compositeLiteralTypes = true, -- 顯示 struct 類型提示
							constantValues = true, -- 顯示常數值
							functionTypeParameters = true, -- 顯示函式類型參數
							parameterNames = true, -- 顯示函式參數名稱
							rangeVariableTypes = true, -- 顯示 range 變數類型
						},
						matcher = "Fuzzy", -- 使用模糊匹配補全
						experimentalPostfixCompletions = true, -- 啟用後綴補全
						diagnosticsDelay = "500ms", -- 延遲診斷錯誤的時間
						codelenses = {
							generate = true, -- 顯示 `go generate` 的 CodeLens
							gc_details = true, -- 顯示垃圾回收資訊
							test = true, -- 顯示測試相關的 CodeLens
						},
						linksInHover = true, -- 允許 hover 訊息中包含超連結
					},
				},
			})

			lspconfig.ts_ls.setup({
				capabilities = capabilities,
				on_attach = function(client, bufnr)
					client.server_capabilities.documentFormattingProvider =
						false
				end,
			})

			lspconfig.eslint.setup({
				capabilities = capabilities,
				on_attach = function(client, bufnr)
					client.server_capabilities.documentFormattingProvider =
						false
					-- vim.api.nvim_create_autocmd("BufWritePre", {
					-- 	buffer = bufnr,
					-- 	command = "EslintFixAll",
					-- })
				end,
			})

			lspconfig.tailwindcss.setup({
				capabilities = capabilities,
				on_attach = function(client, bufnr)
					-- 這裡可以加上你需要的 LSP 附加功能
				end,
				settings = {
					tailwindCSS = {
						experimental = {
							classRegex = {
								"tw`([^`]*)`",
								'tw="([^"]*)"',
								"tw\\.\\w+`([^`]*)`",
							},
						},
					},
				},
			})
		end,
	},
}
