local polygon = require 'polygon'
local circumcircle = require 'circumcircle'
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
--draw(myPolygon)

local triangle = polygon.new({
    {x = 4, y = 16},
    {x = 12, y = 32},
    {x = 100, y = 0}
})

local circumcircle = circumcircle.fromThreePoints(triangle.nodes[1], triangle.nodes[2], triangle.nodes[3])

local img = cairo.image_surface_create("rgb24", myPolygon.max * 2, myPolygon.max * 2)
local cr = cairo.context_create(img)
cr:set_source_rgb(1, 1, 1)
cr:paint()

cr:set_source_rgb(1, 0, 0)
triangle:DrawCircumcircle(cr, circumcircle)

cr:set_source_rgb(0.5, 1, 1)
triangle:DrawAllPoints(cr)
local err = img:write_to_png("triangle.png")

