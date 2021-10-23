function mysplit(inputstr, sep)
    print(inputstr)
    if sep == nil then
        sep = "%s"
    end
    local t={}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        print(str)
        table.insert(t, str)
    end
    return t
end

return {
    mysplit = mysplit
}
