local function place(text)
    local curpos = vim.api.nvim_win_get_cursor(0)
    local cur_row = curpos[1]

    local win_width = vim.api.nvim_win_get_width(0)
    local float_window_start = math.ceil(win_width * 0.6)

    local allowed_window_width = win_width - float_window_start

    require"hal-9000.floating".create_floating_window(text, cur_row, allowed_window_width)
end

local function suggest3() 
    local stdin = vim.loop.new_pipe(false)
    local stdout = vim.loop.new_pipe(false)
    local stderr = vim.loop.new_pipe(false)

    print("stdin", stdin)
    print("stdout", stdout)
    print("stderr", stderr)

    local handle, pid = vim.loop.spawn("cat", {
        stdio = {stdin, stdout, stderr}
    }, function(code, signal) -- on exit
        print("exit code", code)
        print("exit signal", signal)
    end)

    print("process opened", handle, pid)

    vim.loop.read_start(stdout, function(err, data)
        assert(not err, err)
        if data then
            print("stdout chunk", stdout, data)
        else
            print("stdout end", stdout)
        end
    end)

    vim.loop.read_start(stderr, function(err, data)
        assert(not err, err)
        if data then
            print("stderr chunk", stderr, data)
        else
            print("stderr end", stderr)
        end
    end)

    vim.loop.write(stdin, "Hello World")

    vim.loop.shutdown(stdin, function()
        print("stdin shutdown", stdin)
        vim.loop.close(handle, function()
            print("process closed", handle, pid)
        end)
    end)
end

local model_result = {}
local function suggest()
    local cur_path = require"hal-9000.os-helpers".script_path()
    -- local txt = require"hal-9000.selection-helpers".selection_to_string(0)
    local txt = "I am a text without the shitty characters"

    local words_to_generate = 300
    local pyfolder_path = cur_path .. '../../py'

    local stdout = vim.loop.new_pipe(false)
    local stderr = vim.loop.new_pipe(false)

    Handle, Pid = vim.loop.spawn("python3",
    {
        args = {
            pyfolder_path .. "/generate_text.py", 
            "\"" .. txt .. "\"", 
            words_to_generate
        },
        stdio = {nil, stdout, stderr}
    },
    function (code, signal)
        print("code and signal", code, signal)
        vim.loop.close(Handle, function()
            print("process closed", Handle, Pid)
        end)

        for key, value in pairs(model_result) do
            print(key, value)
        end
    end)

    vim.loop.read_start(stdout, function(err, data)
        assert(not err, err)
        if data then
            model_result[#model_result+1] = data
        else
            print("stdout end", stdout)
        end
    end)

    vim.loop.read_start(stderr, function(err, data)
        assert(not err, err)
        if data then
            print("stderr chunk", stderr, data)
        else
            print("stderr end", stderr)
        end
    end)
end

return {
    suggest = suggest,
}
