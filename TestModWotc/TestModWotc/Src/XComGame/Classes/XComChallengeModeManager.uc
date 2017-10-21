//---------------------------------------------------------------------------------------
//  FILE:    XComChallengeModeManager.uc
//  AUTHOR:  Timothy Talley  --  02/16/2015
//  PURPOSE: Manages the System Interface and any necessary persistent data.
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class XComChallengeModeManager extends Object
	dependson(X2ChallengeModeDataStructures, XComGameState_ChallengeScore)
	config(ChallengeData)
	native(Challenge);

var config bool bUseMCP;

var config ChallengeMissionScoring DefaultChallengeMissionScoring;
var config array<ChallengeMissionScoring> DefaultChallengeMissionScoringTable;
var config ChallengeObjectiveScoring DefaultChallengeObjectiveScoring;
var config array<ChallengeObjectiveScoring> DefaultChallengeObjectiveScoringTable;
var config ChallengeEnemyScoring DefaultChallengeEnemyScoring;
var config array<ChallengeEnemyScoring> DefaultChallengeEnemyScoringTable;
var config ChallengeSoldierScoring DefaultChallengeSoldierScoring;
var config ChallengeTimeScoring DefaultChallengeTimeScoring;

var private ChallengeScoring OverrideScoringTable; 
var private array<ChallengeModeData> Challenges;
var private int SelectedChallengeIndex;

var private X2ChallengeModeInterface SystemInterface;
var private bool bShouldSubmitGameState;
var private int ChallengeScore;
var private int FinalChallengeScore;
var private LeaderboardScoreData TempScoreData; // Hold the data from the last played Challenge, while the server is processing

native final function ClearChallengeData();

cpptext
{
	void Init();
	INT FindOrAddChallenge(INT PlayerSeed);
	INT AddChallengeData(INT DataIndex, void* Data, INT DataLenth, INT TimeLimit, INT PlayerSeed);
	void SetScoringTable(INT DataIndex, const struct FChallengeScoring& NewScoringTable);
	void SetScoringTable(INT DataIndex, const char* ChallengeScoringData);
	void SetOverrideScoringTable(const struct FChallengeScoring& NewScoringTable);
	void SetOverrideScoringTable(const char* ChallengeScoringData);
	void ParseScoringXML(const char* ChallengeScoringData, struct FChallengeScoring& NewScoringTable);
	TArrayNoInit<BYTE>& GetChallengeStartData(INT ChallengeIndex);
}

event Init()
{
	`log(`location @ `ShowVar(bUseMCP));
	if (SystemInterface == none)
	{
		if (bUseMCP)
		{
			SystemInterface = `XENGINE.MCPManager;
		}
		else
		{
			SystemInterface = `FXSLIVE;
		}
	}
	`log(`location @ "Using Interface:" @ `ShowVar(SystemInterface));
}

function ResetChallengeScore()
{
	ChallengeScore = 0;
}

function int GetChallengeScore()
{
	return ChallengeScore;
}

function bool ShouldSubmitGameState()
{
	return bShouldSubmitGameState;
}

function X2ChallengeModeInterface GetSystemInterface()
{
	if (SystemInterface == none)
	{
		Init();
	}
	return SystemInterface;
}

function SetSystemInterface(X2ChallengeModeInterface Interface)
{
	SystemInterface = Interface;
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

function bool CheckAvailableConnectionOrOpenErrorDialog()
{
	if (!SystemInterface.IsConnected())
	{
		DisplayConnectionError();
		return false;
	}
	else if (SystemInterface.HasDeclinedUserEULAs())
	{
		DisplayDeclinedEULA();
		return false;
	}
	// As of CL 284636 you no longer need to be linked to access challenge mode
	//else if (SystemInterface.RequiresSystemLogin())
	//{
	//	DisplayRequiresSystemLogin();
	//	return false;
	//}
	return true;
}

function OpenChallengeModeUI()
{
	if (CheckAvailableConnectionOrOpenErrorDialog())
	{
		OpenIntervalUI();
	}
}

function DisplayRequiresSystemLogin()
{
	local TDialogueBoxData kDialogBoxData;

	`log(`location);

	kDialogBoxData.strTitle = class'UIFiraxisLiveLogin'.default.m_LinkedAccountRequiredTitle;
	kDialogBoxData.strText = class'UIFiraxisLiveLogin'.default.m_LinkedAccountRequiredMessage;
	kDialogBoxData.strAccept = class'UIUtilities_Text'.default.m_strGenericOK;
	kDialogBoxData.eType = eDialog_Warning;

	`PRESBASE.UIRaiseDialog(kDialogBoxData);
}

function DisplayConnectionError()
{
	local TDialogueBoxData kDialogBoxData;

	`log(`location);

	kDialogBoxData.strTitle = class'X2MPData_Shell'.default.m_strFiraxisLiveNoConnectionDialog_Default_Title;
	kDialogBoxData.strText = class'X2MPData_Shell'.default.m_strFiraxisLiveNoConnectionDialog_Default_Text;
	kDialogBoxData.strAccept = class'UIUtilities_Text'.default.m_strGenericOK;
	kDialogBoxData.eType = eDialog_Warning;

	`PRESBASE.UIRaiseDialog(kDialogBoxData);
}

function DisplayDeclinedEULA()
{
	local TDialogueBoxData kDialogBoxData;

	`log(`location);

	kDialogBoxData.strTitle = class'UIFiraxisLiveLogin'.default.m_DeclineEULATitle;
	kDialogBoxData.strText = class'UIFiraxisLiveLogin'.default.m_DeclineEULABody;
	kDialogBoxData.strAccept = class'UIUtilities_Text'.default.m_strGenericOK;
	kDialogBoxData.eType = eDialog_Warning;
	kDialogBoxData.fnCallback = UIActionCallback_DisplayDeclinedEULA;

	`PRESBASE.UIRaiseDialog(kDialogBoxData);
}

function UIActionCallback_DisplayDeclinedEULA(Name eAction)
{
	// Open the EULA UI
	SystemInterface.OpenUserEULAs();
}

function OpenLoginUI()
{
	local string LoginUIClassName;
	local UILoginScreen Screen;
	LoginUIClassName = SystemInterface.GetSystemLoginUIClassName();
	Screen = UILoginScreen(GetPresBase().LoadGenericScreenFromName(LoginUIClassName));
	Screen.OnClosedDelegate = LoginUIClosed;
}

function LoginUIClosed(bool bLoginSuccessful)
{
	if (bLoginSuccessful)
	{
		OpenIntervalUI();
	}
}

function UIScreen OpenDebugUI()
{
	return GetPresBase().UIDebugChallengeMode();
}

function UIScreen OpenIntervalUI()
{
	if( SystemInterface.IsDebugMenuEnabled() )
	{
		return OpenDebugUI();
	}
	return OpenSqadSelectUI();
}

function UIScreen OpenSqadSelectUI()
{
	return GetPresBase().UIChallengeMode_SquadSelect();
}

function SetSelectedChallengeIndex(int Index)
{
	SelectedChallengeIndex = Index;
}

function int GetSelectedChallengeTimeLimit()
{
	if(SelectedChallengeIndex >= 0 && SelectedChallengeIndex < Challenges.Length)
	{
		return Challenges[SelectedChallengeIndex].TimeLimit;
	}
	else
	{
		`warn(self $ "::" $ GetFuncName() @ "SelectedChallengeIndex is out of bounds (" $ SelectedChallengeIndex $ "). Returning -1");
`if(`notdefined(FINAL_RELEASE))
		return MaxInt;
`else
		return -1;
`endif
	}
}

function int FindChallengeIndex(int PlayerSeedId)
{
	local int Idx;
	`log(`location @ `ShowVar(PlayerSeedId),,'FiraxisLive');
	for( Idx = 0; Idx < Challenges.Length; ++Idx )
	{
		`log(`location @ `ShowVar(Challenges[Idx].PlayerSeed) @ "==" @ `ShowVar(PlayerSeedId),,'FiraxisLive');
		if( Challenges[Idx].PlayerSeed == PlayerSeedId )
		{
			return Idx;
		}
	}
	return -1;
}

function GetTempScoreData(out LeaderboardScoreData TempLeaderboardScore)
{
	TempLeaderboardScore = TempScoreData;
}
function SetTempScoreData(XComGameStateHistory ChallengeHistory)
{
	local XComGameState_ChallengeData ChallengeStateData;
	local XComGameState_ChallengeScore ChallengeScoreObj;
	local int EntryIdx;

	ChallengeStateData = XComGameState_ChallengeData(ChallengeHistory.GetSingleGameStateObjectForClass(class'XComGameState_ChallengeData', true));
	if (ChallengeStateData != none)
	{
		TempScoreData.IntervalSeedID = ChallengeStateData.SeedData.IntervalSeedID;
		TempScoreData.GameScore = ChallengeStateData.SeedData.GameScore;
		TempScoreData.TimeCompleted = ChallengeStateData.SeedData.VerifiedCount;
		`log(`location @ `ShowVar(TempScoreData.GameScore, GameScore) @ `ShowVar(TempScoreData.TimeCompleted, TimeCompleted));
	}

	// Score Entries
	TempScoreData.ScoreEntries.Length = 0;
	foreach ChallengeHistory.IterateByClassType(class'XComGameState_ChallengeScore', ChallengeScoreObj)
	{
		`log(`location @ `ShowEnum(ChallengeModePointType, ChallengeScoreObj.ScoringType, ScoringType) @ `ShowVar(ChallengeScoreObj.AddedPoints, AddedPoints));
		EntryIdx = TempScoreData.ScoreEntries.Add(1);
		TempScoreData.ScoreEntries[EntryIdx].ScoreType = ChallengeScoreObj.ScoringType;
		TempScoreData.ScoreEntries[EntryIdx].MaxPossible = ChallengeScoreObj.AddedPoints;
	}
}

final native function BootstrapDebugChallenge( );

final native function GetMissionScoring(out ChallengeMissionScoring MissionScoring, string MissionType, optional int ChallengeIdx = -1);
final native function GetObjectiveScoring(out ChallengeObjectiveScoring ObjectiveScoring, string MissionType = "", int TextPoolIndex = -1, int GroupID = -1, int LineIndex = -1, optional int ChallengeIdx = -1);
final native function GetMissionTypeObjectiveScoring(out array<ChallengeObjectiveScoring> MissionTypeObjectiveScoring, string MissionType = "", optional int ChallengeIdx = -1);
final native function GetEnemyScoring(out ChallengeEnemyScoring EnemyScoring, string CharacterTemplateName, optional int ChallengeIdx = -1);
final native function GetSoldierScoring(out ChallengeSoldierScoring SoldierScoring, optional int ChallengeIdx = -1);
final native function GetTimeScoring(out ChallengeTimeScoring TimeScoring, optional int ChallengeIdx = -1);
final native function int GetTotalScore();
final native function int GetTotalScoreFromHistory(XComGameStateHistory ChallengeHistory);
final native function int GetMaxChallengeScore(optional int ChallengeIdx = -1);
final native function int GetMaxChallengeScoreFromHistory(XComGameStateHistory History);
final native function int GetChallengeMaxPossibleScoreTable(out array<ScoreTableEntry> ScoreTable, optional int ChallengeIdx = -1);
final native function int GetChallengeMaxPossibleScoreTableFromHistory(out array<ScoreTableEntry> ScoreTable, XComGameStateHistory History, optional int ChallengeIdx = -1);

final static native function EventListenerReturn OnTacticalGameEnd(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData);
final static native function EventListenerReturn OnKillMail(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData);
final static native function EventListenerReturn OnMissionObjectiveComplete(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData);
final static native function EventListenerReturn OnCivilianRescued(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData);

defaultproperties
{
	bShouldSubmitGameState=true
}