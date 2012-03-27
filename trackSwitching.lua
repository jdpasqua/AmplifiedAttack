module (..., package.seeall)

function new()

	local trackButtons = {}
 	trackButtons[1] = display.newCircle(40, 840, 30)
	trackButtons[1].strokeWidth = 5
	trackButtons[1]:setStrokeColor(128,0,0)
	trackButtons[1].trackno = "track4"
	
	trackButtons[2] = display.newCircle(40, 910, 30)
	trackButtons[2]:setFillColor(255,255,255)
	trackButtons[2].strokeWidth = 5
	trackButtons[2]:setStrokeColor(128,0,0)
	trackButtons[2].trackno = "track9"
	
	trackButtons[3] = display.newCircle(40, 980, 30)
	trackButtons[3].strokeWidth = 5
	trackButtons[3]:setStrokeColor(128,0,0)
	trackButtons[3].trackno = "track10"
	
	function trackSwitch(event) 
		if (event.phase == "ended") then
			_G.player:switchTrack(event.target.trackno)
		end
	end 

	trackButtons[1]:addEventListener("touch", trackSwitch)
	trackButtons[2]:addEventListener("touch", trackSwitch)
	trackButtons[3]:addEventListener("touch", trackSwitch)
	
	_G.gameLayer:insert(trackButtons[1])
	_G.gameLayer:insert(trackButtons[2])
	_G.gameLayer:insert(trackButtons[3])
	
	return trackButtons
end


