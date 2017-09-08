//---------------------------------------------------------------------------------------
//  *********   FIRAXIS SOURCE CODE   ******************
//  FILE:    UIChallengePostScreen.uc
//  AUTHORS: Russell Aasland
//
//  PURPOSE: Container for special challenge mode specific UI elements
//  NOTE: Reuses the flash elements from the MP HUD. 
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//--------------------------------------------------------------------------------------- 

class UIChallengePostScreen extends UIScreen;

var localized string m_Header;
var localized string m_HeaderLose;
var localized string m_ScoreLabel;
var localized string m_RankLabel;
var localized string m_LeaderboardLabel;
var localized string m_Description;
var localized string m_DescriptionLose;
var localized string m_ButtonLabel;
var UINavigationHelp					m_NavHelp;

var bool bAllSoldiersDead;;
var bool bMissionFailed;

var string m_ImagePath;

var UIButton m_ContinueButton;
var UIButton m_LeaderboardButton;
var UIButton m_PhotoboothButton;

var X2Photobooth_TacticalAutoGen m_kPhotoboothAutoGen;
var bool bUserPhotoTaken;

simulated function InitScreen( XComPlayerController InitController, UIMovie InitMovie, optional name InitName )
{
	super.InitScreen( InitController, InitMovie, InitName );

	CheckForAllSoldiersDead();

	m_ContinueButton = Spawn( class'UIButton', self );
	m_ContinueButton.InitButton( 'challengeContinueButton', class'UIUtilities_Text'.default.m_strGenericContinue, OnContinueButtonPress );

	m_LeaderboardButton = Spawn( class'UIButton', self );
	m_LeaderboardButton.InitButton( 'leaderboardButton', , OnLeaderboardButtonPress );

	m_PhotoboothButton = Spawn(class'UIButton', self);
	m_PhotoboothButton.InitButton('photoboothButton', class'UIMissionSummary'.default.m_strMissionPhotobooth, OnPhotoboothButtonPress);
	m_PhotoboothButton.SetGamepadIcon(class'UIUtilities_Input'.const.ICON_Y_TRIANGLE);
	m_PhotoboothButton.Hide();

	Navigator.Clear();
}

// Flash side is initialized.
simulated function OnInit( )
{
	local string TempBlank;

	local XComChallengeModeManager ChallengeModeManager;
	local WorldInfo LocalWorldInfo;
	local int Year, Month, DayOfWeek, Day, Hour, Minute, Second, Millisecond;
	local string TimeString, DescriptionString;
	local string GamerTag;
	local int ChallengeScore, MaxChallengeScore;
	local XComGameState_BattleData BattleData;

	super.OnInit( );

	if (XComTacticalGRI(class'WorldInfo'.static.GetWorldInfo().GRI).ReplayMgr.bInReplay)
	{
		GamerTag = `ONLINEEVENTMGR.m_sReplayUserID;
	}
	else
	{
		GamerTag = GetALocalPlayerController().PlayerReplicationInfo.PlayerName;
	}

	LocalWorldInfo = class'Engine'.static.GetCurrentWorldInfo( );

	LocalWorldInfo.GetSystemTime( Year, Month, DayOfWeek, Day, Hour, Minute, Second, Millisecond );
	`ONLINEEVENTMGR.FormatTimeStampSingleLine12HourClock( TimeString, Year, Month, Day, Hour, Minute );

	ChallengeModeManager = XComEngine(Class'GameEngine'.static.GetEngine()).ChallengeModeManager;
	ChallengeScore = ChallengeModeManager.GetTotalScore();
	MaxChallengeScore = ChallengeModeManager.GetMaxChallengeScore();

	BattleData = XComGameState_BattleData(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_BattleData'));
	bMissionFailed = (!BattleData.bLocalPlayerWon);

	if(bMissionFailed)
	{
		DescriptionString = m_DescriptionLose;
	}
	else
	{
		DescriptionString = m_Description;
	}

	TempBlank = "";

	MC.BeginFunctionOp( "setScreenData" );

	MC.QueueString( m_ImagePath ); //strImage
	MC.QueueString( m_Header ); //strHeader
	MC.QueueString( GamerTag ); //strGamertag
	MC.QueueString( TimeString ); //strTime
	MC.QueueString( m_ScoreLabel); //strRankLabel
	MC.QueueString( string(ChallengeScore)); //strRankValue1
	MC.QueueString( class'UIChallengeModeScoringDialog'.default.m_TotalLabel); //strScoreLabel
	MC.QueueString( string(MaxChallengeScore) ); //strScoreValue
	MC.QueueString( TempBlank); //strRankValue2
	MC.QueueString( m_LeaderboardLabel ); //strLeaderboardLabel
	MC.QueueString( DescriptionString ); //strDescription
	MC.QueueString( m_ButtonLabel ); //strContinue

	MC.EndOp( );

	if(bMissionFailed)
	{
		MC.FunctionVoid("setFailureState");
	}

	if(`ISCONTROLLERACTIVE)
	{
		m_NavHelp = Spawn(class'UINavigationHelp', self).InitNavHelp();
		UpdateNavHelp();
	}
}


simulated function UpdateNavHelp()
{
	m_NavHelp.ClearButtonHelp();

	m_NavHelp.AddCenterHelp(class'UIUtilities_Text'.default.m_strGenericContinue, class'UIUtilities_Input'.const.ICON_A_X);

	m_NavHelp.AddCenterHelp(m_LeaderboardLabel, class'UIUtilities_Input'.const.ICON_X_SQUARE);
}

simulated function Remove( )
{
	super.Remove( );
}

function SetupTacticalPhotoStudio()
{
	m_kPhotoboothAutoGen = Spawn(class'X2Photobooth_TacticalAutoGen', self);
	m_kPhotoboothAutoGen.bChallengeMode = true;
	m_kPhotoboothAutoGen.Init();
}

simulated function OnContinueButtonPress( UIButton Button )
{
	CloseScreenTakePhoto();
}

simulated function CloseScreenTakePhoto()
{
	if (false) //!bAllSoldiersDead && !bUserPhotoTaken && !`ISCONSOLE && !`SCREENSTACK.IsInStack(class'UIReplay'))
	{
		// We assume the screen fade will be cleared on the changing of maps after this screen closes.
		class'WorldInfo'.static.GetWorldInfo().GetALocalPlayerController().ClientSetCameraFade(true, MakeColor(0, 0, 0), vect2d(0, 1), 0.0);

		SetupTacticalPhotoStudio();
		m_kPhotoboothAutoGen.RequestPhoto(PhotoTaken);

		HideObscuringParticleSystems();
	}
	else
	{
		CloseAndContinue();
	}
}

simulated function PhotoTaken()
{
	m_kPhotoboothAutoGen.Destroy();
	CloseAndContinue();
}

function CloseAndContinue()
{
	CloseScreen( );

	if (!Movie.Pres.IsA( 'XComHQPresentationLayer' ))
		`TACTICALRULES.bWaitingForMissionSummary = false;
	else
	{
		`HQPRES.UIAfterAction( true );
	}
}

simulated function CloseThenOpenPhotographerScreen()
{
	local XComTacticalController LocalController;

	LocalController = XComTacticalController(BATTLE().GetALocalPlayerController());
	if (LocalController != none && LocalController.PlayerCamera != none && LocalController.PlayerCamera.bEnableFading)
	{
		LocalController.ClientSetCameraFade(false);
	}

	HideObscuringParticleSystems();

	`PRES.UIPhotographerScreen();
	`PRES.m_kPhotographer.bChallengeMode = true;
}

simulated function OnPhotoboothButtonPress(UIButton button)
{
	local XComTacticalController LocalController;

	LocalController = XComTacticalController(BATTLE().GetALocalPlayerController());
	if (LocalController != none && LocalController.PlayerCamera != none && LocalController.PlayerCamera.bEnableFading)
	{
		LocalController.ClientSetCameraFade(false);
	}

	HideObscuringParticleSystems();

	`PRES.UIPhotographerScreen();
	`PRES.m_kPhotographer.bChallengeMode = true;
}

function CheckForAllSoldiersDead()
{
	local int i;
	local array<XComGameState_Unit> arrSoldiers;

	BATTLE().GetHumanPlayer().GetOriginalUnits(arrSoldiers, true, true, true);

	bAllSoldiersDead = true;
	for (i = 0; i < arrSoldiers.Length; ++i) // Check that we are not adding more than 6 units as no formation holds more than 6.
	{
		if (arrSoldiers[i].UnitIsValidForPhotobooth())
		{
			bAllSoldiersDead = false;
			break;
		}
	}
}

static function XGBattle_SP BATTLE()
{
	return XGBattle_SP(`BATTLE);
}

simulated function HideObscuringParticleSystems()
{
	local Name P_X4_ExplosionName;
	local Emitter EmitterActor;

	P_X4_ExplosionName = Name("P_X4_Explosion");
	foreach AllActors(class'Emitter', EmitterActor)
	{
		if (EmitterActor.ParticleSystemComponent != none
			&& EmitterActor.ParticleSystemComponent.Template != none
			&& EmitterActor.ParticleSystemComponent.Template.Name == P_X4_ExplosionName)
		{
			EmitterActor.SetVisible(false);
		}
	}
}

function OnLeaderboardButtonPress( UIButton Button )
{
	Movie.Pres.UIChallengeLeaderboard(true);
}

//==============================================================================
//		INPUT HANDLING:
//==============================================================================
simulated function bool OnUnrealCommand(int ucmd, int arg)
{
	if (!CheckInputIsReleaseOrDirectionRepeat(ucmd, arg))
		return false;

	switch (ucmd)
	{
	case (class'UIUtilities_Input'.const.FXS_BUTTON_X):
		Movie.Pres.UIChallengeLeaderboard(true);
		return true;
	case (class'UIUtilities_Input'.const.FXS_BUTTON_Y):
		return true;

	case (class'UIUtilities_Input'.const.FXS_BUTTON_A):
	case (class'UIUtilities_Input'.const.FXS_KEY_ENTER):
	case (class'UIUtilities_Input'.const.FXS_KEY_SPACEBAR):
		CloseScreenTakePhoto();
		return true;
	}

	return super.OnUnrealCommand(ucmd, arg);
}

// ===========================================================================
//  DEFAULTS:
// ===========================================================================
defaultproperties
{
	MCName = "theScreen";
	Package = "/ package/gfxChallengePostGame/ChallengePostGame";

	m_ImagePath = "img:///UILibrary_Common.ChallengeMode.Challenge_XComPoster01";

	bUserPhotoTaken = false;
}