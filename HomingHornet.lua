module (..., package.seeall)

function new(type, entrance)
	
	local BulletRotating = require("BulletRotating")
	local BulletHoming = require("BulletHoming")
	local BulletSplitter = require ("BulletSpreader")
	local BulletExplosion = require ("BulletExplosion")
	local easingx  = require("easing")
	
	local box = display.newImage("assets/graphics/enemy1.png") --HomingHornet.png")
	
	local bullet1
	local rotationAngle = 135
	local isShooting = false
	local trackno = "track4" 
	
	box.type = "HomingHornet"
	
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
		
		box:setReferencePoint( display.CenterReferencePoint )
		
		-- Position
		box.x = entrance.xpos --math.floor(math.random(display.contentWidth))
		box.y = entrance.ypos --math.floor(math.random(display.contentHeight / 2) - display.contentHeight + 30)
		
	--	box.setColor()
		
		transition.to(box, {
		                time = entrance.speed,
		                x = box.x, --math.floor(math.random(display.contentWidth - 80) + 40),
		                y = box.y + entrance.distance, --math.floor(math.random(display.contentHeight / 2)),
		                transition = easingx.easeOutBack,
		 				onComplete = box.enableShooting })
						
		-- Event Listener
		Runtime:addEventListener( trackno, box )

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
			bullet1 = BulletHoming.new(box.x, box.y, "left")
		end
	end
	
	function box:track4( event )
		box.move()
		box.shoot()
	end
	
	box.init()
	
	return box
	
end