module(..., package.seeall)

--====================================================================--
-- SCENE: MAIN MENU
--====================================================================--

new = function ( params )
	
	------------------
	-- Variables
	------------------
	
	_G.gameIsActive = true
	local scoreText
	local sounds
	local score = 0
	local toRemove = {}
	local background1
	local background2
	local halfPlayerWidth
	local halfPlayerHeight
	local stars_total = 153
	local stars_field1= 50
	local stars_field2= 140
	local stars_field3= 150
	local stars_field4= 154
	local star_radius_min  = 2
	local star_radius_max  = 3
	
	local areTracksInit = 0
	
	local tempo = {}
	tempo[1] = {}
	tempo[2] = {}
	tempo[3] = {}
	tempo[4] = {}
	tempo[5] = {}
	tempo[6] = {}
	tempo[7] = {}
	tempo[8] = {}
	tempo[9] = {}
	tempo[10] = {}
	tempo[11] = {}
	
	local notes = {}
	notes[1] = {}
	notes[2] = {}
	notes[3] = {}
	notes[4] = {}
	notes[5] = {}
	notes[6] = {}
	notes[7] = {}
	notes[8] = {}
	notes[9] = {}
	notes[10] = {}
	notes[11] = {}
	
	local playhead = {}
	playhead[1] = 1
	playhead[2] = 1
	playhead[3] = 1
	playhead[4] = 1
	playhead[5] = 1
	playhead[6] = 1
	playhead[7] = 1
	playhead[8] = 1

	local bpm = 110;
	local timeConvert = 0;
	
	local track1_LastBullet = 0; 
	local track1_pos = 0
	local track1_valDiff = 0
	local track1_playTime = 4300	
		
	local pos = 0
	local valDiff = 0
	local playTime = 3350
	local textureCache = {}
	local timeLastBullet, timeLastEnemy = 0, 0
	local bulletInterval = 1000
	local frameNumber = 0
	local totalPauseTime = 0
	local pauseStart
	local pauseEnd
	local basicBox
	local playerCollisionFilter = { categoryBits = 1, maskBits = 12 }
	local playerBulletCollisionFilter = { categoryBits = 2, maskBits = 4 }
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
	--backgroundMusicChannel = audio.play(backgroundMusic, { channel=1, loops=-1, fadein=0 })

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
	local Skrillot = require("Skrillot")
	local HomingHornet = require("HomingHornet")
	local Player = require("Player")


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
	_G.bulletsLayer = display.newGroup()
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
		local event = { name="pulse" }
		Runtime:dispatchEvent( event )
		--timer.performWithDelay( 500, pulseBeat )
	end

	local function trackEvent(trackno)
		local event = {name=string.format("track%d", trackno)}
		Runtime:dispatchEvent( event )
		local pos = playhead[trackno]		
		
		--check if you are at the end of the track
		if tempo[trackno][pos+1] == nil then
			playhead[trackno] =  1
			pos = 1
		end 
		
		local valDiff = tempo[trackno][pos+1] - tempo[trackno][pos]
		local playTime = valDiff * timeConvert --1764.7058823
		--This takes care of the error ratio
	--	playTime = playTime - ((event.time - timeLastBullet) - temp) --playTime * 0.5
		
		playhead[trackno] = pos + 1
		
		local myClosure = function() return trackEvent(trackno) end
		timer.performWithDelay(playTime, myClosure, 1)
	end


	
	-- Take care of collisions
	local function onCollision(self, event)
		-- Bullet hit enemy
		if self.name == "bullet" and event.other.name == "enemy" and _G.gameIsActive and event.other then --and event.other.alive == "yes"
			-- Increase score
			score = score + 1
			scoreText.text = score
			
			--event.other.alive = "no"
			-- Play Sound
			audio.play(sounds.boom)

			-- We can't remove a body inside a collision event, so queue it to removal.
			-- It will be removed on the next frame inside the game loop.
			table.insert(toRemove, event.other)
			if (event.other.type == "Skrillot") then
				Runtime:removeEventListener("track7", event.other)
			elseif (event.other.type == "Skrillot") then
				Runtime:removeEventListener("track7", event.other)
			else	
				Runtime:removeEventListener("pulse", event.other)
			end			
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
	
	-- Handler that gets notified when the alert closes
	local function onPauseSelection( event )
	        print( "index => ".. event.index .. "    action => " .. event.action )
			pauseEnd = system.getTimer()
			totalPauseTime = totalPauseTime + (pauseEnd - pauseStart)
			print (totalPauseTime)
	        local action = event.action
	        if "clicked" == event.action then
	                if 1 == event.index then
						-- Main Menu
						_G.gameIsActive = false
						director:changeScene( "menu", "fade" )
					elseif 2 == event.index then
						-- Change Level
						_G.gameIsActive = false
						director:changeScene( "levelSelector", "fade" )
	                elseif 3 == event.index then
						-- Resume Game
						print "RESUME GAME"
						_G.gameIsActive = true
						audio.resume(backgroundMusicChannel)
						physics.start()
					end
	        end
	end
	
	local btPauset = function ( event )
		if event.phase == "release" then
			_G.gameIsActive = false
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
	
	local function init_tracks(track, file)--(fh)
		for i = 1, 11 do --11
			
			--format file names
			local tempofn = string.format("assets/MidiExtraction/TopGear/track%u_tempo.txt", i)
			local notefn = string.format("assets/MidiExtraction/TopGear/track%u_notes.txt", i)
			
			local tempofile = system.pathForFile(tempofn)
			local notefile = system.pathForFile(notefn)
			
			--open tempo and note files
			local track_tempo = io.open(tempofile, "r")
			local track_notes = io.open(notefile, "r")
			
			--read tempos into array
			local num = track_tempo:read("*l")
			local j = 1

			if track_tempo then
				while num do
					tempo[i][j] = tonumber(num)
					num = track_tempo:read("*l")
					j = j + 1
				end
			end
			
			--read notes into array
			note = track_notes:read("*l")
			j = 1

			if track_notes then
				while note ~= nil do
					notes[i][j] = note
					note = track_notes:read("*l")
					j = j + 1
				end
			else 
				print ("\n\nKABOOM\n\n")
			end	
			
			print (j)		
		end
	end
	
	local function calc_tempo_conversion ()
			local bps = bpm / 60
			local time = (1 / bps) * 4 * 1000
			return time
	end
	
	
	local timeout = function ( event )
		local o
		o = event.time
		return o
	end




	
	-- update star locations and setcolor
	local function updateStars(event)
			if (_G.gameIsActive) then
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
		--drawPlayer()
		
		_G.gameLayer:insert(background1)
		_G.gameLayer:insert(background2)
		_G.gameLayer:insert(starsLayer)
		_G.gameLayer:insert(bulletsLayer)
		_G.gameLayer:insert(enemiesLayer)
		
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
		_G.player = Player.new()
		--------------------------------------------------------------------------------
		-- Game loop
		--------------------------------------------------------------------------------

		local function gameLoop(event)
			
			frameNumber = frameNumber + 1
 
			if areTracksInit == 0 then
				init_tracks()
				areTracksInit = 1
				timeConvert = calc_tempo_conversion()

				trackEvent(1)
				trackEvent(2)
				trackEvent(3)
				trackEvent(4)
				trackEvent(5)
				trackEvent(6)
				trackEvent(7)
				trackEvent(8)
				--print (string.format("===================TIME CONVERT=%d", timeConvert)) -- TIME CONVERT CHECK
			end
			
			
			if _G.gameIsActive then
				-- Remove collided enemy planes
				for i = 1, #toRemove do
					if (toRemove[i] and toRemove[i].parent) then
						toRemove[i].parent:remove(toRemove[i])
						toRemove[i] = nil
					end
				end
				
				updateBackground()

				-- Check if it's time to spawn another enemy,
				-- based on a random range and last spawn (timeLastEnemy)
				if ((event.time - timeLastEnemy) >= (math.random(1000, 1500))) then
					if (math.random(10) <= 10) then
						basicBox = Skrillot.new()
					else 
						basicBox = HomingHornet.new()
					end
					timeLastEnemy = event.time
				end

				-- Spawn a bullet
				if (event.time - timeLastBullet - totalPauseTime >= playTime) then
					local bullet = display.newImage("assets/graphics/bullet5.png")
					local temp = playTime
					bullet.x = _G.player.x
					bullet.y = _G.player.y

					-- Kinematic, so it doesn't react to gravity.
					physics.addBody(bullet, "dynamic", {bounce = 0, filter = playerBulletCollisionFilter})
					bullet.name = "bullet"

					-- Listen to collisions, so we may know when it hits an enemy.
					bullet.collision = onCollision
					bullet:addEventListener("collision", bullet)
					bullet.alive = true

					_G.gameLayer:insert(bullet)
					
				--	local pos2 = pos + 1
				--	valDiff = p1_track[pos+1] - p1_track[pos]
				--	while (notes[4][pos2] ~= "C--") do
					pos = pos + 1
				--		print (string.format("---pos2 = ", notes[4][pos2]))
				--	end	
					local playerTrack = 4
					if tempo[playerTrack][pos+1] == nil then
						pos = 1
					end 
					valDiff = tempo[playerTrack][pos+1] - tempo[playerTrack][pos]
					
					playTime = valDiff * timeConvert --1764.7058823
					--This takes care of the error ratio
					playTime = playTime - ((event.time - timeLastBullet) - temp) --playTime * 0.5
					
					pulseBeat()
					
					-- Move it to the top.
					-- When the movement is complete, it will remove itself: the onComplete event
					-- creates a function to will store information about this bullet and then remove it.
					
					duration = math.max(playTime, 1000)
					duration = math.min(duration, 5000)
					local trans1 = transitionManager:newTransition(bullet, {time = duration, y = _G.player.y - 1000,
						onComplete = function(self) self.parent:remove(self); self = nil; end
					})

					timeLastBullet = event.time
				end
				
			--	if (event.time - track1_LastBullet - totalPauseTime >= 3000) then
		--			local temp = track1_playTime
		--			track1_pos = track1_pos + 1
		--			track1_valDiff = tempo[4][pos+1] - tempo[4][pos]
		--			track1_playTime = track1_valDiff * 1764.7058823
--
					--This takes care of the error ratio 
--					track1_playTime = track1_playTime - ((event.time - track1_LastBullet) - temp)
				
--					pulseBeat()
					
--				end
			end
		end

		-- Call the gameLoop function EVERY frame,
		-- e.g. gameLoop() will be called 30 times per second in our case.
		Runtime:addEventListener("enterFrame", gameLoop)
		Runtime:addEventListener("enterFrame", updateStars)		
		
	end	
	
	initVars()
		
	return localGroup
	
end

