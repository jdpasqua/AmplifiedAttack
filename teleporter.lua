module (..., package.seeall)

function new()

   local teleporter = require("enemy").new()

   function teleporter:move()
      self.rotation = math.random(360)
   end

   function teleporter:setColor()
      self:setFillColor(255, 0, 0)
   end

   return teleporter

end