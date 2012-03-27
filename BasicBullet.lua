module (..., package.seeall)

function new(xPos, yPos, name, image, isEnemyBullet)

	local bullet
	if (image == "circle") then 
		bullet = display.newCircle(xPos, yPos, 5)
	else 
		bullet = display.newImage(image, xPos, yPos)
	end
	
	bullet.isActive = "active"
	
	local function destroyBullet()
		if (bullet and bullet.removeSelf) then
			bullet:removeSelf()
		end
	end

	-- Take care of collisions
	local function onCollision(event)

	--	print ("COLLISION: " .. event.object1.name .. " WITH " .. event.object2.name)

		if (event.object1.name == "enemy" and event.object2.name == "playerBullet" 
			and event.object1.isAlive == "alive" and event.object2.isActive == "active") then

			-- Increase score
			event.object1.hp = event.object1.hp - 1

			table.insert(_G.toRemove, event.object2)
			event.object2.isVisible = false
			event.object2._functionListeners = nil
			event.object2._tableListeners = nil
			event.object2.isActive = "inactive"
			
			print (event.object1.hp)
			if event.object1.hp <= 1 then

				_G.score = _G.score + 1
				print (_G.score)
				_G.scoreText.text = _G.score

				_G.enemyCount = _G.enemyCount - 1

				--event.object2.alive = "no"
				-- Play Sound
				audio.setVolume (0.30, {channel=3})
				audio.play(_G.trumpet[_G.trumpetQ], {channel=3})
				_G.trumpetQ = _G.trumpetQ + 1
				if _G.trumpetQ > #_G.trumpet then
					_G.trumpetQ = 1
				end
				sprite.add( _G.pow_Set, "pow", 1, 6, 300, -1 )
				local powInst = sprite.newSprite ( _G.pow_Set )
				powInst.x = event.object1.x
				powInst.y = event.object1.y
				powInst:prepare("pow")
				powInst:play()
				-- We can't remove a body inside a collision event, so queue it to removal.
				-- It will be removed on the next frame inside the game loop.
				table.insert(_G.toRemove, event.object1)
				event.object1._functionListeners = nil
				event.object1._tableListeners = nil	
				event.object1.isAlive = "dead"	
			end
		-- Player was hit!	
		elseif event.object1.name == "player" and event.object2.name == "enemyBullet" then
			-- destroy the enemy bullet
			table.insert(_G.toRemove, event.object2)
			event.object2._functionListeners = nil
			event.object2._tableListeners = nil

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
	timer.performWithDelay(7000, destroyBullet)

	return bullet

end