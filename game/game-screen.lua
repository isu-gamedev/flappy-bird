require "game.vector"
require "game.mover"
require "game.camera"
require "game.obstacle"
require "game.collision-detector"

GameScreen = {}
GameScreen.__index = GameScreen

function GameScreen:create()
    local gameScreen = {}
    setmetatable(gameScreen, GameScreen)
    self:load()
    return gameScreen
end

function GameScreen:load()
    love.graphics.setBackgroundColor(0, 0, 0, 0)

    self.mover = Mover:create(Vector:create(0, height / 2), Vector:create(0, 0))
    self.gravity = Vector:create(0, 0.1)
    self.camera = Camera:create(self.mover)
    -- TODO: change
    self.tubes = {}

    self:generateTubes()

    -- OTHER
    self.currentTube = nil
    self.spacePressedFor = 0
    self.score = 0
    self.font = love.graphics.newFont("fonts/MartianMono.ttf", 24)
end

function GameScreen:update(dt)
    self.mover.velocity.x = 0.8
    self.mover:applyForce(self.gravity)
    if love.keyboard.isDown("space") and self.spacePressedFor < 0.2 then
        self:birdUp(dt)
    end
    self.mover:update(dt)

    if self.currentTube then
        if not rectCircleCollision(self.currentTube, self.mover) then
            self.currentTube = nil
            self.score = self.score + 1
        else
            for k=1,#self.currentTube.parts do
                if rectCircleCollision(self.currentTube.parts[k], self.mover) then
                    self.mover.color = {255, 0, 0, 255}
                    break
                else
                    self.mover.color = {255, 255, 255, 255}
                end
            end
        end
    else
        self.mover.color = {255, 255, 255, 255}
    end

    for i=1,#self.tubes do
        local currTube = self.tubes[i]
        if self.camera:notVisible(currTube) then
            local newTube = self:generateTube(self.tubes[#self.tubes].location.x)
            table.remove(self.tubes, i)
            table.insert(self.tubes, newTube)
        end
        if not self.currentTube and rectCircleCollision(currTube, self.mover) then
            self.currentTube = currTube                
        end
    end
end

function GameScreen:draw()
    local offset = self.camera:getOffset()
    self.mover:draw(self.camera.fixedLocation)
    for i=1,#self.tubes do
        self.tubes[i]:draw(offset)
    end
    self:printScore()
end


function GameScreen:keyreleased( key, scancode )
    if key == "space" then
        self.spacePressedFor = 0
    end
end


function GameScreen:generateTubes()
    math.randomseed(os.time())

    self.tubesWidth = 100
    self.betweenTubes = 200
    self.gap = 150
    local tubesNum = math.ceil(width / (self.tubesWidth + self.betweenTubes)) + 2
    self.tubes[1] = self:generateTube(0)
    for i=2, tubesNum do
        self.tubes[i] = self:generateTube(self.tubes[i - 1].location.x)
    end
end


function GameScreen:generateTube(prevX)
    local x = prevX + self.tubesWidth + self.betweenTubes
    local toGap = math.random(height - self.gap)
    return Obstacle:create(x, self.tubesWidth, self.gap, toGap)
end


function GameScreen:printScore()
    love.graphics.printf("Score: " .. self.score, self.font , 0, 30, width, "center")
end

function GameScreen:birdUp(dt)
    if self.spacePressedFor == 0 then
        self.mover.velocity.y = 0
    end
    self.spacePressedFor = self.spacePressedFor + dt
    self.mover:applyForce(self.gravity * -100)
end

function GameScreen:updateIdle(dt, timePassed)
    local distance = 700 -- обратная зависимость
    local time = 1.5 -- прямая зависимость
    self.mover:applyForce(Vector:create(0, math.cos(timePassed * time) / distance))
    self.mover:update(dt)
end