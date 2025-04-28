local Class = require "libs.hump.class"

local Background = Class{}
function Background:init(strImagePath)
    self.img = love.graphics.newImage(strImagePath) 

    self.x = 0
    self.y = 0 

    self.scaleX = 2 
    self.scaleY = 2
end

function Background:draw()
    love.graphics.draw(self.img,self.x,self.y,0,self.scaleX,self.scaleY)
end
    
return Background
