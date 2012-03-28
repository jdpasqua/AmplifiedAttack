module (..., package.seeall)

function new(type, image, trackno, hp)

	local enemy = display.newImage(image)
	local enemyCollisionFilter = { categoryBits = 4, maskBits = 3 }

	enemy:scale(1.6, 1.6)
	enemy.name = "enemy"
	enemy.type = "Skrillot"
	enemy.trackno = trackno
	enemy.isAlive = "alive"
	enemy.hp = hp

	-- Physics
	physics.addBody(enemy, "kinematic", {density = 20, bounce = 0, filter = enemyCollisionFilter})

	enemy:setReferencePoint( display.CenterReferencePoint )

	_G.gameLayer:insert(enemy)
	
	function enemy:_resetColor()
		if (enemy ~= nil and enemy.setFillColor) then
			enemy:setFillColor(255, 255, 255)
		end
	end
	
	function enemy:resetColor()
		timer.performWithDelay(200, enemy._resetColor) 
	end

	return enemy

end
