--[[
	This class acts as the screen on which the game name, tetris board & high scores scores are shown
--]]
require("Globals")

System = {
	font = love.graphics.newFont(Globals.Path.FONT, 36) -- font used for rendering text
}

-- Heading of the game
function System:setHeading()
	local heading = Globals.GAME_NAME
	love.graphics.print(heading, 250, 25)
end

-- Initializes the system by setting the font and window title
function System:init()
	love.window.setTitle(Globals.GAME_NAME)
	love.graphics.setFont(self.font)
end

-- Updates the user's score on the screen
function System:updateScore()
	local scoreLabel = Globals.SCORE_LABEL .. Game:getScore()
	love.graphics.print(scoreLabel, 550, 150)
end

-- Shows the top X highest scores on the screen
function System:showHighScores()
	local y = 130
	local scores = Leaderboard:getTopScores()
	love.graphics.print("GAME OVER!", 300, 20)
	love.graphics.print("Top 5 Highest Scores", 250, 80)
	love.graphics.print("Press spacebar to play again", 250, 350)
	for rank, score in ipairs(scores) do
		local scoreLabel = rank .. "           " .. score
		love.graphics.print(scoreLabel, 330, y)
		y = y + 40	
	end
end