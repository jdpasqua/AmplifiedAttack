module (..., package.seeall)

function new(xPos, yPos, rotationAngle)
	
	local BasicBullet = require("BasicBullet")

	local bullet = BasicBullet.new(xPos, yPos, "enemyBullet", "assets/graphics/bullet10.png", true)
	
	function bullet:init()
		
		bullet.rotation = rotationAngle
		bullet.isFixedRotation = true
	
		local bulletSpeed = 300
		bullet:setLinearVelocity(math.sin(math.rad(bullet.rotation))*bulletSpeed,
								 math.cos(math.rad(bullet.rotation))*-bulletSpeed)
		timer.performWithDelay(10000, bullet.removeBullet)
	end
	
	bullet:init()	
		
	return bullet
	
end