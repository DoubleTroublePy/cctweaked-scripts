local dr = peripheral.wrap("top")

local function main()
	local draw = dr.getDrawer(1)
	if draw.getCount() == draw.getCapacity() then
		return
	end

	turtle.select(1)
	for _ = 1, 1023 do
		if turtle.detect() then
			turtle.dig()
		end
	end

	for i = 1, 16 do
		turtle.select(i)
		turtle.dropUp()
	end
end
while true do
	main()
end
