local model_result_ready = false
local suggest_win_id = -1
local suggest_buf_id = -1
local current_animation_frame = 0

local animation_frames = {}
animation_frames[0] = {"     ", " .   ", "     "}
animation_frames[1] = {"     ", " ..  ", "     "}
animation_frames[2] = {"     ", " ... ", "     "}
print(animation_frames)

local function replace_idle_with_results(text)
    model_result_ready = true
    require"hal-9000.floating".set_text(text)
end

local function loop_waiting_for_model_results() 
    if not model_result_ready then
        vim.defer_fn(function()
            if model_result_ready then
                return
            end
            print(animation_frames)

            for index, value in pairs(animation_frames[math.fmod(current_animation_frame, 3)]) do
                print(index, value)
            end

            local lines_in_preloader = vim.api.nvim_buf_line_count(suggest_buf_id)
            vim.api.nvim_buf_set_lines(suggest_buf_id, 0, lines_in_preloader, true, animation_frames[math.fmod(current_animation_frame, 3)])
            current_animation_frame = current_animation_frame + 1
            loop_waiting_for_model_results()
        end, 100)
    end
end

local function setup_animation_window(window_pos, win_width)
    local start_row = window_pos[1]
    local start_col = math.ceil(win_width * 0.4)
    local right_padding = math.ceil(win_width * 0.2)

    local allowed_window_width = win_width - start_col - right_padding

    suggest_win_id, suggest_buf_id = require"hal-9000.floating".create_floating_window(
        "", start_row, start_col, allowed_window_width
    )

    loop_waiting_for_model_results()
end

local function clear_windows()
    require"hal-9000.floating".close_floating_window(suggest_win_id)
end

local model_result = {}
local function suggest()
    local cur_path = require"hal-9000.os-helpers".script_path()
    -- local txt = require"hal-9000.selection-helpers".selection_to_string(0)
    local txt = "Hello? Is anyone in there?"

    local window_pos = vim.api.nvim_win_get_cursor(0)
    local win_width = vim.api.nvim_win_get_width(0)

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

        print("from model")
        for key, value in pairs(model_result) do
            print(key, value)
        end

        print("model concat", table.concat(model_result, "\n"))

        vim.schedule(function ()
            replace_idle_with_results(table.concat(model_result, "\n"))
        end)
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

    setup_animation_window(window_pos, win_width)
end

return {
    suggest = suggest,
    clearWindows = clear_windows
}
