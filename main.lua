local Grid = require("grid")


local grid
local cellSize = 20
local colors = {
    background = {0.9, 0.9, 0.9},
    grid = {0.8, 0.8, 0.8},
    cell = {0.2, 0.6, 1.0}
}


function love.load()    
    -- calculate grid dimensions based on window size
    local windowWidth = love.graphics.getWidth()
    local windowHeight = love.graphics.getHeight()
    local gridWidth = math.floor(windowWidth / cellSize)
    local gridHeight = math.floor(windowHeight / cellSize)
    
    grid = Grid.new(cellSize, gridWidth, gridHeight)
end

function love.draw()
    love.graphics.setBackgroundColor(colors.background)
    local gridWidth, gridHeight = grid:getDimensions()
    
    -- cells
    for y = 1, gridHeight do
        for x = 1, gridWidth do
            if grid:getCell(x, y) == 1 then
                love.graphics.setColor(colors.cell)
                love.graphics.rectangle("fill", 
                    (x-1) * cellSize, 
                    (y-1) * cellSize, 
                    cellSize-1, 
                    cellSize-1
                )
            end
        end
    end
    
    -- grid lines
    love.graphics.setColor(colors.grid)
    for x = 0, gridWidth do
        love.graphics.line(x * cellSize, 0, x * cellSize, gridHeight * cellSize)
    end
    for y = 0, gridHeight do
        love.graphics.line(0, y * cellSize, gridWidth * cellSize, y * cellSize)
    end

end