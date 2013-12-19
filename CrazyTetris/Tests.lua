--[[
	Contains unit tests for some functions
--]]

function testProbability()
	local prob = {
		[1] = 50,
		[2] = 80,
		[3] = 120,
		[4] = 300,
		[5] = 300,
		[6] = 250,
		[7] = 250,
	}
	
	for run = 1, 1000 do
		local selected = Utils:pickOne(prob) or 1
		print(run .. ": " .. selected)
	end
end