function forward()
  if turtle.getFuelLevel() < 10 then
    turtle.refuel(1)
  end
  turtle.forward()
end

function dig_move()
  if turtle.detect() then
    turtle.dig()
  end
  forward()
end

-- main loop
print("lenght: ")
local lenght = io.read()-1

print("width: ")
local width = io.read()-1

print("depth: ")
local depth = io.read()
local side = true

for level=1, depth do
  for row=1, width do
    for line=1, lenght do
      dig_move()
    end
    if side then
      turtle.turnRight()
      forward()
      turtle.turnRight()
    else
      turtle.turnLeft()
      forward()
      turtle.turnLeft()
    end
    side = not side
  end
  if level ~= depth then
    turtle.digDown()
    turtle.down()
  end
end

