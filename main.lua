require 'game'
require 'menu'

GameState = {
    GAME_START = 0,
    MAIN_MENU = 1,
    GAME = 2,
    PAUSED = 3,
    GAME_OVER = 4
}

function love.load()
    love.window.setTitle('Flappy Bird')
    width = love.graphics.getWidth()
    height = love.graphics.getHeight()

    pauseMenu = PauseMenu:create()
    gameOverMenu = nil
    love.audio.stop()

    mainMusic = love.audio.newSource('assets/sounds/background.mp3', 'stream')
    mainMusic:play()
    mainMusic:setVolume(0.4)
    soundsOn = true
    start()
end

function love.update(dt)
    timePassed = timePassed + dt
    if currState == GameState.GAME then
        if not gameScreen:update(dt) then
            changeState(GameState.GAME_OVER)
            gameOverMenu = LossMenu:create(gameScreen.score)
        end
    elseif prePaused == GameState.GAME_START then
        gameScreen:updateIdle(dt, timePassed)
    end
end

function love.draw()
    gameScreen:draw()
    if currState == GameState.PAUSED then
        pauseMenu:draw()
    elseif currState == GameState.GAME_OVER then
        gameOverMenu:draw()
    end
end

function love.keypressed(key, scancode)
    local func
    if currState == GameState.GAME_START then
        if key == 'space' then
            changeState(GameState.GAME)
        end
    elseif currState == GameState.PAUSED then
        func = pauseMenu:keypressed(key, scancode)
        if func then
            func()
        end
    elseif currState == GameState.GAME_OVER then
        func = gameOverMenu:keypressed(key, scancode)
        if func then
            func()
        end
    elseif currState == GameState.GAME then
        gameScreen:keypressed(key)
    end
    if key == 'escape' then
        if currState == GameState.GAME or currState == GameState.GAME_START then
            changeState(GameState.PAUSED, true)
        else
            continue()
        end
    end
end

function love.keyreleased(key, scancode)
    if currState == GameState.GAME then
        gameScreen:keyreleased(key, scancode)
    end
end

function continue()
    pauseMenu:revert()
    changeState(prePaused)
end

function start()
    gameScreen = GameScreen:create()
    changeState(GameState.GAME_START)
    pauseMenu:revert()

    timePassed = 0
end

function quit()
    love.event.quit(0)
end

function toggleSound()
    if soundsOn then
        mainMusic:setVolume(0)
        gameScreen.sounds:setVolume(0)
        soundsOn = false
    else
        gameScreen.sounds:setVolume(0.7)
        mainMusic:setVolume(0.1)
        soundsOn = true
    end
end

function changeState(newState, paused)
    if not paused then
        prePaused = newState
    end
    currState = newState
    if not soundsOn then
        return
    end
    if currState ~= GameState.GAME then
        gameScreen.sounds:setVolume(0.7)
        mainMusic:setVolume(0.1)
    else
        gameScreen.sounds:setVolume(1)
        mainMusic:setVolume(0.4)
    end
end
