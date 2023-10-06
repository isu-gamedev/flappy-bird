require "vector"
require "mover"
require "camera"
require "obstacle"
require "collisionDetector"

function love.load()
    love.window.setTitle("Flappy Bird")
    width = love.graphics.getWidth()
    height = love.graphics.getHeight()
    love.graphics.setBackgroundColor(0, 0, 0, 0)

    mover = Mover:create(Vector:create(0, height / 2), Vector:create(0.8, 0))
    gravity = Vector:create(0, 0.1)
    camera = Camera:create(mover.location)
    -- TUBES
    tubes = {}
    math.randomseed(os.time())
    local tubesWidth = 100
    local betweenTubes = 300
    local tubesNum = math.ceil(width / (tubesWidth + betweenTubes)) + 2
    for i=1,tubesNum do
        local gap = 150
        local toGap = math.random(height - gap)
        tubes[i] = Obstacle:create((i - 1) * betweenTubes + width / 2, tubesWidth, gap, toGap)
    end

    currentTube = nil
    spacePressedFor = 0
    score = 0

    font = love.graphics.newFont("fonts/MartianMono.ttf", 24)
end

function love.update(dt)
    mover:applyForce(gravity)
    if love.keyboard.isDown("space") and spacePressedFor < 0.2 then
        if spacePressedFor == 0 then
            mover.velocity.y = mover.velocity.y * 0
        end
        -- mover.acceleration:mul(0)
        spacePressedFor = spacePressedFor + dt
        mover:applyForce(gravity * -100)
    end
    mover:update(dt)

    if currentTube then
        if not rectCircleCollision(currentTube, mover) then
            currentTube = nil        
            score = score + 1
        else
            for k=1,#currentTube.parts do
                if rectCircleCollision(currentTube.parts[k], mover) then
                    mover.color = {255, 0, 0, 255}
                    break
                else
                    mover.color = {255, 255, 255, 255}
                end
            end
        end
    else
        mover.color = {255, 255, 255, 255}
    end
    for i=1,#tubes do
        local currTube = tubes[i]
        if currTube.location.x + currTube.width + camera.fixedLocation.x < mover.location.x - mover.size then
            local newTube = Obstacle:create(tubes[#tubes].location.x + 300, currTube.width, currTube.gap, math.random(height - currTube.gap))
            table.remove(tubes, i)
            table.insert(tubes, newTube)
        end
        if not currentTube and rectCircleCollision(currTube, mover) then
            currentTube = currTube                
        end
    end
end


function love.draw()
    mover:draw(camera.fixedLocation)
    local offset = camera:getOffset()
    for i=1,#tubes do
        tubes[i]:draw(offset)
    end
    love.graphics.printf("Score: " .. score, font,0, 30,  width, "center")
end

function love.keyreleased( key, scancode )
    if key == "space" then
        spacePressedFor = 0
    end
end


-- TODO: larger distance between gaps
-- TODO: win / loss
-- TODO: menu
