local Grid = require("components.grid")
local Welcome = require("components.welcome")

-- states
local GAME_STATE = {
    WELCOME = 1,
    GRID_VIEW = 2
}

local gameState = GAME_STATE.WELCOME
local grid
local cellSize = 10
local colors = {
    background = {0.9, 0.9, 0.9},
    grid = {0.8, 0.8, 0.8},
    cell = {0.2, 0.2, 0.2}
}

function love.load()
    love.window.setTitle("Grid Demo")
    
    -- init welcome screen
    Welcome.load()
    
    -- calculate grid dimensions based on window size
    local windowWidth = love.graphics.getWidth()
    local windowHeight = love.graphics.getHeight()
    local gridWidth = math.floor(windowWidth / cellSize)
    local gridHeight = math.floor(windowHeight / cellSize)
    
    -- initialize grid
    grid = Grid.new(cellSize, gridWidth, gridHeight)
end

function love.update(dt)
    if gameState == GAME_STATE.WELCOME then
        Welcome.update(dt)
    end
end

function love.draw()
    if gameState == GAME_STATE.WELCOME then
        Welcome.draw()

    elseif gameState == GAME_STATE.GRID_VIEW then
        -- draw the grid
        local gridWidth, gridHeight = grid:getDimensions()
        
        love.graphics.setBackgroundColor(colors.background)
        
        -- grid lines
        love.graphics.setColor(colors.grid)
        for x = 0, gridWidth do
            love.graphics.line(x * cellSize, 0, x * cellSize, gridHeight * cellSize)
        end
        for y = 0, gridHeight do
            love.graphics.line(0, y * cellSize, gridWidth * cellSize, y * cellSize)
        end
    end
end

function love.mousepressed(x, y, button, istouch, presses)
    if gameState == GAME_STATE.WELCOME then
        if Welcome.mousepressed(x, y, button) then
            gameState = GAME_STATE.GRID_VIEW
        end
    end
end