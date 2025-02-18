-- constans
DELAY = 0.1

-- globals
Timer = 0

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

local function print_progress_bar(perc, w, monitor)
	local x, y = monitor.callRemote("monitor_0", "getCursorPos")
	local scale_factor = (w - x - 2) / 100
	monitor.write("[")
	monitor.setCursorPos(x + (100 * scale_factor), y)
	monitor.write("]%")
	monitor.setBackgroundColor(colors.white)
	print_line_o(y, x + 1, (x + 1) + (perc * scale_factor), monitor)
	monitor.setBackgroundColor(colors.black)
end

local monitor = peripheral.find("monitor") or error("monitor not found")
local gen = peripheral.wrap("right")
local color = colors.gray

local old_rf_stored = 0

while true do
	-- get water tank info
	local tank_stored = gen.getTanks()[1].amount
	local tank_max = gen.getTanks()[1].capacity
	local tank_perc = round((tank_stored / tank_max) * 100, 0)

	-- setup monitor
	local w, h = monitor.getSize()
	monitor.setTextScale(0.5)
	monitor.clear()

	monitor.setCursorPos(2, 2)
	monitor.write("energy: " .. rf_stored .. "/" .. rf_max)
	monitor.setCursorPos(10, 3)
	print_progress_bar(rf_perc, w, monitor)
	monitor.setCursorPos(2, 4)
	monitor.write("water: ")
	monitor.setCursorPos(10, 4)
	monitor.write(tank_stored .. "/" .. tank_max)
	monitor.setCursorPos(10, 5)
	print_progress_bar(tank_perc, w, monitor)

	old_rf_stored = rf_stored
	if Timer < 0.00001 then
		Timer = 0
	else
		Timer = Timer - 0.1
	end
	sleep(1)
end
