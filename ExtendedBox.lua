module (..., package.seeall)

function new()
	
	local box = require("BasicBox").new()
	
	box.superMove = box.move
	
	function box:move()
		self:superMove()
		self.rotation = math.random(360)
	end
	
	function box:setColor()
		self:setFillColor(255, 0, 0)
	end
	
	return box
	
end