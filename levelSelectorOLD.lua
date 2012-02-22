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
	
	local background = display.newImage( "assets/graphics/background2.png" )
	local title      = display.newText( "Level Selector", 0, 0, native.systemFontBold, 16 )

	--====================================================================--
	-- BUTTONS
	--====================================================================--
	
	------------------
	-- Functions
	------------------
	
	local btLevel1 = function ( event )
		if event.phase == "release" then
			
			director:changeScene( "level2", "fade" )
		end
	end
	--
	local btLevel2 = function ( event )
		if event.phase == "release" then
			director:changeScene( "level2", "fade" )
		end
	end
	--
	local btLevel3 = function ( event )
		if event.phase == "release" then
			director:changeScene( "level1", "fade" )
		end
	end
	
	------------------
	-- UI Objects
	------------------
	
	local btLevel1 = ui.newButton{
					default = "assets/graphics/bt_moveFromLeft.png",
					over = "assets/graphics/bt_moveFromLeft.png",
					onEvent = btLevel1t,
					id = "btLevel1"
	}
	--
	local btLevel2 = ui.newButton{
					default = "assets/graphics/bt_overFromRight.png",
					over = "assets/graphics/bt_overFromRight.png",
					onEvent = btLevel2t,
					id = "btLevel2"
	}
	--
	local btLevel3 = ui.newButton{
					default = "assets/graphics/bt_overFromRight.png",
					over = "assets/graphics/bt_overFromRight.png",
					onEvent = btLevel3t,
					id = "btLevel3"
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
		localGroup:insert( btLevel1 )
		localGroup:insert( btLevel2 )
		localGroup:insert( btLevel3 )
	
		------------------
		-- Positions
		------------------
		
		title.x = 160
		title.y = 20
		--
		btLevel1.x = 85
		btLevel1.y = 70
		--
		btLevel2.x = 85
		btLevel2.y = 130
		--
		btLevel3.x = 85
		btLevel3.y = 190
		
		title:setTextColor( 255,255,255 )
	end
	
	initVars()
	
	return localGroup
	
end
