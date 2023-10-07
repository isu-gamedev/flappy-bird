require "game"
require "menu"

function love.load()
    love.window.setTitle("Flappy Bird")
    width = love.graphics.getWidth()
    height = love.graphics.getHeight()

    pauseMenu = PauseMenu:create()

    start()
end

function love.update(dt)
    timePassed = timePassed + dt
    if currState == "game" then
        gameScreen:update(dt)
    elseif currState == "gameStart" then
        gameScreen:updateIdle(dt, timePassed)
    end
end


function love.draw()
    gameScreen:draw()
    if currState == "paused" then
        pauseMenu:draw()
    end
end

function love.keypressed(key, scancode)
    local func
    if currState == "gameStart" then
        if key == "space" then
            changeState("game")            
        end
    elseif currState == "paused" then
        func = pauseMenu:keypressed(key, scancode) 
        if func then
            func()
        end
    end
    if key == 'p' then
        if currState == "game" or currState == "gameStart" then
            changeState("paused", true)
        else
            continue()
        end
    end
end

function love.keyreleased( key, scancode )
    if currState == "game" then
        gameScreen:keyreleased(key, scancode)
    end
end


function continue()
    pauseMenu:revert()
    changeState(prePaused)
end

function start()
    gameScreen = GameScreen:create()
    changeState("gameStart")
    pauseMenu:revert()
    
    timePassed = 0
end

function quit()
    love.event.quit(0)
end

function changeState(newState, paused)
    if not paused then
        prePaused = newState
    end
    currState = newState
end


-- TODO: win / loss
