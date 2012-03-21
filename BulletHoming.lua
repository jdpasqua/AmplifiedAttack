module (..., package.seeall)

function new(xPos, yPos)

	local BasicBullet = require("BasicBullet")
	local bullet = BasicBullet.new(xPos, yPos, "enemyBullet", "circle", true)

	function bullet:removeBullet()
		Runtime:removeEventListener("track4", bullet)
		bullet:removeSelf()
	end

	function bullet:init()

		timer.performWithDelay(5000, bullet.removeBullet)

		-- Event Listener
		Runtime:addEventListener( "track4", bullet )
		bullet.move()
		_G.bulletsLayer:insert(bullet)
	end

	function bullet:move()
		local xSpeed
		local ySpeed
		xSpeed = speed * (_G.player.x - bullet.x)
		if (xSpeed < 0 and xSpeed > -150) then
			xSpeed = -150
		end
		if (xSpeed >= 0 and xSpeed < 150) then
			xSpeed = 150
		end
		local speed = 0.6
		bullet:setLinearVelocity(xSpeed, speed * (_G.player.y - bullet.y))
	end

	function bullet:track4( event )
		bullet.move()
	end

	bullet:init()	

	return bullet

end