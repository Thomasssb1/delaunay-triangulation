local node = require 'node'
local polygon = {}

function polygon.new(nodes)
    local self = setmetatable({}, {__index = polygon})
    self.nodes = {}
    for _, v in ipairs(nodes) do
        local newNode = node.new(v.x, v.y, self)
        table.insert(self.nodes, newNode)
    end
    self.dx, self.dy = self:GetMaxPoints()
    -- radius of the circle
    self.max = self.dx >= self.dy and 1.5 * self.dx or 1.5 * self.dy
    return self
end

function polygon:addNodeConnections(cr, initialNodes)
    local nodesToAdd = initialNodes
    for _, v in pairs(self.nodes) do
      v:connectNodes(nodesToAdd)
      v:drawConnected(cr)
      table.insert(nodesToAdd, v)
    end
end

function polygon:GetNodeCount()
    return #self.nodes
end

function polygon:DrawPoint(cr, index)
    local point = self.nodes[index]
    local x, y = point:PointToSurfacePoint()
    cr:arc(x , y, 2, 0, 2 * math.pi)
end

function polygon:DrawAllPoints(cr)
    cr:new_sub_path()
    cr:set_source_rgb(0, 0, 0)
    for i = 1, self:GetNodeCount() do
        self:DrawPoint(cr, i)
    end
    cr:close_path()
    cr:stroke()
end

function polygon:GetMaxPoints()
    local minX, maxX = math.huge, -math.huge
    local minY, maxY = math.huge, -math.huge

    for _, v in ipairs(self.nodes) do
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
        node.new(-self.max + self.dx/2, self.minY, self),
        node.new(self.max + self.dx/2, self.minY, self),
        node.new(self.dx/2, self.max, self)
    }
end

function polygon:DrawSuperTriangle(cr, superTriangle)
    local yOffset = self.max - self.dy/2

    cr:set_source_rgb(0, 0, 0)
    cr:arc(self.max, self.maxY + yOffset, self.max, 0, 2 * math.pi)
    cr:stroke()
    
    cr:new_sub_path()
    cr:set_source_rgb(1, 0, 0)
    cr:move_to(superTriangle[1]:PointToSurfacePoint())
    cr:line_to(superTriangle[2]:PointToSurfacePoint())
    cr:line_to(superTriangle[3]:PointToSurfacePoint())
    cr:close_path()
    cr:stroke()
end

return polygon