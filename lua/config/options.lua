-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- add shortcuts for opening diagnostics
vim.keymap.set("n", "<leader>dd", vim.diagnostic.open_float, { desc = "Show diagnostic [E]rror messages" })

-- Disable LazyVim auto format
vim.g.autoformat = false

-- add shortcuts for copilot auto_trigger
vim.keymap.set("n", "<leader>at", function()
  require("copilot.suggestion").toggle_auto_trigger()
end, { desc = "Toggle Copilot auto-[T]rigger" })

-- add shortcuts for lsp restart
vim.keymap.set("n", "<leader>cL", function()
  vim.cmd([[ LspRestart ]])
end, { desc = "Restart [L]SP" })
