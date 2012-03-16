module (..., package.seeall)

function new(type)
	
	local Bullet = require("Bullet")
	local easingx  = require("easing")
	
	local box
	if (math.random(10) > 7) then 
		box = display.newImage("assets/graphics/enemy5.png")
	else 
		box = display.newImage("assets/graphics/enemy12.png")
	end
	
	box:scale(2, 2)
	local straightBullet
	
	local transitionManager = require('transitionManager')

	function box:init()

		-- Physics
		physics.addBody(box, "dynamic", {bounce = 0})
		
		-- Name
		box.name = "enemy"
		
		box:setReferencePoint( display.CenterReferencePoint )
		
		-- Position
		box.x = math.floor(math.random(display.contentHeight / 2))
		box.y = math.floor(math.random(display.contentHeight / 2))
				
		-- Color
		--box.setColor()
		
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
		straightBullet = Bullet.new(box.x, box.y + math.floor(box.height / 2))
	end
	
	function box:pulse( event )
		box.move()
		box.shoot()
	end
		
	return box
	
end