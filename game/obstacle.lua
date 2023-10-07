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
    obstacle.parts = {
        {location = Vector:create(x, -offScreen), width = width, height = toGap + offScreen},
        {location = Vector:create(x, toGap + gap), width = width, height = obstacle.height}
    }
    return obstacle
end

function Obstacle:draw(offset)
    for i=1,#self.parts do
        local offsetLocation = self.parts[i].location + offset
        love.graphics.rectangle("line", offsetLocation.x, offsetLocation.y, self.parts[i].width, self.parts[i].height)
    end
end