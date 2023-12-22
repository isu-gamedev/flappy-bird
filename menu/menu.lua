require 'menu.menu-item'

Menu = {}
Menu.__index = Menu

-- function Menu:create(title, items)
--     local menu = {}
--     setmetatable(menu, Menu)
--     menu.title = title
--     menu.betweenItems = 20
--     menu.items = items
--     menu.y = (height - menu:getHeight()) / 2
--     menu.x = (width - menu:getWidth()) / 2
--     menu.chosenItem = 1
--     menu.titleFont = love.graphics.newFont('fonts/MartianMono.ttf', 32)
--     menu.changeSound = love.audio.newSource('assets/sounds/change.mp3', 'static')
--     menu.changeSound:setVolume(0.3)
--     return menu
-- end

-- function Menu:drawMenu()
--     love.graphics.printf(self.title, self.titleFont, 0, 30, width, 'center')
--     self:drawItems()
-- end

-- function Menu:drawItems()
--     for n, i in ipairs(self.items) do
--         local added = (i.height + self.betweenItems) * (n - 1)
--         local chosen = n == self.chosenItem
--         i:draw(self.x, self.y + added, chosen)
--     end
-- end

-- function Menu:getHeight()
--     local menuHeight = 0
--     for n, i in ipairs(self.items) do
--         if n ~= 1 then
--             menuHeight = menuHeight + self.betweenItems
--         end
--         menuHeight = menuHeight + i.height
--     end
--     return menuHeight
-- end

-- function Menu:getWidth()
--     return self.items[1].width
-- end

-- function Menu:keypressed(key, scancode)
--     if key == 'up' then
--         if self.changeSound:isPlaying() then
--             self.changeSound:stop()
--         end
--         self.changeSound:play()
--         if self.chosenItem > 1 then
--             self.chosenItem = self.chosenItem - 1
--         end
--     elseif key == 'down' then
--         if self.changeSound:isPlaying() then
--             self.changeSound:stop()
--         end
--         self.changeSound:play()
--         if self.chosenItem < #self.items then
--             self.chosenItem = self.chosenItem + 1
--         end
--     elseif key == 'space' then
--         local chosenItem = self.items[self.chosenItem]
--         if chosenItem.sound:isPlaying() then
--             chosenItem.sound:stop()
--         end
--         chosenItem.sound:play()
--         return chosenItem.func
--     end
-- end

-- function Menu:revert()
--     self.chosenItem = 1
-- end

function Menu:create(background, items)
    local menu = {}
    setmetatable(menu, Menu)
    menu.scale = 1
    menu.sounds = {
        click = love.audio.newSource('assets/sounds/click.mp3', 'static'),
        change = love.audio.newSource('assets/sounds/change.mp3', 'static')
    }
    for k, s in pairs(menu.sounds) do
        s:setVolume(0.3)
    end

    menu.background = love.graphics.newImage(background)
    menu.items = items
    menu.chosenItem = 1
    return menu
end

function Menu:draw()
    love.graphics.draw(self.background, 0, 0, 0, scale, scale)
    for n, i in ipairs(self.items) do
        if n == self.chosenItem then
            i:draw(true)
        else
            i:draw(false)
        end
    end
end

function Menu:keypressed(key, scancode)
    if key == 'up' then
        if self.sounds.change:isPlaying() then
            self.sounds.change:stop()
        end
        self.sounds.change:play()
        if self.chosenItem > 1 then
            self.chosenItem = self.chosenItem - 1
        end
    elseif key == 'down' then
        if self.sounds.change:isPlaying() then
            self.sounds.change:stop()
        end
        self.sounds.change:play()
        if self.chosenItem < #self.items then
            self.chosenItem = self.chosenItem + 1
        end
    elseif key == 'space' then
        local chosenItem = self.items[self.chosenItem]
        if self.sounds.click:isPlaying() then
            self.sounds.click:stop()
        end
        self.sounds.click:play()
        return chosenItem:execute()
    end
end

function Menu:revert()
    self.chosenItem = 1
end
