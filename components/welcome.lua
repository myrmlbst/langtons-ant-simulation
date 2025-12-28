local Welcome = {}
local font = nil

local button = {
    x = 0,
    y = 0,
    width = 250,
    height = 50,
    text = "Initialize Simulation",
    color = {0.2, 0.6, 1.0},
    hoverColor = {0.1, 0.5, 0.9},
    currentColor = {0.2, 0.6, 1.0},
    textColor = {0, 0, 0}
}

function Welcome.load()
    font = love.graphics.newFont(24)
    button.x = love.graphics.getWidth() / 2 - button.width / 2
    button.y = love.graphics.getHeight() / 2 - button.height / 2 + 100
end

function Welcome.update(dt)
    local mx, my = love.mouse.getPosition()
    
    -- check if mouse is hovering over the button
    if mx > button.x and mx < button.x + button.width and
       my > button.y and my < button.y + button.height then
        button.currentColor = button.hoverColor
    else
        button.currentColor = button.color
    end
end

function Welcome.draw()
    love.graphics.setBackgroundColor(0.95, 0.95, 0.95)
    
    local title = "Langton's Ant Simulation"
    local titleFont = love.graphics.newFont(32)
    love.graphics.setFont(titleFont)
    local titleWidth = titleFont:getWidth(title)
    love.graphics.print(title, love.graphics.getWidth()/2 - titleWidth/2, 100)

    local description = {
        "This project is a simulation of Langton's Ant,", 
        "and how its behavior evolves over time.",
        "",
        "This project demonstrates Deterministic Chaos:",
        "the emergence of complex patterns from simple rules."
    }
    
    love.graphics.setFont(font)
    for i, line in ipairs(description) do
        local textWidth = font:getWidth(line)
        love.graphics.print(line, love.graphics.getWidth()/2 - textWidth/2, 180 + (i * 30))
    end

    love.graphics.setColor(button.currentColor)
    love.graphics.rectangle("fill", button.x, button.y, button.width, button.height, 10, 200)
    love.graphics.setColor(button.textColor)
    local textWidth = font:getWidth(button.text)
    local textX = button.x + (button.width - textWidth) / 2
    local textY = button.y + (button.height - font:getHeight()) / 2
    love.graphics.print(button.text, textX, textY)
end

function Welcome.mousepressed(x, y, buttonPressed)
    if buttonPressed == 1 then -- left mouse button
        if x > button.x and x < button.x + button.width and
           y > button.y and y < button.y + button.height then
            return true -- signal that we should switch to the main simulation
        end
    end
    return false
end

return Welcome
