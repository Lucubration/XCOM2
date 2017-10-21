//---------------------------------------------------------------------------------------
//  FILE:    XComGameState_CampaignSettings.uc
//  AUTHOR:  Ryan McFall  --  4/6/2015
//  PURPOSE: This state object keeps track of the settings a player has selected for
//			 a single player X2 campaign. 
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class XComGameState_CampaignSettings extends XComGameState_BaseObject
	native(Core);

// When adding fields to this class, be sure to include them in CopySettings below.

var privatewrite string StartTime;				// Tracks when the player initiated this campaign. This is used as the true UID for this campaign.
var privatewrite int GameIndex;					// m_iGames at the time this campaign was started. Used as part of the save descriptor, but is not unique since it relies on deletable profile data.
var privatewrite int DifficultySetting;			// 0:Easy to 3:Impossible
var privatewrite int LowestDifficultySetting;	// 0:Easy to 3:Impossible.  Used for calculating which achievements to unlock, for users who changed their difficulty setting while playing the game.
var privatewrite bool bIronmanEnabled;			// TRUE indicates that this campaign was started with Ironman enabled
var privatewrite bool bTutorialEnabled;			// TRUE indicates that this campaign was started with the tutorial enabled
var privatewrite bool bXPackNarrativeEnabled;	// TRUE indicates that this campaign was started with Xpack narrative content enabled
var privatewrite bool bIntegratedDLCEnabled;	// TRUE indicates that special gameplay to incorporate DLC2 and 3 into the XPack is enabled
var privatewrite bool bSuppressFirstTimeNarrative; // TRUE, the tutorial narrative moments will be skipped
var privatewrite array<name> SecondWaveOptions;	// A list of identifiers indicating second wave options that are enabled
var privatewrite array<name> RequiredDLC;		// A list of DLC ( either mods or paid ) that this campaign is using
var privatewrite array<name> EnabledOptionalNarrativeDLC; // A list of DLC where optional narrative content for this campaign is enabled

//Dev options
var bool bCheatStart;		// Calls 'DebugStuff' in XGStrategy when starting a new game. Skips the first battle entirely and grants facilities / items
var bool bSkipFirstTactical;// Starts the campaign by simulating combat in the first mission

var string BizAnalyticsCampaignID;

// The new difficulty sliders:
//
//  0 - 20: Rookie
// 20 - 40: Veteran
// 40 - 60: Commander
// 60 - 80: Classic
// 80 - 100: Impossible
// 
var privatewrite float TacticalDifficulty;
var privatewrite float StrategyDifficulty;
var privatewrite float GameLength;

function SetStartTime(string InStartTime)
{
	StartTime = InStartTime;
}

function SetDifficulty(int NewDifficulty, optional float NewTacticalDifficulty = -1, optional float NewStrategyDifficulty = -1, optional float NewGameLength = -1, optional bool IsPlayingGame = false, optional bool InitialDifficultyUpdate = false)
{
	local bool bDifficultyChanged;

	bDifficultyChanged = InitialDifficultyUpdate;

	if( DifficultySetting != NewDifficulty )
	{
		DifficultySetting = NewDifficulty;
		bDifficultyChanged = true;
	}

	if( NewTacticalDifficulty < 0 )
	{
		NewTacticalDifficulty = class'UIShellDifficulty'.default.DifficultyConfigurations[NewDifficulty].TacticalDifficulty;
	}

	if( TacticalDifficulty != NewTacticalDifficulty )
	{
		TacticalDifficulty = NewTacticalDifficulty;
		bDifficultyChanged = true;
	}

	if( NewStrategyDifficulty < 0 )
	{
		NewStrategyDifficulty = class'UIShellDifficulty'.default.DifficultyConfigurations[NewDifficulty].StrategyDifficulty;
	}

	if( StrategyDifficulty != NewStrategyDifficulty )
	{
		StrategyDifficulty = NewStrategyDifficulty;
		bDifficultyChanged = true;
	}

	if( NewGameLength < 0 )
	{
		NewGameLength = class'UIShellDifficulty'.default.DifficultyConfigurations[NewDifficulty].GameLength;
	}

	if( GameLength != NewGameLength )
	{
		GameLength = NewGameLength;
		bDifficultyChanged = true;
	}

	if( bDifficultyChanged )
	{
		if( IsPlayingGame )
		{
			LowestDifficultySetting = Min(LowestDifficultySetting, NewDifficulty);
		}
		else
		{
			LowestDifficultySetting = NewDifficulty;
		}

		// after changing difficulties, all the game caches must be rebuilt
		class'X2DataTemplateManager'.static.RebuildAllTemplateGameCaches();
	}
}

function SetIronmanEnabled(bool bEnabled)
{
	bIronmanEnabled = bEnabled;
}

function SetTutorialEnabled(bool bEnabled)
{
	bTutorialEnabled = bEnabled;
}

function SetXPackNarrativeEnabled(bool bEnabled)
{
	bXPackNarrativeEnabled = bEnabled;
}

function SetSuppressFirstTimeNarrativeEnabled(bool bEnabled)
{
	bSuppressFirstTimeNarrative = bEnabled;
}

function SetGameIndexFromProfile()
{
	GameIndex = `XPROFILESETTINGS.Data.m_iGames + 1;
}

function AddSecondWaveOption(name OptionEnabled)
{
	SecondWaveOptions.AddItem(OptionEnabled);
}

function RemoveSecondWaveOption(name OptionDisabled)
{
	SecondWaveOptions.RemoveItem(OptionDisabled);
}

function bool IsSecondWaveOptionEnabled(name OptionID)
{
	return (SecondWaveOptions.Find(OptionID) != INDEX_NONE);
}

function AddRequiredDLC(name DLCEnabled)
{
	RequiredDLC.AddItem(DLCEnabled);
}

function RemoveAllRequiredDLC()
{
	RequiredDLC.Remove(0, RequiredDLC.Length);
}

function RemoveRequiredDLC(name DLCDisabled)
{
	RequiredDLC.RemoveItem(DLCDisabled);
}

function AddOptionalNarrativeDLC(name DLCEnabled)
{
	if(RequiredDLC.Find(DLCEnabled) != INDEX_NONE)
	{
		EnabledOptionalNarrativeDLC.AddItem(DLCEnabled);
	}
}

function bool HasOptionalNarrativeDLCEnabled(name DLCName)
{
	return (EnabledOptionalNarrativeDLC.Find(DLCName) != INDEX_NONE);
}

function RemoveAllOptionalNarrativeDLC()
{
	EnabledOptionalNarrativeDLC.Remove(0, EnabledOptionalNarrativeDLC.Length);
}

function RemoveOptionalNarrativeDLC(name DLCDisabled)
{
	EnabledOptionalNarrativeDLC.RemoveItem(DLCDisabled);
}

function SetIntegratedDLCEnabled(bool bEnabled)
{
	bIntegratedDLCEnabled = bEnabled;
}

function bool HasIntegratedDLCEnabled()
{
	return bIntegratedDLCEnabled;
}

static function CopySettings(XComGameState_CampaignSettings Src, XComGameState_CampaignSettings Dest)
{
	Dest.StartTime = Src.StartTime;
	Dest.DifficultySetting = Src.DifficultySetting;
	Dest.LowestDifficultySetting = Src.LowestDifficultySetting;
	Dest.bIronmanEnabled = Src.bIronmanEnabled;
	Dest.bTutorialEnabled = Src.bTutorialEnabled;
	Dest.bXPackNarrativeEnabled = Src.bXPackNarrativeEnabled;
	Dest.bIntegratedDLCEnabled = Src.bIntegratedDLCEnabled;
	Dest.bSuppressFirstTimeNarrative = Src.bSuppressFirstTimeNarrative;
	Dest.SecondWaveOptions = Src.SecondWaveOptions;
	Dest.RequiredDLC = Src.RequiredDLC;
	Dest.EnabledOptionalNarrativeDLC = Src.EnabledOptionalNarrativeDLC;
	Dest.bCheatStart = Src.bCheatStart;
	Dest.bSkipFirstTactical = Src.bSkipFirstTactical;
}

static function CopySettingsFromOnlineEventMgr(XComGameState_CampaignSettings Dest)
{
	local XComOnlineEventMgr EventMgr;

	EventMgr = `ONLINEEVENTMGR;

	//Dest.StartTime = EventMgr.CampaignStartTime;
	Dest.DifficultySetting = EventMgr.CampaignDifficultySetting;
	Dest.LowestDifficultySetting = EventMgr.CampaignLowestDifficultySetting;
	Dest.bIronmanEnabled = EventMgr.CampaignbIronmanEnabled;
	Dest.bTutorialEnabled = EventMgr.CampaignbTutorialEnabled;
	Dest.bXPackNarrativeEnabled = EventMgr.CampaignbXPackNarrativeEnabled;
	Dest.bIntegratedDLCEnabled = EventMgr.CampaignbIntegratedDLCEnabled;
	Dest.bSuppressFirstTimeNarrative = EventMgr.CampaignbSuppressFirstTimeNarrative;
	Dest.SecondWaveOptions = EventMgr.CampaignSecondWaveOptions;
	Dest.RequiredDLC = EventMgr.CampaignRequiredDLC;
	Dest.EnabledOptionalNarrativeDLC = EventMgr.CampaignOptionalNarrativeDLC;
}

static function CreateCampaignSettings(
	XComGameState StartState, 
	bool InTutorialEnabled, 
	bool InXPackNarrativeEnabled,
	bool InIntegratedDLCEnabled,
	int SelectedDifficulty,
	float InTacticalDifficulty,
	float InStrategyDifficulty,
	float InGameLength,
	bool InSuppressFirstTimeVO,
	optional array<name> OptionalNarrativeDLC,
	optional array<name> InSecondWaveOptions)
{
	local XComGameState_CampaignSettings Settings;
	local XComOnlineEventMgr EventManager;
	local int i;

	Settings = XComGameState_CampaignSettings(StartState.CreateNewStateObject(class'XComGameState_CampaignSettings'));
	Settings.SetDifficulty(SelectedDifficulty, InTacticalDifficulty, InStrategyDifficulty, InGameLength, , true);
	Settings.SetTutorialEnabled(InTutorialEnabled);
	Settings.SetXPackNarrativeEnabled(InXPackNarrativeEnabled);
	Settings.SetIntegratedDLCEnabled(InIntegratedDLCEnabled);
	Settings.SetSuppressFirstTimeNarrativeEnabled(InSuppressFirstTimeVO);
	Settings.SetGameIndexFromProfile();

	Settings.RemoveAllRequiredDLC();
	Settings.RemoveAllOptionalNarrativeDLC();
	EventManager = `ONLINEEVENTMGR;
	for(i = EventManager.GetNumDLC() - 1; i >= 0; i--)
	{
		Settings.AddRequiredDLC(EventManager.GetDLCNames(i));
	}

	// If we are coming from the tutorial, copy the optional narrative DLC here so it can be used when setting up the strategy objectives
	if (InTutorialEnabled && OptionalNarrativeDLC.Length == 0)
	{
		Settings.EnabledOptionalNarrativeDLC = EventManager.CampaignOptionalNarrativeDLC;
	}
	else
	{
		for (i = 0; i < OptionalNarrativeDLC.Length; i++)
		{
			Settings.AddOptionalNarrativeDLC(OptionalNarrativeDLC[i]);
		}
	}

	Settings.BizAnalyticsCampaignID = `FXSLIVE.GetGUID( );

	// If we are coming from the tutorial, copy the Second Wave options here so they can be used when setting up the strategy objectives
	if (InTutorialEnabled && InSecondWaveOptions.Length == 0)
	{
		Settings.SecondWaveOptions = EventManager.CampaignSecondWaveOptions;
	}
	else
	{
	Settings.SecondWaveOptions = InSecondWaveOptions;
}
}

static event int GetCampaignDifficultyFromSettings()
{
	local XComGameState_CampaignSettings SettingsObject;

	SettingsObject = XComGameState_CampaignSettings(class'XComGameStateHistory'.static.GetGameStateHistory().GetSingleGameStateObjectForClass(class'XComGameState_CampaignSettings', true));
	if (SettingsObject != none)
		return SettingsObject.DifficultySetting;

	return default.DifficultySetting;
}

static event int GetTacticalDifficultyIndexFromSettings()
{
	local int Index;
	local float CurrentDifficulty;

	CurrentDifficulty = GetTacticalDifficultyFromSettings();
	
	for( Index = 0; Index < class'UIShellDifficulty'.default.TacticalIndexThresholds.Length; ++Index )
	{
		if( CurrentDifficulty < class'UIShellDifficulty'.default.TacticalIndexThresholds[Index] )
		{
			return Index - 1;
		}
	}

	return class'UIShellDifficulty'.default.TacticalIndexThresholds.Length - 2;
}

static event int GetStrategyDifficultyIndexFromSettings()
{
	local int Index;
	local float CurrentDifficulty;

	CurrentDifficulty = GetStrategyDifficultyFromSettings();

	for( Index = 0; Index < class'UIShellDifficulty'.default.StrategyIndexThresholds.Length; ++Index )
	{
		if( CurrentDifficulty < class'UIShellDifficulty'.default.StrategyIndexThresholds[Index] )
		{
			return Index - 1;
		}
	}

	return class'UIShellDifficulty'.default.StrategyIndexThresholds.Length - 2;
}

static event int GetGameLengthIndexFromSettings()
{
	local int Index;
	local float CurrentGameLength;

	CurrentGameLength = GetGameLengthFromSettings();

	for( Index = 0; Index < class'UIShellDifficulty'.default.GameLengthIndexThresholds.Length; ++Index )
	{
		if( CurrentGameLength < class'UIShellDifficulty'.default.GameLengthIndexThresholds[Index] )
		{
			return Index - 1;
		}
	}

	return class'UIShellDifficulty'.default.GameLengthIndexThresholds.Length - 2;
}

static function bool IsSecondWaveOptionEnabledForSettings(name OptionID)
{
	local XComGameState_CampaignSettings SettingsObject;

	SettingsObject = XComGameState_CampaignSettings(class'XComGameStateHistory'.static.GetGameStateHistory().GetSingleGameStateObjectForClass(class'XComGameState_CampaignSettings', true));
	return SettingsObject != None && SettingsObject.IsSecondWaveOptionEnabled(OptionID);
}

static native function float GetTacticalDifficultyFromSettings();
static native function float GetStrategyDifficultyFromSettings();
static native function float GetGameLengthFromSettings();

static native function int ScaleArrayIntValueForTacticalDifficulty(const out array<int> InArray);
static native function int ScaleArrayIntValueForStrategyDifficulty(const out array<int> InArray);
static native function int ScaleArrayIntValueForGameLength(const out array<int> InArray);

static native function float ScaleArrayFloatValueForTacticalDifficulty(const out array<float> InArray);
static native function float ScaleArrayFloatValueForStrategyDifficulty(const out array<float> InArray);
static native function float ScaleArrayFloatValueForGameLength(const out array<float> InArray);


defaultproperties
{
	DifficultySetting=1 //Default to 'normal' difficulty
	LowestDifficultySetting=1 //Default to 'normal' difficulty
	TacticalDifficulty = 25
	StrategyDifficulty = 25
	GameLength=33
	bTutorialEnabled=false
	bXPackNarrativeEnabled=false
	bIntegratedDLCEnabled=false
	bCheatStart=false
	bSkipFirstTactical=false
}