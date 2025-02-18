while true do
    craft = {
        1, 2, 3,
        5, 6, 7, 
        9, 10, 11
    }
    num = 0
    
    for i=1, 9 do
        turtle.select(craft[i])
        if turtle.getItemCount() >= 1 then 
            num = num + 1
        else 
            turtle.suckUp(1)
        end
    end
    print(num)
    if num == 9 then
        turtle.craft()
    end
    for i=1, 16 do
        turtle.select(i)
        item = turtle.getItemDetail()
        if item and item.name == "extrautils2:compressedcobblestone" then   
            turtle.drop()
        end         
    end
end
