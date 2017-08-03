local exports = {}

package.loaded.new = exports

local crossover, copyGenome, mutate, writeFile, totalAverageFitness, addToSpecies

ffi.cdef[[
typedef struct {
    uint32_t into, out, innovation;
    float weight;
    bool enabled;
} gene_t;
]]

local gene_t = ffi.typeof "gene_t"
exports.newGene = function()
	local gene = gene_t()
	gene.enabled = true
	return gene
end

exports.newNeuron = function()
	local neuron = {
        n = 0,
        value = 0
    }
	
	return neuron
end
local newNeuron = exports.newNeuron

exports.newNetwork = function(genome)
	local network = {}
	network.neurons = {}
	
	for i=1,Inputs do
		network.neurons[i] = newNeuron()
	end
	
	for o=1,Outputs do
		network.neurons[MaxNodes+o] = newNeuron()
	end
	
	table.sort(genome.genes, function (a,b)
		return (a.out < b.out)
	end)
    
	for i=1,#genome.genes do
		local gene = genome.genes[i]
		if gene.enabled then
			if network.neurons[gene.out] == nil then
				network.neurons[gene.out] = newNeuron()
			end
			local neuron = network.neurons[gene.out]
            neuron.n = neuron.n + 1
			neuron[neuron.n] = gene
			if network.neurons[gene.into] == nil then
				network.neurons[gene.into] = newNeuron()
			end
		end
	end
	
	return network
end

exports.newGenome = function()
	local genome = {}
	genome.genes = {}
	genome.fitness = 0
	genome.adjustedFitness = 0
	genome.network = {}
	genome.maxneuron = 0
	genome.globalRank = 0
	genome.mutationRates = {}
	genome.mutationRates.connections = MutateConnectionsChance
	genome.mutationRates.link = LinkMutationChance
	genome.mutationRates.bias = BiasMutationChance
	genome.mutationRates.node = NodeMutationChance
	genome.mutationRates.enable = EnableMutationChance
	genome.mutationRates.disable = DisableMutationChance
	genome.mutationRates.step = StepSize
	
	return genome
end

exports.newPool = function ()
	local pool = {}
	pool.species = {}
	pool.generation = 0
	pool.innovation = Outputs
	pool.currentSpecies = 1
	pool.currentGenome = 1
	pool.currentFrame = 0
	pool.maxFitness = 0
	
	return pool
end

exports.newSpecies = function()
	local species = {}
	species.topFitness = 0
	species.staleness = 0
	species.genomes = {}
	species.averageFitness = 0
	
	return species
end



local function cullSpecies(cutToOne, pool)
	for s = 1,#pool.species do
		local species = pool.species[s]
		
		table.sort(species.genomes, function (a,b)
			return (a.fitness > b.fitness)
		end)
		
		local remaining = math.ceil(#species.genomes/2)
		if cutToOne then
			remaining = 1
		end
		while #species.genomes > remaining do
			table.remove(species.genomes)
		end
	end
end
local function rankGlobally(pool)
	local global = {}
	for s = 1,#pool.species do
		local species = pool.species[s]
		for g = 1,#species.genomes do
			table.insert(global, species.genomes[g])
		end
	end
	table.sort(global, function (a,b)
		return (a.fitness < b.fitness)
	end)
	
	for g=1,#global do
		global[g].globalRank = g
	end
end
local function removeStaleSpecies(pool)
	local survived = {}

	for s = 1,#pool.species do
		local species = pool.species[s]
		
		table.sort(species.genomes, function (a,b)
			return (a.fitness > b.fitness)
		end)
		
		if species.genomes[1].fitness > species.topFitness then
			species.topFitness = species.genomes[1].fitness
			species.staleness = 0
		else
			species.staleness = species.staleness + 1
		end
		if species.staleness < StaleSpecies or species.topFitness >= pool.maxFitness then
			table.insert(survived, species)
		end
	end

	pool.species = survived
end

local function calculateAverageFitness(species)
	local total = 0
	
	for g=1,#species.genomes do
		local genome = species.genomes[g]
		total = total + genome.globalRank
	end
	
	species.averageFitness = total / #species.genomes
end

local function removeWeakSpecies(pool)
	local survived = {}

	local sum = totalAverageFitness(pool)
	for s = 1,#pool.species do
		local species = pool.species[s]
		breed = math.floor(species.averageFitness / sum * Population)
		if breed >= 1 then
			table.insert(survived, species)
		end
	end

	pool.species = survived
end
local function breedChild(species, pool)
	local child
	if math.random() < CrossoverChance then
		local g1 = species.genomes[math.random(1, #species.genomes)]
		local g2 = species.genomes[math.random(1, #species.genomes)]
		child = crossover(g1, g2)
	else
		local g = species.genomes[math.random(1, #species.genomes)]
		child = copyGenome(g)
	end
	
	mutate(child, pool)
	
	return child
end

exports.newGeneration = function(pool, saveLoadFile)
	cullSpecies(false, pool) -- Cull the bottom half of each species
	rankGlobally(pool)
	removeStaleSpecies(pool)
	rankGlobally(pool)
	for s = 1,#pool.species do
		local species = pool.species[s]
		calculateAverageFitness(species)
	end
	removeWeakSpecies(pool)
	local sum = totalAverageFitness(pool)
	local children = {}
	for s = 1,#pool.species do
		local species = pool.species[s]
		breed = math.floor(species.averageFitness / sum * Population) - 1
		for i=1,breed do
			table.insert(children, breedChild(species, pool))
		end
	end
	cullSpecies(true, pool) -- Cull all but the top member of each species
	while #children + #pool.species < Population do
		local species = pool.species[math.random(1, #pool.species)]
		table.insert(children, breedChild(species, pool))
	end
	for c=1,#children do
		local child = children[c]
		addToSpecies(child, pool)
	end
    
	pool.generation = pool.generation + 1
	
	writeFile("backup." .. pool.generation .. ".DP1.state.pool", pool)
end

crossover  = require "construct".crossover
copyGenome = require "construct".copyGenome
mutate     = require "mutate".mutate
writeFile  = require "io".writeFile
totalAverageFitness = require "routine".totalAverageFitness
addToSpecies    = require "routine".addToSpecies

return exports