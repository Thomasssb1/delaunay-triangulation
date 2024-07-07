local node = require 'node'
local edge = require 'edge'
local circumcircle = require 'circumcircle'
local triangle = {}

function triangle.new(node1, node2, node3)
    local self = setmetatable({}, {__index = triangle})

    self.node1 = node.new(node1.x, node1.y)
    self.node2 = node.new(node2.x, node2.y)
    self.node3 = node.new(node3.x, node3.y)
    
    self.edge1 = edge.new(self.node1, self.node2)
    self.edge2 = edge.new(self.node2, self.node3)
    self.edge3 = edge.new(self.node3, self.node1)
    return self
end

function triangle:GetConnectedNodes()
    return {self.node1, self.node2, self.node3}
end

function triangle:GetEdges()
    return {self.edge1, self.edge2, self.edge3}
end

function triangle:AddEdges(edgeBuffer)
    
end

function triangle:SharesNode(node)
    return node:CompareTo(self.node1) or node:CompareTo(self.node2) or node:CompareTo(self.node3)
end

function triangle:Draw(cr, polygon)
    cr:new_sub_path()
    cr:set_source_rgb(0, 0, 1)
    cr:move_to(polygon:PointToSurfacePoint(self.node1))
    cr:line_to(polygon:PointToSurfacePoint(self.node2)) 
    cr:line_to(polygon:PointToSurfacePoint(self.node3)) 
    cr:line_to(polygon:PointToSurfacePoint(self.node1)) 
    cr:close_path()
    cr:stroke()
end

function triangle:__tostring()
    return self.node1:__tostring().."-"..self.node2:__tostring().."-"..self.node3:__tostring()
end

return triangle