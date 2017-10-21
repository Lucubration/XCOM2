//  *********   FIRAXIS SOURCE CODE   ******************
//  FILE:    UIChallengeMode_SquadSelect
//  AUTHOR:  Timothy Talley -- 02/23/2015
//
//  PURPOSE: Displays the Challenge Mode Squad selection options based on the mock-up at
//      N:\2KGBAL\Projects\XCOM 2\Art\UI\DailyChallenge
//
//
// - Section: Header
//     - Title
//     - Challenge Operation Name
//     - Boosts
// - Section: Objectives
//     - Object List
//     - Power Level
//     - Location
//     - (REMOVED) Edit Commander Button
// - (REMOVED) Section: Commander
//     - (REMOVED) Soldier Template
//     - (REMOVED) Commander Medals
// - (REMOVED) Section: Tactical Options
//     - (REMOVED) Option 1: (Activate) Boosts Solider [#] [stat] by [x] and Reduces Soldier [#] [stat] by [y]
//     - (REMOVED) Option 2: (Activate) 
// - Section: Squad
//     - Soldier #1 Template
//     - Soldier #2 Template
//     - Soldier #3 Template
//     - Soldier #4 Template
//     - Soldier #5 Template
//     - Soldier #6 Template
// - Button: Back
// - Button: View Medals
// - Button: Accept Challenge
//
//---------------------------------------------------------------------------------------
//  Copyright (c) 2009-2016 Firaxis Games, Inc. All rights reserved.
//--------------------------------------------------------------------------------------- 

class UIChallengeMode_SquadSelect extends UIScreen
	dependson(UIChallengeLeaderboards);


//--------------------------------------------------------------------------------------- 
// UI Objects
//
var UIPanel								m_InfoPanel;
var UIPanel								m_SquadInfoButton;

var UIPanel								m_ReplayPanel;

var UIButton							m_ViewLeaderboardButton;
var UILargeButton						m_AcceptChallengeButton;
var UIDropdown							m_IntervalDropdown;	        // List of all returned Intervals - TEMP


var UIButton							m_ViewGlobalLeaderboardButton;
var UIButton							m_ViewFriendLeaderboardButton;
var UIButton							m_ViewReplayButton;

var UIPanel								m_UnitSlotContainer;
var array<UIPanel>						m_UnitInfoPanels;
var array<UIPanel>						m_InfoButtonPanels;

var int									m_ViewReplayIndex;
var int									m_NumSoldierSlots;
var int									m_LocalPlayerScore;

var bool								m_bViewingSoldiers;
var bool								m_bGlobalLeaderboards;


//--------------------------------------------------------------------------------------- 
// Localization Labels
//
var localized string					m_strSquadInfo;
var localized string					m_strChallengeModeTitle;
var localized string					m_strObjectiveTitle;
var localized string					m_strTacticalOptionsTitle;
var localized string					m_strDeactivateButtonLabel;
var localized string					m_strActivateButtonLabel;
var localized string					m_strBoostActiveLabel;
var localized string                    m_strBackButtonLabel;
var localized string					m_strViewMedalsButtonLabel;
var localized string					m_strViewLeaderboardButtonLabel;
var localized string					m_strAcceptChallengeButtonLabel;
var localized string					m_strMostlyTag;
var localized string					m_strToggleLeaderboard;

var localized string					m_strCompletedScore;
var localized string					m_strBestRank;
var localized string					m_strPlayersCompleted;

var localized string					m_strNoAchieveTitle;
var localized string					m_strNoAchieveBody;

var localized string					m_strChallengeInfoBody;

//bsg-jneal (5.5.17): adding new navhelp labels
var localized string					m_strViewCharacterDetailsLabel;
var localized string					m_strChallengeInfo;
//bsg-jneal (5.5.17): end

var localized string					m_strDifficultyLabel;
var localized string					m_strLocationLabel;
var localized string					m_strCreatorLabel;
var localized string					m_strCombatDataLabel;
var localized string					m_strAdditionalDataLabel;
var localized string					m_strPlayerDataLabel;
var localized string					m_strViewReplayButtonLabel;
var localized string					m_strViewCharInfoButtonLabel;

var localized string					m_strChallengeCompleteLabel;
var localized string					m_strAverageScoreLabel;
var localized string					m_strHighestScoreLabel;
var localized string					m_strAverageRankLabel;
var localized string					m_strBestRankLabel;

var localized string					m_strTopPlayersLabel;
var localized string					m_strGlobalLeaderboardsLabel;
var localized string					m_strFriendsLeaderboardsLabel;

var localized string					m_strSquadHeader;
var localized string					m_strEnemiesHeader;
var localized string					m_strObjectivesHeader;
var localized string					m_strChallengeExpire;
var localized string					m_strExpireDay;
var localized string					m_strExpireDays;
var localized string					m_strExpireHr;
var localized string					m_strExpireHrs;
var localized string					m_strExpireMin;
var localized string					m_strExpireMins;

var localized string					m_strSquadConnector;

var UIText								m_ObjectiveText;

const MAX_UNIT_SLOTS = 9;
const MAX_LEADERBOARDS = 5;


//--------------------------------------------------------------------------------------- 
// Challenge Data
//
struct StatsInfo
{
	var INT BestScore;
	var INT BestScoreDate;
	var INT ChallengesCompleted;
	var INT AverageChallengeScores;
};
var array<IntervalInfo>					m_arrIntervals;
var qword								m_CurrentIntervalSeedID;
var FriendFetchInfo						m_FriendFetch;
var StatsInfo							m_ChallengeStats;
var array<delegate<RequestDelegate> >	m_FiraxisLiveRequestDelegates;
var delegate<RequestDelegate>			m_CurrentRequestDelegate;
var int									m_TotalPlayerCount;


//--------------------------------------------------------------------------------------- 
// X2 Battle Data
//
var XComGameState_BattleData			m_BattleData;
var XComGameState_ChallengeData			m_ChallengeData;
var XComGameState_ObjectivesList		m_ObjectivesList;
var string								m_NextMapCommand;


//--------------------------------------------------------------------------------------- 
// Cache References
//
var XComGameStateHistory				History;
var OnlineSubsystem						OnlineSub;
var XComOnlineEventMgr					OnlineEventMgr;
var X2ChallengeModeInterface			ChallengeModeInterface;
var X2TacticalChallengeModeManager		ChallengeModeManager;
var XComChallengeModeManager			ChallengesManager;
var UINavigationHelp					m_NavHelp;
var X2MPShellManager					m_kMPShellManager;

var UniqueNetId							m_LocalPlayerID;
var bool								m_bUpdatingLeaderboardData;
var array<TLeaderboardEntry>			m_LeaderboardsData;
var array<byte>							PlayerGameData;
var bool								m_DelegatesHookedup;
var string								m_strCacheChallengeInfo;


//==============================================================================
//		INITIALIZATION:
//==============================================================================
simulated function CacheUpdate()
{
	local int ChallengeIdx, PlayerSeedId, DropdownIdx;
	History = `XCOMHISTORY;
	OnlineSub = Class'GameEngine'.static.GetOnlineSubsystem();
	OnlineEventMgr = `ONLINEEVENTMGR;
	ChallengeModeInterface = `CHALLENGEMODE_INTERFACE;
	ChallengesManager = XComEngine(Class'GameEngine'.static.GetEngine()).ChallengeModeManager;

	if (m_arrIntervals.Length > 0)
	{
		DropdownIdx = int(m_IntervalDropdown.GetSelectedItemData());
		PlayerSeedId = m_arrIntervals[DropdownIdx].IntervalSeedID.A;
		ChallengeIdx = ChallengesManager.FindChallengeIndex(PlayerSeedId);
		`log(`location @ `ShowVar(PlayerSeedId) @ `ShowVar(ChallengeIdx),,'FiraxisLive');
		if( ChallengeIdx > -1 )
		{
			History.ReadHistoryFromChallengeModeManager(ChallengeIdx);
			m_BattleData = XComGameState_BattleData(History.GetSingleGameStateObjectForClass(class'XComGameState_BattleData'));
			m_ChallengeData = XComGameState_ChallengeData(History.GetSingleGameStateObjectForClass(class'XComGameState_ChallengeData'));
			m_ObjectivesList = XComGameState_ObjectivesList(History.GetSingleGameStateObjectForClass(class'XComGameState_ObjectivesList'));
			UpdateCacheChallengeInfo();
		}
	}
}

simulated function UpdateCacheChallengeInfo()
{
	local XGCharacterGenerator CharacterGenerator;
	local X2CharacterTemplate CharTemplate;
	local XComGameState_Unit Unit, NewUnit;
	local XComGameState NewGameState;
	local XComGameState_BattleData NewBattleData;
	local TSoldier GeneratedSoldierData;

	NewGameState = History.GetStartState();
	if (NewGameState == None)
	{
		NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Challenge Localization Update");
	}

	class'Engine'.static.SetRandomSeeds(m_BattleData.iLevelSeed);
	NewBattleData = XComGameState_BattleData(NewGameState.ModifyStateObject(class'XComGameState_BattleData', m_BattleData.ObjectID));
	NewBattleData.m_strOpName = class'XGMission'.static.GenerateOpName(false);
	foreach History.IterateByClassType(class'XComGameState_Unit', Unit)
	{
		if (Unit.GetTeam() == eTeam_XCom && Unit.IsSoldier())
		{
			CharTemplate = Unit.GetMyTemplate();
			CharacterGenerator = `XCOMGRI.Spawn(CharTemplate.CharacterGeneratorClass);
			GeneratedSoldierData = CharacterGenerator.CreateTSoldierFromUnit(Unit, NewGameState);
			CharacterGenerator.Destroy();

			`log(`location @ "Setting Data:" @ `ShowVar(GeneratedSoldierData.strFirstName) @ `ShowVar(GeneratedSoldierData.strLastName) @ `ShowVar(GeneratedSoldierData.strNickName) @ `ShowVar(GeneratedSoldierData.kAppearance.nmLanguage) @ `ShowVar(GeneratedSoldierData.kAppearance.nmVoice));
			NewUnit = XComGameState_Unit(NewGameState.ModifyStateObject(class'XComGameState_Unit', Unit.ObjectID));
			NewUnit.SetCharacterName(GeneratedSoldierData.strFirstName, GeneratedSoldierData.strLastName, GeneratedSoldierData.strNickName);
			NewUnit.kAppearance.nmLanguage = GeneratedSoldierData.kAppearance.nmLanguage;
			NewUnit.kAppearance.nmVoice = GeneratedSoldierData.kAppearance.nmVoice;
		}
	}

	if (NewGameState != History.GetStartState())
	{
		History.AddGameStateToHistory(NewGameState);
	}

	SetHeaderData();
}

simulated function HookupDelegates()
{
	local byte LocalUserNum;
	ScriptTrace();
	`log(`location @ `ShowVar(m_DelegatesHookedup));
	if (!m_DelegatesHookedup)
	{
		LocalUserNum = `ONLINEEVENTMGR.LocalUserIndex;

		OnlineSub.PlayerInterface.GetUniquePlayerId(`ONLINEEVENTMGR.LocalUserIndex, m_LocalPlayerID);
		OnlineSub.PlayerInterface.AddRequestUserInformationCompleteDelegate(OnRequestUserInformationComplete);
		OnlineSub.PlayerInterface.AddFriendsChangeDelegate(LocalUserNum, OnFriendsChange);
		OnlineSub.PlayerInterface.AddReadFriendsCompleteDelegate(LocalUserNum, OnReadFriendsComplete);

		ChallengeModeInterface.AddReceivedChallengeModeIntervalStartDelegate(OnReceivedChallengeModeIntervalStart);
		ChallengeModeInterface.AddReceivedChallengeModeIntervalEndDelegate(OnReceivedChallengeModeIntervalEnd);
		ChallengeModeInterface.AddReceivedChallengeModeIntervalEntryDelegate(OnReceivedChallengeModeIntervalEntry);
		ChallengeModeInterface.AddReceivedChallengeModeSeedDelegate(OnReceivedChallengeModeSeed);
		ChallengeModeInterface.AddReceivedChallengeModeGetEventMapDataDelegate(OnReceivedChallengeModeGetEventMapData);
		ChallengeModeInterface.AddReceivedChallengeModeLeaderboardStartDelegate(OnReceivedChallengeModeLeaderboardStart);
		ChallengeModeInterface.AddReceivedChallengeModeLeaderboardEndDelegate(OnReceivedChallengeModeLeaderboardEnd);
		ChallengeModeInterface.AddReceivedChallengeModeLeaderboardEntryDelegate(OnReceivedChallengeModeLeaderboardEntry);

		m_kMPShellManager.AddLeaderboardFetchCompleteDelegate(OnLeaderBoardFetchComplete);
		m_DelegatesHookedup = true;
	}
}

simulated function InitScreen( XComPlayerController InitController, UIMovie InitMovie, optional name InitName )
{
	local int i;
	local name panelName;

	//
	// Setup Handlers
	//
	m_kMPShellManager = XComShellPresentationLayer(InitController.Pres).m_kMPShellManager;
	CacheUpdate();
	SubscribeToOnCleanupWorld();
	ChallengeModeManager = Spawn(class'X2TacticalChallengeModeManager', self);
	ChallengeModeManager.Init();
	HookupDelegates();
	m_kMPShellManager.CancelLeaderboardsFetch();

	ChallengeModeInterface.AddReceivedChallengeModeGetGameSaveDelegate(OnReceivedChallengeModeGetGameSave);
	//
	// Initialize Screen
	//
	super.InitScreen(InitController, InitMovie, InitName);

	m_InfoPanel = Spawn(class'UIPanel', self);
	m_InfoPanel.InitPanel('infoPanel');

	m_SquadInfoButton = Spawn(class'UIPanel', m_InfoPanel);
	m_SquadInfoButton.InitPanel('squadInfoButton');

	//bsg-jneal (5.5.17): use navhelp for most screen interaction when using controller
	if (!`ISCONTROLLERACTIVE)
	{
		m_SquadInfoButton.ProcessMouseEvents(SquadInfoMouseEvents);

		m_ViewLeaderboardButton = Spawn(class'UIButton', self);
		m_ViewLeaderboardButton.InitButton('viewLeaderboardButton', m_strViewLeaderboardButtonLabel, OnLeaderboardButton, eUIButtonStyle_HOTLINK_BUTTON);
		m_ViewLeaderboardButton.AnchorBottomCenter();
		m_ViewLeaderboardButton.SetGamepadIcon(class'UIUtilities_Input'.const.ICON_Y_TRIANGLE);
		m_ViewLeaderboardButton.SetPosition(-80, -50);
	}
	else
	{
		m_SquadInfoButton.Hide();
	}
	//bsg-jneal (5.5.17): end

	//bsg-jneal (5.5.17): display X to start challenge on button
	m_AcceptChallengeButton = Spawn(class'UILargeButton', self);
	if(`ISCONTROLLERACTIVE)
	{
		m_AcceptChallengeButton.InitLargeButton('acceptChallengeButton', class'UIUtilities_Text'.static.InjectImage(
				class'UIUtilities_Input'.static.GetGamepadIconPrefix() $ class'UIUtilities_Input'.const.ICON_X_SQUARE, 26, 26, -13) @ m_strAcceptChallengeButtonLabel, "", OnAcceptButton, eUILargeButtonStyle_READY);
	}
	else
	{
		m_AcceptChallengeButton.InitLargeButton('acceptChallengeButton', m_strAcceptChallengeButtonLabel, "", OnAcceptButton, eUILargeButtonStyle_READY);
	}
	//bsg-jneal (5.5.17): end

	m_AcceptChallengeButton.AnchorBottomRight();
	m_AcceptChallengeButton.SetGamepadIcon(class'UIUtilities_Input'.static.GetAdvanceButtonIcon());

	m_ReplayPanel = Spawn(class'UIPanel', self);
	m_ReplayPanel.InitPanel('replayPanel');
	//bsg-jneal (5.5.17): use controller button styles while gamepad is active
	m_ViewGlobalLeaderboardButton = Spawn(class'UIButton', m_ReplayPanel);
	if(`ISCONTROLLERACTIVE)
	{
		m_ViewGlobalLeaderboardButton.InitButton('GlobalButtonChallenge', m_strGlobalLeaderboardsLabel, , eUIButtonStyle_SELECTED_SHOWS_HOTLINK);
		m_ViewGlobalLeaderboardButton.mc.FunctionString("setIcon", "");
		m_ViewGlobalLeaderboardButton.SetSelected(true);
	}
	else
	{
		m_ViewGlobalLeaderboardButton.InitButton('GlobalButtonChallenge', m_strGlobalLeaderboardsLabel, TopPlayersButtonCallback, eUIButtonStyle_HOTLINK_BUTTON);
	}

	m_ViewFriendLeaderboardButton = Spawn(class'UIButton', m_ReplayPanel);
	if(`ISCONTROLLERACTIVE)
	{
		m_ViewFriendLeaderboardButton.InitButton('FriendButtonChallenge', m_strFriendsLeaderboardsLabel, , eUIButtonStyle_SELECTED_SHOWS_HOTLINK);
		m_ViewFriendLeaderboardButton.mc.FunctionString("setIcon", "");
	}
	else
	{
		m_ViewFriendLeaderboardButton.InitButton('FriendButtonChallenge', m_strFriendsLeaderboardsLabel, FriendRanksButtonCallback, eUIButtonStyle_HOTLINK_BUTTON);
	}
	//bsg-jneal (5.5.17): end

	m_UnitSlotContainer = Spawn(class'UIPanel', self);
	m_UnitSlotContainer.InitPanel('unitSlotContainer');
	m_UnitSlotContainer.Hide();

	for (i = 0; i < MAX_UNIT_SLOTS; i++)
	{
		m_UnitInfoPanels.AddItem(Spawn(class'UIPanel', m_UnitSlotContainer));
		panelName = name("unitSlot"$i);
		m_UnitInfoPanels[i].InitPanel(panelName);
		m_InfoButtonPanels.AddItem(Spawn(class'UIPanel', m_UnitInfoPanels[i]));
		m_InfoButtonPanels[i].InitPanel('InfoButton');
		m_InfoButtonPanels[i].ProcessMouseEvents(AbilityInfoMouseEvents);
	}
	
	//
	// TEMP: Interval Dropdown for easy selection ...
	//
	m_IntervalDropdown = Spawn(class'UIDropdown', self);
	m_IntervalDropdown.InitDropdown('intervalDropdown', "Intervals", IntervalDropdownSelectionChange);
	m_IntervalDropdown.SetAnchor(class'UIUtilities'.const.ANCHOR_TOP_LEFT);
	m_IntervalDropdown.SetPosition(450, 65);
	m_IntervalDropdown.Hide();
	UpdateIntervalDropdown();

	//
	// Server Data Updates
	//
	RequestServerDataUpdate();

	// Update the embedded timer
	SetTimer(60.0f, true, nameof(SetHeaderData));
}

simulated function ToggleIntervalDropdown()
{
	`log(`location);
	m_IntervalDropdown.ToggleVisible();
}

simulated function OnInit()
{
	super.OnInit();

	m_NavHelp = PC.Pres.GetNavHelp();

	Navigator.Clear();

	//bsg-jneal (5.5.17): set initial highlight on init
	if(`ISCONTROLLERACTIVE)
	{
		m_NavHelp.SetY(-15); //bsg-jneal (4.13.17): adjust navhelp position with gamepad
		MC.FunctionNum("setHighlight", m_ViewReplayIndex);
	}
	//bsg-jneal (5.5.17): end

	OnlineSub.PlayerInterface.RequestUserInformation(`ONLINEEVENTMGR.LocalUserIndex, m_LocalPlayerID);
}

function NoAchievementPopup()
{
	local TDialogueBoxData DialogData;

	DialogData.strAccept = class'XComPresentationLayerBase'.default.m_strOK;

	DialogData.strTitle = m_strChallengeModeTitle;
	DialogData.strText = m_strChallengeInfoBody;
	Movie.Pres.UIRaiseDialog(DialogData);
	
	DialogData.strTitle = m_strNoAchieveTitle;
	DialogData.strText = m_strNoAchieveBody;
	Movie.Pres.UIRaiseDialog(DialogData);
}


function int GetIntervalIndex(qword IntervalSeedID)
{
	local int Index;

	for (Index = 0; Index < m_arrIntervals.Length; ++Index)
	{
		if (m_arrIntervals[Index].IntervalSeedID == IntervalSeedID)
		{
			return Index;
		}
	}
	return -1;
}

function OnRequestUserInformationComplete(bool bWasSuccessful, UniqueNetId PlatformID, string PlayerName)
{
	local int Index;
	`log(`location @ `ShowVar(OnlineSub.UniqueNetIdToString(PlatformID), PlatformID) @ `ShowVar(PlayerName));

	// Lookup the PlatformID in the current data
	Index = FindLeaderboardIndex(PlatformID, true /*bSearchByPlatformID*/);
	if (Index != -1)
	{
		// Update the leaderboard entry
		m_LeaderboardsData[Index].strPlayerName = PlayerName;
		UpdateLeaderboardData();
	}
}

function int FindLeaderboardIndex(UniqueNetId PlayerID, optional bool bSearchByPlatformID=false)
{
	local int Index;

	for (Index = 0; Index < m_LeaderboardsData.Length; ++Index)
	{
		if ((bSearchByPlatformID && m_LeaderboardsData[Index].PlatformID == PlayerID) || m_LeaderboardsData[Index].PlayerID == PlayerID)
		{
			break;
		}
	}

	if (m_LeaderboardsData.Length == 0 || Index >= m_LeaderboardsData.Length)
	{
		ScriptTrace();
		`log(`location @ "Returning unfound index for" @ `ShowVar(OnlineSub.UniqueNetIdToString(PlayerID), PlayerID));
		Index = -1;
	}

	return Index;
}

function OnReceivedChallengeModeLeaderboardStart(int NumEntries, qword IntervalSeedID)
{
	`log(`location @ `ShowVar(NumEntries) @ QWordToString(IntervalSeedID), , 'XCom_Online');
	m_LeaderboardsData.Length = 0;
	m_bUpdatingLeaderboardData = true;
}

function OnReceivedChallengeModeLeaderboardEnd(qword IntervalSeedID)
{
	`log(`location @ QWordToString(IntervalSeedID), , 'XCom_Online');
	m_bUpdatingLeaderboardData = false;
	UpdateData();
	Movie.Pres.UICloseProgressDialog();
	UpdateNavHelp();

	if (`XPROFILESETTINGS.Data.m_bPlayerHasSeenNoAchievesInChallenge == false)
	{
		`XPROFILESETTINGS.Data.m_bPlayerHasSeenNoAchievesInChallenge = true; //Only allow this to be activate for this profile, never toggled back. 
		`ONLINEEVENTMGR.SaveProfileSettings(true);
		NoAchievementPopup();
	}
	RequestFinished(m_CurrentRequestDelegate);
}

/**
* Received when the Challenge Mode data has been read.
*
* @param Entry, Struct filled with all the data incoming from the server
*/
function OnReceivedChallengeModeLeaderboardEntry(ChallengeModeLeaderboardData Entry)
{
	local int Index;
	local TLeaderboardEntry NewEntry;
	local float TopPercentile;

	`log(`location @ `ShowVar(OnlineSub.UniqueNetIdToString(Entry.PlatformID), PlatformID) @ `ShowVar(OnlineSub.UniqueNetIdToString(Entry.PlayerID), PlayerID)
		@ QWordToString(Entry.IntervalSeedID) @ `ShowVar(Entry.Rank) @ `ShowVar(Entry.GameScore) @ `ShowVar(Entry.TimeStart) @ `ShowVar(Entry.TimeEnd) @ `ShowVar(Entry.UninjuredSoldiers)
		@ `ShowVar(Entry.SoldiersAlive) @ `ShowVar(Entry.KilledEnemies) @ `ShowVar(Entry.CompletedObjectives) @ `ShowVar(Entry.CiviliansSaved) @ `ShowVar(Entry.TimeBonus)
		@ `ShowVar(m_bUpdatingLeaderboardData), , 'XCom_Online');

	if (m_bUpdatingLeaderboardData)
	{
		Index = m_LeaderboardsData.Length;
		m_LeaderboardsData.Add(1);
	}
	else
	{
		Index = FindLeaderboardIndex(Entry.PlayerID);
	}

	TopPercentile = 100.0  - ((float(Entry.Rank) / float(m_TotalPlayerCount)) * 100.0);
	//TopPercentile = (100.0 / m_TotalPlayerCount) * (Entry.Rank - 0.5);
	`log(`location @ `ShowVar(Entry.Rank) @ `ShowVar(m_TotalPlayerCount) @ `ShowVar(TopPercentile));

	NewEntry.iRank = Entry.Rank;
	NewEntry.iScore = Entry.GameScore;
	NewEntry.iTime = Entry.TimeEnd - Entry.TimeStart;
	NewEntry.iPercentile = TopPercentile;

	NewEntry.UninjuredSoldiers		= Entry.UninjuredSoldiers;
	NewEntry.SoldiersAlive			= Entry.SoldiersAlive;
	NewEntry.KilledEnemies			= Entry.KilledEnemies;
	NewEntry.CompletedObjectives	= Entry.CompletedObjectives;
	NewEntry.CiviliansSaved			= Entry.CiviliansSaved;
	NewEntry.TimeBonus				= Entry.TimeBonus;

	NewEntry.PlayerID = Entry.PlayerID;
	NewEntry.PlatformID = Entry.PlatformID;

	if (Entry.PlatformID == m_LocalPlayerID) // (!m_bFoundLocalPlayerLeaderboardData)
	{
		m_LocalPlayerScore = NewEntry.iScore;
	}

	if (Index != -1)
	{
		m_LeaderboardsData[Index] = NewEntry;
		if (len(m_LeaderboardsData[Index].strPlayerName) == 0)
		{
			if (!OnlineSub.PlayerInterface.RequestUserInformation(`ONLINEEVENTMGR.LocalUserIndex, Entry.PlatformID))
			{
				`RedScreen("Unable to lookup username for PlatformID: " $ OnlineSub.UniqueNetIdToString(Entry.PlatformID));
			}
		}
		`log(`location @ "Setting Leaderboard Entry(" $ Index $ ")" @ `ShowVar(m_LeaderboardsData[Index].iScore, GameScore));

		if (!m_bUpdatingLeaderboardData)
		{
			UpdateLeaderboardData();
		}
	}
}

simulated function string GetChallengeCompletedScreen()
{
	local XGParamTag kTag;
	local string strChallengeExpiry;

	kTag = XGParamTag(`XEXPANDCONTEXT.FindTag("XGParam"));

	kTag.strValue0 = string(m_LocalPlayerScore);
	strChallengeExpiry = `XEXPAND.ExpandString(m_strCompletedScore) @ "-";

	kTag.strValue0 = string(m_TotalPlayerCount);
	strChallengeExpiry @= "\n\n" $ "-" @ `XEXPAND.ExpandString(m_strPlayersCompleted);

	return strChallengeExpiry;
}

simulated function string GetChallengeExpiryTime()
{
	local XGParamTag kTag;
	local string strChallengeExpiry;
	local int Index, SecondsUntilExpiry, Hours, Minutes, Days;

	Index = GetIntervalIndex(m_CurrentIntervalSeedID);
	kTag = XGParamTag(`XEXPANDCONTEXT.FindTag("XGParam"));
	
	SecondsUntilExpiry = m_arrIntervals[Index].DateEnd.B - class'XComGameState_TimerData'.static.GetUTCTimeInSeconds();
	
	`log(`location @ `ShowVar(SecondsUntilExpiry) @ `ShowVar(m_arrIntervals[Index].DateEnd.B,DateEnd) @ `ShowVar(class'XComGameState_TimerData'.static.GetUTCTimeInSeconds(), UTCTimeInSeconds));

	strChallengeExpiry = m_strChallengeExpire;

	if (SecondsUntilExpiry > 86400) // 1 day in seconds
	{
		Days = SecondsUntilExpiry / 86400;
		kTag.strValue0 = string(Days);

		if(Days > 1)
		{
			strChallengeExpiry @= `XEXPAND.ExpandString(m_strExpireDays);
		}
		else
		{
			strChallengeExpiry @= `XEXPAND.ExpandString(m_strExpireDay);
		}
	}
	else
	{
		Hours = (SecondsUntilExpiry / 3600) % 24;
		Minutes = (SecondsUntilExpiry / 60) % 60;

		if(Hours > 0)
		{
			kTag.StrValue0 = string(Hours);

			if(Hours > 1)
			{
				strChallengeExpiry @= `XEXPAND.ExpandString(m_strExpireHrs);
			}
			else
			{
				strChallengeExpiry @= `XEXPAND.ExpandString(m_strExpireHr);
			}
		}
		else
		{
			Minutes = Max(1, Minutes);
		}

		if(Minutes > 0)
		{
			kTag.StrValue0 = string(Minutes);

			if(Minutes > 1)
			{
				strChallengeExpiry @= `XEXPAND.ExpandString(m_strExpireMins);
			}
			else
			{
				strChallengeExpiry @= `XEXPAND.ExpandString(m_strExpireMin);
			}
		}
	}
	return strChallengeExpiry;
}

simulated function bool GetLocalizationData(string CategoryName, out string LocData)
{
	local X2FiraxisLiveClient LiveClient;
	local int CategoryIdx, MessageIdx;
	local string Language;
	LiveClient = `FXSLIVE;
	Language = GetLanguage();
	`log(`location @ `ShowVar(CategoryName) @ `ShowVar(Language));
	for (CategoryIdx = 0; CategoryIdx < LiveClient.CachedMOTDData.Length; ++CategoryIdx)
	{
		if (LiveClient.CachedMOTDData[CategoryIdx].Category == CategoryName)
		{
			for (MessageIdx = 0; MessageIdx < LiveClient.CachedMOTDData[CategoryIdx].Messages.Length; ++MessageIdx)
			{
				if (LiveClient.CachedMOTDData[CategoryIdx].Messages[MessageIdx].MessageType == Language)
				{
					LocData = LiveClient.CachedMOTDData[CategoryIdx].Messages[MessageIdx].Message;
					return true;
				}
			}
			break;
		}
	}
	return false;
}

simulated function string GetOpName()
{
	local int Index;
	local string LocData;
	Index = GetIntervalIndex(m_CurrentIntervalSeedID);
	if (Index >= 0)
	{
		if (GetLocalizationData(m_arrIntervals[Index].IntervalName $ "_OpName", LocData))
		{
			return LocData;
		}
	}

	LocData = m_BattleData.m_strOpName;

	`log(`location @ `ShowVar(LocData) @ `ShowVar(m_BattleData.m_strOpName));
	return LocData;
}

simulated function string GetSquadInfo()
{
	local X2ChallengeTemplateManager TemplateManager;
	local X2ChallengeSoldierClass SoldierTemplate;
	local X2ChallengeSquadAlien AlienTemplate;
	local int Index, NumSoldiers, NumAliens;
	local string LocData;
	local bool bUseSquadConnector;

	Index = GetIntervalIndex(m_CurrentIntervalSeedID);
	if (Index >= 0)
	{
		if (GetLocalizationData(m_arrIntervals[Index].IntervalName $ "_SquadInfo", LocData))
		{
			return LocData;
		}
	}

	TemplateManager = class'X2ChallengeTemplateManager'.static.GetChallengeTemplateManager();
	SoldierTemplate = X2ChallengeSoldierClass(TemplateManager.FindChallengeTemplate(m_ChallengeData.ClassSelectorName));
	AlienTemplate = X2ChallengeSquadAlien(TemplateManager.FindChallengeTemplate(m_ChallengeData.AlienSelectorName));
	NumSoldiers = 0;
	NumAliens = 0;
	bUseSquadConnector = false;

	GetNumSoldiersAndAliens(NumSoldiers, NumAliens);

	if(NumSoldiers > 0)
	{
		if(SoldierTemplate != none)
		{
			bUseSquadConnector = (NumAliens > 0);
			LocData $= (SoldierTemplate.DisplayName != "") ? SoldierTemplate.DisplayName : "IMPLEMENT_SOLDIER'" $ SoldierTemplate.DataName $ "'";
		}
		else if(m_ChallengeData.ClassSelectorName != '')
		{
			bUseSquadConnector = (NumAliens > 0);
			LocData $= "TODO[" $ m_ChallengeData.ClassSelectorName $ "]";
		}
	}
	
	if(NumAliens > 0)
	{
		if(AlienTemplate != none)
		{
			if(bUseSquadConnector)
			{
				LocData @= m_strSquadConnector $ " ";
			}

			LocData $= (AlienTemplate.DisplayName != "") ? AlienTemplate.DisplayName : "IMPLEMENT_ALIEN'" $ AlienTemplate.DataName $ "'";
		}
		else if(m_ChallengeData.AlienSelectorName != '')
		{
			if(bUseSquadConnector)
			{
				LocData @= m_strSquadConnector $ " ";
			}

			LocData $= "TODO[" $ m_ChallengeData.AlienSelectorName $ "]";
		}
	}
	
	`log(`location @ `ShowVar(m_ChallengeData.SquadSizeSelectorName) @ `ShowVar(m_ChallengeData.ClassSelectorName) @ `ShowVar(m_ChallengeData.AlienSelectorName) @ `ShowVar(SoldierTemplate.DisplayName) @ `ShowVar(AlienTemplate.DisplayName) @ `ShowVar(LocData));
	return LocData;
}

private simulated function GetNumSoldiersAndAliens(out int NumSoldiers, out int NumAliens)
{
	local XComGameState_Unit UnitState;

	foreach History.IterateByClassType(class'XComGameState_Unit', UnitState)
	{
		if(UnitState.GetTeam() == eTeam_XCom && !UnitState.GetMyTemplate().bIsCosmetic)
		{
			if(UnitState.IsSoldier())
			{
				NumSoldiers++;
			}
			else
			{
				NumAliens++;
			}
		}
	}
}

simulated function string GetEnemyInfo()
{
	local X2ChallengeTemplateManager TemplateManager;
	local X2ChallengeEnemyForces EnemyTemplate;
	local int Index;
	local string LocData;
	Index = GetIntervalIndex(m_CurrentIntervalSeedID);
	if (Index >= 0)
	{
		if (GetLocalizationData(m_arrIntervals[Index].IntervalName $ "_EnemyInfo", LocData))
		{
			return LocData;
		}
	}

	TemplateManager = class'X2ChallengeTemplateManager'.static.GetChallengeTemplateManager();
	EnemyTemplate = X2ChallengeEnemyForces(TemplateManager.FindChallengeTemplate(m_ChallengeData.EnemyForcesSelectorName));
	`log(`location @ `ShowVar(m_ChallengeData.EnemyForcesSelectorName) @ `ShowVar(EnemyTemplate.DataName) @ `ShowVar(EnemyTemplate.DisplayName));
	return EnemyTemplate.DisplayName;
}

simulated function string GetObjectiveInfo()
{
	local X2MissionTemplateManager MissionTemplateManager;
	local int Index;
	local string LocData;

	Index = GetIntervalIndex(m_CurrentIntervalSeedID);
	if (Index >= 0)
	{
		if (GetLocalizationData(m_arrIntervals[Index].IntervalName $ "_Objective", LocData))
		{
			return LocData;
		}
	}

	MissionTemplateManager = class'X2MissionTemplateManager'.static.GetMissionTemplateManager();
	LocData = MissionTemplateManager.GetMissionDisplayName(m_BattleData.MapData.ActiveMission.MissionName);
	`log(`location @ `ShowVar(m_BattleData.MapData.ActiveMission.MissionName, MissionName));

	return (LocData != "") ? LocData : "ERROR_GETTING_OBJECTIVES";
}

simulated function SetHeaderData()
{
	local TDateTime kDateTime;
	local int year, month, day;
	local string DateString;

	class'XComGameState_TimerData'.static.GetUTCDate(class'XComGameState_TimerData'.static.GetUTCTimeInSeconds(), year, month, day);
	kDateTime.m_iDay = day;
	kDateTime.m_iMonth = month;
	kDateTime.m_iYear = year;
	DateString = "";

	DateString = class'X2StrategyGameRulesetDataStructures'.static.GetDateString(kDateTime, true);

	m_strCacheChallengeInfo  = "<font size='18' color ='#" $ class'UIUtilities_Colors'.const.HEADER_HTML_COLOR	$ "' face='" $ class'UIUtilities_Text'.const.TITLE_FONT_TYPE	$ "'>" $ m_strSquadHeader  $ ":</font>\n";
	m_strCacheChallengeInfo $= "<font size='32' color ='#" $ class'UIUtilities_Colors'.const.GOOD_HTML_COLOR	$ "' face='" $ class'UIUtilities_Text'.const.TITLE_FONT_TYPE	$ "'>" $ GetSquadInfo() $ "</font>\n";
	m_strCacheChallengeInfo $= "<font size='18' color ='#" $ class'UIUtilities_Colors'.const.HEADER_HTML_COLOR	$ "' face='" $ class'UIUtilities_Text'.const.TITLE_FONT_TYPE	$ "'>" $ m_strEnemiesHeader  $ ":</font>\n";
	m_strCacheChallengeInfo $= "<font size='32' color ='#" $ class'UIUtilities_Colors'.const.BAD_HTML_COLOR		$ "' face='" $ class'UIUtilities_Text'.const.TITLE_FONT_TYPE	$ "'>" $ GetEnemyInfo() $ "</font>\n";
	m_strCacheChallengeInfo $= "<font size='18' color ='#" $ class'UIUtilities_Colors'.const.HEADER_HTML_COLOR	$ "' face='" $ class'UIUtilities_Text'.const.TITLE_FONT_TYPE	$ "'>" $ m_strObjectivesHeader  $ ":</font>\n";
	m_strCacheChallengeInfo $= "<font size='24' color ='#" $ class'UIUtilities_Colors'.const.NORMAL_HTML_COLOR	$ "' face='" $ class'UIUtilities_Text'.const.BODY_FONT_TYPE		$ "'>" $ GetObjectiveInfo() $ "</font>\n\n";

	if (IsReplayDownloadAccessible())
	{
		m_strCacheChallengeInfo $= "<p align='center'><font size='22' color ='#" $ class'UIUtilities_Colors'.const.GOOD_HTML_COLOR $ "' face='" $ class'UIUtilities_Text'.const.TITLE_FONT_TYPE $ "'>- " $ GetChallengeCompletedScreen() $ " -</font></p>";
	}
	else
	{
		m_strCacheChallengeInfo $= "<p align='center'><font size='22' color ='#" $ class'UIUtilities_Colors'.const.WARNING_HTML_COLOR $ "' face='" $ class'UIUtilities_Text'.const.TITLE_FONT_TYPE $ "'>- " $ GetChallengeExpiryTime() $ " -</font></p>";
	}

	MC.BeginFunctionOp("setHeaderData");
	MC.QueueString(GetOpName() @ "-" @ DateString);
	MC.QueueString(m_strSquadInfo);
	MC.QueueString(m_strCacheChallengeInfo);
	MC.EndOp();
}

simulated function UpdateNavHelp()
{
	//bsg-jneal (5.19.17): do not update the navhelp if screen is not focused
	if(!bIsFocused)
	{
		return;
	}
	//bsg-jneal (5.19.17): end

	m_NavHelp.ClearButtonHelp();
	m_NavHelp.AddBackButton(BackButtonCallback);
	
	//bsg-jneal (5.5.17): new navhelp reflecting screen changes
	if(`ISCONTROLLERACTIVE)
	{
		m_NavHelp.AddLeftHelp(m_strViewLeaderboardButtonLabel, class'UIUtilities_Input'.const.ICON_Y_TRIANGLE);
		
		//bsg-jneal (4.13.17): update navhelp based on what is selected
		if(!m_bViewingSoldiers)
		{
			if(IsReplayDownloadAccessible())
				m_NavHelp.AddSelectNavHelp(m_strViewReplayButtonLabel);
			m_NavHelp.AddLeftHelp(m_strToggleLeaderboard, class'UIUtilities_Input'.const.ICON_LT_L2);
			m_NavHelp.AddLeftHelp(m_strSquadInfo, class'UIUtilities_Input'.const.ICON_RB_R1);
		}
		else
		{
			if(IsReplayDownloadAccessible())
				m_NavHelp.AddSelectNavHelp(m_strViewCharacterDetailsLabel);
			m_NavHelp.AddLeftHelp(m_strChallengeInfo, class'UIUtilities_Input'.const.ICON_RB_R1);
		}
		//bsg-jneal (4.13.17): end
	}
	//bsg-jneal (5.5.17): end
}

simulated function BackButtonCallback()
{
	OnCancel();
}

function UpdateDisplay()
{
	SetHeaderData();
	UpdateObjectives();
	UpdateLeaderboardData();
	UpdateSoldiers();
	UpdatePlayerData();
}

function UpdateObjectives()
{
	local ObjectiveDisplayInfo Info;
	local string s;

	foreach m_ObjectivesList.ObjectiveDisplayInfos(Info)
	{
		s $= Info.DisplayLabel $ ",";
	}
	MC.BeginFunctionOp("setObjectiveData");
	MC.QueueString(m_strObjectiveTitle);
	MC.QueueString(s);
	MC.QueueString(m_strLocationLabel);//location label "LOCATION"
	MC.QueueString(m_BattleData.m_strLocation );//location value, location name
	MC.QueueString(m_strCreatorLabel);//creator label "CREATED BY"
	MC.QueueString("Han Solo");//creator value
	MC.EndOp();
}

function UpdateCombatData()
{
	/*local int i;
	local X2SitRepEffectTemplate SitrepEffects;
	MC.BeginFunctionOp("setCombatData");
	MC.QueueString(m_strCombatDataLabel);
	foreach class'X2SitRepTemplateManager'.static.IterateEffects(class'X2SitRepEffectTemplate', SitrepEffects, m_BattleData.ActiveSitReps)
	{
		if (i++ < 3)
		{
			MC.QueueString(SitrepEffects.GetFriendlyName());
		}
	}
	
	for (i = i; i < 3; i++)
	{
		MC.QueueString("");
	}
	MC.EndOp();*/
}

function UpdatePlayerData()
{
	local string DateString;
	local TDateTime kDateTime;
	local int year, month, day;

	class'XComGameState_TimerData'.static.GetUTCDate(m_ChallengeStats.BestScoreDate, year, month, day);
	kDateTime.m_iDay = day;
	kDateTime.m_iMonth = month;
	kDateTime.m_iYear = year;
	DateString = "";

	if(m_ChallengeStats.ChallengesCompleted > 0)
	{
		DateString = class'X2StrategyGameRulesetDataStructures'.static.GetDateString(kDateTime, true);
	}
	
	MC.BeginFunctionOp("setPlayerData");
	MC.QueueString(m_strPlayerDataLabel);

	MC.QueueString(m_strChallengeCompleteLabel); // these lines need to be downloaded somewhere in the challenge data
	MC.QueueString(String(m_ChallengeStats.ChallengesCompleted));

	MC.QueueString("");// m_strAverageRankLabel);
	MC.QueueString("");//"avRank");

	MC.QueueString(m_strHighestScoreLabel);
	MC.QueueString(String(m_ChallengeStats.BestScore));
	MC.QueueString(DateString);

	MC.QueueString("");//m_strBestRankLabel);
	MC.QueueString("");//"BestRank");

	MC.QueueString(m_strAverageScoreLabel);
	MC.QueueString(String(m_ChallengeStats.AverageChallengeScores));
	MC.EndOp();
}

function UpdateLeaderboardData()
{
	local int i;
	local string PlayerName, PlayerScore, ReplayMovieVisibility;
	local bool bReplayDownloadAccessible, bHideReplayButton;
	local ASValue replayValue;

	MC.BeginFunctionOp("setScoreBoardHeader");
	MC.QueueString(m_strTopPlayersLabel);
	MC.QueueString(m_strGlobalLeaderboardsLabel);
	MC.QueueString(m_strFriendsLeaderboardsLabel);
	MC.EndOp();

	/*if (`ISCONTROLLERACTIVE)
	{
		MC.FunctionBool("hideHeaderButtons", true);
	}*/

	bReplayDownloadAccessible = IsReplayDownloadAccessible();

	for (i = 0; i < MAX_LEADERBOARDS; i++)
	{
		bHideReplayButton = bReplayDownloadAccessible;
		if (i < m_LeaderboardsData.Length)
		{
			PlayerName = m_LeaderboardsData[i].strPlayerName;
			PlayerScore = string(m_LeaderboardsData[i].iScore);
		}
		else
		{
			PlayerName = "";
			PlayerScore = "";
			bHideReplayButton = false;
		}
		MC.BeginFunctionOp("setScoreBoardRow");
		MC.QueueNumber(i);
		MC.QueueString(PlayerName);
		MC.QueueString(PlayerScore);
		MC.EndOp();

		replayValue.Type = AS_Boolean;
		replayValue.b = bHideReplayButton;
		ReplayMovieVisibility = MCPath $ ".scoreRow" $ i $ ".ReplayButton._visible";
		Movie.SetVariable(ReplayMovieVisibility, replayValue);
		`log(`location @ `ShowVar(ReplayMovieVisibility) @ `ShowVar(bHideReplayButton));
	}
}

simulated function OnMouseEvent(int cmd, array<string> args)
{
	local string strCheck, strRow;
	local int index;
	strRow = args[args.length - 2];
	strCheck = args[args.length - 1];
	`log(`location @ `ShowVar(cmd) @ strCheck);
	
	if (cmd == class'UIUtilities_Input'.const.FXS_L_MOUSE_UP  )
	{
		switch (strCheck)
		{
		case "GlobalButtonChallenge":
			TopPlayersButtonCallback(none);
			break;
		case "FriendButtonChallenge":
			FriendRanksButtonCallback(none);
			break;
		case "ReplayButton":
			if (IsReplayDownloadAccessible())
			{
				index = int(Right(strRow, 1));
				if (PerformChallengeModeGetGameSave(index))
				{
					GotoState('ReplayDownloading');
				}
			}
			else
			{
				PlaySound(SoundCue'SoundUI.NegativeSelection2Cue', true);
			}
			break;
		default:
			TopPlayersButtonCallback(none);
		}
	}
}

simulated function AbilityInfoMouseEvents(UIPanel panel, int cmd)
{
	local int index;
	local array<string> args;
	local string strRow;

	if (cmd == class'UIUtilities_Input'.const.FXS_L_MOUSE_UP)
	{
		args = SplitString(String(panel.MCPath), ".");
		strRow = args[args.length - 2];
		index = int(Right(strRow, 1));
		ShowAbilityInfoScreen(index);
	}
}

simulated function SquadInfoMouseEvents(UIPanel panel, int cmd)
{
	if (cmd == class'UIUtilities_Input'.const.FXS_L_MOUSE_UP)
	{
		m_UnitSlotContainer.Show();
		m_bViewingSoldiers = true;
		MC.FunctionVoid("flipInfoScreenState");
	}
}

simulated function ShowAbilityInfoScreen(int unitIndex)
{
	local XComGameState_Unit Unit;
	local int Index;
	local UIAbilityInfoScreen AbilityInfoScreen;

	Index = 0;
	foreach History.IterateByClassType(class'XComGameState_Unit', Unit)
	{
		if (Unit.GetTeam() == eTeam_XCom && !Unit.GetMyTemplate().bIsCosmetic)
		{
			if (Index == unitIndex)
				break;
			else
				Index++;
		}
	}

	if (Unit != none)
	{
		AbilityInfoScreen = Spawn(class'UIAbilityInfoScreen', Movie.Pres.ScreenStack.GetCurrentScreen());
		AbilityInfoScreen.bIsChallengeModeScreen = true;
		AbilityInfoScreen.InitAbilityInfoScreen(XComPlayerController(Movie.Pres.Owner), Movie);
		AbilityInfoScreen.SetGameStateUnit(Unit);
		Movie.Pres.ScreenStack.Push(AbilityInfoScreen);
	}
}

/**
* Received when the Challenge Mode data has been read.
*
* @param PlayerId, Unique Identifier for the particular player
* @param PlayerName, Name to show on the leaderboard
* @param IntervalSeedID, Specifies the entry's leaderboard (since there may be multiple days worth of leaderboards)
* @param LevelSeed, Seed used for the level generation
* @param PlayerSeed, Seed specific for that player
* @param TimeLimit, Time allowed to play the level
* @param GameScore, Value of the entry
* @param TimeStart, Epoch time in UTC whenever the player first started the challenge
* @param TimeEnd, Epoch time in UTC whenever the player finished the challenge
* @param GameData, History data for replay / validation
*/
function OnReceivedChallengeModeGetGameSave(UniqueNetId PlayerID, string PlayerName, qword IntervalSeedID, int LevelSeed, int PlayerSeed, int TimeLimit, int GameScore, qword TimeStart, qword TimeEnd, array<byte> GameData)
{
	`log(`location @ `ShowVar(Class'GameEngine'.static.GetOnlineSubsystem().UniqueNetIdToString(PlayerID), PlayerID) @ `ShowVar(PlayerName) @ QWordToString(IntervalSeedID) @ `ShowVar(LevelSeed) @ `ShowVar(PlayerSeed) @ `ShowVar(TimeLimit) @ `ShowVar(GameScore), , 'XCom_Online');

	if (GameData.Length == 0)
	{
		GameDataDownloadFailed();
	}
	else
	{
		PlayerGameData = GameData;
		ReceivedGameData();
	}

	Movie.Pres.UICloseProgressDialog();

	// No longer listen for updates!
	ChallengeModeInterface.ClearReceivedChallengeModeGetGameSaveDelegate(OnReceivedChallengeModeGetGameSave);
}

//---------------------------------------------------------------------------------------
//  Get Game Save
//---------------------------------------------------------------------------------------
/**
* Retrieves the stored save of the submitted game for the specified player and interval
*
* @param PlayerId, Unique Identifier for the particular player
* @param IntervalSeedID, Any known Interval call GetCurrentIntervalID() for a default ID
*/
function bool PerformChallengeModeGetGameSave(int leaderboardID)
{
	local bool bSuccess;
	local TProgressDialogData kDialogBoxData;

	`log(`location);
	ScriptTrace();
	m_ViewReplayIndex = leaderboardID;

	bSuccess = ChallengeModeInterface.PerformChallengeModeGetGameSave(m_LeaderboardsData[leaderboardID].playerID, m_CurrentIntervalSeedID);
	if (bSuccess)
	{
		// If we're going to spawn a dialog box that says we're fetching data, that means we don't want navhelp to display anything, since we aren't able to do anything(kmartinez)
		kDialogBoxData.strTitle = class'X2MPData_Shell'.default.m_strChallengeFetchingReplayDialogTitle;
		kDialogBoxData.strDescription = class'X2MPData_Shell'.default.m_strChallengeFetchingReplayDialogText;
		kDialogBoxData.fnCallback = CancelPlayReplay;

		Movie.Pres.UIProgressDialog(kDialogBoxData);
	}
	return bSuccess;
}

function CancelPlayReplay()
{
	Movie.Pres.UICloseProgressDialog();
	GotoState('ReplayCanceled');
}

function ReceivedGameData()
{
}

function LoadGameData()
{
	// Load-up the replay!
	if (ChallengeModeInterface.ChallengeModeLoadGameData(PlayerGameData))
	{
		PlayReplay();
	}
	else
	{
		// TODO: Hookup an error message that the load failed!
		`RedScreen("Failed to load the Challenge Mode data, cannot start the replay! @ttalley");
		PlaySound(SoundCue'SoundUI.NegativeSelection2Cue', true);
	}
}

function GameDataDownloadFailed()
{
	local TDialogueBoxData kConfirmData;
	kConfirmData.eType = eDialog_Warning;

	// TODO: Hook up a better reason behind the failure!
	kConfirmData.strTitle = class'UIChallengeLeaderboard_ListItem'.default.m_replayNotAvailable; // class'X2MPData_Shell'.default.m_strChallengeNoActiveChallengeDialogTitle;
	kConfirmData.strText = ""; //m_replayNotAvailable

	kConfirmData.strAccept = class'UIUtilities_Text'.default.m_strGenericOK;
	kConfirmData.strCancel = "";
	Movie.Pres.UIRaiseDialog(kConfirmData);

	PlaySound(SoundCue'SoundUI.NegativeSelection2Cue', true);
	GotoState('ReplayNotLoaded');
}

function PlayReplay()
{
	local XComGameState_BattleData BattleData;
	local int Index;

	Index = GetIntervalIndex(m_CurrentIntervalSeedID);
	`ONLINEEVENTMGR.bInitiateReplayAfterLoad = true;
	`ONLINEEVENTMGR.m_sReplayUserID = m_LeaderboardsData[m_ViewReplayIndex].strPlayerName;
	// Load up the Replay ...
	BattleData = XComGameState_BattleData(History.GetSingleGameStateObjectForClass(class'XComGameState_BattleData'));
	m_ChallengeData = XComGameState_ChallengeData(History.GetSingleGameStateObjectForClass(class'XComGameState_ChallengeData'));
	m_ChallengeData.LeaderBoardName = m_arrIntervals[Index].IntervalName;
	m_NextMapCommand = BattleData.m_strMapCommand $ "?LoadingSave" $ "?ReplayID=" $ QWordToString(m_arrIntervals[Index].IntervalSeedID);
	`ONLINEEVENTMGR.m_sLastReplayMapCommand = m_NextMapCommand;
	GotoState('ExecuteMapChange');
}

function UpdateSoldiers()
{
	local XComGameState_Unit Unit;
	local int Index;
	Index = 0;
	m_NumSoldierSlots = 0;
	foreach History.IterateByClassType(class'XComGameState_Unit', Unit)
	{
		if (Index < MAX_UNIT_SLOTS && Unit.GetTeam() == eTeam_XCom && !Unit.GetMyTemplate().bIsCosmetic)
		{
			m_NumSoldierSlots++;
			AddSlot(Index++, Unit);
		}
	}

	while(Index < MAX_UNIT_SLOTS)
	{
		MC.FunctionNum("hideUnitInfo", Index++);
	}
}

function SetUnitInfo(int Index, string HeadShotImg, string PointsLabel, string PointsValue, string FirstName, string LastName, string NickName, string ClassIcon, string RankIcon, string Description)
{
	MC.BeginFunctionOp("setUnitInfo");
	MC.QueueNumber(Index);
	MC.QueueString(HeadShotImg);
	MC.QueueString(FirstName @ (NickName != "") ? (NickName @ LastName) : LastName);

	MC.QueueString(ClassIcon);
	MC.QueueString(RankIcon);

	MC.QueueString(Description);

	MC.EndOp();
}

function AddSlot(int Index, XComGameState_Unit Unit)
{
	`log(`location @ Unit.ToString(true));
	if (Unit.IsSoldier())
	{
		AddSlotSoldier(Index, Unit);
	}
	else
	{
		AddSlotAlien(Index, Unit);
	}
}

function AddSlotAlien(int Index, XComGameState_Unit Unit)
{
	local string RankStr;
	local X2MPCharacterTemplate UnitMPTemplate;

	UnitMPTemplate = class'X2MPCharacterTemplateManager'.static.GetMPCharacterTemplateManager().FindMPCharacterTemplateByCharacterName(Unit.GetMyTemplateName());
	Unit.SetMPCharacterTemplate(UnitMPTemplate.DataName);
	`log(`location @ `ShowVar(Unit.GetMyTemplate()) @ `ShowVar(Unit.GetMyTemplateName()) @ `ShowVar(UnitMPTemplate.DataName) @ `ShowVar(Unit.GetMPCharacterTemplate()) @ `ShowVar(Unit.GetSoldierClassTemplateName()) @ `ShowVar(Unit.GetNickName(true)) @ (Unit.IsSoldier()) ? (`ShowVar(Unit.GetSoldierClassTemplate().DataName) @ `ShowVar(Unit.GetMPCharacterTemplate().SoldierClassTemplateName)) : "" );
	if (Unit.GetMPCharacterTemplate() == none)
	{
		SetUnitInfo(Index, "", "", "", "", "", "", "", "", "");
		return;
	}

	RankStr = Unit.IsAdvent() ? class'UIMPSquadSelect_ListItem'.default.m_strAdvent : class'UIMPSquadSelect_ListItem'.default.m_strAlien;

	SetUnitInfo(Index,
		UnitMPTemplate.ChallengeHeadImage,
		"",
		"",
		"",
		"",
		Caps(UnitMPTemplate.DisplayName),
		UnitMPTemplate.IconImage, "",
		Caps(RankStr));
}

function AddSlotSoldier(int Index, XComGameState_Unit Unit)
{
	local X2SoldierClassTemplate ClassTemplate;

	ClassTemplate = Unit.GetSoldierClassTemplate();

	MC.BeginFunctionOp("setUnitInfo");
	MC.QueueNumber(Index);
	MC.QueueString("img:///UILibrary_XPACK_StrategyImages.challenge_Xcom");
	MC.QueueString(Unit.GetName(eNameType_RankFull));

	MC.QueueString(Unit.GetSoldierClassTemplate().IconImage);
	MC.QueueString("");

	MC.QueueString(Caps(ClassTemplate.DisplayName));

	MC.EndOp();
}

function RequestServerDataUpdate()
{
	local TProgressDialogData kDialogBoxData;

	kDialogBoxData.strTitle = class'X2MPData_Shell'.default.m_strChallengeFetchingChallengeInfoDialogTitle;
	kDialogBoxData.strDescription = class'X2MPData_Shell'.default.m_strChallengeFetchingChallengeInfoDialogText;
	kDialogBoxData.fnCallback = CloseScreen;
	Movie.Pres.UIProgressDialog(kDialogBoxData);
	//DisplayProgressMessage("Requesting all Intervals from the server ...");

	m_arrIntervals.Length = 0; // Clear
	`CHALLENGEMODE_MGR.ClearChallengeData();
	QueueRequest(PerformChallengeModeGetIntervals);
	QueueRequest(PerformChallengeModeGetPlayerStats);
	QueueRequest(PerformChallengeModeGetGlobalMissionStats);

	// Prefetch the friend's list
	ASyncReadFriendList(none);
}

/**
* Used to queue up Firaxis Live Requests, such as: getting Intervals, getting user stats, and getting global stats
*/
delegate RequestDelegate(); // Will hookup to the PerformXXX functions.

function QueueRequest(delegate<RequestDelegate> Request)
{
	`log(`location @ `ShowVar(Request));
	m_FiraxisLiveRequestDelegates.AddItem(Request);
	if (m_FiraxisLiveRequestDelegates.Length == 1)
	{
		// Call immediately - since we just queued one.
		m_CurrentRequestDelegate = Request;
		m_CurrentRequestDelegate();
	}
}

function RequestFinished(delegate<RequestDelegate> Request)
{
	local int i;
	`log(`location @ `ShowVar(Request));
	for (i = 0; i < m_FiraxisLiveRequestDelegates.Length; ++i)
	{
		if (m_FiraxisLiveRequestDelegates[i] == Request)
		{
			`log(`location @ "Removing Delegate @" $ i);
			m_FiraxisLiveRequestDelegates.Remove(i, 1);
			break;
		}
	}
	if (m_FiraxisLiveRequestDelegates.Length > 0)
	{
		// Perform the next request
		m_CurrentRequestDelegate = m_FiraxisLiveRequestDelegates[0];
		`log(`location @ "Kicking off next request:" @ `ShowVar(m_CurrentRequestDelegate));
		m_CurrentRequestDelegate();
}
	else
	{
		`log(`location @ "All requests have been processed.");
		m_CurrentRequestDelegate = none;
	}
}

function PerformChallengeModeGetIntervals()
{
	if (!ChallengeModeInterface.PerformChallengeModeGetIntervals())
	{
		SetTimer(1.0f, false, nameof(PerformChallengeModeGetIntervals));
	}
}

function PerformChallengeModeGetPlayerStats()
{
	local X2FiraxisLiveClient LiveClient;
	LiveClient = `FXSLIVE;
	LiveClient.AddReceivedStatsKVPDelegate(OnReceivedPlayerStats);
	LiveClient.GetStats(eKVPSCOPE_USER, "CMKS_");
}

function OnReceivedPlayerStats(bool Success, array<string> GlobalKeys, array<int> GlobalValues, array<string> UserKeys, array<int> UserValues)
{
	local int Idx;
	local X2FiraxisLiveClient LiveClient;
	LiveClient = `FXSLIVE;
	LiveClient.ClearReceivedStatsKVPDelegate(OnReceivedPlayerStats);
	`log(`location @ `ShowVar(Success) @ `ShowVar(GlobalKeys.Length) @ `ShowVar(GlobalValues.Length) @ `ShowVar(UserKeys.Length) @ `ShowVar(UserValues.Length));
	for (Idx = 0; Idx < UserKeys.Length; ++Idx)
	{
		`log(`location @ `ShowVar(UserKeys[Idx]) @ `ShowVar(UserValues[Idx]));
		if (UserKeys[Idx] == "CMKS_BestScore")
		{
			m_ChallengeStats.BestScore = UserValues[Idx];
		}
		else if (UserKeys[Idx] == "CMKS_BestScoreDate")
		{
			m_ChallengeStats.BestScoreDate = UserValues[Idx];
		}
		else if (UserKeys[Idx] == "CMKS_ChallengesCompleted")
		{
			m_ChallengeStats.ChallengesCompleted = UserValues[Idx];
		}
		else if (UserKeys[Idx] == "CMKS_AverageChallengeScore")
		{
			m_ChallengeStats.AverageChallengeScores = UserValues[Idx];
		}
	}
	UpdatePlayerData();
	RequestFinished(PerformChallengeModeGetPlayerStats);
}

function PerformChallengeModeGetGlobalMissionStats()
{
	local X2FiraxisLiveClient LiveClient;
	LiveClient = `FXSLIVE;
	LiveClient.AddReceivedStatsKVPDelegate(OnReceivedGlobalMissionStats);
	LiveClient.GetStats(eKVPSCOPE_GLOBAL, "CMK_Mission");
}

function OnReceivedGlobalMissionStats(bool Success, array<string> GlobalKeys, array<int> GlobalValues, array<string> UserKeys, array<int> UserValues)
{
	local int Idx;
	local X2FiraxisLiveClient LiveClient;
	LiveClient = `FXSLIVE;
	LiveClient.ClearReceivedStatsKVPDelegate(OnReceivedGlobalMissionStats);
	`log(`location @ `ShowVar(Success) @ `ShowVar(GlobalKeys.Length) @ `ShowVar(GlobalValues.Length) @ `ShowVar(UserKeys.Length) @ `ShowVar(UserValues.Length));
	for (Idx = 0; Idx < GlobalKeys.Length; ++Idx)
	{
		`log(`location @ `ShowVar(GlobalKeys[Idx]) @ `ShowVar(GlobalValues[Idx]));
		if (GlobalKeys[Idx] == "CMK_MissionComplete")
		{
			m_TotalPlayerCount = GlobalValues[Idx];
		}
	}
	RequestFinished(PerformChallengeModeGetGlobalMissionStats);
}


//==============================================================================
// 		FRIENDS LIST
//==============================================================================
/**
* Delegate called whenever the Friend's List is read from the online subsystem
*/
delegate FriendFetchComplete();

function OnFriendFetchComplete()
{
	local int Index;
	local bool bFetchFailed;
	local array<string> PlayerIDs;

	m_FriendFetch.bSuccess = true;
	bFetchFailed = FALSE;
	Index = GetIntervalIndex(m_CurrentIntervalSeedID);
	`log(`location @ `ShowVar(m_FriendFetch.Offset, Offset) @ `ShowVar(m_FriendFetch.Limit, Limit) @ `ShowVar(m_arrIntervals[Index].IntervalName, IntervalName));
	if (Index == -1)
	{
		m_FriendFetch.bSuccess = false;
		`log(`location @ "Failed to find Interval for ID:" @ QWordToString(m_CurrentIntervalSeedID));
		bFetchFailed = true;
	}
	else if (GetFriendIDs(PlayerIDs, m_FriendFetch.Offset, m_FriendFetch.Limit))
	{
		//AddPlayerIDForLeaderboardPlayerList(PlayerIDs);
		if (PlayerIDs.length <= 0)
		{
			m_FriendFetch.bSuccess = false;
			bFetchFailed = true;
		}
		else if (!ChallengeModeInterface.PerformChallengeModeGetGameScoresFriends(m_arrIntervals[Index].IntervalName, PlayerIDs))
		{
			m_FriendFetch.bSuccess = false;
			bFetchFailed = true;
		}
	}

	if (bFetchFailed)
	{
		// Failed to launch ...
		UpdateData();
		Movie.Pres.UICloseProgressDialog();
		UpdateNavHelp();
	}
}

function bool PerformGetGameScoreFriends(optional delegate<FriendFetchComplete> OnFriendFetchCompleteDelegate = OnFriendFetchComplete, optional int Offset = 0, optional int Limit = 10)
{
	`log(`location @ `ShowVar(OnFriendFetchCompleteDelegate) @ `ShowVar(Offset) @ `ShowVar(Limit));
	if (IsFriendFetchComplete(Offset, Limit))
	{
		OnFriendFetchCompleteDelegate();
	}
	else
	{
		// Called Perform while still fetching list, store the callback for later
		if (m_FriendFetch.bFetchingFriends)
		{
			m_FriendFetch.OnComplete = OnFriendFetchCompleteDelegate;
			return true;
		}

		return ASyncReadFriendList(OnFriendFetchCompleteDelegate, Offset, Limit);
	}

	return true;
}

function bool IsFriendFetchComplete(int Offset, int Limit)
{
	return m_FriendFetch.bComplete && m_FriendFetch.Offset == Offset && m_FriendFetch.Limit == Limit && m_FriendFetch.bSuccess;
}

function bool ASyncReadFriendList(delegate<FriendFetchComplete> OnFriendFetchCompleteDelegate, optional int Offset = 0, optional int Limit = 10)
{
	`log(`location @ `ShowVar(OnFriendFetchCompleteDelegate) @ `ShowVar(Offset) @ `ShowVar(Limit));
	m_FriendFetch.bFetchingFriends = true;
	m_FriendFetch.bComplete = false;
	m_FriendFetch.Offset = Offset;
	m_FriendFetch.Limit = Limit;
	m_FriendFetch.OnComplete = OnFriendFetchCompleteDelegate;

	return OnlineSub.PlayerInterface.ReadFriendsList(`ONLINEEVENTMGR.LocalUserIndex, Limit, Offset);
}

// Must call ASyncReadFriendList prior to getting the list
function bool GetFriendIDs(out array<string> PlayerIDs, optional int Offset = 0, optional int Limit = 10)
{
	local array<OnlineFriend> Friends;
	local EOnlineEnumerationReadState ReadState;
	local int FriendIdx;

	`log(`location @ `ShowVar(Offset) @ `ShowVar(Limit));

	if (IsFriendFetchComplete(Offset, Limit))
	{
		ReadState = OnlineSub.PlayerInterface.GetFriendsList(`ONLINEEVENTMGR.LocalUserIndex, Friends, Limit, Offset);
		if (ReadState == OERS_Done)
		{
			PlayerIDs.Length = 0;
			//PlayerIDs.AddItem(QWordToString(`ONLINEEVENTMGR.LocalUserIndex));
			for (FriendIdx = 0; FriendIdx < Friends.Length; ++FriendIdx)
			{
				PlayerIDs.AddItem(QWordToString(Friends[FriendIdx].UniqueId.Uid));
			}
		}
	}

	`log(`location @ `ShowVar(Friends.Length) @ `ShowEnum(EOnlineEnumerationReadState, ReadState, ReadState));
	return ReadState == OERS_Done;
}

/**
* Delegate used in friends list change notifications
*/
function OnFriendsChange()
{
	`log(`location);
}

/**
* Delegate used when the friends read request has completed
*
* @param bWasSuccessful true if the async action completed without error, false if there was an error
*/
function OnReadFriendsComplete(bool bWasSuccessful)
{
	local delegate<FriendFetchComplete> OnFriendFetchCompleteDelegate;
	`log(`location @ `ShowVar(bWasSuccessful) @ `ShowVar(m_FriendFetch.OnComplete));

	OnFriendFetchCompleteDelegate = m_FriendFetch.OnComplete;

	m_FriendFetch.bFetchingFriends = false;
	m_FriendFetch.OnComplete = none;

	if (bWasSuccessful)
	{
		m_FriendFetch.bComplete = true;
		if (OnFriendFetchCompleteDelegate != none)
		{
			OnFriendFetchCompleteDelegate();
		}
	}
}


//==============================================================================
//		HELPER FUNCTIONALITY:
//==============================================================================
function DisplayProgressMessage(string ProgressMessage)
{
	// Log for now:
	`log(ProgressMessage,,'XCom_Online');
}

function string QWordToString(qword Number)
{
	local UniqueNetId NetId;

	NetId.Uid.A = Number.A;
	NetId.Uid.B = Number.B;

	return OnlineSub.UniqueNetIdToString(NetId);
}

function qword StringToQWord(string Text)
{
	local UniqueNetId NetId;
	local qword Number;

	OnlineSub.StringToUniqueNetId(Text, NetId);

	Number.A = NetId.Uid.A;
	Number.B = NetId.Uid.B;

	return Number;
}

function UpdateData()
{
	CacheUpdate();
	UpdateDisplay();
}

function UpdateIntervalDropdown()
{
	local int Index, SelectedIdx;
	local string DropdownEntryStr;
	SelectedIdx = 0;
	m_IntervalDropdown.Clear(); // empty dropdown
	for( Index = 0; Index < m_arrIntervals.Length; ++Index )
	{
		//DropdownEntryStr = QWordToString(m_arrIntervals[Index].IntervalSeedID);
		DropdownEntryStr = m_arrIntervals[Index].IntervalName;
		DropdownEntryStr $= ": " $ `ShowEnum(EChallengeStateType, m_arrIntervals[Index].IntervalState, State);
		m_IntervalDropdown.AddItem(DropdownEntryStr, string(Index));
		if( m_arrIntervals[Index].IntervalSeedID == m_CurrentIntervalSeedID )
		{
			SelectedIdx = Index;
		}
	}
	m_IntervalDropdown.SetSelected( SelectedIdx );
}

function DisplayChallengeModeUnavailableDialog()
{
	local TDialogueBoxData kConfirmData;
	local string DisabledChallengeModeText;
	local bool bAreModsInstalled;
	local bool bAreInstalledDLCsRankedFriendly;
	local bool bGameDataHashesAreValid;
	local bool bIsDevConsoleEnabled;

	bAreModsInstalled = class'Helpers'.static.NetAreModsInstalled();
	bAreInstalledDLCsRankedFriendly = class'Helpers'.static.NetAreInstalledDLCsRankedFriendly();
	bGameDataHashesAreValid = class'Helpers'.static.NetGameDataHashesAreValid();
	bIsDevConsoleEnabled = class'Helpers'.static.IsDevConsoleEnabled();
	`log(`location @ `ShowVar(bAreModsInstalled) @ `ShowVar(bAreInstalledDLCsRankedFriendly) @ `ShowVar(bGameDataHashesAreValid) @ `ShowVar(bIsDevConsoleEnabled), , 'XCom_Online');

	if (bAreModsInstalled)
	{
		DisabledChallengeModeText $= class'UIMPShell_MainMenu'.default.m_strDisableModsForRanked;
	}
	if (!bAreInstalledDLCsRankedFriendly)
	{
		DisabledChallengeModeText $= ((Len(DisabledChallengeModeText) > 0) ? ", " : "");
		DisabledChallengeModeText $= class'UIMPShell_MainMenu'.default.m_strDisableDLCForRanked;
	}
	if (!bGameDataHashesAreValid)
	{
		DisabledChallengeModeText $= ((Len(DisabledChallengeModeText) > 0) ? ", " : "");
		DisabledChallengeModeText $= class'UIMPShell_MainMenu'.default.m_strDisableGameDataForRanked;
	}
	if (bIsDevConsoleEnabled)
	{
		DisabledChallengeModeText $= ((Len(DisabledChallengeModeText) > 0) ? ", " : "");
		DisabledChallengeModeText $= class'UIMPShell_MainMenu'.default.m_strDisableConsoleForRanked;
	}


	kConfirmData.eType = eDialog_Warning;
	kConfirmData.strTitle = class'X2MPData_Shell'.default.m_strChallengeUnplayableDialogTitle;
	kConfirmData.strText = DisabledChallengeModeText;
	kConfirmData.strAccept = class'UIUtilities_Text'.default.m_strGenericOK;
	kConfirmData.strCancel = "";
	Movie.Pres.UIRaiseDialog(kConfirmData);
}

function DisplayAllowConsoleErrorDialog()
{
	local TDialogueBoxData kConfirmData;
	kConfirmData.strTitle = class'X2MPData_Shell'.default.m_strChallengeUnplayableDialogTitle;

	kConfirmData.strText = class'X2MPData_Shell'.default.m_strChallengeUnplayableAllowConsoleErrorText;

	kConfirmData.eType = eDialog_Warning;
	kConfirmData.strAccept = class'UIUtilities_Text'.default.m_strGenericOK;

	Movie.Pres.UIRaiseDialog(kConfirmData);
}

function DisplayUnplayableChallengeDialog(EChallengeStateType IntervalState)
{
	local TDialogueBoxData kConfirmData;

	kConfirmData.strTitle = class'X2MPData_Shell'.default.m_strChallengeUnplayableDialogTitle;
	if (IntervalState == ECST_Started)
	{
		kConfirmData.strText = class'X2MPData_Shell'.default.m_strChallengeUnplayableAlreadyAttemptedDialogText;
	}
	else if (IntervalState == ECST_Submitted)
	{
		kConfirmData.strText = class'X2MPData_Shell'.default.m_strChallengeUnplayableSubmittedDialogText;
	}
	else if (IntervalState == ECST_TimeExpired)
	{
		kConfirmData.strText = class'X2MPData_Shell'.default.m_strChallengeUnplayableTimedoutDialogText;
	}
	kConfirmData.eType = eDialog_Warning;
	kConfirmData.strAccept = class'UIUtilities_Text'.default.m_strGenericOK;

	Movie.Pres.UIRaiseDialog(kConfirmData);
}

function bool IsReplayDownloadAccessible()
{
	local int Index;
	Index = GetIntervalIndex(m_CurrentIntervalSeedID);
	if (Index >= 0 && Index < m_arrIntervals.Length)
	{
		`log(`location @ `ShowVar(Index) @ `ShowEnum(EChallengeStateType, m_arrIntervals[Index].IntervalState));
		if (m_arrIntervals[Index].IntervalState != ECST_Ready && m_arrIntervals[Index].IntervalState != ECST_Started)
		{
			return true;
		}
	}
	return false;
}

//==============================================================================
//		STANDARD UI HANDLERS:
//==============================================================================
function OnLeaderboardButton(UIButton Button)
{
	local UIChallengeLeaderboards LeaderboardScreen;
	m_kMPShellManager.m_bLeaderboardsTopPlayersDataLoaded = false;
	m_kMPShellManager.m_bLeaderboardsFriendsDataLoaded = false;
	ClearDelegates();
	GetPresBase().UIChallengeLeaderboard();
	LeaderboardScreen = UIChallengeLeaderboards(GetPresBase().ScreenStack.GetFirstInstanceOf(class'UIChallengeLeaderboards'));
	if (LeaderboardScreen != none)
	{
		LeaderboardScreen.OnCloseScreen = LeaderboardScreen_OnCloseScreen;
	}
	else
	{
		// LeaderboardScreen failed to open ... reattach the delegates.
		HookupDelegates();
	}
}

function LeaderboardScreen_OnCloseScreen()
{
	if (m_arrIntervals.Length > 0)
	{
		HookupDelegates();
	}
	else
	{
		// No intervals available, close this screen
		CloseScreen();
	}
}

function OnAcceptButton(UIButton button)
{
	OnAccept();
}

function XComPresentationLayerBase GetPresBase()
{
	local XComPresentationLayerBase PresBase;
	PresBase = XComPlayerController(class'WorldInfo'.static.GetWorldInfo().GetALocalPlayerController()).Pres;
	if (PresBase == none)
	{
		PresBase = `HQPRES;
	}
	return PresBase;
}

function OnAccept()
{
	local int Index;
	Index = GetIntervalIndex(m_CurrentIntervalSeedID);
	if (!class'Helpers'.static.NetAllRankedGameDataValid())
	{
		`XSTRATEGYSOUNDMGR.PlayPersistentSoundEvent("Play_MenuClickNegative");
		DisplayChallengeModeUnavailableDialog();
	}
	else if (m_arrIntervals[Index].IntervalState == ECST_Ready)
	{
		`XSTRATEGYSOUNDMGR.PlayPersistentSoundEvent("Play_MenuSelect");
		if (ChallengesManager.CheckAvailableConnectionOrOpenErrorDialog())
		{
			// Start the mission
			GotoState('LaunchChallenge');
		}
	}
	else
	{
		`XSTRATEGYSOUNDMGR.PlayPersistentSoundEvent("Play_MenuClickNegative");
		DisplayUnplayableChallengeDialog(m_arrIntervals[Index].IntervalState);
	}
}

function OnCancel(optional bool bAll=false)
{
	if (!`ISCONTROLLERACTIVE && m_bViewingSoldiers) //bsg-jneal (5.5.17): only do this with mouse active as state change is done via controller bumpers
	{
		m_bViewingSoldiers = false;
		MC.FunctionVoid("flipInfoScreenState");
	}
	else
	{
		// Return to Main Menu!
		m_NavHelp.ClearButtonHelp();
		Movie.Stack.Pop(self);
	}
}

simulated function OnReceiveFocus()
{
	UpdateNavHelp();
	Show();
}

simulated function OnLoseFocus()
{
	m_NavHelp.ClearButtonHelp();
	Hide();
}

simulated function bool OnUnrealCommand(int cmd, int arg)
{
	if( !CheckInputIsReleaseOrDirectionRepeat(cmd, arg) )
		return false;

	//bsg-jneal (5.19.17): do not allow input until the intervals have been updated
	if(m_arrIntervals.Length == 0)
	{
		return false;
	}
	//bsg-jneal (5.19.17): end

	switch( cmd )
	{
	case class'UIUtilities_Input'.const.FXS_KEY_ENTER:
	case class'UIUtilities_Input'.const.FXS_KEY_SPACEBAR:
	case class'UIUtilities_Input'.const.FXS_BUTTON_X: //bsg-jneal (1.19.17): moving launch input to X/Square for console
		OnAccept();
		return true;
	case class'UIUtilities_Input'.const.FXS_BUTTON_B:
	case class'UIUtilities_Input'.const.FXS_KEY_ESCAPE:
	case class'UIUtilities_Input'.const.FXS_R_MOUSE_DOWN:
		OnCancel();
		return true;

	//bsg-jneal (5.26.17): prevent unnecessary sounds
	case class'UIUtilities_Input'.const.FXS_BUTTON_LBUMPER:
		//consume left bumper so input does not trickle down to UIShell and make sound
		return true;
	//bsg-jneal (5.26.17): end

	//bsg-jneal (5.5.17): use left and right bumpers to swap between info states
	case class'UIUtilities_Input'.const.FXS_BUTTON_RBUMPER:
		`SOUNDMGR.PlaySoundEvent("Play_MenuSelect"); //bsg-jneal (5.26.17): adding sound
		if(!m_bViewingSoldiers)
		{
			SquadInfoMouseEvents(none, class'UIUtilities_Input'.const.FXS_L_MOUSE_UP);
			
			MC.FunctionNum("setUnhighlight", m_ViewReplayIndex);
			m_ViewReplayIndex = 5;
			MC.FunctionNum("setHighlight", m_ViewReplayIndex);

			UpdateNavHelp();
		}
		else
		{
			m_bViewingSoldiers = false;
			MC.FunctionVoid("flipInfoScreenState");

			MC.FunctionNum("setUnhighlight", m_ViewReplayIndex);
			m_ViewReplayIndex = 0;
			MC.FunctionNum("setHighlight", m_ViewReplayIndex);

			UpdateNavHelp();
		}
		return true;
	//bsg-jneal (5.5.17): end
	case class'UIUtilities_Input'.const.FXS_BUTTON_LTRIGGER : //bsg-jneal (5.5.17): switching leaderboard call to LTRIGGER
		m_bGlobalLeaderboards = !m_bGlobalLeaderboards;
		m_LeaderboardsData.Remove(0, m_LeaderboardsData.Length);
		if (m_bGlobalLeaderboards)
		{
			TopPlayersButtonCallback(none);
			m_ViewGlobalLeaderboardButton.SetSelected(true);
			m_ViewFriendLeaderboardButton.SetSelected(false);
		}
		else
		{
			FriendRanksButtonCallback(none);
			m_ViewGlobalLeaderboardButton.SetSelected(false);
			m_ViewFriendLeaderboardButton.SetSelected(true);
		}
		return true;

	case class'UIUtilities_Input'.const.FXS_BUTTON_Y:
		OnLeaderboardButton(m_ViewLeaderboardButton);
		return true;

	//bsg-jneal (4.6.17): fix A button to select properly
	case class'UIUtilities_Input'.const.FXS_BUTTON_A :
		if (!m_bViewingSoldiers && PerformChallengeModeGetGameSave(m_ViewReplayIndex))
		{
			GotoState('ReplayDownloading');
		}
		else if(m_bViewingSoldiers)
		{
			ShowAbilityInfoScreen(m_ViewReplayIndex - 5);
		}
		return true;
	//bsg-jneal (4.6.17): end

	//bsg-jneal (5.26.17): controller navigation improvements, soldier grid, sounds
	case class'UIUtilities_Input'.const.FXS_VIRTUAL_LSTICK_LEFT :
	case class'UIUtilities_Input'.const.FXS_DPAD_LEFT:
		if (m_bViewingSoldiers)
		{
			//soldier indices start at 5
			if ((m_ViewReplayIndex % 3) != 2) // farthest left index
			{
				MC.FunctionNum("setUnhighlight", m_ViewReplayIndex);
				m_ViewReplayIndex--;
				MC.FunctionNum("setHighlight", m_ViewReplayIndex);
			}

			`SOUNDMGR.PlaySoundEvent("Play_Mouseover");
		}
		break;

	case class'UIUtilities_Input'.const.FXS_VIRTUAL_LSTICK_RIGHT:
	case class'UIUtilities_Input'.const.FXS_DPAD_RIGHT:
		if (m_bViewingSoldiers)
		{
			//soldier indices start at 5
			if ((m_ViewReplayIndex % 3) != 1) // farthest right index
			{
				MC.FunctionNum("setUnhighlight", m_ViewReplayIndex);
				m_ViewReplayIndex++;
				MC.FunctionNum("setHighlight", m_ViewReplayIndex);
			}

			`SOUNDMGR.PlaySoundEvent("Play_Mouseover");
		}
		break;

	case class'UIUtilities_Input'.const.FXS_VIRTUAL_LSTICK_UP :
	case class'UIUtilities_Input'.const.FXS_DPAD_UP:
		`SOUNDMGR.PlaySoundEvent("Play_Mouseover");

		//bsg-jneal (5.5.17): fix stick navigation to include interval dropdown and new screen layout
		if(m_IntervalDropdown != none && m_IntervalDropdown.bIsVisible)
		{
			if (!m_bViewingSoldiers && m_ViewReplayIndex == 0)
			{
				MC.FunctionNum("setUnhighlight", m_ViewReplayIndex);
				m_IntervalDropdown.OnReceiveFocus();
				m_ViewReplayIndex--;
				return true;
			}
		}

		if (!m_bViewingSoldiers)
		{
			MC.FunctionNum("setUnhighlight", m_ViewReplayIndex);
			m_ViewReplayIndex--;
			if (m_ViewReplayIndex < 0)
			{
				if(m_IntervalDropdown != none && m_IntervalDropdown.bIsFocused)
				{
					m_IntervalDropdown.OnLoseFocus();
				}

				m_ViewReplayIndex = m_LeaderboardsData.Length - 1;
			}
		}
		else
		{			
			if ((m_ViewReplayIndex - 3) >= 5) //soldier indices start at 5, furthest up index
			{
				MC.FunctionNum("setUnhighlight", m_ViewReplayIndex);
				m_ViewReplayIndex -= 3; //only 3 items per row
			}
		}

		MC.FunctionNum("setHighlight", m_ViewReplayIndex);
		break;

	case class'UIUtilities_Input'.const.FXS_VIRTUAL_LSTICK_DOWN :
	case class'UIUtilities_Input'.const.FXS_DPAD_DOWN:
		`SOUNDMGR.PlaySoundEvent("Play_Mouseover");

		if(m_IntervalDropdown != none && m_IntervalDropdown.bIsVisible)
		{
			if (!m_bViewingSoldiers && m_ViewReplayIndex == 4 + m_NumSoldierSlots)
			{
				MC.FunctionNum("setUnhighlight", m_ViewReplayIndex);
				m_IntervalDropdown.OnReceiveFocus();
				m_ViewReplayIndex++;
				return true;
			}
		}

		if(m_IntervalDropdown != none && m_IntervalDropdown.bIsFocused)
		{
			m_IntervalDropdown.OnLoseFocus();
		}
		//bsg-jneal (4.6.17): end

		if (!m_bViewingSoldiers)
		{
			MC.FunctionNum("setUnhighlight", m_ViewReplayIndex);
			m_ViewReplayIndex++;
			if (m_ViewReplayIndex >= m_LeaderboardsData.Length)
			{
				m_ViewReplayIndex = 0;
			}
		}
		else
		{
			if ((m_ViewReplayIndex + 3) <= 4 + m_NumSoldierSlots) //furthest down index
			{
				MC.FunctionNum("setUnhighlight", m_ViewReplayIndex);
				m_ViewReplayIndex += 3; //only 3 items per row
			}
		}

		MC.FunctionNum("setHighlight", m_ViewReplayIndex);		
		break;
		//bsg-jneal (5.5.17): end
	}
	//bsg-jneal (5.26.17): end

	return super.OnUnrealCommand(cmd, arg);
}

function IntervalDropdownSelectionChange(UIDropdown kDropdown)
{
	local int Idx;
	Idx = int(m_IntervalDropdown.GetSelectedItemData());
	m_CurrentIntervalSeedID = m_arrIntervals[Idx].IntervalSeedID;

	// Enable/Disable the "Accept Button"
	if (m_arrIntervals[Idx].IntervalState == ECST_Started)
	{
		m_AcceptChallengeButton.DisableButton(class'X2MPData_Shell'.default.m_strChallengeUnplayableAlreadyAttemptedDialogText);
		OnLeaderboardButton(none);
	}
	else if (m_arrIntervals[Idx].IntervalState == ECST_Submitted)
	{
		m_AcceptChallengeButton.DisableButton(class'X2MPData_Shell'.default.m_strChallengeUnplayableSubmittedDialogText);
		OnLeaderboardButton(none);
	}
	else if (m_arrIntervals[Idx].IntervalState == ECST_TimeExpired)
	{
		m_AcceptChallengeButton.DisableButton(class'X2MPData_Shell'.default.m_strChallengeUnplayableTimedoutDialogText);
		OnLeaderboardButton(none);
	}
	else
	{
		m_AcceptChallengeButton.EnableButton();
		TopPlayersButtonCallback(none);
	}

	UpdateData();
}

//==============================================================================
//		DAILY CHALLENGE HANDLERS:
//==============================================================================
private function int SortChallengeIntervals(IntervalInfo A, IntervalInfo B)
{
	// Reverse sort
	if (A.IntervalName > B.IntervalName)
		return 1;
	if (A.IntervalName < B.IntervalName)
		return -1;
	return 0;
}

function OnReceivedChallengeModeIntervalStart(int NumIntervals)
{
	`log(`location @ `ShowVar(NumIntervals));
	m_arrIntervals.Length = 0;
}

function OnReceivedChallengeModeIntervalEnd()
{
	local UIChallengeLeaderboards LeaderboardScreen;
	`log(`location);

	if (m_arrIntervals.Length > 0)
	{
		m_arrIntervals.Sort(SortChallengeIntervals);
		m_CurrentIntervalSeedID = m_arrIntervals[0].IntervalSeedID;

		UpdateIntervalDropdown();
		UpdateData();
		TopPlayersButtonCallback(none);
	}
	else
	{
		// No Intervals
		Movie.Pres.UICloseProgressDialog();
		OnLeaderboardButton(none);
		LeaderboardScreen = UIChallengeLeaderboards(GetPresBase().ScreenStack.GetFirstInstanceOf(class'UIChallengeLeaderboards'));
		if (LeaderboardScreen != none)
		{
			LeaderboardScreen.SetDisplayNoChallengeDialogOnInit();
		}
	}
	RequestFinished(PerformChallengeModeGetIntervals);
}

function OnReceivedChallengeModeIntervalEntry(qword IntervalSeedID, int ExpirationDate, int TimeLength, EChallengeStateType IntervalState, optional string IntervalName, optional array<byte> StartState)
{
	local int Idx;
	`log(`location @ QWordToString(IntervalSeedID) @ `ShowVar(ExpirationDate) @ `ShowVar(TimeLength) @ `ShowEnum(EChallengeStateType, IntervalState, IntervalState) @ `ShowVar(IntervalName), , 'XCom_Online');
	Idx = m_arrIntervals.Length;
	m_arrIntervals.Add(1);
	m_arrIntervals[Idx].IntervalSeedID = IntervalSeedID;
	m_arrIntervals[Idx].DateEnd.B = ExpirationDate;
	m_arrIntervals[Idx].TimeLimit = TimeLength;
	m_arrIntervals[Idx].IntervalState = IntervalState;
	m_arrIntervals[Idx].IntervalName = IntervalName;
	m_arrIntervals[Idx].StartState = StartState;
	DisplayProgressMessage("Received an Interval from the server. Total (" $ m_arrIntervals.Length $ ")");
}

function OnReceivedChallengeModeSeed(int LevelSeed, int PlayerSeed, int TimeLimit, qword StartTime, int GameScore)
{
	//Firaxis Live implementation does not use the function parameters here.

	//UpdateData();
	DisplayProgressMessage("Received Seed information from the server.");
}

function OnReceivedChallengeModeGetEventMapData(qword IntervalSeedID, int NumEvents, int NumTurns, array<INT> EventMap)
{
	`log(`location @ QWordToString(IntervalSeedID) @ `ShowVar(NumEvents) @ `ShowVar(NumTurns) @ `ShowVar(EventMap.Length),,'XCom_Online');
	OnlineEventMgr.m_ChallengeModeEventMap = EventMap;
	ChallengeModeManager.ResetAllData();
	DisplayProgressMessage("Done getting Event Data from the server.");
}

simulated event OnReceiveChallengeModeActionFinished(ICMS_Action Action, bool bSuccess)
{
	switch(Action)
	{
	case ICMS_GetSeed:
		UpdateData();
		break;
	case ICMS_GetEventMapData:
		DisplayProgressMessage("Event Data has been retrieved from the server.");
		break;
	default:
		break;
	}
}

public function TopPlayersButtonCallback(UIButton button)
{
	QueueRequest(PerformGetTopPlayerLeaderboard);
}

function PerformGetTopPlayerLeaderboard()
{
	`log(self $ "::" $ GetFuncName(), , 'uixcom_mp');
	if (!m_bViewingSoldiers)
	{
		if (m_kMPShellManager.m_bLeaderboardsTopPlayersDataLoaded)
		{
			OnLeaderBoardFetchComplete(m_kMpShellManager.m_tLeaderboardsTopPlayersData);
		}
		else
		{
			FetchLeaderboardData(eMPLeaderboard_TopPlayers);
		}
	}
}

public function FriendRanksButtonCallback(UIButton button)
{
	QueueRequest(PerformGetFriendLeaderboard);
}

function PerformGetFriendLeaderboard()
{
	`log(self $ "::" $ GetFuncName(), , 'uixcom_mp');
	if (!m_bViewingSoldiers)
	{
		if (m_kMPShellManager.m_bLeaderboardsFriendsDataLoaded)
		{
			OnLeaderBoardFetchComplete(m_kMpShellManager.m_tLeaderboardsFriendsData);
		}
		else
		{
			FetchLeaderboardData(eMPLeaderboard_Friends);
		}
	}
}

function OnLeaderBoardFetchComplete(const out TLeaderboardsData kLeaderboardsData)
{
	m_LeaderboardsData = kLeaderboardsData.arrResults;

	UpdateData();

	Movie.Pres.UICloseProgressDialog();
	UpdateNavHelp();
}

function bool FetchLeaderboardData(EMPLeaderboardType kLeaderboardType)
{
	local bool bSuccess;
	local TProgressDialogData kDialogBoxData;
	local int Index;

	Index = GetIntervalIndex(m_CurrentIntervalSeedID);
	if (Index == -1)
	{
		`log(`location @ "Failed to find Interval for ID:" @ QWordToString(m_CurrentIntervalSeedID));
		return false;
	}

	`log(`location @ "Using Name:" @ `ShowVar(m_arrIntervals[Index].IntervalName, IntervalName));
	switch (kLeaderboardType)
	{
	case eMPLeaderboard_TopPlayers:
		bSuccess = ChallengeModeInterface.PerformChallengeModeGetTopGameScores(m_arrIntervals[Index].IntervalName, , MAX_LEADERBOARDS);
		break;
	case eMPLeaderboard_Friends:
		PerformGetGameScoreFriends(, , MAX_LEADERBOARDS);
		bSuccess = m_FriendFetch.bSuccess;
		break;
	default:
		bSuccess = false;
	}
	if (bSuccess)
	{
		m_LeaderboardsData.Remove(0, m_LeaderboardsData.Length);
		// If we're going to spawn a dialog box that says we're fetching data, that means we don't want navhelp to display anything, since we aren't able to do anything(kmartinez)
		m_NavHelp.ClearButtonHelp();
		kDialogBoxData.strTitle = class'X2MPData_Shell'.default.m_strMPFetchingLeaderboardsProgressDialogTitle;
		kDialogBoxData.strDescription = class'X2MPData_Shell'.default.m_strMPFetchingLeaderboardsProgressDialogText;

		Movie.Pres.UIProgressDialog(kDialogBoxData);
	}
	return bSuccess;
}

//==============================================================================
//		STATES:
//==============================================================================
state ExecuteMapChange
{
	simulated function ClearHistory()
	{
		// Do not clear the history whenever switching maps (i.e. loading a replay or challenge)
		`log(`location);
	}

Begin:
	Cleanup(); // Unregisters any delegates prior to the map change
	ConsoleCommand(m_NextMapCommand);
}

state LaunchChallenge
{
	function OnReceivedChallengeModeGetEventMapData(qword IntervalSeedID, int NumEvents, int NumTurns, array<INT> EventMap)
	{
		global.OnReceivedChallengeModeGetEventMapData(IntervalSeedID, NumEvents, NumTurns, EventMap);
		ChallengeModeInterface.PerformChallengeModeGetSeed(m_CurrentIntervalSeedID);
	}

	function OnReceivedChallengeModeSeed(int LevelSeed, int PlayerSeed, int TimeLimit, qword StartTime, int GameScore)
	{
		global.OnReceivedChallengeModeSeed(LevelSeed, PlayerSeed, TimeLimit, StartTime, GameScore);
		LoadTacticalMap();
	}

	function LoadTacticalMap()
	{
		`ONLINEEVENTMGR.bIsChallengeModeGame = true;
		SetChallengeData();
		m_NextMapCommand = m_BattleData.m_strMapCommand;
		GotoState('ExecuteMapChange');
	}

	function SetChallengeData()
	{
		local int Index;

		Index = GetIntervalIndex(m_CurrentIntervalSeedID);
		m_ChallengeData.LeaderBoardName = m_arrIntervals[Index].IntervalName;
		m_ChallengeData.SeedData.IntervalSeedID = m_CurrentIntervalSeedID;
		OnlineSub.PlayerInterface.GetUniquePlayerId(`ONLINEEVENTMGR.LocalUserIndex, m_ChallengeData.SeedData.PlayerID);
	}

Begin:
	// Get the latest Event Data from the server ...
	DisplayProgressMessage("Loading Event Data from the server ...");
	`CHALLENGEMODE_MGR.SetSelectedChallengeIndex(int(m_IntervalDropdown.GetSelectedItemData()));
	ChallengeModeInterface.PerformChallengeModeGetEventMapData(m_CurrentIntervalSeedID);
}

state ReplayDownloading
{
	function PerformReplayStateAction()
	{
		PlaySound(SoundCue'SoundUI.NegativeSelection2Cue', true);
	}

	function ReceivedGameData()
	{
		LoadGameData();
	}

}

state ReplayCanceled
{
	function PerformReplayStateAction()
	{
		if (PlayerGameData.Length > 0)
		{
			LoadGameData();
		}
		else
		{
			GotoState('ReplayDownloading');
		}
	}
}

//==============================================================================
//		CLEANUP:
//==============================================================================
simulated event OnCleanupWorld()
{
	Cleanup();

	super.OnCleanupWorld();
}

simulated event Destroyed() 
{
	UnsubscribeFromOnCleanupWorld();
	Cleanup();

	super.Destroyed();
}

simulated function Cleanup()
{
	local X2FiraxisLiveClient LiveClient;

	ClearDelegates();

	LiveClient = `FXSLIVE;
	LiveClient.ClearReceivedStatsKVPDelegate(OnReceivedPlayerStats);
	LiveClient.ClearReceivedStatsKVPDelegate(OnReceivedGlobalMissionStats);
	ChallengeModeInterface.ClearReceivedChallengeModeGetGameSaveDelegate(OnReceivedChallengeModeGetGameSave);

	m_kMPShellManager.CancelLeaderboardsFetch();

	ClearHistory();
}

// This should be overridden inside of any state that is going to load a replay or challenge, so the history doesn't get reset.
simulated function ClearHistory()
{
	`log(`location);
	// if the Leaderboard screen is up, let it handle the clean-up.
	if (UIChallengeLeaderboards(GetPresBase().ScreenStack.GetFirstInstanceOf(class'UIChallengeLeaderboards')) == none)
	{
		History.ResetHistory(); // Make sure to clear out all of the loaded history details.
	}
}

simulated function ClearDelegates()
{
	local byte LocalUserNum;
	ScriptTrace();
	`log(`location @ `ShowVar(m_DelegatesHookedup));
	if (m_DelegatesHookedup)
	{
		LocalUserNum = `ONLINEEVENTMGR.LocalUserIndex;

		OnlineSub.PlayerInterface.ClearRequestUserInformationCompleteDelegate(OnRequestUserInformationComplete);
		OnlineSub.PlayerInterface.ClearFriendsChangeDelegate(LocalUserNum, OnFriendsChange);
		OnlineSub.PlayerInterface.ClearReadFriendsCompleteDelegate(LocalUserNum, OnReadFriendsComplete);

		ChallengeModeInterface.ClearReceivedChallengeModeIntervalStartDelegate(OnReceivedChallengeModeIntervalStart);
		ChallengeModeInterface.ClearReceivedChallengeModeIntervalEndDelegate(OnReceivedChallengeModeIntervalEnd);
		ChallengeModeInterface.ClearReceivedChallengeModeIntervalEntryDelegate(OnReceivedChallengeModeIntervalEntry);
		ChallengeModeInterface.ClearReceivedChallengeModeSeedDelegate(OnReceivedChallengeModeSeed);
		ChallengeModeInterface.ClearReceivedChallengeModeGetEventMapDataDelegate(OnReceivedChallengeModeGetEventMapData);
		ChallengeModeInterface.ClearReceivedChallengeModeLeaderboardStartDelegate(OnReceivedChallengeModeLeaderboardStart);
		ChallengeModeInterface.ClearReceivedChallengeModeLeaderboardEndDelegate(OnReceivedChallengeModeLeaderboardEnd);
		ChallengeModeInterface.ClearReceivedChallengeModeLeaderboardEntryDelegate(OnReceivedChallengeModeLeaderboardEntry);

		m_kMPShellManager.ClearLeaderboardFetchCompleteDelegate(OnLeaderBoardFetchComplete);
		m_DelegatesHookedup = false;
	}
}

//bsg-jneal (5.5.17): clean up navhelp positioning change on closing
simulated function CloseScreen()
{
	m_NavHelp.SetY(0);
	m_NavHelp.ClearButtonHelp();
	super.CloseScreen();
}
//bsg-jneal (5.5.17): end

//==============================================================================
//		DEFAULTS:
//==============================================================================

defaultproperties
{
	Package   = "/ package/gfxDailyChallenge/DailyChallenge";
	MCName      = "theScreen";

	m_ViewReplayIndex = 0;
	m_bViewingSoldiers = false;
	m_bGlobalLeaderboards = true;

	InputState= eInputState_Evaluate;
	m_DelegatesHookedup=false
}
