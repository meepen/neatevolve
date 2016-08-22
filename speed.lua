local unloop = [[
local min, max = math.min, math.max
local getTile = ...

local iy_mult = ((BoxRadius * 2) * 16)
return function(marioX, marioY)
    local dx, dy, inx, iny, low, high, val
    
    local halfx = BoxRadius * 16 - marioX % 16
    local halfy = BoxRadius * 16 - marioY % 16]]
    
for dx = 16 * (-BoxRadius - 1), 16 * (BoxRadius), 16 do
    for dy = 16 * (-BoxRadius - 1), 16 * (BoxRadius), 16 do
        
        unloop = unloop..[[
            dx, dy = ]]..dx..","..dy..[[
        
            inx = halfx + dx 
            iny = halfy + dy 
            low, high = getTile(dx + marioX, dy + marioY)
            val = low > 0 and 1 or 0
            
            for fx = max(0, inx) + 1, min(inx + 15, iy_mult - 1) + 1 do
                for fy = max(0, iny) * iy_mult, min(iny + 15, iy_mult - 1) * iy_mult, iy_mult do
                    inputs[fy + fx] = val
                end
            end
        
        ]]
    
    --[[
    for dx = 16 * (-BoxRadius - xoff), 16 * (BoxRadius - 1 + xoff), 16 do
        for dy = 16 * (-BoxRadius - yoff), 16 * (BoxRadius - 1 + yoff), 16 do
            
            local inx = halfx + dx 
            local iny = halfy + dy 
            local low, high = getTile(dx + marioX, dy + marioY)
            local val = low > 0 and 1 or 0
            
            for fx = max(0, inx) + 1, min(inx + 15, iy_mult - 1) + 1 do
                for fy = max(0, iny) * iy_mult, min(iny + 15, iy_mult - 1) * iy_mult, iy_mult do
                    inputs[fy + fx] = val
                end
            end
            
        end
    end
    ]]
    
unloop = unloop..[[
end]]

unloop = load(unloop, "=unloop")(getTile)