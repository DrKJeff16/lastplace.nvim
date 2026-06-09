---@class lastplace.Config
local M = {}

---@class lastplaceOpts
---@field ignore_filetypes? string[]
---@field ignore_buftypes? string[]
---@field center_on_jump? boolean
---@field jump_only_if_not_visible? boolean
---@field min_lines? integer
---@field max_line? integer
---@field open_folds? boolean
---@field debug? boolean
local default_config = {
  ignore_filetypes = {
    "gitcommit",
    "gitrebase",
    "svn",
    "hgcommit",
    "xxd",
    "COMMIT_EDITMSG",
  },

  ignore_buftypes = {
    "quickfix",
    "nofile",
    "help",
    "terminal",
  },

  center_on_jump = true,
  jump_only_if_not_visible = false,
  min_lines = 10,
  max_line = 0,
  open_folds = true,
  debug = false,
}

local current_config = {} ---@type lastplaceOpts

---@param user_config lastplaceOpts
function M.setup(user_config)
  current_config = vim.tbl_deep_extend("force", default_config, user_config or {}) --[[@as lastplaceOpts]]
end

---@return lastplaceOpts current_config
function M.get()
  return current_config
end

---@return lastplaceOpts default_config
function M.get_default()
  return default_config
end

return M
