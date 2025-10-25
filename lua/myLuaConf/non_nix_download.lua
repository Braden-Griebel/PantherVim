-- Don't have the nix providers, so tell Mason where to find them
vim.g.python3_host_prog = "~/environments/pynvim/.venv/bin/python"
vim.g.python_host_prog = "~/environments/pynvim/.venv/bin/python"

-- load the plugins via paq-nvim when not on nix
require("nixCatsUtils.catPacker").setup({
	-- Startup Plugins
	-- Editor category
	-- Default
	{ "BirdeeHub/lze" },
	{ "BirdeeHub/lzextras" },
	{ "MunifTanjim/nui.nvim" },
	{ "nvim-lua/plenary.nvim" },
	{ "tpope/vim-repeat" },
	{ "rcarriga/nvim-notify" },

	-- UI category
	{ "nvim-tree/nvim-web-devicons" },

	-- Languages Category
	-- rust
	{ "mrcjkb/rustaceanvim" },

	-- Themer Category
	{ "rose-pine/neovim" },

	-- Optional Plugins
	-- Coding Category
	{ "windwp/nvim-autopairs", opt = true },
	{ "numToStr/Comment.nvim", opt = true, as = "comment.nvim" },
	{ "nvim-mini/mini.ai", opt = true },
	{ "nvim-mini/mini.surround", opt = true },
	{ "smjonas/inc-rename.nvim", opt = true },
	{ "nvim-treesitter/nvim-treesitter-textobjects", opt = true },
	{ "nvim-treesitter/nvim-treesitter", build = ":TSUpdate", opt = true },
	{ "gbprod/yanky.nvim", opt = true },

	-- Debug
	{ "nvim-neotest/nvim-nio", opt = true },
	{ "rcarriga/nvim-dap-ui", opt = true },
	{ "theHamsta/nvim-dap-virtual-text", opt = true },
	{ "jay-babu/mason-nvim-dap.nvim", opt = true },
	{ "mfussenegger/nvim-dap", opt = true },

	-- Category Editor
	-- Diagnostics
	{ "folke/trouble.nvim", opt = true },
	{ "folke/todo-comments.nvim", opt = true },

	-- Files
	{ "stevearc/oil.nvim", opt = true },
	{ "nvim-neo-tree/neo-tree.nvim", opt = true },

	-- Git
	{ "tpope/vim-fugitive", opt = true },
	{ "lewis6991/gitsigns.nvim", opt = true },
	{ "kdheepak/lazygit.nvim", opt = true },

	-- Indent
	{ "lukas-reineke/indent-blankline.nvim", opt = true },
	{ "tpope/vim-sleuth", opt = true },

	-- Information
	{ "j-hui/fidget.nvim", opt = true },
	{ "folke/which-key.nvim", opt = true },

	-- Movement
	{ "folke/flash.nvim", opt = true },
	{ "christoomey/vim-tmux-navigator", opt = true },
	{ "chentoast/marks.nvim", opt = true },

	-- Picker
	{ "nvim-telescope/telescope-ui-select.nvim", opt = true },
	{ "nvim-telescope/telescope.nvim", opt = true },
	{ "mbbill/undotree", opt = true },

	-- Repl
	{ "jpalardy/vim-slime", opt = true },

	-- Languages Category
	{ "Saghen/blink.cmp", opt = true, branch = "v1.7.0" },
	{ "Saghen/blink.compat", opt = true },
	{ "hrsh7th/cmp-cmdline", opt = true },
	{ "xzbdmw/colorful-menu.nvim", opt = true },
	{ "stevearc/conform.nvim", opt = true },
	{ "folke/lazydev.nvim", opt = true },
	{ "L3MON4D3/LuaSnip", opt = true, as = "luasnip" },
	{ "mfussenegger/nvim-lint", opt = true },
	{ "neovim/nvim-lspconfig", opt = true },
	-- Mason to download LSPs and Formatters
	{ "williamboman/mason.nvim", opt = true },
	{ "williamboman/mason-lspconfig.nvim", opt = true },

	-- Java
	{ "mfussenegger/nvim-jdtls", opt = true },
	{ "Julian/lean.nvim", opt = true },
	{ "MeanderingProgrammer/render-markdown.nvim", opt = true },

	-- Rust
	{ "Saecki/crates.nvim", opt = true },
	{ "R-nvim/R.nvim", opt = true, as = "rnvim" },

	-- Category UI
	{ "akinsho/bufferline.nvim", opt = true },
	{ "nvim-lualine/lualine.nvim", opt = true },
	{ "nvim-mini/mini.animate", opt = true },
	{ "nvim-mini/mini.icons", opt = true },
	{ "folke/noice.nvim", opt = true },
	{ "ya2s/nvim-cursorline", opt = true },
	{ "sphamba/smear-cursor.nvim", opt = true },
	{ "folke/snacks.nvim", opt = true },
	{ "rubiin/fortune.nvim", opt = true },
	{ "akinsho/toggleterm.nvim", opt = true, as = "toggleterm" },
})
