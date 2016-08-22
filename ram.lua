local exports = {}

package.loaded.ram = exports

memory.usememorydomain("WRAM")


local clipping = {
    xdisp = memory.readbyterange(0x1B56C, 60, "CARTROM"),
    width = memory.readbyterange(0x1B5A8, 60, "CARTROM"),
    ydisp = memory.readbyterange(0x1B5E4, 60, "CARTROM"),
    height = memory.readbyterange(0x1B620, 60, "CARTROM"),
}
for i = 0, 59 do
    local tmp = clipping.xdisp[i]
    if (tmp > 0x7f) then
        tmp = tmp - 0x100
    end
    clipping.xdisp[i] = tmp
    tmp = clipping.ydisp[i]
    if (tmp > 0x7f) then
        tmp = tmp - 0x100
    end
    clipping.ydisp[i] = tmp
end
local playerClipping = {
    height = memory.readbyterange(0x1b660, 4, "CARTROM"),
    ydisp = memory.readbyterange(0x1b65c, 4, "CARTROM"),
    width = 0xC,
    xdisp = 2
}


local performTileSetup, getTile
local ramlow,ramhigh
local tilecache 
local floor = math.floor
local y_size = 256
local x_size = 256
function exports.performTileSetup()
    --tilecache = {}
    if (not tilecache) then
        ramhigh = memory.readbyterange(0x1C800, 0x37FF)
        ramlow = memory.readbyterange(0xC800, 0x37FF)
        tilecache = {}
        
        for dy = 0, y_size - 1 do
            for dx = 0, x_size - 1 do
                local index = floor(dx/0x10)*0x1B0 + dy*0x10 + dx%0x10
                tilecache[dx * y_size + dy] = {
                    ramhigh[index] or 0,
                    ramlow[index] or 0
                }
            end
        end
    end
    
end

function exports.getTile(dx, dy)
    dx = (dx - dx % 16) / 16
    dy = (dy - dy % 16) / 16
    if (dx < 0 or dx >= x_size or dy < 0 or dy >= y_size) then
        return 0, 0
    end
    local tile = tilecache[dx * y_size + dy]
    return tile[1], tile[2]
end

local allowStatus = {
    false,
    false,
    true,
    false,
    false,
    false,
    false,
    true
}

function exports.getSprites()
    
	local sprites = {}
	for slot=0,11 do
        
		local status = memory.readbyte(0x14C8+slot)
		if allowStatus[status] then
			local spritex = memory.readbyte(0xE4+slot) + memory.readbyte(0x14E0+slot)*256
			local spritey = memory.readbyte(0xD8+slot) + memory.readbyte(0x14D4+slot)*256
            local clip = bit.band(memory.readbyte(0x1662+slot), 0x3f)
            
			sprites[#sprites+1] = {
                x = spritex + clipping.xdisp[clip],
                x2 = spritex + clipping.xdisp[clip] + clipping.width[clip],
                y = spritey + clipping.ydisp[clip],
                y2 = spritey + clipping.ydisp[clip] + clipping.height[clip],
            }
		end
        
	end		
	
	return sprites
end



function exports.getPlayerHitbox(marioX, marioY)
    local crouching = memory.readbyte(0x73)
    local powerup = memory.readbyte(0x19)
    local index = 0
    if (crouching ~= 0 or powerup == 0) then
        index = index + 1
    end
    local yoshistate = memory.readbyte(0x187A)
    if (yoshistate ~= 0) then
        index = index + 2
    end
    
    return {
        x = marioX + playerClipping.xdisp,
        y = marioY + playerClipping.ydisp[index],
        h = playerClipping.height[index],
        w = playerClipping.width
    }
end


function exports.getExtendedSprites()
	local extended = {}
	for slot=0,11 do
		local number = memory.readbyte(0x170B+slot)
		if number ~= 0 then
			local spritex = memory.readbyte(0x171F+slot) + memory.readbyte(0x1733+slot)*256
			local spritey = memory.readbyte(0x1715+slot) + memory.readbyte(0x1729+slot)*256
			extended[#extended+1] = {
                x = spritex, 
                y = spritey
            }
		end
	end		
	
	return extended
end


function exports.getPosition()
	return memory.read_s16_le(0xD1), memory.read_s16_le(0xD3)
end

function exports.getScreen()
    return memory.read_s16_le(0x7E), memory.read_s16_le(0x80);
end

return exports