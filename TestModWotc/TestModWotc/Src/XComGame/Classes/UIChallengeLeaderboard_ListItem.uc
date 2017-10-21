class UIChallengeLeaderboard_ListItem extends UILeaderboard_ListItem;

var array<byte> PlayerGameData;
var TLeaderboardEntry m_LeaderboardEntry;

var private X2ChallengeModeInterface    ChallengeModeInterface;
var localized string m_replayNotAvailable;
var localized string m_replayNotAvailableTooltip;
var localized string m_downloadWatchReplay;
var localized string m_downloadingReplay;
var localized string m_loadDownloadedReplay;
var localized string m_loadingReplay;
var string m_currentStatus;
var qword m_IntervalID;
var UniqueNetId m_LocalPlayerID;
var string m_LeaderboardName;


simulated function UIChallengeLeaderboard_ListItem InitChallengeListItem(qword IntervalID, optional name InitName, optional name InitLibID)
{
	SubscribeToOnCleanupWorld();

	ChallengeModeInterface = `CHALLENGEMODE_INTERFACE;
	m_IntervalID = IntervalID;

	Class'GameEngine'.static.GetOnlineSubsystem().PlayerInterface.GetUniquePlayerId(`ONLINEEVENTMGR.LocalUserIndex, m_LocalPlayerID);

	InitPanel(InitName, InitLibID);

	
	return self;
}

function SetLeaderboardName(string LeaderboardName)
{
	m_LeaderboardName = LeaderboardName;
}

function SetPlayerGameData(array<byte> NewPlayerGameData)
{
	PlayerGameData = NewPlayerGameData;
	GotoState('ReplayCanceled');
}

function PerformReplayStateAction()
{
}

function ReceivedGameData()
{
	m_currentStatus = m_loadDownloadedReplay;
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
	kConfirmData.strTitle = m_replayNotAvailable; // class'X2MPData_Shell'.default.m_strChallengeNoActiveChallengeDialogTitle;
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
	local XComGameState_ChallengeData ChallengeData;
	local XComGameStateHistory History;

	m_currentStatus = m_loadingReplay;
	`ONLINEEVENTMGR.bInitiateReplayAfterLoad = true;
	`ONLINEEVENTMGR.m_sReplayUserID = m_LeaderboardEntry.strPlayerName;
	// Load up the Replay ...
	History = `XCOMHISTORY;
	BattleData = XComGameState_BattleData(History.GetSingleGameStateObjectForClass(class'XComGameState_BattleData'));
	ChallengeData = XComGameState_ChallengeData(History.GetSingleGameStateObjectForClass(class'XComGameState_ChallengeData'));
	ChallengeData.LeaderBoardName = m_LeaderboardName;

	`ONLINEEVENTMGR.m_sLastReplayMapCommand = BattleData.m_strMapCommand $ "?LoadingSave" $ "?ReplayID=" $ QWordToString(m_IntervalID);
	ConsoleCommand(`ONLINEEVENTMGR.m_sLastReplayMapCommand);
}

function CancelPlayReplay()
{
	Movie.Pres.UICloseProgressDialog();
	GotoState('ReplayCanceled');
}

function EnableDownloadReplay()
{
	GotoState('ReplayNotLoaded');
}

function DisableDownloadReplay()
{
	GotoState('ReplayUnavailable');
}

auto state ReplayUnavailable
{
Begin:
	m_currentStatus = m_replayNotAvailable;
	RefreshChallengeData();
}

state ReplayNotLoaded
{
	function PerformReplayStateAction()
	{
		if (PerformChallengeModeGetGameSave())
		{
			GotoState('ReplayDownloading');
		}
		else
		{
			PlaySound(SoundCue'SoundUI.NegativeSelection2Cue', true);
			`RedScreen("Error, cannot retrieve the challenge replay from the server. Try again in a few seconds. @ttalley");
		}
	}
Begin:
	m_currentStatus = m_downloadWatchReplay;
	RefreshChallengeData();
}

state ReplayDownloading
{
	function PerformReplayStateAction()
	{
		PlaySound(SoundCue'SoundUI.NegativeSelection2Cue', true);
	}

	function ReceivedGameData()
	{
		m_currentStatus = m_loadDownloadedReplay;
		LoadGameData();
	}

Begin:
	m_currentStatus = m_downloadingReplay;
	RefreshChallengeData();
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

	function ReceivedGameData()
	{
		m_currentStatus = m_loadDownloadedReplay;
	}


Begin:
	if (PlayerGameData.Length > 0)
	{
		m_currentStatus = m_loadDownloadedReplay;
	}
	else
	{
		m_currentStatus = m_downloadWatchReplay;
	}
	RefreshChallengeData();
}


/*
var string strPlayerName;
var int iRank;
var int iWins;
var int iLosses;
var int iDisconnects;
var int iScore;
var int iTime;
var UniqueNetId playerID;
*/

simulated function OnMouseEvent(int cmd, array<string> args)
{
	`log(`location @ `ShowVar(cmd) @ args[args.length - 2]);
	if (cmd == class'UIUtilities_Input'.const.FXS_L_MOUSE_UP && args[args.length - 2] == "replayButton")
	{
		StartChallengeReplayDownload(); //bsg-jneal (5.9.17): stub out replay download for access by controller
	}
	else if (cmd == class'UIUtilities_Input'.const.FXS_L_MOUSE_IN)
	{
		UIChallengeLeaderboards(`SCREENSTACK.GetFirstInstanceOf(class'UIChallengeLeaderboards')).CompareEntries(m_Entry);
	}
	else if (cmd == class'UIUtilities_Input'.const.FXS_L_MOUSE_OUT || cmd == class'UIUtilities_Input'.const.FXS_L_MOUSE_DRAG_OUT)
	{
		UIChallengeLeaderboards(`SCREENSTACK.GetFirstInstanceOf(class'UIChallengeLeaderboards')).CloseComparisson();
	}
}

//bsg-jneal (5.9.17): stub out replay download for access by controller
function StartChallengeReplayDownload()
{
	ChallengeModeInterface.AddReceivedChallengeModeGetGameSaveDelegate(OnReceivedChallengeModeGetGameSave);
	PerformReplayStateAction();
}
//bsg-jneal (5.9.17): end

function string GetMinutesSecondsTime(int TimeInSeconds)
{
	local int min, sec;
	local string time;
	min = TimeInSeconds / 60;
	sec = TimeInSeconds % 60;
	time $= min;
	time $= ":" $ (sec < 10) ? "0" $ sec : "" $ sec;
	return time;
}

simulated function UpdateData(const out TLeaderboardEntry entry)
{
	local bool bIsPlayer;
	m_LeaderboardEntry = entry;
	m_Entry = entry;

	bIsPlayer = entry.PlatformID == m_LocalPlayerID;

	`log(`location @ `ShowVar(QWordToString(m_IntervalID), m_IntervalID) @ `ShowVar(QWordToString(m_Entry.PlayerID.Uid), PlayerID) @ `ShowVar(QWordToString(m_Entry.PlatformID.Uid), PlatformID) @ `ShowVar(bIsPlayer) @ `ShowVar(m_Entry.iRank) @ `ShowVar(m_Entry.strPlayerName) @ `ShowVar(m_Entry.iScore) @ `ShowVar(m_Entry.iTime));
	SetChallengeData(bIsPlayer, string(m_Entry.iRank), m_Entry.strPlayerName, string(m_Entry.iScore), GetMinutesSecondsTime(m_Entry.iTime), m_currentStatus, string(m_Entry.iPercentile));

	if (entry.iRank > 0 && (m_IntervalID.A != 0 || m_IntervalID.B != 0))
	{
		EnableDownloadReplay();
	}
	else
	{
		DisableDownloadReplay();
	}
}

//bsg-jneal (5.9.17): refresh data to override label text for button image injection
function RefreshChallengeData(optional string statusOverride)
{
	SetChallengeData(m_Entry.PlatformID == m_LocalPlayerID, string(m_Entry.iRank), m_Entry.strPlayerName, string(m_Entry.iScore), GetMinutesSecondsTime(m_Entry.iTime), statusOverride != "" ? statusOverride $"</img>" : m_currentStatus, string(m_Entry.iPercentile));
}
//bsg-jneal (5.9.17): end

function SetChallengeData(bool bIsPlayer, string Rank, string playerName, string Score, string Time, string Replay, string TopPercentile)
{
	mc.BeginFunctionOp("setData");
	mc.QueueBoolean(bIsPlayer);
	if( bIsPlayer )
	{
		mc.QueueString(Rank @ "(" $ TopPercentile $"%)");
	}
	else
	{
		mc.QueueString(Rank);
	}
	mc.QueueString(playerName);
	mc.QueueString(Score);
	mc.QueueString(Time);
	mc.QueueString(Replay);
	mc.EndOp();
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
function bool PerformChallengeModeGetGameSave()
{
	local bool bSuccess;
	local TProgressDialogData kDialogBoxData;

	`log(`location @ `ShowVar(QWordToString(m_LeaderboardEntry.playerID.Uid), PlayerID) @ `ShowVar(QWordToString(m_IntervalID), m_IntervalID));

	bSuccess = ChallengeModeInterface.PerformChallengeModeGetGameSave(m_LeaderboardEntry.playerID, m_IntervalID);
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
	`log(`location 
		@ `ShowVar(Class'GameEngine'.static.GetOnlineSubsystem().UniqueNetIdToString(m_LeaderboardEntry.playerID), m_LeaderboardEntry)
		@ `ShowVar(Class'GameEngine'.static.GetOnlineSubsystem().UniqueNetIdToString(PlayerID), PlayerID) @ `ShowVar(PlayerName)
		@ `ShowVar(PlayerName) @ QWordToString(IntervalSeedID) @ `ShowVar(LevelSeed) @ `ShowVar(PlayerSeed) @ `ShowVar(TimeLimit) @ `ShowVar(GameScore), , 'XCom_Online');

	if (PlayerID != m_LeaderboardEntry.playerID)
		return;

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

function string QWordToString(qword Number)
{
	local UniqueNetId NetId;

	NetId.Uid.A = Number.A;
	NetId.Uid.B = Number.B;

	return Class'GameEngine'.static.GetOnlineSubsystem().UniqueNetIdToString(NetId);
}

//bsg-jneal (5.9.17): on receive and lose focus for use with gamepad to properly highlight list items
simulated function OnReceiveFocus()
{
	super.OnReceiveFocus();

	if(`ISCONTROLLERACTIVE)
	{
		MC.FunctionVoid("realizeButtonFocus");
	}
}

simulated function OnLoseFocus()
{
	super.OnLoseFocus();
	
	if(`ISCONTROLLERACTIVE)
	{
		MC.FunctionVoid("realizeButtonFocus");
	}
}
//bsg-jneal (5.9.17): end

/**
* Called when the world is being cleaned up. Allows the actor to free any dynamic content it has created.
*/
simulated event OnCleanupWorld()
{
	Cleanup();
}

function Cleanup()
{
	ChallengeModeInterface.ClearReceivedChallengeModeGetGameSaveDelegate(OnReceivedChallengeModeGetGameSave);
}

defaultproperties
{
	LibID = "ChallengeLeaderboardListItem";

	m_currentStatus = "";

	width = 1265;
	height = 43;
}