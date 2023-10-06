require "vector"

Mover = {}
Mover.__index = Mover

function Mover:create(location, velocity, weight, color)
    local mover = {}
    setmetatable(mover, Mover)
    mover.location = location
    mover.velocity = velocity
    mover.acceleration = Vector:create(0, 0)
    mover.size = 20
    mover.weight = weight or 1
    mover.color = color or {255, 255, 255, 255}
    return mover
end

function Mover:draw(fixedLocation)
    love.graphics.setColor(self.color)
    -- love.graphics.circle("fill", self.location.x, self.location.y, self.size)
    if not fixedLocation then
        fixedLocation = Vector:create(width / 2, height / 2)
    end
    love.graphics.circle("fill", fixedLocation.x, fixedLocation.y, self.size)
    love.graphics.setColor({255, 255, 255, 255})
end

function Mover:update(dt)
    dt = dt * 100
    self.velocity:add(self.acceleration * dt)
    if self.velocity.y < -3 then
        self.velocity.y = -3
    end
    self.location:add(self.velocity * dt)
    self.acceleration:mul(0)
    -- self:checkBoundaries()
end

function Mover:applyForce(force)
    self.acceleration:add(force * self.weight)
end

function Mover:checkBoundaries()
    if self.location.x >= width - self.size then
        self.location.x = width - self.size
        self.velocity.x = -1 * self.velocity.x
    elseif self.location.x <= self.size then 
        self.location.x = self.size
        self.velocity.x = -1 * self.velocity.x        
    end
    if self.location.y >= height - self.size then
        self.location.y = height - self.size
        self.velocity.y = -1 * self.velocity.y
    elseif self.location.y <= self.size then 
        self.location.y = self.size
        self.velocity.y = -1 * self.velocity.y
    end
end