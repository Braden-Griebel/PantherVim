require("lze").load({
	{
		"conform.nvim",
		for_cat = "languages",
		-- cmd = { "" },
		-- event = "",
		-- ft = "",
		keys = {
			{ "<leader>FF", desc = "[F]ormat [F]ile" },
		},
		-- colorscheme = "",
		after = function(plugin)
			local conform = require("conform")

			conform.setup({
				formatters_by_ft = {
					lua = { "stylua" },
					bash = { "shfmt" },
					markdown = { "mdformat" },
					typst = { "typstyle" },
					nix = { "alejandra" },
				},
				formatters = {
					typstyle = {
						command = "typstyle",
						stdin = true,
						args = { "--wrap-text" },
					},
				},
			})

			vim.keymap.set({ "n", "v" }, "<leader>FF", function()
				conform.format({
					lsp_fallback = true,
					async = false,
					timeout_ms = 1000,
				})
			end, { desc = "[F]ormat [F]ile" })
		end,
	},
})
