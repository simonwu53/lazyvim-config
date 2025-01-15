return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    sources = { "filesystem", "buffers", "git_status", "document_symbols" },
    document_symbols = {
      follow_cursor = true,
    },
    filesystem = {
      filtered_items = {
        hide_gitignored = false,
        always_show_by_pattern = {
          ".env*",
          ".gitignore",
        },
        never_show = {
          ".DS_Store",
          "thumbs.db",
          "__pycache__",
        },
      }
    }
  },
  keys = {
    {
      "<leader>ce",
      function()
        require("neo-tree.command").execute({ source = "document_symbols", toggle = true })
      end,
      desc = "Symbol Explorer",
    },
  }
}
