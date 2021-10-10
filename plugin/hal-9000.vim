fun! ReloadPlugin() 
    lua for k, v in pairs(package.loaded) do if k:match("^hal%-9000") then package.loaded[k] = nil end end
endfun

fun! Suggest()
    call ReloadPlugin()
    lua require("hal-9000").suggest()
endfun

fun! ClearMarks()
    call ReloadPlugin()
    lua require("hal-9000").clearMarks()
endfun

nnoremap txt :call Suggest()<CR>
nnoremap rmrm :call ClearMarks()<CR>

" let g:your_global_var_value = 42
augroup Suggest
    autocmd!
augroup END 

augroup ClearMarks
    autocmd!
augroup END 
