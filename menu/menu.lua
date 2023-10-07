require "menu.menu-item"

Menu = {}
Menu.__index = Menu

function Menu:create(items)
    local menu = {}
    setmetatable(menu, Menu)
    menu.betweenItems = 20
    menu.items = items
    menu.y = (height - menu:getHeight()) / 2
    menu.x = (width - menu:getWidth()) / 2
    menu.chosenItem = 1
    return menu
end

function Menu:drawItems()
    for n, i in ipairs(self.items) do
        local added = (i.height + self.betweenItems )* (n - 1)
        local chosen = n == self.chosenItem
        i:draw(self.x, self.y + added, chosen)
    end
end

function Menu:getHeight()
    local menuHeight = 0
    for n, i in ipairs(self.items) do
        if n ~= 1 then
            menuHeight = menuHeight + self.betweenItems
        end
        menuHeight = menuHeight + i.height
    end
    return menuHeight
end

function Menu:getWidth()
    return self.items[1].width
end

function Menu:keypressed(key, scancode)
    if key == "up" then
        if self.chosenItem > 1 then
            self.chosenItem = self.chosenItem - 1            
        end
    elseif key == "down" then
        if self.chosenItem < #self.items then
            self.chosenItem = self.chosenItem + 1         
        end
    elseif key == "return" then
        return self.items[self.chosenItem].func
    end
end

function Menu:revert()
    self.chosenItem = 1
end