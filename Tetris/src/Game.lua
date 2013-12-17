require("Globals")

cubes = {}

Game = {
   TetrominoType = { 
        --      ....
        --      ####
        --      ....
        --      ....
        I = 1,
        --      ##..
        --      ##..
        --      ....
        --      ....
        O = 2,
        --      .#..
        --      ###.
        --      ....
        --      ....
        T = 3,
        --      .##.
        --      ##..
        --      ....
        --      ....
        S = 4,
        --      ##..
        --      .##.
        --      ....
        --      ....
        Z = 5,
        --      #...
        --      ###.
        --      ....
        --      ....
        J = 6,
        --      ..#.
        --      ###.
        --      ....
        --      ....
        L = 7
    },
--    TetrominoCenter = {
--    	[TetrominoType[I]] = 3,
--    	[TetrominoType[O]] = 4,
--    	[TetrominoType[T]] = 3,
--    	[TetrominoType[S]] = 4,
--    	[TetrominoType[Z]] = 3,
--    	[TetrominoType[J]] = 3,
--    	[TetrominoType[L]] = 4
--    },
	board = {},
	tetrominos = {},
	cubes = {},
	activeTetromino,
	nextTetromino,
}

function Game:init()
	Game:loadImages()
	Game:createBoard()
	Game:createTetrominos()
	self.activeTetromino = Game:newTetromino()
end

function Game:loadImages()
--TODO: Y u no work!!!!!?!?!?!?
--	for k,v in ipairs(Globals.Colors) do
--		print("v: " .. v)
--		self.cubes[v] = love.graphics.newImage("images/" .. v .. ".png")
--	end	
	self.cubes[1] = love.graphics.newImage("images/Gray.png")
	self.cubes[2] = love.graphics.newImage("images/Blue.png")
	self.cubes[3] = love.graphics.newImage("images/Green.png")
	self.cubes[4] = love.graphics.newImage("images/Orange.png")
	self.cubes[5] = love.graphics.newImage("images/Red.png")
	self.cubes[6] = love.graphics.newImage("images/Violet.png")
	self.cubes[7] = love.graphics.newImage("images/Yellow.png")
end

function Game:update(dt)

end

function Game:createBoard()
	for i = 1, Globals.BOARD_WIDTH do
		self.board[i] = {}
		for j = 1, Globals.BOARD_HEIGHT do
			self.board[i][j] = 1
		end
	end
end

function Game:setMatrix(matrix, height, width, value)
	for i = 1, height do
		matrix[i] = {}
		for j = 1, width do
			matrix[i][j] = value
		end
	end
end

function Game:createTetrominos()
	for i = 1, Globals.TOTAL_TETROMINO_TYPES do
		self.tetrominos[i] = {}
		Game:setMatrix(self.tetrominos[i], Globals.TETROMINO_SIZE, Globals.TETROMINO_SIZE, false)
	end
	
	Game:createI(self.tetrominos[self.TetrominoType.I])
	Game:createO(self.tetrominos[self.TetrominoType.O])
	Game:createT(self.tetrominos[self.TetrominoType.T])
	Game:createS(self.tetrominos[self.TetrominoType.S])
	Game:createZ(self.tetrominos[self.TetrominoType.Z])
	Game:createJ(self.tetrominos[self.TetrominoType.J])
	Game:createL(self.tetrominos[self.TetrominoType.L])
end

--[[
	oooo
--]]
function Game:createI(tetromino)
	tetromino[1][1] = true
	tetromino[2][1] = true
	tetromino[3][1] = true
	tetromino[4][1] = true
end

--[[
	oo
	oo
-]]
function Game:createO(tetromino)
	tetromino[1][1] = true
	tetromino[1][2] = true
	tetromino[2][1] = true
	tetromino[2][2] = true
end

--[[
	 o
	ooo
--]]
function Game:createT(tetromino)
	tetromino[2][1] = true
	tetromino[1][2] = true	
	tetromino[2][2] = true
	tetromino[3][2] = true
end

--[[
	 oo
	oo
--]]
function Game:createS(tetromino)
	tetromino[2][1] = true	
	tetromino[3][1] = true	
	tetromino[1][2] = true
	tetromino[2][2] = true
end

--[[
	oo
	 oo
--]]

function Game:createZ(tetromino)
	tetromino[1][1] = true
	tetromino[2][1] = true
	tetromino[2][2] = true
	tetromino[3][2] = true
end

--[[
	o
	ooo
--]]

function Game:createJ(tetromino)
	tetromino[1][1] = true
	tetromino[1][2] = true
	tetromino[2][2] = true
	tetromino[3][2] = true
end

--[[
	  o
	ooo
--]]

function Game:createL(tetromino)
	tetromino[3][1] = true
	tetromino[1][2] = true
	tetromino[2][2] = true	
	tetromino[3][2] = true
end

function Game:_debugPrintTetro(tetro)
	for k = 1, 4 do
		print(tostring(tetro[1][k]) .. "\t" .. tostring(tetro[2][k]) .. "\t"  .. tostring(tetro[3][k]) .. "\t"  .. tostring(tetro[4][k]))
	end 
end

function Game:newTetromino()
	math.random()
	math.random()
	math.random()
	
	local newPiece = math.random(1, Globals.TOTAL_TETROMINO_TYPES)
	local newRow = 1
	local newCol = Globals.BOARD_WIDTH / 2;
	
	local maxWidth = 1
	local maxHeight = 1
	local tetro = self.tetrominos[newPiece];
	
	Game:_debugPrintTetro(tetro)
	
	--TODO: IMPROVE THE FOLLOWING CODE TO GET MAXWIDTH & MAXHEIGHT
	
	for i = 1, 4 do
		for j = 1, 4 do
			if tetro[i][j] == true then
				if j > maxHeight then
					maxHeight = j
				end
			end
		end
	end
	
	for i = 1, 4 do
		for j = 1, 4 do
			if tetro[j][i] == true then
				if j > maxWidth then
					maxWidth = j
				end
			end
		end
	end
	
	local newTetromino = {
		["tetro"] = self.tetrominos[newPiece],
		["row"] = newRow,
		["col"] = newCol,
		["width"] = maxWidth,
		["height"] = maxHeight,
		["color"] = 2,
		["rotation"] = 1
	}
	
	print ("\n", newTetromino.height .. newTetromino.width)
	
	return newTetromino
end

function Game:renderTetromino(tetroToRender) 
	local tetro = tetroToRender["tetro"]
	local x = tetroToRender["col"]
	local y = tetroToRender["row"]
	local color = tetroToRender["color"]
	local width = tetroToRender["width"]
	local height = tetroToRender["height"]
	local tileSize = Globals.TILE_SIZE; 
	
	for i = 1, width do
		for j = 1, height do
			if tetro[i][j] == true then
	 			love.graphics.draw(self.cubes[color], Globals.TILE_SIZE * (x+i-2), Globals.TILE_SIZE * (y+j-2))
	 		end
	 	end
	 end
end

function addTetroToBoard()

end

function Game:render()
	for i = 1, Globals.BOARD_WIDTH do
		for j = 1, Globals.BOARD_HEIGHT do
			love.graphics.draw(self.cubes[self.board[i][j]], Globals.TILE_SIZE * (i - 1), Globals.TILE_SIZE * (j - 1))
		end
	end
	
	Game:renderTetromino(self.activeTetromino)
end