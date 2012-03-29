module (..., package.seeall)

function new(xPos, yPos)
	
	local BulletRotating = require("BulletRotating")

	local explosion = display.newCircle(xPos, yPos, 1)
	
	function explosion:init()
		
		for i = 0, 360, 10 do 
			local bullet = BulletRotating.new(xPos, yPos, i, false, "assets/graphics/basicBulletRed.png")
		end
		
	end
	
	explosion.init()
	
	return explosion
	
end