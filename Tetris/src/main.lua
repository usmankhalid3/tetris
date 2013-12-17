require("System")
require("Game")
require("Globals")

function love.load()
	Game:init()
end

function love.update(dt)
    Game:update()
end

function love.draw()
	Game:render()
end

function love.keypressed(key, unicode)
    System:onKeyDown(key)
end

function love.keyreleased(key)
    System:onKeyUp(key)
end