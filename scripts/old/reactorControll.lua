monitor = "monitor_1"
generator = "BigReactors-Reactor_0"

modem = peripheral.wrap("left")

function clear()
	modem.callRemote(monitor, "clear")
end

function monitorPrint(x, y, text)
	modem.callRemote(monitor, "setCursorPos", x, y)
	modem.callRemote(monitor, "write", text)
end

function bar(x, y, min, max)
	lenght = #tostring(min) + #tostring(max) + 8

	lenght_bar_t = w - lenght
	lenght_bar = (min * lenght_bar_t) / max

	monitorPrint(
		x,
		y,
		min
			.. "/"
			.. max
			.. " "
			.. "["
			.. string.rep("|", lenght_bar)
			.. string.rep(" ", lenght_bar_t - lenght_bar)
			.. "]"
	)
end

local power = false

local power_max = 0
local temp_max = 0

while true do
	if redstone.getInput("top") then
		if power then
			modem.callRemote(generator, "setActive", 0)
			power = false
		else
			modem.callRemote(generator, "setActive", 1)
			power = true
		end
	end

	w, h = modem.callRemote(monitor, "getSize")
	local fuel_max = modem.callRemote(generator, "getFuelAmountMax")
	local fuel = modem.callRemote(generator, "getFuelAmount")

	bar(2, 2, fuel, fuel_max)

	local power = modem.callRemote(generator, "getEnergyProducedLastTick")
	if power_max < power then
		power_max = power
	end

	bar(2, 4, power, power_max)

	local temp = modem.callRemote(generator, "getFuelTemperature")
	if temp_max < temp then
		temp_max = temp
	end

	bar(2, 6, temp, temp_max)

	os.sleep(0.1)
	clear()
end
