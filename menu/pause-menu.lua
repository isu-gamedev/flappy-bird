require 'menu.menu-item'
require 'menu.menu'

PauseMenu = {}
PauseMenu.__index = PauseMenu

setmetatable(PauseMenu, Menu)

function PauseMenu:create()
    local menu = Menu:create('Pause', {MenuItem:create('Continue', continue), MenuItem:create('Restart', start), MenuItem:create('Sound', toggleSound),
                                       MenuItem:create('Quit', quit)})
    setmetatable(menu, PauseMenu)
    return menu
end

function PauseMenu:draw()
    local r, g, b, a = love.graphics.getColor()
    love.graphics.setColor(0, 0, 0, 0.7)
    love.graphics.rectangle('fill', 0, 0, width, height)
    love.graphics.setColor(r, g, b, a)
    self:drawMenu()
end
