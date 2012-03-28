module (..., package.seeall)

function new(type, entrance)
	
	local BulletRotating = require("BulletRotating")
	local BulletHoming = require("BulletHoming")
	local BulletSplitter = require ("BulletSpreader")
	local BulletExplosion = require ("BulletExplosion")
	local easingx  = require("easing")
	local trackno = "track7"
	
	local BasicEnemy = require("BasicEnemy")
	local enemy = BasicEnemy.new("Skrillot", "assets/graphics/skrillot2.png", trackno, 3)
	
	local bullet1
	local bullet2
	local rotationAngle = 135
	local isShooting = false 
	
	function enemy:enableShooting() 
		isShooting = true
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
		Runtime:removeEventListener("track7", bullet)
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
			bullet1 = BulletRotating.new(enemy.x, enemy.y, rotationAngle, true)
			rotationAngle = rotationAngle + 17
		end
	end
	
	function enemy:track7( event )
		enemy.shoot()
	end
	
	enemy.init()
		
	return enemy
	
end
