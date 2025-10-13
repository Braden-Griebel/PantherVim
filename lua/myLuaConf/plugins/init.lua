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
	{ import = "myLuaConf.plugins.languages" },
	{ import = "myLuaConf.plugins.ui" },
})
