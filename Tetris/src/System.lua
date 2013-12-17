System = {
	font = love.graphics.newFont("fonts/DimboRegular.ttf", 36)
}

function System:setHeading()
	local heading = Globals.GAME_NAME
	local textWidth = self.font:getWidth(heading)
	love.graphics.print(heading, 250, 25)
end

function System:init()
	love.window.setTitle(Globals.GAME_NAME)
	love.graphics.setFont(self.font)
	System:setHeading()
end