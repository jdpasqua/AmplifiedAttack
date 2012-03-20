module (..., package.seeall)

function new(xPos, yPos, rotationAngle)
	
	if ((xPos == nil) or (yPos == nil)) then
		return nil
	end
	
	local bullet = display.newCircle(xPos, yPos, 6)
	--display.newImage("assets/graphics/bullet10.png", xPos, yPos + 40)

	function bullet:removeBullet()
		bullet:removeSelf()
	end
	
	function bullet:init()
		
		local enemyBulletCollisionFilter = { categoryBits = 8, maskBits = 1 }
		
		-- Physics
		physics.addBody(bullet, "dynamic", {bounce = 0, filter = enemyBulletCollisionFilter})
		
		-- Name
		bullet.name = "enemyBullet"
		
		bullet:setReferencePoint( display.CenterReferencePoint )
		
		-- Color
		bullet.setColor()
		bullet.rotation = rotationAngle
		bullet.isFixedRotation = true
	
		local bulletSpeed = 300
		bullet:setLinearVelocity(math.sin(math.rad(bullet.rotation))*bulletSpeed,
								 math.cos(math.rad(bullet.rotation))*-bulletSpeed)
		timer.performWithDelay(10000, bullet.removeBullet)

		_G.bulletsLayer:insert(bullet)
	end
	
	function bullet:move()
		--transition.to( bullet, { time=900, x=math.random(display.contentWidth), y=math.random(display.contentHeight / 2)} )
	end
	
	function bullet:setColor()
		bullet:setFillColor(131, 245, 44)
	end
	
	bullet:init()	
		
	return bullet
	
end