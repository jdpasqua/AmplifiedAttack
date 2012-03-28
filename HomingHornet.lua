module (..., package.seeall)

function new(type, entrance)
	
	local BulletHoming = require("BulletHoming")
	local easingx  = require("easing")
	local trackno = "track11"
	local note = "E--"
	
	local BasicEnemy = require("BasicEnemy")
	local enemy = BasicEnemy.new("HomingHornet", "assets/graphics/hominghornet2.png", trackno, 3)
	local rotationAngle = 0
	local bullet1
	local isShooting = false
	local trackno = "track11" 
		function enemy:enableShooting() 
			if (enemy.isAlive == "alive") then  
				isShooting = true
			end
		end

		function enemy:init()	

			-- Position
			enemy.x = entrance.xpos
			enemy.y = entrance.ypos

--			enemy.setColor()

			if (entrance.direction == "straight") then
				transition.to(enemy, {
			                	time = entrance.speed,
			                	x = enemy.x,
			                	y = enemy.y + entrance.distance,
			                	--transition = easingx.easeIn, --OutBack,
			 					onComplete = enemy.enableShooting })
			end
			-- Event Listener
			Runtime:addEventListener( trackno, enemy )

			_G.gameLayer:insert(enemy)
		end

		function enemy:setColor()
			enemy:setFillColor(80, 99, 190)
		end

		function enemy:shoot()
			-- Fire a bullet!
			if (isShooting and enemy.x and enemy.y) then
				bullet = BulletHoming.new(enemy.x - 22, enemy.y + 30)
			end
		end

		function enemy:track11( event )
			if (event.note == note) then
				enemy.shoot()
			end
		end

		enemy.init()

		return enemy

	end
	