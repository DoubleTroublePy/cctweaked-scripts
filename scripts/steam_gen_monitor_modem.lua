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

local function print_line_o(line, l_start, l_end, modem)
	for i = l_start, l_end do
		modem.callRemote("monitor_0", "setCursorPos", i, line)
		modem.callRemote("monitor_0", "write", " ")
	end
end

local function print_line_v(col, c_start, c_end, modem)
	for i = c_start, c_end do
		modem.callRemote("monitor_0", "setCursorPos", col, i)
		modem.callRemote("monitor_0", "write", " ")
	end
end

local function color_border(color, w, h, modem, problem)
	problem = problem or ""
	modem.callRemote("monitor_0", "setBackgroundColor", color)

	print_line_v(1, 1, w, modem)
	print_line_v(h, 1, w, modem)

	print_line_o(1, 1, h, modem)
	print_line_o(w, 1, h, modem)

	modem.callRemote("monitor_0", "setCursorPos", 2, h)
	modem.callRemote("monitor_0", "write", problem)

	modem.callRemote("monitor_0", "setBackgroundColor", colors.black)
end

local function print_progress_bar(perc, w, modem)
	local x, y = modem.callRemote("monitor_0", "getCursorPos")
	local scale_factor = (w - x - 2) / 100
	modem.callRemote("monitor_0", "write", "[")
	modem.callRemote("monitor_0", "setCursorPos", x + (100 * scale_factor), y)
	modem.callRemote("monitor_0", "write", "]%")
	modem.callRemote("monitor_0", "setBackgroundColor", colors.white)

	print_line_o(y, x + 1, (x + 1) + (perc * scale_factor), modem)

	local x, y = modem.callRemote("monitor_0", "getCursorPos")

	modem.callRemote("monitor_0", "setBackgroundColor", colors.black)
end

local modem = peripheral.find("modem") or error("modem no found")
local gen = peripheral.wrap("right")
local color = colors.gray

local old_rf_stored = 0

while true do
	-- get power storage info
	local rf_stored = gen.getEnergyStored()
	local rf_max = gen.getEnergyCapacity()
	local rf_perc = round((rf_stored / rf_max) * 100, 0)

	-- get water tank info
	local tank_stored = gen.getTanks()[1].amount
	local tank_max = gen.getTanks()[1].capacity
	local tank_perc = round((tank_stored / tank_max) * 100, 0)

	-- setup monitor
	local w, h = modem.callRemote("monitor_0", "getSize")
	modem.callRemote("monitor_0", "setTextScale", 0.5)
	modem.callRemote("monitor_0", "clear")

	local item = gen.list()
	if (old_rf_stored < rf_stored and rf_stored < 100) or old_rf_stored == rf_stored and item == nil then
		color = color_switch(color)
		color_border(color, w, h, modem, "stopped")
	end

	modem.callRemote("monitor_0", "setCursorPos", 2, 2)
	modem.callRemote("monitor_0", "write", "energy: " .. rf_stored .. "/" .. rf_max)
	modem.callRemote("monitor_0", "setCursorPos", 10, 3)
	print_progress_bar(rf_perc, w, modem)
	modem.callRemote("monitor_0", "setCursorPos", 2, 4)
	modem.callRemote("monitor_0", "write", "water: ")
	modem.callRemote("monitor_0", "setCursorPos", 10, 4)
	modem.callRemote("monitor_0", "write", tank_stored .. "/" .. tank_max)
	modem.callRemote("monitor_0", "setCursorPos", 10, 5)
	print_progress_bar(tank_perc, w, modem)

	old_rf_stored = rf_stored
	if Timer < 0.00001 then
		Timer = 0
	else
		Timer = Timer - 0.1
	end
	sleep(0.5)
end
--[[
mon.clear()
mon.setCursorPos(1, 1)
mon.write(en_stored)
mon.setCursorPos(1, 2)
mon.write(en_max)
mon.setCursorPos(1, 3)
mon.write(round((en_stored / en_max) * 100, 2) .. "%")
]]
--
