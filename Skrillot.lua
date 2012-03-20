module (..., package.seeall)

function new(type)
	
	local BulletRotating = require("BulletRotating")
	local easingx  = require("easing")
	
	local box = display.newImage("assets/graphics/Skrillot.png")
	box:scale(2, 2)
	
	local straightBullet
	local rotationAngle = 135
	local isShooting = false 
	local transitionManager = require('transitionManager')
	
	function box:enableShooting() 
		isShooting = true
	end
	
	function box:init()

		local enemyCollisionFilter = { categoryBits = 4, maskBits = 3 }
		-- Physics
		physics.addBody(box, "dynamic", {bounce = 0, filter = enemyCollisionFilter})
		
		-- Name
		box.name = "enemy"
		box.alive = "yes"
        box.hp = 5
		
		box:setReferencePoint( display.CenterReferencePoint )
		
		-- Position
		box.x = math.floor(math.random(display.contentWidth))
		box.y = math.floor(math.random(display.contentHeight / 2) - display.contentHeight + 30)
		
		transition.to(box, {
		                time = 4000,
		                x = math.floor(math.random(display.contentWidth - 80) + 40),
		                y = math.floor(math.random(display.contentHeight / 2)),
		                transition = easingx.easeOutBack,
		 				onComplete = box.enableShooting })
						
		-- Event Listener
		Runtime:addEventListener( "pulse", box )

		_G.gameLayer:insert(box)
	end
	
	function box:move()

	end
	
	function box:setColor()
		box:setFillColor(math.random(255), math.random(255), math.random(255))
	end
	
	function box:shoot()
		-- Fire a bullet!
		if (isShooting) then
			straightBullet = BulletRotating.new(box.x, box.y + math.floor(box.height / 2), rotationAngle)
			rotationAngle = rotationAngle + 10
		end
	end
	
	function box:pulse( event )
		box.move()
		box.shoot()
	end
		
	return box
	
end
