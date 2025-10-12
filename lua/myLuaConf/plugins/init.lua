local colorschemeName = nixCats("colorscheme")
if not require("nixCatsUtils").isNixCats then
	colorschemeName = "rose-pine"
end
vim.cmd.colorscheme(colorschemeName)

local ok, notify = pcall(require, "notify")
if ok then
	notify.setup({
		on_open = function(win)
			vim.api.nvim_win_set_config(win, { focusable = false })
		end,
	})
	vim.notify = notify
	vim.keymap.set("n", "<Esc>", function()
		notify.dismiss({ silent = true })
	end, { desc = "dismiss notify popup and clear hlsearch" })
end

require("lze").load({
	{ import = "myLuaConf.plugins.coding" },
	{ import = "myLuaConf.plugins.editor" },
	{ import = "myLuaConf.plugins.completion" },
	{
		"markdown-preview.nvim",
		-- NOTE: for_cat is a custom handler that just sets enabled value for us,
		-- based on result of nixCats('cat.name') and allows us to set a different default if we wish
		-- it is defined in luaUtils template in lua/nixCatsUtils/lzUtils.lua
		-- you could replace this with enabled = nixCats('cat.name') == true
		-- if you didnt care to set a different default for when not using nix than the default you already set
		for_cat = "languages.markdown",
		cmd = { "MarkdownPreview", "MarkdownPreviewStop", "MarkdownPreviewToggle" },
		ft = "markdown",
		keys = {
			{ "<leader>mp", "<cmd>MarkdownPreview <CR>", mode = { "n" }, noremap = true, desc = "markdown preview" },
			{
				"<leader>ms",
				"<cmd>MarkdownPreviewStop <CR>",
				mode = { "n" },
				noremap = true,
				desc = "markdown preview stop",
			},
			{
				"<leader>mt",
				"<cmd>MarkdownPreviewToggle <CR>",
				mode = { "n" },
				noremap = true,
				desc = "markdown preview toggle",
			},
		},
		before = function(plugin)
			vim.g.mkdp_auto_close = 0
		end,
	},
	-- {
	--   "hlargs",
	--   for_cat = 'general.extra',
	--   event = "DeferredUIEnter",
	--   -- keys = "",
	--   dep_of = { "nvim-lspconfig" },
	--   after = function(plugin)
	--     require('hlargs').setup {
	--       color = '#32a88f',
	--     }
	--     vim.cmd([[hi clear @lsp.type.parameter]])
	--     vim.cmd([[hi link @lsp.type.parameter Hlargs]])
	--   end,
	-- },
	{
		"lualine.nvim",
		for_cat = "editor",
		-- cmd = { "" },
		event = "DeferredUIEnter",
		-- ft = "",
		-- keys = "",
		-- colorscheme = "",
		after = function(plugin)
			require("lualine").setup({
				options = {
					icons_enabled = false,
					theme = colorschemeName,
					component_separators = "|",
					section_separators = "",
				},
				sections = {
					lualine_c = {
						{
							"filename",
							path = 1,
							status = true,
						},
					},
				},
				inactive_sections = {
					lualine_b = {
						{
							"filename",
							path = 3,
							status = true,
						},
					},
					lualine_x = { "filetype" },
				},
				tabline = {
					lualine_a = { "buffers" },
					-- if you use lualine-lsp-progress, I have mine here instead of fidget
					-- lualine_b = { 'lsp_progress', },
					lualine_z = { "tabs" },
				},
			})
		end,
	},
})
