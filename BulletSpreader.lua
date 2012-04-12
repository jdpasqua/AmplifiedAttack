module (..., package.seeall)

function new(xPos, yPos, type)

	function bullet:removeBullet()
		Runtime:removeEventListener("track4", bullet)
		bullet:removeSelf()
		bullet.isAlive = false
	end

	local BasicBullet = require("BasicBullet")
	local bullet = BasicBullet.new(xPos, yPos, "enemyBullet", "circle", true)

	function bullet:init()

		bullet.isAlive = true

		-- Color
		bullet.setColor()

		timer.performWithDelay(3000, bullet.removeBullet)
		bullet.move()
		_G.bulletsLayer:insert(bullet)
	end

	function bullet:move()
		if (bullet.isAlive == true) then
			if (type == "left") then
				bullet:setLinearVelocity(50, 200)
				type = "right"
			elseif (type == "right") then
				bullet:setLinearVelocity(-50, 200)
				type = "left"
			end
		end
	end

	function bullet:setColor()
		bullet:setFillColor(0, 255, 102)
	end

	bullet:init()	

	return bullet

end