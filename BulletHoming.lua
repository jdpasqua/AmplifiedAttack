module (..., package.seeall)

function new(xPos, yPos, trackno)

	local BasicBullet = require("BasicBullet")
	local bullet = BasicBullet.new(xPos, yPos, "enemyBullet", "assets/graphics/bullet14.png", true, false)
	bullet:scale(0.3, 0.3)
	
	function bullet:removeBullet()
		Runtime:removeEventListener("track11", bullet)
		display.remove(bullet)
		bullet = nil
	end

	function bullet:init()

		timer.performWithDelay(10000, bullet.removeBullet)

		-- Event Listener
		Runtime:addEventListener( "track11", bullet )
		bullet.move()
		_G.bulletsLayer:insert(bullet)
	end

	function bullet:move()
		local xSpeed
		local ySpeed
		local speed = 0.9
		
		-- Speed is relative to position of player
		xSpeed = speed * (_G.player.x - bullet.x)
		ySpeed = speed * (_G.player.y - bullet.y)
		
		-- Set a minimum speed
		if (xSpeed < 0 and xSpeed > -150) then
			xSpeed = -150
		end
		if (xSpeed >= 0 and xSpeed < 150) then
			xSpeed = 150
		end
		if (ySpeed < 0 and ySpeed > -150) then
			ySpeed = -150
		end
		if (ySpeed >= 0 and ySpeed < 150) then
			ySpeed = 150
		end
		bullet:setLinearVelocity(xSpeed, ySpeed)
	end

	function bullet:track11( event )
		if (bullet.isActive == "active" and event.note == "E--") then
			bullet.move()
		end
	end

	bullet:init()	

	return bullet

end