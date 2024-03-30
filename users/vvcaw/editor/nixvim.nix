{
  pkgs,
  nixvim,
  ...
}: {
  imports = [
    nixvim.homeManagerModules.nixvim
  ];

  programs.nixvim.enable = true;

  # Color scheme
  programs.nixvim.colorschemes.catppuccin = {
    enable = true;
    flavour = "mocha";
  };

  # Options
  programs.nixvim.options = {
    number = true;
    relativenumber = true;

    shiftwidth = 4;
  };

  # Keymap
  # Note for future me: This is fucked up, using default <C-c> causes LSPs to not refresh correctly...
  programs.nixvim.keymaps = [
    {
      action = "<Esc>";
      key = "<C-c>";
      mode = "i";
    }

    # Lazy Git
    {
      action = "<cmd>LazyGit<CR>";
      key = "<space>lg";
      mode = "n";
    }

    # Cmake stuff
    {
      action = "<cmd>CMakeGenerate<CR>";
      key = "<space>cg";
      mode = "n";
    }
    {
      action = "<cmd>CMakeBuild<CR>";
      key = "<space>cb";
      mode = "n";
    }
    {
      action = "<cmd>CMakeRun<CR>";
      key = "<space>cr";
      mode = "n";
    }

    # Conform formatting.
    {
      action = "<cmd>lua require(\"conform\").format()<CR>";
      key = "<space>fb";
      mode = "n";
    }
  ];

  # Extra plugins not available trough nixvim.
  programs.nixvim.extraPlugins = with pkgs.vimPlugins; [
    lazygit-nvim

    # Requirement for below.
    plenary-nvim

    # This cmake plugin is not packaged on nixpkgs, thus, let's build it ourself.
    (pkgs.vimUtils.buildVimPlugin {
      name = "cmake-tools-nvim";
      src = pkgs.fetchFromGitHub {
        owner = "Civitasv";
        repo = "cmake-tools.nvim";
        rev = "a4cd0b3";
        hash = "sha256-6A78j0CGDpoRcFWAlzviUB92kAemt9Dlzic1DvZNJ64=";
      };
    })
  ];

  programs.nixvim.extraConfigLua = ''
    require("cmake-tools").setup {
      cmake_command = "cmake", -- this is used to specify cmake command path
      ctest_command = "ctest", -- this is used to specify ctest command path
      cmake_regenerate_on_save = true, -- auto generate when save CMakeLists.txt
      cmake_generate_options = { "-DCMAKE_EXPORT_COMPILE_COMMANDS=1" }, -- this will be passed when invoke `CMakeGenerate`
      cmake_build_options = {"-j 12"}, -- this will be passed when invoke `CMakeBuild`
      cmake_build_directory = "out/${variant:buildType}", -- this is used to specify generate directory for cmake, allows macro expansion, relative to vim.loop.cwd()
      cmake_soft_link_compile_commands = true, -- this will automatically make a soft link from compile commands file to project root dir
      cmake_compile_commands_from_lsp = false, -- this will automatically set compile commands file location using lsp, to use it, please set `cmake_soft_link_compile_commands` to false
      cmake_kits_path = nil, -- this is used to specify global cmake kits path, see CMakeKits for detailed usage
      cmake_variants_message = {
        short = { show = true }, -- whether to show short message
        long = { show = true, max_length = 40 }, -- whether to show long message
      },
      cmake_dap_configuration = { -- debug settings for cmake
        name = "cpp",
        type = "codelldb",
        request = "launch",
        stopOnEntry = false,
        runInTerminal = true,
        console = "integratedTerminal",
      },
      cmake_executor = { -- executor to use
        name = "quickfix", -- name of the executor
        opts = {}, -- the options the executor will get, possible values depend on the executor type. See `default_opts` for possible values.
        default_opts = { -- a list of default and possible values for executors
          quickfix = {
            show = "always", -- "always", "only_on_error"
            position = "belowright", -- "vertical", "horizontal", "leftabove", "aboveleft", "rightbelow", "belowright", "topleft", "botright", use `:h vertical` for example to see help on them
            size = 10,
            encoding = "utf-8", -- if encoding is not "utf-8", it will be converted to "utf-8" using `vim.fn.iconv`
            auto_close_when_success = true, -- typically, you can use it with the "always" option; it will auto-close the quickfix buffer if the execution is successful.
          },
          toggleterm = {
            direction = "float", -- 'vertical' | 'horizontal' | 'tab' | 'float'
            close_on_exit = false, -- whether close the terminal when exit
            auto_scroll = true, -- whether auto scroll to the bottom
          },
          overseer = {
            new_task_opts = {
                strategy = {
                    "toggleterm",
                    direction = "horizontal",
                    autos_croll = true,
                    quit_on_exit = "success"
                }
            }, -- options to pass into the `overseer.new_task` command
            on_new_task = function(task)
                require("overseer").open(
                    { enter = false, direction = "right" }
                )
            end,   -- a function that gets overseer.Task when it is created, before calling `task:start`
          },
          terminal = {
            name = "Main Terminal",
            prefix_name = "[CMakeTools]: ", -- This must be included and must be unique, otherwise the terminals will not work. Do not use a simple spacebar " ", or any generic name
            split_direction = "horizontal", -- "horizontal", "vertical"
            split_size = 11,

            -- Window handling
            single_terminal_per_instance = true, -- Single viewport, multiple windows
            single_terminal_per_tab = true, -- Single viewport per tab
            keep_terminal_static_location = true, -- Static location of the viewport if avialable

            -- Running Tasks
            start_insert = false, -- If you want to enter terminal with :startinsert upon using :CMakeRun
            focus = false, -- Focus on terminal when cmake task is launched.
            do_not_add_newline = false, -- Do not hit enter on the command inserted when using :CMakeRun, allowing a chance to review or modify the command before hitting enter.
          }, -- terminal executor uses the values in cmake_terminal
        },
      },
      cmake_runner = { -- runner to use
        name = "terminal", -- name of the runner
        opts = {}, -- the options the runner will get, possible values depend on the runner type. See `default_opts` for possible values.
        default_opts = { -- a list of default and possible values for runners
          quickfix = {
            show = "always", -- "always", "only_on_error"
            position = "belowright", -- "bottom", "top"
            size = 10,
            encoding = "utf-8",
            auto_close_when_success = true, -- typically, you can use it with the "always" option; it will auto-close the quickfix buffer if the execution is successful.
          },
          toggleterm = {
            direction = "float", -- 'vertical' | 'horizontal' | 'tab' | 'float'
            close_on_exit = false, -- whether close the terminal when exit
            auto_scroll = true, -- whether auto scroll to the bottom
          },
          overseer = {
            new_task_opts = {
                strategy = {
                    "toggleterm",
                    direction = "horizontal",
                    autos_croll = true,
                    quit_on_exit = "success"
                }
            }, -- options to pass into the `overseer.new_task` command
            on_new_task = function(task)
            end,   -- a function that gets overseer.Task when it is created, before calling `task:start`
          },
          terminal = {
            name = "Main Terminal",
            prefix_name = "[CMakeTools]: ", -- This must be included and must be unique, otherwise the terminals will not work. Do not use a simple spacebar " ", or any generic name
            split_direction = "horizontal", -- "horizontal", "vertical"
            split_size = 11,

            -- Window handling
            single_terminal_per_instance = true, -- Single viewport, multiple windows
            single_terminal_per_tab = true, -- Single viewport per tab
            keep_terminal_static_location = true, -- Static location of the viewport if avialable

            -- Running Tasks
            start_insert = false, -- If you want to enter terminal with :startinsert upon using :CMakeRun
            focus = false, -- Focus on terminal when cmake task is launched.
            do_not_add_newline = false, -- Do not hit enter on the command inserted when using :CMakeRun, allowing a chance to review or modify the command before hitting enter.
          },
        },
      },
      cmake_notifications = {
        runner = { enabled = true },
        executor = { enabled = true },
        spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }, -- icons used for progress display
        refresh_rate_ms = 100, -- how often to iterate icons
      },
    }
  '';

  # Plugins
  programs.nixvim.plugins = {
    lightline.enable = true;

    leap.enable = true;

    toggleterm.enable = true;

    conform-nvim = {
      enable = true;
      formattersByFt = {
        nix = ["alejandra"];
        cpp = ["clang_format"];
      };
    };

    telescope = {
      enable = true;
      keymaps = {
        "<space>ff" = {
          action = "find_files";
          desc = "Find files";
        };
        "<C-e>" = {
          action = "git_files";
          desc = "Telescope Git Files";
        };
      };
    };

    lsp = {
      enable = true;
      servers = {
        clangd = {
          enable = true;
          filetypes = ["c" "cpp" "h" "hpp"];
          onAttach.function = ''
            local opts = { noremap=true, silent=true }
            -- Enable completion triggered by <c-x><c-o>
            vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

            -- Clangd inlay hints
            require("clangd_extensions.inlay_hints").setup_autocmd()
            require("clangd_extensions.inlay_hints").set_inlay_hints()

            -- Mappings.
            -- See `:help vim.lsp.*` for documentation on any of the below functions
            vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
            vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
            vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
            vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
            vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-p>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
            vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
            vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
            vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
            vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
            vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>h', '<cmd>ClangdSwitchSourceHeader<CR>', opts)
          '';
        };

        nil_ls = {
          enable = true;
          filetypes = ["nix"];
        };
      };
    };

    nvim-cmp = {
      enable = true;
      autoEnableSources = true;
      sources = [
        {name = "nvim_lsp";}
        {name = "luasnip";}
        {name = "buffer";}
        {name = "path";}
      ];

      snippet."expand" = "luasnip";

      mapping = {
        "<C-j>" = "cmp.mapping.select_next_item(cmp_select)";
        "<C-k>" = "cmp.mapping.select_prev_item(cmp_select)";
        "<CR>" = "cmp.mapping.confirm({select = true})";
        "<C-Space>" = "cmp.mapping.complete()";
      };
    };

    luasnip.enable = true;

    clangd-extensions = {
      enable = true;
      inlayHints.highlight = "Comment";
      inlayHints.inline = "vim.fn.has(\"nvim-0.10\") == 1";
      inlayHints.maxLenAlign = false;
      inlayHints.maxLenAlignPadding = 1;
      inlayHints.onlyCurrentLine = false;
      inlayHints.onlyCurrentLineAutocmd = "CursorMoved";
      inlayHints.otherHintsPrefix = "=> ";
      inlayHints.parameterHintsPrefix = "<- ";
      inlayHints.priority = 100;
      inlayHints.rightAlign = false;
      inlayHints.rightAlignPadding = 7;
      inlayHints.showParameterHints = true;
    };
  };
}
