//---------------------------------------------------------------------------------------
//  FILE:    SeqEvent_OnTurnEnd.uc
//  AUTHOR:  David Burchanowski  --  1/21/2014
//  PURPOSE: Fires when a player's turn ends
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
 
class SeqEvent_OnTurnEnd extends SeqEvent_X2GameState;

event Activated()
{
	local X2TacticalGameRuleset Rules;
	local XComGameStateHistory History;
	local X2GameRulesetEventObserverInterface EventObserver;
	local KismetGameRulesetEventObserver KismetObserver;
	local XComGameState Latest;
	local XComGameStateContext_TacticalGameRule LatestContext;
	local XComGameState_Player EndingTurnPlayer;

	// determine which player is currently active and fire
	OutputLinks[0].bHasImpulse = false;
	OutputLinks[1].bHasImpulse = false;
	OutputLinks[2].bHasImpulse = false;
	OutputLinks[3].bHasImpulse = false;
	OutputLinks[4].bHasImpulse = false;

	History = `XCOMHISTORY;
	Rules = `TACTICALRULES;

	EventObserver = Rules.GetEventObserverOfType( class'KismetGameRulesetEventObserver' );
	KismetObserver = KismetGameRulesetEventObserver( EventObserver );
	`assert( KismetObserver != none );

	// the latest history is the one that we would have been activated in response to
	Latest = KismetObserver.PostBuildTriggerState;
	LatestContext = XComGameStateContext_TacticalGameRule( Latest.GetContext() );
	`assert( (LatestContext != none) && (LatestContext.GameRuleType == eGameRule_PlayerTurnEnd) ); // but just to be sure...

	// the player referenced by this context is the one who's turn ended
	EndingTurnPlayer = XComGameState_Player( History.GetGameStateForObjectID( LatestContext.PlayerRef.ObjectID ) );
	`assert( EndingTurnPlayer != none );

	switch(EndingTurnPlayer.TeamFlag)
	{
	case eTeam_XCom:
		OutputLinks[0].bHasImpulse = true;
		break;
	case eTeam_Alien:
		OutputLinks[1].bHasImpulse = true;
		break;
	case eTeam_Neutral:
		OutputLinks[2].bHasImpulse = true;
		break;
	case eTeam_TheLost:
		OutputLinks[3].bHasImpulse = true;
		break;
	case eTeam_Resistance:
		OutputLinks[4].bHasImpulse = true;
		break;
	}
}

/**
* Return the version number for this class.  Child classes should increment this method by calling Super then adding
* a individual class version to the result.  When a class is first created, the number should be 0; each time one of the
* link arrays is modified (VariableLinks, OutputLinks, InputLinks, etc.), the number that is added to the result of
* Super.GetObjClassVersion() should be incremented by 1.
*
* @return	the version number for this specific class.
*/
static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 2;
}

defaultproperties
{
	VariableLinks.Empty

	OutputLinks(0)=(LinkDesc="XCom")
	OutputLinks(1)=(LinkDesc="Alien")
	OutputLinks(2)=(LinkDesc="Civilian")
	OutputLinks(3)=(LinkDesc="TheLost")
	OutputLinks(4)=(LinkDesc="Resistance")

	bGameSequenceEvent=true
	bConvertedForReplaySystem=true

	ObjCategory="Gameplay"
	ObjName="On Turn End"
}
