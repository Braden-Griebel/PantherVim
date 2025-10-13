return {
  {
    "lualine.nvim",
    for_cat = "ui",
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
  {
    "bufferline.nvim",
    event = "DeferredUIEnter",
    keys = {
      { "<leader>bp", "<Cmd>BufferLineTogglePin<CR>",            desc = "Toggle Pin" },
      { "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "Delete Non-Pinned Buffers" },
      { "<leader>br", "<Cmd>BufferLineCloseRight<CR>",           desc = "Delete Buffers to the Right" },
      { "<leader>bl", "<Cmd>BufferLineCloseLeft<CR>",            desc = "Delete Buffers to the Left" },
      { "<S-h>",      "<cmd>BufferLineCyclePrev<cr>",            desc = "Prev Buffer" },
      { "<S-l>",      "<cmd>BufferLineCycleNext<cr>",            desc = "Next Buffer" },
      { "[b",         "<cmd>BufferLineCyclePrev<cr>",            desc = "Prev Buffer" },
      { "]b",         "<cmd>BufferLineCycleNext<cr>",            desc = "Next Buffer" },
      { "[B",         "<cmd>BufferLineMovePrev<cr>",             desc = "Move buffer prev" },
      { "]B",         "<cmd>BufferLineMoveNext<cr>",             desc = "Move buffer next" },
      { "<leader>bb", "<cmd>e #<cr>",                            desc = "Move to other buffer" },
      { "<leader>bd", "<Cmd>bdelete<cr>",                        desc = "Delete Buffer" },
    },
    after = function(plugins)
      require("bufferline").setup({
        options = {
          -- stylua: ignore
          close_command = function(n) require("snacks").bufdelete(n) end,
          -- stylua: ignore
          right_mouse_command = function(n) require("snacks").bufdelete(n) end,
          diagnostics = "nvim_lsp",
          always_show_bufferline = true,
          offsets = {
            {
              filetype = "neo-tree",
              text = "Neo-tree",
              highlight = "Directory",
              text_align = "left",
            },
            {
              filetype = "snacks_layout_box",
            },
          },
        },
      })
      vim.api.nvim_create_autocmd({ "BufAdd", "BufDelete" }, {
        callback = function()
          vim.schedule(function()
            pcall(nvim_bufferline)
          end)
        end,
      })
    end,
  },
  {
    "mini.animate",
    event = "DeferredUIEnter",
    after = function(plugin)
      require("mini.animate").setup({ cursor = { enable = false } })
    end,
  },
  {
    "mini.icons",
    after = function(plugin)
      require("mini.icons").setup()
    end,
    dep_of = { "render-markdown.nvim" },
  },
  {
    "noice.nvim",
    event = "DeferredUIEnter",
    after = function(plugin)
      require("noice").setup({
        -- add any options here
        lsp = {
          -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            -- ['cmp.entry.get_documentation'] = true, -- requires hrsh7th/nvim-cmp
          },
        },
        -- you can enable a preset for easier configuration
        presets = {
          bottom_search = false,        -- use a classic bottom cmdline for search
          command_palette = true,       -- position the cmdline and popupmenu together
          long_message_to_split = true, -- long messages will be sent to a split
          inc_rename = true,            -- enables an input dialog for inc-rename.nvim
          lsp_doc_border = true,        -- add a border to hover docs and signature help
        },
      })
    end,
  },
  {
    "nvim-cursorline",
    event = "DeferredUIEnter",
    after = function(plugin)
      require("nvim-cursorline").setup({
        cursorline = {
          enable = true,
          timeout = 1000,
          number = false,
        },
        cursorword = {
          enable = true,
          min_length = 3,
          hl = { underline = true },
        },
      })
    end,
  },
  {
    "smear-cursor.nvim",
    event = "DeferredUIEnter",
    after = function(plugin)
      require("smear_cursor").setup()
    end,
  },
  {
    "fortune.nvim",
    on_require = { "fortune" },
    after = function(plugin)
      require("fortune").setup({
        max_width = 60,
        display_format = "mixed",
        content_type = "quotes",
        language = "en",
      })
    end,
  },
  {
    "snacks.nvim",
    after = function(plugin)
      require("snacks").setup({
        dashboard = {
          preset = {
            header = [[
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣾⣿⣿⣶⣶⣦⣄⡀⠀⠀⠀⠀⢀⣀⣠⣤⣤⣴⣶⣶⣦⣤⣤⣄⣀⠀⠀⠀⠀⠀⣀⣤⣴⣶⣾⣿⣿⣷⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⣿⣿⣿⣿⣿⣿⣿⣿⣷⣦⣴⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣦⣴⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⣀⣀⣀⠀⠀⠀⠀⠈⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡟⠀⠀⠀⠀⠀⣀⣀⣀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠉⠉⠙⠛⠿⢿⣶⣦⣀⠀⣿⣿⣿⣿⣿⣿⡿⠋⠁⠀⠀⠉⠻⣿⣿⣿⣿⣿⣿⠛⠁⠀⠀⠈⠙⢿⣿⣿⣿⣿⣿⣏⠀⣠⣴⣾⡿⠟⠛⠋⠉⠁⠀⠀⠀⠀
⠀⢀⣠⣤⣤⣤⣤⣤⣤⣀⣈⠙⠻⣷⣿⣿⣿⣿⣿⡟⠀⠀⠀⢀⠀⠀⠀⠘⣿⣿⣿⣿⠁⠀⠀⠀⠀⠀⠀⠀⢿⣿⣿⣿⣿⣿⡿⠟⠋⣁⣀⣤⣤⣤⣤⣤⣤⣀⡀⠀
⠈⠉⠉⠉⠉⠉⠉⠉⠛⠛⠿⢿⣶⣄⣿⣿⣿⣿⣿⡇⠀⠀⠀⣾⡆⠀⠀⠀⣿⣿⣿⣿⠀⠀⠀⢸⣧⠀⠀⠀⣸⣿⣿⣿⣿⣿⣤⣶⡿⠟⠛⠋⠉⠉⠉⠉⠉⠉⠉⠁
⠀⠀⠀⣠⣤⣶⣶⣶⣶⣶⣶⣿⣿⣿⣿⣿⣿⣿⣿⣿⣄⠀⠀⢿⠃⠀⢀⣼⣿⣿⣿⣿⣧⡀⠀⠸⡏⠀⠀⣠⣿⣿⣿⣿⣿⣿⣿⣿⣿⣶⣶⣶⣶⣶⣶⣤⣄⠀⠀⠀
⠀⠀⠊⠉⠁⠀⣠⣶⣶⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣦⣤⣤⣶⣿⣿⣿⠿⠿⣿⣿⣿⣶⣤⣤⣴⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣶⣦⣀⠀⠈⠉⠑⠀⠀
⠀⠀⠀⠀⠀⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡟⠛⠛⠛⠛⠛⠛⠛⠋⠀⠀⠀⠀⠙⠛⠛⠛⠛⠛⠛⠛⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡆⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠘⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⠿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠁⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠉⠉⠉⠻⢿⣿⡿⠟⠉⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠉⠻⣿⣿⠿⠋⠉⠉⠉⠀⠀⠀⠀⠀⠀⠀
              ]],
            -- stylua: ignore
            keys = {
              { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
              { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
              { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
              { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
              { icon = " ", key = "q", desc = "Quit", action = ":qa" },
            },
          },
          sections = {
            { section = "header" },
            { section = "keys",                                           gap = 1, padding = 1 },
            { text = table.concat(require("fortune").get_fortune(), "\n") }
          },
        },
      })
    end,
  },
  -- Terminal
  {
    "toggleterm",
    event = "DeferredUIEnter",
    after = function()
      require("toggleterm").setup({
        size = function(term)
          if term.direction == 'horizontal' then
            return 15
          elseif term.direction == 'vertical' then
            return vim.o.columns * 0.4
          end
        end,
        open_mapping = [[<c-\>]],
        hide_numbers = true,
        shell = 'bash',
      })
    end,
    keys  = {
      {
        '<leader>tr',
        '<cmd>TermNew size=40 dir=git_dir direction=float name=root-terminal<cr>',
        mode = { 'n' },
        desc = 'Open [T]erminal [R]oot Directory',
      },
      {
        '<leader>tc',
        '<cmd>TermNew size=40 dir=. direction=float name=cwd-terminal<cr>',
        mode = { 'n' },
        desc = 'Open [T]erminal [C]urrent [W]orking [D]irectory',
      },
      { '<leader>tb', '<cmd>TermNew size=20 dir=. direction=horizontal name=horizontal-terminal<cr>', mode = { 'n' }, desc = 'Open [B]ottom Terminal' },
      { '<leader>ts', '<cmd>TermSelect<cr>', mode = { 'n' }, desc = 'Select Terminal' },
      { '<c-\\>', '<cmd>ToggleTerm dir=git_dir direction=horizontal name=<cr>', mode = { 'n' }, desc = 'Toggle Terminal' },
    },
  },
}
