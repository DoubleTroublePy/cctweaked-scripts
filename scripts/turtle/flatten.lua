function forward()
  if turtle.getFuelLevel() > 10 then return end
  turtle.refuel(1)
end

function dig_move()
  if turtle.detect() then
    dig()
  end
  forward()
end

-- main loop
print("lenght: ")
local lenght = io.read()

print("width: ")
local width = io.read()

print("depth: ")
local depth = io.read()
local side = true

for level=1, depth do
  for row=1, width do
    for line=1, lenght do
      dig_move()
    end
    if side then
      turtle.turnLeft()
      forward()
      turtle.turnLeft()
    else
      turtle.turnRight()
      forward()
      turtle.turnRight()
    end
    side = not side
  end
  turtle.digDown()
  turtle.down()
end

