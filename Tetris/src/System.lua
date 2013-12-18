require("Globals")

System = {
	font = love.graphics.newFont(Globals.Path.FONT, 36)
}

function System:setHeading()
	local heading = Globals.GAME_NAME
	love.graphics.print(heading, 250, 25)
end

function System:init()
	love.window.setTitle(Globals.GAME_NAME)
	love.graphics.setFont(self.font)
end

function System:updateScore()
	local scoreLabel = Globals.SCORE_LABEL .. Game:getScore()
	love.graphics.print(scoreLabel, 550, 150)
end

function System:showHighScores()
	local y = 100
	local scores = Leaderboard:getTopScores()
	love.graphics.print("Top 5 Highest Scores", 250, 25)
	love.graphics.print("Press spacebar to play again", 250, 350)
	for rank, score in ipairs(scores) do
		local scoreLabel = rank .. "           " .. score
		love.graphics.print(scoreLabel, 300, y)
		y = y + 40	
	end
end