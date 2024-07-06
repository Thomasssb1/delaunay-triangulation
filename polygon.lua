local polygon = {}

function polygon.new(points)
    local self = setmetatable({}, {__index = polygon})
    self.points = points
    self.dx, self.dy = self:GetMaxPoints()
    self.max = self.dx >= self.dy and 1.5 * self.dx or 1.5 * self.dy
    return self
end

function polygon:GetPointCount()
    return #self.points
end

function polygon:GetMaximumY()
    local maxY = -math.huge
    for _, v in pairs(self.points) do
        if v.y > maxY then
            maxY = v.y
        end
    end
    return maxY
end

function polygon:DrawPoint(cr, index)
    local point = self.points[index]
    local xOffset, yOffset = self.max - self.dx/2, self.max - self.dy/2
    cr:arc(point.x + xOffset, point.y + yOffset, 2, 0, 2 * math.pi)
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

    local dx = maxX - minX
    local dy = maxY - minY
    return dx, dy
end

function polygon:DrawSuperTriangle(cr)
    local yOffset = self.max - self.dy/2

    local maxY = self:GetMaximumY()
        
    cr:set_source_rgb(0, 0, 0)
    cr:arc(self.max, maxY + yOffset, self.max, 0, 2 * math.pi)
    cr:stroke()

    
    cr:new_sub_path()
    cr:set_source_rgb(1, 0, 0)
    cr:move_to(0, maxY + yOffset)
    cr:line_to(self.max * 2, maxY + yOffset)
    cr:line_to(self.max, maxY + yOffset - self.max)
    cr:line_to(0, maxY + yOffset)
    cr:close_path()
    cr:stroke()

    return radius
end

return polygon