fun! YourFirstPlugin()
    lua for k, v in pairs(package.loaded) do if k:match("^your%-first-%-plugin") then package.loaded[k] = nil end end
    lua require("your-first-plugin").createFloatingWindow()
endfun

let g:your_global_var_value = 42
augroup YourFirstPlugin
    autocmd!
augroup END 
