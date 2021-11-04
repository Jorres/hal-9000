fun! ReloadPlugin() 
    lua for k, v in pairs(package.loaded) do if k:match("^hal%-9000") then package.loaded[k] = nil end end
endfun

nnoremap <leader>hs :lua require("hal-9000").suggest()<CR>
nnoremap <leader>hc :lua require("hal-9000").clear_windows()<CR>
nnoremap <leader>hr :call ReloadPlugin()<CR>
nnoremap <leader>ht :lua require("hal-9000").do_talk()<CR>
