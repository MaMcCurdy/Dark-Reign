local Class = require "libs.hump.class"
local hudFont = love.graphics.newFont("fonts/Abaddon Bold.ttf",16)

local HUD = Class{}
function HUD:init(player)
    self.player = player
end

function HUD:update(dt) 
 
end

function HUD:drawHpBar()
    love.graphics.setColor(0.6,0,0) 
    local stx = 5
    for k = 1, player.hp do
        love.graphics.rectangle("fill",stx,gameHeight-50,30,14) 
        
        stx = stx + 50
    end
    love.graphics.setColor(0,0,0.7)
    stx = 5
    for k = 1, player.mana do

        love.graphics.rectangle("fill",stx,gameHeight-25,30,14) 
        stx = stx + 50
    end
    love.graphics.setColor(1,1,1)
end

function HUD:draw()
    love.graphics.print("Lives: "..self.player.lives, hudFont, 5, 1)
    self:drawHpBar()
end

return HUD