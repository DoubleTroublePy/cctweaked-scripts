repeat 
    turtle.suck()
    i = turtle.getItemDetail()
    for p=1, 16 do
        turtle.select(p)
        if not(i.name == "exnihilosequentia:piece_iron") then
            turtle.dropUp()
        else
            if turtle.getItemCount() >= 4 then
                turtle.transferTo(1)
                turtle.transferTo(2, 1)
                turtle.transferTo(3, 1)
                turtle.transferTo(3, 1)
                turtle.craft()
            end
        end
    end

until false