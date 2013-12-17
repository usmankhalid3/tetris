require("System")
require("Game")
require("Globals")

function love.load()
	Game:init()
end

function love.update(dt)
    Game:update(dt)
end

function love.draw()
	Game:render()
end

function love.keypressed(key, unicode)
    Game:onKeyDown(key)
end

function love.keyreleased(key)
    Game:onKeyUp(key)
end