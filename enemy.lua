module (..., package.seeall)

local function new()

   local enemy = display.newRect( 0, 0, 30, 30 )

   function enemy:move()
      self.x = math.random(display.contentWidth)
      self.y = math.random(display.contentHeight)
   end

   function enemy:setColor()
      self:setFillColor(math.random(255), math.random(255), math.random(255))
   end

   return enemy

end