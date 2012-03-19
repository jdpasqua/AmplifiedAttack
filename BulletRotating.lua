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
		bullet.name = "bullet"
		
		bullet:setReferencePoint( display.CenterReferencePoint )
		
		-- Color
		--bullet.setColor()
		--print ("ROTATION ANGLE" .. rotationAngle)
		bullet.rotation = rotationAngle
		bullet.isFixedRotation = true
		
		-- Event Listener		
		--bullet.collision = onCollision
		--bullet:addEventListener("collision", bullet)
		
		--transition.to( bullet, { time=1500, y=bullet.y + 1100, onComplete = endBullet, onComplete = bullet.removeBullet} )
		local bulletSpeed = 1000
		bullet:setLinearVelocity(math.sin(math.rad(bullet.rotation))*bulletSpeed,math.cos(math.rad(bullet.rotation))*-bulletSpeed)
		timer.performWithDelay(2000, bullet.removeBullet)

		_G.gameLayer:insert(bullet)
	end
	
	function bullet:move()
		--transition.to( bullet, { time=900, x=math.random(display.contentWidth), y=math.random(display.contentHeight / 2)} )
	end
	
	function bullet:setColor()
		bullet:setFillColor(math.random(255), math.random(255), math.random(255))
	end
	
	bullet:init()	
		
	return bullet
	
end