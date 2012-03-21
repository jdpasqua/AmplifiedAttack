module (..., package.seeall)

function new(type)
	
	local BulletRotating = require("BulletRotating")
	local BulletHoming = require("BulletHoming")
	local BulletSplitter = require ("BulletSpreader")
	local BulletExplosion = require ("BulletExplosion")
	local easingx  = require("easing")
	local trackno = "track7"
	
	local BasicEnemy = require("BasicEnemy")
	local enemy = BasicEnemy.new("Skrillot", "assets/graphics/Skrillot.png", trackno, 1)
	
	local bullet1
	local bullet2
	local rotationAngle = 135
	local isShooting = false 
	
	function enemy:enableShooting() 
		isShooting = true
	end
	
	function enemy:init()	
		
		-- Position
		enemy.x = math.floor(math.random(display.contentWidth))
		enemy.y = math.floor(math.random(display.contentHeight / 2) - display.contentHeight + 30)
		
	--	enemy.setColor()
		
		transition.to(enemy, {
		                time = 4000,
		                x = math.floor(math.random(display.contentWidth - 80) + 40),
		                y = math.floor(math.random(display.contentHeight / 2)),
		                transition = easingx.easeOutBack,
		 				onComplete = enemy.enableShooting })
						
		-- Event Listener
		Runtime:addEventListener( trackno, enemy )
		
		_G.gameLayer:insert(enemy)
	end
	
	function enemy:removeSkrillot()
		print("REMOVE SKRILLOT")
		Runtime:removeEventListener("track7", bullet)
		if (enemy) then
			enemy:removeSelf()
		end
	end
	
	function enemy:move()

	end
	
	function enemy:setColor()
		enemy:setFillColor(math.random(255), math.random(255), math.random(255))
	end
	
	function enemy:shoot()
		-- Fire a bullet!
		if (isShooting and enemy.x and enemy.y) then
			bullet1 = BulletRotating.new(enemy.x, enemy.y, rotationAngle)
			rotationAngle = rotationAngle + 15
			--local explosion = BulletExplosion.new(enemy.x, enemy.y)
		end
	end
	
	function enemy:track7( event )
		enemy.move()
		enemy.shoot()
	end
	
	enemy.init()
		
	return enemy
	
end
