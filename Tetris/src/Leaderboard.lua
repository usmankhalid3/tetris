Leaderboard = {
	scores = {},
}

function Leaderboard:init(scoreData)
	if scoreData == nil then
		for i = 1, Globals.LEADERBOARD_SIZE do
			self.scores[i] = "0"
		end
	else
		self.scores = Utils:split(scoreData, ",")
	end
end

function Leaderboard:addScore(score)
	self.scores[Globals.LEADERBOARD_SIZE] = score
	Leaderboard:sortScores()
end

function Leaderboard:getTopScores()
	return self.scores
end

function Leaderboard:sortScores()
	table.sort(self.scores,
		function(n1, n2)
			return tonumber(n1) > tonumber(n2) 
		end
	)
end

function Leaderboard:scoreData()
	return table.concat(self.scores, ",")
end