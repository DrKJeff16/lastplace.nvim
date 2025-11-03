---@class Lastplace.Actions
local Actions = {}

---Reset cursor to first line.
---
function Actions.reset_to_top()
    vim.cmd.norm({ 'gg', bang = true })
end

---Attempt to center the line in the buffer.
---
function Actions.center_line()
    vim.cmd.norm({ 'zvzz', bang = true })
end

---Sets line to last line edited.
--
function Actions.set_to_last_place()
    vim.cmd('keepjumps normal! g`"')
end

---Set cursor to last registered position.
---
---See `:h 'quote` for more info.
---
function Actions.last_registered_pos()
    vim.cmd([[keepjumps normal! G'"<C-e>]])
end

return Actions
-- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
