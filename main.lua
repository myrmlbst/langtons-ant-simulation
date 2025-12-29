local Grid = require("components.grid")
local Welcome = require("components.welcome")
local Ant = require("components.ant")

-- states
local GAME_STATE = {
    WELCOME = 1,
    GRID_VIEW = 2
}

local gameState = GAME_STATE.WELCOME
local grid, ant
local cellSize = 10
local colors = {
    background = {0.9, 0.9, 0.9},
    grid = {0.8, 0.8, 0.8},
    cell = {0.2, 0.2, 0.2},
    cellBlack = {0.1, 0.1, 0.1}
}

-- simulation controls
local isSimulationRunning = false
local simulationSpeed = 1  -- steps per frame
local stepCounter = 0


function love.load()    
    -- init welcome screen
    Welcome.load()
    
    -- calculate grid dimensions based on window size
    local windowWidth = love.graphics.getWidth()
    local windowHeight = love.graphics.getHeight()
    local gridWidth = math.floor(windowWidth / cellSize)
    local gridHeight = math.floor(windowHeight / cellSize)
    
    -- initialize grid and place ant in the center
    grid = Grid.new(cellSize, gridWidth, gridHeight)
    local startX = math.floor(gridWidth / 2)
    local startY = math.floor(gridHeight / 2)
    ant = Ant.new(startX, startY)
    
    -- initialize simulation controls
    isSimulationRunning = false
    simulationSpeed = 1
    stepCounter = 0
end


function love.update(dt)
    if gameState == GAME_STATE.WELCOME then
        Welcome.update(dt)
    elseif gameState == GAME_STATE.GRID_VIEW and isSimulationRunning then
        -- run simulation steps
        for i = 1, simulationSpeed do
            if ant then
                ant:update(grid)
                stepCounter = stepCounter + 1
                
                -- check if ant is out of bounds
                if not grid:isInBounds(ant.x, ant.y) then
                    -- reset ant position to center if it goes out of bounds
                    ant = Ant.new(
                        math.floor(grid:getDimensions() / 2),
                        math.floor(select(2, grid:getDimensions()) / 2)
                    )
                end
            end
        end
    end
end


function love.draw()
    if gameState == GAME_STATE.WELCOME then
        Welcome.draw()

    elseif gameState == GAME_STATE.GRID_VIEW then
        local gridWidth, gridHeight = grid:getDimensions()
        
        love.graphics.setBackgroundColor(colors.background)
        
        -- draw filled cells
        for y = 1, gridHeight do
            for x = 1, gridWidth do
                if grid:getCell(x, y) == 1 then
                    love.graphics.setColor(colors.cellBlack)
                    love.graphics.rectangle("fill", (x-1)*cellSize, (y-1)*cellSize, cellSize, cellSize)
                end
            end
        end
        
        -- draw grid lines
        love.graphics.setColor(colors.grid)
        for x = 0, gridWidth do
            love.graphics.line(x * cellSize, 0, x * cellSize, gridHeight * cellSize)
        end
        for y = 0, gridHeight do
            love.graphics.line(0, y * cellSize, gridWidth * cellSize, y * cellSize)
        end
        
        if ant and grid:isInBounds(ant.x, ant.y) then
            ant:draw(cellSize)
        end

    end
end


function love.mousepressed(x, y, button, istouch, presses)
    if gameState == GAME_STATE.WELCOME then
        if Welcome.mousepressed(x, y, button) then
            gameState = GAME_STATE.GRID_VIEW
        end
    elseif gameState == GAME_STATE.GRID_VIEW and button == 1 then
        -- toggle cell state on click
        local cellX = math.floor(x / cellSize) + 1
        local cellY = math.floor(y / cellSize) + 1
        
        if grid:isInBounds(cellX, cellY) then
            local current = grid:getCell(cellX, cellY)
            grid:setCell(cellX, cellY, 1 - current)
        end
    end
end

function love.keypressed(key)
    if gameState == GAME_STATE.GRID_VIEW then
        if key == "space" then
            isSimulationRunning = not isSimulationRunning
        
        elseif key == "r" then
            -- reset simulation
            grid = Grid.new(cellSize, grid:getDimensions())
            local startX = math.floor(select(1, grid:getDimensions()) / 2)
            local startY = math.floor(select(2, grid:getDimensions()) / 2)
            ant = Ant.new(startX, startY)
            stepCounter = 0
            isSimulationRunning = false
        
        elseif key == "+" then
            simulationSpeed = math.min(simulationSpeed * 2, 64)
        
        elseif key == "-" then
            simulationSpeed = math.max(1, math.floor(simulationSpeed / 2))
        
        elseif key == "return" and not isSimulationRunning then
            -- single step when simulation is paused
            if ant then
                ant:update(grid)
                stepCounter = stepCounter + 1
            end
        end
        
    end
end