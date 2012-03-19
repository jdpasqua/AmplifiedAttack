module (..., package.seeall)

function new(type)
	
	local BulletRotating = require("BulletRotating")
	local easingx  = require("easing")
	

	local box = display.newImage("assets/graphics/Skrillot.png")
	box:scale(2, 2)
	
	local straightBullet
	local rotationAngle = 90
	
	local transitionManager = require('transitionManager')

	--function box:onCollision(self, event)
	--	print ("COLLISION: " .. self.name .. " WITH " .. event.other.name)
	--end 
	
	function box:init()

		local enemyCollisionFilter = { categoryBits = 4, maskBits = 3 }
		-- Physics
		physics.addBody(box, "dynamic", {bounce = 0, filter = enemyCollisionFilter})
		
		-- Name
		box.name = "enemy"
		box.alive = "yes"
		
		box:setReferencePoint( display.CenterReferencePoint )
		
		-- Position
		box.x = math.floor(math.random(display.contentHeight / 2))
		box.y = math.floor(math.random(display.contentHeight / 2))
				
		-- Color
		--box.setColor()
		
		-- Event Listener
		Runtime:addEventListener( "pulse", box )
		
		--box.collision = onCollision
		--box:addEventListener("collision", box)
				
		_G.gameLayer:insert(box)
	end
	
	function box:move()
		--local rotationAngle
		--if (box.rotation == 0) then
	--		rotationAngle = 360
--		else
--			rotationAngle = 0
--		end
		--local trans1 = transitionManager:newTransition( box, { --rotation = 0, 
		--	time=900, x=math.random(display.contentWidth), y=math.random(display.contentHeight / 2)} )
		--[[
		local nextX
		local nextY
		
		if (box.x > 350) then
			nextX = box.x - 200
		else
			nextX = box.x + 200
		end
		
		if (box.y > 500) then
			nextY = box.y - 500
		else
			nextY = box.y + 100
		end
		
		transition.to(box, {
		                time = 4000,
		                x = display.contentWidth + 10 ,
		                y = display.contentHeight / 2 - box.y,
		                transition = easingx.easeInElastic })
						]]
	end
	
	function box:setColor()
		box:setFillColor(math.random(255), math.random(255), math.random(255))
	end
	
	function box:shoot()
		-- Fire a bullet!
		straightBullet = BulletRotating.new(box.x, box.y + math.floor(box.height / 2), rotationAngle)
		rotationAngle = rotationAngle + 15
		--print ("ROTATION ANGLE" .. rotationAngle)
		
	end
	
	function box:pulse( event )
		box.move()
		box.shoot()
	end
		
	return box
	
end