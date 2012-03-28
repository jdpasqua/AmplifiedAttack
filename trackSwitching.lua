module (..., package.seeall)

function new()

	local buttonGlows = {}
	local trackButtons = {}
	local buttonPlayGlows = {}
	local selectedTrack = 1
	
	buttonGlows[1] =  display.newImage("assets/graphics/blue_glow.png")--display.newCircle(40, 840, 30)
	buttonGlows[1].x = 40
	buttonGlows[1].y = 850
	buttonPlayGlows[1] = display.newImage("assets/graphics/blue_PlayGlow.png")--display.newCircle(40, 840, 30)
	buttonPlayGlows[1].x = 40
	buttonPlayGlows[1].y = 850
	buttonPlayGlows[1].isVisible = false
	trackButtons[1] =  display.newImage("assets/graphics/button_up.png")--display.newCircle(40, 840, 30)
	trackButtons[1].x = 40
	trackButtons[1].y = 850	
	trackButtons[1].trackno = "track4"
	
	buttonGlows[2] =  display.newImage("assets/graphics/green_glow.png")--display.newCircle(40, 840, 30)
	buttonGlows[2].x = 40
	buttonGlows[2].y = 915
	buttonPlayGlows[2] = display.newImage("assets/graphics/green_PlayGlow.png")--display.newCircle(40, 840, 30)
	buttonPlayGlows[2].x = 40
	buttonPlayGlows[2].y = 915
	buttonPlayGlows[2].isVisible = false
 	trackButtons[2] =  display.newImage("assets/graphics/button_up.png")--display.newCircle(40, 840, 30)
	trackButtons[2].x = 40
	trackButtons[2].y = 915
	trackButtons[2].trackno = "track9"
	
	buttonGlows[3] =  display.newImage("assets/graphics/red_glow.png")--display.newCircle(40, 840, 30)
	buttonGlows[3].x = 40
	buttonGlows[3].y = 980
	buttonPlayGlows[3] = display.newImage("assets/graphics/red_PlayGlow.png")--display.newCircle(40, 840, 30)
	buttonPlayGlows[3].x = 40
	buttonPlayGlows[3].y = 980
	buttonPlayGlows[3].isVisible = false
 	trackButtons[3] =  display.newImage("assets/graphics/button_up.png")--display.newCircle(40, 840, 30)
	trackButtons[3].x = 40
	trackButtons[3].y = 980
	trackButtons[3].trackno = "track10"
	
	local buttonDown = {}
	buttonDown[1] = display.newImage("assets/graphics/button_down.png")--display.newCircle(40, 840, 30)
	buttonDown[1].x = 40
	buttonDown[1].y = 850
		
	buttonDown[2] = display.newImage("assets/graphics/button_down.png")--display.newCircle(40, 840, 30)
	buttonDown[2].x = 40
	buttonDown[2].y = 915
		
	buttonDown[3] = display.newImage("assets/graphics/button_down.png")--display.newCircle(40, 840, 30)
	buttonDown[3].x = 40
	buttonDown[3].y = 980

	
	function trackSwitch(event) 
		if (event.phase == "ended") then
			_G.player:switchTrack(event.target.trackno)
		--	print (event.target.trackno)
			local buttonNum = 1	
						
			if event.target.trackno == trackButtons[1].trackno then
				buttonNum = 1				
			elseif event.target.trackno == trackButtons[2].trackno then
				buttonNum = 2
			elseif event.target.trackno == trackButtons[3].trackno then
				buttonNum = 3
			end

			buttonDown[1].isVisible = false
			buttonDown[2].isVisible = false
			buttonDown[3].isVisible = false
			
			buttonDown[buttonNum].isVisible = true
			
		end
		
		
	end 

	local function endPulse (num)
		buttonPlayGlows[num].isVisible = false
		--print ("TURN OFF")
		--print (num)
		
	end

	function pulseButton (event)
--		print(event.name)
		--num = 1
		if event.name == "track4" then
			num = 1
		elseif event.name == "track9" then
			num = 2
		elseif event.name == "track10" then
			num = 3
		--	print ("TURN ON")
		--	print (num)
		end

		
		buttonPlayGlows[num].isVisible = true
		local myClosure = function() return endPulse(num) end
		timer.performWithDelay(50, myClosure)
	end
	
	
	
	trackButtons[1]:addEventListener("touch", trackSwitch)
	trackButtons[2]:addEventListener("touch", trackSwitch)
	trackButtons[3]:addEventListener("touch", trackSwitch)
	
	Runtime:addEventListener("track4", pulseButton)
	Runtime:addEventListener("track9", pulseButton)
	Runtime:addEventListener("track10", pulseButton)

	_G.gameLayer:insert(buttonGlows[1])
	_G.gameLayer:insert(buttonGlows[2])
	_G.gameLayer:insert(buttonGlows[3])
	
	_G.gameLayer:insert(buttonPlayGlows[1])
	_G.gameLayer:insert(buttonPlayGlows[2])
	_G.gameLayer:insert(buttonPlayGlows[3])
		
	_G.gameLayer:insert(trackButtons[1])
	_G.gameLayer:insert(trackButtons[2])
	_G.gameLayer:insert(trackButtons[3])
	
	_G.gameLayer:insert(buttonDown[1])
	_G.gameLayer:insert(buttonDown[3])
	
	buttonDown[2].isVisible = false
	buttonDown[3].isVisible = false
	
	return trackButtons
end


