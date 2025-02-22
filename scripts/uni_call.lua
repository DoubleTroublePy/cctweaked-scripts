local expect = require("cc.expect")
local expect, field = expect.expect, expect.field

-- peripherals
-- call(name, method, ...)
-- callRemote(remoteName, method, ...)
function uni_call(name, method, ...)
	expect(1, name, "string")
	expect(2, method, "string")

	local per = peripheral.find(name)
	if per ~= nil then
		peripheral.call(name, method, ...)
		print("local call")
	end
	local names = peripheral.getNames()
	local side = nil
	for _, l_name in pairs(names) do
		if l_name == "callRemote" then
			side = l_name
		end
	end
	if side == nil then
		return
	end
	peripheral.call(side, "callRemote", name, method, ...)
	print("remide call")
end

uni_call("monitor", "write", "k")
