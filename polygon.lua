local node = require 'node'
local polygon = {}

function polygon.new(points)
    local self = setmetatable({}, {__index = polygon})
    self.points = points
    self.dx, self.dy = self:GetMaxPoints()
    -- radius of the circle
    self.max = self.dx >= self.dy and 1.5 * self.dx or 1.5 * self.dy
    return self
end

function polygon:PointToSurfacePoint(point)
    return point.x + self.max - self.dx/2, (2* self.max) -  (point.y + self.max - self.dy / 2)
end

function polygon:GetPointCount()
    return #self.points
end

function polygon:DrawPoint(cr, index)
    local point = self.points[index]
    local x, y = self:PointToSurfacePoint(point)
    cr:arc(x , y, 2, 0, 2 * math.pi)
end

function polygon:DrawAllPoints(cr)
    cr:new_sub_path()
    cr:set_source_rgb(0, 0, 0)
    for i = 1, self:GetPointCount() do
        self:DrawPoint(cr, i)
    end
    cr:close_path()
    cr:stroke()
end

function polygon:GetMaxPoints()
    local minX, maxX = math.huge, -math.huge
    local minY, maxY = math.huge, -math.huge

    for i, v in ipairs(self.points) do
        if v.x < minX then
            minX = v.x
        end
        if v.x > maxX then
            maxX = v.x
        end
        if v.y < minY then
            minY = v.y
        end
        if v.y > maxY then
            maxY = v.y
        end
    end

    self.minX, self.maxX = minX, maxX
    self.minY, self.maxY = minY, maxY

    local dx = maxX - minX
    local dy = maxY - minY
    return dx, dy
end

function polygon:CalculateSuperTriangle()
    return {
        node.new(-self.max + self.dx/2, self.minY),
        node.new(self.max + self.dx/2, self.minY),
        node.new(self.dx/2, self.max)
    }
end

function polygon:DrawSuperTriangle(cr)
    local superTriangle = self:CalculateSuperTriangle()
    print(superTriangle)
    local yOffset = self.max - self.dy/2

    cr:set_source_rgb(0, 0, 0)
    cr:arc(self.max, self.maxY + yOffset, self.max, 0, 2 * math.pi)
    cr:stroke()
    
    cr:new_sub_path()
    cr:set_source_rgb(1, 0, 0)
    cr:move_to(self:PointToSurfacePoint(superTriangle[1]))
    cr:line_to(self:PointToSurfacePoint(superTriangle[2]))
    cr:line_to(self:PointToSurfacePoint(superTriangle[3]))
    cr:close_path()
    cr:stroke()
end

return polygon