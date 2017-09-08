///---------------------------------------------------------------------------------------
//  FILE:    SeqEvent_SquadConcealmentBroken.uc
//  AUTHOR:  David Burchanowski  --  9/20/2016
//  PURPOSE: Event that fires when the XCom squad's concealment is broken.
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class SeqEvent_SquadConcealmentBroken extends SeqEvent_GameEventTriggered;

DefaultProperties
{
	EventID="SquadConcealmentBroken"
	ObjCategory="Gameplay"
	ObjName="Squad Concealment Broken"

	bConvertedForReplaySystem=true
	bCanBeUsedForGameplaySequence=true

	VariableLinks.Empty()
}