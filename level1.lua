module(..., package.seeall)

--====================================================================--
-- SCENE: MAIN MENU
--====================================================================--

new = function ( params )
	
	------------------
	-- Variables
	------------------
	
	local gameIsActive = true
	local scoreText
	local sounds
	local score = 0
	local toRemove = {}
	local background1
	local background2
	local player
	local halfPlayerWidth
	local halfPlayerHeight
	local stars_total = 153
	local stars_field1= 50
	local stars_field2= 140
	local stars_field3= 150
	local stars_field4= 154
	local star_radius_min  = 2
	local star_radius_max  = 3
	local p1_track = {0}
	local p2_track = {0}	
	local pos = 0
	local valDiff = 0
	local playTime = 3300
	local textureCache = {}
	local timeLastBullet, timeLastEnemy = 0, 0
	local bulletInterval = 1000
	local frameNumber = 0
	local totalPauseTime = 0
	local pauseStart
	local pauseEnd
	local basicBox
	local extendedBox
	textureCache[1] = display.newImage("assets/graphics/enemy.png"); 
	textureCache[1].isVisible = false;
	textureCache[2] = display.newImage("assets/graphics/bullet.png"); 
	textureCache[2].isVisible = false;
	textureCache[3] = display.newImage("assets/graphics/bt_pause.png"); 
	textureCache[3].isVisible = false;
	textureCache[4] = display.newImage("assets/graphics/bt_play.png"); 
	textureCache[4].isVisible = false;
	local halfEnemyWidth = textureCache[1].contentWidth * .5
	local sounds = {
	--	pew = audio.loadSound("assets/sounds/pew.wav"),
	--	boom = audio.loadSound("assets/sounds/boom.wav"),
	--	gameOver = audio.loadSound("assets/sounds/gameOver.wav")
	}
	
	-----------------------
	--  Music Channels
	--1 = Background Music
	--2 = Player Music
	--3 = Enemy Music
	-----------------------
	
	-- Background music
	backgroundMusic = audio.loadStream("assets/sounds/topGear.mp3")
	backgroundMusicChannel = audio.play(backgroundMusic, { channel=1, loops=-1, fadein=0 })

	-- Player Music
	--playerMusic = audio.loadStream("assets/music/topGear_PlayerSounds.mp3")
	--playerMusicChannel = audio.play(playerMusic, { channel=2, loops=-1, fadein=0 })

	-- Enemy Music
	--enemyMusic = audio.loadStream("assets/music/topGear_EnemySounds2.mp3")
	--enemyMusicChannel = audio.play(enemyMusic, { channel=3, loops=-1, fadein=0 })
	
	------------------
	-- Imports
	------------------
	
	local ui = require ( "ui" )
	local transitionManager = require('transitionManager')
	local Hopper = require("hopper")
	local Enemy = require("enemy")
	local Teleporter = require("teleporter")
	local BasicBox = require("BasicBox")
	local ExtendedBox = require("ExtendedBox")


	------------------
	-- Groups
	------------------
	
	local localGroup = display.newGroup()
	
	------------------
	-- Display Objects
	------------------

	-- Layers (Groups). Think as Photoshop layers: you can order things with Corona groups,
	-- as well have display objects on the same group render together at once. 
 	_G.gameLayer    = display.newGroup()
	local bulletsLayer = display.newGroup()
	local enemiesLayer = display.newGroup()
	local starsLayer = display.newGroup()
	-- create table
	local stars = {}
	
	--====================================================================--
	-- BUTTONS
	--====================================================================--
	
	------------------
	-- Functions
	------------------
	
	local function drawStars() 
		for i = 1, stars_total do
	        	local star = {} 
	        	star.object = display.newCircle(math.random(display.contentWidth),math.random(display.contentHeight),math.random(star_radius_min,star_radius_max))
	        	stars[ i ] = star
				starsLayer:insert(star.object)
			end
	end
	
	local function drawBackground()
		background1 = display.newImage( "assets/graphics/bg1.png", 0, -656, true)
		background1:setReferencePoint(display.TopLeftReferencePoint)
		background2 = display.newImage( "assets/graphics/bg3.png", 0, -1347 -656, true)
		background2:setReferencePoint(display.TopLeftReferencePoint)
	end
	
	local function drawPlayer()
		-- Load and position the player
		player = display.newImage("assets/graphics/antmaker.png")
		player.x = display.contentCenterX
		player.y = display.contentHeight - player.contentHeight
	end
	
	local function updateBackground()
		if (frameNumber % 2 == 0) then
			background1.y = background1.y + 1
			background2.y = background2.y + 1
		end
		if (background1.y >= 1024) then
			background1.y = 0 - background1.contentHeight - (background2.contentHeight - 1024)
		end
		if (background2.y >= 1024) then
			background2.y = 0 - (background1.contentHeight - 1024) - background2.contentHeight
		end
	end
	
	local function pulseBeat()
		local event = { name="pulse", target=BasicBox }
		Runtime:dispatchEvent( event )
		timer.performWithDelay(1000, pulseBeat )
	end

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
		if event.y >= halfPlayerHeight and event.y <= display.contentHeight - halfPlayerHeight then
			-- Update player y axis
			player.y = event.y
		end
	end
	
	
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
		elseif false then --self.name == "player" and event.other.name == "enemy" then
			audio.play(sounds.gameOver)

			local gameoverText = display.newText("Game Over!", 0, 0, "HelveticaNeue", 35)
			gameoverText:setTextColor(255, 255, 255)
			gameoverText.x = display.contentCenterX
			gameoverText.y = display.contentCenterY
			_G.gameLayer:insert(gameoverText)

			-- This will stop the gameLoop
			gameIsActive = false
		end
	end
	
	-- Handler that gets notified when the alert closes
	local function onPauseSelection( event )
	        print( "index => ".. event.index .. "    action => " .. event.action )
			pauseEnd = system.getTimer()
			totalPauseTime = totalPauseTime + (pauseEnd - pauseStart)
			print ("TOTAL PAUSE TIME")
			print (totalPauseTime)
	        local action = event.action
	        if "clicked" == event.action then
	                if 1 == event.index then
						-- Main Menu
						gameIsActive = false
						director:changeScene( "menu", "fade" )
					elseif 2 == event.index then
						-- Change Level
						gameIsActive = false
						director:changeScene( "levelSelector", "fade" )
	                elseif 3 == event.index then
						-- Resume Game
						print "RESUME GAME"
						gameIsActive = true
						audio.resume(backgroundMusicChannel)
						physics.start()
					end
	        end
	end
	
	local btPauset = function ( event )
		if event.phase == "release" then
			gameIsActive = false
			physics.pause()
			print (system.getTimer())
			audio.pause(backgroundMusicChannel)
			pauseStart = system.getTimer()
			-- Show alert
			local alert = native.showAlert( "Game Options", "Choose one:", 
				{ "Main Menu", "Change Level", "Resume Game" }, onPauseSelection )
		end
	end

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
	
	local function init_track(track, file)--(fh)

		print ("INIT TRACK")
		--fh is assumed to be open
		local path = system.pathForFile(file)
		
		local tt_p1 = io.open(path, "r")

		local num = tt_p1:read("*l")
		local i = 1

		if tt_p1 then
			while num do
				track[i] = tonumber(num)
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

	--local function init_track(songTitle, trackNo)--(fh)

--		local notes = ""
--		--fh is assumed to be open
--		local path = system.pathForFile(file)
--		--local path = system.pathForFile("trackTimes4Trim.txt")
--
--		local tt_p1 = io.open(path, "r")
--
--		local num = tt_p1:read("*l")
--		local i = 1
--
--		if tt_p1 then
--			while num do
--				track[i] = tonumber(num)
--				num = tt_p1:read("*l")
--				i = i + 1
--			end
--		else	
--		end
--	end
	
	local timeout = function ( event )
		local o
		o = event.time
		return o
	end



	
	-- update star locations and setcolor
	local function updateStars(event)
			if (gameIsActive) then
	        	for i = stars_total,1, -1 do
		                if (i < stars_field1) then
		                        stars[i].object:setFillColor(150,150,150)
		                        starspeed = 0.6
		                end
		                if (i < stars_field2 and i > stars_field1) then
		                        stars[i].object:setFillColor(175,175,175)
		                        starspeed = 1
		                end
		                if (i < stars_field3 and i > stars_field2) then
		                        stars[i].object:setFillColor(175,175,175)
		                        starspeed = 2.5
		                end
						if (i < stars_field4 and i > stars_field3) then
		                        stars[i].object:setFillColor(200,200,200)
		                        starspeed = 4
		                end
		                stars[i].object.y  = stars[i].object.y + starspeed      
		                if (stars[i].object.y > display.contentHeight) then
		                        stars[i].object.y = stars[i].object.y-display.contentHeight
		                end
		        end
			end
	end
	
	--====================================================================--
	-- INITIALIZE
	--====================================================================--
	
	local initVars = function ()
		
		------------------
		-- Inserts
		------------------
		
		localGroup:insert( _G.gameLayer )

		------------------
		-- Positions
		------------------
		
		-- Hide status bar, so it won't keep covering our game objects
		display.setStatusBar(display.HiddenStatusBar)
		
		-- Load and start physics
		local physics = require("physics")
		physics.start()
		physics.setGravity(0, 0)		
		
		-- Adjust the volume
		audio.setMaxVolume( 0.85, { channel=1 } )

		drawStars()
		drawBackground()
		drawPlayer()
		
		_G.gameLayer:insert(background1)
		_G.gameLayer:insert(background2)
		_G.gameLayer:insert(starsLayer)
		_G.gameLayer:insert(bulletsLayer)
		_G.gameLayer:insert(enemiesLayer)

		-- Add a physics body. It is kinematic, so it doesn't react to gravity.
		physics.addBody(player, "kinematic", {bounce = 0})

		-- This is necessary so we know who hit who when taking care of a collision event
		player.name = "player"
		player:toFront()
		-- Listen to collisions
		player.collision = onCollision
		player:addEventListener("collision", player)

		-- Add to main layer
		_G.gameLayer:insert(player)

		-- Store half width, used on the game loop
		halfPlayerWidth = player.contentWidth * .5
		halfPlayerHeight = player.contentHeight * .5
		
		-- Show the score
		scoreText = display.newText(score, 0, 0, "HelveticaNeue", 35)
		scoreText:setTextColor(255, 255, 255)
		scoreText.x = 30
		scoreText.y = 25
		_G.gameLayer:insert(scoreText)
		btPause.x = 740
		btPause.y = 25
		localGroup:insert( btPause )
		pulseBeat()

		--------------------------------------------------------------------------------
		-- Game loop
		--------------------------------------------------------------------------------

		local function gameLoop(event)
			
			frameNumber = frameNumber + 1
 
			if p1_track[1] == 0 then
			--	local offset = timer.performWithDelay(0, timeout )
			--	playTime = playTime + offset
				init_track(p1_track, "assets/midi/trackTimes4.txt")
				init_track(p2_track, "assets/midi/trackTimes4.txt")
			end
			
			
			if gameIsActive then
				-- Remove collided enemy planes
				for i = 1, #toRemove do
					if (toRemove[i]) then
						toRemove[i].parent:remove(toRemove[i])
						toRemove[i] = nil
					end
				end
				
				updateBackground()

				-- Check if it's time to spawn another enemy,
				-- based on a random range and last spawn (timeLastEnemy)
				if ((event.time - timeLastEnemy) >= (math.random(1000, 1500))) then
					basicBox = BasicBox.new()
					basicBox.init()
					timeLastEnemy = event.time
				end

				-- Spawn a bullet
				if (event.time - timeLastBullet - totalPauseTime >= playTime) then
					local bullet = display.newImage("assets/graphics/bullet5.png")
					local temp = playTime
					bullet.x = player.x
					bullet.y = player.y - halfPlayerWidth

					-- Kinematic, so it doesn't react to gravity.
					physics.addBody(bullet, "kinematic", {bounce = 0})
					bullet.name = "bullet"

					-- Listen to collisions, so we may know when it hits an enemy.
					bullet.collision = onCollision
					bullet:addEventListener("collision", bullet)

					_G.gameLayer:insert(bullet)
					
					pos = pos + 1
					valDiff = p1_track[pos+1] - p1_track[pos]
					playTime = valDiff * 1764.7058823

					--This takes care of the error 
					playTime = playTime - ((event.time - timeLastBullet) - temp) --playTime * 0.5

					
					-- Move it to the top.
					-- When the movement is complete, it will remove itself: the onComplete event
					-- creates a function to will store information about this bullet and then remove it.
					
					duration = math.max(playTime, 1000)
					duration = math.min(duration, 5000)
					local trans1 = transitionManager:newTransition(bullet, {time = duration, y = player.y - 1000,
						onComplete = function(self) self.parent:remove(self); self = nil; end
					})

					timeLastBullet = event.time
				end
			end
		end

		-- Call the gameLoop function EVERY frame,
		-- e.g. gameLoop() will be called 30 times per second in our case.
		Runtime:addEventListener("enterFrame", gameLoop)
		Runtime:addEventListener("enterFrame", updateStars)		
		player:addEventListener("touch", playerMovement)
		
	end	
	
	initVars()
		
	return localGroup
	
end

