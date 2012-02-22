module(..., package.seeall)

--====================================================================--
-- SCENE: TEAM LOGO SCREEN
--====================================================================--
new = function ( params )
	
	------------------
	-- Params
	------------------
	local vLabel = "Help"
	local vReload = false
	--
	if type( params ) == "table" then
		--
		if type( params.label ) == "string" then
			vLabel = params.label
		end
		--
		if type( params.reload ) == "boolean" then
			vReload = params.reload
		end
		--
	end
	
	------------------
	-- Groups
	------------------
	
	local localGroup = display.newGroup()
	
	------------------
	-- Display Objects
	------------------
	
	local background = display.newImage( "assets/graphics/background2.png" )
	local title = display.newText( vLabel, 0, 0, native.systemFontBold, 16 )
	
	------------------
	-- Listeners
	------------------
	
	local timeout = function ( event )
		director:changeScene( "menu", "crossfade" )
	end
	
	--====================================================================--
	-- INITIALIZE
	--====================================================================--
	
	local initVars = function ()
	
		localGroup:insert( background )
		localGroup:insert( title )
	
		title.x = 160
		title.y = 240
		title:setTextColor( 255,255,255 )

	    timer.performWithDelay(2000, timeout )
		
	end

	initVars()

	return localGroup
	
end
