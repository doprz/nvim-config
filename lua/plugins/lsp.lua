return {
	{
		"mason-org/mason.nvim",
		dependencies = {
			"neovim/nvim-lspconfig",
			"mason-org/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
		},
		config = function()
			-- NOTE: Don't install rust_analyzer as rustaceanvim takes care of it
			require("mason").setup()
			require("mason-lspconfig").setup()
			require("mason-tool-installer").setup({
				ensure_installed = {
					-- "lua_ls",
					-- "stylua",
				},
			})

			-- Enable inlay hints + toggle
			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(args)
					local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
					if client.server_capabilities.inlayHintProvider then
						vim.lsp.inlay_hint.enable(true)
					end
				end,
			})
			vim.keymap.set("n", "<leader>i", function()
				vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ 0 }), { 0 })
			end)

			vim.lsp.config("lua_ls", {
				settings = {
					Lua = {
						runtime = {
							version = "LuaJIT",
						},
						diagnostics = {
							globals = {
								"vim",
								"require",
							},
						},
						workspace = {
							library = vim.api.nvim_get_runtime_file("", true),
						},
						telemetry = {
							enable = false,
						},
						hint = {
							enable = true,
							arrayIndex = "Enable",
							await = true,
							paramName = true,
							paramType = true,
							setType = true,
						},
					},
				},
			})

			vim.lsp.config("vtsls", {
				settings = {
					typescript = {
						inlayHints = {
							parameterNames = {
								enabled = true,
							},
							parameterTypes = {
								enabled = true,
							},
							variableTypes = {
								enabled = true,
							},
							propertyDeclarationTypes = {
								enabled = true,
							},
							functionLikeReturnTypes = {
								enabled = true,
							},
							enumMemberValues = {
								enabled = true,
							},
						},
					},
				},
			})

			require("lspconfig").nixd.setup({
				cmd = { "nixd" },
				-- NOTE: export NIXD_FLAGS="--inlay-hints=true"
				settings = {
					nixd = {
						nixpkgs = {
							expr = "import (builtins.getFlake(toString ./.)).inputs.nixpkgs { }",
						},
						formatting = {
							command = { "nixfmt" },
						},
						options = {
							-- nixos = {
							-- 	expr = "let flake = builtins.getFlake(toString ./.); in flake.nixosConfigurations.[HOST_NAME_HERE].options",
							-- },
							home_manager = {
								expr = "let flake = builtins.getFlake(toString ./.); in flake.homeConfigurations.doprz.options",
							},
						},
					},
				},
			})

			-- conform.nvim takes care of this
			-- vim.api.nvim_create_autocmd("BufWritePre", {
			--   buffer = buffer,
			--   callback = function()
			--     vim.lsp.buf.format { async = false }
			--   end
			-- })
		end,
	},
	{
		"stevearc/conform.nvim",
		opts = {},
		config = function()
			require("conform").setup({
				format_on_save = {
					-- These options will be passed to conform.format()
					timeout_ms = 500,
					lsp_format = "fallback",
				},
				formatters_by_ft = {
					lua = { "stylua" },
					-- Conform will run multiple formatters sequentially
					python = { "isort", "black" },
					-- You can customize some of the format options for the filetype (:help conform.format)
					rust = { "rustfmt" },
					-- Conform will run the first available formatter
					javascript = { "prettierd", "prettier", stop_after_first = true },
				},
			})
		end,
	},
	{
		"mrcjkb/rustaceanvim",
		version = "^6", -- Recommended
		lazy = false, -- This plugin is already lazy
	},
}
