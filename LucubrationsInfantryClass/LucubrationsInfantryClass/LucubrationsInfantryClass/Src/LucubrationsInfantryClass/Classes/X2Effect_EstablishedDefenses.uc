class X2Effect_EstablishedDefenses extends X2Effect_BonusArmor
	config(LucubrationsInfantryClass);

var config int LowCoverBonusArmor, HighCoverBonusArmor, BonusArmorChance;

// Built-in methods on the X2Effect_BonusArmor class that we're overriding to provide updated armor values.
// Apparently, these get evaluated a lot, like whenever the unit's health bar thing gets updated, whenever
// abilities get evaluated, etc. So differing values return here will change it dynamically as the unit
// moves around
function int GetArmorChance(XComGameState_Effect EffectState, XComGameState_Unit UnitState)
{
	local ECoverType CoverType;

	CoverType = UnitState.GetCoverTypeFromLocation();

	// Always provide armor when in cover, never when out of cover
	if (CoverType == CT_MidLevel || CoverType == CT_Standing)
	{
		//`LOG("Lucubration Infantry Class: Established Defenses armor bonus applies= True");
		return default.BonusArmorChance;
	}
	else
	{
		//`LOG("Lucubration Infantry Class: Established Defenses armor bonus applies= False");
		return 0;
	}
}

function int GetArmorMitigation(XComGameState_Effect EffectState, XComGameState_Unit UnitState)
{
	local ECoverType CoverType;

	CoverType = UnitState.GetCoverTypeFromLocation();

	// Provide differing amounts of armor in different circumstances
	if (CoverType == CT_MidLevel)
	{
		//`LOG("Lucubration Infantry Class: Established Defenses low cover armor bonus=" @ string(default.LowCoverBonusArmor));
		return default.LowCoverBonusArmor;
	}
	else if (CoverType == CT_Standing)
	{
		//`LOG("Lucubration Infantry Class: Established Defenses high cover armor bonus=" @ string(default.HighCoverBonusArmor));
		return default.HighCoverBonusArmor;
	}
	
	//`LOG("Lucubration Infantry Class: Established Defenses no cover armor bonus= 0");

	return 0;
}

DefaultProperties
{
	EffectName="EstablishedDefenses"
	DuplicateResponse=eDupe_Refresh
}