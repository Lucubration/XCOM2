//---------------------------------------------------------------------------------------
//  *********   FIRAXIS SOURCE CODE   ******************
//  FILE:    UIEndGameStats
//  AUTHOR:  Sam Batista
//  PURPOSE: This file controls the summary of players achievements
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//--------------------------------------------------------------------------------------- 

class UIEndGameStats extends UIScreen;

struct TEndGameStat
{
	var string Label;
	var string YouValue;
	var string WorldValue;
};

const BANNER_WIN1 = 0; // good win
const BANNER_WIN2 = 1; // worn win
const BANNER_WIN3 = 2; // torn win
const BANNER_WIN_IRONMAN = 3;
const BANNER_LOSE = 4;
const NUM_PAGES = 5;

var bool bGameWon;
var int CurrentPage;
var array<UIEndGameStatsPage> StatPages;

var UINavigationHelp NavHelp;

//------------------------------------------------------
// LOCALIZED STRINGS
var localized string GameSummary;
var localized string Victory;
var localized string Defeat;
var localized string Difficulty;
var localized string Ironman;
var localized string Date;
var localized string Doom;
var localized string Page;
var localized string Stats;
var localized string You;
var localized string World;

// FIRST PAGE STATS
var localized string MissionsWon;
var localized string MissionsLost;
var localized string AliensKilled;
var localized string SoldiersLost;
var localized string AverageShotTakenPct;
var localized string FlawlessMissions;
var localized string AverageTurnsLeftOnMissionTimers;

// XPACK SECOND PAGE STATS
var localized string ChosenKilled;
var localized string DaysToFirstChosenKill;
var localized string KillsByFactionHeroes;
var localized string AbilityPointsEarned;
var localized string CompletedCovertActions;
var localized string NumLevel3SoldierBonds;
var localized string NumBreakthroughsResearched;

// SECOND PAGE STATS
var localized string SoldiersWhoSawAction;
var localized string DaysToFirstColonel;
var localized string TotalDaysWounded;
var localized string PromotionsEarned;
var localized string NumberColonels;
var localized string PsiSoldiersTrained;
var localized string NumberMaguses;
var localized string HackRewardsEarned;
var localized string RobotsHacked;

// THIRD PAGE STATS
var localized string NumberScientists;
var localized string NumberEngineers;
var localized string DaysToMagneticWeapons;
var localized string DaysToBeamWeapons;
var localized string DaysToPlatedArmor;
var localized string DaysToPowerArmor;
var localized string DaysToAlienEncryption;

// FOURTH PAGE STATS
var localized string RadioRelaysBuilt;
var localized string SuppliesFromDepots;
var localized string SuppliedFromBlackMarket;
var localized string IntelCollected;
var localized string IntelPaidToBlackMarket;
var localized string AlienFacilitiesSabotaged;

// PROGRESS DIALOG
var localized string FetchDataDialogTitle;
var localized string FetchDataDialogBody;

//------------------------------------------------------
// MEMBER DATA
var XComGameState_Analytics Analytics;
var AnalyticsManager AnalyticsManager;

//==============================================================================
//		INITIALIZATION & INPUT:
//==============================================================================
simulated function InitScreen(XComPlayerController InitController, UIMovie InitMovie, optional name InitName)
{
	local int i;

	super.InitScreen(InitController, InitMovie, InitName);

	if (XComHQPresentationLayer( Movie.Pres ) != none)
		NavHelp = XComHQPresentationLayer( Movie.Pres ).m_kAvengerHUD.NavHelp;
	else
		NavHelp = Spawn( class'UINavigationHelp', self ).InitNavHelp( );

	UpdateNavHelp( );

	MC.BeginFunctionOp("setBannerData");
	if(bGameWon)
	{
		MC.QueueNumber(GetWinLevel()); //numBannerType
		MC.QueueString(Victory); //strTitle
	}
	else
	{
		MC.QueueNumber(BANNER_LOSE); //numBannerType
		MC.QueueString(Defeat); //strTitle
	}
	MC.QueueString(Difficulty); //strDifficultyLabel
	MC.QueueString(Caps(class'UIShellDifficulty'.default.m_arrDifficultyTypeStrings[`CAMPAIGNDIFFICULTYSETTING])); //strDifficultyValue
	MC.QueueString(`GAME.m_bIronman ? Ironman : ""); //strIronman
	MC.QueueString(Date); //strDateLabel
	MC.QueueString(class'X2StrategyGameRulesetDataStructures'.static.GetDateString(class'UIUtilities_Strategy'.static.GetGameTime().CurrentTime, true)); //strDateValue
	MC.EndOp();

	for(i = 0; i < NUM_PAGES; ++i)
	{
		MC.FunctionVoid("addStatPage");
		StatPages.AddItem(Spawn(class'UIEndGameStatsPage', self).InitStatsPage(i, i == 0));
	}

	AnalyticsManager = `XANALYTICS;
	Analytics = XComGameState_Analytics(`XCOMHISTORY.GetSingleGameStateObjectForClass( class'XComGameState_Analytics' ));

	if (AnalyticsManager.WaitingOnWorldStats( ))
	{
		ShowFetchingDataProgressDialog( );
		return;
	}

	UpdateStats();
	MC.FunctionVoid("animateIn");
}

simulated function ShowFetchingDataProgressDialog( )
{
	local TProgressDialogData ProgressDialogData;
	ProgressDialogData.strTitle = FetchDataDialogTitle;
	ProgressDialogData.strDescription = FetchDataDialogBody;
	ProgressDialogData.fnCallback = CancelFetchingData;
	Movie.Pres.UIProgressDialog( ProgressDialogData );
}

simulated function CancelFetchingData( )
{
	AnalyticsManager.CancelWorldStats( );
	DisplayStats( );
}

simulated function DisplayStats( )
{
	UpdateNavHelp( );
	UpdateStats( );
	Show( );
	MC.FunctionVoid( "animateIn" );
}

simulated function UpdateStats()
{
	local UIEndGameStatsPage SPage;

	StatPages[0].UpdateStats(GetFirstPageStats(), !AnalyticsManager.WorldStatsAvailable());
	StatPages[1].UpdateStats(GetXPackPageStats(), !AnalyticsManager.WorldStatsAvailable());
	StatPages[2].UpdateStats(GetSecondPageStats(), !AnalyticsManager.WorldStatsAvailable());
	StatPages[3].UpdateStats(GetThirdPageStats(), !AnalyticsManager.WorldStatsAvailable());
	StatPages[4].UpdateStats(GetFourthPageStats(), !AnalyticsManager.WorldStatsAvailable());

	// Shift the header for the Player to the world column if we don't have world stats
	if (!AnalyticsManager.WorldStatsAvailable())
	{
		foreach StatPages(SPage)
		{
			SPage.SetHeaderLabels( Stats, "", You );
		}
	}
}

simulated function float GetWinLevel()
{
	if(`GAME.m_bIronman)
		return BANNER_WIN_IRONMAN;

	// TODO: @mnauta

	return BANNER_WIN1;
}

simulated function UpdateNavHelp()
{
	NavHelp.ClearButtonHelp();
	if(CurrentPage > 0)
		NavHelp.AddBackButton(OnBack);
	NavHelp.AddContinueButton(OnContinue);
}

simulated function OnContinue()
{
	CurrentPage++;
	UpdateNavHelp();
	if(CurrentPage >= NUM_PAGES)
		CloseScreen();
	else
		MC.FunctionVoid("nextStat");
}

simulated function OnBack()
{
	if(CurrentPage > 0)
	{
		CurrentPage--;
		UpdateNavHelp();
		MC.FunctionVoid("prevStat");
	}
}

simulated function array<TEndGameStat> GetFirstPageStats()
{
	local TEndGameStat Stat;
	local array<TEndGameStat> StatList;
	local float NumTimedMissions, RemainingTimers;
	local float NumShots, NumSuccessfulShots;

	Stat.Label = MissionsWon;
	Stat.YouValue = Analytics.GetValueAsString("BATTLES_WON");
	Stat.WorldValue = AnalyticsManager.GetAvgWorldStatValueAsString("BATTLES_WON");
	StatList.AddItem(Stat);

	Stat.Label = MissionsLost;
	Stat.YouValue = Analytics.GetValueAsString("BATTLES_LOST");
	Stat.WorldValue = AnalyticsManager.GetAvgWorldStatValueAsString("BATTLES_LOST");
	StatList.AddItem(Stat);

	Stat.Label = FlawlessMissions;
	Stat.YouValue = Analytics.GetValueAsString("FLAWLESS_MISSIONS");
	Stat.WorldValue = AnalyticsManager.GetAvgWorldStatValueAsString("FLAWLESS_MISSIONS");
	StatList.AddItem(Stat);

	Stat.Label = AliensKilled;
	Stat.YouValue = Analytics.GetValueAsString("ACC_UNIT_KILLS");
	Stat.WorldValue = AnalyticsManager.GetAvgWorldStatValueAsString("ACC_UNIT_KILLS");
	StatList.Additem(Stat);

	Stat.Label = SoldiersLost;
	Stat.YouValue = Analytics.GetValueAsString("UNITS_LOST");
	Stat.WorldValue = AnalyticsManager.GetAvgWorldStatValueAsString("UNITS_LOST");
	StatList.Additem(Stat);

	Stat.Label = AverageShotTakenPct;
	NumShots = Analytics.GetFloatValue("ACC_UNIT_SHOTS_TAKEN");
	NumSuccessfulShots = Analytics.GetFloatValue("ACC_UNIT_SUCCESS_SHOTS");
	if (NumShots > 0)
	{
		Stat.YouValue = class'UIUtilities'.static.FormatPercentage( NumSuccessfulShots / NumShots * 100, 0 );
	}
	else
	{
		Stat.YouValue = "--";
	}
	NumShots = AnalyticsManager.GetWorldStatFloatValue( "ACC_UNIT_SHOTS_TAKEN" );
	NumSuccessfulShots = AnalyticsManager.GetWorldStatFloatValue( "ACC_UNIT_SUCCESS_SHOTS" );
	if (NumShots > 0)
	{
		Stat.WorldValue = class'UIUtilities'.static.FormatPercentage( NumSuccessfulShots / NumShots * 100, 0 );
	}
	else
	{
		Stat.WorldValue = "--";
	}
	StatList.Additem(Stat);

	Stat.Label = AverageTurnsLeftOnMissionTimers;
	NumTimedMissions = Analytics.GetFloatValue("NUM_TIMED_MISSIONS");
	RemainingTimers = Analytics.GetFloatValue("REMAINING_TIMED_MISSION_TURNS");
	if (NumTimedMissions > 0)
	{
		Stat.YouValue = class'UIUtilities'.static.FormatFloat( RemainingTimers / NumTimedMissions, 2 );
	}
	else
	{
		Stat.YouValue = "--";
	}
	NumTimedMissions = AnalyticsManager.GetWorldStatFloatValue( "NUM_TIMED_MISSIONS" );
	RemainingTimers = AnalyticsManager.GetWorldStatFloatValue( "REMAINING_TIMED_MISSION_TURNS" );
	if (NumTimedMissions > 0)
	{
		Stat.WorldValue = class'UIUtilities'.static.FormatFloat( RemainingTimers / NumTimedMissions, 2 );
	}
	else
	{
		Stat.WorldValue = "--";
	}
	StatList.Additem(Stat);

	return StatList;
}

simulated function array<TEndGameStat> GetXPackPageStats()
{
	local TEndGameStat Stat;
	local array<TEndGameStat> StatList;
	local float NumCompletedGames;
	local float NumKills;

	NumCompletedGames = AnalyticsManager.GetWorldStatFloatValue("COMPLETED_GAMES");

	Stat.Label = ChosenKilled;
	NumKills = Analytics.GetFloatValue("CHOSEN_ASSASSIN_DEFEATED");
	NumKills += Analytics.GetFloatValue("CHOSEN_WARLOCK_DEFEATED");
	NumKills += Analytics.GetFloatValue("CHOSEN_HUNTER_DEFEATED");
	Stat.YouValue = class'UIUtilities'.static.FormatFloat( NumKills, 0 );
	NumKills = AnalyticsManager.GetWorldStatFloatValue("CHOSEN_ASSASSIN_DEFEATED");
	NumKills += AnalyticsManager.GetWorldStatFloatValue("CHOSEN_WARLOCK_DEFEATED");
	NumKills += AnalyticsManager.GetWorldStatFloatValue("CHOSEN_HUNTER_DEFEATED");
	Stat.WorldValue = class'UIUtilities'.static.FormatFloat( NumKills / NumCompletedGames, 0 );
	StatList.Additem(Stat);

	Stat.Label = DaysToFirstChosenKill;
	Stat.YouValue = Analytics.GetValueAsString("FIRST_CHOSEN_DEFEAT_DAYS", "--");
	Stat.WorldValue = AnalyticsManager.GetAvgWorldStatValueAsString("FIRST_CHOSEN_DEFEAT_DAYS", "--");
	StatList.Additem(Stat);

	Stat.Label = KillsByFactionHeroes;
	NumKills = Analytics.GetFloatValue("TOTAL_SKIRMISHER_KILLS");
	NumKills += Analytics.GetFloatValue("TOTAL_REAPER_KILLS");
	NumKills += Analytics.GetFloatValue("TOTAL_TEMPLAR_KILLS");
	NumKills += Analytics.GetFloatValue("TOTAL_LOSTABANDONED_ANNA_KILLS");
	NumKills += Analytics.GetFloatValue("TOTAL_LOSTABANDONED_MOX_KILLS");
	Stat.YouValue = class'UIUtilities'.static.FormatFloat( NumKills, 0 );
	NumKills = AnalyticsManager.GetWorldStatFloatValue("TOTAL_SKIRMISHER_KILLS");
	NumKills += AnalyticsManager.GetWorldStatFloatValue("TOTAL_REAPER_KILLS");
	NumKills += AnalyticsManager.GetWorldStatFloatValue("TOTAL_TEMPLAR_KILLS");
	NumKills += AnalyticsManager.GetWorldStatFloatValue("TOTAL_LOSTABANDONED_ANNA_KILLS");
	NumKills += AnalyticsManager.GetWorldStatFloatValue("TOTAL_LOSTABANDONED_MOX_KILLS");
	Stat.WorldValue = class'UIUtilities'.static.FormatFloat( NumKills / NumCompletedGames, 0 );
	StatList.Additem(Stat);

	Stat.Label = AbilityPointsEarned;
	Stat.YouValue = Analytics.GetValueAsString("ABILITY_POINTS_GAINED");
	Stat.WorldValue = AnalyticsManager.GetAvgWorldStatValueAsString("ABILITY_POINTS_GAINED");
	StatList.Additem(Stat);

	Stat.Label = CompletedCovertActions;
	Stat.YouValue = Analytics.GetValueAsString("COVERT_ACTIONS_COMPLETE");
	Stat.WorldValue = AnalyticsManager.GetAvgWorldStatValueAsString("COVERT_ACTIONS_COMPLETE");
	StatList.Additem(Stat);

	Stat.Label = NumLevel3SoldierBonds;
	Stat.YouValue = Analytics.GetValueAsString("NUM_SOLDIER_BONDS_3");
	Stat.WorldValue = AnalyticsManager.GetAvgWorldStatValueAsString("NUM_SOLDIER_BONDS_3");
	StatList.Additem(Stat);

	Stat.Label = NumBreakthroughsResearched;
	Stat.YouValue = Analytics.GetValueAsString("NUM_TECH_BREAKTHROUGHS");
	Stat.WorldValue = AnalyticsManager.GetAvgWorldStatValueAsString("NUM_TECH_BREAKTHROUGHS");
	StatList.Additem(Stat);

	return StatList;
}

simulated function array<TEndGameStat> GetSecondPageStats()
{
	local TEndGameStat Stat;
	local array<TEndGameStat> StatList;
	local float Hours;
	local int Days;

	Stat.Label = SoldiersWhoSawAction;
	Stat.YouValue = Analytics.GetValueAsString("SAW_ACTION");
	Stat.WorldValue = AnalyticsManager.GetAvgWorldStatValueAsString("SAW_ACTION");
	StatList.Additem(Stat);

	Stat.Label = DaysToFirstColonel;
	Stat.YouValue = Analytics.GetValueAsString("FIRST_COLONEL_DAYS", "--");
	Stat.WorldValue = AnalyticsManager.GetAvgWorldStatValueAsString("FIRST_COLONEL_DAYS", "--");
	StatList.Additem(Stat);

	Stat.Label = TotalDaysWounded;
	Hours = Analytics.GetFloatValue("ACC_UNIT_HEALING");
	if (Hours > 0)
	{
		Days = Round( Hours / 24.0 );
		Stat.YouValue = string(Days);
	}
	else
	{
		Stat.YouValue = "--";
	}
	Hours = AnalyticsManager.GetAvgWorldStatFloatValue( "ACC_UNIT_HEALING" );
	if (Hours > 0)
	{
		Days = Round( Hours / 24.0 );
		Stat.WorldValue = string( Days );
	}
	else
	{
		Stat.WorldValue = "--";
	}
	StatList.Additem(Stat);

	Stat.Label = PromotionsEarned;
	Stat.YouValue = Analytics.GetValueAsString("PROMOTIONS_EARNED");
	Stat.WorldValue = AnalyticsManager.GetAvgWorldStatValueAsString("PROMOTIONS_EARNED");
	StatList.Additem(Stat);

	Stat.Label = NumberColonels;
	Stat.YouValue = Analytics.GetValueAsString("NUM_COLONELS");
	Stat.WorldValue = AnalyticsManager.GetAvgWorldStatValueAsString("NUM_COLONELS");
	StatList.Additem(Stat);

	Stat.Label = PsiSoldiersTrained;
	Stat.YouValue = Analytics.GetValueAsString("NUM_PSIONICS");
	Stat.WorldValue = AnalyticsManager.GetAvgWorldStatValueAsString("NUM_PSIONICS");
	StatList.Additem(Stat);

	Stat.Label = NumberMaguses;
	Stat.YouValue = Analytics.GetValueAsString("NUM_MAGUSES");
	Stat.WorldValue = AnalyticsManager.GetAvgWorldStatValueAsString("NUM_MAGUSES");
	StatList.Additem(Stat);

	Stat.Label = HackRewardsEarned;
	Stat.YouValue = Analytics.GetValueAsString("HACK_REWARDS");
	Stat.WorldValue = AnalyticsManager.GetAvgWorldStatValueAsString("HACK_REWARDS");
	StatList.Additem(Stat);

	Stat.Label = RobotsHacked;
	Stat.YouValue = Analytics.GetValueAsString("SUCCESSFUL_HAYWIRES");
	Stat.WorldValue = AnalyticsManager.GetAvgWorldStatValueAsString("SUCCESSFUL_HAYWIRES");
	StatList.Additem(Stat);

	return StatList;
}

simulated function array<TEndGameStat> GetThirdPageStats()
{
	local TEndGameStat Stat;
	local array<TEndGameStat> StatList;

	Stat.Label = NumberScientists;
	Stat.YouValue = Analytics.GetValueAsString("NUM_SCIENTISTS");
	Stat.WorldValue = AnalyticsManager.GetAvgWorldStatValueAsString("NUM_SCIENTISTS");
	StatList.Additem(Stat);

	Stat.Label = NumberEngineers;
	Stat.YouValue = Analytics.GetValueAsString("NUM_ENGINEERS");
	Stat.WorldValue = AnalyticsManager.GetAvgWorldStatValueAsString("NUM_ENGINEERS");
	StatList.Additem(Stat);

	Stat.Label = DaysToMagneticWeapons;
	Stat.YouValue = Analytics.GetValueAsString("MAGNETIC_WEAPONS", "--");
	Stat.WorldValue = AnalyticsManager.GetAvgWorldStatValueAsString("MAGNETIC_WEAPONS", "--");
	StatList.Additem(Stat);

	Stat.Label = DaysToBeamWeapons;
	Stat.YouValue = Analytics.GetValueAsString("BEAM_WEAPONS", "--");
	Stat.WorldValue = AnalyticsManager.GetAvgWorldStatValueAsString("BEAM_WEAPONS", "--");
	StatList.Additem(Stat);

	Stat.Label = DaysToPlatedArmor;
	Stat.YouValue = Analytics.GetValueAsString("PLATED_ARMOR", "--");
	Stat.WorldValue = AnalyticsManager.GetAvgWorldStatValueAsString("PLATED_ARMOR", "--");
	StatList.Additem(Stat);

	Stat.Label = DaysToPowerArmor;
	Stat.YouValue = Analytics.GetValueAsString("POWERED_ARMOR", "--");
	Stat.WorldValue = AnalyticsManager.GetAvgWorldStatValueAsString("POWERED_ARMOR", "--");
	StatList.Additem(Stat);

	Stat.Label = DaysToAlienEncryption;
	Stat.YouValue = Analytics.GetValueAsString("ALIEN_ENCRYPTION", "--");
	Stat.WorldValue = AnalyticsManager.GetAvgWorldStatValueAsString("ALIEN_ENCRYPTION", "--");
	StatList.Additem(Stat);

	return StatList;
}

simulated function array<TEndGameStat> GetFourthPageStats()
{
	local TEndGameStat Stat;
	local array<TEndGameStat> StatList;

	Stat.Label = RadioRelaysBuilt;
	Stat.YouValue = Analytics.GetValueAsString("BUILT_OUTPOST");
	Stat.WorldValue = AnalyticsManager.GetAvgWorldStatValueAsString("BUILT_OUTPOST");
	StatList.Additem(Stat);

	Stat.Label = AlienFacilitiesSabotaged;
	Stat.YouValue = Analytics.GetValueAsString("NUM_SABOTAGED_FACILITIES");
	Stat.WorldValue = AnalyticsManager.GetAvgWorldStatValueAsString("NUM_SABOTAGED_FACILITIES");
	StatList.Additem(Stat);

	Stat.Label = SuppliesFromDepots;
	Stat.YouValue = Analytics.GetValueAsString("SUPPLY_DROP_SUPPLIES");
	Stat.WorldValue = AnalyticsManager.GetAvgWorldStatValueAsString("SUPPLY_DROP_SUPPLIES");
	StatList.Additem(Stat);

	Stat.Label = SuppliedFromBlackMarket;
	Stat.YouValue = Analytics.GetValueAsString("BLACKMARKET_SUPPLIES");
	Stat.WorldValue = AnalyticsManager.GetAvgWorldStatValueAsString("BLACKMARKET_SUPPLIES");
	StatList.Additem(Stat);

	Stat.Label = IntelCollected;
	Stat.YouValue = Analytics.GetValueAsString("INTEL_GATHERED");
	Stat.WorldValue = AnalyticsManager.GetAvgWorldStatValueAsString("INTEL_GATHERED");
	StatList.Additem(Stat);

	Stat.Label = IntelPaidToBlackMarket;
	Stat.YouValue = Analytics.GetValueAsString("BLACKMARKET_INTEL");
	Stat.WorldValue = AnalyticsManager.GetAvgWorldStatValueAsString("BLACKMARKET_INTEL");
	StatList.Additem(Stat);

	return StatList;
}

simulated function bool OnUnrealCommand(int cmd, int arg)
{
	// Only pay attention to presses or repeats; ignoring other input types
	// NOTE: Ensure repeats only occur with arrow keys
	if ( !CheckInputIsReleaseOrDirectionRepeat(cmd, arg) )
		return false;

	switch( cmd )
	{
		case class'UIUtilities_Input'.const.FXS_BUTTON_B:
		case class'UIUtilities_Input'.const.FXS_KEY_ESCAPE:
		case class'UIUtilities_Input'.const.FXS_R_MOUSE_DOWN:
		case class'UIUtilities_Input'.const.FXS_ARROW_LEFT:
		case class'UIUtilities_Input'.const.FXS_DPAD_LEFT:
		case class'UIUtilities_Input'.const.FXS_BUTTON_LBUMPER:
			OnBack();
			break;
		case class'UIUtilities_Input'.const.FXS_BUTTON_A:
		case class'UIUtilities_Input'.const.FXS_KEY_ENTER:
		case class'UIUtilities_Input'.const.FXS_KEY_SPACEBAR:
		case class'UIUtilities_Input'.const.FXS_ARROW_RIGHT:
		case class'UIUtilities_Input'.const.FXS_DPAD_RIGHT:
		case class'UIUtilities_Input'.const.FXS_BUTTON_RBUMPER:
			OnContinue();
			break;
		default:
			break;
	}

	return true;
}

//----------------------------------------------------------

simulated function Show( )
{
	super.Show( );
	NavHelp.Show( );
}

simulated function Hide( )
{
	super.Hide( );
	NavHelp.Hide( );
}

simulated function OnReceiveFocus( )
{
	super.OnReceiveFocus( );
	DisplayStats( );
}

simulated function OnRemoved()
{
	Movie.Pres.UICredits(true);
}

//==============================================================================
//		DEFAULTS:
//==============================================================================
DefaultProperties
{
	Package = "/ package/gfxEndGameStats/EndGameStats";
	bAnimateOnInit = false; // we handle animation differently
	bConsumeMouseEvents = true;
	InputState = eInputState_Consume;
}
