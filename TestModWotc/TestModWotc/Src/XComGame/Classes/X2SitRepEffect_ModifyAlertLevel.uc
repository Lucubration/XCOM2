//---------------------------------------------------------------------------------------
//  FILE:    X2SitRepEffect_ModifyAlertLevel.uc
//  AUTHOR:  David Burchanowski  --  8/22/2016
//  PURPOSE: Allows sitreps to modify the mission's force level
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class X2SitRepEffect_ModifyAlertLevel extends X2SitRepEffectTemplate;

var int MinAlertLevel;
var int MaxAlertLevel;
var int AlertLevelModification; // adds this number to the overall force level before clamping to the min and max

function ModifyPreMissionBattleDataState(XComGameState_BattleData BattleData)
{
	local int AlertLevel;

	if(MinAlertLevel < 1 || MinAlertLevel > MaxAlertLevel)
	{
		`Redscreen("Detected invalid Min/Max values in X2SitRepEffect_ModifyAlertLevel");
		return;
	}

	AlertLevel = BattleData.GetAlertLevel();

	AlertLevel += AlertLevelModification;
	AlertLevel = Clamp(AlertLevel, MinAlertLevel, MaxAlertLevel);

	BattleData.SetAlertLevel(AlertLevel);
}

defaultproperties
{
	MinAlertLevel=1
	MaxAlertLevel=10000
	AlertLevelModification=0
}