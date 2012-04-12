module (..., package.seeall)

function new(type, entrance)
	
	local BulletRotating = require("BulletRotating")
	local BulletHoming = require("BulletHoming")
	local BulletSplitter = require ("BulletSpreader")
	local BulletExplosion = require ("BulletExplosion")
	local easingx  = require("easing")
	local trackno = "track2"
	
	local BasicEnemy = require("BasicEnemy")
	local enemy = BasicEnemy.new("Brute", "assets/graphics/brute.png", trackno, 3)
	enemy.bypass = false
	local bullet1
	local bullet2
	local rotationAngle = 135
	local isShooting = false 
	
	function enemy:enableShooting()
		if (enemy.isAlive == "alive") then  
			isShooting = true
		end
	end
	
	function enemy:init()	
		
		-- Position
		enemy.x = entrance.xpos --math.floor(math.random(display.contentWidth))
		enemy.y = entrance.ypos --math.floor(math.random(display.contentHeight / 2) - display.contentHeight + 30)
		
	--	enemy.setColor()
		
		if (entrance.direction == "straight") then
			transition.to(enemy, {
		                	time = entrance.speed,
		                	x = enemy.x, --math.floor(math.random(display.contentWidth - 80) + 40),
		                	y = enemy.y + entrance.distance, -- math.floor(math.random(display.contentHeight / 2)),
		                	--transition = easingx.easeIn, --OutBack,
		 					onComplete = enemy.enableShooting })
		end
		-- Event Listener
		Runtime:addEventListener( trackno, enemy )
		
		_G.gameLayer:insert(enemy)
	end
	
	function enemy:removeSkrillot()
		Runtime:removeEventListener("track2", bullet)
		if (enemy) then
			enemy:removeSelf()
		end
	end
	
	function enemy:setColor()
		enemy:setFillColor(math.random(255), math.random(255), math.random(255))
	end
	
	function enemy:shoot()
		-- Fire a bullet!
		if (isShooting and enemy.x and enemy.y) then
			bullet1 = BulletRotating.new(enemy.x - 10, enemy.y, 180, true, "assets/graphics/bruteBullet.png")
		end
	end
	
	function enemy:track2( event )
		if (event.note == "Eb\'\'" or enemy.bypass) then
			enemy.shoot()
		end
	end
	
	enemy.init()
		
	return enemy
	
end
