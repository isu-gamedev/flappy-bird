require 'game.vector'

Camera = {}
Camera.__index = Camera

function Camera:create(object, fixedLocation)
    local camera = {}
    setmetatable(camera, Camera)
    camera.object = object
    camera.fixedLocation = fixedLocation or Vector:create(width / 2 - object.width / 2, height / 2 - object.height / 2)
    return camera
end

function Camera:getOffset()
    return self.fixedLocation - self.object.location
end

function Camera:notVisible(object)
    return object.location.x + object.width + self.fixedLocation.x < self.object.location.x - self.object.width
end
