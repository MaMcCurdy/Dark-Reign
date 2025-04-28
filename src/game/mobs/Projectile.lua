local Class = require "libs.hump.class"
local Hbox = require "src.game.Hbox"

local Projectile = Class{}
function Projectile:init()
    self.x = 0
    self.y = 0
    self.sizeX = nil
    self.sizeY = nil
    self.name = ""
    self.type = ""
    self.dir = "l" -- Direction r = right, l = left
    self.state = "moving"
    self.animations = {} -- dict of animations (each mob will have its own)
    self.sprites = {} -- dict of sprites (for animations)
    -- Attributes
    self.hitboxes = nil -- for later
    self.damage = 1 -- mob's damage
    self.died = false
    self.speedX = 300
    self.speedY = 0
    self.angle = 0
    self.hostile = false
end

function Projectile:getDimensions() -- returns current Width,Height
    return self.animations[self.state]:getDimensions()
end

function Projectile:setAnimation(st,sprite,anim, hit)
    if hit then
        self.animations[st] = anim
        self.animations[st].onLoop = function() self.died = true end
        self.sprites[st] = sprite
    else
    self.animations[st] = anim
    self.sprites[st] = sprite
    end
end


function Projectile:impact()
    self = nil
end


function Projectile:setCoord(x,y)
    self.x = x
    self.y = y
end

function Projectile:update(dt)
    self.animations[self.state]:update(dt)
end

function Projectile:draw()
    self.animations[self.state]:draw(self.sprites[self.state],
        math.floor(self.x), math.floor(self.y), 0, self.sizeX, self.sizeY)
    
    if debugFlag then
        local w,h = self:getDimensions()
        love.graphics.rectangle("line",self.x,self.y,w,h) -- sprite
    
        if self:getHitbox() then
            love.graphics.setColor(1,0,0) -- red
            self:getHitbox():draw()
        end
        love.graphics.setColor(1,1,1) 
        if self.particleSystem ~= nil then
            love.graphics.draw(self.particleSystem, x, y)
        end
    end
        
end

function Projectile:changeDirection()
    if self.dir == "l" then
        self.dir = "r"
    else
        self.dir = "l"
    end

    for st,anim in pairs(self.animations) do
        anim:flipH()
    end
end 


function Projectile:hit()
    self.state = "hit"
end

function Projectile:setAngle(angle)
    self.speedY = angle
end

function Projectile:getHbox(boxtype)
    if boxtype == "hit" then
        return self.hitboxes[self.state]
    end
end

function Projectile:getHitbox()
    return self:getHbox("hit")
end

function Projectile:setHitbox(state,ofx,ofy,width,height)
    self.hitboxes[state] = Hbox(self,ofx,ofy,width,height)
end

return Projectile