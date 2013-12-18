Utils = {

}

function Utils:split(s, delimiter)
    result = {};
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match);
    end
    return result;
end

function Utils:pickOne(probabilities)
	local sum = 0
	for k,v in ipairs(probabilities) do
		sum = sum + v
	end
	return Utils:getByProbability(probabilities, sum)
end

function Utils:getByProbability(probabilities, totalProbability)
	if totalProbability < 1 then
		return nil
	else
		math.random()
		math.random()
		math.random()
		
		local number = math.random(1, totalProbability)
		for k, v in ipairs(probabilities) do
			number = number - v
			if number < 0 then
				return k
			end
		end
	end
	return nil
end