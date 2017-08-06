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

--[[
	This value needs to be high enough for MarI/O to reach the
	goal trigger. If it's too low then the level will be reset
	and no TimeBonus will be given.
]]--
TimeoutConstant = 90

--[[
	How much penalty MarI/O receives upon death.
	This actually doesn't seem to be very useful. But a value
	less than TimeoutConstant might help MarI/O learn.
]]--
DeathPenaltyValue = 0

--[[
	If MarI/O reaches the goal a time bonus will be calculated
	based on these values.
	For each second left on the timer (T) TimeBonusInitialValue will
	grow exponentially with TimeBonusGrowthRate percent.
	Examples:
		TimeBonusInitialValue * math.pow(1 + (TimeBonusGrowthRate / 100), T)
		10 * math.pow(1 + (1.2 / 100), 200) = 108
		10 * math.pow(1 + (1.2 / 100), 350) = 650
		10 * math.pow(1 + (1.2 / 100), 360) = 732
]]--
TimeBonusInitialValue = 10
TimeBonusGrowthRate = 1.2

MaxNodes = 1000000
