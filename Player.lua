module (..., package.seeall)

function new()

	local BulletRotating = require("BulletRotating")
	local player = display.newImage("assets/graphics/antmaker.png")
	local playerLEFT = display.newImage("assets/graphics/antmaker_LEFT2.png")
	local playerRIGHT = display.newImage("assets/graphics/antmaker_RIGHT2.png")
	local halfPlayerWidth
	local halfPlayerHeight
	local currentTrack = "track2"
	
	--------------------------------------------------------------------------------
	-- Basic controls
	--------------------------------------------------------------------------------
	function playerMovement(event)
		-- Doesn't respond if the game is ended
		if not _G.gameIsActive then return false end

		playerLEFT.x = player.x 
		playerRIGHT.x = player.x
		
		playerLEFT.y = player.y + 2
		playerRIGHT.y = player.y + 2
		
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
	end
	
	function player:activateTouch()
		player:addEventListener("touch", playerMovement)
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
			local bullet = BulletRotating.new(player.x - 18, player.y - 10, 0, false, "assets/graphics/basicBulletGreen.png")
		else
			local bullet = BulletRotating.new(player.x - 18, player.y - 10, 0, false, "assets/graphics/basicBulletRed.png")
		end
	end

	function player:track2( event )
		shoot("A")
	end
	
	function player:track1( event )
		shoot("B")
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


