module (..., package.seeall)

function new(xPos, yPos, rotationAngle, isEnemy, image)
	
	
	local BasicBullet = require("BasicBullet")
	local name
	if (isEnemy) then
		name = "enemyBullet"
	else 
		name = "playerBullet"
	end
	
	if (image == nil) then
		image = "assets/graphics/bullet10.png"
	end
	
	local bullet = BasicBullet.new(xPos, yPos, name, image, isEnemy)
	
	function bullet:init()
		
		bullet.rotation = rotationAngle
		bullet.isFixedRotation = true
	
		local bulletSpeed = 300
		bullet:setLinearVelocity(math.sin(math.rad(bullet.rotation))*bulletSpeed,
								 math.cos(math.rad(bullet.rotation))*-bulletSpeed)
	end
	
	bullet:init()	
		
	return bullet
	
end