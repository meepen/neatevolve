local p1 = "P1 "
Filename = "DP1.state"
ButtonNames = {
    p1.."A",
    p1.."B",
	p1.."X",
	p1.."Y",
	p1.."Up",
	p1.."Down",
	p1.."Left",
	p1.."Right",
}

BoxRadius = 5
InputSize = ((BoxRadius*2)*16)*((BoxRadius*2)*16)

Inputs = InputSize+1
Outputs = #ButtonNames

Population = 300
DeltaDisjoint = 2.0
DeltaWeights = 0.4
DeltaThreshold = 1.0

StaleSpecies = 15

MutateConnectionsChance = 0.25
PerturbChance = 0.90
CrossoverChance = 0.75
LinkMutationChance = 2.0
NodeMutationChance = 0.50
BiasMutationChance = 0.40
StepSize = 0.1
DisableMutationChance = 0.4
EnableMutationChance = 0.2

TimeoutConstant = 90

MaxNodes = 1000000
