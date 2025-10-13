-- Don't have the nix providers, so tell Mason where to find them
vim.g.python3_host_prog = '~/environments/pynvim/bin/python'
vim.g.python_host_prog = '~/environments/pynvim/bin/python'

-- load the plugins via paq-nvim when not on nix
require('nixCatsUtils.catPacker').setup({
  -- Startup Plugins
  -- Editor category
  -- Default
  { "BirdeeHub/lze", },
  { "BirdeeHub/lzextras", },
  { 'MunifTanjim/nui.nvim' },
  { 'nvim-lua/plenary.nvim', },
  { 'tpope/vim-repeat', },
  { 'rcarriga/nvim-notify', },

  -- UI category
  { 'nvim-tree/nvim-web-devicons', },

  -- Languages Category
  -- rust
  { "mrcjkb/rustaceanvim", },

  -- Themer Category
  { 'rose-pine/neovim', },

  -- Optional Plugins
  -- Coding Category
  { "windwp/nvim-autopairs",                       opt = true, },
  { 'numToStr/Comment.nvim',                       opt = true,          as = "comment.nvim", },
  { 'nvim-mini/mini.ai',                           opt = true, },
  { 'nvim-mini/mini.surround',                     opt = true, },
  { 'smjonas/inc-rename.nvim',                     opt = true, },
  { 'nvim-treesitter/nvim-treesitter-textobjects', opt = true, },
  { 'nvim-treesitter/nvim-treesitter',             build = ':TSUpdate', opt = true, },
  { 'gbprod/yanky.nvim',                           opt = true, },

  -- Debug
  { 'nvim-neotest/nvim-nio',                       opt = true, },
  { 'rcarriga/nvim-dap-ui',                        opt = true, },
  { 'theHamsta/nvim-dap-virtual-text',             opt = true, },
  { 'jay-babu/mason-nvim-dap.nvim',                opt = true, },
  { 'mfussenegger/nvim-dap',                       opt = true, },

  -- Category Editor
  -- Files
  { "stevearc/oil.nvim",                           opt = true },
  { "nvim-neo-tree/neo-tree.nvim",                 opt = true },

  -- Git
  { 'tpope/vim-fugitive',                          opt = true, },
  { 'lewis6991/gitsigns.nvim',                     opt = true, },
  { 'kdheepak/lazygit.nvim',                       opt = true, },

  -- Indent
  { 'lukas-reineke/indent-blankline.nvim',         opt = true, },
  { 'tpope/vim-sleuth',                            opt = true, },

  -- Information
  { 'j-hui/fidget.nvim',                           opt = true, },
  { 'folke/which-key.nvim',                        opt = true, },




  { 'nvim-telescope/telescope-ui-select.nvim',     opt = true, },
  { 'nvim-telescope/telescope.nvim',               opt = true, },

  -- lsp
  { 'williamboman/mason.nvim',                     opt = true, },
  { 'williamboman/mason-lspconfig.nvim',           opt = true, },
  { 'neovim/nvim-lspconfig',                       opt = true, },
  { 'folke/lazydev.nvim',                          opt = true, },

  -- completion
  { 'L3MON4D3/LuaSnip',                            opt = true,          as = "luasnip", },
  { 'hrsh7th/cmp-cmdline',                         opt = true, },
  { 'Saghen/blink.cmp',                            opt = true, },
  { 'Saghen/blink.compat',                         opt = true, },
  { 'xzbdmw/colorful-menu.nvim',                   opt = true, },

  -- lint and format
  { 'mfussenegger/nvim-lint',                      opt = true, },
  { 'stevearc/conform.nvim',                       opt = true, },

  -- dap

  { 'mbbill/undotree',                             opt = true, },
  { 'tpope/vim-rhubarb',                           opt = true, },
  { 'nvim-lualine/lualine.nvim',                   opt = true, },
  { 'kylechui/nvim-surround',                      opt = true, },
  {
    "iamcco/markdown-preview.nvim",
    build = ":call mkdp#util#install()",
    opt = true,
  },
})
