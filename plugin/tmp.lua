name = "Derek"

print("Hello world")

io.write("Size of string ", #name, "\n")

longString = [[
hell
 hello

]]

print(longString .. name)


age = 16
if age < 15 then
io.write("you can go to school");
elseif age <= 17 then
io.write("  you maybe go to school");
end

io.write(string.len(longString), "\n")


aTable = {

}

for i = 1, 10, 1 do
    aTable[i] = i
end

io.write("Size of a table: ", #aTable, "\n") 

function getSum(num1, num2)
    return num1 + num2
end

print("sum of 1 and 2 is %d", getSum(1, 2), "\n")

print(getSum)
