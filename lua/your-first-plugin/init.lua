local function visual_selection_range()
    local _, csrow, cscol, _ = unpack(vim.fn.getpos("'<"))
    local _, cerow, cecol, _ = unpack(vim.fn.getpos("'>"))

    if csrow < cerow or (csrow == cerow and cscol <= cecol) then
        return csrow, cscol, cerow, cecol + 1
    else
        return cerow, cecol, csrow, cscol + 1
    end
end

local selection_to_string = function(buf)
    local rowfrom, colfrom, rowto, colto = visual_selection_range()

    local content = vim.api.nvim_buf_get_lines(buf, rowfrom - 1, rowto, false)

    content[1] = content[1]:sub(colfrom);
    content[#content] = content[#content]:sub(0, colto - 1)
    return table.concat(content, "\n")
end

local function try_place_on_lines(n, text)
    local curpos = vim.api.nvim_win_get_cursor(0)
    local curline = curpos[1]

    local win_width = vim.api.nvim_win_get_width(0)
    local offset_from_real_text = 5

    local chunks = {}
    local line_lengths = {}

    local cur_chunk_start = 1

    local what_we_can_fit = 0
    for i = 1, n, 1 do
        local cur_line_length = #vim.api.nvim_eval("getline(" .. tostring(curline + i - 1)  .. ")")
        line_lengths[i] = cur_line_length

        local remaining_space = math.ceil(2 * win_width / 3) - cur_line_length  - offset_from_real_text
        cur_chunk_start = cur_chunk_start + remaining_space

        chunks[i] = string.sub(text, cur_chunk_start, cur_chunk_start + remaining_space) 
        what_we_can_fit = what_we_can_fit + remaining_space
    end

    if #text > what_we_can_fit then
        return false
    end

    local this_note_marks = {}

    local bnr = vim.fn.bufnr('%')
    local ns_id = vim.api.nvim_create_namespace('demo')

    for i = 1, n, 1 do
        local opts = {
            end_line = 10,
            id = i,
            virt_text = {{chunks[i], "LineNr"}},
            -- virt_text_pos = 'eol',
            virt_text_win_col = line_lengths[i] + offset_from_real_text,
        }

        this_note_marks[i] = vim.api.nvim_buf_set_extmark(bnr, ns_id, tonumber(curline) + i - 2, 0, opts)
    end

    return this_note_marks
end

local function invoke_external_command()
    --[[ local txt = selection_to_string(0)
    local command = string.format("echo \"%s\"", txt)

    -- ok I've essentially been able to read a buffer,
    -- now I need to call an external command

    local handle = io.popen(command)
    local result = handle:read("*a")
    print(result) ]]
    local text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas eu ligula in sem tempus dapibus. Etiam sit amet orci eu dui consectetur laoreet. Maecenas blandit orci quis dui tincidunt luctus sed id tellus. Etiam at metus sit amet lorem varius imperdiet id non turpis. Donec ligula augue, ultricies a mi in, commodo congue tortor. Curabitur pellentesque, ante sed porta semper, risus massa rhoncus quam, non suscipit dolor ipsum nec velit. Donec dictum augue sit amet imperdiet fringilla. Praesent id tempor ipsum, eu eleifend orci. Donec in dolor vehicula, ullamcorper tortor viverra, vulputate nulla. Mauris malesuada metus volutpat nulla condimentum semper. Duis varius venenatis malesuada. Vestibulum porta varius mi, at eleifend eros placerat in. Fusce sed mi at libero dignissim volutpat."

    local curmarks
    for i = 1, 10, 1 do
        curmarks = try_place_on_lines(i, text)
        if curmarks then
            print("broken", i)
            break
        end
    end

    -- handle:close()
end

return {
    createFloatingWindow = invoke_external_command
}
