local polygon = require 'polygon'
local cairo = require 'oocairo'

local function draw(myPolygon)
    local img = cairo.image_surface_create("rgb24", myPolygon.max * 2, myPolygon.max * 2)
    local cr = cairo.context_create(img)
    cr:set_source_rgb(1, 1, 1)
    cr:paint()

    cr:set_source_rgb(0.5, 1, 1)
    myPolygon:DrawAllPoints(cr)
    local superTriangle = myPolygon:CalculateSuperTriangle()
    myPolygon:DrawSuperTriangle(cr, superTriangle)    

    myPolygon:addNodeConnections(cr, superTriangle)

    local err = img:write_to_png("polygon.png")
end

local myPolygon = polygon.new({
    {x = 0, y = 0},
    {x = 0, y = 100},
    {x = 100, y = 100},
    {x = 100, y = 0}
})
draw(myPolygon)