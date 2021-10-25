local function close_floating_window(win_id)
    if vim.api.nvim_win_is_valid(win_id) then
        vim.api.nvim_win_close(win_id, true)
    end
end

local function set_text(text, buf_id)
    local t = require"hal-9000.algo-helpers".mysplit(text, "\n")
    vim.api.nvim_buf_set_lines(buf_id, 0, 0, true, t)
end

local function create_floating_window(text, row, col, allowed_window_width)
    local window_pad_and_bord = 2

    local allowed_str_width = allowed_window_width - 2 * window_pad_and_bord
    local resulting_window_height = (math.ceil(#text / allowed_str_width) + 1) + 2 * window_pad_and_bord

    local buf_id = vim.api.nvim_create_buf(false, true)
    local win_id = vim.api.nvim_open_win(buf_id, true, {
        relative="editor",
        width = allowed_window_width,
        height = resulting_window_height,
        col = col,
        row = row,
        style = "minimal",
        border="single"
    })

    vim.api.nvim_win_set_option(win_id, "wrap", true)
    vim.api.nvim_win_set_option(win_id, "winhighlight", "Normal:MatchParen")

    set_text(text, buf_id)

    return win_id, buf_id
end

return {
    close_floating_window = close_floating_window,
    create_floating_window = create_floating_window,
    set_text = set_text
}
