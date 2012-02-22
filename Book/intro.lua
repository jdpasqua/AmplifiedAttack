module(..., package.seeall)

--====================================================================--
-- SCENE: INTRO
--====================================================================--

--[[

 - Version: 1.0
 - Made by Ricardo Rauber Pereira @ 2011
 - Blog: http://rauberlabs.blogspot.com/
 - Mail: ricardorauber@gmail.com

******************
 - INFORMATION
******************

  - App introduction.

--]]

function new()

	------------------
	-- DISPLAY GROUPS
	------------------

	local localGroup = display.newGroup()

	------------------
	-- TITLE
	------------------
	
	local title = display.newText( "Porto Alegre", 0, 0, nil, 40 )
	title:setReferencePoint( display.CenterReferencePoint )
	title.x = _W / 2
	title.y = _H / 2
	localGroup:insert( title )
	
	------------------
	-- APP CREDITS
	------------------
	
	local appCred = display.newText( "Developed by http://rauberlabs.blogspot.com/", 0, 0, nil, 20 )
	appCred:setTextColor( 255, 255, 255 )
	appCred:setReferencePoint( display.CenterReferencePoint )
	appCred.x = _W / 2
	appCred.y = _H / 4 * 3 - 40
	localGroup:insert( appCred )
	--
	local goRauberLabs = function ( event )
		if event.phase == "ended" then
			system.openURL( "http://rauberlabs.blogspot.com/" )
		end
	end
	appCred:addEventListener( "touch", goRauberLabs )
	
	------------------
	-- PICTURES CREDITS
	------------------
	
	local picCred = display.newText( "Photos by http://www.portoimagem.com/", 0, 0, nil, 20 )
	picCred:setTextColor( 255, 255, 255 )
	picCred:setReferencePoint( display.CenterReferencePoint )
	picCred.x = _W / 2
	picCred.y = _H / 4 * 3
	localGroup:insert( picCred )
	--
	local goPorto = function ( event )
		if event.phase == "ended" then
			system.openURL( "http://www.portoimagem.com/" )
		end
	end
	picCred:addEventListener( "touch", goPorto )

	------------------
	-- BACKGROUND
	------------------

	local background = display.newRect( 0, 0, _W, _H )
	background:setFillColor( 0, 0, 0 )
	background.x = _W / 2
	background.y = _H / 2
	localGroup:insert( background )
	
	------------------
	-- VARIABLES
	------------------

	local showFx
	local fxTime = 2000
	local safeDelay = 50
	
	------------------
	-- CREATE BOOK
	------------------
	
	local function createBook ( event )
	
		------------------
		-- TURN TO BOOK
		------------------
	
		director:turnToBook ()
		
		------------------
		-- CREATE BOOK
		------------------
		
		director:newBookPages( pageList )
		
	end

	------------------
	-- FADE EFFECT
	------------------
	
	local endFade = function ()
		showFx = transition.to ( background, { alpha = 1, time = fxTime, delay = fxTime * 2, onComplete = createBook } )
	end
	--
	showFx = transition.to ( background, { alpha = 0, time = fxTime, onComplete = endFade } )
	
	------------------
	-- RETURN
	------------------
	
	return localGroup
	
end