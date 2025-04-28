local Class = require "libs.hump.class"
local Anim8 = require "libs.anim8"
local Tween = require "libs.tween"
local Hbox = require "src.game.Hbox"
local Sounds = require "src.game.Sounds"

local Magic = require "src.game.mobs.Magic"

local idleSprite = love.graphics.newImage("graphics/char/IDLE2.png")
local idleGrid = Anim8.newGrid(95,32,idleSprite:getWidth(),idleSprite:getHeight())
local idleAnim = Anim8.newAnimation( idleGrid('1-1',1), 0.3)

local runSprite = love.graphics.newImage("graphics/char/RUN2.png")
local runGrid = Anim8.newGrid(96,35,runSprite:getWidth(),runSprite:getHeight())
local runAnim = Anim8.newAnimation( runGrid('1-8',1), 0.1)

local jumpSprite = love.graphics.newImage("graphics/char/JUMP2.png")
local jumpGrid = Anim8.newGrid(95,35,jumpSprite:getWidth(),jumpSprite:getHeight())
local jumpAnim = Anim8.newAnimation( jumpGrid('1-5',1), 0.1)

local attackSprite = love.graphics.newImage("graphics/char/BIGATTACK2.png")
local attackGrid = Anim8.newGrid(96, 34, attackSprite:getWidth(), attackSprite:getHeight())
local attack1Anim = Anim8.newAnimation(attackGrid('3-6',1),0.15)
local attack2Anim = Anim8.newAnimation(attackGrid('5-10',1),0.15)

local hitSprite = love.graphics.newImage("graphics/char/HURT2.png")
local hitGrid = Anim8.newGrid(95, 34, hitSprite:getWidth(), hitSprite:getHeight())
local hitAnim = Anim8.newAnimation(hitGrid('1-4',1),0.3)

local dieSprite = love.graphics.newImage("graphics/char/DEATH2.png")
local dieGrid = Anim8.newGrid(96, 32, dieSprite:getWidth(), dieSprite:getHeight())
local dieAnim = Anim8.newAnimation(dieGrid('1-12',1),0.05)

local shootSprite = love.graphics.newImage("graphics/char/DEFEND2.png")
local shootGrid = Anim8.newGrid(96, 34, shootSprite:getWidth(), shootSprite:getHeight())
local shootAnim = Anim8.newAnimation(shootGrid('3-6',1),0.1)

local chargeSprite = love.graphics.newImage("graphics/char/DEFEND2.png")
local chargeGrid = Anim8.newGrid(96, 34, chargeSprite:getWidth(), chargeSprite:getHeight())
local chargeAnim = Anim8.newAnimation(chargeGrid('2-2',1),0.01)

local Player = Class{}
function Player:init(x,y)
    self.x = x
    self.y = y
    self.name = "char"
    self.hitboxes = {}
    self.hurtboxes = {}

    self.state = "idle"
    self.dir = "r" 
    self.speedY = 0
    self.ground = true

    self.animations = {}
    self.sprites = {}
    self:createAnimations()

    self.lives = 3
    self.hp = 3
    self.maxHP = 3
    self.mana = 3
    self.maxMP = 3
    self.coins = 0
    self.gems = 0
    self.damage = 1
end

function Player:nextStage(stage)
    self.x = stage.initialPlayerX
    self.y = stage.initialPlayerY
    
    self.crystals = 0 
    self.hp = math.min(100, self.hp+10)
end

function Player:reset()
    self:setDirection("r") 
    self.state = "idle" 
    self.lives = 3
    self.hp = self.maxHP 
    self.mana = self.maxMP
end

function Player:createAnimations() 
    self.animations["idle"] = idleAnim
    self.sprites["idle"] = idleSprite

    self.animations["run"] = runAnim
    self.sprites["run"] = runSprite

    self.animations["jump"] = jumpAnim
    self.sprites["jump"] = jumpSprite

    self.animations["attack1"] = attack1Anim
    self.animations["attack1"].onLoop = function() self:finishAttack() end
    self.sprites["attack1"] = attackSprite

    self.animations["attack2"] = attack2Anim
    self.animations["attack2"].onLoop = function() self:finishAttack() end
    self.sprites["attack2"] = attackSprite

    self.animations["hit"] = hitAnim
    self.animations["hit"].onLoop = function() self:finishHit() end
    self.sprites["hit"] = hitSprite

    self.animations["die"] = dieAnim
    self.animations["die"].onLoop = function() self:died() end
    self.sprites["die"] = dieSprite

    self.animations["shoot"] = shootAnim
    self.animations["shoot"].onLoop = function() self.state="idle" end
    self.sprites["shoot"] = shootSprite

    self.animations["charge"] = chargeAnim
    self.animations["shoot"].onLoop = function() self.state="idle" end
    self.sprites["charge"] = chargeSprite

    self.hurtboxes["idle"] = Hbox(self,34,0,25,48-16)
    self.hurtboxes["shoot"] = Hbox(self,34,0,25,48-16)
    self.hurtboxes["charge"] = Hbox(self,34,0,25,48-16)
    self.hurtboxes["run"] = Hbox(self,34,0,26,48-16)
    self.hurtboxes["attack1"] = Hbox(self,34,0,26,48-16)
    self.hitboxes["attack1"] = Hbox(self,34,16,43,16)
    self.hurtboxes["attack2"] = Hbox(self,34,0,26,48-16)
    self.hitboxes["attack2"] = Hbox(self,25,16,52,16)
    self.hurtboxes["jump"] = Hbox(self,34,0,26,48-16)


end

function Player:update(dt, stage)
    if love.keyboard.isDown("right") then
        self:setDirection("r")
        if not stage:rightCollision(self, 1) then
            self.x = self.x + 96*dt
        end
    elseif love.keyboard.isDown("left") then
        self:setDirection("l")
        if not stage:leftCollision(self,1) then
            self.x = self.x - 96*dt
        end
    elseif love.keyboard.isDown("c") and self.mana < self.maxMP then
        self.mana = self.mana+((1*dt))
    end

    if stage:topCollision(self,1,1) then
        self.speedY = 10
    end
    if self.state == "idle" or self.state == "run" then
        if not stage:bottomCollision(self,1,1) then
            self.state = "jump"
            self.speedY = 32
            self:jump(dt, stage)
        elseif love.keyboard.isDown("right","left") then
            self.state = "run"
        elseif love.keyboard.isDown("c") then
            self.state = "charge"
        elseif not love.keyboard.isDown("c") then
            self.state = "idle" 
        else
            self.state = "idle"
        end
    elseif self.state == "jump" or self.state == "attack1" or self.state == "attack2" then
        if self.speedY < 0 then
            self:jump(dt, stage)
        elseif not stage:bottomCollision(self,1,1) then
            self:jump(dt, stage)
        elseif self.state == "jump" then
            self.state = "idle"
            self.speedY = 1
        end
    end

    if self.state == "attack1" or self.state == "attack2" then
        local mob = stage:checkMobsHboxCollision(self:getHitbox())
        if mob ~= nil then
            mob:hit(self.damage, self.dir)
        end
    end


    if stage:bottomCollision(self, 1, 1) then
        self.ground = true
    else
        self.ground = false
    end
    if self.state ~= "hit" then 
        local mob = stage:checkMobsHboxCollision(self:getHurtbox(),"hit")
        if mob then
            self.state = "hit"
            self.speedY = -32 
            self.hp = math.max(0, self.hp - mob.damage)
        end
        if stage:bottomHazard(self,1,1) then
            self.state = "hit"
            self.speedY = -300
            self.hp = math.max(0, self.hp-1)
        end
    else 
        if self.dir == "r" then
            self.x = math.max(0,self.x - 32*dt) 
        else
            self.x = math.min(self.x + 32*dt, stage:getWidth()-32)
        end
        if not stage:bottomCollision(self,1,1) then 
            self:jump(dt, stage) 
        end
    end

    if self.mana > 3 then
        self.mana = 3
    end
    if self.hp <= 0 then 
        self.state = "die"
        Sounds["die"]:play()
    end

    self.animations[self.state]:update(dt)
end

function Player:draw(stage)
    self.animations[self.state]:draw(self.sprites[self.state],
        math.floor(self.x), math.floor(self.y) )

    if debugFlag then
        local w,h = self:getDimensions()
        love.graphics.rectangle("line",self.x,self.y,w,h)
        love.graphics.print(w.." | "..h, self.x, self.y-20)
        local row1,col1,row2,col2 = stage:toMapCoords(self)
        love.graphics.rectangle("line",(col1-1)*stage:getTileSize(),(row2-0-1)*stage:getTileSize(),(col2)*stage:getTileSize()-(col1)*stage:getTileSize()+stage:getTileSize(),stage:getTileSize())
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

function Player:keypressed(key, stage)
    if key == "z" and self.state ~= "jump" and not ((self.state=="attack1" or self.state=="attack2") and not self.ground) then
        self.state = "jump"
        self.speedY = -200 
        self.y = self.y -1
        self.animations["jump"]:gotoFrame(1)
        Sounds["jump"]:play()
    elseif key=="x" and self.state~="attack1" and self.state~="attack2" then
        self.state = "attack1"
        self.animations["attack1"]:gotoFrame(1)
        Sounds["attack1"]:play()
    elseif key=="x" and self.state == "attack1" then
        self.state = "attack2"
        self.animations["attack2"]:gotoFrame(1)
        Sounds["attack2"]:play()
    elseif key == "d" and self.mana >= 1 then
        Sounds["attack2"]:play()
        self:magicAttack(stage)
    end
end

function Player:magicAttack(stage)
    local row1,col1,row2,col2 = stage:toMapCoords(self)
    self.state = "shoot"
    local blast = Magic(nil, self.dir)
    if self.dir == 'r' then 
        blast:setCoord(self.x+50, self.y-16)
    else
        blast:setCoord(self.x-50, self.y-20)
    end
    stage:addMob(blast)
    self.mana = self.mana-1
end

function Player:setCoords(x,y)
    self.x = x
    self.y = y
end

function Player:setDirection(newdir)
    if self.dir ~= newdir then
        self.dir = newdir
        for states,anim in pairs(self.animations) do
            anim:flipH()
        end 
    end 
end

function Player:jump(dt, stage)
    if self.y < stage:getHeight() then
        self.y = self.y + self.speedY*dt
        self.speedY = self.speedY +gravity*dt
    else 
        self:died(stage)
    end
end

function Player:onGround()
    if self.y >= 8*16 then 
        self.y = 8*16
        return true
    end
    return false
end

function Player:getDimensions()
    return self.animations[self.state]:getDimensions()
end

function Player:finishAttack()
    self.state = "idle"
end

function Player:getHbox(boxtype)
    if boxtype == "hit" then
        return self.hitboxes[self.state]
    else
        return self.hurtboxes[self.state]
    end
end

function Player:getHitbox()
    return self:getHbox("hit")
end

function Player:getHurtbox()
    return self:getHbox("hurt")
end

function Player:died(stage)
    if stage == nil then stage = stagemanager:currentStage() end

    self.lives = self.lives - 1
    self:setDirection("r")
    self.state = "idle"
    self.speedY = 1
    self.hp = self.maxHP
    self.mana = self.maxMP
    self.x = stage.initialPlayerX
    self.y = stage.initialPlayerY
    Sounds["die"]:play()
end

function Player:finishHit()
    self.state = "idle"
end

return Player