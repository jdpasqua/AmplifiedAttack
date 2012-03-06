module(..., package.seeall)
local physics = require("physics")

local random = math.random	--localized for performance

--decorator--------------------
function decorate(obj)	--object to decorate
	obj.force = {random() - .5, -random() * .5 - .5}
	
	--loop behavior--------------------
	function obj:enterFrame(event)
		self:applyForce(self.force[1], self.force[2], self.x, self.y)
		if (random() < .02) then
			self.force = {random() - .5, -random() * .5 - .5}
		end
	end
	
--destroy--------------------
	function obj:remove()
		Runtime:removeEventListener("enterFrame", self)
		Runtime:removeEventListener("touch", self)
		self:removeSelf()
	end
	
	if obj.bodyType == nil then
		physics.addBody(obj, {density=random(), radius=10})
	end
	Runtime:addEventListener("enterFrame", obj)
end