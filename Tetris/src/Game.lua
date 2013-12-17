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
	gameOver = false,
	gamePaused = false,
	descentTimer = 0,
	keyTimerLeft = 0,
	keyTimerRight = 0,
	keyTimerUp = 0,
	keyTimerDown = 0,
	score = 0,
	cubes = {}
}

function Game:init()
	math.randomseed(os.time())
	Game:loadImages()
	self.board = Game:createBoard()
	Game:createTetrominos()
	self.activeTetromino = Game:newTetromino()
	self.nextTetromino = Game:newTetromino()
end

function Game:loadImages()
	for k,v in ipairs(Globals.Colors) do
		print(k, v)
		local path = "images/" .. v .. ".png"
		self.cubes[k] = love.graphics.newImage(path)
	end	
end

function Game:hasReachedDown()
	local tetro = self.activeTetromino
	if tetro["row"] + tetro["height"] > Globals.BOARD_HEIGHT then
		return true
	end
	
	for i = 1, tetro["width"] do
		for j = 1, tetro["height"] do
			if tetro["tetro"][i][j] then
				if self.board[tetro["col"]+i-1] ~= nil then
					if self.board[tetro["col"]+i-1][tetro["row"]+j] ~= nil then
						if self.board[tetro["col"]+i-1][tetro["row"]+j] ~= 1 then
							return true
						end
					end
				end
			end
		end
	end
	return false
end

function Game:hasReachedLeft()
	local tetro = self.activeTetromino
	if tetro["col"] < 2 then
		return true
	end
	for i = 1, tetro["width"] do
		for j = 1, tetro["height"] do
			if tetro["tetro"][i][j] then
				if self.board[tetro["col"]+i-2][tetro["row"]+j-1] ~= nil then
					if self.board[tetro["col"]+i-2][tetro["row"]+j-1] ~= nil then
						if self.board[tetro["col"]+i-2][tetro["row"]+j-i] ~= 1 then
							return true
						end
					end
				end
			end
		end
	end
	return false
end

function Game:hasReachedRight()
	local tetro = self.activeTetromino
	if tetro["col"] + tetro["width"] > Globals.BOARD_WIDTH then
		return true
	end
	for i = 1, tetro["width"] do
		for j = 1, tetro["height"] do
			if tetro["tetro"][i][j] then
				if self.board[tetro["col"]+i] ~= nil then
					if self.board[tetro["col"]+i][tetro["row"]+j-1] ~= nil then
						if self.board[tetro["col"]+i][tetro["row"]+j-1] ~= 1 then
							return true
						end
					end
				end
			end
		end
	end
	return false
end

function Game:checkLegal(tetro)
	for i = 1, tetro["width"] do
		for j = 1, tetro["height"] do
			if tetro["tetro"][i][j] then
				if self.board[tetro["col"]+i-1] == nil then
					return false
				elseif self.board[tetro["col"]+i-1][tetro["row"]+j-1] == nil then
					return false
				elseif self.board[tetro["col"]+i-1][tetro["row"]+j-1] ~= 1 then
					return false
				end
			end
		end
	end
	return true
end

function Game:addTetroToBoard()
	local tetro = self.activeTetromino
	
	for i = 1, tetro["width"] do
		for j = 1, tetro["height"] do
			if tetro["tetro"][i][j] then
				self.board[tetro["col"]+i-1][tetro["row"]+j-1] = tetro["color"]
			end
		end
	end
	
	self.activeTetromino = self.nextTetromino
	
	if Game:checkLegal(self.activeTetromino) == false then
		self.gameOver = true
	end
	
	self.nextTetromino = Game:newTetromino()
end

function Game:descendTetromino()
	self.activeTetromino["row"] = self.activeTetromino["row"] + 1
end

function Game:rotateTetromino()
	local tetro = self.activeTetromino
	-- No need to rotate the O-shape
	if tetro["type"] == self.TetrominoType.O then
		return
	end
	
	local newTetro = {}
	newTetro["tetro"] = {}
	newTetro["color"] = tetro["color"]
	newTetro["rotation"] = tetro["rotation"] % 4 + 1
	
	if Game:isOfTypeI(tetro) or Game:isOfTypeS(tetro) or Game:isOfTypeZ(tetro) then
		if tetro["rotation"] == 1 or tetro["rotation"] == 3 then
			newTetro["col"] = tetro["col"] - math.floor((tetro["height"] - tetro["width"]) / 2)
			newTetro["row"] = tetro["row"] - math.ceil((tetro["width"] - tetro["height"]) / 2)
		elseif tetro["rotation"] == 2 or tetro["rotation"] == 4 then
			newTetro["col"] = tetro["col"] - math.ceil((tetro["height"] - tetro["width"]) / 2)
			newTetro["row"] = tetro["row"] - math.floor((tetro["width"] - tetro["height"]) / 2)
		end
	else
		if tetro["rotation"] == 1 then
			newTetro["col"] = tetro["col"] - math.floor((tetro["height"] - tetro["width"]) / 2)
			newTetro["row"] = tetro["row"] - math.floor((tetro["width"] - tetro["height"]) / 2)
		elseif tetro["rotation"] == 2 then
			newTetro["col"] = tetro["col"] - math.ceil((tetro["height"] - tetro["width"]) / 2)
			newTetro["row"] = tetro["row"] - math.floor((tetro["width"] - tetro["height"]) / 2)
		elseif tetro["rotation"] == 3 then
			newTetro["col"] = tetro["col"] - math.ceil((tetro["height"] - tetro["width"]) / 2)
			newTetro["row"] = tetro["row"] - math.ceil((tetro["width"] - tetro["height"]) / 2)
		elseif tetro["rotation"] == 4 then
			newTetro["col"] = tetro["col"] - math.floor((tetro["height"] - tetro["width"]) / 2)
			newTetro["row"] = tetro["row"] - math.ceil((tetro["width"] - tetro["height"]) / 2)
		end			
	end
	
	newTetro["height"] = tetro["width"]
	newTetro["width"] = tetro["height"]
	
	for i = 1, newTetro["width"] do
		newTetro["tetro"][i] = {}
	end
	
	for i = 1, tetro["width"] do
		for j = 1, tetro["height"] do
			newTetro["tetro"][tetro["height"]-j+1][i] = tetro["tetro"][i][j]
		end
	end
	
	if Game:checkLegal(newTetro) == true then
		self.activeTetromino = newTetro
	end
	 
end

function Game:removeCompletedRows()
	local completedRows = {}
	local linesCompleted = 0
	local newBoard = Game:createBoard()
	
	for j = Globals.BOARD_HEIGHT, 1, -1 do
		completedRows[j] = true
		for i = 1, Globals.BOARD_WIDTH do
			if self.board[i][j] == 1 then
				completedRows[j] = false
				break
			end
		end
	end
	
	for j = Globals.BOARD_HEIGHT, 1, -1 do
		if completedRows[j] then
			linesCompleted = linesCompleted + 1
		end
		for i = 1, Globals.BOARD_WIDTH do
			if j - linesCompleted > 0 then
				newBoard[i][j] = self.board[i][j - linesCompleted]
			end
		end
	end
	
	if linesCompleted > 0 then
		self.score = self.score + linesCompleted
	end
	self.board = newBoard
end

function Game:update(dt)
	if self.gamePaused == true or self.gameOver == true then
		return
	end
	
	Game:removeCompletedRows()
	
	local tetro = self.activeTetromino
	
	if tetro == nil then
		return
	end
	
	self.keyTimerUp = self.keyTimerUp - dt
	self.keyTimerDown = self.keyTimerDown - dt
	self.keyTimerLeft = self.keyTimerLeft - dt
	self.keyTimerRight = self.keyTimerRight - dt
	
	if self.keyTimerUp <= 0 then
		if love.keyboard.isDown("up", " ") then
			Game:rotateTetromino()
			self.keyTimerUp = Globals.KEYPRESS_DELAY
		end
	end
	
		if self.keyTimerDown <= 0 then
		if love.keyboard.isDown("down", "s") then
			self.keyTimerDown = Globals.KEYPRESS_DELAY
			if Game:hasReachedDown() then
				Game:addTetroToBoard()
			else
				tetro["row"] = tetro["row"] + 1
			end
		end
	end	
	
	if self.keyTimerLeft <= 0 then
		if love.keyboard.isDown("left", "a") then
			self.keyTimerLeft = Globals.KEYPRESS_DELAY
			if Game:hasReachedLeft() == false then
				tetro["col"] = tetro["col"] - 1
			end
		end
	end
	
	if self.keyTimerRight <= 0 then
		if love.keyboard.isDown("right", "d") then
			self.keyTimerRight = Globals.KEYPRESS_DELAY
			if Game:hasReachedRight() == false then
				tetro["col"] = tetro["col"] + 1
			end
		end
	end
		
	self.descentTimer = self.descentTimer - dt
	if self.descentTimer <= 0 then
		self.descentTimer = Globals.DESCENT_DELAY
		if Game:hasReachedDown() then
			Game:addTetroToBoard()
		else
			Game:descendTetromino()
		end
	end
end

function Game:createBoard()
	local board = {}
	for i = 1, Globals.BOARD_WIDTH do
		board[i] = {}
		for j = 1, Globals.BOARD_HEIGHT do
			board[i][j] = 1
		end
	end
	return board
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

function Game:isOfTypeI(tetro)
	return tetro["type"] == self.TetrominoType.I
end

function Game:isOfTypeO(tetro)
	return tetro["type"] == self.TetrominoType.O
end

function Game:isOfTypeT(tetro)
	return tetro["type"] == self.TetrominoType.T
end

function Game:isOfTypeS(tetro)
	return tetro["type"] == self.TetrominoType.S
end

function Game:isOfTypeZ(tetro)
	return tetro["type"] == self.TetrominoType.Z
end

function Game:isOfTypeJ(tetro)
	return tetro["type"] == self.TetrominoType.J
end

function Game:isOfTypeL(tetro)
	return tetro["type"] == self.TetrominoType.L
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
	
	local type = math.random(1, Globals.TOTAL_TETROMINO_TYPES)
	local row = 1
	local col = Globals.BOARD_WIDTH / 2;
	
	local maxWidth = 1
	local maxHeight = 1
	local tetro = self.tetrominos[type];
	
	--Game:_debugPrintTetro(tetro)
	
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
		["tetro"] = self.tetrominos[type],
		["row"] = row,
		["col"] = col,
		["width"] = maxWidth,
		["height"] = maxHeight,
		["color"] = type + 1,
		["rotation"] = 1,
		["type"] = type
	}
	
	--print ("\n", newTetromino.height .. newTetromino.width)
	
	return newTetromino
end

function Game:renderTetromino(tetroToRender)
	if tetroToRender == nil then
		return
	end
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
	 			love.graphics.draw(self.cubes[color], Globals.TILE_SIZE * (x+i-2) + Globals.BOARD_OFFSET_X, Globals.TILE_SIZE * (y+j-2) + Globals.BOARD_OFFSET_Y)
	 		end
	 	end
	 end
end

function Game:render()
	for i = 1, Globals.BOARD_WIDTH do
		for j = 1, Globals.BOARD_HEIGHT do
			love.graphics.draw(self.cubes[self.board[i][j]], Globals.TILE_SIZE * (i - 1) + Globals.BOARD_OFFSET_X, Globals.TILE_SIZE * (j - 1) + Globals.BOARD_OFFSET_Y)
		end
	end
	
	Game:renderTetromino(self.activeTetromino)
end

function Game:onKeyDown(key)

end

function Game:pauseGame()
	if self.gamePaused == true then
		self.gamePaused = false
	else
		self.gamePaused = true
	end
end

function Game:onKeyUp(key)
	if key == "p" then
		Game:pauseGame()
	end
end