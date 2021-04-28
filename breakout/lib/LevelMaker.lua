LevelMaker = Class{}

function LevelMaker.createMap(level)
	local bricks = {}

	local numRows = math.random(1, 5)
	local numColumns = math.random(7, 13)
	numColumns = numColumns	% 2 == 0 and (numColumns + 1) or numColumns

	local highestTier = math.min(3, math.floor(level / 5))

	local highestColor = math.min(5, level % 5 + 3)

	for y = 1, numRows do

		-- random enable and alternate
		local skipPattern = math.random(1, 2) == 1 and true or false
		local alternatePattern = math.random(1, 2) == 1 and true or false

		-- choose 2 colors to alternate btween
		local alternateColor1 = math.random(1, highestColor)
		local alternateColor2 = math.random(1, highestColor)
		local alternateTier1 = math.random(0, highestTier)
		local alternateTier2 = math.random(0, highestTier)

		-- only when skipping a block, for skip pattern
		local skipFlag = math.random(2) == 1 and true or false
		local alternateFlag = math.random(2) == 1 and true or false

		local solidColor = math.random(1, highestColor)
		local solidTier = math.random(0, highestTier)

		for x = 1, numColumns do
			if skipPattern and skipFlag then
				skipFlag = not skipFlag
			else
				skipFlag = not skipFlag
				b = Brick(

					-- x coordinate

					(x-1)						-- decrement x by 1 bcos tables are 1-indexed, coords r 0
					* 32						-- multiply by brick width
					+ 8							-- the screen should have 8 pixels of padding since, 13 colums + 16 
					+ (13 - numColumns) * 16,	-- left side padding for < 13 columns

					-- y coordinate

					y * 16						-- y * 16 for top padding
				)

			
			
				if alternatePattern and alternateFlag then
					b.color = alternateColor1
					b.tier = alternateTier1 
					alternateFlag = not alternateFlag
				else
					b.color = alternateColor2
					b.tier = alternateTier2
					alternateFlag = not alternateFlag
				end
				
				if not alternatePattern then
					b.color = solidColor
					b.tier = solidTier
				end
			end

			table.insert(bricks, b)
		end
	end
	if #bricks == 0 then
		return LevelMaker:createMap(level)
	else
		return bricks
	end
end