///---------------------------------------------------------------------------------------
//  FILE:    SeqEvent_UnitConcealmentBroken.uc
//  AUTHOR:  David Burchanowski  --  9/20/2016
//  PURPOSE: Event that fires when an XCom unit's concealment is broken.
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class SeqEvent_UnitConcealmentBroken extends SeqEvent_GameEventTriggered;

DefaultProperties
{
	EventID="UnitConcealmentBroken"
	ObjCategory="Gameplay"
	ObjName="Unit Concealment Broken"

	bConvertedForReplaySystem=true
	bCanBeUsedForGameplaySequence=true
}