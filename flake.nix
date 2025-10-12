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
    # the following extra_pkg_config contains any values
    # which you want to pass to the config set of nixpkgs
    # import nixpkgs { config = extra_pkg_config; inherit system; }
    # will not apply to module imports
    # as that will have your system values
    extra_pkg_config = {
      # allowUnfree = true;
    };
    dependencyOverlays = [
      (utils.standardPluginOverlay inputs)
    ];

    # see :help nixCats.flake.outputs.categories
    # and
    # :help nixCats.flake.outputs.categoryDefinitions.scheme
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
          json = [vscode-langservers-extracted];
          lean = [
            lean4
          ];
          lua = [
            lua-language-server
          ];
          markdown = [
            marksman
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
        };
        debug = with pkgs; [
          lldb
          delve
          python313Packages.debugpy
        ];
        writing = with pkgs; [
          harper
        ];
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
          neo-tree-nvim
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
          comment-nvim
          inc-rename-nvim
          nvim-treesitter-textobjects
          nvim-treesitter.withAllGrammars
        ];
        debug = with pkgs.vimPlugins; {
          # it is possible to add default values.
          # there is nothing special about the word "default"
          # but we have turned this subcategory into a default value
          # via the extraCats section at the bottom of categoryDefinitions.
          default = [
            nvim-dap
            nvim-dap-ui
            nvim-dap-virtual-text
          ];
          go = [nvim-dap-go];
          python = [nvim-dap-python];
        };
        editor = with pkgs.vimPlugins; {
          default = [
            auto-pairs
            fidget-nvim
            flash-nvim
            gitsigns-nvim
            indent-blankline-nvim
            marks-nvim
            mini-ai
            mini-animate
            mini-icons
            nvim-surround
            snacks-nvim
            telescope-fzf-native-nvim
            telescope-nvim
            telescope-ui-select-nvim
            undotree
            vim-fugitive
            vim-sleuth
            vim-slime
            vim-tmux-navigator
            which-key-nvim
            yanky-nvim
          ];
          extras = [
            oil-nvim
          ];
        };
        languages = with pkgs.vimPlugins; {
          default = [
            blink-cmp
            blink-compat
            cmp-cmdline
            colorful-menu-nvim
            conform-nvim
            lazydev-nvim
            luasnip
            nvim-lint
            nvim-lspconfig
          ];
          cpp = [];
          go = [];
          java = [
            nvim-jdtls
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
        };
        ui =
          (with pkgs.vimPlugins; [
            bufferline-nvim
            lualine-nvim
            noice-nvim
            nvim-cursorline
            smear-cursor-nvim
          ])
          ++ (with pkgs.neovimPlugins; [toggleterm]);
      };

      # shared libraries to be added to LD_LIBRARY_PATH
      # variable available to nvim runtime
      sharedLibraries = {
      };

      # environmentVariables:
      # this section is for environmentVariables that should be available
      # at RUN TIME for plugins. Will be available to path within neovim terminal
      environmentVariables = {
      };

      # If you know what these are, you can provide custom ones by category here.
      # If you dont, check this link out:
      # https://github.com/NixOS/nixpkgs/blob/master/pkgs/build-support/setup-hooks/make-wrapper.sh
      extraWrapperArgs = {
      };

      # lists of the functions you would have passed to
      # python.withPackages or lua.withPackages
      # do not forget to set `hosts.python3.enable` in package settings

      # get the path to this python environment
      # in your lua config via
      # vim.g.python3_host_prog
      # or run from nvim terminal via :!<packagename>-python3
      python3.libraries = {
        debug = [(python-pkgs: [python-pkgs.debugpy])];
      };
      # populates $LUA_PATH and $LUA_CPATH
      extraLuaPackages = {
      };

      # see :help nixCats.flake.outputs.categoryDefinitions.default_values
      # this will enable test.default and debug.default
      # if any subcategory of test or debug is enabled
      # WARNING: use of categories argument in this set will cause infinite recursion
      # The categories argument of this function is the FINAL value.
      # You may use it in any of the other sets.
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

    # packageDefinitions:

    # Now build a package with specific categories from above
    # All categories you wish to include must be marked true,
    # but false may be omitted.
    # This entire set is also passed to nixCats for querying within the lua.
    # It is directly translated to a Lua table, and a get function is defined.
    # The get function is to prevent errors when querying subcategories.

    # see :help nixCats.flake.outputs.packageDefinitions
    packageDefinitions = {
      # the name here is the name of the package
      # and also the default command name for it.
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
          debug = true;
          editor = {
            default = true;
            extras = true;
          };
          languages = true;
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
    # I did not here, but you might want to create a package named nvim.
    # defaultPackageName is also passed to utils.mkNixosModules and utils.mkHomeModules
    # and it controls the name of the top level option set.
    # If you made a package named `nixCats` your default package as we did here,
    # the modules generated would be set at:
    # config.nixCats = {
    #   enable = true;
    #   packageNames = [ "nixCats" ]; # <- the packages you want installed
    #   <see :h nixCats.module for options>
    # }
    # In addition, every package exports its own module via passthru, and is overrideable.
    # so you can yourpackage.homeModule and then the namespace would be that packages name.
  in
    # you shouldnt need to change much past here, but you can if you wish.
    # but you should at least eventually try to figure out whats going on here!
    # see :help nixCats.flake.outputs.exports
    forEachSystem (system: let
      # and this will be our builder! it takes a name from our packageDefinitions as an argument, and builds an nvim.
      nixCatsBuilder =
        utils.baseBuilder luaPath {
          # we pass in the things to make a pkgs variable to build nvim with later
          inherit nixpkgs system dependencyOverlays extra_pkg_config;
          # and also our categoryDefinitions and packageDefinitions
        }
        categoryDefinitions
        packageDefinitions;
      # call it with our defaultPackageName
      defaultPackage = nixCatsBuilder defaultPackageName;

      # this pkgs variable is just for using utils such as pkgs.mkShell
      # within this outputs set.
      pkgs = import nixpkgs {inherit system;};
      # The one used to build neovim is resolved inside the builder
      # and is passed to our categoryDefinitions and packageDefinitions
    in {
      # these outputs will be wrapped with ${system} by utils.eachSystem

      # this will generate a set of all the packages
      # in the packageDefinitions defined above
      # from the package we give it.
      # and additionally output the original as default.
      packages = utils.mkAllWithDefault defaultPackage;

      # choose your package for devShell
      # and add whatever else you want in it.
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
      # we also export a nixos module to allow reconfiguration from configuration.nix
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
      # and the same for home manager
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
      # these outputs will be NOT wrapped with ${system}

      # this will make an overlay out of each of the packageDefinitions defined above
      # and set the default overlay to the one named here.
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
