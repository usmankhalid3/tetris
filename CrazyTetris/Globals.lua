--[[
	This class contains the constant values in the game
--]]

Globals = {
	GAME_NAME = "Crazy Tetris v0.1",
	SCORE_LABEL = "Score: ",
	BOARD_WIDTH = 10, -- width of the tetris board (in number of tiles)
	BOARD_HEIGHT = 15,-- height of the tetris board (in number of tiles)
	TILE_SIZE = 32, -- size of a single tetromino tile
	TETROMINO_SIZE = 4, -- number of tiles in each tetromino
	TOTAL_TETROMINO_TYPES = 7, -- total number of tetrominos
	DESCENT_DELAY = 1, -- delay in seconds for a tetromino descend
	KEYPRESS_DELAY = 0.1, -- delay in seconds before a key is responded to
	BOARD_OFFSET_X = 200, -- offset of the tetris board from the left of the screen
	BOARD_OFFSET_Y = 100, -- offset of the tetris board from the top of the screen
	LEADERBOARD_SIZE = 5, -- total number of entries on the leaderboard 
	
	Colors = { -- colors of the tetrominos
		"Grey",
		"Red", 
		"Orange", 
		"Yellow", 
		"Green", 
		"Cyan", 
		"Blue",
		"Violet"
	},
	
	Path = {	-- various paths
		IMAGES = "images/",
		FONT = "fonts/DimboRegular.ttf",
		GAME_DATA = "scores",
	}
}