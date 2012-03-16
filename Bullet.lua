module (..., package.seeall)

function new(xPos, yPos, type)
	
	if ((xPos == nil) or (yPos == nil)) then
		return nil
	end
	
	local bullet = display.newCircle( xPos, yPos, 7 )
	
	function bullet:removeBullet()
		bullet:removeSelf()
	end
	
	function bullet:init()
		-- Physics
		physics.addBody(bullet, "dynamic", {bounce = 0})
		
		-- Name
		bullet.name = "bullet"
		
		-- Color
		bullet.setColor()
		
		-- Event Listener		
		bullet.collision = onCollision
		bullet:addEventListener("collision", bullet)
		
		transition.to( bullet, { time=1500, y=bullet.y + 1100, onComplete = endBullet, onComplete = bullet.removeBullet} )
				
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