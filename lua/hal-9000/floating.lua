local buf_h
local win_id = -1

local function close_floating_window()
    if vim.api.nvim_win_is_valid(win_id) then
        vim.api.nvim_win_close(win_id)
    end
end

local function create_floating_window(text, row, allowed_window_width)
    if win_id ~= -1 then
        close_floating_window()
    end

    local window_pad_and_bord = 2

    local win_width = vim.api.nvim_win_get_width(0)

    local allowed_str_width = allowed_window_width - 2 * window_pad_and_bord
    local resulting_window_height= (math.ceil(#text / allowed_str_width) + 1) + 2 * window_pad_and_bord

    buf_h = vim.api.nvim_create_buf(false, true)
    win_id = vim.api.nvim_open_win(buf_h, true, {
        relative="editor",
        width = allowed_window_width,
        height = resulting_window_height,
        col = win_width - allowed_window_width,
        row = row,
        style="minimal",
        border="rounded"
    })

    vim.api.nvim_win_set_option(win_id, "wrap", true)

    local t = require"hal-9000.algo-helpers".mysplit(text, "\n")

    vim.api.nvim_buf_set_lines(buf_h, 0, 0, true, t)
end


return {
    close_floating_window = close_floating_window,
    create_floating_window = create_floating_window
}
