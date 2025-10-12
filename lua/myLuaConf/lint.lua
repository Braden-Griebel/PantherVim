require("lze").load({
	{
		"nvim-lint",
		for_cat = "languages",
		-- cmd = { "" },
		event = "FileType",
		-- ft = "",
		-- keys = "",
		-- colorscheme = "",
		after = function(plugin)
			require("lint").linters_by_ft = {
				-- NOTE: download some linters in lspsAndRuntimeDeps
				-- and configure them here
				-- markdown = {'vale',},
				-- javascript = { 'eslint' },
				-- typescript = { 'eslint' },
				markdown = { "markdownlint-cli2" },
				bash = { "shellcheck" },
				python = { "mypy" },
				javascript = { "oxlint", "eslint" },
			}

			vim.api.nvim_create_autocmd({ "BufWritePost" }, {
				callback = function()
					require("lint").try_lint()
				end,
			})
		end,
	},
})
