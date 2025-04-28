local Class = require "libs.hump.class"

local Tile = Class{}
function Tile:init(id, quad)
    self.id = id 
    self.quad = quad 
    self.rotation = 0 
    self.flipHor = 1 
    self.flipVer = 1
    self.solid = true 
    self.hidden = false 
    self.hazard = false
end

return Tile