local Grid = {}
Grid.__index = Grid


function Grid.new(cellSize, width, height)
    local self = setmetatable({}, Grid)
    
    self.cellSize = cellSize or 20
    self.width = width or 40
    self.height = height or 30
    
    -- initialize grid with all cells empty (0 = empty, 1 = filled)
    self.cells = {}
    for y = 1, self.height do
        self.cells[y] = {}
        for x = 1, self.width do
            self.cells[y][x] = 0
        end
    end
    
    return self
end


function Grid:isInBounds(x, y)
    return y >= 1 and y <= #self.cells and x >= 1 and x <= #self.cells[1]
end


function Grid:getCell(x, y)
    return self:isInBounds(x, y) and self.cells[y][x] or nil
end


function Grid:setCell(x, y, value)
    if self:isInBounds(x, y) then
        self.cells[y][x] = value and 1 or 0
        return true
    end
    return false
end


function Grid:getDimensions()
    return self.width, self.height
end


return Grid