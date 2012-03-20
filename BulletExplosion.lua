module (..., package.seeall)

function new(xPos, yPos)
	
	local BulletRotating = require("BulletRotating")
	local easingx  = require("easing")

	local bullet1
	local bullet2
	local explosion = display.newCircle(xPos, yPos, 1)
	
	function explosion:init()
		
		for i = 0, 360, 10 do 
			local bullet = BulletRotating.new(xPos, yPos, i)
		end
		
	end
	
	explosion.init()
	
	return explosion
	
end