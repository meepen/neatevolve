local exports = {}

package.loaded.routine = exports

local basicGenome, performTileSetup, newNetwork, newSpecies, getScreen

local exp = math.exp
local function sigmoid(x)
	return 2/(1+exp(-4.9*x))-1
end

function exports.evaluateCurrent(pool)
	local genome = pool.species[pool.currentSpecies].genomes[pool.currentGenome]

	local controller = exports.evaluateNetwork(genome.network, exports.getInputs())
    genome.curScreenX, genome.curScreenY = getScreen()
    
	if controller["P1 Left"] and controller["P1 Right"] then
		controller["P1 Left"] = false
		controller["P1 Right"] = false
	end
	if controller["P1 Up"] and controller["P1 Down"] then
		controller["P1 Up"] = false
		controller["P1 Down"] = false
	end

	joypad.set(controller)
end

function exports.initializePool(pool)
	for i=1,Population do
		exports.addToSpecies(basicGenome(pool), pool)
	end

	exports.initializeRun(pool)
    return pool
end

function exports.initializeRun(pool)
	savestate.load(Filename);
    performTileSetup();
	-- rightmost = 0
	pool.currentFrame = 0
	timeout = TimeoutConstant
	exports.clearJoypad()
	
	local species = pool.species[pool.currentSpecies]
	local genome = species.genomes[pool.currentGenome]
	genome.network = newNetwork(genome)
	exports.evaluateCurrent(pool)
end

local curScreenX, curScreenY
local curMarioX, curMarioY

local min = math.min
local max = math.max

local getPosition           = require "ram".getPosition
local getSprites            = require "ram".getSprites
local getExtendedSprites    = require "ram".getExtendedSprites
local getTile               = require "ram".getTile
require "globals"

local PrecompiledTableAssignment = {}

local precompiled_end = "\nend"

local iy_mult = ((BoxRadius * 2) * 16)
local precompiled = "return function(inputs, inx, iny) inx = inx + iny * "..iy_mult.."\n"

local function buildFormatArgs(count, num)
    local r = {}
    for i = 1, count do
        r[i] = num + i - 1
    end
    return unpack(r)
end

local set = ""
local val  = ""
for x = 0, 6 do
    set = set.."inputs[inx + 0x%xULL],"
    val = val.."1,"
    local set2 = ""
    local val2 = ""
    for y = 0, 15 do
        set2 = set2..set:format(buildFormatArgs(x+1, y*iy_mult))
        val2 = val2..val
        PrecompiledTableAssignment[y*16+x] = load(precompiled..set2:sub(1,-2).."="..val2:sub(1,-2)..precompiled_end, x.."x"..y)()
    end
end

for x = 7, 13 do
    for y = 0, 15 do
        PrecompiledTableAssignment[y*16+x] = function(inputs, inx, iny)
            PrecompiledTableAssignment[6+y*16](inputs, inx, iny)
            PrecompiledTableAssignment[x-7+y*16](inputs, inx + 7, iny)
        end
    end
end
for x = 14, 15 do
    for y = 0, 15 do
        PrecompiledTableAssignment[y*16+x] = function(inputs, inx, iny)
            PrecompiledTableAssignment[6+y*16](inputs, inx, iny)
            PrecompiledTableAssignment[6+y*16](inputs, inx+7, iny)
            PrecompiledTableAssignment[x-14+y*16](inputs,inx+14, iny)
        end
    end
end

local inputs = ffi.new("int8_t["..Inputs.."]")
function exports.getInputs()
	local marioX, marioY = getPosition()
	
	local sprites = getSprites()
	local extended = getExtendedSprites()
    ffi.fill(inputs, Inputs)
	curScreenX, curScreenY = screenX, screenY
    curMarioX, curMarioY = marioX, marioY
    
    local xoff, yoff = 
        marioX % 16,
        marioY % 16
    local xadd, yadd = 
        xoff == 0 and 0 or 1,
        yoff == 0 and 0 or 1
    
    local halfx = BoxRadius * 16 - xoff
    local halfy = BoxRadius * 16 - yoff
    
    
    
    local inx, iny, low, high, val
    local dy_min, dy_max = 16 * (-BoxRadius - yoff), 16 * (BoxRadius - 1 + yoff)
    for dx = 16 * (-BoxRadius - xoff), 16 * (BoxRadius - 1 + xoff), 16 do
        for dy = dy_min, dy_max, 16 do
            
            local inx, iny = 
                halfx + dx,
                halfy + dy 
            local low, high = getTile(dx + marioX, dy + marioY)
            if (low > 0) then
                local fy_min, fy_max = 
                    max(0, iny), 
                    min(iny + 15, iy_mult - 1)
                local fx = max(0, inx)  
                local w = min(inx + 15, iy_mult - 1) - fx
                local h = fy_max - fy_min
                
                if (h >= 0 and w >= 0) then
                    PrecompiledTableAssignment[h * 16 + w](inputs, fx + 1, iny)
                end
            end
            
        end
    end
    
    for i = 1,#sprites do
        local sprite = sprites[i]
        local dx, dy = 
            sprite.x - marioX,
            sprite.y - marioY
        local dx2, dy2 = 
            sprite.x2 - marioX,
            sprite.y2 - marioY
        
        local ix = dx + BoxRadius * 16
        local iy = dy + BoxRadius * 16
        
        local ix2 = dx2 + BoxRadius * 16
        local iy2 = dy2 + BoxRadius * 16
        
        for fy = max(0, iy), min(iy_mult - 1, iy2) do
            for fx = max(0, ix), min(iy_mult - 1, ix2) do 
                inputs[fy * iy_mult + fx + 1] = -1
            end
        end
    end
	for i = 1,#extended do
        local dx, dy = 
            extended[i].x - marioX,
            extended[i].y - marioY
        
        local ix = dx + BoxRadius * 16
        local iy = dy + BoxRadius * 16
        
        for fy = max(0, iy - 15), min(iy_mult - 1, iy) do
            for fx = max(0, ix), min(iy_mult - 1, ix + 15) do 
                inputs[fy * iy_mult + fx + 1] = -1
            end
        end
	end
    
	return inputs
end

function exports.evaluateNetwork(network, inputs)
    local value = "value"
    
    local neurons = network.neurons
	inputs[Inputs] = 1
    
	for i=1,Inputs - Inputs % 32, 32 do
        neurons[i+0].value, neurons[i+1].value, neurons[i+2].value, neurons[i+3].value,
        neurons[i+4].value, neurons[i+5].value, neurons[i+6].value, neurons[i+7].value,
        neurons[i+8].value, neurons[i+9].value, neurons[i+10].value, neurons[i+11].value,
        neurons[i+12].value, neurons[i+13].value, neurons[i+14].value, neurons[i+15].value,
        neurons[i+16].value, neurons[i+17].value, neurons[i+18].value, neurons[i+19].value,
        neurons[i+20].value, neurons[i+21].value, neurons[i+22].value, neurons[i+23].value,
        neurons[i+24].value, neurons[i+25].value, neurons[i+26].value, neurons[i+27].value,
        neurons[i+28].value, neurons[i+29].value, neurons[i+30].value, neurons[i+31].value = 
            inputs[i+0], inputs[i+1], inputs[i+2], inputs[i+3],
            inputs[i+4], inputs[i+5], inputs[i+6], inputs[i+7],
            inputs[i+8], inputs[i+9], inputs[i+10], inputs[i+11],
            inputs[i+12], inputs[i+13], inputs[i+14], inputs[i+15],
            inputs[i+16], inputs[i+17], inputs[i+18], inputs[i+19],
            inputs[i+20], inputs[i+21], inputs[i+22], inputs[i+23],
            inputs[i+24], inputs[i+25], inputs[i+26], inputs[i+27],
            inputs[i+28], inputs[i+29], inputs[i+30], inputs[i+31]
	end
    
    for i = Inputs - Inputs % 32, Inputs do
        neurons[i].value = inputs[i]
    end
	
    for i = 1, Inputs do
        local neuron = neurons[i]
        if neuron.n > 0 then
            local sum = 0
            
            for j = 1, neuron.n do
                local incoming = neuron[j]
                local other = network.neurons[incoming.into]
                sum = sum + incoming.weight * other.value
            end
        
            neuron.value = sigmoid(sum)
        end
    end
    
    i = MaxNodes + 1
    neuron = neurons[i]
    repeat
        if neuron.n > 0 then
            local sum = 0
            
            for j = 1, neuron.n do
                local incoming = neuron[j]
                local other = network.neurons[incoming.into]
                sum = sum + incoming.weight * other.value
            end
        
            neuron.value = sigmoid(sum)
        end
        i = i + 1
        neuron = neurons[i]
    until not neuron
    
    
	local outputs = {}
	for o=1,Outputs do
		local button = ButtonNames[o]
		if network.neurons[MaxNodes+o].value > 0 then
			outputs[button] = true
		else
			outputs[button] = false
		end
	end
	
	return outputs
end

local function disjoint(genes1, genes2)
	local i1 = {}
	for i = 1,#genes1 do
		local gene = genes1[i]
		i1[gene.innovation] = true
	end

	local i2 = {}
	for i = 1,#genes2 do
		local gene = genes2[i]
		i2[gene.innovation] = true
	end
	
	local disjointGenes = 0
	for i = 1,#genes1 do
		local gene = genes1[i]
		if not i2[gene.innovation] then
			disjointGenes = disjointGenes+1
		end
	end
	
	for i = 1,#genes2 do
		local gene = genes2[i]
		if not i1[gene.innovation] then
			disjointGenes = disjointGenes+1
		end
	end
	
	local n = math.max(#genes1, #genes2)
	
	return disjointGenes / n
end

local function weights(genes1, genes2)
	local i2 = {}
	for i = 1,#genes2 do
		local gene = genes2[i]
		i2[gene.innovation] = gene
	end

	local sum = 0
	local coincident = 0
	for i = 1,#genes1 do
		local gene = genes1[i]
		if i2[gene.innovation] ~= nil then
			local gene2 = i2[gene.innovation]
			sum = sum + math.abs(gene.weight - gene2.weight)
			coincident = coincident + 1
		end
	end
	
	return sum / coincident
end

function exports.isSameSpecies(genome1, genome2)
	local dd = DeltaDisjoint*disjoint(genome1.genes, genome2.genes)
	local dw = DeltaWeights*weights(genome1.genes, genome2.genes) 
	return dd + dw < DeltaThreshold
end

function exports.totalAverageFitness(pool)
	local total = 0
	for s = 1,#pool.species do
		local species = pool.species[s]
		total = total + species.averageFitness
	end

	return total
end

function exports.clearJoypad()
	local controller = {}
	for b = 1,#ButtonNames do
		controller[ButtonNames[b]] = false
	end
	joypad.set(controller)
end

function exports.addToSpecies(child, pool)
	local foundSpecies = false
	for s=1,#pool.species do
		local species = pool.species[s]
		if not foundSpecies and exports.isSameSpecies(child, species.genomes[1]) then
			table.insert(species.genomes, child)
			foundSpecies = true
		end
	end
	
	if not foundSpecies then
		local childSpecies = newSpecies()
		table.insert(childSpecies.genomes, child)
		table.insert(pool.species, childSpecies)
	end
end

basicGenome       = require "construct".basicGenome
performTileSetup  = require "ram".performTileSetup
newNetwork        = require "new".newNetwork
newSpecies        = require "new".newSpecies
getScreen         = require "ram".getScreen
return exports