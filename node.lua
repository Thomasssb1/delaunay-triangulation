local node = {}

function node.new(x, y)
    local self = setmetatable({}, {__index = node})
    self.x = x
    self.y = y
    return self
end

function node:CompareTo(other)
    return self.x == other.x and self.y == other.y
end

return node