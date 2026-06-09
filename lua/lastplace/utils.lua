---@class lastplace.Utils.FileStats
---@field total_lines integer
---@field current_line integer
---@field current_col integer
---@field last_position [integer, integer]
---@field filetype string
---@field buftype string

---@class lastplace.Utils
local M = {}

---@return boolean at_beginning
function M.is_at_beginning()
  local line = vim.fn.line(".")
  local col = vim.fn.col(".")
  return line == 1 and col == 1
end

---@return lastplace.Utils.FileStats stats
function M.get_file_stats()
  return {
    total_lines = vim.fn.line("$"),
    current_line = vim.fn.line("."),
    current_col = vim.fn.col("."),
    last_position = { vim.fn.line("'\""), vim.fn.col("'\"") },
    filetype = vim.bo.filetype,
    buftype = vim.bo.buftype,
  }
end

---@param line integer
---@param col integer
---@return string formatted_pos
function M.format_position(line, col)
  return ("%d:%d"):format(line, col)
end

return M
