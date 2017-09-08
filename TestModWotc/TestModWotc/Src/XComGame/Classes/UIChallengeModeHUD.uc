//---------------------------------------------------------------------------------------
//  *********   FIRAXIS SOURCE CODE   ******************
//  FILE:    UIChallengeModeHUD.uc
//  AUTHORS: Russell Aasland
//
//  PURPOSE: Container for special challenge mode specific UI elements
//  NOTE: Reuses the flash elements from the MP HUD. 
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//--------------------------------------------------------------------------------------- 

class UIChallengeModeHUD extends UIScreen
	dependson(XComChallengeModeManager);

var bool WaitingOnBanner;

var localized string m_ScoreLabel;
var localized string m_BannerLabels[ChallengeModePointType.EnumCount]<BoundEnum = ChallengeModePointType>;

var localized string m_PointsLabel; //bsg-jneal (5.15.17): adding localized string for POINTS

var private bool TimerAudioPaused; // Prevents Wwise spam.

simulated function InitScreen( XComPlayerController InitController, UIMovie InitMovie, optional name InitName )
{
	local Object ThisObj;

	super.InitScreen( InitController, InitMovie, InitName );

	ThisObj = self;
	`XEVENTMGR.RegisterForEvent( ThisObj, 'ChallengeModeScoreChange', ChallengeScoreChanged, ELD_OnVisualizationBlockCompleted );
}

// Flash side is initialized.
simulated function OnInit( )
{
	local string sContainerPath;

	super.OnInit();
	if (`ONLINEEVENTMGR.bInitiateReplayAfterLoad)
	{
		Hide();
	}
	else
	{
		Show();
	}

	MC.BeginFunctionOp( "setChallengeScoreDirect" );
	MC.QueueNumber( 0 );
	MC.QueueString(m_ScoreLabel);
	MC.EndOp( );

	Movie.ActionScriptVoid( Movie.Pres.GetUIComm( ).MCPath $ "." $ "setCommlinkChallengeOffset" );
	Movie.ActionScriptVoid( Movie.Pres.GetUIComm( ).MCPath $ "." $ "AnchorToTopRight" );

	sContainerPath = XComPresentationLayer( Movie.Pres ).GetSpecialMissionHUD( ).MCPath $ ".counters";
	Movie.ActionScriptVoid(sContainerPath $ "." $ "setCounterChallengeOffset");
	XComTacticalController(class'WorldInfo'.static.GetWorldInfo().GetALocalPlayerController()).HideInputButtonRelatedHUDElements(true);

	//bsg-jneal (5.15.17): adding localized string for POINTS
	MC.BeginFunctionOp( "setPointsString" );
	MC.QueueString( m_PointsLabel );
	MC.EndOp( );
	//bsg-jneal (5.15.17): end
}

simulated function Remove( )
{
	super.Remove( );
}

simulated event Tick( float DeltaTime )
{
	local XComGameState_TimerData Timer;
	local int TotalSeconds, Minutes, Seconds;

	Timer = XComGameState_TimerData( `XCOMHISTORY.GetSingleGameStateObjectForClass( class'XComGameState_TimerData', true ) );

	if ((Timer != none) && Timer.bIsChallengeModeTimer)
	{
		if (!`TACTICALRULES.UnitActionPlayerIsAI())
		{
			Timer.bStopTime = class'XComGameStateVisualizationMgr'.static.VisualizerBusy( ) && !`Pres.UIIsBusy( );
		}

		if (!Timer.bStopTime && !Movie.Pres.ScreenStack.IsInStack(class'UIChallengeModeScoringDialog') && !Movie.Pres.ScreenStack.IsInStack(class'UIChallengePostScreen'))
		{
			TotalSeconds = Timer.GetCurrentTime( );
			if (TotalSeconds >= 0)
			{
				Minutes = (TotalSeconds / 60);
				Seconds = TotalSeconds % 60;

				MC.BeginFunctionOp( "setChallengeTimer" );

				MC.QueueNumber( Minutes );
				MC.QueueNumber( Seconds );

				MC.EndOp( );

				if (Minutes < 10)
				{
					if (Minutes < 5)
					{
						MC.FunctionVoid( "setChallengeTimerWarning" );
					}
					else
					{
						MC.FunctionVoid( "setChallengeTimerCaution" );
					}
				}
				else
				{
					MC.SetString("TimerColor", class'UIUtilities_Colors'.static.GetHexColorFromState(eUIState_Good));
				}
			}

			if (TimerAudioPaused)
			{
				`XTACTICALSOUNDMGR.PlayPersistentSoundEvent("TacticalUI_ChallengeMode_TimerUnpaused");
				TimerAudioPaused = false;
			}
		}
		else
		{
			if (Movie.Pres.ScreenStack.IsInStack(class'UIChallengeModeScoringDialog'))
			{
				MC.BeginFunctionOp("setChallengeTimer");

				MC.QueueNumber(30);
				MC.QueueNumber(0);

				MC.EndOp();
			}

			Timer.AddPauseTime( DeltaTime );

			if (!TimerAudioPaused)
			{
				`XTACTICALSOUNDMGR.PlayPersistentSoundEvent("TacticalUI_ChallengeMode_TimerPaused");
				TimerAudioPaused = true;
			}
		}
	}
}

function UpdateChallengeScore( ChallengeModePointType ScoringType, int AddedPoints )
{
	MC.BeginFunctionOp("setChallengeScore");

	MC.QueueString( m_ScoreLabel );
	MC.QueueNumber( AddedPoints );
	MC.QueueString( m_BannerLabels[ ScoringType ] );

	MC.EndOp( );
}

function TriggerChallengeBanner(  )
{
	WaitingOnBanner = true;
	MC.FunctionVoid( "setChallengeBanner" );
}

simulated function OnCommand( string cmd, string arg )
{
	switch( cmd )
	{
		case "ChallengeBannerComplete": 
			WaitingOnBanner = false;
			break;
		case "PlayChallengeSound": 
			if(!`REPLAY.bInReplay)
				PlayChallengeSound( arg );
			break;

	}
}

function bool IsWaitingForBanner( )
{
	return WaitingOnBanner;
}

function EventListenerReturn ChallengeScoreChanged(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	/*
	local XComGameStateContext_ChallengeScore Context;
	local XComGameState_ChallengeScore ChallengeScore;

	Context = XComGameStateContext_ChallengeScore( GameState.GetContext( ) );

	if (Context != none)
	{
		foreach GameState.IterateByClassType(class'XComGameState_ChallengeScore', ChallengeScore)
		{
			if (ChallengeScore.ScoringType != CMPT_None && ChallengeScore.ScoringType != CMPT_TotalScore && ChallengeScore.AddedPoints > 0)
			{
				UpdateChallengeScore(ChallengeScore.ScoringType, ChallengeScore.AddedPoints);
			}
		}
	}
	*/
	return ELR_NoInterrupt;
}

simulated function PlayChallengeSound( string arg )
{
	`XTACTICALSOUNDMGR.PlayPersistentSoundEvent( arg );
}

// ===========================================================================
//  DEFAULTS:
// ===========================================================================
defaultproperties
{
	MCName = "theScreen";
	Package = "/ package/gfxChallengeHUD/ChallengeHUD";

	InputState = eInputState_None;
	bHideOnLoseFocus = false;

	WaitingOnBanner = false;
	bAlwaysTick=true
}