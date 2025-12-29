local Grid = {}
Grid.__index = Grid


function Grid.new(cellSize, width, height)
    local self = setmetatable({}, Grid)    
    self.cellSize = cellSize or 20
    self.width = width or 40
    self.height = height or 30
    
    -- initialize grid with all cells white (0 = white, 1 = black)
    self.cells = {}
    for y = 1, self.height do
        self.cells[y] = {}
        for x = 1, self.width do
            self.cells[y][x] = 0
        end
    end
    
    -- keep track of cells that need to be redrawn
    self.dirtyCells = {}
    
    return self
end


function Grid:getCell(x, y)
    return self:isInBounds(x, y) and self.cells[y][x] or nil
end


function Grid:setCell(x, y, value)
    if self:isInBounds(x, y) then
        local current = self.cells[y][x]
        if value == 1 or value == true then
            value = 1
        else
            value = 0
        end
        if current ~= value then
            self.cells[y][x] = value
            -- mark cell as dirty
            self.dirtyCells[#self.dirtyCells + 1] = {x = x, y = y, value = value}
        end
        return true
    end
    return false
end


function Grid:getDimensions()
    return self.width, self.height
end


-- get all cells that have changed since last clear
function Grid:getDirtyCells()
    return self.dirtyCells
end


-- clear the dirty cells list
function Grid:clearDirtyCells()
    self.dirtyCells = {}
end


-- check if coordinates are within grid bounds
function Grid:isInBounds(x, y)
    return y >= 1 and y <= self.height and x >= 1 and x <= self.width
end


return Grid