return {
	{
		"oil.nvim",
		for_cat = "editor.extras",
		cmd = { "Oil" },
		keys = {
			{ "-", "<cmd>Oil<CR>", mode = { "n" }, desc = "Open Parent Directory" },
			{ "<leader>-", "<cmd>Oil .<CR>", mode = { "n" }, desc = "Open nvim root directory" },
		},
		before = function(plugin)
			vim.g.loaded_netrwPlugin = 1
		end,
		after = function(plugin)
			require("oil").setup({
				default_file_explorer = true,
				view_options = {
					show_hidden = true,
				},
				columns = {
					"icon",
					"permissions",
					"size",
					"mtime",
				},
				keymaps = {
					["g?"] = "actions.show_help",
					["<CR>"] = "actions.select",
					["<C-s>"] = "actions.select_vsplit",
					["<C-h>"] = "actions.select_split",
					["<C-t>"] = "actions.select_tab",
					["<C-p>"] = "actions.preview",
					["<C-c>"] = "actions.close",
					["<C-l>"] = "actions.refresh",
					["-"] = "actions.parent",
					["_"] = "actions.open_cwd",
					["`"] = "actions.cd",
					["~"] = "actions.tcd",
					["gs"] = "actions.change_sort",
					["gx"] = "actions.open_external",
					["g."] = "actions.toggle_hidden",
					["g\\"] = "actions.toggle_trash",
				},
			})
		end,
	},
}
