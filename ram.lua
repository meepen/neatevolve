local exports = {}
package.loaded.ram = exports

local SMW = require "lib/SMW"
local SPRITES = require "sprites"

memory.usememorydomain("WRAM")

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

local x_size = 0
local y_size = 0


function isLevelVertical()
	local levelsettings = memory.readbyte(SMW.WRAM.level_mode_settings)
	return (levelsettings ~= 0) and (levelsettings == 0x3 or levelsettings == 0x4 or levelsettings == 0x7 or levelsettings == 0x8 or levelsettings == 0xa or levelsettings == 0xd)
end	


function levelSetup()
	local screens = memory.readbyte(SMW.WRAM.screens_number)

	if isLevelVertical() then
		x_size = 27
		y_size = 16 * screens --vertical level
	else
		x_size = 16 * screens
		y_size = 27
	end
end


function exports.performTileSetup()
	levelSetup()	
	
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


function exports.getSprites()
    
	local sprites = {}
	for slot=0,SMW.constant.sprite_max -1 do
        
		local status = memory.readbyte(SMW.WRAM.sprite_status+slot)
		if status ~= 0 then
			local spritex = memory.readbyte(SMW.WRAM.sprite_x_low+slot) + memory.readbyte(SMW.WRAM.sprite_x_high+slot)*256
			local spritey = memory.readbyte(SMW.WRAM.sprite_y_low+slot) + memory.readbyte(SMW.WRAM.sprite_y_high+slot)*256
            local boxid = bit.band(memory.readbyte(SMW.WRAM.sprite_2_tweaker+slot), 0x3f)
            
			-- Ignore unnecessary stuff (tweak this in enemies.lua)
			-- FIXME: Doesn't work for large enemies (ex. Banzai Bill)
			--        Do we need to read SMW.WRAM.sprite_memory_header to fix this?
			local sprite_extra_info = SPRITES[boxid]
			
			if (sprite_extra_info.deadly) then
				local clip = SMW.HITBOX_SPRITE[boxid]
				
				sprites[#sprites+1] = {
					x = spritex + clip.xoff,
					x2 = spritex + clip.xoff + clip.width,
					y = spritey + clip.yoff,
					y2 = spritey + clip.yoff + clip.width,
				}
			end
		end
        
	end		
	
	return sprites
end


function exports.getPlayerHitbox(marioX, marioY)
    local crouching = memory.readbyte(SMW.WRAM.is_ducking)
    local powerup = memory.readbyte(SMW.WRAM.powerup)
    local index = 0
    if (crouching ~= 0 or powerup == 0) then
        index = index + 1
    end
    local yoshistate = memory.readbyte(SMW.WRAM.yoshi_riding_flag)
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
	return memory.read_s16_le(SMW.WRAM.x), memory.read_s16_le(SMW.WRAM.y)
	--return memory.read_s16_le(0xD1), memory.read_s16_le(0xD3)
end

function exports.getScreen()
	local screenIndex = memory.readbyte(0x95)
	if isLevelVertical() then
	--	return 0, screenIndex
	else
	--	return screenIndex, 0
	end
    return memory.read_s16_le(0x7E), memory.read_s16_le(0x80);
end

return exports