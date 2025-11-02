---@class Lastplace
local Lastplace = {}

---@type Lastplace.Opts
Lastplace.options = {}

---@return Lastplace.Opts
function Lastplace.get_defaults()
    ---@class Lastplace.Opts
    local opts = {
        ---A tuple containing both lists of excluded filetypes and buftypes.
        ---
        ---Default:
        --- - bt: `{ 'quickfix', 'nofile', 'help' }`
        --- - ft: `{ 'gitcommit', 'gitrebase', 'svn', 'hgcommit' }`
        ---
        ignore = { ---@type { ft: string[], bt: string[] }
            bt = { 'quickfix', 'nofile', 'help' },
            ft = { 'gitcommit', 'gitrebase', 'svn', 'hgcommit' },
        },
        ---If true it wil automatically open folds upon file reading.
        ---
        ---Default: `true`
        ---
        ---@type boolean
        open_folds = true,
    }
    return opts
end

---@param opts? Lastplace.Opts
function Lastplace.setup(opts)
    if vim.fn.has('nvim-0.11') then
        vim.validate('opts', opts, 'table', true, 'Lastplace.Opts')
    else
        vim.validate({ opts = { opts, { 'table', 'nil' } } })
    end

    Lastplace.options = vim.tbl_deep_extend('keep', opts or {}, Lastplace.get_defaults())

    local group = vim.api.nvim_create_augroup('NvimLastplace', { clear = true })
    vim.api.nvim_create_autocmd('BufRead', {
        group = group,
        callback = function(ev)
            vim.api.nvim_create_autocmd('BufWinEnter', {
                group = group,
                buffer = ev.buf,
                callback = function()
                    Lastplace.lastplace_ft(ev.buf)
                end,
            })
        end,
    })
end

---Reset cursor to first line.
---
local function reset_to_top()
    vim.cmd.norm({ 'gg', bang = true })
end

---Attempt to center the line in the buffer.
---
local function center_line()
    vim.cmd.norm({ 'zvzz', bang = true })
end

---Sets line to last line edited.
--
local function set_to_last_place()
    vim.cmd('keepjumps normal! g`"')
end

---Set cursor to last registered position.
---
---See `:h 'quote` for more info.
---
local function last_registered_pos()
    vim.cmd([[keepjumps normal! G'"<C-e>]])
end

local function set_cursor_position()
    local last = vim.fn.line([['"]])
    local buf_last = vim.fn.line('$')
    local window = { first = vim.fn.line('w0'), last = vim.fn.line('w$') }
    -- If the last line is set and the less than the last line in the buffer
    if last > 0 and last <= buf_last then
        if window.last == buf_last then
            set_to_last_place()
        elseif buf_last - last > math.floor((window.last - window.first) / 2) - 1 then
            set_to_last_place()
            center_line()
        else
            last_registered_pos()
        end
    end
    if vim.fn.foldclosed('.') ~= -1 and Lastplace.options.open_folds then
        center_line()
    end
end

function Lastplace.lastplace_buf()
    local bufnr = vim.api.nvim_get_current_buf()
    local ignore_bt = Lastplace.options.ignore.bt
    if vim.list_contains(ignore_bt, vim.bo[bufnr].buftype) then
        return
    end

    local ignore_ft = Lastplace.options.ignore.ft
    if vim.list_contains(ignore_ft, vim.bo[bufnr].filetype) then
        reset_to_top()
        return
    end

    ---Return if the file doesn't exist, like a new and unsaved file
    ---CREDITS: https://github.com/vladdoster/remember.nvim/blob/master/lua/remember.lua#L58
    if vim.fn.empty(vim.fn.glob(vim.fn.expand('%'))) ~= 0 then
        return
    end

    ---If a line has already specified or on the cmdline, stop.
    ---
    ---Use case: `nvim file +num`
    if vim.fn.line('.') > 1 then
        return
    end

    set_cursor_position()
end

---@param bufnr integer
function Lastplace.lastplace_ft(bufnr)
    local ignore_bt = Lastplace.options.ignore.bt
    if vim.list_contains(ignore_bt, vim.bo[bufnr].buftype) then
        return
    end

    local ignore_ft = Lastplace.options.ignore.ft
    if vim.list_contains(ignore_ft, vim.bo[bufnr].filetype) then
        reset_to_top()
        return
    end

    ---If a line has already been set by the `BufReadPost` event or on the cmdline...
    if vim.fn.line('.') > 1 then
        return
    end

    ---Ideally this shouldn't be reached but better have it than not.
    set_cursor_position()
end

return Lastplace
-- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
