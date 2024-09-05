# Delaunay Triangulation
An algorithm to generate a set of vertices used to create a triangulation using circumcircles to determine whether or not to split the triangles. Using this algorithm, you can create a Voronoi diagram by connecting the centres of the circumcircles used to determine the triangles in this triangulation.

## Bowyer-Watson Algorithm
This implementation uses the Bowyer-Watson Algorithm, where:
1. Create the "super-triangle" which contains every point - add it to the list of circumcircles (empty)
2. Iterate through each point and check if the point is within each of the circumcircles - if so then remove that triangle because it is no longer valid
3. Iterate through each invalid triangle's points and add the edges of the triangle to a new list as long as the edge is not shared by other invalid triangles
4. Iterate through the new list to create new triangles from the current point and the edges stored in the list

Using the polygon:
```lua
local myPolygon = polygon.new({
    {x = 0, y = 0},
    {x = 0, y = 100},
    {x = 30, y = 45},
    {x = 50, y = 65},
    {x = 100, y = 100},
    {x = 100, y = 0},
    
})
```
produces the result:
<div>
  <img src="https://raw.githubusercontent.com/Thomasssb1/delaunay-triangulation/main/polygon.png"/ width=256 height=256>
</div>
Where the blue square contains the newly created triangulation and the red triangle is the super triangle.
