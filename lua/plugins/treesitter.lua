-- Customize Treesitter

---@type LazySpec
return {
  "nvim-treesitter/nvim-treesitter",
  opts = {
    ensure_installed = {
      -- ✨ Essential Core Languages
      "cpp",
      "c",
      "cmake",
      "lua",
      "vim",
      "bash",
      "json",
      "yaml",
      "markdown",
      "markdown_inline",

      -- 🏗️ Programming Languages
      "cpp",
      "c",
      "rust",
      "python",

      -- 🔎 Penetration Testing & Security-Related
      "regex",
      "jsonc",

      -- 📡 Networking & Protocols
      "toml",
      "dockerfile",
    },
    highlight = {
      enable = true, -- Enable syntax highlighting
    },
    indent = {
      enable = true, -- Enable Treesitter-based indentation
    },
  },
}
