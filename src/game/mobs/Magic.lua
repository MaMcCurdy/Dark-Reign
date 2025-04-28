local Class = require "libs.hump.class"
local Anim8 = require "libs.anim8"
local Projectile = require "src.game.mobs.Projectile"
local Hbox = require "src.game.Hbox"
local Sounds = require "src.game.Sounds"

local Flare = require "src.game.Flare"
local imgParticle = love.graphics.newImage("graphics/particles/20.png")
local movingSprite = love.graphics.newImage("graphics/mobs/magic/magic.png")
local movingGrid = Anim8.newGrid(51, 51, movingSprite:getWidth(), movingSprite:getHeight())
local movingAnim = Anim8.newAnimation(movingGrid('1-2',1),0.1)

local hitSprite = love.graphics.newImage("graphics/mobs/magic/burst.png")
local hitGrid = Anim8.newGrid(51, 51, movingSprite:getWidth(), movingSprite:getHeight())
local hitAnim = Anim8.newAnimation(hitGrid('1-2',1),0.1)

local Magic = Class{__includes = Projectile}
function Magic:init(type, direction) Projectile:init() 
    self.name = "magic"
    self.type = type
    self.dir = direction or "l"
    self.state = "moving" 
    self.animations = {} 
    self.sprites = {} 
    self.hitboxes = {}
    self.damage = 2
    self.speedX = 300   
    self.speedY = 0
    self.r = 1
    self.g = 0.5
    self.b = 0

    
    if type == "boss" then
        self.speedX = 0
        self.speedY = 300
        self.r = 1
        self.g = 0
        self.b = 1
    end

    self:setAnimation("moving",movingSprite, movingAnim, false)
    self:setAnimation("hit",hitSprite, hitAnim, true)

    self:setHitbox("moving",10,10,34,22)

    self.flare = Flare()
    self.flare:setColor(self.r, self.g, self.b)
    
end

function Magic:draw()
    self.animations[self.state]:draw(self.sprites[self.state],
        math.floor(self.x), math.floor(self.y), 0, self.sizeX, self.sizeY)
    
    self.flare:draw()

    if debugFlag then
        local w,h = self:getDimensions()
        love.graphics.rectangle("line",self.x,self.y,w,h) 
    
        if self:getHitbox() then
            love.graphics.setColor(1,0,0)
            self:getHitbox():draw()
        end
        love.graphics.setColor(1,1,1) 
    end
end

function Magic:update(dt, stage)
    if self.state == "moving" then
        if self.dir == "l" then 
            if stage:leftCollision(self,0) then 
                self:hit()
            else 
                self.x = self.x-self.speedX*dt
            end
        else 
            if stage:rightCollision(self,0) then
                self:hit()
            else 
                self.x = self.x+self.speedX*dt
            end 
        end 
        self.y = self.y+self.speedY*dt
        if stage:checkMobsHboxCollision(self.hitboxes[self.state], "hit") and stage:checkMobsHboxCollision(self.hitboxes[self.state], "hit") ~= self then
            local enemy = stage:checkMobsHboxCollision(self:getHitbox(), "hit")
            enemy:hit(self.damage, self.dir)
            self:hit()
        end
    end
    self.animations[self.state]:update(dt)
    self.flare:update(dt)
end 

function Magic:hit(damage, direction)
    local w,h = self:getDimensions()
    self.state = "hit"

    self.flare:trigger(self.x + (w/2), self.y + (h/2))
    Sounds["mob_hurt"]:play()
end

return Magic