module (..., package.seeall)

function new(xPos, yPos, type)
	
	if ((xPos == nil) or (yPos == nil)) then
		return nil
	end
		
	local bullet = display.newCircle(xPos, yPos, 6)
	--display.newImage("assets/graphics/bullet10.png", xPos, yPos + 40)

	function bullet:removeBullet()
		Runtime:removeEventListener("track4", bullet)
		bullet:removeSelf()
		bullet.isAlive = false
	end
	
	local speed = 0.6
	
	function bullet:init()
		
		local enemyBulletCollisionFilter = { categoryBits = 8, maskBits = 1 }
		
		-- Physics
		physics.addBody(bullet, "dynamic", {bounce = 0, filter = enemyBulletCollisionFilter})
		
		-- Name
		bullet.name = "enemyBullet"
		bullet.isAlive = true
		
		bullet:setReferencePoint( display.CenterReferencePoint )
		
		-- Color
		bullet.setColor()

		timer.performWithDelay(3000, bullet.removeBullet)
		-- Event Listener
		--Runtime:addEventListener( "track4", bullet )
		bullet.move()
		_G.bulletsLayer:insert(bullet)
	end
	
	function bullet:move()
		if (bullet.isAlive == true) then
		
		if (type == "left") then
			bullet:setLinearVelocity(50, 200)
			type = "right"
		elseif (type == "right") then
			bullet:setLinearVelocity(-50, 200)
			type = "left"
		end
			--timer.performWithDelay(200, bullet.move)
		end
	end
	
	function bullet:setColor()
		bullet:setFillColor(0, 255, 102)
	end
	
	--function bullet:track4( event )
	--	bullet.move()
	--end
	
	bullet:init()	
		
	return bullet
	
end