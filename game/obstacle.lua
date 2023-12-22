Obstacle = {}
Obstacle.__index = Obstacle

function Obstacle:create(x, width, gap, toGap)
    local obstacle = {}
    setmetatable(obstacle, Obstacle)
    local offScreen = 500

    obstacle.location = Vector:create(x, -offScreen)
    obstacle.height = height + offScreen
    obstacle.width = width
    obstacle.toGap = toGap
    obstacle.gap = gap
    obstacle.parts = {{
        location = Vector:create(x, -offScreen),
        width = width,
        height = toGap + offScreen
    }, {
        location = Vector:create(x, toGap + gap),
        width = width,
        height = obstacle.height
    }}
    obstacle.sprites = {love.graphics.newImage('assets/images/tube1.png'), love.graphics.newImage('assets/images/tube2.png'),
                        love.graphics.newImage('assets/images/tube3.png')}
    return obstacle
end

function Obstacle:draw(offset)
    for i = 1, #self.parts do
        local offsetLocation = self.parts[i].location + offset
        -- love.graphics.rectangle('line', offsetLocation.x, offsetLocation.y, self.parts[i].width, self.parts[i].height)
        self:_drawSprite(offsetLocation, i)
    end
end

function Obstacle:_drawSprite(offset, part)
    local heights = {self.sprites[1]:getHeight() - 2, self.sprites[2]:getHeight() - 2, self.sprites[3]:getHeight() - 2}
    local scale = self.width / (self.sprites[1]:getWidth())
    local scaleY = (self.parts[part].height - heights[1] * scale - heights[3] * scale) / heights[2]
    -- print(self.parts[part].height - heights[1] * scale - heights[3] * scale)
    if part == 1 then
        love.graphics.draw(self.sprites[3], offset.x, offset.y, 0, scale, scale)
        love.graphics.draw(self.sprites[2], offset.x, offset.y + heights[3] * scale, 0, scale, scaleY)
        love.graphics.draw(self.sprites[1], offset.x, offset.y + heights[3] * scale + heights[2] * scaleY + heights[1] * scale, 0, scale, -scale)
    elseif part == #self.parts then
        love.graphics.draw(self.sprites[1], offset.x, offset.y, 0, scale, scale)
        love.graphics.draw(self.sprites[2], offset.x, offset.y + heights[1] * scale, 0, scale, scaleY)
        love.graphics.draw(self.sprites[3], offset.x, offset.y + heights[1] * scale + heights[2] * scaleY, 0, scale, scale)
    end
end
