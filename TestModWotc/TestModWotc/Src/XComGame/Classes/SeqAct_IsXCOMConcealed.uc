///---------------------------------------------------------------------------------------
//  FILE:    SeqAct_IsXComConcealed.uc
//  AUTHOR:  James Brawley  --  4/20/17
//  PURPOSE: Action to actively check if XCOM has squad concealment
//			 Implemented to fix problems caused by SitRep High Alert
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2017 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class SeqAct_IsXComConcealed extends SequenceAction;

event Activated()
{
	local XComGameStateHistory History;
	local XComGameState_Player XComPlayer;
	History = `XCOMHISTORY;
	foreach History.IterateByClassType(class'XComGameState_Player', XComPlayer)
	{
		if( XComPlayer.GetTeam() == eTeam_XCom )
		{
			OutputLinks[0].bHasImpulse = XComPlayer.bSquadIsConcealed;
			OutputLinks[1].bHasImpulse = !XComPlayer.bSquadIsConcealed;
		}
	}
}

defaultproperties
{
	ObjName="Is XCOM Concealed"
	ObjCategory="Concealment"
	bCallHandler=false

	bConvertedForReplaySystem=true
	bCanBeUsedForGameplaySequence=true

	OutputLinks(0)=(LinkDesc="Yes")
	OutputLinks(1)=(LinkDesc="No")
}