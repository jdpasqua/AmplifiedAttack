module(..., package.seeall)
require "sprite"
--====================================================================--
-- SCENE: MAIN MENU
--====================================================================--

new = function ( params )

	------------------
	-- Variables
	------------------

	_G.gameIsActive = true
	_G.score = 0
	_G.toRemove = {}
	_G.combo = 0
	local background1
	local background2
	local halfPlayerWidth
	local halfPlayerHeight


	local areTracksInit = 0

	local tempo = {}
	tempo[1] = {}
	tempo[2] = {}
	tempo[3] = {}
	tempo[4] = {}
--[[	tempo[5] = {}
	tempo[6] = {}
	tempo[7] = {}
	tempo[8] = {}
	tempo[9] = {}
	tempo[10] = {}
	tempo[11] = {}
	tempo[12] = {}
	tempo[13] = {}
	tempo[14] = {}
	tempo[15] = {}
	tempo[16] = {}
	tempo[17] = {}
]]
	local notes = {}
	notes[1] = {}
	notes[2] = {}
	notes[3] = {}
	notes[4] = {}
--[[	notes[5] = {}
	notes[6] = {}
	notes[7] = {}
	notes[8] = {}
	notes[9] = {}
	notes[10] = {}
	notes[11] = {}
	notes[12] = {}
	notes[13] = {}
	notes[14] = {}
	notes[15] = {}
	notes[16] = {}
	notes[17] = {}
]]
	local playhead = {}
	playhead[1] = 1
	playhead[2] = 1
	playhead[3] = 1
	playhead[4] = 1
--[[	playhead[5] = 1
	playhead[6] = 1
	playhead[7] = 1
	playhead[8] = 1
	playhead[9] = 1
	playhead[10] = 1
	playhead[11] = 1
	playhead[12] = 1
	playhead[13] = 1
	playhead[14] = 1
	playhead[15] = 1
	playhead[16] = 1
	playhead[17] = 1
]]	
	--swarms - this indicates how many enemies to send out each swarm (swarm = per note). Limit the notes in spawnEnemy funct.
	--each element in the array is 1 swarm. The next swarm doesn't begin spawning until 
	local swarms = {{{"Skrillot", "Skrillot"}, {"Skrillot"}},
					{{"Skrillot", "Skrillot"}, {"Skrillot"}},
					{{"Skrillot", "Skrillot"}, {"Skrillot"}},
					{{"Skrillot", "Skrillot"}, {"Skrillot"}},
					{{"Skrillot", "Skrillot"}, {"HomingHornet"}},
					{{"HomingHornet", "Skrillot"}, {"HomingHornet"}},
					{{"Skrillot", "Skrillot"}, {"HomingHornet"}, {"Skrillot", "HomingHornet"}},
					{{"HomingHornet", "Skrillot"}, {"HomingHornet"}, {"HomingHornet"}},
					{{"Skrillot", "HomingHornet"}, {"HomingHornet"}, {"Skrillot"}, {"HomingHornet"}},
					{{"Skrillot", "Skrillot"}, {"HomingHornet"}, {"HomingHornet"}},
					{{"HomingHornet", "Skrillot"}, {"HomingHornet"}},
					{{"Skrillot", "Skrillot"}, {"HomingHornet"}},
					{{"HomingHornet", "Skrillot"}, {"HomingHornet"}},
					{{"Skrillot", "HomingHornet"}, {"Skrillot"}},
					{{"Skrillot", "HomingHornet"}, {"HomingHornet"}}}
	--these are enemy entrance/spawn instructions, even tho this is hard coded now, it will be easy to make a function to generate 
	-- patterns eventually. Separate swarms with newlines to easily visualize. Max number of enemies can be set below.(see spawnData)
	-- this will be heavily changed in structure as well, but thought I would commit for now anyways
	local spawnEntrance = {}
	--Swarm#1
--[[	spawnEntrance[1] = {enemy = "Skrillot", xpos = display.contentWidth / 8 , ypos = -50, direction = "straight", speed = 500, distance = display.contentHeight / 2 - 400}
	spawnEntrance[2] = {enemy = "Skrillot", xpos = 7 * display.contentWidth / 8, ypos = -50, direction = "straight", speed = 500, distance = display.contentHeight / 2 - 400}

	--Swarm#2
	spawnEntrance[3] = {enemy = "Skrillot", xpos = 4 * display.contentWidth / 8, ypos = -50, direction = "straight", speed = 1000, distance = display.contentHeight / 2 - 300}

	spawnEntrance[4] = {enemy = "Skrillot", xpos = display.contentWidth / 6 , ypos = -30, direction = "straight", speed = 2000, distance = display.contentHeight / 2 - 100}
	
	spawnEntrance[5] = {enemy = "Skrillot", xpos = 2 * display.contentWidth / 6, ypos = -30, direction = "straight", speed = 2000, distance = display.contentHeight / 2 - 50}

	spawnEntrance[6] = {enemy = "Skrillot", xpos = 3 * display.contentWidth / 6, ypos = -30, direction = "straight", speed = 2000, distance = display.contentHeight / 2}
	
	spawnEntrance[7] = {enemy = "Skrillot", xpos = 4 * display.contentWidth / 6, ypos = -30, direction = "straight", speed = 2000, distance = display.contentHeight / 2 - 50}
	
	spawnEntrance[8] = {enemy = "Skrillot", xpos = 5 * display.contentWidth / 6, ypos = -30, direction = "straight", speed = 2000, distance = display.contentHeight / 2 - 100}
]]	
	local spawnData = {} -- {current number, max number, [...]}
	spawnData["Skrillot"] = {count = 0, maxNum = 5}
	_G.enemyCount = 0
	
	local bpm = 75; --136;
	local timeConvert = 0;	

	local pos = 0
	local valDiff = 0
--	local playTime = 3350
	local textureCache = {}
	local timeLastBullet, timeLastEnemy = 0, 0
	local bulletInterval = 1000
	local frameNumber = 0
	_G.totalPauseTime = 0
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
	
		--local pow_sheet = sprite.newSpriteSheet("assets/graphics/pow2.png", 200, 145)
		local pow_sheet = sprite.newSpriteSheet("assets/graphics/pow2.png", 200, 145)
		local boom_sheet = sprite.newSpriteSheet("assets/graphics/boom1.png", 96, 96)

		--	_G.SPEAKER_PURPLE = display.newImage("assets/graphics/trumpet_purple.png")
		_G.boom_Set = sprite.newSpriteSet(boom_sheet, 1, 12)--6)
		_G.pow_Set = sprite.newSpriteSet(pow_sheet, 1, 6)--6)
		
	--	local powSet1 = sprite.newSpriteSet
	--	sprite.add( pow_sheet, "pow", 1, 4, 1000, 0 )
	_G.trumpetQ = 1;
	_G.trumpet = {
		--	pew = audio.loadSound("assets/sounds/pew.wav"),
			audio.loadSound("assets/sounds/trumpet_Bb.mp3"),
			audio.loadSound("assets/sounds/trumpet_Eb.mp3"),
			audio.loadSound("assets/sounds/trumpet_Db.mp3")
			
		--	gameOver = audio.loadSound("assets/sounds/gameOver.wav")
	}
	_G.explosionQ = 1;
	_G.explosion = {audio.loadSound("assets/sounds/future_flute.mp3")}
	-----------------------
	--  Music Channels
	--1 = Background Music
	--2 = Player Music
	--3 = Enemy Music
	-----------------------

	-- Background music
	backgroundMusic = audio.loadStream("assets/sounds/untitled.mp3")--TopGear3.mp3")

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
	local Teleporter = require("teleporter")
	local BasicBox = require("BasicBox")
	local ExtendedBox = require("ExtendedBox")
	local Skrillot = require("Skrillot")
	local HomingHornet = require("HomingHornet")
	local Player = require("Player")
	local TrackSwitching = require("trackSwitching")
	local Boundaries = require("boundaries")
	local Background = require("background")

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

	--====================================================================--
	-- BUTTONS
	--====================================================================--

	------------------
	-- Functions
	------------------

	local function pulseBeat()
		local event = { name="pulse" }
		Runtime:dispatchEvent( event )
		--timer.performWithDelay( 500, pulseBeat )
	end

	local function trackEvent(trackno)
		local curTime = system.getTimer() - _G.totalPauseTime --os.difftime(os.time(), launchTime)
		local pos = playhead[trackno]
		local eName = "track" .. trackno
		local event = {name=eName, note=notes[trackno][pos]}
		local targetTime = (tempo[trackno][pos] * timeConvert)
	--	print (string.format("..............%f\n", pos))
		
		local playTime = 0

		if pos > 1 then
			Runtime:dispatchEvent( event )
			local prevTargetTime = (tempo[trackno][pos - 1] * timeConvert) 
			playTime = targetTime - prevTargetTime --1764.7058823
			--fixes error in the playTime calculation (thinking you are in the right place when you aren't)
			playTime = playTime - (curTime - prevTargetTime) --playTime * 0.5
		--	print (string.format("playTime = %f     targetTime = %f     prevTargetTime = %f     curTime = %d\n", playTime, targetTime, prevTargetTime, curTime))
		else
			playTime = (tempo[trackno][pos] * timeConvert)		
		end
	
		playhead[trackno] = pos + 1
		
		local myClosure = function() return trackEvent(trackno) end
		timer.performWithDelay(playTime, myClosure)	
	end

	-- Handler that gets notified when the alert closes
	local function onPauseSelection( event )
		print( "index => ".. event.index .. "    action => " .. event.action )
		pauseEnd = system.getTimer()
		_G.totalPauseTime = _G.totalPauseTime + (pauseEnd - pauseStart)
		print (_G.totalPauseTime)
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
		for i = 1, 4 do --17 do --11
			--format file names
			local tempofn = string.format("assets/MidiExtraction/untitled/track%u_tempo.txt", i)
			local notefn = string.format("assets/MidiExtraction/untitled/track%u_notes.txt", i)

			local tempofile = system.pathForFile(tempofn)
			local notefile = system.pathForFile(notefn)

			--open tempo and note files
			local track_tempo = io.open(tempofile, "r")
			local track_notes = io.open(notefile, "r")

			--read tempos into array
			local num = track_tempo:read("*l")
			local j = 1

			if track_tempo then
		--		print ("*********************")
				while num do
					tempo[i][j] = tonumber(num)
		--			print (string.format("%f", tempo[i][j]))
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
		print ("DONE___________________________________")
	end

	local function calc_tempo_conversion ()
		local bps = bpm / 60
		local time = (1 / bps) * 1000
		return time
	end


	local timeout = function ( event )
		local o
		o = event.time
		return o
	end

	-- Spawn Enemy
	local function spawnEnemy (event)
	--	print("SPAWN")
--	if (event.note == 'F--') then
--local swarmed = false
		if swarms[1][1] then
			for i = 1, #swarms[1][1] do
				--	if (spawnData["Skrillot"].count < spawnData["Skrillot"].maxNum) then
				--		spawnData["Skrillot"].count = spawnData["Skrillot"].count + 1 
				if (spawnEntrance[1].enemy == "Skrillot") then
					basicBox = Skrillot.new(1, spawnEntrance[1])
				else
					basicBox = HomingHornet.new(1, spawnEntrance[1])
				end
					table.remove(spawnEntrance, 1)
					basicBox.init()
					spawnData["Skrillot"].count = spawnData["Skrillot"].count + 1
					swarmed = true
					_G.enemyCount = _G.enemyCount + 1
			--	end
				--	end
			end
			table.remove(swarms[1], 1)
		else 
			if (swarms[1] and _G.enemyCount == 0) then
				table.remove(swarms, 1)
			end
		end 
--[[if swarmed then
	table.remove(swarms, 1)
end]]
	end

	
	local function generateEntrances()
		-- swarmEnemies = random, ratio, or setType
		-- formation
		for i = 1, #swarms do 
			for j = 1, #swarms[i] do 
				--for k = 2, swarms[i][j][1] do
					if #swarms[i][j] == 1 then
						local rand = math.random(1,7)
						table.insert(spawnEntrance, {enemy = swarms[i][j][1], xpos = rand * display.contentWidth / 8 , ypos = -50, direction = "straight", speed = 500, distance = display.contentHeight / 2 - 300})
					elseif #swarms[i][j] == 2 then
						local rand = math.random(1,3)
						table.insert(spawnEntrance, {enemy = swarms[i][j][1], xpos = rand * display.contentWidth / 8 , ypos = -50, direction = "straight", speed = 500, distance = display.contentHeight / 2 - 400})
						table.insert(spawnEntrance, {enemy = swarms[i][j][2], xpos = (8 - rand) * display.contentWidth / 8 , ypos = -50, direction = "straight", speed = 500, distance = display.contentHeight / 2 - 400})
					elseif swarms[i] == 3 then
				
					elseif swarms[i] == 4 then
			
					end
				--end
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

		Background.init()
		
		_G.gameLayer:insert(bulletsLayer)
		_G.gameLayer:insert(enemiesLayer)

		-- Show the score
		_G.scoreText = display.newText(score, 0, 0, "HelveticaNeue", 35)
		_G.scoreText:setTextColor(255, 255, 255)
		_G.scoreText.x = 30
		_G.scoreText.y = 25
		_G.gameLayer:insert(_G.scoreText)
		btPause.x = 740
		btPause.y = 25
		localGroup:insert( btPause )

		pulseBeat()

		_G.player = Player.new()
		Runtime:addEventListener("track2", spawnEnemy)

		_G.trackButtons = TrackSwitching.new()
		
		local boundaries = Boundaries.new()

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
		--[[		trackEvent(5)
				trackEvent(6)
				trackEvent(7)
				trackEvent(8)
				trackEvent(9)
				trackEvent(10)
				trackEvent(11)]]
				generateEntrances()
				--print (string.format("===================TIME CONVERT=%d", timeConvert)) -- TIME CONVERT CHECK
			end


			if _G.gameIsActive then
				-- Remove collided enemy planes
				for i = 1, #_G.toRemove do
					if (_G.toRemove[i] and _G.toRemove[i].parent) then
						_G.toRemove[i].parent:remove(_G.toRemove[i])
						_G.toRemove[i] = nil
					end
				end

			end
		end

		_G.totalPauseTime = system.getTimer()
		print(_G.totalPauseTime)
		backgroundMusicChannel = audio.play(backgroundMusic, { channel=1, loops=-1, fadein=0 })
		
		-- Call the gameLoop function EVERY frame,
			-- e.g. gameLoop() will be called 30 times per second in our case.
			Runtime:addEventListener("enterFrame", gameLoop)

	end	
	
	--[[
	local monitorMem = function()

	    collectgarbage()
	    print( "MemUsage: " .. collectgarbage("count") )

	    local textMem = system.getInfo( "textureMemoryUsed" ) / 1000000
	    print( "TexMem:   " .. textMem )
	end

	Runtime:addEventListener( "enterFrame", monitorMem )
	--]]
	
	initVars()

	return localGroup

end


