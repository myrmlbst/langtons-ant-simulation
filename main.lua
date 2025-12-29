local Grid = require("components.grid")
local Welcome = require("components.welcome")
local Ant = require("components.ant")

-- states
local GAME_STATE = {
    WELCOME = 1,
    GRID_VIEW = 2
}

local gameState = GAME_STATE.WELCOME

local grid, ants
local cellSize = 5
local smallFont = love.graphics.newFont(12)
local antSound

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
    ants = {}
    
    -- load ant sound
    antSound = love.audio.newSource("sounds/ant.mp3", "static")
    antSound:setVolume(0.5)
    
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
            for antIndex = #ants, 1, -1 do
                local ant = ants[antIndex]
                ant:update(grid)
                stepCounter = stepCounter + 1

                -- check if ant is out of bounds
                if not grid:isInBounds(ant.x, ant.y) then
                    table.remove(ants, antIndex)
                end
            end

            if #ants == 0 then
                isSimulationRunning = false
                break
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

        for _, ant in ipairs(ants) do
            if grid:isInBounds(ant.x, ant.y) then
                ant:draw(cellSize)
            end
        end

        -- save current font
        local oldFont = love.graphics.getFont()
        love.graphics.setFont(smallFont)
        
        -- calculate positions
        local x = 15
        local y = 10
        local lineHeight = smallFont:getHeight() + 2
        
        -- controls section
        love.graphics.setColor(0.3, 0.3, 0.3)
        love.graphics.print("CONTROLS:", x, y)
        y = y + lineHeight * 1.5
        
        local controls = {
            "Space: " .. (isSimulationRunning and "Pause" or "Start"),
            "R: Reset",
            "Click on Cell: Add ant",
            -- "Right Click: Toggle cell",
            "+/−: Change speed",
            "ESC: Quit"
        }

        for _, text in ipairs(controls) do
            love.graphics.print(text, x, y)
            y = y + lineHeight
        end
        
        y = y + lineHeight * 0.5
        love.graphics.print("Steps: " .. stepCounter, x, y)
        y = y + lineHeight
        love.graphics.print("Speed: " .. simulationSpeed .. "x", x, y)
        
        love.graphics.setFont(oldFont)
    end
end


function love.mousepressed(x, y, button, istouch, presses)
    if gameState == GAME_STATE.WELCOME then
        if Welcome.mousepressed(x, y, button) then
            gameState = GAME_STATE.GRID_VIEW
            isSimulationRunning = false
            stepCounter = 0
        end
    
    elseif gameState == GAME_STATE.GRID_VIEW and (button == 1 or button == 2) then
        local cellX = math.floor(x / cellSize) + 1
        local cellY = math.floor(y / cellSize) + 1
        
        if grid:isInBounds(cellX, cellY) then
            if button == 1 then
                ants[#ants + 1] = Ant.new(cellX, cellY)
                love.audio.play(antSound)
            else
                -- toggle cell state on right click
                local current = grid:getCell(cellX, cellY)
                grid:setCell(cellX, cellY, 1 - current)
            end
        end
    end

end


function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
        return
    end
    
    if gameState == GAME_STATE.GRID_VIEW then
        if key == "space" then
            if #ants > 0 then
                isSimulationRunning = not isSimulationRunning
            end
        
        elseif key == "r" then
            -- reset simulation
            local gridWidth, gridHeight = grid:getDimensions()
            grid = Grid.new(cellSize, gridWidth, gridHeight)
            ants = {}
            stepCounter = 0
            isSimulationRunning = false
        
        elseif key == "+" or key == "up" then
            -- speed up simulation
            simulationSpeed = math.min(simulationSpeed * 2, 128)
        
        elseif key == "-" or key == "down" then
            -- slow down simulation
            simulationSpeed = math.max(1, math.floor(simulationSpeed / 2))
        
        elseif key == "return" and not isSimulationRunning then
            -- single step when simulation is paused
            for antIndex = #ants, 1, -1 do
                local ant = ants[antIndex]
                ant:update(grid)
                stepCounter = stepCounter + 1

                if not grid:isInBounds(ant.x, ant.y) then
                    table.remove(ants, antIndex)
                end
            end
        end
        
    end
end