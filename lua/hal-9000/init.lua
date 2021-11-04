local M = {}

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
    require"hal-9000.floating".set_text(text, suggest_buf_id)
end

M.loop_waiting_for_model_results = function()
    if not model_result_ready then
        vim.defer_fn(function()
            if model_result_ready then
                model_result_ready = false
                return
            end

            local lines_in_preloader = vim.api.nvim_buf_line_count(suggest_buf_id)
            vim.api.nvim_buf_set_lines(suggest_buf_id, 0, lines_in_preloader, true, animation_frames[math.fmod(current_animation_frame, 3)])
            current_animation_frame = current_animation_frame + 1
            M.loop_waiting_for_model_results()
        end, 300)
    end
end

M.setup_animation_window = function(win_width)
    local start_col = math.ceil(win_width * 0.4)
    local right_padding = math.ceil(win_width * 0.2)

    local allowed_window_width = win_width - start_col - right_padding

    suggest_win_id, suggest_buf_id = require"hal-9000.floating".create_floating_window(
        "", start_col, allowed_window_width
    )

    M.loop_waiting_for_model_results()
end

M.clear_windows = function()
    require"hal-9000.floating".close_floating_window(suggest_win_id)
end

local model_result = {}
M.suggest = function()
    local cur_path = require"hal-9000.os-helpers".script_path()
    -- local txt = require"hal-9000.selection-helpers".selection_to_string(0)
    local txt = "Hello? Is anyone in there?"

    local win_width = vim.api.nvim_win_get_width(0)

    local words_to_generate = 300
    local pyfolder_path = cur_path .. '../../py'

    local http = require("socket.http")
    local body, code, headers, status = http.request("https://www.google.com")
    print(code, status, #body)

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

    M.setup_animation_window(win_width)
end

M.do_talk = function()
    local txt = "Hello? Is anyone in there?"

    -- This is an external dependency, you need to 
    -- deal with it somehow if you want to distribute the plugin
    -- Although 3Gb model is a problem in itself...
    -- TODO replace this with curl
    local json = require('cjson')

    local tmp = {}
    tmp['text'] = txt
    local data = require"urlencode".encode_url(json.encode(tmp))
    print(data)

    local http_request = require"http.request"
    local request = http_request.new_from_uri(string.format(
        "http://localhost:5000/append-conf?text=%s", 
        data
    ))

    local _, stream = assert(request:go())
    local body = assert(stream:get_body_as_string())
    print(json.decode(body)['data'])
end

return M
