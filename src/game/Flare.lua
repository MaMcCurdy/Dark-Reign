local Class = require "libs.hump.class"
local imgParticle = love.graphics.newImage("graphics/particles/20.png")
local Flare = Class{}

function Flare:init()
    self.particleSystem = love.graphics.newParticleSystem(imgParticle,100) 
    self.particleSystem:setParticleLifetime(0.2, 1.0)
    self.particleSystem:setEmissionRate(0)
    self.particleSystem:setSizes(0.1, 0) 
    self.particleSystem:setSpeed(0, 20) 
    self.particleSystem:setLinearAcceleration(0, 0, 0, 0)
    self.particleSystem:setEmissionArea("uniform",10,10,0,true)
    self.particleSystem:setColors(1, 1, 1, 1, 0, 0, 0, 0) 
end

function Flare:setColor(r,g,b) 
    self.particleSystem:setColors(r,g,b,1,r,g,b,0)
end

function Flare:trigger(x,y)
    if x and y then 
        self.particleSystem:setPosition(x, y)
    end
    self.particleSystem:emit(30) 
end

function Flare:update(dt)
    self.particleSystem:update(dt)
end

function Flare:draw(x,y)
    love.graphics.draw(self.particleSystem, x, y)
end

function Flare:isActive() 
    return self.particleSystem:getCount() > 0
end
return Flare 