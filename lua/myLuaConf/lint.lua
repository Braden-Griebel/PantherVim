require("lze").load({
	{
		"nvim-lint",
		for_cat = "languages",
		event = "FileType",
		after = function(_)
			require("lint").linters_by_ft = {
				markdown = { "markdownlint-cli2" },
				bash = { "shellcheck" },
				python = { "mypy" },
				javascript = { "oxlint", "eslint" },
				typscript = { "eslint" },
			}

			vim.api.nvim_create_autocmd({ "BufWritePost" }, {
				callback = function()
					require("lint").try_lint()
				end,
			})
		end,
	},
})
