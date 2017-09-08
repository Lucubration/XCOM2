///---------------------------------------------------------------------------------------
//  FILE:    SeqAct_IsUnitSoldier.uc
//  AUTHOR:  David Burchanowski  --  9/20/2016
//  PURPOSE: Action to determine if a given unit is a solider
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class SeqAct_IsUnitSoldier extends SequenceAction;

var XComGameState_Unit Unit;

event Activated()
{
	if(Unit == none)
	{
		`Redscreen("Warning: SeqAct_IsUnitSoldier was called without specifying a unit.");
		OutputLinks[0].bHasImpulse = false;
		OutputLinks[1].bHasImpulse = true;
		return;
	}

	if (`ONLINEEVENTMGR.bIsChallengeModeGame && !Unit.GetMyTemplate().bIsCosmetic)
	{
		// This is in a challenge mode AND not a cosmetic unit, so count it as a soldier
		OutputLinks[0].bHasImpulse = true;
		OutputLinks[1].bHasImpulse = !OutputLinks[0].bHasImpulse;
		return;
	}

	OutputLinks[0].bHasImpulse = Unit.IsSoldier();
	OutputLinks[1].bHasImpulse = !OutputLinks[0].bHasImpulse;
}

defaultproperties
{
	ObjName="Is Unit Soldier"
	ObjCategory="Unit"
	bCallHandler=false

	bConvertedForReplaySystem=true
	bCanBeUsedForGameplaySequence=true

	OutputLinks(0)=(LinkDesc="Yes")
	OutputLinks(1)=(LinkDesc="No")

	VariableLinks(0)=(ExpectedType=class'SeqVar_GameUnit', LinkDesc="Unit", PropertyName=Unit)
}