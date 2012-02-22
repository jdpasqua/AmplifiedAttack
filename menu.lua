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
	
	local background = display.newImage( "assets/graphics/background1.png" )
	local title      = display.newText( "Main Menu", 0, 0, native.systemFontBold, 16 )

	--====================================================================--
	-- BUTTONS
	--====================================================================--
	
	------------------
	-- Functions
	------------------
	
	local btPlayt = function ( event )
		if event.phase == "release" then
			director:changeScene( "levelSelector", "fade" )
		end
	end
	--
	local btSettingst = function ( event )
		if event.phase == "release" then
			director:changeScene( "settings", "fade" )
		end
	end
	--
	local btHelpt = function ( event )
		if event.phase == "release" then
			director:changeScene( "help", "fade" )
		end
	end
	
	------------------
	-- UI Objects
	------------------
	
	local btPlay = ui.newButton{
					default = "assets/graphics/bt_moveFromLeft.png",
					over = "assets/graphics/bt_moveFromLeft.png",
					onEvent = btPlayt,
					id = "btPlay"
	}
	--
	local btSettings = ui.newButton{
					default = "assets/graphics/bt_overFromRight.png",
					over = "assets/graphics/bt_overFromRight.png",
					onEvent = btSettingst,
					id = "btSettings"
	}
	--
	local btHelp = ui.newButton{
					default = "assets/graphics/bt_overFromRight.png",
					over = "assets/graphics/bt_overFromRight.png",
					onEvent = btHelpt,
					id = "btHelp"
	}

	--====================================================================--
	-- INITIALIZE
	--====================================================================--
	
	local initVars = function ()
		
		------------------
		-- Inserts
		------------------
		
		localGroup:insert( background )
		localGroup:insert( title )
		localGroup:insert( btPlay )
		localGroup:insert( btSettings )
		localGroup:insert( btHelp )
	
		------------------
		-- Positions
		------------------
		
		title.x = 160
		title.y = 20
		--
		btPlay.x = 85
		btPlay.y = 70
		--
		btSettings.x = 85
		btSettings.y = 130
		--
		btHelp.x = 85
		btHelp.y = 190
		
		title:setTextColor( 255,255,255 )
	end
	
	initVars()
	
	return localGroup
	
end
