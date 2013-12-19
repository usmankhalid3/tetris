--[[
	This class handles the highest scores in the game
--]]

Leaderboard = {
	scores = {},
}

-- Initializes the leaderboard by reading persisted top scores (if present)
function Leaderboard:init(scoreData)
	if scoreData == nil then
		for i = 1, Globals.LEADERBOARD_SIZE do
			self.scores[i] = "0"
		end
	else
		self.scores = Utils:split(scoreData, ",")
	end
end

-- Adds score to the leaderboard and sort
function Leaderboard:addScore(score)
	self.scores[Globals.LEADERBOARD_SIZE] = score
	Leaderboard:sortScores()
end

-- Returns the top scores on the leaderboard
function Leaderboard:getTopScores()
	return self.scores
end

-- Sorts all scores on the leaderboard
function Leaderboard:sortScores()
	table.sort(self.scores,
		function(n1, n2)
			return tonumber(n1) > tonumber(n2) 
		end
	)
end

-- Returns a csv string of leaderboard scores
function Leaderboard:scoreData()
	return table.concat(self.scores, ",")
end