Ball = Class{}

function Ball:init(skin)
	self.width = 8
	self.height = 8

	self.dx = 0
	self.dy = 0

	self.skin = skin

end

function Ball:collides(target)
	if self.x <= target.x + target.width and self.x + self.width >= target.x then
		if self.y <= target.y + target.height and self.y + self.height >= target.y then
			return true
		end
	end
end

function Ball:reset()
	self.x = VIRTUAL_WIDTH / 2 - 4
	self.y = VIRTUAL_HEIGHT / 2 - 4
	self.dx = 0
	self.dy = 0
end

function Ball:update(dt)

	self.x = self.x + self.dx * dt
	self.y = self.y + self.dy * dt

	if self.x + self.width >= VIRTUAL_WIDTH then
		self.dx = -self.dx
		self.x = self.x - 2
		-- self.x = self.x - self.width
		gSounds['collides']:play()
	end

	if self.y <= 0 then
		self.dy = -self.dy
		self.y = self.y + 2
		-- self.y = self.y + self.height
		gSounds['collides']:play()
	end

	if self.x <= 0 then
		self.dx = -self.dx
		self.x = self.x + 2
		-- self.x = self.x + self.width
		gSounds['collides']:play()
	end
end

function Ball:render()
	love.graphics.draw(gTextures['main'], gFrames['balls'][self.skin], self.x, self.y)
end
