local Ant = {}
Ant.__index = Ant

-- directions the ant can face (in clockwise order)
local DIRECTIONS = {
    UP = {x = 0, y = -1},    -- UP
    RIGHT = {x = 1, y = 0},  -- RIGHT
    DOWN = {x = 0, y = 1},   -- DOWN
    LEFT = {x = -1, y = 0}   -- LEFT
}


-- create a new ant at the given position
function Ant.new(x, y)
    local self = setmetatable({}, Ant)
    self.x = x or 1
    self.y = y or 1
    self.direction = DIRECTIONS.UP  -- start facing up
    self.directionIndex = 1         -- index in the directions table
    
    -- directions in order (for turning)
    self.directions = {
        DIRECTIONS.UP,
        DIRECTIONS.RIGHT,
        DIRECTIONS.DOWN,
        DIRECTIONS.LEFT
    }
    
    return self
end


-- turn the ant 90 degrees to the right
function Ant:turnRight()
    self.directionIndex = (self.directionIndex % #self.directions) + 1
    self.direction = self.directions[self.directionIndex]
end


-- turn the ant 90 degrees to the left
function Ant:turnLeft()
    self.directionIndex = self.directionIndex - 1
    if self.directionIndex < 1 then
        self.directionIndex = #self.directions
    end
    self.direction = self.directions[self.directionIndex]
end


-- move the ant forward one cell in its current direction
function Ant:move()
    self.x = self.x + self.direction.x
    self.y = self.y + self.direction.y
end


-- update the ant's position based on the current cell's state
-- return the new cell state (0 or 1)
function Ant:update(grid)
    -- get current cell state
    local currentState = grid:getCell(self.x, self.y) or 0
    
    -- change the color of the current cell
    if currentState == 0 then
        -- white cell: flip to black
        grid:setCell(self.x, self.y, 1)
        -- turn right
        self:turnRight()
    else
        -- black cell: flip to white
        grid:setCell(self.x, self.y, 0)
        -- turn left
        self:turnLeft()
    end
    
    -- move forward to the next cell
    self:move()
    
    -- return the new state of the cell we just left (which was already flipped)
    return currentState == 0 and 1 or 0
end


-- draw the ant (to be called from the main draw loop)
function Ant:draw(cellSize)
    -- draw a red square for the ant (RGB: 255, 0, 0)
    love.graphics.setColor(1, 0, 0, 0.9)
    love.graphics.rectangle("fill", 
        (self.x - 1) * cellSize, 
        (self.y - 1) * cellSize, 
        cellSize, 
        cellSize
    )
    
    -- draw an indicator for the direction the ant is facing
    local centerX = (self.x - 0.5) * cellSize
    local centerY = (self.y - 0.5) * cellSize
    local dirX = centerX + self.direction.x * cellSize * 0.4
    local dirY = centerY + self.direction.y * cellSize * 0.4
    
    love.graphics.setColor(1, 1, 1)
    love.graphics.circle("fill", dirX, dirY, cellSize * 0.2)
end


return Ant