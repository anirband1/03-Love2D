function GenerateQuads(atlas, tilewidth, tileheight)
	local spriteWidth = atlas:getWidth() / tilewidth
	local spriteHeight = atlas:getHeight() / tileheight

	local spriteCounter = 1
	local spritesheet = {}

	for y = 0, spriteHeight - 1 do
		for x = 0, spriteWidth - 1 do
			spritesheet[spriteCounter] = 
				love.graphics.newQuad(x * tilewidth, y * tileheight, tilewidth, tileheight, atlas:getDimensions())
				spriteCounter = spriteCounter + 1
		end
	end

	return spritesheet

end

function table.slice(tbl, first, last, step)
	local sliced = {}

	for i = first or 1, last or #tbl, step or 1 do
		sliced[#sliced + 1] = tbl[i]
	end

	return sliced

end

function GenerateBrickQuads(atlas)
	return table.slice(GenerateQuads(atlas, 32, 16), 1, 21)
end

function GeneratePaddleQuads(atlas)

	local quads = {}
	local counter = 1

	local x = 0
	local y = 64

	for i=0, 4 do

		quads[counter] = love.graphics.newQuad(x, y, 32, 16, atlas:getDimensions())
		counter = counter + 1

		quads[counter] = love.graphics.newQuad(x + 32, y, 64, 16, atlas:getDimensions())
		counter = counter + 1

		quads[counter] = love.graphics.newQuad(x + 96, y, 96, 16, atlas:getDimensions())
		counter = counter + 1

		quads[counter] = love.graphics.newQuad(x, y + 16,  128, 16, atlas:getDimensions())
		counter = counter + 1
		
		x = 0
		y = y + 32

	end

	return quads
end 

function GenerateBallQuads(atlas)
	local quads = {}
	local counter = 1

	local x = 96
	local y = 48

	for i=0, 3 do
		quads[counter] = love.graphics.newQuad(x, y, 8, 8, atlas:getDimensions())
		x = x + 8
		counter = counter + 1
	end

	local x = 96
	local y = 56

	for i=0, 2 do
		quads[counter] = love.graphics.newQuad(x, y, 8, 8, atlas:getDimensions())
		x = x + 8
		counter = counter + 1
	end

	return quads 

end

function GenerateHeartsQuads(atlas)
	local quads = {}

	local x = 128
	local y = 48

	local counter = 1

	for i=0, 2 do
		quads[counter] = love.graphics.newQuad(x, y, 10, 9, atlas:getDimensions())
		x = x + 10 
		counter = counter + 1
	end

	return quads
end