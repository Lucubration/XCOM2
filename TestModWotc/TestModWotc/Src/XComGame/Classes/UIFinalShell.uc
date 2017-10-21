//---------------------------------------------------------------------------------------
//  *********   FIRAXIS SOURCE CODE   ******************
//  FILE:    UIFinalShell.uc
//  AUTHOR:  Sam Batista - 11/4/10
//  PURPOSE: Carbon copy of 'Shell.uc' with different menu options.
//           OVERRIDES ONLY NECESSARY FUNCTIONS.
//---------------------------------------------------------------------------------------
//  Copyright (c) 2009 - 2016 Firaxis Games, Inc. All rights reserved.
//--------------------------------------------------------------------------------------- 

class UIFinalShell extends UIShell;

//------------------------------------------------------
// LOCALIZED STRINGS
var localized string            m_sNewGame;
var localized string            m_sMultiplayer;
var localized string            m_sExitToDesktop;
var localized string            m_sCharacterPool;
var localized string            m_sChallengeMode;

var localized string            m_strExitToPSNStoreTitle;
var localized string            m_strExitToPSNStoreBody;

var UIButton                    m_my2KButton;
var bool                        m_bNewChallenge;
var bool                        m_bChallengeRequestInFlight;
var bool                        m_bLaunchChallengeAfterRequest;

var int m_iSP;
var int m_iMP;
var int m_iLoad;
var int m_iOptions;
var int m_iExit;

var bool bIsFullScreenViewport;

//--------------------------------------------------------------------------------------- 
// Cached References
//
var X2FiraxisLiveClient FiraxisLiveClient;


// Flash is ready
simulated function OnInit()
{
	super.OnInit();
	
	ImportBaseGameCharacterPool();

	m_my2KButton = Spawn(class'UIButton', self);
	m_my2KButton.LibID = 'My2KButton';
	m_my2KButton.InitButton('My2KButton', ,  ProcessMy2KButtonClick);
	m_my2KButton.AnchorBottomRight();
	m_my2KButton.SetPosition(-200,-120);
	
	SubscribeToOnCleanupWorld();
	FiraxisLiveClient = `FXSLIVE;
	FiraxisLiveClient.AddLoginStatusDelegate(LoginStatusChange);
	FiraxisLiveClient.AddReceivedChallengeModeIntervalStartDelegate(OnReceivedChallengeModeIntervalStart);
	FiraxisLiveClient.AddReceivedChallengeModeIntervalEndDelegate(OnReceivedChallengeModeIntervalEnd);
	FiraxisLiveClient.AddReceivedChallengeModeIntervalEntryDelegate(OnReceivedChallengeModeIntervalEntry);

	FiraxisLiveClient.FirstClientInit();

	UpdateMy2KButtonStatus();

	SetTimer(1.0f, true, nameof(UpdateMy2KButtonStatus));

	bIsFullScreenViewport = `XENGINE.GameViewport.IsFullScreenViewport();
}

function ImportBaseGameCharacterPool()
{
	local CharacterPoolManager CP;
	local XComGameState_Unit ImportUnit;
	local int iNumChars;

	iNumChars = `XENGINE.m_CharacterPoolManager.CharacterPool.Length;
	if (iNumChars == 0)
	{
		CP = new class'CharacterPoolManager';		
		CP.LoadBaseGameCharacterPool();

		if (CP.CharacterPool.Length > 0)
		{
			//Grab each unit and put it in the default pool
			foreach CP.CharacterPool(ImportUnit)
			{
				if (ImportUnit != None)
					`XENGINE.m_CharacterPoolManager.CharacterPool.AddItem(ImportUnit);
			}

			//Save the default character pool
			`XENGINE.m_CharacterPoolManager.SaveCharacterPool();
		}
	}
}

simulated function UpdateMenu()
{
	local int i;

	ClearMenu();

	CreateItem('SP', m_sNewGame);
	CreateItem('Load', m_sLoad);
	CreateItem('MP', m_sMultiplayer);
	CreateItem('Challenge', m_sChallengeMode);
	CreateItem('Options', m_sOptions);
	CreateItem('CharacterPool', m_sCharacterPool);
	CreateItem('Exit', m_sExitToDesktop);

	MainMenuContainer.Navigator.SelectFirstAvailable();
	for (i = 0; i < MainMenu.Length; ++i)
	{
		MainMenu[i].ProcessMouseEvents(OnChildMouseEvent);
}
}

// Button callbacks
simulated function OnMenuButtonClicked(UIButton button)
{
	if( m_bDisableActions )
		return;

	//Re-enable achievements
	`ONLINEEVENTMGR.ResetAchievementState();

	switch( button.MCName )
	{
	case 'SP':
		XComShellPresentationLayer(Owner).UIDifficulty();
		break;
	case 'MP':
		XComShellPresentationLayer(Owner).StartMPShellState();
		break;
	case 'Load':
		`XCOMHISTORY.ResetHistory();
		XComShellPresentationLayer(Owner).UILoadScreen();
		break;
	case 'Challenge':
		if (!m_bChallengeRequestInFlight)
		{
			OpenChallengeModeUI();
		}
		else
		{
			m_bLaunchChallengeAfterRequest = true;
		}
		break;
	case 'Options':
		XComPresentationLayerBase(Owner).UIPCOptions();
		break;
	case 'CharacterPool':
		XComPresentationLayerBase(Owner).UICharacterPool();
		`XCOMGRI.DoRemoteEvent('StartCharacterPool');
		break;
	case 'Exit':
		if( !WorldInfo.IsConsoleBuild(CONSOLE_Any) )
		{
			ConsoleCommand("exit");
		}
		break;
	}
}

simulated function OnChildMouseEvent(UIPanel control, int cmd)
{
	switch (cmd)
	{
	case class'UIUtilities_Input'.const.FXS_L_MOUSE_IN :
	case class'UIUtilities_Input'.const.FXS_L_MOUSE_OVER :
	case class'UIUtilities_Input'.const.FXS_L_MOUSE_DRAG_OVER :
		MainMenuContainer.Navigator.SetSelected(control);
		break;
	}
}

simulated function OnReceiveFocus()
{
	m_my2kButton.OnLoseFocus();

	if(Navigator.SelectedIndex == 1)
	{
		Navigator.SelectFirstAvailable();
	}

	super.OnReceiveFocus();
	XComShellPresentationLayer(Movie.Pres).UIShellScreen3D();
}

function ProcessMy2KButtonClick(UIButton Button)
{
	local EStatusType StatusType;

	StatusType = FiraxisLiveClient.GetStatus();
	`log( `location @ `ShowEnum(EStatusType, StatusType, StatusType),,'FiraxisLive');

	switch(StatusType)
	{
	case E2kST_OfflineLoggedInCached:
	case E2kST_OnlineLoggedIn:
		if( FiraxisLiveClient.IsAccountAnonymous() )
		{
			FiraxisLiveClient.UpgradeAccount();
			break;
		}
		if( FiraxisLiveClient.IsAccountPlatform() )
		{
			FiraxisLiveClient.StartLinkAccount();
			break;
		}
		if( FiraxisLiveClient.IsAccountFull() )
		{
			PromptForUnlink();
			break;
		}

	case E2kST_Unknown:
	case E2kST_Online:
	case E2kST_Offline:
	case E2kST_OfflineBanned:
	case E2kST_OfflineBlocked:
	case E2kST_OfflineRejectedWhitelist:
	case E2kST_OfflineRejectedCapacity:
	case E2kST_OfflineLegalAccepted:
	case E2kST_LoggedInDoormanOffline:
	default:
		FiraxisLiveClient.StartLoginRequest();
		break;
	}
}

function UIFiraxisLiveLogin GetFiraxisLiveLoginUI()
{
	local XComPresentationLayerBase Presentation;
	local UIFiraxisLiveLogin FiraxisLiveUI;
	Presentation = XComPresentationLayerBase(Owner);
	if( !Presentation.ScreenStack.HasInstanceOf(class'UIFiraxisLiveLogin') )
	{
		// Only open and handle the notification if the Live UI is not up already.
		FiraxisLiveUI = UIFiraxisLiveLogin(Presentation.UIFiraxisLiveLogin(false));
	}
	return FiraxisLiveUI;
}

function PromptForUnlink()
{
	local UIFiraxisLiveLogin FiraxisLiveUI;
	FiraxisLiveUI = GetFiraxisLiveLoginUI();
	if( FiraxisLiveUI != None )
	{
		FiraxisLiveUI.GotoRequestUnlink();
	}
}

function UpdateMy2KButtonStatus()
{
	local ELoginStatus NewButtonStatus;
	local string StatusText;

	// TODO: once my2k provides the status message, use that message instead of the local messages below

	NewButtonStatus = LS_NotLoggedIn;
	StatusText = class'XComOnlineEventMgr'.default.My2k_Offline;
	if (IsOnline())
	{
		if (FiraxisLiveClient.IsAccountAnonymous() || FiraxisLiveClient.IsAccountPlatform())
		{
			NewButtonStatus = LS_UsingLocalProfile;
			StatusText = class'XComOnlineEventMgr'.default.My2k_Link;
		}
		else if (FiraxisLiveClient.IsAccountFull())
		{
			NewButtonStatus = LS_LoggedIn;
			StatusText = class'XComOnlineEventMgr'.default.My2k_Unlink;
		}
	}
	m_my2KButton.MC.FunctionString("setStatusText", StatusText);
	m_my2KButton.MC.FunctionNum("setStatus", NewButtonStatus);
}

function LoginStatusChange(ELoginStatusType Type, EFiraxisLiveAccountType Account, string Message, bool bSuccess)
{
	`log( `location @ `ShowEnum(ELoginStatusType, Type, Type) @ `ShowEnum(EFiraxisLiveAccountType, Account, Account) @ `ShowVar(Message) @ `ShowVar(bSuccess),,'FiraxisLive');

	// Ignore status coming back that are errors
	if( !bSuccess ) return;

	// Refresh the menu options to handle the DLC option either
	// appearing or disappearing with a login status change.
	UpdateMenu();

	UpdateMy2KButtonStatus();

	ClearTimer(nameof(CheckForNewChallenges));
	SetTimer(3.0f, true, nameof(CheckForNewChallenges));
}

function OnReceivedMOTD(string Category, array<MOTDMessageData> Messages)
{
	super.OnReceivedMOTD(Category, Messages);

	ClearTimer(nameof(CheckForNewChallenges));
	SetTimer(3.0f, true, nameof(CheckForNewChallenges));
}

function CheckForNewChallenges()
{
	ClearTimer(nameof(CheckForNewChallenges));
	`log(`location @ `ShowEnum(EStatusType, FiraxisLiveClient.GetStatus(), Status));
	ScriptTrace();
	if (IsOnline())
	{
		if (!m_bChallengeRequestInFlight)
		{
			m_bChallengeRequestInFlight = true;
			// Grab the Challenge Information
			FiraxisLiveClient.PerformChallengeModeGetIntervals(false); // Don't get the seed data!
		}
		else
		{
			`log(`location @ "Attempting to get challenge mode intervals while a request is already out. This will cause an error");
		}
	}
	else
	{
		`log(`location @ "Unable to Check for New Challenges, not currently online!");
	}
}

function bool IsOnline()
{
	switch (FiraxisLiveClient.GetStatus())
	{
	case E2kST_Online:
	case E2kST_OnlineLoggedIn:
		return true;
		break;
	}
	return false;
}

function OpenChallengeModeUI()
{
	ClearTimer(nameof(CheckForNewChallenges));
	`CHALLENGEMODE_MGR.OpenChallengeModeUI();
}

function OnReceivedChallengeModeIntervalStart(int NumIntervals)
{
	`log(`location @ `ShowVar(NumIntervals));
	m_bNewChallenge = false;
}

function OnReceivedChallengeModeIntervalEnd()
{
	`log(`location @ `ShowVar(m_bNewChallenge));
	UIX2MenuButton(MainMenu[3]).NeedsAttention(m_bNewChallenge);
	m_bChallengeRequestInFlight = false;
	if (m_bLaunchChallengeAfterRequest)
	{
		m_bLaunchChallengeAfterRequest = false;
		OpenChallengeModeUI();
	}
}

function OnReceivedChallengeModeIntervalEntry(qword IntervalSeedID, int ExpirationDate, int TimeLength, EChallengeStateType IntervalState, optional string IntervalName, optional array<byte> StartState)
{
	`log(`location @ `ShowVar(ExpirationDate) @ `ShowVar(TimeLength) @ `ShowEnum(EChallengeStateType, IntervalState, IntervalState) @ `ShowVar(IntervalName), , 'XCom_Online');
	if (IntervalState == ECST_Ready)
	{
		m_bNewChallenge = true;
	}
}

event Tick(float DeltaTime)
{
	super.Tick(DeltaTime);

	if (bIsFullScreenViewport != `XENGINE.GameViewport.IsFullScreenViewport())
	{
		bIsFullScreenViewport = !bIsFullScreenViewport;
		UpdateNavHelp();
	}
}

//==============================================================================
//		CLEANUP (can never be too careful):
//==============================================================================

event Destroyed() 
{
	Cleanup();
	UnsubscribeFromOnCleanupWorld();
	super.Destroyed();
}
simulated event OnCleanupWorld()
{
	Cleanup();
	super.OnCleanupWorld();
}
simulated function Cleanup()
{
	super.Cleanup();
	FiraxisLiveClient.ClearLoginStatusDelegate(LoginStatusChange);
	FiraxisLiveClient.ClearReceivedChallengeModeIntervalStartDelegate(OnReceivedChallengeModeIntervalStart);
	FiraxisLiveClient.ClearReceivedChallengeModeIntervalEndDelegate(OnReceivedChallengeModeIntervalEnd);
	FiraxisLiveClient.ClearReceivedChallengeModeIntervalEntryDelegate(OnReceivedChallengeModeIntervalEntry);

	ClearTimer(nameof(UpdateMy2KButtonStatus));

	//CleanupMOTDReference();
}

DefaultProperties
{
	InputState = eInputState_Evaluate; 
}