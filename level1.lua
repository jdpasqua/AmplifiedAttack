module(..., package.seeall)

--====================================================================--
-- SCENE: MAIN MENU
--====================================================================--

new = function ( params )
	
	------------------
	-- Imports
	------------------
	
	local ui = require ( "ui" )
	
	------------------
	-- Groups
	------------------
	
	local localGroup = display.newGroup()
	
	------------------
	-- Display Objects
	------------------
	
	--local background = display.newImage( "assets/graphics/background2.png" )

	-- Layers (Groups). Think as Photoshop layers: you can order things with Corona groups,
	-- as well have display objects on the same group render together at once. 
	local gameLayer    = display.newGroup()
	local bulletsLayer = display.newGroup()
	local enemiesLayer = display.newGroup()

	--====================================================================--
	-- BUTTONS
	--====================================================================--
	
	------------------
	-- Functions
	------------------
	
	------------------
	-- UI Objects
	------------------

	--====================================================================--
	-- INITIALIZE
	--====================================================================--
	
	local initVars = function ()
		
		------------------
		-- Inserts
		------------------
		
		--localGroup:insert( background )
		localGroup:insert( gameLayer )

		------------------
		-- Positions
		------------------
		
		-- Hide status bar, so it won't keep covering our game objects
		display.setStatusBar(display.HiddenStatusBar)

		-- Load and start physics
		local physics = require("physics")
		physics.start()

		-- A heavier gravity, so enemies planes fall faster
		-- !! Note: there are a thousand better ways of doing the enemies movement,
		-- but I'm going with gravity for the sake of simplicity. !!
		physics.setGravity(0, 20)

	

		-- Declare variables
		local gameIsActive = true
		local scoreText
		local sounds
		local score = 0
		local toRemove = {}
		local background
		local player
		local halfPlayerWidth

		-- Keep the texture for the enemy and bullet on memory, so Corona doesn't load them everytime
		local textureCache = {}
		textureCache[1] = display.newImage("assets/graphics/enemy.png"); 
		textureCache[1].isVisible = false;
		textureCache[2] = display.newImage("assets/graphics/bullet.png"); 
		textureCache[2].isVisible = false;
		local halfEnemyWidth = textureCache[1].contentWidth * .5

		-- Adjust the volume
		audio.setMaxVolume( 0.85, { channel=1 } )

		-- Pre-load our sounds
		sounds = {
			pew = audio.loadSound("assets/sounds/pew.wav"),
			boom = audio.loadSound("assets/sounds/boom.wav"),
			gameOver = audio.loadSound("assets/sounds/gameOver.wav")
		}

		-- Blue background
		background = display.newRect(0, 0, display.contentWidth, display.contentHeight)
		background:setFillColor(21, 115, 193)
		gameLayer:insert(background)

		-- Order layers (background was already added, so add the bullets, enemies, and then later on
		-- the player and the score will be added - so the score will be kept on top of everything)
		gameLayer:insert(bulletsLayer)
		gameLayer:insert(enemiesLayer)

		-- Take care of collisions
		local function onCollision(self, event)
			-- Bullet hit enemy
			if self.name == "bullet" and event.other.name == "enemy" and gameIsActive then
				-- Increase score
				score = score + 1
				scoreText.text = score

				-- Play Sound
				audio.play(sounds.boom)

				-- We can't remove a body inside a collision event, so queue it to removal.
				-- It will be removed on the next frame inside the game loop.
				table.insert(toRemove, event.other)

			-- Player collision - GAME OVER	
			elseif self.name == "player" and event.other.name == "enemy" then
				audio.play(sounds.gameOver)

				local gameoverText = display.newText("Game Over!", 0, 0, "HelveticaNeue", 35)
				gameoverText:setTextColor(255, 255, 255)
				gameoverText.x = display.contentCenterX
				gameoverText.y = display.contentCenterY
				gameLayer:insert(gameoverText)

				-- This will stop the gameLoop
				gameIsActive = false
			end
		end

		-- Load and position the player
		player = display.newImage("assets/graphics/player.png")
		player.x = display.contentCenterX
		player.y = display.contentHeight - player.contentHeight

		-- Add a physics body. It is kinematic, so it doesn't react to gravity.
		physics.addBody(player, "kinematic", {bounce = 0})

		-- This is necessary so we know who hit who when taking care of a collision event
		player.name = "player"

		-- Listen to collisions
		player.collision = onCollision
		player:addEventListener("collision", player)

		-- Add to main layer
		gameLayer:insert(player)

		-- Store half width, used on the game loop
		halfPlayerWidth = player.contentWidth * .5

		-- Show the score
		scoreText = display.newText(score, 0, 0, "HelveticaNeue", 35)
		scoreText:setTextColor(255, 255, 255)
		scoreText.x = 30
		scoreText.y = 25
		gameLayer:insert(scoreText)

		--------------------------------------------------------------------------------
		-- Game loop
		--------------------------------------------------------------------------------
		local timeLastBullet, timeLastEnemy = 0, 0
		local bulletInterval = 1000

		local function gameLoop(event)
			if gameIsActive then
				-- Remove collided enemy planes
				for i = 1, #toRemove do
					toRemove[i].parent:remove(toRemove[i])
					toRemove[i] = nil
				end

				-- Check if it's time to spawn another enemy,
				-- based on a random range and last spawn (timeLastEnemy)
				if event.time - timeLastEnemy >= math.random(600, 1000) then
					-- Randomly position it on the top of the screen
					local enemy = display.newImage("assets/graphics/enemy.png")
					enemy.x = math.random(halfEnemyWidth, display.contentWidth - halfEnemyWidth)
					enemy.y = -enemy.contentHeight

					-- This has to be dynamic, making it react to gravity, so it will
					-- fall to the bottom of the screen.
					physics.addBody(enemy, "dynamic", {bounce = 0})
					enemy.name = "enemy"

					enemiesLayer:insert(enemy)
					timeLastEnemy = event.time
				end

				-- Spawn a bullet
				if event.time - timeLastBullet >= math.random(250, 300) then
					local bullet = display.newImage("assets/graphics/bullet.png")
					bullet.x = player.x
					bullet.y = player.y - halfPlayerWidth

					-- Kinematic, so it doesn't react to gravity.
					physics.addBody(bullet, "kinematic", {bounce = 0})
					bullet.name = "bullet"

					-- Listen to collisions, so we may know when it hits an enemy.
					bullet.collision = onCollision
					bullet:addEventListener("collision", bullet)

					gameLayer:insert(bullet)

					-- Pew-pew sound!
					audio.play(sounds.pew)

					-- Move it to the top.
					-- When the movement is complete, it will remove itself: the onComplete event
					-- creates a function to will store information about this bullet and then remove it.
					transition.to(bullet, {time = 1000, y = -bullet.contentHeight,
						onComplete = function(self) self.parent:remove(self); self = nil; end
					})

					timeLastBullet = event.time
				end
			end
		end

		-- Call the gameLoop function EVERY frame,
		-- e.g. gameLoop() will be called 30 times per second ir our case.
		Runtime:addEventListener("enterFrame", gameLoop)

		--------------------------------------------------------------------------------
		-- Basic controls
		--------------------------------------------------------------------------------
		local function playerMovement(event)
			-- Doesn't respond if the game is ended
			if not gameIsActive then return false end

			-- Only move to the screen boundaries
			if event.x >= halfPlayerWidth and event.x <= display.contentWidth - halfPlayerWidth then
				-- Update player x axis
				player.x = event.x
			end
		end

		-- Player will listen to touches
		player:addEventListener("touch", playerMovement)
				
		
	end
	
	initVars()
	
	return localGroup
	
end

