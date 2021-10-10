local buf_h  
local win_id

local function create_floating_window()
    local width = vim.api.nvim_win_get_width(0)
    local height = vim.api.nvim_win_get_height(0)

    print("Window size", width, height)

    buf_h = vim.api.nvim_create_buf(false, true)
    win_id = vim.api.nvim_open_win(buf_h, true, {
        relative="editor",
        width = width - 4,
        height = height - 4,
    })
end

local function close_floating_window() 
    vim.api.nvim_win_close(win_id)
end

return {
    close_floating_window = close_floating_window,
    create_floating_window = create_floating_window
}
