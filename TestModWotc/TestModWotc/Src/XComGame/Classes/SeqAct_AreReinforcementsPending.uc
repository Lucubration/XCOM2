///---------------------------------------------------------------------------------------
//  FILE:    SeqAct_AreReinforcementsPending.uc
//  AUTHOR:  David Burchanowski  --  9/20/2016
//  PURPOSE: Action to determine if any alien reinforcements are queued, but not yet deployed
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class SeqAct_AreReinforcementsPending extends SequenceAction;

event Activated()
{
	local XComGameState_AIReinforcementSpawner Spawner;

	foreach `XCOMHISTORY.IterateByClassType(class'XComGameState_AIReinforcementSpawner', Spawner)
	{
		OutputLinks[0].bHasImpulse = true;
		OutputLinks[1].bHasImpulse = false;
		return;
	}

	OutputLinks[0].bHasImpulse = false;
	OutputLinks[1].bHasImpulse = true;
}

defaultproperties
{
	ObjName="Are Reinforcements Pending"
	ObjCategory="Gameplay"
	bCallHandler=false

	bConvertedForReplaySystem=true
	bCanBeUsedForGameplaySequence=true

	OutputLinks(0)=(LinkDesc="Yes")
	OutputLinks(1)=(LinkDesc="No")

	VariableLinks.Empty()
}