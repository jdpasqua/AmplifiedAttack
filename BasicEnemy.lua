module (..., package.seeall)

function new(type, image, trackno, hp)

	local enemy = display.newImage(image)
	local enemyCollisionFilter = { categoryBits = 4, maskBits = 3 }

	enemy:scale(2, 2)
	enemy.name = "enemy"
	enemy.type = "Skrillot"
	enemy.trackno = trackno
	enemy.alive = "yes"
	enemy.hp = hp

	-- Physics
	physics.addBody(enemy, "dynamic", {bounce = 0, filter = enemyCollisionFilter})

	enemy:setReferencePoint( display.CenterReferencePoint )

	_G.gameLayer:insert(enemy)

	return enemy

end
