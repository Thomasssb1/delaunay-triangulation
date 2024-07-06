package = "delaunay-triangulation"
version = "dev-1"
source = {
   url = "git+https://github.com/Thomasssb1/delaunay-triangulation.git"
}
description = {
   homepage = "https://github.com/Thomasssb1/delaunay-triangulation",
   license = "*** please specify a license ***"
}
dependencies = {
   "oocairo >= 1.5-1"
}
build = {
   type = "builtin",
   modules = {
      main = "main.lua",
      polygon = "polygon.lua"
   }
}
