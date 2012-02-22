module(..., package.seeall)

--====================================================================--
-- BOOK PAGES
--====================================================================--

--[[

 - Version: 1.0
 - Made by Ricardo Rauber Pereira @ 2011
 - Blog: http://rauberlabs.blogspot.com/
 - Mail: ricardorauber@gmail.com

******************
 - INFORMATION
******************

  - Create pages dynamically.

--]]

new = function ( params )

	------------------
	-- Groups
	------------------

	local localGroup = display.newGroup()
	
	------------------
	-- Image
	------------------
	
	local image = display.newImageRect( params.image, _W, _H )
	image.x = _W / 2
	image.y = _H / 2
	localGroup:insert( image )
	
	------------------
	-- Swipe text
	------------------
	
	local swipeText = display.newText( "<- Swipe to change image ->", 0, 0, nil, 20 )
	swipeText:setTextColor( 255, 255, 255 )
	swipeText:setReferencePoint( display.CenterReferencePoint )
	swipeText.x = _W / 2
	swipeText.y = _H - 40
	localGroup:insert( swipeText )
	
	------------------
	-- Show current page
	------------------
	
	localGroup.start = function()
		print( "Current page: " .. params.name )
	end
	
	------------------
	-- MUST return a display.newGroup()
	------------------
	
	return localGroup
	
end