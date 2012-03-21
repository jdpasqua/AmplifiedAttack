module (..., package.seeall)

function new(xPos, yPos)
	
	if ((xPos == nil) or (yPos == nil)) then
		return nil
	end
	
	local bullet = display.newCircle(xPos, yPos, 6)
	--display.newImage("assets/graphics/bullet10.png", xPos, yPos + 40)

	function bullet:removeBullet()
		Runtime:removeEventListener("track1", bullet)
		bullet:removeSelf()
	end
	
	local speed = 0.6
	
	function bullet:init()
		
		local enemyBulletCollisionFilter = { categoryBits = 8, maskBits = 1 }
		
		-- Physics
		physics.addBody(bullet, "dynamic", {bounce = 0, filter = enemyBulletCollisionFilter})
		
		-- Name
		bullet.name = "enemyBullet"
		
		bullet:setReferencePoint( display.CenterReferencePoint )
		
		-- Color
		bullet.setColor()

		timer.performWithDelay(5000, bullet.removeBullet)
		-- Event Listener
		Runtime:addEventListener( "track1", bullet )
		bullet.move()
		_G.bulletsLayer:insert(bullet)
	end
	
	function bullet:move()
		local xSpeed
		local ySpeed
		xSpeed = speed * (_G.player.x - bullet.x)
			if (xSpeed < 0 and xSpeed > -150) then
				xSpeed = -150
			end
			if (xSpeed >= 0 and xSpeed < 150) then
				xSpeed = 150
			end
		bullet:setLinearVelocity(xSpeed,
								 speed * (_G.player.y - bullet.y))
	end
	
	function bullet:setColor()
		bullet:setFillColor(131, 245, 44)
	end
	
	function bullet:track1( event )
		bullet.move()
	end
	
	bullet:init()	
		
	return bullet
	
end