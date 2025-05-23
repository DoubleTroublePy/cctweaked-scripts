-- author: dtpy
-- version: 0.1.3

function refuel()
  while true do
    for i=1, 16 do
      turtle.select(i)
      -- try to refuel whit every item in the turtle if stop when encunters a 
      -- valid one
      if turtle.refuel(1) then return end
    end
    print("... waiting fuel ...")
    print("... press any key ...")
    io.read()
    os.sleep(.1)
  end
end

function forward()
  if turtle.getFuelLevel() < 10 then
    refuel()
  end
  turtle.forward()
end

function place_beind(item)
  while true do
    for i=1, 16 do
      data = turtle.getItemDetail(i)
      if data.name == item then
        select(i)
        turtle.turnRight()
        turtle.turnRight()
        turtle.place()
        turtle.turnRight()
        turtle.turnRight()
        return
      end
    end
    print("... waiting " .. item .. " ...")
    print("... press any key ...")
    io.read()
    os.sleep(.1)
  end
end

function dig_move(replace, item)
  replace = replace or false
  if turtle.detect() then
    turtle.dig()
    if replace then
      place_beind(item)
    end
  end
  forward()
end

-- main loop
-- TODO: give a prompt in case of an error
-- XXX: no error checking 
local lenght = tonumber(arg[1])-1
local width = tonumber(arg[2])
local depth = tonumber(arg[3])
local item = arg[4] or nil

local side = true
local replace = false
if item ~= nil then depth += 1 end

for level=1, depth do
  if item ~= nil and level == depth then replace = true end
  for row=1, width do
    for line=1, lenght do
      dig_move()
    end
    if row ~= width then
      if side then
        turtle.turnRight()
        dig_move()
        turtle.turnRight()
      else
        turtle.turnLeft()
        dig_move(replace, item)
        turtle.turnLeft()
      end
      side = not side
    end
  end
  if level ~= depth then
    turtle.digDown()
    turtle.down()
    turtle.turnRight()
    turtle.turnRight()
  end
end

