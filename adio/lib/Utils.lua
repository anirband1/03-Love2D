function GenerateQuads(atlas, tilewidth, tileheight)
	local spriteWidth = math.floor(atlas:getWidth() / tilewidth)
	local spriteHeight = math.floor(atlas:getHeight() / tileheight)

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

function GenerateTileSets(quads, setsX, setsY, sizeX, sizeY)
    local tilesets = {}
    local tableCounter = 0
    local sheetWidth = setsX * sizeX
    local sheetHeight = setsY * sizeY

    -- for each tile set on the X and Y
    for tilesetY = 1, setsY do
        for tilesetX = 1, setsX do
            
            -- tileset table
            table.insert(tilesets, {})
            tableCounter = tableCounter + 1

            for y = sizeY * (tilesetY - 1) + 1, sizeY * (tilesetY - 1) + 1 + sizeY do
                for x = sizeX * (tilesetX - 1) + 1, sizeX * (tilesetX - 1) + 1 + sizeX do
                    table.insert(tilesets[tableCounter], quads[sheetWidth * (y - 1) + x])
                end
            end
        end
    end

    return tilesets
end 