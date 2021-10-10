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

return {
    visual_selection_range = visual_selection_range,
    selection_to_string = selection_to_string
}
