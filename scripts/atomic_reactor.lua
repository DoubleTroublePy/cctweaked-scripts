require("graphics")
local expect = require("cc.expect")
local expect = expect.expect

local function round(num, dec_places)
	expect(1, num, "number")
	expect(2, dec_places, "number")

	local mult = 10 ^ (dec_places or 0)
	return math.floor(num * mult + 0.5) / mult
end

local function temp_color(temp)
	expect(1, temp, "number")

	if temp < 200 then
		return colors.green
	end

	if temp >= 200 and temp < 1000 then
		return colors.orange
	end

	return colors.red
end

local monitor = peripheral.find("monitor")
local generator = peripheral.find("BigReactors-Reactor")

-- local constants
local ENERGY_MAX = generator.getEnergyCapacity()
local FUEL_MAX = generator.getFuelAmountMax()
local TEMP_MAX = 2000

-- outloop vars
local rod_timer = os.clock()

-- reset
monitor.clear()
generator.setActive(false)
generator.setAllControlRodLevels(100)

while true do
	-- get var --
	-- fuel
	local fuel = generator.getFuelAmount()
	local fuel_perc = (fuel / FUEL_MAX) * 100

	-- energy
	local energy = generator.getEnergyStored()
	local energy_perc = (energy / ENERGY_MAX) * 100
	local energy_produced_lt = generator.getEnergyProducedLastTick()

	-- fuel temp
	local fuel_temp = generator.getFuelTemperature()
	local fuel_temp_perc = math.log(fuel_temp) * (100 / math.log(TEMP_MAX))

	-- casing temp
	local casing_temp = generator.getCasingTemperature()
	local casing_temp_perc = math.log(casing_temp) * (100 / math.log(TEMP_MAX))

	-- road leves
	local road_levels = generator.getControlRodLevel(1)

	-- medium temp
	local temp = (casing_temp + fuel_temp) / 2

	-- gen set --
	if os.clock() - rod_timer > 0.1 then
		if temp < 23 and not generator.getActive() then
			generator.setActive(true)
		end
		if generator.getActive() then
			if temp > 200 then
				generator.setAllControlRodLevels(road_levels + 1)
			elseif temp < 190 then
				generator.setAllControlRodLevels(road_levels - 1)
			end
		end
		rod_timer = 0
	end

	generator.doEjectWaste()

	-- monitor set --
	-- energy
	monitor.setCursorPos(1, 1)
	monitor.write("energy: " .. string.format("%e", tonumber(energy_produced_lt)))

	-- fuel
	monitor.setCursorPos(1, 2)
	monitor.write("fuel: " .. round(fuel, 0) .. "/" .. round(FUEL_MAX, 0))
	monitor.setCursorPos(4, 3)
	print_progress_bar(fuel_perc, monitor)

	-- energy capacity
	monitor.setCursorPos(1, 4)
	monitor.write("energy storage: " .. round(energy, 0) .. "/" .. round(ENERGY_MAX, 0))
	monitor.setCursorPos(4, 5)
	print_progress_bar(energy_perc, monitor)

	-- fuel temp
	monitor.setCursorPos(1, 6)
	monitor.write("fuel temp: " .. round(fuel_temp, 0) .. "/" .. round(TEMP_MAX, 0))
	monitor.setCursorPos(4, 7)
	print_progress_bar(fuel_temp_perc, monitor, temp_color(fuel_temp))

	-- carsing temp
	monitor.setCursorPos(1, 8)
	monitor.write("casing temp: " .. round(casing_temp, 0) .. "/" .. round(TEMP_MAX, 0))
	monitor.setCursorPos(4, 9)
	print_progress_bar(casing_temp_perc, monitor, temp_color(casing_temp))

	sleep(0.1)
	monitor.clear()
end
