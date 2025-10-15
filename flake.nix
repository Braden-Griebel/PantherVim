{
  description = "Neovim config using nixCats";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixCats.url = "github:BirdeeHub/nixCats-nvim";

    "plugins-toggleterm" = {
      url = "github:akinsho/toggleterm.nvim";
      flake = false;
    };

    "plugins-rnvim" = {
      url = "github:R-nvim/R.nvim";
      flake = false;
    };
  };

  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let
    inherit (inputs.nixCats) utils;
    luaPath = ./.;
    # this is flake-utils eachSystem
    forEachSystem = utils.eachSystem nixpkgs.lib.platforms.all;
    extra_pkg_config = {
      # allowUnfree = true;
    };
    dependencyOverlays = [
      (utils.standardPluginOverlay inputs)
    ];

    categoryDefinitions = {
      pkgs,
      settings,
      categories,
      extra,
      name,
      mkPlugin,
      ...
    } @ packageDef: {
      lspsAndRuntimeDeps = {
        editor = with pkgs; [
          fd
          fzf
          lazygit
          ripgrep
          universal-ctags
        ];
        languages = with pkgs; {
          default = [lua-language-server stylua];
          bash = [bash-language-server shfmt shellcheck];
          cpp = [clang-tools neocmakelsp];
          css = [vscode-langservers-extracted];
          fish = [fish-lsp];
          fortran = [fortls];
          gleam = [gleam];
          go = [
            gopls
            gofumpt
            go-tools
          ];
          haskell = [haskell-language-server];
          html = [vscode-langservers-extracted];
          java = [
            jdt-language-server
          ];
          javascript = [
            deno
            eslint
            oxlint
          ];
          typescript = [
            deno
            eslint
            oxlint
          ];
          json = [vscode-langservers-extracted];
          lean = [
            lean4
          ];
          lua = [
            lua-language-server
            stylua
          ];
          markdown = [
            marksman
            mdformat
            markdownlint-cli2
          ];
          nix = [
            alejandra
            nix-doc
            nixd
          ];
          ocaml = [ocamlPackages.ocaml-lsp];
          python = [
            ruff
            mypy
            pyright
          ];
          r = [
            air
            rPackages.languageserver
          ];
          rust = [
            clippy
            rust-analyzer
            rustfmt
          ];
          typst = [
            tinymist
            typstyle
          ];
          xml = [lemminx];
          yaml = [vscode-langservers-extracted];
          writing = [
            harper
          ];
        };
        debug = with pkgs; {
          default = [lldb];
          go = [delve];
          python = [python313Packages.debugpy];
        };
      };

      # This is for plugins that will load at startup without using packadd:
      startupPlugins = {
        coding = with pkgs.vimPlugins; [];
        debug = with pkgs.vimPlugins; {
          default = [nvim-nio];
        };
        editor = with pkgs.vimPlugins; {
          default = [
            lze
            lzextras
            nui-nvim
            vim-repeat
            plenary-nvim
            (nvim-notify.overrideAttrs {doCheck = false;}) # TODO: remove overrideAttrs after check is fixed
          ];
          extras = [
          ];
        };
        languages = with pkgs.vimPlugins; {
          bash = [];
          cpp = [];
          css = [];
          fish = [];
          fortran = [];
          gleam = [];
          go = [];
          haskell = [];
          html = [];
          java = [];
          javascript = [];
          typescript = [];
          json = [];
          lean = [];
          lua = [];
          markdown = [];
          nix = [];
          ocaml = [];
          python = [];
          r = [];
          rust = [
            rustaceanvim
          ];
          typst = [
          ];
          xml = [];
          yaml = [];
        };
        ui = with pkgs.vimPlugins; [
          nvim-web-devicons
        ];
        themer = with pkgs.vimPlugins; (
          builtins.getAttr (categories.colorscheme or "rose-pine") {
            # Theme switcher without creating a new category
            "onedark" = onedark-nvim;
            "rose-pine" = rose-pine;
            "catppuccin" = catppuccin-nvim;
            "catppuccin-mocha" = catppuccin-nvim;
            "tokyonight" = tokyonight-nvim;
            "tokyonight-day" = tokyonight-nvim;
          }
        );
      };

      # not loaded automatically at startup.
      optionalPlugins = {
        coding = with pkgs.vimPlugins; [
          nvim-autopairs
          comment-nvim
          mini-ai
          mini-surround
          inc-rename-nvim
          nvim-treesitter-textobjects
          nvim-treesitter.withAllGrammars
          yanky-nvim
        ];
        debug = with pkgs.vimPlugins; {
          default = [
            nvim-dap
            nvim-dap-ui
            nvim-dap-virtual-text
          ];
          go = [nvim-dap-go];
          python = [nvim-dap-python];
        };
        editor = with pkgs.vimPlugins; {
          files = [
            oil-nvim
            neo-tree-nvim
          ];
          git = [
            vim-fugitive
            gitsigns-nvim
            lazygit-nvim
          ];
          indent = [
            indent-blankline-nvim
            vim-sleuth
          ];
          information = [
            fidget-nvim
            which-key-nvim
          ];
          movement = [
            flash-nvim
            marks-nvim
            vim-tmux-navigator
          ];
          picker = [
            telescope-nvim
            telescope-ui-select-nvim
            undotree
          ];
          repl = [
            vim-slime
          ];
        };
        languages = with pkgs.vimPlugins; {
          default = [
            blink-cmp # Completion engine
            blink-compat # Compatibility with cmp sources
            cmp-cmdline # Completion in cmdline
            colorful-menu-nvim # Treesitter colors in completion
            conform-nvim # Formatting
            lazydev-nvim # Improved lua lsp in config
            luasnip # Snippet support
            nvim-lint # Runs linters
            nvim-lspconfig # Default LSP configs
          ];
          cpp = [];
          go = [];
          java = [
            nvim-jdtls # Sets up LSP
          ];
          lean = [
            lean-nvim
          ];
          markdown = [
            render-markdown-nvim
          ];
          nix = [];
          python = [];
          rust = [
            crates-nvim
          ];
          r = [] ++ (with pkgs.neovimPlugins; [rnvim]);
          typst = [];
          writing = [];
        };
        ui =
          (with pkgs.vimPlugins; [
            bufferline-nvim
            dashboard-nvim
            lualine-nvim
            mini-animate
            mini-icons
            noice-nvim
            nvim-cursorline
            smear-cursor-nvim
            snacks-nvim
            fortune-nvim
          ])
          ++ (with pkgs.neovimPlugins; [toggleterm]);
      };

      sharedLibraries = {
      };

      environmentVariables = {
      };

      extraWrapperArgs = {
      };

      python3.libraries = {
        debug.python = [(python-pkgs: [python-pkgs.debugpy])];
      };
      # populates $LUA_PATH and $LUA_CPATH
      extraLuaPackages = {
      };

      extraCats = {
        languages = [
          [
            "languages"
            "default"
          ]
        ];
        debug = [
          ["debug" "default"]
        ];
        editor = [["editor" "default"]];
      };
    };

    packageDefinitions = {
      nvim = {
        pkgs,
        name,
        ...
      } @ misc: {
        settings = {
          suffix-path = true;
          suffix-LD = true;
          aliases = ["vim" "vimcat"];
          wrapRc = true;
          configDirName = "nixCats-nvim";
          hosts.python3.enable = true;
          hosts.node.enable = true;
        };
        categories = {
          colorscheme = "rose-pine";
          coding = true;
          debug = {
            default = true;
            python = true;
            go = true;
          };
          editor = {
            default = true;
            files = true;
            git = true;
            indent = true;
            information = true;
            movement = true;
            picker = true;
            repl = true;
          };
          languages = {
            default = true;
            bash = true;
            cpp = true;
            css = true;
            fish = true;
            fortran = true;
            gleam = true;
            go = true;
            haskell = true;
            html = true;
            java = true;
            javascript = true;
            typescript = true;
            json = true;
            lean = true;
            lua = true;
            markdown = true;
            nix = true;
            ocaml = true;
            python = true;
            r = true;
            rust = true;
            typst = true;
            xml = true;
            yaml = true;
            writing = true;
          };
          lspDebugMode = false;
          themer = true;
          ui = true;
        };
        extra = {
          nixdExtras = {
            nixpkgs = ''import ${pkgs.path} {}'';
            # or inherit nixpkgs;
          };
        };
      };
    };

    defaultPackageName = "nvim";
  in
    forEachSystem (system: let
      nixCatsBuilder =
        utils.baseBuilder luaPath {
          inherit nixpkgs system dependencyOverlays extra_pkg_config;
        }
        categoryDefinitions
        packageDefinitions;
      defaultPackage = nixCatsBuilder defaultPackageName;

      pkgs = import nixpkgs {inherit system;};
    in {
      packages = utils.mkAllWithDefault defaultPackage;

      devShells = {
        default = pkgs.mkShell {
          name = defaultPackageName;
          packages = [defaultPackage];
          inputsFrom = [];
          shellHook = ''
          '';
        };
      };
    })
    // (let
      nixosModule = utils.mkNixosModules {
        moduleNamespace = [defaultPackageName];
        inherit
          defaultPackageName
          dependencyOverlays
          luaPath
          categoryDefinitions
          packageDefinitions
          extra_pkg_config
          nixpkgs
          ;
      };
      homeModule = utils.mkHomeModules {
        moduleNamespace = [defaultPackageName];
        inherit
          defaultPackageName
          dependencyOverlays
          luaPath
          categoryDefinitions
          packageDefinitions
          extra_pkg_config
          nixpkgs
          ;
      };
    in {
      overlays =
        utils.makeOverlays luaPath {
          inherit nixpkgs dependencyOverlays extra_pkg_config;
        }
        categoryDefinitions
        packageDefinitions
        defaultPackageName;

      nixosModules.default = nixosModule;
      homeModules.default = homeModule;

      inherit utils nixosModule homeModule;
      inherit (utils) templates;
    });
}
