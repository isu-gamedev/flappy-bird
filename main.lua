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
    love.window.setMode(1920 * 0.5, 1080 * 0.5)
    width = love.graphics.getWidth()
    height = love.graphics.getHeight()
    scale = width / 1920
    mainMenu = Menu:create('assets/images/menu-main.png',
        {MenuItem:create(scale * 600, scale * 472, 'assets/images/menu/start.png', 'assets/images/menu/start-active.png', start),
         MenuItem:create(scale * 530, scale * 605, 'assets/images/menu/soundOnG.png', 'assets/images/menu/soundOnG-active.png', toggleSound),
         MenuItem:create(scale * 717, scale * 735, 'assets/images/menu/exitY.png', 'assets/images/menu/exitY-active.png', love.event.quit, {0})})
    pauseMenu = Menu:create('assets/images/menu-pause.jpg',
        {MenuItem:create(scale * 380, scale * 251, 'assets/images/menu/continue.png', 'assets/images/menu/continue-active.png', continue),
         MenuItem:create(scale * 76, scale * 538, 'assets/images/menu/soundOnR.png', 'assets/images/menu/soundOnR-active.png', toggleSound),
         MenuItem:create(scale * 593, scale * 818, 'assets/images/menu/newGame.png', 'assets/images/menu/newGame-active.png', start),
         MenuItem:create(scale * 1622, scale * 758, 'assets/images/menu/exitY.png', 'assets/images/menu/exitY-active.png', love.event.quit, {0})})
    gameOverMenu = Menu:create('assets/images/menu-gameOver.png',
        {MenuItem:create(scale * 76, scale * 730, 'assets/images/menu/startAgain.png', 'assets/images/menu/startAgain-active.png', start),
         MenuItem:create(scale * 1608, scale * 733, 'assets/images/menu/exitB.png', 'assets/images/menu/exitB-active.png', love.event.quit, {0})})
    love.audio.stop()

    mainMusic = love.audio.newSource('assets/sounds/background.mp3', 'stream')
    mainMusic:play()
    mainMusic:setVolume(0.4)
    soundsOn = true
    changeState(GameState.MAIN_MENU, false)
    timePassed = 0
    -- start()
end

function love.update(dt)
    timePassed = timePassed + dt
    if currState == GameState.GAME then
        if not gameScreen:update(dt) then
            changeState(GameState.GAME_OVER)
        end
    elseif prePaused == GameState.GAME_START then
        gameScreen:updateIdle(dt, timePassed)
    end
end

function love.draw()
    if currState == GameState.PAUSED then
        pauseMenu:draw()
    elseif currState == GameState.GAME_OVER then
        gameOverMenu:draw()
    elseif currState == GameState.MAIN_MENU then
        mainMenu:draw()
    elseif currState == GameState.GAME or currState == GameState.GAME_START then
        gameScreen:draw()
    end
end

function love.keypressed(key, scancode)
    local func
    if currState == GameState.GAME_START then
        if key == 'space' then
            changeState(GameState.GAME)
        end
    elseif currState == GameState.MAIN_MENU then
        func = mainMenu:keypressed(key, scancode)
        if func then
            func()
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
    mainMenu:revert()
    timePassed = 0
end

function quit()
    love.event.quit(0)
end

function toggleSound()
    if soundsOn then
        mainMusic:setVolume(0)
        if gameScreen then
            gameScreen.sounds:setVolume(0)
        end
        mainMenu.items[2]:changeImage('assets/images/menu/soundOffG.png', 'assets/images/menu/soundOffG-active.png')
        pauseMenu.items[2]:changeImage('assets/images/menu/soundOffR.png', 'assets/images/menu/soundOffR-active.png')
        soundsOn = false
    else
        if gameScreen then
            gameScreen.sounds:setVolume(0.7)
        end
        mainMusic:setVolume(0.1)
        mainMenu.items[2]:changeImage('assets/images/menu/soundOnG.png', 'assets/images/menu/soundOnG-active.png')
        pauseMenu.items[2]:changeImage('assets/images/menu/soundOnR.png', 'assets/images/menu/soundOnR-active.png')
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
    if currState == GameState.PAUSED or currState == GameState.GAME_OVER then
        gameScreen.sounds:setVolume(0.7)
        mainMusic:setVolume(0.1)
    elseif currState == GameState.GAME then
        gameScreen.sounds:setVolume(1)
        mainMusic:setVolume(0.4)
    end
end
