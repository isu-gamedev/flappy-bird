MenuItem = {}
MenuItem.__index = MenuItem

function MenuItem:create(text, func, args)
    local item = {}
    setmetatable(item, MenuItem)

    item.text = text
    item.height = 50
    item.width = 100
    item.func = func
    item.args = args
    item.font = love.graphics.newFont('fonts/MartianMono.ttf', 12)
    item.sound = love.audio.newSource('/assets/sounds/click.mp3', 'static')
    item.sound:setVolume(0.3)

    item.image = image
    item.image_pressed = image_pressed
    item.image_chosen = image_chosen
    return item
end

function MenuItem:draw(menuOffsetX, menuOffsetY, chosen)
    local x = menuOffsetX
    local y = menuOffsetY
    local padding = self:getPadding()

    local textColor = {255, 255, 255, 255}
    local fillMode = 'line'
    if chosen then
        textColor = {0, 0, 0, 255}
        fillMode = 'fill'
    end
    love.graphics.rectangle(fillMode, x, y, self.width, self.height)
    love.graphics.printf({textColor, self.text}, self.font, x, y + padding, self.width, 'center')
end

function MenuItem:getPadding()
    return (self.height - self.font:getHeight()) / 2
end
