//---------------------------------------------------------------------------------------
//  FILE:    X2SitRepEffect_ModifyForceLevel.uc
//  AUTHOR:  David Burchanowski  --  8/22/2016
//  PURPOSE: Allows sitreps to modify the mission's force level
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class X2SitRepEffect_ModifyForceLevel extends X2SitRepEffectTemplate;

var int MinForceLevel;
var int MaxForceLevel;
var int ForceLevelModification; // adds this number to the overall force level before clamping to the min and max

function ModifyPreMissionBattleDataState(XComGameState_BattleData BattleData)
{
	local int ForceLevel;
	
	if(MinForceLevel < 1 || MinForceLevel > MaxForceLevel)
	{
		`Redscreen("Detected invalid Min/Max values in X2SitRepEffect_ModifyForceLevel");
		return;
	}

	ForceLevel = BattleData.GetForceLevel();

	ForceLevel += ForceLevelModification;
	ForceLevel = Clamp(ForceLevel, MinForceLevel, MaxForceLevel);

	BattleData.SetForceLevel(ForceLevel);
}

defaultproperties
{
	MinForceLevel=1
	MaxForceLevel=10000
	ForceLevelModification=0
}