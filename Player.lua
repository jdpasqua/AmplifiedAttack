module (..., package.seeall)

function new()

	local BulletRotating = require("BulletRotating")
	local player = display.newImage("assets/graphics/antmaker.png")
	local halfPlayerWidth
	local halfPlayerHeight
	local currentTrack = "track4"
	
	--------------------------------------------------------------------------------
	-- Basic controls
	--------------------------------------------------------------------------------
	function playerMovement(event)
		-- Doesn't respond if the game is ended
		if not _G.gameIsActive then return false end

		-- Only move to the screen boundaries
		if event.x >= halfPlayerWidth and event.x <= display.contentWidth - halfPlayerWidth then
			-- Update player x axis
			player.x = event.x
		end
		if event.y >= halfPlayerHeight and event.y <= display.contentHeight - halfPlayerHeight then
			-- Update player y axis
			player.y = event.y
		end
	end
	
	function player:init()
		
		player.x = display.contentCenterX
		player.y = display.contentHeight - player.contentHeight
		
		-- Store half width, used on the game loop
		halfPlayerWidth = player.contentWidth * .5
		halfPlayerHeight = player.contentHeight * .5
		
		player:setReferencePoint( display.CenterReferencePoint )

		local playerCollisionFilter = { categoryBits = 1, maskBits = 12 }

		triangularShape = { 0, -30, 30, 40, -30, 40 }

		-- Add a physics body. It is kinematic, so it doesn't react to gravity.
		physics.addBody(player, "kinematic", {bounce = 0, filter = playerCollisionFilter, shape = triangularShape})

		player.name = "player"
		player:toFront()
		player.collision = onCollision
		player:addEventListener("collision", player)

		-- Add to main layer
		_G.gameLayer:insert(player)
		player:addEventListener("touch", playerMovement)
		Runtime:addEventListener(currentTrack, player)

	end

	function player:setColor()
		player:setFillColor(243, 132, 0)
	end
	
	function player:shoot()
		local bullet1 = BulletRotating.new(player.x - 18, player.y - 10, 0, false, "assets/graphics/bullet11.png")

	end

	function player:track4( event )
		player.shoot()
	end
	
	function player:track9( event )
		player.shoot()
	end
	
	function player:track10( event )
		player.shoot()
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


