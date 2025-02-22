---@type LazySpec
return {
  -- 🔎 Search & Fuzzy Finder
  { "junegunn/fzf.vim" }, -- Fuzzy finder for files & commands
  { "junegunn/fzf" }, -- Core fzf binary
  {
    "nvim-telescope/telescope.nvim", -- Powerful fuzzy finder
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("telescope").setup {
        defaults = { file_ignore_patterns = { "node_modules", ".git" } },
      }
    end,
  },

  -- 🛠️ Debugging & Development
  { "mfussenegger/nvim-dap" }, -- Debug Adapter Protocol (DAP) for debugging
  { "rcarriga/nvim-dap-ui", dependencies = { "mfussenegger/nvim-dap" } }, -- UI for DAP
  { "simrat39/rust-tools.nvim", dependencies = { "neovim/nvim-lspconfig" } }, -- Rust LSP & debugging

  -- 🖥️ Terminal & Shell
  {
    "akinsho/toggleterm.nvim", -- Embedded terminal in Neovim
    opts = { size = 20, open_mapping = [[<C-\>]], direction = "float" },
  },

  -- ✍️ Snippets & Auto-Pairing
  {
    "L3MON4D3/LuaSnip", -- Snippet engine
    config = function(plugin, opts)
      require "astronvim.plugins.configs.luasnip"(plugin, opts) -- Load AstroNvim defaults
      local luasnip = require "luasnip"
      luasnip.filetype_extend("javascript", { "javascriptreact" })
    end,
  },
  {
    "windwp/nvim-autopairs", -- Auto-closing brackets & quotes
    config = function(plugin, opts)
      require "astronvim.plugins.configs.nvim-autopairs"(plugin, opts) -- Load AstroNvim defaults
      local npairs = require "nvim-autopairs"
      local Rule = require "nvim-autopairs.rule"
      local cond = require "nvim-autopairs.conds"

      npairs.add_rules {
        Rule("$", "$", { "tex", "latex" })
          :with_pair(cond.not_after_regex "%%") -- Prevent pairing before '%'
          :with_pair(cond.not_before_regex("xxx", 3)) -- Prevent pairing after "xxx"
          :with_move(cond.none()) -- Prevent moving right when repeating character
          :with_del(cond.not_after_regex "xx") -- Prevent deletion if next char is "xx"
          :with_cr(cond.none()), -- Disable newline pairing
      }
    end,
  },

  -- 🔥 Diagnostics & Code Navigation
  {
    "folke/trouble.nvim", -- Improved diagnostics UI
    opts = {},
    cmd = "Trouble",
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" },
      { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics (Trouble)" },
      { "<leader>cs", "<cmd>Trouble symbols toggle focus=false<cr>", desc = "Symbols (Trouble)" },
      {
        "<leader>cl",
        "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
        desc = "LSP Definitions / References (Trouble)",
      },
      { "<leader>xL", "<cmd>Trouble loclist toggle<cr>", desc = "Location List (Trouble)" },
      { "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix List (Trouble)" },
    },
  },

  -- LSP Configuration for C++
  {
    "neovim/nvim-lspconfig",
    config = function()
      local lspconfig = require "lspconfig"

      -- C++ LSP (clangd)
      lspconfig.clangd.setup {
        cmd = { "clangd" },
        filetypes = { "c", "cpp", "objc", "objcpp" },
        root_dir = lspconfig.util.root_pattern("compile_commands.json", "compile_flags.txt", ".git", "CMakeLists.txt"),
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
      }

      -- CMake LSP
      lspconfig.cmake.setup {
        cmd = { "cmake-language-server" },
        filetypes = { "cmake" },
        root_dir = lspconfig.util.root_pattern "CMakeLists.txt",
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
      }
    end,
  },

  -- Completion Engine
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp", -- LSP completion
      "hrsh7th/cmp-buffer", -- Buffer words completion
      "hrsh7th/cmp-path", -- File path completion
      "L3MON4D3/LuaSnip", -- Snippet engine
    },
    config = function()
      local cmp = require "cmp"
      cmp.setup {
        mapping = cmp.mapping.preset.insert {
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm { select = true },
        },
        sources = cmp.config.sources {
          { name = "nvim_lsp" },
          { name = "buffer" },
          { name = "path" },
        },
      }
    end,
  },

  {
    -- Debugger
    "mfussenegger/nvim-dap",
    config = function()
      local dap = require "dap"
      dap.adapters.lldb = {
        type = "executable",
        command = "/usr/bin/lldb-vscode", -- Change if using another path
        name = "lldb",
      }
      dap.configurations.cpp = {
        {
          name = "Launch",
          type = "lldb",
          request = "launch",
          program = function() return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file") end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
        },
      }
    end,
  },
}
