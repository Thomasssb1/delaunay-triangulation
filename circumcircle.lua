local node = require "node"
local circumcircle = {}

function circumcircle.new(x, y, radius)
    local self = setmetatable({}, {__index = circumcircle})
    self.x = x
    self.y = y
    self.radius = radius
    return self
end

function circumcircle.fromThreePoints(node1, node2, node3)
    local self = setmetatable({}, {__index = circumcircle})
    local line1 = self:CalculatePerpendicularBisector(node1, node2)
    local line2 = self:CalculatePerpendicularBisector(node2, node3)
    local x, y, radius = self:CalculateCircleFromBisector(line1, line2, node1)
    return circumcircle.new(x, y, radius)
end

function circumcircle:CalculateCircleFromBisector(line, otherLine, node)
    local totalCoefficientX = otherLine.m - line.m
    local totalConstant = (-line.m * line.x) + line.y - otherLine.y + (otherLine.m * otherLine.x)
    local x = totalConstant / totalCoefficientX
    local y = (line.m * x) - (line.m * line.x) + line.y

    local radius = math.sqrt((node.x - x)^ 2 + (node.y - y)^2)

    return x, y, radius
end

function circumcircle:CalculatePerpendicularBisector(node1, node2)
    local x = (node1.x + node2.x) / 2
    local y = (node1.y + node2.y) / 2
    local m = -1 / ((node2.y - node1.y) / (node2.x - node1.x))
    return {x=x, y=y, m=m}
end

return circumcircle