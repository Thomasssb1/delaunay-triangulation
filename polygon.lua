local node = require 'node'
local triangle = require 'triangle'
local circumcircle = require 'circumcircle'
local polygon = {}

function polygon.new(nodes)
    local self = setmetatable({}, {__index = polygon})
    self.triangles = {}
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

function polygon:PointToSurfacePoint(node)
    return node.x + self.max - self.dx/2, (2* self.max) -  (node.y + self.max - self.dy / 2)
end

function polygon:Triangulate(superTriangle)
    -- initialise and add supertriangle to lists
    local vertices = self.nodes
    for _, v in ipairs(superTriangle:GetConnectedNodes()) do
        table.insert(vertices, v)
    end
    table.insert(self.triangles, superTriangle)

    for _, v in ipairs(vertices) do
        local edgeBuffer = {}
        local badTriangles = {}
        for i = #self.triangles, 1, - 1 do
            local tri = self.triangles[i]
            local circle = circumcircle.fromTriangle(tri)

            if circle:ContainsNode(v) then
                table.insert(badTriangles, i)
            end
        end

        for _, i1 in ipairs(badTriangles) do
            local tri1 = self.triangles[i1]
            local edges1 = tri1:GetEdges()
            for j1 = 1, 3 do
                for _, i2 in ipairs(badTriangles) do
                    if i1 == i2 then goto continue end
                    local tri2 = self.triangles[i2]
                    local edges2 = tri2:GetEdges()
                    for j2 = 1, 3 do
                        if edges1[j1]:CompareTo(edges2[j2]) then
                            goto ignore
                        end
                    end
                    ::continue::
                end
                table.insert(edgeBuffer, edges1[j1])
                ::ignore::
            end
        end

        for _, tri in pairs(badTriangles) do
            table.remove(self.triangles, tri)
        end

        for _, edge in ipairs(edgeBuffer) do
            local newTriangle = triangle.new(edge.node1, edge.node2, v)
            table.insert(self.triangles, newTriangle)
        end
    end
    
    for i = #self.triangles, 1, -1 do
        local nodes = self.triangles[i]:GetConnectedNodes()
        for j = 1, 3 do 
            local current = nodes[j]
            if superTriangle:SharesNode(current) then
                table.remove(self.triangles, i)
            end
        end
    end
    print(#self.triangles)
end


function polygon:GetNodeCount()
    return #self.nodes
end

function polygon:DrawPoint(cr, index)
    local point = self.nodes[index]
    local x, y = self:PointToSurfacePoint(point)
    cr:arc(x , y, 2, 0, 2 * math.pi)
end

function polygon:DrawAllPoints(cr)
    cr:set_source_rgb(0, 0, 0)
    for i = 1, self:GetNodeCount() do
        cr:new_sub_path()
        self:DrawPoint(cr, i)
        cr:close_path()
    end
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
    local TOLERANCE = 30
    return triangle.new(
        {x = -self.max + self.dx/2 - TOLERANCE, y = self.minY - TOLERANCE},
        {x = self.max + self.dx/2 + TOLERANCE, y = self.minY - TOLERANCE},
        {x = self.dx/2, y = self.max + TOLERANCE}
    )
end

function polygon:DrawSuperTriangle(cr, superTriangle)
    local yOffset = self.max - self.dy/2

    cr:set_source_rgb(0, 0, 0)
    cr:arc(self.max, self.maxY + yOffset, self.max, 0, 2 * math.pi)
    cr:stroke()
    
    cr:new_sub_path()
    cr:set_source_rgb(1, 0, 0)
    cr:move_to(self:PointToSurfacePoint(superTriangle.node1))
    cr:line_to(self:PointToSurfacePoint(superTriangle.node2))
    cr:line_to(self:PointToSurfacePoint(superTriangle.node3))
    cr:close_path()
    cr:stroke()
end

return polygon