local Class = require "libs.hump.class"

local Hbox = Class{}
function Hbox:init(entity,ofX,ofY,width,height)
    self.entity = entity 
    self.offsetX = ofX 
    self.offsetY = ofY 
    self.width = width 
    self.height = height 
end

function Hbox:left()
    if self.entity.dir == "l" then
        local animWidth, animHeight = self.entity:getDimensions()
        return self.entity.x+animWidth-self.offsetX-self.width
    else 
        return self.entity.x+self.offsetX
    end
end

function Hbox:top()
    return self.entity.y+self.offsetY
end

function Hbox:right() 
    return self:left()+self.width
end

function Hbox:bottom()
    return self:top()+self.height
end

function Hbox:draw()
    if debugFlag then
        love.graphics.rectangle("line", self:left(), self:top(), self.width, self.height)
    end
end

function Hbox:collision(anotherHbox) 
    return self:right() >= anotherHbox:left() and anotherHbox:right() >= self:left()
    and self:bottom() >= anotherHbox:top() and anotherHbox:bottom() >= self:top()
end

return Hbox
