local exports = {}

package.loaded.ram = exports

memory.usememorydomain("WRAM")

local function SNESToPC(addr)
    return bit.band(addr, 0xFFFF)+(32768*(bit.band(bit.rshift(addr, 16), 127)))-32256-512;
end



local clipping = {
    xdisp = memory.readbyterange(SNESToPC(0x03B56C), 60, "CARTROM"),
    width = memory.readbyterange(SNESToPC(0x03B5A8), 60, "CARTROM"),
    ydisp = memory.readbyterange(SNESToPC(0x03B5E4), 60, "CARTROM"),
    height = memory.readbyterange(SNESToPC(0x03B620), 60, "CARTROM"),
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

require "globals"

local performTileSetup, getTile
local ramlow,ramhigh
local tilecache, slope
local floor = math.floor
local y_size = 256
local x_size = 256
local iy_mult = ((BoxRadius * 2) * 16)
local precompiled_end = "\nend"

local precompiled = "return function(inputs, inx, iny) inx = inx + iny * "..iy_mult.."\n"
local inputSetters = {}
local function buildFormatArgs(count, num, offset)
    local r = {}
    offset = offset or 0
    for i = 1, count do
        r[i] = num + i + offset - 1
    end
    return unpack(r)
end
local function buidValueFormatArgs(count, y, range, offset)
    local r = {}
    offset = offset or 0
    for i = offset + 0, offset + count-1 do
        r[#r+1] = (y + (y < 0 and 16 or 0) >= range[i]) and "1" or "0"
    end
    return unpack(r)
end
function exports.performTileSetup()
    --tilecache = {}
    if (not tilecache) then
        ramhigh = memory.readbyterange(0x1C800, 0x37FF)
        ramlow = memory.readbyterange(0xC800, 0x37FF)
        tilecache = {}
        local slope_ptr = SNESToPC(memory.read_u24_le(0x0082))
        
        slopes = memory.readbyterange(slope_ptr, 0x1D7-0x16A, "CARTROM")
        
        for dy = 0, y_size - 1 do
            for dx = 0, x_size - 1 do
                local index = floor(dx/0x10)*0x1B0 + dy*0x10 + dx%0x10
                tilecache[dx * y_size + dy] = {
                    ramhigh[index] or 0,
                    ramlow[index] or 0,
                    false -- ensure we aren't indexing the hash table every frame
                }
                local hi = ramhigh[index]
                local lo = ramlow[index]
                
                local base = 0x6e
                
                if (hi == 1 and lo >= base and lo <= 0xD8) then
                    
                    if (not inputSetters[lo-base]) then
                        
                        local setters = {}
                        local idx = slopes[lo-base] * 16 -- lowest 4 bits are which pixel you are on
                        local range = memory.readbyterange(SNESToPC(0xE632) + idx, 16, "CARTROM")
                        for i = 0, 0xf do
                            if (range[i] > 0x7f) then
                                range[i] = range[i] - 0x100
                            end
                        end
                        
                        local set = ""
                        local val  = ""
                        for x = 0, 6 do
                            set = set.."inputs[inx + 0x%x],"
                            val = val.."%i,"
                            local set2 = ""
                            local val2 = ""
                            for y = 0, 15 do
                                set2 = set2..set:format(buildFormatArgs(x+1, y * iy_mult, 0))
                                val2 = val2..val:format(buidValueFormatArgs(x+1, y, range))
                                setters[y*16+x] = load(precompiled..set2:sub(1,-2).."="..val2:sub(1,-2)..precompiled_end, lo..":"..x.."x"..y)()
                            end
                        end
                        set, val = "", ""
                        for x = 7, 13 do
                            set = set.."inputs[inx + 0x%x],"
                            val = val.."%i,"
                            local set2 = ""
                            local val2 = ""
                            for y = 0, 15 do
                                set2 = set2..set:format(buildFormatArgs(x-6, y * iy_mult, 7))
                                val2 = val2..val:format(buidValueFormatArgs(x-6, y, range, 7))
                                local tmp = load(precompiled..set2:sub(1,-2).."="..val2:sub(1,-2)..precompiled_end, lo..":"..x.."x"..y)()
                                setters[y*16+x] = function(inputs, inx, iny)
                                    setters[6+y*16](inputs, inx, iny)
                                    tmp(inputs, inx, iny)
                                end
                            end
                        end
                        set, val = "", ""
                        for x = 14, 15 do
                            set = set.."inputs[inx + 0x%x],"
                            val = val.."%i,"
                            local set2 = ""
                            local val2 = ""
                            for y = 0, 15 do
                                set2 = set2..set:format(buildFormatArgs(x-13, y * iy_mult, 14))
                                val2 = val2..val:format(buidValueFormatArgs(x-13, y, range, 14))
                                local tmp = load(precompiled..set2:sub(1,-2).."="..val2:sub(1,-2)..precompiled_end, lo..":"..x.."x"..y)()
                                setters[y*16+x] = function(inputs, inx, iny)
                                    setters[13+y*16](inputs, inx, iny)
                                    tmp(inputs, inx, iny)
                                    if (input.get().G) then
                                        print(("%02X"):format(lo))print(range)
                                        print"meme"
                                        
                                    end
                                end
                            end
                        end
                        inputSetters[lo-base] = setters
                        
                    end
                    
                    tilecache[dx * y_size + dy][3] = inputSetters[lo-base]
                    
                end
                
            end
        end
    end
    
end

function exports.getTile(dx, dy)
    dx = (dx - dx % 16) / 16
    dy = (dy - dy % 16) / 16
    if (dx < 0 or dx >= x_size or dy < 0 or dy >= y_size) then
        return 0, 0, false
    end
    local tile = tilecache[dx * y_size + dy]
    return tile[1], tile[2], tile[3]
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