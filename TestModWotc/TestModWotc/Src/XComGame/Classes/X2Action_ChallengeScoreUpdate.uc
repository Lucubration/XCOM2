//---------------------------------------------------------------------------------------
//  FILE:    X2Action_ChallengeScoreUpdate.uc
//  AUTHOR:  Russell Aasland
//  PURPOSE: Action for triggering visual changes to the challenge score
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class X2Action_ChallengeScoreUpdate extends X2Action;

var UIChallengeModeHUD ChallengeHUD;

var ChallengeModePointType ScoringType;
var int AddedPoints;

function Init(  )
{
	super.Init( );
}

event bool BlocksAbilityActivation( )
{
	return true;
}

//------------------------------------------------------------------------------------------------
simulated state Executing
{
	simulated event BeginState( Name PreviousStateName )
	{
		ChallengeHUD = `PRES.GetChallengeModeHUD();
	}

Begin:

	if (ScoringType != CMPT_None && ScoringType != CMPT_TotalScore && AddedPoints > 0 && !`REPLAY.bInReplay)
	{
		// Make sure that a banner isn't already in flight
		while (ChallengeHUD.IsWaitingForBanner())
		{
			Sleep(0.0f);
		}

		ChallengeHUD.UpdateChallengeScore(ScoringType, AddedPoints);
		Sleep(0.1f);
		ChallengeHUD.TriggerChallengeBanner();

		while (ChallengeHUD.IsWaitingForBanner())
		{
			Sleep(0.0f);
		}
	}
	
	CompleteAction( );
}

defaultproperties
{
	TimeoutSeconds = 20;
}