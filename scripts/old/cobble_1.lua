while true do
    for i=1, 1023 do
        if turtle.detect() then 
            turtle.dig()
        end
    end 
    turtle.turnLeft()
    turtle.turnLeft()
    for i=1, 16 do 
        turtle.select(i)
        turtle.drop()
    end 
end
