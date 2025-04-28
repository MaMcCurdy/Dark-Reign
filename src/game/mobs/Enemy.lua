local Class = require "libs.hump.class"
local Hbox = require "src.game.Hbox"

local Enemy = Class{}
function Enemy:init()
    self.x = 0
    self.y = 0
    self.name = ""
    self.type = ""
    self.dir = "l" 
    self.state = "idle"
    self.invincible = false 
    self.animations = {} 
    self.sprites = {}
    
    self.hitboxes = nil 
    self.hurtboxes = nil 
    self.hp = 10 
    self.damage = 10 
    self.died = false
    self.score = 100 
    self.hostile = true
end

function Enemy:getDimensions()
    return self.animations[self.state]:getDimensions()
end

function Enemy:setAnimation(st,sprite,anim)
    self.animations[st] = anim
    self.sprites[st] = sprite
end

function Enemy:setCoord(x,y)
    self.x = x
    self.y = y
end

function Enemy:update(dt)
    self.animations[self.state]:update(dt)
end

function Enemy:draw()
    self.animations[self.state]:draw(self.sprites[self.state],
        math.floor(self.x), math.floor(self.y))
    
    if debugFlag then
        local w,h = self:getDimensions()
        love.graphics.rectangle("line",self.x,self.y,w,h) 
    
        if self:getHurtbox() then
            love.graphics.setColor(0,0,1) 
            self:getHurtbox():draw()
        end
    
        if self:getHitbox() then
            love.graphics.setColor(1,0,0)
            self:getHitbox():draw()
        end
        love.graphics.setColor(1,1,1) 
    end
        
end

function Enemy:changeDirection()
    if self.dir == "l" then
        self.dir = "r"
    else
        self.dir = "l"
    end

    for st,anim in pairs(self.animations) do
        anim:flipH()
    end
end

function Enemy:hit(damage)
    self.hp = self.hp - damage
end

function Enemy:getHbox(boxtype)
    if boxtype == "hit" then
        return self.hitboxes[self.state]
    else
        return self.hurtboxes[self.state]
    end
end

function Enemy:getHitbox()
    return self:getHbox("hit")
end

function Enemy:getHurtbox()
    return self:getHbox("hurt")
end

function Enemy:setHurtbox(state,ofx,ofy,width,height)
    self.hurtboxes[state] = Hbox(self,ofx,ofy,width,height)
end

function Enemy:setHitbox(state,ofx,ofy,width,height)
    self.hitboxes[state] = Hbox(self,ofx,ofy,width,height)
end


return Enemy