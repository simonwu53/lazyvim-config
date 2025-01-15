return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    sources = { "filesystem", "buffers", "git_status", "document_symbols" },
    document_symbols = {
      follow_cursor = true,
    },
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
