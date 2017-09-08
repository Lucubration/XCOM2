//---------------------------------------------------------------------------------------
//  FILE:    X2Condition_GameplayTag.uc
//  AUTHOR:  Dan Kaplan
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2017 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class X2Condition_GameplayTag extends X2Condition
	native(Core);

var name RequiredGameplayTag;
var name DisallowGameplayTag;

function bool CanEverBeValid(XComGameState_Unit SourceUnit, bool bStrategyCheck)
{
	local XComGameStateHistory History;
	local XComGameState_HeadquartersXCom XComHQ;

	History = `XCOMHISTORY;
	XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom', true));

	if( RequiredGameplayTag != '' && XComHQ.TacticalGameplayTags.Find(RequiredGameplayTag) == INDEX_NONE )
	{
		return false;
	}

	if( DisallowGameplayTag != '' && XComHQ.TacticalGameplayTags.Find(DisallowGameplayTag) != INDEX_NONE )
	{
		return false;
	}

	return true;
}

defaultproperties
{
}