//---------------------------------------------------------------------------------------
//  *********   FIRAXIS SOURCE CODE   ******************
//  FILE:    UIChallengeLeaderboards.uc
//  AUTHOR:  Joe Cortese
//  PURPOSE: Screen that shows the challenge leaderboards
//---------------------------------------------------------------------------------------
//  Copyright (c) 2017 Firaxis Games Inc. All rights reserved.
//--------------------------------------------------------------------------------------- 
class UIChallengeLeaderboards extends UIMPShell_Leaderboards
	dependson(XComGameStateContext_ChallengeScore, X2ChallengeModeDataStructures);

struct FriendFetchInfo
{
	var bool bFetchingFriends;
	var bool bComplete;
	var bool bSuccess;
	var int	Offset;
	var int Limit;
	var delegate<FriendFetchComplete> OnComplete;
};

var array<UIChallengeLeaderboard_HeaderButton> m_aChallengeHeaderButtons;

var UIChallengeLeaderboard_ListItem m_plrLeaderboardEntry;
var TLeaderboardEntry			m_plrEntry;
var bool						bLocalStartedMission;

var localized string            m_strScoreColumnText;
var localized string            m_strTimeColumnText;
var localized string            m_strReplayColumnText;

var localized string            m_strScoreBreakdown;
var localized string            m_strAverageScore;
var localized string            m_strMissionSuccess;
var localized string            m_strMissionFailed;
var localized string            m_strMissionNotStarted;
var localized string            m_strMissionFinished;
var localized string            m_strMissionComplete;
var localized string            m_strTimeScore;
var localized string            m_strPar;
var localized string            m_strBonus;

var localized string            m_strAliveSoldiers;
var localized string            m_strKilledEnemies;
var localized string            m_strCompletedObjectives;
var localized string            m_strCiviliansSaved;
var localized string            m_strUninjuredSoldiers;

var localized string            m_strPreviousChallenge;
var localized string            m_strNextChallenge;
var localized string			m_strChallenge;
var UIButton					m_PreviousChallengeButton;
var UIButton					m_NextChallengeButton;


var privatewrite bool           m_bUpdatingLeaderboardData;
var privatewrite bool			m_bFoundLocalPlayerLeaderboardData;
var privatewrite bool           m_bUpdatingIntervalData;
var array<EMPLeaderboardType>   m_arrLeaderboardRequestQueue;
var bool						m_bSequenceRequests; // If true, the queue will fire off requests one at a time; false, all queries will run asynchroniously
var FriendFetchInfo				m_FriendFetch;
var int							m_LeaderboardOffset;
var int							m_LeaderboardLimit;
var string						m_OverrideLeaderboardName;
var bool						m_bGetPlayerGameSave;
var bool						m_bDisplayNoChallengeDataOnInit;

var private X2ChallengeModeInterface    ChallengeModeInterface;
var private XComChallengeModeManager	ChallengeModeManager;
var private OnlineSubsystem		m_OnlineSub;

var UniqueNetId					m_LocalPlayerID;

var UIButton					m_JumpToTopButton; 

const MAX_LEADERBOARDSENTRIES = 12;


//--------------------------------------------------------------------------------------- 
// Challenge Data
//
var array<IntervalInfo>			m_arrIntervals;
var int							m_iIncomingIntervalCount;
var int							m_CurrentLeaderboardIndex;
var int							m_TotalPlayerCount;


simulated function string GetUsernameText()
{
	return m_strNameColumnText;
}

simulated function InitScreen(XComPlayerController InitController, UIMovie InitMovie, optional name InitName)
{
	local UIChallengeLeaderboard_HeaderButton headerButton;

	super(UIMPShell_Base).InitScreen(InitController, InitMovie, InitName);

	ChallengeModeManager = `CHALLENGEMODE_MGR;

	m_LeaderboardLimit = MAX_LEADERBOARDSENTRIES;
	
	m_kContainer = Spawn(class'UIPanel', self).InitPanel('StageList');
	m_kContainer.bIsNavigable = false;

	m_kList = Spawn(class'UIList', m_kContainer).InitList('', 0, 0, 1265, 630);
	m_kList.bIsNavigable = `ISCONTROLLERACTIVE; //bsg-jneal (5.9.17): list is navigable on controller

	m_eSortType = eLeaderboardSortType_Rank;

	m_kHeader = Spawn(class'UIPanel', self).InitPanel('challengeHeader');
	m_kHeader.bIsNavigable = false;

	headerButton = Spawn(class'UIChallengeLeaderboard_HeaderButton', m_kHeader);
	headerButton.InitHeaderButton("rank", eLeaderboardSortType_Rank, m_strRankColumnText);
	m_aChallengeHeaderButtons.AddItem( headerButton );
	
	headerButton = Spawn(class'UIChallengeLeaderboard_HeaderButton', m_kHeader);
	headerButton.InitHeaderButton("name", eLeaderboardSortType_Name, GetUsernameText());
	m_aChallengeHeaderButtons.AddItem( headerButton );

	headerButton = Spawn(class'UIChallengeLeaderboard_HeaderButton', m_kHeader);
	headerButton.InitHeaderButton("score", eLeaderboardSortType_Score, m_strScoreColumnText);
	m_aChallengeHeaderButtons.AddItem( headerButton );

	headerButton = Spawn(class'UIChallengeLeaderboard_HeaderButton', m_kHeader);
	headerButton.InitHeaderButton("time", eLeaderboardSortType_Time, m_strTimeColumnText);
	m_aChallengeHeaderButtons.AddItem( headerButton );

	headerButton = Spawn(class'UIChallengeLeaderboard_HeaderButton', m_kHeader);
	headerButton.InitHeaderButton("replay", eLeaderboardSortType_Replay, m_strReplayColumnText);
	headerButton.DisableButton();
	m_aChallengeHeaderButtons.AddItem( headerButton );

	m_plrLeaderboardEntry = Spawn(class'UIChallengeLeaderboard_ListItem', self);
	InitializeListItem(m_plrLeaderboardEntry, 'playerRow');
	
	SubscribeToOnCleanupWorld();

	//bsg-jneal (5.9.17): list is navigable on controller
	if(`ISCONTROLLERACTIVE)
	{
		Navigator.SetSelected(m_kList);
		m_kList.OnSelectionChanged = OnListReplayChanged;
	}
	else
	{
		Navigator.Clear();
	}
	//bsg-jneal (5.9.17): end
	
	PrevPageButton = Spawn(class'UIButton', self).InitButton('prevpage', m_strPreviousPageText, PreviousPageCallback);
	PrevPageButton.SetPosition(320, 960);//Inside the bottom BG area on stage.

	TopPlayersButton = Spawn(class'UIButton', self).InitButton('topPlayers', class'UIChallengeMode_SquadSelect'.default.m_strGlobalLeaderboardsLabel, TopPlayersButtonCallback);
	TopPlayersButton.SetPosition(1280, 120);

	YourRankButton = Spawn(class'UIButton', self).InitButton('yourRank', m_strYourRankButtonText, YourChallengeRankButtonCallback);
	YourRankButton.SetPosition(850, 960);//Inside the bottom BG area on stage.

	FriendsButton = Spawn(class'UIButton', self).InitButton('friendsButton', class'UIChallengeMode_SquadSelect'.default.m_strFriendsLeaderboardsLabel, FriendRanksButtonCallback);
	FriendsButton.SetPosition(1450, 120);
	
	NextPageButton  = Spawn(class'UIButton', self).InitButton('nextPage', m_strNextPageText, NextPageCallback);
	NextPageButton.SetPosition(1420, 960);//Inside the bottom BG area on stage.

	m_JumpToTopButton = Spawn(class'UIButton', self).InitButton('jumpToTop', m_strTopPlayersButtonText, TopPlayersButtonCallback);
	m_JumpToTopButton.SetPosition(850, 925); //Inside the bottom BG area on stage.
	
	m_PreviousChallengeButton = Spawn(class'UIButton', self).InitButton('prevchallenge', m_strPreviousChallenge, PreviousChallengeCallback);
	m_PreviousChallengeButton.AnchorBottomCenter();
	m_PreviousChallengeButton.SetPosition(-640, -40);

	m_NextChallengeButton = Spawn(class'UIButton', self).InitButton('nextchallenge', m_strNextChallenge, NextChallengeCallback);
	m_NextChallengeButton.AnchorBottomCenter();
	m_NextChallengeButton.SetPosition(480, -40);
	m_NextChallengeButton.DisableButton();

	PrevPageButton.SetVisible(`ISCONTROLLERACTIVE == false);
	TopPlayersButton.SetVisible(`ISCONTROLLERACTIVE == false);
	YourRankButton.SetVisible(`ISCONTROLLERACTIVE == false);
	FriendsButton.SetVisible(`ISCONTROLLERACTIVE == false);
	NextPageButton.SetVisible(`ISCONTROLLERACTIVE == false);
	m_PreviousChallengeButton.SetVisible(`ISCONTROLLERACTIVE == false);
	m_NextChallengeButton.SetVisible(`ISCONTROLLERACTIVE == false);
	m_JumpToTopButton.SetVisible(`ISCONTROLLERACTIVE == false);

	m_eSortOrder[0] = eLeaderboardSortType_Rank;
	m_eSortOrder[1] = eLeaderboardSortType_Name;
	m_eSortOrder[2] = eLeaderboardSortType_Score;
	m_eSortOrder[3] = eLeaderboardSortType_Time;
	m_eSortOrder[4] = eLeaderboardSortType_Replay;

	m_iCurrentlySelectedHeaderButton = 0;
}

simulated function CompareEntries(TLeaderboardEntry entry)
{
	MC.BeginFunctionOp("SetOtherScoreBreakdown");
	MC.QueueString(entry.strPlayerName);
	MC.QueueString(string(entry.SoldiersAlive));
	MC.QueueString(string(entry.KilledEnemies));
	MC.QueueString(string(entry.CompletedObjectives));
	MC.QueueString(string(entry.TimeBonus));
	MC.QueueString(string(entry.CiviliansSaved));
	MC.QueueString(string(entry.UninjuredSoldiers));
	MC.EndOp();
}

simulated function CloseComparisson()
{
	MC.BeginFunctionOp("SetOtherScoreBreakdown");
	MC.EndOp();
}

//bsg-jneal (5.9.17): refresh data to override label text for button image injection
simulated function OnListReplayChanged(UIList ContainerList, int ItemIndex)
{
	local UIChallengeLeaderboard_ListItem listItem;
	local int i;

	if(`ISCONTROLLERACTIVE)
	{
		// refresh list items to clear old button text injection
		for(i = 0; i < m_kList.ItemCount; i++)
		{
			listItem = UIChallengeLeaderboard_ListItem(m_kList.GetItem(i));
			listItem.UpdateData(listItem.m_LeaderboardEntry);
		}

		listItem = UIChallengeLeaderboard_ListItem(m_kList.GetSelectedItem());
		CompareEntries(listItem.m_LeaderboardEntry);
		listItem.RefreshChallengeData(class'UIUtilities_Text'.static.InjectImage(class'UIUtilities_Input'.static.GetAdvanceButtonIcon(), 18, 18, -4) @ listItem.m_currentStatus);
	}
}
//bsg-jneal (5.9.17): end

simulated function UpdateNavButtons()
{
	if (`ISCONTROLLERACTIVE)
	{
		//MODIFIED FOR XBOX USE OF 'GAMERCARD' - JTA 2016/4/8
		//INS:
		m_NavHelp.AddCenterHelp(m_strToggleSortingButtonText, class'UIUtilities_Input'.const.ICON_X_SQUARE);

		//Only display the "Top Players" button if we're not displaying that leaderboard.
		if (m_eLeaderboardType != eMPLeaderboard_TopPlayers)
			m_NavHelp.AddCenterHelp(m_strTopPlayersButtonText, class'UIUtilities_Input'.const.ICON_LT_L2);

		//Only display the "Your Rank" button if we're not displaying that leaderboard.
		if (m_eLeaderboardType != eMPLeaderboard_YourRank)
			m_NavHelp.AddCenterHelp(m_strYourRankButtonText, class'UIUtilities_Input'.const.ICON_Y_TRIANGLE);

		//Only display the "Friend Ranks" button if we're not displaying that leaderboard.
		if (m_eLeaderboardType != eMPLeaderboard_Friends && m_FriendFetch.bSuccess)
			m_NavHelp.AddCenterHelp(m_strFriendRanksButtonText, class'UIUtilities_Input'.const.ICON_RT_R2);

		//CONSOLE_INPUT RJM 2016/03/04; JTA 2016/6/6
		if (m_eLeaderboardType == eMPLeaderboard_TopPlayers)
		{
			if (m_iTopPlayersRank > 1)
			{
				m_NavHelp.AddCenterHelp(m_strPreviousPageText, class'UIUtilities_Input'.const.ICON_LB_L1);
			}
			m_NavHelp.AddCenterHelp(m_strNextPageText, class'UIUtilities_Input'.const.ICON_RB_R1);
		}

		
		m_navHelp.AddCenterHelp(m_strPreviousChallenge, class'UIUtilities_Input'.const.ICON_DPAD_LEFT);
		m_navHelp.AddCenterHelp(m_strNextChallenge, class'UIUtilities_Input'.const.ICON_DPAD_RIGHT);
	}
	else
	{
		PrevPageButton.SetDisabled(m_eLeaderboardType != eMPLeaderboard_TopPlayers && m_eLeaderboardType != eMPLeaderboard_Friends);
		NextPageButton.SetDisabled(m_eLeaderboardType != eMPLeaderboard_TopPlayers && m_eLeaderboardType != eMPLeaderboard_Friends);

		if (m_eLeaderboardType == eMPLeaderboard_TopPlayers)
		{
			PrevPageButton.Show();
		}

		TopPlayersButton.Show();
		YourRankButton.Show();
		FriendsButton.Show();
		m_JumpToTopButton.Show();
		if (!m_FriendFetch.bSuccess)
		{
			FriendsButton.Hide();
		}

		if (m_eLeaderboardType == eMPLeaderboard_TopPlayers)
		{
			NextPageButton.Show();
		}
	}
}

simulated function OnInit()
{
	local byte LocalUserNum;
	local string DateString;
	local TDateTime kDateTime;
	local int year, month, day;

	class'XComGameState_TimerData'.static.GetUTCDate(class'XComGameState_TimerData'.static.GetUTCTimeInSeconds(), year, month, day);
	kDateTime.m_iDay = day;
	kDateTime.m_iMonth = month;
	kDateTime.m_iYear = year;
	DateString = "";

	DateString = class'X2StrategyGameRulesetDataStructures'.static.GetDateString(kDateTime, true);

	super(UIMPShell_Base).OnInit();

	LocalUserNum = `ONLINEEVENTMGR.LocalUserIndex;

	m_OnlineSub = Class'GameEngine'.static.GetOnlineSubsystem();
	m_OnlineSub.PlayerInterface.GetUniquePlayerId(LocalUserNum, m_LocalPlayerID);
	m_OnlineSub.PlayerInterface.AddRequestUserInformationCompleteDelegate(OnRequestUserInformationComplete);
	m_OnlineSub.PlayerInterface.AddFriendsChangeDelegate(LocalUserNum, OnFriendsChange);
	m_OnlineSub.PlayerInterface.AddReadFriendsCompleteDelegate(LocalUserNum, OnReadFriendsComplete);

	`log(`location @ `ShowVar(m_OnlineSub.UniqueNetIdToString(m_LocalPlayerID), m_LocalPlayerID), , 'XCom_Online');
	m_plrEntry.PlatformID = m_LocalPlayerID;
	m_OnlineSub.PlayerInterface.RequestUserInformation(LocalUserNum, m_LocalPlayerID);

	// Setting up Firaxis Live Delegates
	ChallengeModeInterface = `CHALLENGEMODE_INTERFACE;
	ChallengeModeInterface.AddReceivedChallengeModeLeaderboardStartDelegate(OnReceivedChallengeModeLeaderboardStart);
	ChallengeModeInterface.AddReceivedChallengeModeLeaderboardEndDelegate(OnReceivedChallengeModeLeaderboardEnd);
	ChallengeModeInterface.AddReceivedChallengeModeLeaderboardEntryDelegate(OnReceivedChallengeModeLeaderboardEntry);
	ChallengeModeInterface.AddReceivedChallengeModeDeactivatedIntervalStartDelegate(OnReceivedChallengeModeDeactivatedIntervalStart);
	ChallengeModeInterface.AddReceivedChallengeModeDeactivatedIntervalEndDelegate(OnReceivedChallengeModeDeactivatedIntervalEnd);
	ChallengeModeInterface.AddReceivedChallengeModeDeactivatedIntervalEntryDelegate(OnReceivedChallengeModeDeactivatedIntervalEntry);

	SetTitle(m_strChallenge @ "-" @ DateString, "-"); // Challenge, Par
	SetScoreBreakdown();
	SetPlayerRow(m_plrEntry);

	m_NavHelp = Spawn(class'UINavigationHelp', self).InitNavHelp();
	UpdateNavHelp();

	m_kMPShellManager.CancelLeaderboardsFetch();
	m_kMPShellManager.AddLeaderboardFetchCompleteDelegate(OnLeaderBoardFetchComplete);

	FetchDeactivatedIntervals();

	if( `ISCONTROLLERACTIVE ) 
		m_NavHelp.SetCenterHelpPaddingValue(m_NavHelp.CENTER_HELP_CONTAINER_PADDING - 10);
}

simulated function UpdateDataFromTempData()
{
	local int Points, PlayerScore1, PlayerScore2, PlayerScore3, PlayerScore4, TimeRemaining, PlayerScoreBonus;
	local LeaderboardScoreData ScoreData;
	local ScoreTableEntry ScoreEntry;

	`log(`location @ `ShowVar(m_CurrentLeaderboardIndex));
	ChallengeModeManager.GetTempScoreData(ScoreData);
	if (m_CurrentLeaderboardIndex < 0 || m_arrIntervals[m_CurrentLeaderboardIndex].IntervalSeedID != ScoreData.IntervalSeedID)
	{
		return;
	}

	bLocalStartedMission = true;
	m_plrEntry.iScore = ScoreData.GameScore;
	m_plrEntry.iTime = ScoreData.TimeCompleted;
	`log(`location @ `ShowVar(m_plrEntry.iScore) @ `ShowVar(m_plrEntry.iTime));

	foreach ScoreData.ScoreEntries(ScoreEntry)
	{
		`log(`location @ `ShowEnum(ChallengeModePointType, ScoreEntry.ScoreType, ScoreType) @ `ShowVar(ScoreEntry.MaxPossible, MaxPossible));
		Points = ScoreEntry.MaxPossible;
		switch (ScoreEntry.ScoreType)
		{
		case CMPT_AliveSoldiers: PlayerScore1 += Points; break;
		case CMPT_KilledEnemy: PlayerScore2 += Points; break;
		case CMPT_CompletedObjective: PlayerScore3 += Points; break;
		case CMPT_CiviliansSaved: PlayerScore4 += Points; break;
		case CMPT_UninjuredSoldiers: PlayerScoreBonus += Points; break;
		case CMPT_TimeRemaining: TimeRemaining += Points; break;
		default: break;
		}
	}
	SetScoreBreakdown(string(PlayerScore1), string(PlayerScore2), string(PlayerScore3), string(PlayerScore4), string(TimeRemaining), string(PlayerScoreBonus));
	SetPlayerRow(m_plrEntry);
	LoadTitleFromHistory();
}

//bsg-jneal (5.9.17): add select navhelp for list items to select replays
simulated function UpdateNavHelp()
{
	super.UpdateNavHelp();
	m_NavHelp.AddSelectNavHelp();
}
//bsg-jneal (5.9.17): end

simulated function bool OnUnrealCommand(int cmd, int arg)
{
	local int previousSelectedIndex;
	local bool bHandled;

	if( !CheckInputIsReleaseOrDirectionRepeat(cmd, arg) )
		return false;

	bHandled = true;

	switch( cmd )
	{
	case class'UIUtilities_Input'.const.FXS_BUTTON_X:

		//here we change the sort type.
		//we also change our index
		previousSelectedIndex = m_iCurrentlySelectedHeaderButton;
		if(m_bFlipSort)
		{	
			m_iCurrentlySelectedHeaderButton++;
			m_eSortType = m_eSortOrder[m_iCurrentlySelectedHeaderButton];
			if(m_iCurrentlySelectedHeaderButton >= LEADERBOARDS_SORT_SIZE) //bsg-jneal (5.9.17): new enum entries extended size for checks so making new const to check against instead
			{
				m_iCurrentlySelectedHeaderButton = 0;
				m_eSortType = m_eSortOrder[m_iCurrentlySelectedHeaderButton];
			}
		}
		if(previousSelectedIndex != m_iCurrentlySelectedHeaderButton)
		{
			//we've changed to a different index that means
			//that we need to deselect and reselect our new button.
			m_aChallengeHeaderButtons[previousSelectedIndex].Deselect();
			m_aChallengeHeaderButtons[m_iCurrentlySelectedHeaderButton].Select();
		}
		else
		{
			m_bFlipSort = !m_bFlipSort;
			m_aChallengeHeaderButtons[m_iCurrentlySelectedHeaderButton].SetArrow( m_bFlipSort );
		}
		UpdateData();
		break;

	case class'UIUtilities_Input'.const.FXS_BUTTON_LBUMPER:
		PreviousPageCallback(none);
		break;

	case class'UIUtilities_Input'.const.FXS_BUTTON_LTRIGGER:
		TopPlayersButtonCallback(none);
		break;

	case class'UIUtilities_Input'.const.FXS_BUTTON_Y:
		YourChallengeRankButtonCallback(none);
		break;

	case class'UIUtilities_Input'.const.FXS_BUTTON_A:
		UIChallengeLeaderboard_ListItem(m_kList.GetSelectedItem()).StartChallengeReplayDownload(); //bsg-jneal (5.9.17): start replay download
		break;

	case class'UIUtilities_Input'.const.FXS_BUTTON_RTRIGGER:
		if(m_FriendFetch.bSuccess)
			FriendRanksButtonCallback(none);
		break;

	case class'UIUtilities_Input'.const.FXS_BUTTON_RBUMPER:
		NextPageCallback(none);
		break;

	case class'UIUtilities_Input'.const.FXS_DPAD_LEFT :
		SetScoreBreakdown();
		PreviousChallengeCallback(none);
		break;
	case class'UIUtilities_Input'.const.FXS_DPAD_RIGHT :
		SetScoreBreakdown();
		NextChallengeCallback(none);
		break;
	default:
		bHandled = false;
		break;
	}

	if (!bHandled && m_kList.Navigator.OnUnrealCommand(cmd, arg))
		return true;

	return bHandled || super.OnUnrealCommand(cmd, arg);
}

public function PreviousPageCallback(UIButton button)
{
	if (m_eLeaderboardType == eMPLeaderboard_TopPlayers)
	{
		if (m_LeaderboardOffset > 0)
		{
			m_LeaderboardOffset -= MAX_LEADERBOARDSENTRIES;

			if (m_LeaderboardOffset < 0)
			{
				m_LeaderboardOffset = 0;
			}

			if (!FetchTopPlayersListData()) // failed to fetch go back to previous rank
			{
				m_LeaderboardOffset += MAX_LEADERBOARDSENTRIES;
			}
		}
	}
}

public function NextChallengeCallback(UIButton button)
{
	local string DateString;
	local TDateTime kDateTime;
	local int year, month, day;

	if (m_arrIntervals.Length > 1 && !m_NextChallengeButton.IsDisabled)
	{
		m_PreviousChallengeButton.EnableButton();
		m_CurrentLeaderboardIndex += 1;
		if (m_arrIntervals.Length == m_CurrentLeaderboardIndex + 1)
		{
			m_NextChallengeButton.DisableButton();
		}

		class'XComGameState_TimerData'.static.GetUTCDate(class'XComGameState_TimerData'.static.GetUTCTimeInSeconds() - ((m_arrIntervals.Length - 1 - m_CurrentLeaderboardIndex) * 24 * 60 * 60), year, month, day);
		kDateTime.m_iDay = day;
		kDateTime.m_iMonth = month;
		kDateTime.m_iYear = year;
		DateString = "";
		DateString = class'X2StrategyGameRulesetDataStructures'.static.GetDateString(kDateTime, true);

		SetTitle(m_strChallenge @ "-" @ DateString, "-");

		m_plrEntry.iRank = 0;
		m_plrEntry.iScore = 0;
		m_plrEntry.iTime = 0;
		m_plrEntry.TimeBonus = 0;
		m_plrEntry.UninjuredSoldiers = 0;
		m_plrEntry.CiviliansSaved = 0;
		m_plrEntry.CompletedObjectives = 0;
		m_plrEntry.KilledEnemies = 0;
		m_plrEntry.SoldiersAlive = 0;

		bLocalStartedMission = false;
		m_plrLeaderboardEntry.UpdateData(m_plrEntry);

		SetScoreBreakdown();

		// Populate the leaderboard
		YourRankButtonCallback(none);

		UpdateNavButtons();
	}
}

public function PreviousChallengeCallback(UIButton button)
{
	local string DateString;
	local TDateTime kDateTime;
	local int year, month, day;

	if (m_arrIntervals.Length > 1 && !m_PreviousChallengeButton.IsDisabled)
	{
		m_NextChallengeButton.EnableButton();
		m_CurrentLeaderboardIndex -= 1;
		
		if (m_arrIntervals.Length - 6 > m_CurrentLeaderboardIndex)
		{
			m_PreviousChallengeButton.DisableButton();
		}
		
		class'XComGameState_TimerData'.static.GetUTCDate(class'XComGameState_TimerData'.static.GetUTCTimeInSeconds() - ((m_arrIntervals.Length - 1 - m_CurrentLeaderboardIndex) * 24 * 60 * 60), year, month, day);
		kDateTime.m_iDay = day;
		kDateTime.m_iMonth = month;
		kDateTime.m_iYear = year;
		DateString = "";
		DateString = class'X2StrategyGameRulesetDataStructures'.static.GetDateString(kDateTime, true);

		SetTitle(m_strChallenge @ "-" @ DateString, "-");

		m_plrEntry.iRank = 0;
		m_plrEntry.iScore = 0;
		m_plrEntry.iTime = 0;
		m_plrEntry.TimeBonus = 0;
		m_plrEntry.UninjuredSoldiers = 0;
		m_plrEntry.CiviliansSaved = 0;
		m_plrEntry.CompletedObjectives = 0;
		m_plrEntry.KilledEnemies = 0;
		m_plrEntry.SoldiersAlive = 0;

		bLocalStartedMission = false;
		m_plrLeaderboardEntry.UpdateData(m_plrEntry);

		SetScoreBreakdown();

		// Populate the leaderboard
		YourRankButtonCallback(none);

		UpdateNavButtons();
	}
}

public function YourChallengeRankButtonCallback(UIButton button)
{
	local int previousOffset;
	if (bLocalStartedMission && m_LeaderboardOffset != m_plrEntry.iRank)
	{
		m_eLeaderboardType = eMPLeaderboard_TopPlayers;
		previousOffset = m_LeaderboardOffset;
		m_LeaderboardOffset = m_plrEntry.iRank - 1;
		if (!FetchTopPlayersListData()) // failed to fetch go back to previous rank
		{
			m_LeaderboardOffset = previousOffset;
		}
	}
}

public function TopPlayersButtonCallback(UIButton button)
{
	m_eLeaderboardType = eMPLeaderboard_Friends; // change leaderboard type to force a top players check
	m_LeaderboardOffset = 0;
	super.TopPlayersButtonCallback(button);
}

public function NextPageCallback(UIButton button)
{
	if (m_eLeaderboardType == eMPLeaderboard_TopPlayers && m_LeaderboardsData.Length == MAX_LEADERBOARDSENTRIES)
	{
		m_LeaderboardOffset += MAX_LEADERBOARDSENTRIES;

		if (!FetchTopPlayersListData()) // failed to fetch go back to previous rank
		{
			m_LeaderboardOffset -= MAX_LEADERBOARDSENTRIES;
		}
	}
	else if (m_eLeaderboardType == eMPLeaderboard_Friends)
	{
		m_LeaderboardOffset += MAX_LEADERBOARDSENTRIES;

		if (!FetchFriendRanksListData()) // failed to fetch go back to first page of data. 
		{
			m_LeaderboardOffset = 0;
			FetchFriendRanksListData();
		}
	}
}

function SetDisplayNoChallengeDialogOnInit()
{
	m_bDisplayNoChallengeDataOnInit = true;
}

function SetTitle(string Title, string AveScore)
{
	MC.BeginFunctionOp("SetTitle");
	MC.QueueString(Title);
	MC.QueueString("");
	MC.QueueString("");
	MC.QueueString("");
	MC.QueueString("");
	MC.EndOp();
}

function SetScoreBreakdown(optional string PlayerScore1 = "-", optional string PlayerScore2 = "-", optional string PlayerScore3 = "-", optional string PlayerScore4 = "-", optional string TimeScore = "-", optional string PlayerScoreBonus = "-")
{
	MC.BeginFunctionOp("SetScoreBreakdown");
	MC.QueueString(m_strScoreBreakdown); // title
	MC.QueueString(m_strMissionComplete);
	MC.QueueString(bLocalStartedMission ? m_strMissionFinished @ "-" @ m_plrEntry.iScore: m_strMissionNotStarted);
	MC.QueueString(m_strAliveSoldiers);
	MC.QueueString(PlayerScore1); //player score 1 value or -
	MC.QueueString(m_strKilledEnemies);
	MC.QueueString(PlayerScore2); //player score 2 value or -
	MC.QueueString(m_strCompletedObjectives);
	MC.QueueString(PlayerScore3); //player score 3 value or -
	MC.QueueString(m_strCiviliansSaved);
	MC.QueueString(PlayerScore4); //player score 4 value or -
	MC.QueueString(m_strTimeScore);
	MC.QueueString(TimeScore);
	MC.QueueString(m_strUninjuredSoldiers);
	MC.QueueString(PlayerScoreBonus); //player bonus value or -
	MC.EndOp();
}

function SetPlayerRow(const out TLeaderboardEntry PlayerEntry)
{
	MC.BeginFunctionOp("SetPlayerRow");
	MC.QueueBoolean(true);
	MC.QueueString(string(PlayerEntry.iRank) @ "(" $ PlayerEntry.iPercentile $"%)");
	MC.QueueString(PlayerEntry.strPlayerName);
	MC.QueueString(string(PlayerEntry.iScore));
	MC.QueueString(GetMinutesSecondsTime(PlayerEntry.iTime)); // maybe reformat this
	MC.QueueString("");
	MC.EndOp();

	if (m_plrLeaderboardEntry != none)
	{
		m_plrLeaderboardEntry.UpdateData(m_plrEntry);
		UpdateListItem(m_plrLeaderboardEntry);
	}
}

function string GetMinutesSecondsTime(int TimeInSeconds)
{
	local int min, sec;
	local string time;
	min = TimeInSeconds / 60;
	sec = TimeInSeconds % 60;
	time = "" $ min;
	time $= ":" $ (sec < 10) ? "0" $ sec : "" $ sec;
	return time;
}

function LoadTitleFromHistory()
{
	local XComGameState_BattleData BattleData;

	BattleData = XComGameState_BattleData(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_BattleData'));
	class'Engine'.static.SetRandomSeeds(BattleData.iLevelSeed);
}

function LoadScoreComponentsFromHistory()
{
	local int PlayerScore1, PlayerScore2, PlayerScore3, PlayerScore4, TimeRemaining, PlayerScoreBonus;
	local XComGameStateHistory History;
	local XComGameState_ChallengeScore ChallengeScore;

	History = `XCOMHISTORY;

	LoadTitleFromHistory();

	foreach History.IterateByClassType(class'XComGameState_ChallengeScore', ChallengeScore)
	{
		`log(`location @ `ShowEnum(ChallengeModePointType, ChallengeScore.ScoringType, ScoringType) @ `ShowVar(ChallengeScore.AddedPoints, AddedPoints));
		switch (ChallengeScore.ScoringType)
		{
		case CMPT_AliveSoldiers:
			PlayerScore1 += ChallengeScore.AddedPoints;
			break;
		case CMPT_KilledEnemy:
			PlayerScore2 += ChallengeScore.AddedPoints;
			break;
		case CMPT_CompletedObjective:
			PlayerScore3 += ChallengeScore.AddedPoints;
			break;
		case CMPT_CiviliansSaved:
			PlayerScore4 += ChallengeScore.AddedPoints;
			break;
		case CMPT_UninjuredSoldiers:
			PlayerScoreBonus += ChallengeScore.AddedPoints;
			break;
		case CMPT_TimeRemaining:
			TimeRemaining += ChallengeScore.AddedPoints;
			break;
		default:
			break;
		}
	}

	SetScoreBreakdown(string(PlayerScore1), string(PlayerScore2), string(PlayerScore3), string(PlayerScore4), string(TimeRemaining), string(PlayerScoreBonus));
}

simulated function UpdateListItem(UIChallengeLeaderboard_ListItem ListItem)
{
	local qword IntervalID;
	if (m_CurrentLeaderboardIndex >= 0 && m_CurrentLeaderboardIndex < m_arrIntervals.Length)
	{
		IntervalID = m_arrIntervals[m_CurrentLeaderboardIndex].IntervalSeedID;
	}
	`log(`location @ `ShowVar(QWordToString(IntervalID), IntervalID) @ `ShowVar(m_CurrentLeaderboardIndex));
	ListItem.SetLeaderboardName(m_arrIntervals[m_CurrentLeaderboardIndex].IntervalName);
}

simulated function InitializeListItem(UIChallengeLeaderboard_ListItem ListItem, optional name InitName)
{
	local qword IntervalID;
	if (m_CurrentLeaderboardIndex >= 0 && m_CurrentLeaderboardIndex < m_arrIntervals.Length)
	{
		`log(`location @ `ShowEnum(EChallengeStateType, m_arrIntervals[m_CurrentLeaderboardIndex].IntervalState));
		// Skip setting the IntervalID here to "disable" replays whenever the player has not already submitted their own challenge.
		if (m_arrIntervals[m_CurrentLeaderboardIndex].IntervalState != ECST_Ready && m_arrIntervals[m_CurrentLeaderboardIndex].IntervalState != ECST_Started)
		{
			IntervalID = m_arrIntervals[m_CurrentLeaderboardIndex].IntervalSeedID;
		}
	}
	ListItem = ListItem.InitChallengeListItem(IntervalID, InitName);
	UpdateListItem(ListItem);
}

simulated function UILeaderboard_ListItem CreateNewListItem()
{
	local UIChallengeLeaderboard_ListItem ListItem;
	ListItem = UIChallengeLeaderboard_ListItem(m_kList.CreateItem(class'UIChallengeLeaderboard_ListItem'));
	InitializeListItem(ListItem);
	return ListItem;
}

function SortLeaderboards()
{
	switch(m_eSortType)
	{
	case eLeaderboardSortType_Name: m_LeaderboardsData.Sort(SortByName); break;
	case eLeaderboardSortType_Rank: m_LeaderboardsData.Sort(SortByRank); break;
	case eLeaderboardSortType_Score: m_LeaderboardsData.Sort(SortByScore); break;
	case eLeaderboardSortType_Time: m_LeaderboardsData.Sort(SortByTime); break;
	case eLeaderboardSortType_Replay: m_LeaderboardsData.Sort(SortByReplay); break;
	}
}

simulated function int SortByScore(TLeaderboardEntry A, TLeaderboardEntry B)
{
	if(m_bMyRankTop)
	{
		if(A.playerID == PC.PlayerReplicationInfo.UniqueID)
			return 1;
		else if(B.playerID == PC.PlayerReplicationInfo.UniqueID)
			return -1;
	}

	if(A.iScore < B.iScore) return m_bFlipSort ? -1 : 1;
	else if(A.iScore > B.iScore) return m_bFlipSort ? 1 : -1;
	else return 0;
}

simulated function int SortByTime(TLeaderboardEntry A, TLeaderboardEntry B)
{
	if(m_bMyRankTop)
	{
		if(A.playerID == PC.PlayerReplicationInfo.UniqueID)
			return 1;
		else if(B.playerID == PC.PlayerReplicationInfo.UniqueID)
			return -1;
	}

	if(A.iTime < B.iTime) return m_bFlipSort ? -1 : 1;
	else if(A.iTime > B.iTime) return m_bFlipSort ? 1 : -1;
	else return 0;
}

simulated function int SortByReplay(TLeaderboardEntry A, TLeaderboardEntry B)
{
	if (m_bMyRankTop)
	{
		if (A.playerID == PC.PlayerReplicationInfo.UniqueID)
			return 1;
		else if (B.playerID == PC.PlayerReplicationInfo.UniqueID)
			return -1;
	}

	return 0;
}

function DisplayNoChallengeDialog()
{
	local TDialogueBoxData kConfirmData;
	kConfirmData.eType = eDialog_Warning;
	kConfirmData.strTitle = class'X2MPData_Shell'.default.m_strChallengeNoActiveChallengeDialogTitle;
	kConfirmData.strText = class'X2MPData_Shell'.default.m_strChallengeNoActiveChallengeDialogText;
	kConfirmData.strAccept = class'UIUtilities_Text'.default.m_strGenericOK;
	kConfirmData.strCancel = "";
	Movie.Pres.UIRaiseDialog(kConfirmData);
}

function DisplayNoIntervalsDialog()
{
	local TDialogueBoxData kConfirmData;
	kConfirmData.eType = eDialog_Warning;
	kConfirmData.strTitle = class'X2MPData_Shell'.default.m_strChallengeUnableToGetPastChallengeDataDialogTitle;
	kConfirmData.strText = class'X2MPData_Shell'.default.m_strChallengeUnableToGetPastChallengeDataDialogText;
	kConfirmData.strAccept = class'UIUtilities_Text'.default.m_strGenericOK;
	kConfirmData.strCancel = "";
	kConfirmData.fnCallback = OnDisplayNoIntervalsDialogCallback;
	Movie.Pres.UIRaiseDialog(kConfirmData);
}
function OnDisplayNoIntervalsDialogCallback(Name eAction)
{
	CloseScreen();
}

function DisplayFetchProgress()
{
	local TProgressDialogData kDialogBoxData;

	// If we're going to spawn a dialog box that says we're fetching data, that means we don't want navhelp to display anything, since we aren't able to do anything(kmartinez)
	m_NavHelp.ClearButtonHelp();
	kDialogBoxData.strTitle = class'X2MPData_Shell'.default.m_strMPFetchingLeaderboardsProgressDialogTitle;
	kDialogBoxData.strDescription = class'X2MPData_Shell'.default.m_strMPFetchingLeaderboardsProgressDialogText;
	kDialogBoxData.fnCallback = CloseScreen;

	Movie.Pres.UIProgressDialog(kDialogBoxData);
}

function bool FetchTopPlayersListData()
{
	return FetchLeaderboardData(eMPLeaderboard_TopPlayers);
}

function bool FetchYourRankListData()
{
	return FetchLeaderboardData(eMPLeaderboard_YourRank);
}

function bool FetchFriendRanksListData()
{
	return FetchLeaderboardData(eMPLeaderboard_Friends);
}

function bool FetchLeaderboardData(EMPLeaderboardType kLeaderboardType)
{
	`log(`location @ `ShowEnum(EMPLeaderboardType, kLeaderboardType, kLeaderboardType) @ `ShowVar(m_CurrentLeaderboardIndex) @ `ShowVar(m_arrIntervals.Length) @ `ShowVar(m_bSequenceRequests) @ `ShowVar(m_arrLeaderboardRequestQueue.Length));
	// Confirm that the Leaderboard index is properly set to retrieve the correct leaderboard
	if (m_CurrentLeaderboardIndex < 0 || m_CurrentLeaderboardIndex > m_arrIntervals.Length)
	{
		return false;
	}

	// Already have a request in flight, queue up the next one
	if (m_bSequenceRequests && m_arrLeaderboardRequestQueue.Length > 0)
	{
		m_arrLeaderboardRequestQueue.AddItem(kLeaderboardType);
		return true;
	}

	if (InternalFetchLeaderboardData(kLeaderboardType))
	{
		m_eLeaderboardType = kLeaderboardType;
		if (m_arrLeaderboardRequestQueue.Length == 0)
		{
			m_LeaderboardsData.Length = 0;
			DisplayFetchProgress();
		}
		m_arrLeaderboardRequestQueue.AddItem(kLeaderboardType);
		return true;
	}

	return false;
}

function bool InternalFetchLeaderboardData(EMPLeaderboardType kLeaderboardType)
{
	local bool bSuccess;
	local array<string> PlayerIDs;

	bSuccess = false;

	`log(`location @ "Using Name:" @ `ShowVar(GetLeaderboardName(), IntervalName));
	switch (kLeaderboardType)
	{
	case eMPLeaderboard_TopPlayers:
		bSuccess = ChallengeModeInterface.PerformChallengeModeGetTopGameScores(GetLeaderboardName(), m_LeaderboardOffset, m_LeaderboardLimit);
		break;
	case eMPLeaderboard_Friends:
		PerformGetGameScoreFriends(, m_LeaderboardOffset, m_LeaderboardLimit);
		bSuccess = m_FriendFetch.bSuccess;
		break;
	case eMPLeaderboard_YourRank:
		AddPlayerIDForLeaderboardPlayerList(PlayerIDs);
		bSuccess = ChallengeModeInterface.PerformChallengeModeGetGameScoresFriends(GetLeaderboardName(), PlayerIDs);
		break;
	}

	return bSuccess;
}

function AddPlayerIDForLeaderboardPlayerList(out array<string> PlayerIDs)
{
	local UniqueNetId PlayerNetID;
	m_OnlineSub.GetUniquePlayerNetId(`ONLINEEVENTMGR.LocalUserIndex, PlayerNetID);
	PlayerIDs.AddItem(m_OnlineSub.UniqueNetIdToString(PlayerNetID));
}

function int FindLeaderboardIndex(UniqueNetId PlayerID, optional bool bSearchByPlatformID = false)
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
		`log(`location @ "Returning unfound index for" @ `ShowVar(m_OnlineSub.UniqueNetIdToString(PlayerID), PlayerID));
		Index = -1;
	}

	return Index;
}

function DisplayIntervals()
{
	local int Index;
	for (Index = 0; Index < m_arrIntervals.Length; ++Index)
	{
		`log(`location @ `ShowVar(Index) @ `ShowVar(QWordToString(m_arrIntervals[Index].IntervalSeedID), IntervalSeedID) @ `ShowVar(m_arrIntervals[Index].IntervalName, IntervalName) @ `ShowVar(m_arrIntervals[Index].LevelSeed, LevelSeed)  @ `ShowVar(m_arrIntervals[Index].TimeLimit, TimeLimit));
	}
}

function bool GetCurrentIntervalFromUIChallengeMode_SquadSelect()
{
	local UIChallengeMode_SquadSelect SquadSelectScreen;
	local UIScreenStack ScreenStack;
	local int i, initialSize;

	ScreenStack = `SCREENSTACK;
	SquadSelectScreen = UIChallengeMode_SquadSelect(ScreenStack.GetFirstInstanceOf(class'UIChallengeMode_SquadSelect'));

	if (SquadSelectScreen != none)
	{
		initialSize = m_arrIntervals.Length;
		// Steal the current intervals
		for (i = 0; i < SquadSelectScreen.m_arrIntervals.Length; i++)
		{
			m_arrIntervals.AddItem(SquadSelectScreen.m_arrIntervals[i]);
		}
		DisplayIntervals();
		if (m_arrIntervals.Length > 0)
		{
			m_CurrentLeaderboardIndex = initialSize + SquadSelectScreen.GetIntervalIndex(SquadSelectScreen.m_CurrentIntervalSeedID);

			// Setup the challenge details
			bLocalStartedMission = m_arrIntervals[m_CurrentLeaderboardIndex].IntervalState == ECST_Submitted; //	ECST_Unknown, ECST_Ready, ECST_Started, ECST_Submitted, ECST_TimeExpired, ECST_Deactivated
			LoadTitleFromHistory();

			// Initialize the player entry item to this interval.
			m_plrLeaderboardEntry.UpdateData(m_plrEntry);
			UpdateListItem(m_plrLeaderboardEntry);

			// Populate the leaderboard
			YourRankButtonCallback(none);

			// Prefetch the friend's list
			ASyncReadFriendList(OnFriendFetchComplete, m_LeaderboardOffset, m_LeaderboardLimit);
		}
		// Get total number of players that have completed a challenge
		m_TotalPlayerCount = SquadSelectScreen.m_TotalPlayerCount;
	}
	return m_arrIntervals.Length > 0;
}

function bool GetCurrentIntervalFromTacticalGame()
{
	local XComGameState_Player XComPlayer;
	local XComGameState_ChallengeData ChallengeData;
	local XComGameStateHistory History;
	local string GameURLOptions, ReplayIDstr;
	local int Idx;
	local bool bIsChallengeLocalPlayer, bIsReplay;
	local qword IntervalID;
	//local X2TacticalChallengeModeManager TacticalChallengeModeManager;

	bIsChallengeLocalPlayer = false;
	if (`TACTICALRULES != none)
	{
		History = `XCOMHISTORY;
		ChallengeData = XComGameState_ChallengeData(History.GetSingleGameStateObjectForClass(class'XComGameState_ChallengeData'));
		if (ChallengeData != none)
		{
			GameURLOptions = Split(class'WorldInfo'.static.GetWorldInfo().GetLocalURL(), "?");
			bIsReplay = InStr(GameURLOptions, "LoadingSave") >= 0;
			if (bIsReplay)
			{
				ReplayIDstr = `XCOMGAME.ParseOption(GameURLOptions, "ReplayID");
				IntervalID = StringToQWord(ReplayIDstr);
			}
			else
			{
				IntervalID = ChallengeData.SeedData.IntervalSeedID;
			}

			Idx = m_arrIntervals.Length;
			m_arrIntervals.Add(1);
			m_arrIntervals[Idx].IntervalSeedID = IntervalID;
			m_arrIntervals[Idx].LevelSeed = ChallengeData.SeedData.LevelSeed;
			m_arrIntervals[Idx].TimeLimit = ChallengeData.SeedData.TimeLimit;
			m_arrIntervals[Idx].DateStart = ChallengeData.SeedData.StartTime;  // Epoch Seconds UTC
			m_arrIntervals[Idx].DateEnd = ChallengeData.SeedData.EndTime;    // Epoch Seconds UTC
			m_arrIntervals[Idx].IntervalState = ECST_Submitted;
			m_arrIntervals[Idx].IntervalName = ChallengeData.LeaderBoardName;

			m_CurrentLeaderboardIndex = Idx;
			bLocalStartedMission = true;

			foreach History.IterateByClassType(class'XComGameState_Player', XComPlayer)
			{
				if (XComPlayer.GetTeam() == eTeam_XCom)
				{
					if (XComPlayer.GetGameStatePlayerNetId() == m_LocalPlayerID)
					{
						bIsChallengeLocalPlayer = true;
						m_plrEntry.PlatformID = m_LocalPlayerID;
						m_plrEntry.strPlayerName = XComPlayer.GetGameStatePlayerName();
						m_plrEntry.iScore = ChallengeModeManager.GetTotalScore();
					}
					break;
				}
			}
			
			LoadScoreComponentsFromHistory();

			// Initialize the player entry item to this interval.
			SetPlayerRow(m_plrEntry);

			if (bIsChallengeLocalPlayer)
			{
				// Populate the leaderboard
				TopPlayersButtonCallback(none);
			}
			else
			{
				YourRankButtonCallback(none);
			}

			// Get total number of players that have completed a challenge
			//TacticalChallengeModeManager = `TACTICALGRI.ChallengeModeManager;
			//m_TotalPlayerCount = TacticalChallengeModeManager.m_CurrentTotalTurnEventMap[ECME_CompletedMission] + TacticalChallengeModeManager.m_CurrentTotalTurnEventMap[ECME_FailedMission];
			return true;
		}
	}
	return false;
}

function FetchDeactivatedIntervals()
{
	local TProgressDialogData kDialogBoxData;

	`log(`location);
	m_NavHelp.ClearButtonHelp();
	kDialogBoxData.strTitle = class'X2MPData_Shell'.default.m_strMPFetchingLeaderboardsProgressDialogTitle;
	kDialogBoxData.strDescription = class'X2MPData_Shell'.default.m_strMPFetchingLeaderboardsProgressDialogText;
	kDialogBoxData.fnCallback = CloseScreen;

	Movie.Pres.UIProgressDialog(kDialogBoxData);

	SetTimer(1.5f, false, nameof(InternalGetDeactivatedIntervals));
	SetTimer(8.5f, false, nameof(GetDeactivatedIntervalTimeout));
}

private function InternalGetDeactivatedIntervals()
{
	if (!ChallengeModeInterface.PerformChallengeModeGetDeactivatedIntervals())
	{
		SetTimer(1.5f, false, nameof(InternalGetDeactivatedIntervals));
	}
	else
	{
		ClearTimer(nameof(GetDeactivatedIntervalTimeout));
	}
}

private function GetDeactivatedIntervalTimeout()
{
	local TDialogueBoxData kDialogueData;

	// No longer attempting to fetch deactivated intervals
	ClearTimer(nameof(InternalGetDeactivatedIntervals));
	Movie.Pres.UICloseProgressDialog();


	// Display error message
	kDialogueData.strTitle = class'X2MPData_Shell'.default.m_strChallengeUnplayableDialogTitle;
	kDialogueData.strText = class'X2MPData_Shell'.default.m_strChallengeUnplayableTimedoutDialogText;
	kDialogueData.eType = eDialog_Warning;
	kDialogueData.strAccept = class'UIUtilities_Text'.default.m_strGenericOK;

	Movie.Pres.UIRaiseDialog(kDialogueData);

}

private function int SortChallengeDeactivatedIntervals(IntervalInfo A, IntervalInfo B)
{
	// Reverse sort
	if (A.IntervalName > B.IntervalName)
		return 1;
	if (A.IntervalName < B.IntervalName)
		return -1;
	return 0;
}

function OnReceivedChallengeModeDeactivatedIntervalStart(int NumIntervals)
{
	`log(`location @ `ShowVar(NumIntervals));
	m_iIncomingIntervalCount = NumIntervals;
	m_arrIntervals.Length = 0;
	m_bUpdatingIntervalData = true;
}

function OnReceivedChallengeModeDeactivatedIntervalEnd()
{
	`log(`location);


	if (m_arrIntervals.Length > 0)
	{
		// Must have the intervals for the names prior to getting any leaderboard entries
		m_bGetPlayerGameSave = false;
		if (!GetCurrentIntervalFromTacticalGame())
		{
			// The default gamestate is not loaded, load the player's game save
			m_bGetPlayerGameSave = true;
			GetCurrentIntervalFromUIChallengeMode_SquadSelect();
		}
		else
		{
			// Prefetch the friend's list
			ASyncReadFriendList(OnFriendFetchComplete, m_LeaderboardOffset, m_LeaderboardLimit);
		}
		m_CurrentLeaderboardIndex = m_arrIntervals.length -1;

		// Initialize the player entry item to this interval.
		m_plrLeaderboardEntry.UpdateData(m_plrEntry);
		UpdateListItem(m_plrLeaderboardEntry);

		m_bUpdatingIntervalData = false;

		// Populate the leaderboard
		YourRankButtonCallback(none);
	}
	else
	{
		// Probably not connected to Firaxis Live ...
		Movie.Pres.UICloseProgressDialog();
		DisplayNoIntervalsDialog();
	}
}

function OnReceivedChallengeModeDeactivatedIntervalEntry(qword IntervalSeedID, int ExpirationDate, int TimeLength, EChallengeStateType IntervalState, string IntervalName)
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
}


function OnRequestUserInformationComplete(bool bWasSuccessful, UniqueNetId PlatformID, string PlayerName)
{
	local int Index;
	local TLeaderboardEntry ItemEntry;
	local UIChallengeLeaderboard_ListItem ListItem;
	`log(`location @ `ShowVar(m_OnlineSub.UniqueNetIdToString(PlatformID), PlatformID) @ `ShowVar(PlayerName));

	// Update the local player information
	if (PlatformID == m_LocalPlayerID)
	{
		m_plrEntry.strPlayerName = PlayerName;
		SetPlayerRow(m_plrEntry);
	}

	// Lookup the PlatformID in the current data
	Index = FindLeaderboardIndex(PlatformID, true /*bSearchByPlatformID*/);
	if (Index != -1)
	{
		// Update the leaderboard entry
		m_LeaderboardsData[Index].strPlayerName = PlayerName;
		ItemEntry = m_LeaderboardsData[Index];
		ListItem = UIChallengeLeaderboard_ListItem(m_kList.GetItem(Index));
		ListItem.UpdateData(ItemEntry);
	}
}

function OnLeaderBoardFetchComplete(const out TLeaderboardsData kLeaderboardsData)
{
	`log(`location @ "Skipping");
}

function CompleteLeaderboardFetch(EMPLeaderboardType LeaderboardType)
{
	`log(`location @ `ShowEnum(EMPLeaderboardType, LeaderboardType, LeaderboardType));
	switch (LeaderboardType)
	{
	case eMPLeaderboard_YourRank:
		TopPlayersButtonCallback(none); // Follow-up the Your Rank call with a full player list, and don't pull down the dialog
		break;
	case eMPLeaderboard_TopPlayers:
	case eMPLeaderboard_Friends:
		UpdateData();
		Movie.Pres.UICloseProgressDialog();
		UpdateNavHelp();
		SetTimer(0.2f, false, nameof(DelayedRefreshListItemChanged)); //bsg-jneal (5.9.17): refresh data to override label text for button image injection
		if (m_bDisplayNoChallengeDataOnInit)
		{
			m_bDisplayNoChallengeDataOnInit = false;
			DisplayNoChallengeDialog();
		}
		if (!m_bFoundLocalPlayerLeaderboardData)
		{
			UpdateDataFromTempData();
		}
		break;
	}
}

//bsg-jneal (5.9.17): delaying refresh data to override label text for button image injection, this is necesary because list items do not have their states set initially
function DelayedRefreshListItemChanged()
{
	OnListReplayChanged(none, 0);
}
//bsg-jneal (5.9.17): refresh data to override label text for button image injection

function OnReceivedChallengeModeLeaderboardStart(int NumEntries, qword IntervalSeedID)
{
	`log(`location @ `ShowVar(NumEntries) @ QWordToString(IntervalSeedID), , 'XCom_Online');
	m_bUpdatingLeaderboardData = true;
}

function OnReceivedChallengeModeLeaderboardEnd(qword IntervalSeedID)
{
	local EMPLeaderboardType RequestType;

	RequestType = m_arrLeaderboardRequestQueue[0];
	`log(`location @ QWordToString(IntervalSeedID) @ `ShowEnum(EMPLeaderboardType, RequestType, RequestType), , 'XCom_Online');
	m_bUpdatingLeaderboardData = false;

	m_arrLeaderboardRequestQueue.Remove(0, 1); // Remove the first entry
	if (m_arrLeaderboardRequestQueue.Length == 0)
	{
		CompleteLeaderboardFetch(RequestType);
	}
	else if (m_bSequenceRequests)
	{
		// Skip all of the extra fetch / queue logic
		while (!InternalFetchLeaderboardData(m_arrLeaderboardRequestQueue[0]))
		{
			m_arrLeaderboardRequestQueue.Remove(0, 1); // Remove the first entry
			if (m_arrLeaderboardRequestQueue.Length == 0)
			{
				CompleteLeaderboardFetch(RequestType);
				break;
			}
		}
	}
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
	local int TopPercentile;

	`log(`location @ `ShowVar(m_OnlineSub.UniqueNetIdToString(Entry.PlatformID), PlatformID) @ `ShowVar(m_OnlineSub.UniqueNetIdToString(Entry.PlayerID), PlayerID)
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

	m_TotalPlayerCount = 15;
	TopPercentile = (float(m_TotalPlayerCount - Entry.Rank) / float(m_TotalPlayerCount)) * 100.0;
	//TopPercentile = 100.0 - ((float(Entry.Rank) / float(m_TotalPlayerCount)) * 100.0);
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
		`log(`location @ "Got an entry for the local player");

		bLocalStartedMission = true;
		m_plrEntry = NewEntry;
		m_plrLeaderboardEntry.m_IntervalID = m_arrIntervals[m_CurrentLeaderboardIndex].IntervalSeedID;
		SetPlayerRow(m_plrEntry);
		SetScoreBreakdown( string(NewEntry.SoldiersAlive), string(NewEntry.KilledEnemies), string(NewEntry.CompletedObjectives), string(NewEntry.CiviliansSaved), string(NewEntry.TimeBonus), string(NewEntry.UninjuredSoldiers));
		m_plrLeaderboardEntry.UpdateData(m_plrEntry);
		UpdateListItem(m_plrLeaderboardEntry);
		m_bFoundLocalPlayerLeaderboardData = true;
	}

	if (Index != -1)
	{
		m_LeaderboardsData[Index] = NewEntry;
		if (len(m_LeaderboardsData[Index].strPlayerName) == 0)
		{
			if (!m_OnlineSub.PlayerInterface.RequestUserInformation(`ONLINEEVENTMGR.LocalUserIndex, Entry.PlatformID))
			{
				`RedScreen("Unable to lookup username for PlatformID: " $ m_OnlineSub.UniqueNetIdToString(Entry.PlatformID));
			}
		}
		`log(`location @ "Setting Leaderboard Entry(" $ Index $ ")" @ `ShowVar(m_LeaderboardsData[Index].strPlayerName, PlayerName) @ `ShowVar(m_LeaderboardsData[Index].iScore, GameScore));

		if (!m_bUpdatingLeaderboardData)
		{
			UpdateData();
		}
	}
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
	local array<string> PlayerIDs;
	m_FriendFetch.bSuccess = true;

	`log(`location @ `ShowVar(m_FriendFetch.Offset, Offset) @ `ShowVar(m_FriendFetch.Limit, Limit) @ `ShowVar(GetLeaderboardName(), IntervalName));
	if (GetFriendIDs(PlayerIDs, m_FriendFetch.Offset, m_FriendFetch.Limit))
	{
		//AddPlayerIDForLeaderboardPlayerList(PlayerIDs);
		if (PlayerIDs.length <= 0)
		{
			m_FriendFetch.bSuccess = false;
			// Failed to launch ...
			UpdateData();
			Movie.Pres.UICloseProgressDialog();
			UpdateNavHelp();
		}
		else
		{
			Movie.Pres.UICloseProgressDialog();
			ChallengeModeInterface.PerformChallengeModeGetGameScoresFriends(GetLeaderboardName(), PlayerIDs);
		}
	}
}

function bool PerformGetGameScoreFriends(optional delegate<FriendFetchComplete> OnFriendFetchCompleteDelegate = OnFriendFetchComplete, optional int Offset = 0, optional int Limit = 14)
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
	return m_FriendFetch.bComplete && m_FriendFetch.Offset == Offset && m_FriendFetch.Limit == Limit && m_friendFetch.bSuccess;
}

function bool ASyncReadFriendList(delegate<FriendFetchComplete> OnFriendFetchCompleteDelegate, optional int Offset = 0, optional int Limit = 14)
{
	`log(`location @ `ShowVar(OnFriendFetchCompleteDelegate) @ `ShowVar(Offset) @ `ShowVar(Limit));
	m_FriendFetch.bFetchingFriends = true;
	m_FriendFetch.bComplete = false;
	m_FriendFetch.Offset = Offset;
	m_FriendFetch.Limit = Limit;
	m_FriendFetch.OnComplete = OnFriendFetchCompleteDelegate;

	return m_OnlineSub.PlayerInterface.ReadFriendsList(`ONLINEEVENTMGR.LocalUserIndex, Limit, Offset);
}

// Must call ASyncReadFriendList prior to getting the list
function bool GetFriendIDs(out array<string> PlayerIDs, optional int Offset = 0, optional int Limit = 14)
{
	local array<OnlineFriend> Friends;
	local EOnlineEnumerationReadState ReadState;
	local int FriendIdx;

	`log(`location @ `ShowVar(Offset) @ `ShowVar(Limit));

	if (IsFriendFetchComplete(Offset, Limit))
	{
		ReadState = m_OnlineSub.PlayerInterface.GetFriendsList(`ONLINEEVENTMGR.LocalUserIndex, Friends, Limit, Offset);
		if (ReadState == OERS_Done)
		{
			PlayerIDs.Length = 0;
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

public function FriendRanksButtonCallback(UIButton button)
{
	`log(self $ "::" $ GetFuncName(), , 'uixcom_mp');

	if (m_kMPShellManager.m_bLeaderboardsFriendsDataLoaded)
	{
		OnLeaderBoardFetchComplete(m_kMpShellManager.m_tLeaderboardsFriendsData);
	}
	else
	{
		m_LeaderboardOffset = 0;
		
		FetchLeaderboardData(eMPLeaderboard_Friends);
	}
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
// 		HELPER FUNCTIONALITY:
//==============================================================================
function SetOverrideName(string OverrideName)
{
	`log(`location @ `ShowVar(m_OverrideLeaderboardName) @ `ShowVar(OverrideName) @ `ShowVar(m_arrIntervals[m_CurrentLeaderboardIndex].IntervalName) @ `ShowEnum(EMPLeaderboardType, m_eLeaderboardType, m_eLeaderboardType));
	m_OverrideLeaderboardName = OverrideName;
	FetchLeaderboardData(m_eLeaderboardType);
}

function string GetLeaderboardName()
{
	if (m_OverrideLeaderboardName != "")
		return m_OverrideLeaderboardName;

	return m_arrIntervals[m_CurrentLeaderboardIndex].IntervalName;
}

function qword GetQWordDifference(qword LeftHand, qword RightHand)
{
	local qword Diff;
	Diff.A = LeftHand.A - RightHand.A;
	Diff.B = LeftHand.B - RightHand.B;
	// Check for the carry
	if (Diff.B > LeftHand.B)
		--Diff.A;
	return Diff;
}

function string QWordToString(qword Number)
{
	local UniqueNetId NetId;

	NetId.Uid.A = Number.A;
	NetId.Uid.B = Number.B;

	return m_OnlineSub.UniqueNetIdToString(NetId);
}

function qword StringToQWord(string Text)
{
	local UniqueNetId NetId;
	local qword Number;

	m_OnlineSub.StringToUniqueNetId(Text, NetId);

	Number.A = NetId.Uid.A;
	Number.B = NetId.Uid.B;

	return Number;
}


//==============================================================================
// 		CLEANUP
//==============================================================================
delegate OnCloseScreen();
simulated function CloseScreen()
{
	super.CloseScreen();
	OnCloseScreen();
}

simulated event OnCleanupWorld()
{
	Cleanup();
}

function Cleanup()
{
	local byte LocalUserNum;
	LocalUserNum = `ONLINEEVENTMGR.LocalUserIndex;

	m_OnlineSub.PlayerInterface.ClearRequestUserInformationCompleteDelegate(OnRequestUserInformationComplete);
	m_OnlineSub.PlayerInterface.ClearFriendsChangeDelegate(LocalUserNum, OnFriendsChange);
	m_OnlineSub.PlayerInterface.ClearReadFriendsCompleteDelegate(LocalUserNum, OnReadFriendsComplete);

	ChallengeModeInterface.ClearReceivedChallengeModeLeaderboardStartDelegate(OnReceivedChallengeModeLeaderboardStart);
	ChallengeModeInterface.ClearReceivedChallengeModeLeaderboardEndDelegate(OnReceivedChallengeModeLeaderboardEnd);
	ChallengeModeInterface.ClearReceivedChallengeModeLeaderboardEntryDelegate(OnReceivedChallengeModeLeaderboardEntry);
	ChallengeModeInterface.ClearReceivedChallengeModeDeactivatedIntervalStartDelegate(OnReceivedChallengeModeDeactivatedIntervalStart);
	ChallengeModeInterface.ClearReceivedChallengeModeDeactivatedIntervalEndDelegate(OnReceivedChallengeModeDeactivatedIntervalEnd);
	ChallengeModeInterface.ClearReceivedChallengeModeDeactivatedIntervalEntryDelegate(OnReceivedChallengeModeDeactivatedIntervalEntry);

	m_kMPShellManager.ClearLeaderboardFetchCompleteDelegate(OnLeaderBoardFetchComplete);
	m_kMPShellManager.CancelLeaderboardsFetch();
	if( `ISCONTROLLERACTIVE ) m_NavHelp.SetCenterHelpPaddingValue(m_NavHelp.CENTER_HELP_CONTAINER_PADDING);
}

defaultproperties
{
	m_iTopPlayersRank=1;
	m_eLeaderboardType = eMPLeaderboard_Friends;
	m_bMyRankTop=true;
	Package   = "/ package/gfxFacilitySummary/FacilitySummary";
	LibID = "ChallengeLeaderboardScreen";
	InputState = eInputState_Consume;

	bLocalStartedMission = false;
	m_CurrentLeaderboardIndex=-1
	m_bFoundLocalPlayerLeaderboardData=false
	m_bSequenceRequests=true
	m_LeaderboardOffset=0
	m_LeaderboardLimit = 10
	m_bDisplayNoChallengeDataOnInit=false
}