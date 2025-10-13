-- load the plugins via paq-nvim when not on nix
require('nixCatsUtils.catPacker').setup({
  
  { "BirdeeHub/lze", },
  { "BirdeeHub/lzextras", },
  { "stevearc/oil.nvim", },
  { 'joshdick/onedark.vim', },
  { 'nvim-tree/nvim-web-devicons', },
  { 'nvim-lua/plenary.nvim', },
  { 'tpope/vim-repeat', },
  { 'rcarriga/nvim-notify', },

  { 'nvim-treesitter/nvim-treesitter-textobjects', opt = true, },
  { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate', opt = true, },

  { 'nvim-telescope/telescope-fzf-native.nvim', build = ':!which make && make', opt = true, },
  { 'nvim-telescope/telescope-ui-select.nvim', opt = true, },
  {'nvim-telescope/telescope.nvim', opt = true, },

  -- lsp
  { 'williamboman/mason.nvim', opt = true, },
  { 'williamboman/mason-lspconfig.nvim', opt = true, },
  { 'j-hui/fidget.nvim', opt = true, },
  { 'neovim/nvim-lspconfig', opt = true, },
  { 'folke/lazydev.nvim', opt = true, },

  -- completion
  { 'L3MON4D3/LuaSnip', opt = true, as = "luasnip", },
  { 'hrsh7th/cmp-cmdline', opt = true, },
  { 'Saghen/blink.cmp', opt = true, },
  { 'Saghen/blink.compat', opt = true, },
  { 'xzbdmw/colorful-menu.nvim', opt = true, },

  -- lint and format
  { 'mfussenegger/nvim-lint', opt = true, },
  { 'stevearc/conform.nvim', opt = true, },

  -- dap
  { 'nvim-neotest/nvim-nio', opt = true, },
  { 'rcarriga/nvim-dap-ui', opt = true, },
  { 'theHamsta/nvim-dap-virtual-text', opt = true, },
  { 'jay-babu/mason-nvim-dap.nvim', opt = true, },
  { 'mfussenegger/nvim-dap', opt = true, },

  -- { 'm-demare/hlargs.nvim', },
  { 'mbbill/undotree', opt = true, },
  { 'tpope/vim-fugitive', opt = true, },
  { 'tpope/vim-rhubarb', opt = true, },
  { 'tpope/vim-sleuth', opt = true, },
  { 'folke/which-key.nvim', opt = true, },
  { 'lewis6991/gitsigns.nvim', opt = true, },
  { 'nvim-lualine/lualine.nvim', opt = true, },
  { 'lukas-reineke/indent-blankline.nvim', opt = true, },
  { 'numToStr/Comment.nvim', opt = true, as = "comment.nvim", },
  { 'kylechui/nvim-surround', opt = true, },
  {
    "iamcco/markdown-preview.nvim",
    build = ":call mkdp#util#install()",
    opt = true,
  },
})
