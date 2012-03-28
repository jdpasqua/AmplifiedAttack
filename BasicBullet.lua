module (..., package.seeall)

function new(xPos, yPos, name, image, isEnemyBullet, isBounded)

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

	local function playSound()
		local chan = 3
		if (audio.isChannelPlaying( 3 )) then
			if (audio.isChannelPlaying( 4 )) then
				chan = 5
			else
				chan = 4
			end					
		end
		audio.setVolume (0.30, {channel=chan})
		audio.play(_G.trumpet[_G.trumpetQ], {channel=chan})
		_G.trumpetQ = _G.trumpetQ + 1
		if _G.trumpetQ > #_G.trumpet then
			_G.trumpetQ = 1
		end
	end

	local function explode(x, y)
		-- EXPLOSION SPRITE------------------------------------------
		sprite.add( _G.pow_Set, "pow", 1, 12, 500, 1 )
		local powInst = sprite.newSprite ( _G.pow_Set )
		powInst.x = x
		powInst.y = y
		powInst.xScale = 2
		powInst.yScale = 2
		powInst:prepare("pow")
		powInst:play()
	end

	local function enemyHit(enemy, bullet)
		enemy.hp = enemy.hp - 1
		table.insert(_G.toRemove, bullet)
		bullet.isVisible = false
		bullet._functionListeners = nil
		bullet._tableListeners = nil
		bullet.isActive = "inactive"
		enemy:setFillColor(255, 100, 100)
		enemy:resetColor()
		
		if enemy.hp <= 1 then
			_G.score = _G.score + 1
			print (_G.score)
			_G.scoreText.text = _G.score

			_G.enemyCount = _G.enemyCount - 1

			--bullet.alive = "no"
			playSound()
			explode(enemy.x, enemy.y)

			-- We can't remove a body inside a collision event, so queue it to removal.
			-- It will be removed on the next frame inside the game loop.
			table.insert(_G.toRemove, enemy)
			enemy._functionListeners = nil
			enemy._tableListeners = nil	
			enemy.isAlive = "dead"	
		end
	end

	-- Take care of collisions
	local function onCollision(event)

		--	print ("COLLISION: " .. event.object1.name .. " WITH " .. event.object2.name)

		if (event.object1.name == "enemy" and event.object2.name == "playerBullet" and event.object1.isAlive == "alive" and event.object2.isActive == "active") then

			enemyHit(event.object1, event.object2)

		elseif (event.object2.name == "enemy" and event.object1.name == "playerBullet" 	and event.object2.isAlive == "alive" and event.object1.isActive == "active") then

			enemyHit(event.object2, event.object1)


		elseif (event.object1.name == "player" and event.object2.name == "enemyBullet" and event.object2.isActive == "active") then			
			-- destroy the enemy bullet
			table.insert(_G.toRemove, event.object2)
			event.object2.isVisible = false
			event.object2._functionListeners = nil
			event.object2._tableListeners = nil
			event.object2.isActive = "inactive"

			--audio.play(sounds.gameOver)

			--local gameoverText = display.newText("Game Over!", 0, 0, "HelveticaNeue", 35)
			--gameoverText:setTextColor(255, 255, 255)
			--gameoverText.x = display.contentCenterX
			--gameoverText.y = display.contentCenterY
			--_G.gameLayer:insert(gameoverText)

			-- This will stop the gameLoop
			--_G.gameIsActive = false

		elseif (event.object1.name == "Boundary" and event.object2.isActive == "active") then
			table.insert(_G.toRemove, event.object2)
			event.object2.isVisible = false
			event.object2._functionListeners = nil
			event.object2._tableListeners = nil
			event.object2.isActive = "inactive"
		end	
	end

	local collisionFilter 
	if (isEnemyBullet and (isBounded == false)) then
		collisionFilter = { categoryBits = 8, maskBits = 1 }
	elseif (isEnemyBullet and isBounded) then
		collisionFilter = { categoryBits = 16, maskBits = 33 }
	elseif (isEnemyBullet == false) then
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
	--timer.performWithDelay(10000, destroyBullet)

	return bullet

end