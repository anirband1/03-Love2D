Brick = Class{}

paletteColors = {
	-- blue
	[1] = {
		['r'] = 99,
		['g'] = 155,
		['b'] = 255
	},

	-- green
	[2] = {
		['r'] = 106,
		['g'] = 190,
		['b'] = 47
	},

	-- red
	[3] = {
		['r'] = 217,
		['g'] = 87,
		['b'] = 99
	},

	-- purple
	[4] = {
		['r'] = 215,
		['g'] = 123,
		['b'] = 186
	},

	-- gold
	[5] = {
		['r'] = 251,
		['g'] = 242,
		['b'] = 54
	}
}

function Brick:init(x, y)
	self.tier = 0
	self.color = 1
	
	self.x = x
	self.y = y
	
	self.width = 32
	self.height = 16
	
	self.inPlay = true

	self.psystem = love.graphics.newParticleSystem(gTextures['particles'], 64)

	-- lasts btwen 0.5-1 seconds
	self.psystem:setParticleLifetime(0.5, 1)

	-- acceleration
	self.psystem:setLinearAcceleration(-15, 0, 15, 80)

	-- spread of particles
	self.psystem:setEmissionArea('normal', 10, 10)
end

function Brick:hit()

	-- never mind this stuff
	self.psystem:setColors(
		paletteColors[self.color].r,
		paletteColors[self.color].g,
		paletteColors[self.color].b,
		55 * (self.tier + 1),
		paletteColors[self.color].r,
		paletteColors[self.color].g,
		paletteColors[self.color].b,
		0
	)
	self.psystem:emit(64)
	
	gSounds['collides']:play()
	
	if self.tier > 0 then
		if self.color == 1 then
			self.tier = self.tier - 1
			self.color = 5
		else
			self.color = self.color - 1
		end
	else
		if self.color == 1 then
			self.inPlay = false
		else
			self.color = self.color - 1
		end
	end
end

function Brick:render()
	if self.inPlay then
		love.graphics.draw(gTextures['main'], gFrames['bricks'][self.tier + ((4 * self.color) - 3)], self.x, self.y)
	end 
end

function Brick:renderParticles()
    love.graphics.draw(self.psystem, self.x + 16, self.y + 8)
end