---@class Lastplace
local Lastplace = {}

---@class Lastplace.Opts
---A tuple containing both lists of excluded filetypes and buftypes.
---
---Default:
--- - bt: `{ 'quickfix', 'nofile', 'help' }`
--- - ft: `{ 'gitcommit', 'gitrebase', 'svn', 'hgcommit' }`
---`
---@field ignore? { ft: string[], bt: string[] }
---If true it wil automatically open folds upon file reading.
---
---Default: `true`
---@field open_folds? boolean

---@type Lastplace.Opts
Lastplace.options = {}

---@return Lastplace.Opts
function Lastplace.get_defaults()
    local opts = { ---@type Lastplace.Opts
        ignore = {
            bt = { 'quickfix', 'nofile', 'help' },
            ft = { 'gitcommit', 'gitrebase', 'svn', 'hgcommit' },
        },
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

local function set_cursor_position()
    local last_line = vim.fn.line([['"]])
    local buff_last_line = vim.fn.line('$')
    local window_last_line = vim.fn.line('w$')
    local window_first_line = vim.fn.line('w0')
    -- If the last line is set and the less than the last line in the buffer
    if last_line > 0 and last_line <= buff_last_line then
        -- Check if the last line of the buffer is the same as the window
        if window_last_line == buff_last_line then
            -- Set line to last line edited
            vim.api.nvim_command([[keepjumps normal! g`"]])
            -- Try to center
        elseif buff_last_line - last_line > ((window_last_line - window_first_line) / 2) - 1 then
            vim.api.nvim_command([[keepjumps normal! g`"zz]])
        else
            vim.api.nvim_command([[keepjumps normal! G'"<c-e>]])
        end
    end
    if vim.fn.foldclosed('.') ~= -1 and Lastplace.options.open_folds then
        vim.api.nvim_command([[normal! zvzz]])
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
        -- reset cursor to first line
        vim.api.nvim_command([[normal! gg]])
        return
    end

    -- If a line has already been specified on the command line, we are done
    --   nvim file +num
    if vim.fn.line('.') > 1 then
        return
    end
    set_cursor_position()
end

---@param buffer integer
function Lastplace.lastplace_ft(buffer)
    local ignore_bt = Lastplace.options.ignore.bt
    if vim.list_contains(ignore_bt, vim.bo[buffer].buftype) then
        return
    end

    local ignore_ft = Lastplace.options.ignore.ft
    if vim.list_contains(ignore_ft, vim.bo[buffer].filetype) then
        -- reset cursor to first line
        vim.api.nvim_command([[normal! gg]])
        return
    end

    -- If a line has already been set by the BufReadPost event or on the command
    -- line, we are done.
    if vim.fn.line('.') > 1 then
        return
    end

    -- This shouldn't be reached but, better have it ;-)
    set_cursor_position()
end

return Lastplace
-- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
