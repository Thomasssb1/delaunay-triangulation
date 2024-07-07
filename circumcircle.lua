local node = require 'node'
local circumcircle = {}

function circumcircle.new(x, y, radius)
    local self = setmetatable({}, {__index = circumcircle})
    self.x = x
    self.y = y
    self.radius = radius
    return self
end

function circumcircle.fromTriangle(triangle)
    local self = setmetatable({}, {__index = circumcircle})
    local line1 = self:CalculatePerpendicularBisector(triangle.edge2)
    local line2 = self:CalculatePerpendicularBisector(triangle.edge3)
    local x, y, radius = self:CalculateCircleFromBisector(line1, line2, triangle.node1)
    return circumcircle.new(x, y, radius)
end

function circumcircle:IntersectsCircle(circle)
    local c1c2 = math.sqrt((self.x - circle.x)^2 + (self.y - circle.y)^2)
    if c1c2 <= self.radius - circle.radius or c1c2 <= circle.radius - self.radius or c1c2 <= self.radius + circle.radius then
        return true
    else
        return false
    end
end

function circumcircle:ContainsNode(node)
    local newRadius = math.sqrt((node.x - self.x)^2 + (node.y - self.y)^2)
    return newRadius <= self.radius
end

function circumcircle:CalculateCircleFromBisector(line, otherLine, node)
    local totalCoefficientX = otherLine.m - line.m
    local totalConstant = (-line.m * line.x) + line.y - otherLine.y + (otherLine.m * otherLine.x)
    local x = totalConstant / totalCoefficientX
    local y = (line.m * x) - (line.m * line.x) + line.y

    local radius = math.sqrt((node.x - x)^ 2 + (node.y - y)^2)

    return x, y, radius
end

function circumcircle:CalculatePerpendicularBisector(edge)
    local node1, node2 = edge.node1, edge.node2

    local x = (node1.x + node2.x) / 2
    local y = (node1.y + node2.y) / 2
    local m = -1 / ((node2.y - node1.y) / (node2.x - node1.x))
    return {x=x, y=y, m=m}
end

function circumcircle:Draw(cr, polygon)
    local node = node.new(self.x, self.y)
    local x,y = polygon:PointToSurfacePoint(node)
    cr:arc(x, y, self.radius, 0, 2 * math.pi)
    cr:stroke()
end

return circumcircle