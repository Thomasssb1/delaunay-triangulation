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
    if (node1 == otherNode1 and node2 == otherNode2) or (node1 == otherNode2 and node2 == otherNode1) then
        return true
    end
    return false
end

function edge:__tostring()
    return self.node1:__tostring().."-"..self.node2:__tostring()
end

return edge