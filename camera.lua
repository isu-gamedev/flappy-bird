require "vector"

Camera = {}
Camera.__index = Camera

function Camera:create(location, fixedLocation)
    local camera = {}
    setmetatable(camera, Camera)
    camera.location = location
    camera.fixedLocation = fixedLocation or Vector:create(width / 2, height / 2)
    return camera
end

function Camera:getOffset()
    return self.fixedLocation - self.location
end
