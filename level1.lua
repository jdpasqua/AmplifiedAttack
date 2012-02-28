module(..., package.seeall)

--====================================================================--
-- SCENE: MAIN MENU
--====================================================================--

new = function ( params )
	
	------------------
	-- Variables
	------------------
	
	local gameIsActive = true
	-----------MIDI TEST ZONE - STAY OUT


	--playTime = 35000--2750
	---------
	
	------------------
	-- Imports
	------------------
	
	local ui = require ( "ui" )
	
	
	
	---------------------------------------------------------------------------------------
	--  Music Channels
	--1 = Background Music
	--2 = Player Music
	--3 = Enemy Music

	--Background music
	--backgroundMusic = audio.loadStream("assets/music/topGear_bg2.mp3")
	backgroundMusic = audio.loadStream("assets/sounds/topGear.mp3")

	backgroundMusicChannel = audio.play(backgroundMusic, { channel=1, loops=-1, fadein=0 })

	--Player Music
	--playerMusic = audio.loadStream("assets/music/topGear_PlayerSounds.mp3")
	--playerMusicChannel = audio.play(playerMusic, { channel=2, loops=-1, fadein=0 })

	--Enemy Music
	--enemyMusic = audio.loadStream("assets/music/topGear_EnemySounds2.mp3")
	--enemyMusicChannel = audio.play(enemyMusic, { channel=3, loops=-1, fadein=0 })

	----------------------------------------------------------------------------------------
	
	------------------
	-- Groups
	------------------
	
	local localGroup = display.newGroup()
	
	------------------
	-- Display Objects
	------------------

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
	
	
	-- Handler that gets notified when the alert closes
	local function onComplete( event )
	        print( "index => ".. event.index .. "    action => " .. event.action )

	        local action = event.action
	        if "clicked" == event.action then
	                if 1 == event.index then
						-- Main Menu
						director:changeScene( "menu", "fade" )
					elseif 2 == event.index then
						-- Change Level
						director:changeScene( "levelSelector", "fade" )
	                elseif 3 == event.index then
						-- Resume Game
						print "RESUME GAME"
						gameIsActive = true
						physics.start()
					end
	        end
	end
	
	local btPauset = function ( event )
		if event.phase == "release" then
			gameIsActive = false
			physics.pause()
			
			-- Show alert
			local alert = native.showAlert( "Game Options", "Choose one:", 
				{ "Main Menu", "Change Level", "Resume Game" }, onComplete )
		end
	end
	
	-- Show alert
	--local alert = native.showAlert( "Corona", "Dream. Build. Ship.", { "OK", "Learn More" }, onComplete )
	
	------------------
	-- UI Objects
	------------------

	local btPause = ui.newButton{
					default = "assets/graphics/bt_pause.png",
					over = "assets/graphics/bt_pause.png",
					onEvent = btPauset,
					id = "btPause"
	}
	
	------------------
	-- Track to Array
	------------------
	
	local function init_p1_track()--(fh)

		--fh is assumed to be open
		local path = system.pathForFile("assets/midi/trackTimes4.txt")
		--local path = system.pathForFile("trackTimes4Trim.txt")

		local tt_p1 = io.open(path, "r")

		local num = tt_p1:read("*l")
		local i = 1

		if tt_p1 then
			while num do
				p1_track[i] = tonumber(num)
				num = tt_p1:read("*l")
				i = i + 1
			end
		else	
		end
	end
	
	local timeout = function ( event )
		local o
		o = event.time
		return o
	end
	
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
		--local gameIsActive = true
		local scoreText
		local sounds
		local score = 0
		local toRemove = {}
		local background
		local player
		local halfPlayerWidth
		--
		p1_track = {}
		--track_to_array("assets/sounds/topGear.mp3", p1_track)
		p1_track[1] = 0
		pos = 0
		valDiff = 0
	
		playTime = 3100 --2750
	

		-- Keep the texture for the enemy and bullet on memory, so Corona doesn't load them everytime
		local textureCache = {}
		textureCache[1] = display.newImage("assets/graphics/enemy.png"); 
		textureCache[1].isVisible = false;
		textureCache[2] = display.newImage("assets/graphics/bullet.png"); 
		textureCache[2].isVisible = false;
		textureCache[3] = display.newImage("assets/graphics/bt_pause.png"); 
		textureCache[3].isVisible = false;
		textureCache[4] = display.newImage("assets/graphics/bt_play.png"); 
		textureCache[4].isVisible = false;
		local halfEnemyWidth = textureCache[1].contentWidth * .5

		-- Adjust the volume
		audio.setMaxVolume( 0.85, { channel=1 } )

		-- Pre-load our sounds
		sounds = {
		--	pew = audio.loadSound("assets/sounds/pew.wav"),
		--	boom = audio.loadSound("assets/sounds/boom.wav"),
		--	gameOver = audio.loadSound("assets/sounds/gameOver.wav")
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
		--	elseif self.name == "player" and event.other.name == "enemy" then
		--		audio.play(sounds.gameOver)

		--		local gameoverText = display.newText("Game Over!", 0, 0, "HelveticaNeue", 35)
		--		gameoverText:setTextColor(255, 255, 255)
		--		gameoverText.x = display.contentCenterX
		--		gameoverText.y = display.contentCenterY
		--		gameLayer:insert(gameoverText)

				-- This will stop the gameLoop
		--		gameIsActive = false
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
		btPause.x = 300
		btPause.y = 25
		localGroup:insert( btPause )


		--------------------------------------------------------------------------------
		-- Game loop
		--------------------------------------------------------------------------------
		local timeLastBullet, timeLastEnemy = 0, 0
		local bulletInterval = 1000

		local function gameLoop(event)
			
			if p1_track[1] == 0 then
			--	local offset = timer.performWithDelay(0, timeout )
			--	playTime = playTime + offset
				init_p1_track()--(tt_p1)
			end
			
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
				if event.time - timeLastBullet >= playTime then
					local bullet = display.newImage("assets/graphics/bullet.png")
					local temp = playTime
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
					--audio.play(sounds.pew)
					
					pos = pos + 1
					valDiff = p1_track[pos+1] - p1_track[pos]
					playTime = valDiff * 1764.7058823

					--This takes care of the error 
					playTime = playTime - ((event.time - timeLastBullet) - temp) --playTime * 0.5


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

