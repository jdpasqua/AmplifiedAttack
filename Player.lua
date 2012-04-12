module (..., package.seeall)

function new()

	local BulletRotating = require("BulletRotating")

	local BulletExplosion = require("BulletExplosion")
	local player = display.newImage("assets/graphics/antmaker4.png")
	local playerLEFT = display.newImage("assets/graphics/antmaker_LEFT4.png")
	local playerRIGHT = display.newImage("assets/graphics/antmaker_RIGHT4.png")
	local touchArea = display.newRect(0, 0, 1000, 1000)
	touchArea.alpha = 0.01
	local halfPlayerWidth
	local halfPlayerHeight
	local currentTrack = "track2"
	local lastTouchX
	local lastTouchY
	
	--------------------------------------------------------------------------------
	-- Basic controls
	--------------------------------------------------------------------------------
	
	function movePlayer() 
		-- Speed is relative to position of player
		local speed = 20
		local xDistance = (lastTouchX - _G.player.x)
		local yDistance = (lastTouchY - _G.player.y)
		
		if (math.sqrt(yDistance*yDistance +  xDistance*xDistance) < speed) then		
			player.x = lastTouchX;
			player.y = lastTouchY;
		else
			local radian = math.atan2(yDistance, xDistance);
			player.x = player.x + math.cos(radian) * speed;
			player.y = player.y + math.sin(radian) * speed;
		end
		--[[
		local xSpeed
		local ySpeed
		local speed = 3
		local min
		local max = 25
		
		-- Speed is relative to position of player
		xSpeed = (lastTouchX - _G.player.x)
		ySpeed = (lastTouchY - _G.player.y + 30)
		
		if (xSpeed > max) then 
			xSpeed = max
		elseif (xSpeed < -max) then
			xSpeed = -max
		end
		
		if (ySpeed > max) then 
			ySpeed = max
		elseif (ySpeed < -max) then
			ySpeed = -max
		end
		
		player.x = player.x + (xSpeed)
		player.y = player.y + (ySpeed)
		
		--player:setLinearVelocity(xSpeed, ySpeed)
		]]--
	end
	
	function updateTouchLocation(event)
		-- Doesn't respond if the game is ended
		if not _G.gameIsActive then return false end

		-- Don't let the player move onto the track switching buttons
		if (not (event.x < 110 and event.y > 740)) then
			lastTouchX = event.x
			lastTouchY = event.y
		end
		
		--[[
		playerLEFT.x = player.x 
		playerRIGHT.x = player.x
		
		playerLEFT.y = player.y + 2
		playerRIGHT.y = player.y + 2
		player.alpha = 0.1
		if event.x > player.x then
		--	player.isVisible = false
			playerLEFT.isVisible = false
			playerRIGHT.isVisible = true
			
		elseif event.x < player.x then
		--	player.isVisible = false
			playerLEFT.isVisible = true
			playerRIGHT.isVisible = false
			
		else --if event.x <= player.x and event.x <= player.x then
	--		player.isVisible = true
			player.alpha = 1
	
			playerLEFT.isVisible = false
			playerRIGHT.isVisible = false
			
		end

		-- Only move to the screen boundaries
		if event.x >= halfPlayerWidth and event.x <= display.contentWidth - halfPlayerWidth then
			-- Update player x axis
			player.x = event.x
			playerLEFT.x = event.x 
			playerRIGHT.x = event.x
			
		end
		if event.y >= halfPlayerHeight and event.y <= display.contentHeight - halfPlayerHeight then
			-- Update player y axis
			player.y = event.y
			playerLEFT.y = event.y + 2
			playerRIGHT.y = event.y + 2
			
		end
		]]--
	end
	
	function player:activateTouch()
		lastTouchX = player.x
		lastTouchY = player.y
		touchArea:addEventListener("touch", updateTouchLocation)
		Runtime:addEventListener("enterFrame", movePlayer)
	end		
	
	function player:init()
		
		player.x = display.contentCenterX
		player.y = display.contentHeight + player.contentHeight
		
		-- Store half width, used on the game loop
		halfPlayerWidth = player.contentWidth * .5
		halfPlayerHeight = player.contentHeight * .5
		
		player:setReferencePoint( display.CenterReferencePoint )

		local playerCollisionFilter = { categoryBits = 1, maskBits = 28 }

		triangularShape = { 0, -30, 30, 40, -30, 40 }

		-- Add a physics body. It is kinematic, so it doesn't react to gravity.
		physics.addBody(player, "kinematic", {bounce = 0, filter = playerCollisionFilter, shape = triangularShape})

		player.name = "player"
		player:toFront()
		player.collision = onCollision
		player:addEventListener("collision", player)

		player.isVisible = true
		playerLEFT.isVisible = false
		playerRIGHT.isVisible = false
		
		-- Add to main layer
		_G.gameLayer:insert(player)
		_G.gameLayer:insert(playerLEFT)
		_G.gameLayer:insert(playerRIGHT)
		
		--player:addEventListener("touch", playerMovement)

		Runtime:addEventListener(currentTrack, player)
		
		transition.to(player, {time = 1000, 
							   y = player.y - (2 * player.contentHeight),
							   onComplete = player.activateTouch })
--[[						
						playerLEFT.x = display.contentCenterX
							playerLEFT.y = display.contentHeight - player.contentHeight

							playerRIGHT.x = display.contentCenterX
							playerRIGHT.y = display.contentHeight - player.contentHeight
]]
	end

	function player:setColor()
		player:setFillColor(243, 132, 0)
	end
	
	function shoot(type)
		if (type == "A") then
			local bullet = BulletRotating.new(player.x - 18, player.y - 10, 0, false, "assets/graphics/basicBulletBlue.png")
		elseif (type == "B") then
			local bullet1 = BulletRotating.new(player.x - 18, player.y - 10, -10, false, "assets/graphics/basicBulletGreen.png")
			local bullet2 = BulletRotating.new(player.x - 18, player.y - 10, 0, false, "assets/graphics/basicBulletGreen.png")
			local bullet3 = BulletRotating.new(player.x - 18, player.y - 10, 10, false, "assets/graphics/basicBulletGreen.png")
		else
			local explosion = BulletExplosion.new(player.x, player.y)
		end
	end

	function player:track2( event )
		shoot("A")
	end
	
	function player:track1( event )
		if (event.note == "Eb--" or event.note == "E--") then 
			shoot("B")
		end
	end
	
	function player:track3( event )
	--	if (event.note == "E--") then
			shoot("C")
	--	end
	end

	function player:removePlayer()
		Runtime:removeEventListener(currentTrack, player)
		player:removeSelf()
	end

	function player:switchTrack(nextTrack)
		Runtime:removeEventListener(currentTrack, player)
		Runtime:addEventListener(nextTrack, player)
		currentTrack = nextTrack
	end

	player:init()	

	return player

end


