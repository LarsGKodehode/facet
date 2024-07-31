-- ===========================================================================
-- Settings
-- ===========================================================================
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  command = "TableModeEnable",
})
