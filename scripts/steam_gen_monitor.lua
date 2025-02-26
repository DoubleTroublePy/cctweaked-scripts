-- settings --
--[[
  XXX: warning this device must have the following methods:
  - getEnergyStored
  - getEnergyCapacity
]]
POWER_DEVICE = "thermalexpansion:power_cell"

-- program start --
require("lib.graphics")
local expect = require("cc.expect")
local expect = expect.expect

-- constans
DELAY = 0.1

local function round(num, dec_places)
	expect(1, num, "number")
	expect(2, dec_places, "number")

	local mult = 10 ^ (dec_places or 0)
	return math.floor(num * mult + 0.5) / mult
end

local function table_contais(table, element)
	expect(1, table, "table")
	expect(1, element, "number", "table")
	for _, value in pairs(table) do
		if value == element then
			return true
		end
	end
	return false
end

local monitor = peripheral.find("monitor") or error("monitor not found")
local gen = peripheral.find(POWER_DEVICE) or error(POWER_DEVICE .. " not found")
local gen_methods = peripheral.getNames(POWER_DEVICE)
if not table_contais(gen_methods, "getEnergyStored") and table_contais(gen_methods, "getEnergyCapacity") then
	error(POWER_DEVICE .. " is not compatible")
end

while True do
	-- get power storage info
	local rf_stored = gen.getEnergyStored()
	local rf_max = gen.getEnergyCapacity()
	local rf_perc = round((rf_stored / rf_max) * 100, 0)

	-- setup monitor
	local w, _ = monitor.getSize()
	monitor.setTextScale(0.5)
	monitor.clear()

	monitor.setCursorPos(2, 2)
	monitor.write("energy: " .. rf_stored .. "/" .. rf_max)
	monitor.setCursorPos(10, 3)
	print_progress_bar(rf_perc, w, monitor)
	monitor.setCursorPos(2, 4)

	sleep(DELAY)
end
