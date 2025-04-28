local Tileset = require "src.game.tiling.Tileset"

local imgTileset = love.graphics.newImage("graphics/tilesets/PixelPlatformerSet2v.1.1/main_lev_buildA2.png")




local BasicTileset = Tileset(imgTileset, 16)
BasicTileset:setNotSolid({125, 126, 357, 358, 359, 360, 361, 362, 2031, 2032, 2033, 2034, 2035, 2036, 2037, 2038, 2039, 2040, 2041, 2042, 295, 379, 292, 376, 361, 362, 362, 359, 360, 361, 362, 357, 358, 359, 360, 361, 362, 357, 358, 359, 360, 361, 362, 357, 358,  351, 352, 353, 354, 355, 356,})
BasicTileset:setHazard({125, 126, 295, 379, 292, 376})
return BasicTileset