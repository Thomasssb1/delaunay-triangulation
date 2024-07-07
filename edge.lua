local edge = {}

function edge.new(node1, node2)
    local self = setmetatable({}, {__index = edge})
    self.node1 = node1
    self.node2 = node2
    return self
end

function edge:CompareTo(otherEdge)
    local node1, node2 = self.node1, self.node2
    local otherNode1, otherNode2 = otherEdge.node1, otherEdge.node2
    return (node1:CompareTo(otherNode1) and node2:CompareTo(otherNode2)) or (node1:CompareTo(otherNode2) and node2:CompareTo(otherNode1))
end

function edge:Intersects(otherEdge)
end

function edge:__tostring()
    return self.node1:__tostring().."-"..self.node2:__tostring()
end

return edge