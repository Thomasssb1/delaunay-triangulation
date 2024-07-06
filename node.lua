local node = {}

function node.new(x, y)
    local self = setmetatable({}, {__index = node})
    self.x = x
    self.y = y
    self.connected_nodes = {}
    return self
end

return node