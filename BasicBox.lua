module (..., package.seeall)

function new()
	
	local StraightBullet = require("StraightBullet")
	
	local box = display.newRect( 0, 0, 30, 30 )
	
	local straightBullet
	
	function box:init()

		-- Physics
		physics.addBody(box, "dynamic", {bounce = 0})
		
		-- Name
		box.name = "enemy"
		
		-- Position
		box.x = math.random(display.contentWidth)
		box.y = math.random(display.contentHeight / 2)
		
		-- Color
		box.setColor()
		
		-- Event Listener
		Runtime:addEventListener( "pulse", box )
		
		box.collision = onCollision
		box:addEventListener("collision", box)
				
		_G.gameLayer:insert(box)
	end
	
	function box:move()
		local rotationAngle
		if (box.rotation == 0) then
			rotationAngle = 360
		else
			rotationAngle = 0
		end
		transition.to( box, { rotation = rotationAngle, time=900, x=math.random(display.contentWidth), y=math.random(display.contentHeight / 2)} )
	
	end
	
	function box:setColor()
		box:setFillColor(math.random(255), math.random(255), math.random(255))
	end
	
	function box:shoot()
		-- Fire a bullet!
		straightBullet = StraightBullet.new(box.x, box.y)
	end
	
	function box:pulse( event )
		box.move()	
		box.shoot()
	end
		
	return box
	
end