local node = {}

function node.new(x, y, polygon)
    local self = setmetatable({}, {__index = node})
    self.x = x
    self.y = y
    self.polygon = polygon
    self.connected_nodes = {}
    return self
end

function node:PointToSurfacePoint()
    return self.x + self.polygon.max - self.polygon.dx/2, (2* self.polygon.max) -  (self.y + self.polygon.max - self.polygon.dy / 2)
end

function node:connectNodes(nodes)
    for _, v in pairs(nodes) do
        table.insert(self.connected_nodes, v)
    end
end

function node:drawConnected(cr)
    cr:new_sub_path()
    cr:set_source_rgb(0, 0, 1)
    for _, v in pairs(self.connected_nodes) do
        cr:move_to(self:PointToSurfacePoint())
        cr:line_to(v:PointToSurfacePoint())
    end
    cr:close_path()
    cr:stroke()
end


return node