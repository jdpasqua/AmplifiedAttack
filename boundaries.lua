module (..., package.seeall)

function new()

	local boundaries = {}
	boundaries["north"] = display.newRect(-50, -50, 1000, 1)
	boundaries["east"] = display.newRect(800, -50, 1, 1200)
	boundaries["south"] = display.newRect(-50, 1060, 1000, 1)
	boundaries["west"] = display.newRect(-50, -50, 1, 1200)
	
	boundaries["north"].name = "Boundary"
	boundaries["east"].name = "Boundary"
	boundaries["south"].name = "Boundary"
	boundaries["west"].name = "Boundary"
	
	local boundaryCollisionFilter = { categoryBits = 32, maskBits = 18 }

	-- Physics
	physics.addBody(boundaries["north"], "static", {density = 20, bounce = 0, filter = boundaryCollisionFilter})
	physics.addBody(boundaries["east"], "static", {density = 20, bounce = 0, filter = boundaryCollisionFilter})
	physics.addBody(boundaries["south"], "static", {density = 20, bounce = 0, filter = boundaryCollisionFilter})
	physics.addBody(boundaries["west"], "static", {density = 20, bounce = 0, filter = boundaryCollisionFilter})

	_G.gameLayer:insert(boundaries["north"])
	_G.gameLayer:insert(boundaries["east"])
	_G.gameLayer:insert(boundaries["south"])
	_G.gameLayer:insert(boundaries["west"])

	return boundaries

end
