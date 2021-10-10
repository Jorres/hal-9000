local function visual_selection_range()
    local _, csrow, cscol, _ = unpack(vim.fn.getpos("'<"))
    local _, cerow, cecol, _ = unpack(vim.fn.getpos("'>"))

    if csrow < cerow or (csrow == cerow and cscol <= cecol) then
        return csrow, cscol, cerow, cecol + 1
    else
        return cerow, cecol, csrow, cscol + 1
    end
end

function script_path()
   local str = debug.getinfo(2, "S").source:sub(2)
   return str:match("(.*/)")
end

local selection_to_string = function(buf)
    local rowfrom, colfrom, rowto, colto = visual_selection_range()

    local content = vim.api.nvim_buf_get_lines(buf, rowfrom - 1, rowto, false)

    content[1] = content[1]:sub(colfrom);
    content[#content] = content[#content]:sub(0, colto - 1)
    return table.concat(content, "\n")
end

local last_marks_placed = {}
local bnr = vim.fn.bufnr('%')
local ns_id = vim.api.nvim_create_namespace('demo')

local function clear_all_marks() 
    for _, extmark_id in pairs(last_marks_placed) do
        vim.api.nvim_buf_set_extmark(bnr, ns_id, extmark_id)
    end
end

local function try_place_on_lines(n, text)
    local curpos = vim.api.nvim_win_get_cursor(0)
    local curline = curpos[1]

    local win_width = vim.api.nvim_win_get_width(0)
    local offset_from_real_text = 5
    local right_text_border =    math.ceil(3 * win_width / 4)

    local min_remaining_space = win_width
    for i = 1, n, 1 do
        local cur_line_length = #vim.api.nvim_eval("getline(" .. tostring(curline + i - 1)  .. ")")

        local remaining_space =  right_text_border - cur_line_length  - offset_from_real_text

        if remaining_space < min_remaining_space then
            print(remaining_space)
            min_remaining_space = remaining_space
        end
    end

    if #text > min_remaining_space * n then
        return false
    end

    local this_note_marks = {}

    clear_all_marks()
    -- would have been required if I were to place them in different namespaces

    local cur_chunk_start = 1
    for i = 1, n, 1 do
        local cur_chunk = string.sub(text, cur_chunk_start, cur_chunk_start + min_remaining_space - 1)
        cur_chunk_start = cur_chunk_start + min_remaining_space
        local opts = {
            end_line = 10,
            id = i,
            virt_text = {{cur_chunk, "LineNr"}},
            -- virt_text_pos = 'eol',
            virt_text_win_col = right_text_border - min_remaining_space,
        }

        this_note_marks[i] = vim.api.nvim_buf_set_extmark(bnr, ns_id, tonumber(curline) + i - 2, 0, opts)
    end

    last_marks_placed = this_note_marks
    return true
end
  





-- I have a wonderful text, and it is about to complete itself.  
--
--
--
--
--
--
--
local function file_exists(file)
  local f = io.open(file, "rb")
  if f then f:close() end
  return f ~= nil
end

local function lines_from(file)
    if not file_exists(file) then return {} end
    local lines = {}                 
    for line in io.lines(file) do 
        lines[#lines + 1] = line
    end
    return lines
end


-- Hey, maybe you want to complete me? 






local function suggest()
    local cur_path = script_path()
    local txt = selection_to_string(0)
    print(txt)
    local words_to_generate = 100
    local file = cur_path .. '/tmp3.txt'
    local command = string.format(
        "python3 %s/generate_text.py \"%s\" \"%d\" > %s 2> /dev/null",
        cur_path,
        txt,
        words_to_generate,
        file
    )

    os.execute(command)
    -- os.execute('sleep 30')

    --[[ local lines = lines_from(file)
    -- print all line numbers and their contents
    for k,v in pairs(lines) do
        print('line[' .. k .. ']', v)
    end ]]

    local fileh = io.open(file, "r")
    local content = fileh:read("*all")
    fileh:close()
    print(content)

    local curmarks = {}
    for i = 1, 100, 1 do
        curmarks = try_place_on_lines(i, content)
        if curmarks then
            print("broken", i)
            break
        end
    end
end

return {
    suggest = suggest,
    clearMarks = clear_all_marks
}
