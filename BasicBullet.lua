module (..., package.seeall)

function new(xPos, yPos, name, image, isEnemyBullet)
	
	-- Take care of collisions
	local function onCollision(self, event)
		
		print ("COLLISION")
		-- Bullet hit enemy
		if self.name == "bullet" and event.other.name == "enemy" and _G.gameIsActive and event.other then --and event.other.alive == "yes"
			-- Increase score
			event.other.hp = event.other.hp - 1

			if event.other.hp <= 0 then

				_G.score = _G.score + 1
				_G.scoreText.text = score

				--event.other.alive = "no"
				-- Play Sound
				--audio.play(_G.sounds.boom)

				-- We can't remove a body inside a collision event, so queue it to removal.
				-- It will be removed on the next frame inside the game loop.
				table.insert(_G.toRemove, event.other)
				event.other._functionListeners = nil
				event.other._tableListeners = nil		

				-- Player collision - GAME OVER	
			elseif self.name == "player" and event.other.name == "enemyBullet" then

				event.other.isVisible = false

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
	
	local bullet
	if (image == "circle") then 
		bullet = display.newCircle(xPos, yPos, 5)
	else 
		bullet = display.newImage(image, xPos, yPos)
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
	
	bullet.onCollision = bullet.onCollision
	bullet:addEventListener("collision", bullet)

	_G.bulletsLayer:insert(bullet)

	return bullet

end