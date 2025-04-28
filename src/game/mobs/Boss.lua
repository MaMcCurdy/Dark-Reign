local Class = require "libs.hump.class"
local Anim8 = require "libs.anim8"
local Timer = require "libs.hump.timer"
local Enemy = require "src.game.mobs.Enemy"
local Hbox = require "src.game.Hbox"

local Sounds = require "src.game.Sounds"
local Magic = require "src.game.mobs.Magic"
local idleSprite = love.graphics.newImage("graphics/mobs/boss/SpriteSheet/Bringer-of-Death-SpritSheet.png")
local idleGrid = Anim8.newGrid(140, 93, idleSprite:getWidth(), idleSprite:getHeight())
local idleAnim = Anim8.newAnimation(idleGrid('1-8',1),0.2)
local walkAnim = Anim8.newAnimation(idleGrid('1-8',2),0.2)
local hitAnim = Anim8.newAnimation(idleGrid('1-8',5),0.05)
local attackAnim = Anim8.newAnimation(idleGrid('1-8',3),0.15)
local attackAnim2 = Anim8.newAnimation(idleGrid('1-4',6),0.15)
local deathAnim = Anim8.newAnimation(idleGrid('1-8',5),0.125)

local Boss = Class{__includes = Enemy}
function Boss:init(type) Enemy:init() 
    self.name = "boss"
    self.type = type
    self.dir = "e" 
    self.state = "idle" 
    self.animations = {}
    self.sprites = {}
    self.hitboxes = {}
    self.hurtboxes = {}

    self.hp = 14
    self.damage = 1
    self.cooldown = false
    self:setAnimation("idle",idleSprite, idleAnim)
    self:setAnimation("walk",idleSprite, walkAnim)
    self:setAnimation("hit", idleSprite, hitAnim)
    self:setAnimation("attack", idleSprite, attackAnim)
    self:setAnimation("attack2", idleSprite, attackAnim2)
    self:setAnimation("dead", idleSprite, deathAnim)

    self:setHurtbox("idle",10,38,45,93-38)
    self:setHurtbox("walk",10,38,45,93-38)
    self:setHurtbox("hit",10,38,45,93-38)

    self:setHurtbox("attack",10,38,45,93-38)
    self:setHurtbox("attack2",10,38,45,93-38)

    self:setHitbox("idle",10,38,45,93-38)
    self:setHitbox("walk",10,38,45,93-38)
    self:setHitbox("hit",10,38,45,93-38)

    self:setHitbox("attack",10,0,120,93)
    self:setHitbox("attack2",10,38,45,93-38)

    Timer.every(5,function() self:changeState() end)
end

function Boss:changeState()
    if self.state == "idle" then
            self.state = "walk"
    elseif self.state == "walk" then
        self.state = "idle"
    end
end
    

function Boss:update(dt, stage)
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
    elseif self.state == "attack2" then
        if self.cooldown == false then 
            self.cooldown = true
            Timer.after(1, function() self:magicAttack(stage) end)
        else
            Timer.after(2, function() self.cooldown = false end)
        end
    end
    if not stage:bottomCollision(self,1,0) then 
        self.y = self.y + gravity*dt 
    end
    local w,h = self:getDimensions()
    Timer.update(dt) 
    self.animations[self.state]:update(dt)
end 
    
function Boss:hit(damage, direction)
    if self.invincible then return end

    self.invincible = true
    self.hp = self.hp - damage
    if self.hp <= 0 then
        self:die()
    else
        self.state = "hit"
        Timer.after(0.4, function() self:endHit(direction) end)
    end
    
    Sounds["mob_hurt"]:play()

    

    
    Timer.after(0.4, function() self.invincible = false end)

end

function Boss:endHit(direction)
    if self.dir == direction then
        self:changeDirection()
    end
    self:attack()
end

function Boss:attack()
    local rng = math.random(2)
    if math.ceil(rng)==1 then
        self.state = "attack2"
    else
        self.state = "attack"
    end
    Timer.after(1.49, function() self.state = "walk" end)
end

function Boss:magicAttack(stage)
    local magic = Magic("boss")

    magic:setCoord(stage.player.x, stage.player.y - (16*8))
    stage:addMob(magic)
    self.cooldown = true
end

function Boss:die()
    self.state = "dead"
    Timer.after(0.9, function() self.died = true end)
end

function Boss:draw()
    self.animations[self.state]:draw(self.sprites[self.state],math.floor(self.x), math.floor(self.y))
    if debugFlag then
        local w,h = self:getDimensions()
        love.graphics.rectangle("line",self.x,self.y,w,h) -- sprite
    
        if self:getHurtbox() then
            love.graphics.setColor(0,0,1) -- blue
            self:getHurtbox():draw()
        end
    
        if self:getHitbox() then
            love.graphics.setColor(1,0,0) -- red
            self:getHitbox():draw()
        end
        love.graphics.setColor(1,1,1) 
    end
        
end


return Boss