local expect = require("cc.expect")
local expect = expect.expect

local function round(num, dec_places)
	local mult = 10 ^ (dec_places or 0)
	return math.floor(num * mult + 0.5) / mult
end

local function color_switch(color)
	if Timer ~= 0 then
		return color
	end
	Timer = DELAY
	if color == colors.black then
		return colors.red
	else
		return colors.black
	end
end

local function print_line_o(line, l_start, l_end, monitor)
	for i = l_start, l_end do
		monitor.setCursorPos(i, line)
		monitor.write(" ")
	end
end

local function print_line_v(col, c_start, c_end, monitor)
	for i = c_start, c_end do
		monitor.setCursorPos(col, i)
		monitor.write(" ")
	end
end

local function color_border(color, w, h, monitor, problem)
	problem = problem or ""
	monitor.setBackgroundColor(color)

	print_line_v(1, 1, w, monitor)
	print_line_v(h, 1, w, monitor)

	print_line_o(1, 1, h, monitor)
	print_line_o(w, 1, h, monitor)

	monitor.setCursorPos(2, h)
	monitor.write(problem)

	monitor.setBackgroundColor(colors.black)
end

function print_progress_bar(perc, monitor, color)
	expect(1, perc, "number")
	expect(2, monitor, "table")
	expect(3, color, "number", "nil")
	assert(perc >= 0 and perc <= 100, "out of bouds percentage")
	color = color or colors.white

	local x, y = monitor.getCursorPos()
	local w, _ = monitor.getSize()
	local scale_factor = (w - x - 2) / 100

	monitor.write("[")
	monitor.setCursorPos(x + (100 * scale_factor), y)
	monitor.write("]%")
	monitor.setBackgroundColor(color)
	print_line_o(y, x + 1, (x - 1) + (perc * scale_factor), monitor)
	monitor.setBackgroundColor(colors.black)
end
