require "vector"

function rectCircleCollision(rect, circle)
    local distance = {}
    distance.x = math.abs(circle.location.x - (rect.location.x + rect.width / 2));
    distance.y = math.abs(circle.location.y - (rect.location.y + rect.height / 2));
    if distance.x > (rect.width / 2 + circle.size ) then
        return false
    end
    if distance.y > (rect.height / 2 + circle.size) then
        return false
    end

    if distance.x <= (rect.width / 2) then
        return true
    end
    if distance.y <= (rect.height / 2) then
        return true
    end
    local cDist_sq = (distance.x - rect.width / 2) ^ 2 + (distance.y - rect.height / 2) ^ 2;
    return cDist_sq <= (circle.size ^ 2)
end