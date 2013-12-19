--[[
	This is the entry point for the game. It handles the LOVE2D events and passes
	the controls to the appropriate sections of the game
--]]

require("System")
require("Game")
require("Globals")
require("Leaderboard")
require("Utils")
--require("Tests")

-- Initializes the system & game
function startGame()
	System:init()
	Game:init()
end

-- Initializes the leaderboard and game data 
function love.load()
	love.filesystem.setIdentity("crazytetris")
	local scoreData = nil
	if love.filesystem.exists(Globals.Path.GAME_DATA) then
		scoreData = love.filesystem.read(Globals.Path.GAME_DATA)
	end
	Leaderboard:init(scoreData)
	startGame()
end

-- Updates the game every tick (if game isn't over or paused)
function love.update(dt)
	if Game:isOver() == false and Game:isPaused() == false then
    	Game:update(dt)
    end
end

-- Draws game content on the screen
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

-- Persists the leaderboard scores
function love.quit()
	love.filesystem.write(Globals.Path.GAME_DATA,Leaderboard:scoreData());
end