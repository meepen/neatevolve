local exports = {}

package.loaded.construct = exports

local copyGene, mutate, newGenome, newGeneration, newGene

exports.copyGene = function(gene)
	local gene2 = newGene()
	gene2.into = gene.into
	gene2.out = gene.out
	gene2.weight = gene.weight
	gene2.enabled = gene.enabled
	gene2.innovation = gene.innovation
	
	return gene2
end


exports.copyGenome = function(genome)
	local genome2 = newGenome()
	for g=1,#genome.genes do
		table.insert(genome2.genes, copyGene(genome.genes[g]))
	end
	genome2.maxneuron = genome.maxneuron
	genome2.mutationRates.connections = genome.mutationRates.connections
	genome2.mutationRates.link = genome.mutationRates.link
	genome2.mutationRates.bias = genome.mutationRates.bias
	genome2.mutationRates.node = genome.mutationRates.node
	genome2.mutationRates.enable = genome.mutationRates.enable
	genome2.mutationRates.disable = genome.mutationRates.disable
	
	return genome2
end

exports.basicGenome = function(pool)
	local genome = newGenome()
	local innovation = 1

	genome.maxneuron = Inputs
	mutate(genome, pool)
	
	return genome
end

exports.randomNeuron = function(genes, nonInput)
	local neurons = {}
	if not nonInput then
		for i=1,Inputs do
			neurons[i] = true
		end
	end
	for o=1,Outputs do
		neurons[MaxNodes+o] = true
	end
	for i=1,#genes do
		if (not nonInput) or genes[i].into > Inputs then
			neurons[genes[i].into] = true
		end
		if (not nonInput) or genes[i].out > Inputs then
			neurons[genes[i].out] = true
		end
	end

	local count = 0
	for _ in pairs(neurons) do
		count = count + 1
	end
	local n = math.random(1, count)
	
	for k,v in pairs(neurons) do
		n = n-1
		if n == 0 then
			return k
		end
	end
	
	return 0
end

exports.enableDisableMutate = function(genome, enable)
	local candidates = {}
	for _,gene in pairs(genome.genes) do
		if gene.enabled == not enable then
			table.insert(candidates, gene)
		end
	end
	
	if #candidates == 0 then
		return
	end
	
	local gene = candidates[math.random(1,#candidates)]
	gene.enabled = not gene.enabled
end


exports.crossover = function(g1, g2)
	-- Make sure g1 is the higher fitness genome
	if g2.fitness > g1.fitness then
        g1, g2 = g2, g1
	end

	local child = newGenome()
	
	local innovations2 = {}
	for i=1,#g2.genes do
		local gene = g2.genes[i]
		innovations2[gene.innovation] = gene
	end
	
	for i=1,#g1.genes do
		local gene1 = g1.genes[i]
		local gene2 = innovations2[gene1.innovation]
		if gene2 ~= nil and math.random(2) == 1 and gene2.enabled then
			table.insert(child.genes, copyGene(gene2))
		else
			table.insert(child.genes, copyGene(gene1))
		end
	end
	
	child.maxneuron = math.max(g1.maxneuron,g2.maxneuron)
	
	for mutation,rate in pairs(g1.mutationRates) do
		child.mutationRates[mutation] = rate
	end
	
	return child
end

function exports.nextGenome(pool)
    pool.species[pool.currentSpecies].genomes[pool.currentGenome].network.neurons = nil
	pool.currentGenome = pool.currentGenome + 1
	if pool.currentGenome > #pool.species[pool.currentSpecies].genomes then
		pool.currentGenome = 1
		pool.currentSpecies = pool.currentSpecies+1
		if pool.currentSpecies > #pool.species then
			newGeneration(pool)
			pool.currentSpecies = 1
		end
	end
end
copyGene      = exports.copyGene
mutate        = require "mutate".mutate
newGenome     = require "new".newGenome
newGeneration = require "new".newGeneration
newGene       = require "new".newGene

return exports