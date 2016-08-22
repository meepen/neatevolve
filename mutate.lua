local exports = {}

package.loaded.mutate = exports


local linkMutate, pointMutate, randomNeuron, newGene, enableDisableMutate, copyGene

local function newInnovation(pool)
	pool.innovation = pool.innovation + 1
	return pool.innovation
end

exports.pointMutate = function(genome)
	local step = genome.mutationRates["step"]
	
	for i=1,#genome.genes do
		local gene = genome.genes[i]
		if math.random() < PerturbChance then
			gene.weight = gene.weight + math.random() * step*2 - step
		else
			gene.weight = math.random()*4-2
		end
	end
end

local function containsLink(genes, link)
	for i=1,#genes do
		local gene = genes[i]
		if gene.into == link.into and gene.out == link.out then
			return true
		end
	end
end

exports.linkMutate = function(genome, forceBias, pool)
	local neuron1 = randomNeuron(genome.genes, false)
	local neuron2 = randomNeuron(genome.genes, true)
	 
	local newLink = newGene()
	if neuron1 <= Inputs and neuron2 <= Inputs then
		--Both input nodes
		return
	end
	if neuron2 <= Inputs then
		-- Swap output and input
        neuron1, neuron2 = neuron2, neuron1
	end

	newLink.into = neuron1
	newLink.out = neuron2
	if forceBias then
		newLink.into = Inputs
	end
	
	if containsLink(genome.genes, newLink) then
		return
	end
	newLink.innovation = newInnovation(pool)
	newLink.weight = math.random()*4-2
	
	table.insert(genome.genes, newLink)
end

exports.nodeMutate = function(genome, pool)
	if #genome.genes == 0 then
		return
	end

	genome.maxneuron = genome.maxneuron + 1

	local gene = genome.genes[math.random(1,#genome.genes)]
	if not gene.enabled then
		return
	end
	gene.enabled = false
	
	local gene1 = copyGene(gene)
	gene1.out = genome.maxneuron
	gene1.weight = 1.0
	gene1.innovation = newInnovation(pool)
	gene1.enabled = true
	table.insert(genome.genes, gene1)
	
	local gene2 = copyGene(gene)
	gene2.into = genome.maxneuron
	gene2.innovation = newInnovation(pool)
	gene2.enabled = true
	table.insert(genome.genes, gene2)
end


exports.mutate = function(genome, pool)
	for mutation,rate in pairs(genome.mutationRates) do
		if math.random(1,2) == 1 then
			genome.mutationRates[mutation] = 0.95*rate
		else
			genome.mutationRates[mutation] = 1.05263*rate
		end
	end

	if math.random() < genome.mutationRates.connections then
		pointMutate(genome)
	end
	
	local p = genome.mutationRates.link
	while p > 0 do
		if math.random() < p then
			linkMutate(genome, false, pool)
		end
		p = p - 1
	end

	p = genome.mutationRates.bias
	while p > 0 do
		if math.random() < p then
			linkMutate(genome, true, pool)
		end
		p = p - 1
	end
	
	p = genome.mutationRates.node
	while p > 0 do
		if math.random() < p then
			exports.nodeMutate(genome, pool)
		end
		p = p - 1
	end
	
	p = genome.mutationRates.enable
	while p > 0 do
		if math.random() < p then
			enableDisableMutate(genome, true)
		end
		p = p - 1
	end

	p = genome.mutationRates.disable
	while p > 0 do
		if math.random() < p then
			enableDisableMutate(genome, false)
		end
		p = p - 1
	end
end

linkMutate      = exports.linkMutate
pointMutate     = exports.pointMutate
randomNeuron    = require "construct".randomNeuron
newGene         = require "new".newGene
enableDisableMutate = require "construct".enableDisableMutate
copyGene        = require "construct".copyGene

return exports