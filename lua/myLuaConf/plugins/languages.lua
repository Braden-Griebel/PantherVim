local load_w_after = function(name)
	vim.cmd.packadd(name)
	vim.cmd.packadd(name .. "/after")
end

return {
	{
		"cmp-cmdline",
		for_cat = "languages",
		on_plugin = { "blink.cmp" },
		load = load_w_after,
	},
	{
		"blink.compat",
		for_cat = "languages",
		dep_of = { "cmp-cmdline" },
	},
	{
		"luasnip",
		for_cat = "languages",
		dep_of = { "blink.cmp" },
		after = function(_)
			local luasnip = require("luasnip")
			require("luasnip.loaders.from_vscode").lazy_load()
			luasnip.config.setup({})

			local ls = require("luasnip")

			vim.keymap.set({ "i", "s" }, "<M-n>", function()
				if ls.choice_active() then
					ls.change_choice(1)
				end
			end)
		end,
	},
	{
		"colorful-menu.nvim",
		for_cat = "languages",
		on_plugin = { "blink.cmp" },
	},
	{
		"blink.cmp",
		for_cat = "languages",
		event = "DeferredUIEnter",
		after = function(_)
			require("blink.cmp").setup({
				-- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
				-- See :h blink-cmp-config-keymap for configuring keymaps
				keymap = {
					preset = "enter",
				},
				cmdline = {
					enabled = true,
					completion = {
						menu = {
							auto_show = true,
						},
					},
					sources = function()
						local type = vim.fn.getcmdtype()
						-- Search forward and backward
						if type == "/" or type == "?" then
							return { "buffer" }
						end
						-- Commands
						if type == ":" or type == "@" then
							return { "cmdline", "cmp_cmdline" }
						end
						return {}
					end,
				},
				fuzzy = {
					sorts = {
						"exact",
						-- defaults
						"score",
						"sort_text",
					},
				},
				signature = {
					enabled = false,
					-- window = {
					-- 	show_documentation = true,
					-- },
				},
				completion = {
					menu = {
						draw = {
							treesitter = { "lsp" },
							components = {
								label = {
									text = function(ctx)
										return require("colorful-menu").blink_components_text(ctx)
									end,
									highlight = function(ctx)
										return require("colorful-menu").blink_components_highlight(ctx)
									end,
								},
							},
						},
					},
					documentation = {
						auto_show = true,
					},
				},
				snippets = {
					preset = "luasnip",
					active = function(filter)
						local snippet = require("luasnip")
						local blink = require("blink.cmp")
						if snippet.in_snippet() and not blink.is_visible() then
							return true
						else
							if not snippet.in_snippet() and vim.fn.mode() == "n" then
								snippet.unlink_current()
							end
							return false
						end
					end,
				},
				sources = {
					default = { "lsp", "path", "snippets", "buffer", "omni" },
					providers = {
						path = {
							score_offset = 50,
						},
						lsp = {
							score_offset = 40,
						},
						snippets = {
							score_offset = 40,
						},
						cmp_cmdline = {
							name = "cmp_cmdline",
							module = "blink.compat.source",
							score_offset = -100,
							opts = {
								cmp_name = "cmdline",
							},
						},
					},
				},
			})
		end,
	},
	-- Markdown
	{
		"render-markdown.nvim",
		for_cat = "languages.markdown",
		ft = { "markdown" },
		after = function(plugin)
			require("render-markdown").setup({})
		end,
	},
	-- R
	{
		"rnvim",
		for_cat = "languages.r",
		ft = { "r" },
		after = function(plugin)
			local opts = {
				hook = {
					on_filetype = function()
						vim.api.nvim_buf_set_keymap(0, "n", "<Enter>", "<Plug>RDSendLine", {})
						vim.api.nvim_buf_set_keymap(0, "v", "<Enter>", "<Plug>RSendSelection", {})
					end,
				},
				R_args = { "--quiet", "--no-save" },
				min_editor_width = 72,
				rconsole_width = 78,
				objbr_mappings = { -- Object browser keymap
					c = "class", -- Call R functions
					["<localleader>gg"] = "head({object}, n = 15)", -- Use {object} notation to write arbitrary R code.
					v = function()
						require("r.browser").toggle_view()
					end,
				},
				disable_cmds = {
					"RClearConsole",
					"RCustomStart",
					"RSPlot",
					"RSaveClose",
				},
			}
			if vim.env.R_AUTO_START == "true" then
				opts.auto_start = "on startup"
				opts.objbr_auto_start = true
			end
			require("r").setup()
		end,
	},
	-- Lean
	{
		"lean.nvim",
		event = { "BufReadPre *.lean", "BufNewFile *.lean" },
		after = function(plugin)
			require("lean").setup({ mappings = true })
		end,
	},
	-- Rust
	{
		"crates.nvim",
		event = { "BufRead Cargo.toml" },
		after = function(plugin)
			require("crates").setup()
		end,
	},
}
