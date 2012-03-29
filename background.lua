module (..., package.seeall)


	local stars_total = 153
	local stars_field1= 50
	local stars_field2= 140
	local stars_field3= 150
	local stars_field4= 154
	local star_radius_min  = 2
	local star_radius_max  = 3
	local background1
	local background2
	local starsLayer = display.newGroup()
	local stars = {}
	_G.redTint = display.newRect(0, 0, display.contentWidth, display.contentHeight)
	_G.redTint:setFillColor(255, 0, 0)
	_G.redTint.alpha = 0.2
	_G.redTint.isVisible = false
	
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
		background1.y = background1.y + 0.5
		background2.y = background2.y + 0.5
		
		if (background1.y >= 1024) then
			background1.y = 0 - background1.contentHeight - (background2.contentHeight - 1024)
		end
		if (background2.y >= 1024) then
			background2.y = 0 - (background1.contentHeight - 1024) - background2.contentHeight
		end
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
					stars[i].object.x = math.random(display.contentWidth)
				end
			end
		end
	end
	
	function background:init()
		drawBackground()
		drawStars()
		_G.gameLayer:insert(background1)
		_G.gameLayer:insert(background2)
		_G.gameLayer:insert(starsLayer)
		
		Runtime:addEventListener("enterFrame", updateStars)		
		Runtime:addEventListener("enterFrame", updateBackground)		
		
	end
	

