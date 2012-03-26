module (..., package.seeall)

function new(xPos, yPos, name, image, isEnemyBullet)
	
	local bullet
	if (image == "circle") then 
		bullet = display.newCircle(xPos, yPos, 5)
	else 
		bullet = display.newImage(image, xPos, yPos)
	end
	
	-- Take care of collisions
	local function onCollision(event)
		
		if (event.object1.name == "enemy" and event.object2.name == "playerBullet" and event.object1.isAlive == "alive") then
		
			-- Increase score
			event.object1.hp = event.object1.hp - 1

			if event.object1.hp <= 10 then

				_G.score = _G.score + 1
				print (_G.score)
				_G.scoreText.text = _G.score

				--event.object2.alive = "no"
				-- Play Sound
				--audio.play(_G.sounds.boom)

				-- We can't remove a body inside a collision event, so queue it to removal.
				-- It will be removed on the next frame inside the game loop.
				table.insert(_G.toRemove, event.object1)
				event.object1._functionListeners = nil
				event.object1._tableListeners = nil	
				event.object1.isAlive = "dead"	

				-- Player collision - GAME OVER	
			elseif event.object1.name == "player" and event.object2.name == "enemyBullet" then

				event.object2.isVisible = false

				--audio.play(sounds.gameOver)

				--local gameoverText = display.newText("Game Over!", 0, 0, "HelveticaNeue", 35)
				--gameoverText:setTextColor(255, 255, 255)
				--gameoverText.x = display.contentCenterX
				--gameoverText.y = display.contentCenterY
				--_G.gameLayer:insert(gameoverText)

				-- This will stop the gameLoop
				--_G.gameIsActive = false
			end
		end
	end

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
	
	--bullet.onCollision = bullet.onCollision
	Runtime:addEventListener( "collision", onCollision )
	
	_G.bulletsLayer:insert(bullet)

	return bullet

end