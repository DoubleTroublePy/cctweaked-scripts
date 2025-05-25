turtle.refuel()
scan = peripheral.wrap("left")

data = scan.scan(16)
assert(data ~= nil, "... data is nil ...")
f = fs.open("chunk.csv", "w")

-- name, tags, x, y, z
for _, d in ipairs(data) do
    f.write(d.name .. ", " .. d.x .. ", " .. d.y .. ", " .. d.z .. "\n")
end
f.close()

