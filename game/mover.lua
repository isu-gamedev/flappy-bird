require 'game.vector'

Mover = {}
Mover.__index = Mover

function Mover:create(location, velocity, weight, color)
    local mover = {}
    setmetatable(mover, Mover)
    mover.location = location
    mover.velocity = velocity
    mover.acceleration = Vector:create(0, 0)
    mover.weight = weight or 1
    mover.color = color or {255, 255, 255, 255}
    mover.sound = love.audio.newSource('/assets/sounds/jump.mp3', 'static')
    mover.sound:setVolume(0.5)

    mover.animation = Mover.newAnimation(love.graphics.newImage('/assets/images/rat.png'), 30)

    mover.height = 110
    mover.scale = 1 / (mover.animation.spriteSheet:getHeight() / mover.height)
    mover.collisionOffset = Vector:create(5, 10)
    mover.width = mover.animation.spriteSheet:getWidth() / 4 * mover.scale

    return mover
end

function Mover:draw(fixedLocation)
    love.graphics.setColor(self.color)
    -- love.graphics.circle("fill", self.location.x, self.location.y, self.size)
    if not fixedLocation then
        fixedLocation = Vector:create(width / 2, height / 2)
    end
    -- love.graphics.circle('fill', fixedLocation.x, fixedLocation.y, self.size)
    love.graphics.setColor({255, 255, 255, 255})
    local spriteNum = math.floor(self.animation.currentTime / self.animation.duration * #self.animation.quads) + 1
    -- print(self.animation.currentTime, self.animation.duration)
    love.graphics.draw(self.animation.spriteSheet, self.animation.quads[spriteNum], fixedLocation.x, fixedLocation.y, 0, self.scale, self.scale)
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

    self.animation.currentTime = self.animation.currentTime + dt
    if self.animation.currentTime >= self.animation.duration then
        self.animation.currentTime = self.animation.currentTime - self.animation.duration * math.floor(self.animation.currentTime / self.animation.duration)
    end
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

function Mover.newAnimation(image, duration)
    local animation = {}
    animation.spriteSheet = image
    animation.quads = {}
    local width = math.floor(image:getWidth() / 4)
    local height = image:getHeight()
    for x = 0, image:getWidth() - width, width do
        table.insert(animation.quads, love.graphics.newQuad(x, 0, width, height, image:getDimensions()))
    end

    animation.duration = duration or 1
    animation.currentTime = 0

    return animation
end
