-- Custom live_grep function to search in git root
local function live_grep_git_root()
	local git_root = require("myLuaConf.myUtils").find_git_root()
	if git_root then
		require("telescope.builtin").live_grep({
			search_dirs = { git_root },
		})
	end
end

local function copy_path(state)
	-- NeoTree is based on [NuiTree](https://github.com/MunifTanjim/nui.nvim/tree/main/lua/nui/tree)
	-- The node is based on [NuiNode](https://github.com/MunifTanjim/nui.nvim/tree/main/lua/nui/tree#nuitreenode)
	local node = state.tree:get_node()
	local filepath = node:get_id()
	local filename = node.name
	local modify = vim.fn.fnamemodify

	local results = {
		filepath,
		modify(filepath, ":."),
		modify(filepath, ":~"),
		filename,
		modify(filename, ":r"),
		modify(filename, ":e"),
	}

	vim.ui.select({
		"1. Absolute path: " .. results[1],
		"2. Path relative to CWD: " .. results[2],
		"3. Path relative to HOME: " .. results[3],
		"4. Filename: " .. results[4],
		"5. Filename without extension: " .. results[5],
		"6. Extension of the filename: " .. results[6],
	}, { prompt = "Choose to copy to clipboard:" }, function(choice)
		if choice then
			local i = tonumber(choice:sub(1, 1))
			if i then
				local result = results[i]
				vim.fn.setreg('"', result)
				vim.notify("Copied: " .. result)
			else
				vim.notify("Invalid selection")
			end
		else
			vim.notify("Selection cancelled")
		end
	end)
end

return {
	-- Files category
	{
		"oil.nvim",
		for_cat = "editor.files",
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
	{
		"neo-tree.nvim",
		for_cat = "editor.files",
		after = function(plugin)
			require("neo-tree").setup({
				filesystem = {
					window = {
						mappings = {
							["\\"] = "close_window",
							["Y"] = copy_path,
						},
					},
				},
			})
		end,
		keys = {
			{ "\\", ":Neotree reveal<CR>", desc = "NeoTree reveal", silent = true },
		},
	},
	-- git category
	{
		"gitsigns.nvim",
		for_cat = "editor.git",
		event = "DeferredUIEnter",
		-- cmd = { "" },
		-- ft = "",
		-- keys = "",
		-- colorscheme = "",
		after = function(plugin)
			require("gitsigns").setup({
				-- See `:help gitsigns.txt`
				signs = {
					add = { text = "+" },
					change = { text = "~" },
					delete = { text = "_" },
					topdelete = { text = "‾" },
					changedelete = { text = "~" },
				},
				on_attach = function(bufnr)
					local gs = package.loaded.gitsigns

					local function map(mode, l, r, opts)
						opts = opts or {}
						opts.buffer = bufnr
						vim.keymap.set(mode, l, r, opts)
					end

					-- Navigation
					map({ "n", "v" }, "]c", function()
						if vim.wo.diff then
							return "]c"
						end
						vim.schedule(function()
							gs.next_hunk()
						end)
						return "<Ignore>"
					end, { expr = true, desc = "Jump to next hunk" })

					map({ "n", "v" }, "[c", function()
						if vim.wo.diff then
							return "[c"
						end
						vim.schedule(function()
							gs.prev_hunk()
						end)
						return "<Ignore>"
					end, { expr = true, desc = "Jump to previous hunk" })

					-- Actions
					-- visual mode
					map("v", "<leader>hs", function()
						gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
					end, { desc = "stage git hunk" })
					map("v", "<leader>hr", function()
						gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
					end, { desc = "reset git hunk" })
					-- normal mode
					map("n", "<leader>gs", gs.stage_hunk, { desc = "git stage hunk" })
					map("n", "<leader>gr", gs.reset_hunk, { desc = "git reset hunk" })
					map("n", "<leader>gS", gs.stage_buffer, { desc = "git Stage buffer" })
					map("n", "<leader>gu", gs.undo_stage_hunk, { desc = "undo stage hunk" })
					map("n", "<leader>gR", gs.reset_buffer, { desc = "git Reset buffer" })
					map("n", "<leader>gp", gs.preview_hunk, { desc = "preview git hunk" })
					map("n", "<leader>gb", function()
						gs.blame_line({ full = false })
					end, { desc = "git blame line" })
					map("n", "<leader>gd", gs.diffthis, { desc = "git diff against index" })
					map("n", "<leader>gD", function()
						gs.diffthis("~")
					end, { desc = "git diff against last commit" })

					-- Toggles
					map("n", "<leader>gtb", gs.toggle_current_line_blame, { desc = "toggle git blame line" })
					map("n", "<leader>gtd", gs.toggle_deleted, { desc = "toggle git show deleted" })

					-- Text object
					map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "select git hunk" })
				end,
			})
			vim.cmd([[hi GitSignsAdd guifg=#04de21]])
			vim.cmd([[hi GitSignsChange guifg=#83fce6]])
			vim.cmd([[hi GitSignsDelete guifg=#fa2525]])
		end,
	},
	{
		"lazygit.nvim",
		cmd = {
			"LazyGit",
			"LazyGitConfig",
			"LazyGitCurrentFile",
			"LazyGitFilter",
			"LazyGitFilterCurrentFile",
		},
		keys = {
			{ "<leader>gl", "<cmd>LazyGit<cr>", desc = "LazyGit" },
		},
	},
	-- Indent category
	{
		"indent-blankline.nvim",
		for_cat = "editor.indent",
		event = "DeferredUIEnter",
		after = function(plugin)
			require("ibl").setup()
		end,
	},
	-- Information category
	{
		"which-key.nvim",
		for_cat = "editor.information",
		-- cmd = { "" },
		event = "DeferredUIEnter",
		-- ft = "",
		-- keys = "",
		-- colorscheme = "",
		after = function(plugin)
			require("which-key").setup({})
			require("which-key").add({
				{ "<leader>b", group = "[b]uffer" },
				{ "<leader>b_", hidden = true },
				{ "<leader>c", group = "[c]ode" },
				{ "<leader>c_", hidden = true },
				{ "<leader>d", group = "[d]ocument" },
				{ "<leader>d_", hidden = true },
				{ "<leader>g", group = "[g]it" },
				{ "<leader>g_", hidden = true },
				{ "<leader>r", group = "[r]ename" },
				{ "<leader>r_", hidden = true },
				{ "<leader>s", group = "[s]earch" },
				{ "<leader>s_", hidden = true },
				{ "<leader>t", group = "[t]erminal/[t]oggles" },
				{ "<leader>t_", hidden = true },
				{ "<leader>w", group = "[w]orkspace" },
				{ "<leader>w_", hidden = true },
				{ "<leader>F", group = "[F]ormat" },
				{ "<leader>F_", hidden = true },
				{ "gr", group = "LSP Actions" },
				{ "gz", group = "Vim-Slime" },
			})
		end,
	},
	{
		"fidget.nvim",
		for_cat = "editor.information",
		event = "DeferredUIEnter",
		-- keys = "",
		after = function(plugin)
			require("fidget").setup({})
		end,
	},
	-- Movement Category
	{
		"flash.nvim",
		for_cat = "editor.movement",
		event = "DeferredUIEnter",
		after = function(plugin)
			require("flash").setup()
		end,
		keys = {
			{
				"s",
				mode = { "n", "x", "o" },
				function()
					require("flash").jump()
				end,
				desc = "Flash",
			},
			{
				"S",
				mode = { "n", "x", "o" },
				function()
					require("flash").treesitter()
				end,
				desc = "Flash Treesitter",
			},
			{
				"r",
				mode = "o",
				function()
					require("flash").remote()
				end,
				desc = "Remote Flash",
			},
			{
				"R",
				mode = { "o", "x" },
				function()
					require("flash").treesitter_search()
				end,
				desc = "Treesitter Search",
			},
			{
				"<c-s>",
				mode = { "c" },
				function()
					require("flash").toggle()
				end,
				desc = "Toggle Flash Search",
			},
		},
	},
	{
		"marks.nvim",
		for_cat = "editor.movement",
		event = "DeferredUIEnter",
		after = function(plugin)
			require("marks").setup()
		end,
	},
	{
		"vim-tmux-navigator",
		require = { "vim-tmux-navigator" },
		for_cat = "editor.movement",
		before = function()
			vim.g.tmux_navigator_no_mappings = 1
		end,
		cmd = {
			"TmuxNavigateLeft",
			"TmuxNavigateDown",
			"TmuxNavigateUp",
			"TmuxNavigateRight",
		},
		keys = {
			{ "<c-h>", "<cmd>TmuxNavigateLeft<cr>" },
			{ "<c-j>", "<cmd>TmuxNavigateDown<cr>" },
			{ "<c-k>", "<cmd>TmuxNavigateUp<cr>" },
			{ "<c-l>", "<cmd>TmuxNavigateRight<cr>" },
		},
	},
	-- Picker category
	{
		"telescope.nvim",
		for_cat = "editor.picker",
		cmd = { "Telescope", "LiveGrepGitRoot" },
		-- NOTE: our on attach function defines keybinds that call telescope.
		-- so, the on_require handler will load telescope when we use those.
		on_require = { "telescope" },
		-- event = "",
		-- ft = "",
		keys = {
			{ "<leader>sM", "<cmd>Telescope notify<CR>", mode = { "n" }, desc = "[S]earch [M]essage" },
			{ "<leader>sp", live_grep_git_root, mode = { "n" }, desc = "[S]earch git [P]roject root" },
			{
				"<leader>/",
				function()
					-- Slightly advanced example of overriding default behavior and theme
					-- You can pass additional configuration to telescope to change theme, layout, etc.
					require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
						winblend = 10,
						previewer = false,
					}))
				end,
				mode = { "n" },
				desc = "[/] Fuzzily search in current buffer",
			},
			{
				"<leader>s/",
				function()
					require("telescope.builtin").live_grep({
						grep_open_files = true,
						prompt_title = "Live Grep in Open Files",
					})
				end,
				mode = { "n" },
				desc = "[S]earch [/] in Open Files",
			},
			{
				"<leader>s.",
				function()
					return require("telescope.builtin").oldfiles()
				end,
				mode = { "n" },
				desc = '[S]earch Recent Files ("." for repeat)',
			},
			{
				"<leader>sr",
				function()
					return require("telescope.builtin").resume()
				end,
				mode = { "n" },
				desc = "[S]earch [R]esume",
			},
			{
				"<leader>sd",
				function()
					return require("telescope.builtin").diagnostics()
				end,
				mode = { "n" },
				desc = "[S]earch [D]iagnostics",
			},
			{
				"<leader>sg",
				function()
					return require("telescope.builtin").live_grep()
				end,
				mode = { "n" },
				desc = "[S]earch by [G]rep",
			},
			{
				"<leader>sw",
				function()
					return require("telescope.builtin").grep_string()
				end,
				mode = { "n" },
				desc = "[S]earch current [W]ord",
			},
			{
				"<leader>ss",
				function()
					return require("telescope.builtin").builtin()
				end,
				mode = { "n" },
				desc = "[S]earch [S]elect Telescope",
			},
			{
				"<leader>sf",
				function()
					return require("telescope.builtin").find_files()
				end,
				mode = { "n" },
				desc = "[S]earch [F]iles",
			},
			{
				"<leader>sk",
				function()
					return require("telescope.builtin").keymaps()
				end,
				mode = { "n" },
				desc = "[S]earch [K]eymaps",
			},
			{
				"<leader>sh",
				function()
					return require("telescope.builtin").help_tags()
				end,
				mode = { "n" },
				desc = "[S]earch [H]elp",
			},
		},
		-- colorscheme = "",
		load = function(name)
			vim.cmd.packadd(name)
			vim.cmd.packadd("telescope-fzf-native.nvim")
			vim.cmd.packadd("telescope-ui-select.nvim")
		end,
		after = function(plugin)
			require("telescope").setup({
				-- You can put your default mappings / updates / etc. in here
				--  All the info you're looking for is in `:help telescope.setup()`
				--
				defaults = {
					mappings = {
						i = { ["<c-enter>"] = "to_fuzzy_refine" },
					},
				},
				-- pickers = {}
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown(),
					},
				},
			})

			-- Enable telescope extensions, if they are installed
			pcall(require("telescope").load_extension, "fzf")
			pcall(require("telescope").load_extension, "ui-select")

			vim.api.nvim_create_user_command("LiveGrepGitRoot", live_grep_git_root, {})
		end,
	},
	{
		"undotree",
		for_cat = "editor.extra",
		cmd = { "UndotreeToggle", "UndotreeHide", "UndotreeShow", "UndotreeFocus", "UndotreePersistUndo" },
		keys = { { "<leader>U", "<cmd>UndotreeToggle<CR>", mode = { "n" }, desc = "Undo Tree" } },
		before = function(_)
			vim.g.undotree_WindowLayout = 1
			vim.g.undotree_SplitWidth = 40
		end,
	},
	-- repl Category
	{
		"vim-slime",
		before = function()
			vim.g.slime_target = "tmux"
			vim.g.slime_bracketed_paste = 1
			vim.g.slime_default_config = {
				socket_name = vim.fn.split(vim.env.TMUX, ",")[1],
				target_pane = ":.2",
			}
		end,
		keys = {
			{ "gz", "<Plug>SlimeMotionSend", desc = "Slime Motion Send" },
			{ "gzz", "<Plug>SlimeLineSend", desc = "Slime Motion Send" },
			{ "gz", "<Plug>SlimeRegionSend", mode = { "x" }, desc = "Slime Region Send" },
			{ "gzc", "<Plug>SlimeConfig", desc = "Slime Config" },
		},
	},
}
