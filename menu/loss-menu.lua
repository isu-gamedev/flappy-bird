LossMenu = {}
LossMenu.__index = LossMenu

setmetatable(LossMenu, Menu)

function LossMenu:create(score)
    local loss = Menu:create("You lost. Your score: " .. score, {MenuItem:create("Try again", start), 
    MenuItem:create("Quit", quit)})
    setmetatable(loss, LossMenu)
    return loss
end

function LossMenu:draw()
    local r, g, b, a = love.graphics.getColor()
    love.graphics.setColor(0,0,0,0.7)
    love.graphics.rectangle("fill", 0, 0, width, height)
    love.graphics.setColor(r, g, b, a)
    self:drawMenu()
end