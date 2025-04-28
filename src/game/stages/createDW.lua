local Stage = require "src.game.stages.Stage"
local BasicTileset = require "src.game.tiling.DemoTileset"
local Background = require "src.game.tiling.Background"
local Skeleton = require "src.game.mobs.Skeleton"


local Magic = require "src.game.mobs.Magic"
local Sounds = require "src.game.Sounds"
local Boss = require "src.game.mobs.Boss"

local function createDW()
    local stage = Stage(100,200,BasicTileset)
    local mapdata = require "src.game.maps.demomap"
    stage:readMapData(mapdata)


    local bg1 = Background("graphics/tilesets/PixelPlatformerSet2v.1.1/Background/background1.png")
    local bg2 = Background("graphics/tilesets/PixelPlatformerSet2v.1.1/Background/background2.png")
    local bg3 = Background("graphics/tilesets/PixelPlatformerSet2v.1.1/Background/background3.png")
    
    stage:addBackground(bg1)
    stage:addBackground(bg2)
    stage:addBackground(bg3)

    stage.initialPlayerX = 40*16
    stage.initialPlayerY = 61*16 

    local firstenemy = Skeleton()
    firstenemy:setCoord(43*16, 59*16)
    stage:addMob(firstenemy)

    local mob1 = Boss()
    mob1:setCoord(40*16, 75*16)
    mob1:changeDirection()
    stage:addMob(mob1)

    for k = 1, 5 do
        local skelly = Skeleton()
        skelly:setCoord((100+(k*5))*16, 75*16)
        stage:addMob(skelly)
    end


    for k = 1, 5 do
        local skelly = Skeleton()
        skelly:setCoord((85+(k*10))*16, 35*16)
        stage:addMob(skelly)
    end
    stage:setMusic(Sounds["music_demo"])

    return stage
end

return createDW