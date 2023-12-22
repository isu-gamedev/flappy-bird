require 'game.vector'

function rectCircleCollision(rect, circle)
    local distance = {}
    distance.x = math.abs(circle.location.x - (rect.location.x + rect.width / 2));
    distance.y = math.abs(circle.location.y - (rect.location.y + rect.height / 2));
    if distance.x > (rect.width / 2 + circle.size) then
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

function rectsCollision(rect1, rect2)
    -- if (RectA.X1 < RectB.X2 && RectA.X2 > RectB.X1 &&
    -- RectA.Y1 < RectB.Y2 && RectA.Y2 > RectB.Y1)     
    local rightSide = rect1.location.x + rect1.width - rect1.collisionOffset.x > rect2.location.x
    local leftSide = rect1.location.x + rect1.collisionOffset.x < rect2.location.x + rect2.width
    local upSide = rect1.location.y + rect1.collisionOffset.y < rect2.location.y + rect2.height
    local downSide = rect1.location.y + rect1.height - rect1.collisionOffset.y > rect2.location.y
    if ((rightSide and leftSide) and (upSide and downSide)) then
        return true
    end
    return false
end
