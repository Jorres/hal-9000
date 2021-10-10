fun! Suggest()
    lua for k, v in pairs(package.loaded) do if k:match("^your%-first-%-plugin") then package.loaded[k] = nil end end
    lua require("your-first-plugin").suggest()
endfun

fun! ClearMarks()
    lua for k, v in pairs(package.loaded) do if k:match("^your%-first-%-plugin") then package.loaded[k] = nil end end
    lua require("your-first-plugin").clearMarks()
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
