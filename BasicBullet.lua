module (..., package.seeall)

function new(xPos, yPos, name, image, isEnemyBullet)

	local bullet = display.newImage(image, xPos, yPos)

	bullet.hp = hp

	local collisionFilter 
	if (isEnemyBullet) then
		collisionFilter = { categoryBits = 8, maskBits = 1 }
	else
		collisionFilter = { categoryBits = 2, maskBits = 4 }
	end

	-- Physics
	physics.addBody(bullet, "dynamic", {bounce = 0, filter = collisionFilter})

	-- Name
	bullet.name = name

	bullet:setReferencePoint( display.CenterReferencePoint )

	_G.bulletsLayer:insert(bullet)

	return bullet

end