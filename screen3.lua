module(..., package.seeall)

--====================================================================--
-- POP UP: SCREEN 3
--====================================================================--

--[[

 - Version: 1.3
 - Made by Ricardo Rauber Pereira @ 2010
 - Blog: http://rauberlabs.blogspot.com/
 - Mail: ricardorauber@gmail.com

******************
 - INFORMATION
******************

  - Sample scene.

--]]

new = function ()
	
	------------------
	-- Groups
	------------------
	
	local localGroup = display.newGroup()
	
	------------------
	-- Display Objects
	------------------
	
	local w, h = display.contentWidth, display.contentHeight
	local background = display.newImage( "assets/graphics/background3.png" )
	background.xScale = 0.8
	background.yScale = 0.8
	background.alpha = 0.95
	local title = display.newText( "POP UP - Touch to go back", 0, 0, native.systemFontBold, 16 )
	
	------------------
	-- Listeners
	------------------
	
	local touched = function ( event )
		if event.phase == "ended" then
			director:closePopUp()
		end
	end
	
	--====================================================================--
	-- INITIALIZE
	--====================================================================--
	
	local function initVars ()
		
		------------------
		-- Inserts
		------------------
		
		localGroup:insert( background )
		localGroup:insert( title )
		
		------------------
		-- Positions
		------------------
		
		title.x = 160
		title.y = 240
		
		------------------
		-- Colors
		------------------
		
		title:setTextColor( 255,255,255 )
		
		------------------
		-- Listeners
		------------------
		
		background:addEventListener( "touch" , touched )
		
	end
	
	------------------
	-- Initiate variables
	------------------
	
	initVars()
	
	------------------
	-- MUST return a display.newGroup()
	------------------
	
	return localGroup
	
end
