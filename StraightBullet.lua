module (..., package.seeall)

function new(xPos, yPos, type)
	
	if ((xPos == nil) or (yPos == nil)) then
		return nil
	end
	
	local straightBullet = display.newCircle( xPos, yPos, 10 )
	
	function endBullet()
		display.remove(straightBullet);
	end
	
	function straightBullet:init()
		-- Physics
		physics.addBody(straightBullet, "dynamic", {bounce = 0})
		
		-- Name
		straightBullet.name = "straightBullet"
		
		-- Color
		straightBullet.setColor()
		
		-- Event Listener		
		straightBullet.collision = onCollision
		straightBullet:addEventListener("collision", straightBullet)
		
		transition.to( straightBullet, { time=1500, y=straightBullet.y + 1000, onComplete = endBullet} )
				
		_G.gameLayer:insert(straightBullet)
	end
	
	function straightBullet:move()
		--transition.to( straightBullet, { time=900, x=math.random(display.contentWidth), y=math.random(display.contentHeight / 2)} )
	end
	
	function straightBullet:setColor()
		straightBullet:setFillColor(math.random(255), math.random(255), math.random(255))
	end
	
	straightBullet:init()	
		
	return straightBullet
	
end