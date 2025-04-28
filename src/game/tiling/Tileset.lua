local Class = require "libs.hump.class"
local Tile = require "src.game.tiling.Tile"

local Tileset = Class{}
function Tileset:init(img, tilesize)
    self.tileImage = img 
    self.tileSize = tilesize 
    
    self.rowCount = self.tileImage:getHeight() / self.tileSize
    self.colCount = self.tileImage:getWidth() / self.tileSize
    
    self.tiles = {}
    self:createTiles()
end

function Tileset:createTiles() 
    local index = 1
    for row = 1, self.rowCount do
        for col = 1, self.colCount do
            self.tiles[index] = self:newTile(row,col,index)  
            index = index + 1 
        end 
    end 
end

function Tileset:newTile(row,col, index)
    local q = love.graphics.newQuad(
        (col-1)*self.tileSize, 
        (row-1)*self.tileSize, 
        self.tileSize,self.tileSize,self.tileImage)
    return Tile(index, q)
end

function Tileset:get(index)
    return self.tiles[index]
end

function Tileset:getImage()
    return self.tileImage
end

function Tileset:setNotSolid(tilelist) 
    for i,tid in pairs(tilelist) do
        if self.tiles[tid] then 
            self.tiles[tid].solid = false 
        end
    end 
end

function Tileset:setHazard(tilelist) 
    for i,tid in pairs(tilelist) do
        if self.tiles[tid] then 
            self.tiles[tid].hazard = true 
        end
    end 
end


return Tileset