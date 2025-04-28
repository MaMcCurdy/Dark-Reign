local Class = require "libs.hump.class"
local Anim8 = require "libs.anim8"
local Timer = require "libs.hump.timer"
local Enemy = require "src.game.mobs.Enemy"
local Hbox = require "src.game.Hbox"

local Sounds = require "src.game.Sounds"

-- Idle Animation Resources
local idleSprite = love.graphics.newImage("graphics/mobs/Skeleton/Idle.png")
local idleGrid = Anim8.newGrid(150, 51, idleSprite:getWidth(), idleSprite:getHeight())
local idleAnim = Anim8.newAnimation(idleGrid('1-4',1),0.2)
-- Walk Animation Resources
local walkSprite = love.graphics.newImage("graphics/mobs/Skeleton/Walk.png")
local walkGrid = Anim8.newGrid(150, 51, walkSprite:getWidth(), walkSprite:getHeight())
local walkAnim = Anim8.newAnimation(walkGrid('1-4',1),0.2)
-- Hit Animation Resources
local hitSprite = love.graphics.newImage("graphics/mobs/Skeleton/Take Hit.png")
local hitGrid = Anim8.newGrid(150, 52, hitSprite:getWidth(), hitSprite:getHeight())
local hitAnim = Anim8.newAnimation(hitGrid('1-4',1),0.2)

local attackSprite = love.graphics.newImage("graphics/mobs/Skeleton/Attack.png")
local attackGrid = Anim8.newGrid(150, 57, attackSprite:getWidth(), attackSprite:getHeight())
local attackAnim = Anim8.newAnimation(attackGrid('1-6',1),0.15)
local attackAnim2 = Anim8.newAnimation(attackGrid('7-8',1),0.15)

local deathSprite = love.graphics.newImage("graphics/mobs/Skeleton/Death.png")
local deathGrid = Anim8.newGrid(150, 50, attackSprite:getWidth(), attackSprite:getHeight())
local deathAnim = Anim8.newAnimation(attackGrid('1-4',1),0.25)

local Skeleton = Class{__includes = Enemy}
function Skeleton:init(type) Enemy:init()
    self.name = "skeleton"
    self.type = type
    self.dir = "l" 
    self.state = "idle" 
    self.animations = {} 
    self.sprites = {} 
    self.hitboxes = {}
    self.hurtboxes = {}

    self.hp = 2
    self.damage = 1

    self:setAnimation("idle",idleSprite, idleAnim)
    self:setAnimation("walk",walkSprite, walkAnim)
    self:setAnimation("hit", hitSprite, hitAnim)
    self:setAnimation("attack", attackSprite, attackAnim)
    self:setAnimation("attack2", attackSprite, attackAnim2)
    self:setAnimation("dead", deathSprite, deathAnim)

    self:setHurtbox("idle",61,0,45,51)
    self:setHurtbox("walk",61,0,45,51)
    self:setHurtbox("hit",61,0,45,52)

    self:setHurtbox("attack",61,-5,42,57)
    self:setHurtbox("attack2",61,-5,42,57)

    self:setHitbox("idle",61,0,45,51)
    self:setHitbox("walk",61,0,45,51)
    self:setHitbox("hit",61,0,45,52)

    self:setHitbox("attack",61,-5,42,57)
    self:setHitbox("attack2",49,-5,42+49,57)

    Timer.every(5,function() self:changeState() end)
end

function Skeleton:changeState()
    if self.state == "idle" then
            self.state = "walk"
    elseif self.state == "walk" then
        self.state = "idle"
    end
end
    

function Skeleton:update(dt, stage)
    if self.state == "walk" then
        
        if self.dir == "l" then 
            if stage:leftCollision(self,0) then 
                self:changeDirection()
            else
                self.x = self.x-16*dt
            end
        else 
            if stage:rightCollision(self,0) then 
                self:changeDirection()
            else 
                self.x = self.x+16*dt
            end 
        end
    end 
    if not stage:bottomCollision(self,1,0) then 
        self.y = self.y + gravity*dt 
    end
    local w,h = self:getDimensions()
    Timer.update(dt) 
    self.animations[self.state]:update(dt)
end 
    
function Skeleton:hit(damage, direction)
    if self.invincible then return end

    self.invincible = true
    self.hp = self.hp - damage
    
    Sounds["mob_hurt"]:play()

    if self.hp <= 0 then
        self.died = true
    else
        self.state = "hit"
        Timer.after(1, function() self:endHit(direction) end)
    end

    
    Timer.after(0.9, function() self.invincible = false end)

end

function Skeleton:endHit(direction)
    if self.dir == direction then
        self:changeDirection()
    end
    self.state = "attack"
    Timer.after(0.9, function() self.state = "attack2" end)
    Timer.after(1.25, function() self.state = "walk" end)
end

function Skeleton:die()
    self.state = "dead"
    Timer.after(0.9, function() self.died = true end)
end

function Skeleton:draw()
    if self.state ~= "attack" and self.state ~= "attack2" then
        self.animations[self.state]:draw(self.sprites[self.state],math.floor(self.x), math.floor(self.y))
    else
        self.animations[self.state]:draw(self.sprites[self.state],math.floor(self.x), math.floor(self.y-5))
    end
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

return Skeleton