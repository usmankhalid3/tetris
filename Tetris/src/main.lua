require("System")
require("Game")
require("Globals")
require("Leaderboard")
require("Utils")

function startGame()
	System:init()
	Game:init()
end

function love.load()
	love.filesystem.setIdentity("crazytetris")
	local scoreData = nil
	if love.filesystem.exists(Globals.GAMEDATA_PATH) then
		scoreData = love.filesystem.read(Globals.GAMEDATA_PATH)
	end
	Leaderboard:init(scoreData)
	startGame()
end

function love.update(dt)
	if Game:isOver() == false and Game:isPaused() == false then
    	Game:update(dt)
    end
end

function love.draw()
	if Game:isOver() == true then
		System.showHighScores()
	else
		System:setHeading()
		Game:render()
		System:updateScore()
	end
end

function love.keypressed(key, unicode)
	if Game:isOver() == true and key == " " then
		startGame()
	end
    Game:onKeyDown(key)
end

function love.keyreleased(key)
    Game:onKeyUp(key)
end

function love.quit()
	love.filesystem.write(Globals.GAMEDATA_PATH,Leaderboard:scoreData());
end