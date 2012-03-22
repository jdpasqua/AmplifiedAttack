module (..., package.seeall)

function new()

	local player = display.newImage("assets/graphics/antmaker.png")
	local halfPlayerWidth
	local halfPlayerHeight
	
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

		local playerCollisionFilter = { categoryBits = 1, maskBits = 12 }

		-- Add a physics body. It is kinematic, so it doesn't react to gravity.
		physics.addBody(player, "kinematic", {bounce = 0, filter = playerCollisionFilter})

		player.name = "player"
		player:toFront()
		player.collision = onCollision
		player:addEventListener("collision", player)

		-- Add to main layer
		_G.gameLayer:insert(player)
		player:addEventListener("touch", playerMovement)
		Runtime:addEventListener("track4", player)

	end

	function player:setColor()
		player:setFillColor(243, 132, 0)
	end
	
	function player:shoot()
		print ("SHOOT!")

	end

	function player:track4( event )
		player.shoot()
	--	player.move()
	end

	function player:removePlayer()
		Runtime:removeEventListener("track4", player)
		player:removeSelf()
	end


	player:init()	

	return player

end


