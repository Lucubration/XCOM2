//---------------------------------------------------------------------------------------
//  FILE:    OnlineEventMgr.uc
//  AUTHOR:  Timothy Talley  --  04/26/2012
//  PURPOSE: This object is designed to contain the various callbacks and delegates that
//           respond to online systems changes such as login/logout, storage device selection,
//           controller changes, and others
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class OnlineEventMgr extends Object
	native
	inherits(FTickableObject)
	dependson(OnlineSubsystem)
	config(XComGame);


var OnlineSubsystem OnlineSub;
var privatewrite int LocalUserIndex;
var privatewrite int InviteUserIndex;

// System Messaging - Members
//==================================================================================================================
//
enum ESystemMessageType
{
	SystemMessage_None,
	SystemMessage_Disconnected,
	SystemMessage_GameFull,
	SystemMessage_GameUnavailable,
	SystemMessage_VersionMismatch,
	SystemMessage_QuitReasonLogout,                 // 5
	SystemMessage_QuitReasonDlcDevice,
	SystemMessage_InvitePermissionsFailed,
	SystemMessage_InviteSystemError,
	SystemMessage_QuitReasonLinkLost,
	SystemMessage_QuitReasonInactiveUser,           // 10
	SystemMessage_QuitReasonLostConnection,
	SystemMessage_QuitReasonOpponentDisconnected,
	SystemMessage_BootInviteFailed,
	SystemMessage_LostConnection, // Lost connection with no quit
	SystemMessage_ChatRestricted,                   // 15
	SystemMessage_InviteRankedError, // Player attempted to join a ranked game via invite
	SystemMessage_SystemLinkClientVersionNewer,
	SystemMessage_SystemLinkClientVersionOlder,
	SystemMessage_SystemLinkServerVersionNewer,
	SystemMessage_SystemLinkServerVersionOlder,     // 20
	SystemMessage_CorruptedSave,
	SystemMessage_InviteServerVersionOlder,
	SystemMessage_InviteClientVersionOlder,
	SystemMessage_End,
};
var localized string m_sSystemMessageTitles[24]; //RAM - can't use the actual length here due to script patcher issues for the TU
var localized string m_sSystemMessageStrings[24]; // See: XComPresentationLayerBase:m_sSystemMessageStrings_TU1
var localized string m_sSystemMessageStringsXBOX[24];
var localized string m_sSystemMessageStringsPS3[24];
var protected array<ESystemMessageType> m_eSystemMessageQueue;
var protected array<delegate<SystemMessageAdded> > m_dSystemMessageAddedListeners;
var protected array<delegate<SystemMessagePopped> > m_dSystemMessagePoppedListeners;

// Invite System - Members
//==================================================================================================================
//
var localized string m_sAcceptingGameInvitation;
var localized string m_sAcceptingGameInvitationBody;
var protected bool m_bCurrentlyTriggeringInvite;
var protected bool m_bCurrentlyTriggeringBootInvite;
var protected bool m_bTriggerInvitesAfterMessages;
var protected bool m_bBootInviteChecked;
var protected array<OnlineGameSearchResult> m_tAcceptedGameInviteResults;
var protected array<delegate<CheckReadyForGameInviteAccept> > m_dCheckReadyForGameInviteAcceptListeners;
var protected array<delegate<GameInviteAccepted> > m_dGameInviteAcceptedListeners;
var protected array<delegate<GameInviteComplete> > m_dGameInviteCompleteListeners;

var bool m_bPassedOnlineConnectivityCheck;
var bool m_bPassedOnlinePlayPermissionsCheck;
var bool m_bAccessingOnlineDataDialogue;
var bool m_bMPConfirmExitDialogOpen;

var privatewrite bool m_bControllerUnplugged;

// After the shell login has been completed the first time, ShuttleToScreen will be set accordingly; this way if a 
// player is on the start screen and the title was booted from an invite, then it will transition to the MP Lobby 
// directly after the login-sequence.
enum ShuttleToScreenType
{
	EOEMSTST_None,
	EOEMSTST_StartScreen,
	EOEMSTST_MPMainMenu,
	EOEMSTST_MPInviteLoadout,
	EOEMSTST_ChallengeScreen,
};
var protected ShuttleToScreenType ShuttleToScreen;


// Multiplayer Load Timeout - Members
//==================================================================================================================
//
var float m_fMPLoadTimeout;

// Delegates
//==================================================================================================================
//

// System Messaging
delegate SystemMessageAdded(string sSystemMessage, string sSystemTitle);
delegate SystemMessagePopped(string sSystemMessage, string sSystemTitle);
delegate DisplaySystemMessageComplete();
// Invites
delegate bool CheckReadyForGameInviteAccept();
delegate GameInviteAccepted(bool bWasSuccessful);
delegate GameInviteComplete(ESystemMessageType MessageType, bool bWasSuccessful);


// Helper & Setup Functionality
//==================================================================================================================
//
event Init()
{
	OnlineSub = Class'Engine'.static.GetOnlineSubsystem();

	if (class'WorldInfo'.static.IsConsoleBuild(CONSOLE_Xbox360))
	{
		// Register for all users!
		OnlineSub.GameInterface.AddGameInviteAcceptedDelegate(0, OnGameInviteAcceptedUser0);
		OnlineSub.GameInterface.AddGameInviteAcceptedDelegate(1, OnGameInviteAcceptedUser1);
		OnlineSub.GameInterface.AddGameInviteAcceptedDelegate(2, OnGameInviteAcceptedUser2);
		OnlineSub.GameInterface.AddGameInviteAcceptedDelegate(3, OnGameInviteAcceptedUser3);
	}
	else
	{
		OnlineSub.GameInterface.AddGameInviteAcceptedDelegate(0, OnGameInviteAccepted);
	}

	OnlineSub.SystemInterface.AddControllerChangeDelegate(OnControllerStatusChanged);
}

event Tick(float DeltaTime);

protected function SetActiveController(int ControllerId)
{
	LocalUserIndex = ControllerId;
	m_bControllerUnplugged = !OnlineSub.SystemInterface.IsControllerConnected(ControllerId);
}

/**
 * Responds to controller status changed event
 * 
 * @param ControllerId the id of the controller that changed
 * @param bIsConnected whether the controller is connected or not
 */
protected function OnControllerStatusChanged(int ControllerId, bool bIsConnected)
{
	if( LocalUserIndex == ControllerId )
		m_bControllerUnplugged = !bIsConnected;
}

/** GetSystemMessageString
 * @return A localized, console specific string
 */
public function string GetSystemMessageString(ESystemMessageType eMessageType)
{
	local bool bOverridden;
	local string sSystemMessage;
	
	`log(`location @ `ShowVar(eMessageType));
	bOverridden = false;
	if (class'WorldInfo'.static.IsConsoleBuild(CONSOLE_Xbox360))
	{
		if (eMessageType < SystemMessage_InviteRankedError)
		{
			if( Len(m_sSystemMessageStringsXBOX[eMessageType]) > 0 )
			{
				sSystemMessage = m_sSystemMessageStringsXBOX[eMessageType];
				bOverridden = true;
			}
		}
	}
	else if (class'WorldInfo'.static.IsConsoleBuild(CONSOLE_PS3))
	{
		if (eMessageType < SystemMessage_InviteRankedError)
		{
			if (Len(m_sSystemMessageStringsPS3[eMessageType]) > 0)
			{
				sSystemMessage = m_sSystemMessageStringsPS3[eMessageType];
				bOverridden = true;
			}
		}
	}

	if ( !bOverridden )
	{
		if (eMessageType < SystemMessage_InviteRankedError)
		{
			sSystemMessage = m_sSystemMessageStrings[eMessageType];
		}
	}

	return sSystemMessage;
}

public function string GetSystemMessageTitle(ESystemMessageType eMessageType)
{	
	local string sSystemMessage;	
	
	`log(`location @ `ShowVar(eMessageType));
	if (eMessageType < SystemMessage_InviteRankedError)
	{
		sSystemMessage = m_sSystemMessageTitles[eMessageType];
	}

	return sSystemMessage;
}

/**
 * Performs an engine level disconnect since the PlayerController "ConsoleCommand" will not
 * trigger while the pending level is occurring. -ttalley
 */
native function EngineLevelDisconnect();

/**
 * Helper functions overridden on XComOnlineEventMgr
 */
function ShuttleToScreenType GetShuttleToScreen() { return ShuttleToScreen; }
function SetShuttleToScreen(ShuttleToScreenType ScreenType) 
{
	ScriptTrace();
	`log(`location @ "SHUTTLE CHECK" @ `ShowEnum(ShuttleToScreenType, ScreenType, ScreenType) @ `ShowEnum(ShuttleToScreenType, ShuttleToScreen, ShuttleToScreen));
	ShuttleToScreen = ScreenType;
}
function ClearShuttleToScreen() 
{ 
	ScriptTrace();
	`log(`location @ "SHUTTLE CHECK" @ `ShowEnum(ShuttleToScreenType, ShuttleToScreen, ShuttleToScreen));
	ShuttleToScreen = EOEMSTST_None;
}

function bool GetShuttleToChallengeMenu() { return ShuttleToScreen == EOEMSTST_ChallengeScreen; }
function SetShuttleToChallengeMenu()
{
	ScriptTrace();
	`log(`location @ "SHUTTLE CHECK");
	ShuttleToScreen = EOEMSTST_ChallengeScreen;
}
function bool GetShuttleToMPMainMenu() { return ShuttleToScreen == EOEMSTST_MPMainMenu; }
function SetShuttleToMPMainMenu()
{
	ScriptTrace();
	`log(`location @ "SHUTTLE CHECK");
	ShuttleToScreen = EOEMSTST_MPMainMenu;
}
function bool GetShuttleToMPInviteLoadout() { return ShuttleToScreen == EOEMSTST_MPInviteLoadout; }
function SetShuttleToMPInviteLoadout()
{
	ScriptTrace();
	`log(`location @ "SHUTTLE CHECK");
	ShuttleToScreen = EOEMSTST_MPInviteLoadout;
}
function bool GetShuttleToStartMenu() { return ShuttleToScreen == EOEMSTST_StartScreen; }
function SetShuttleToStartMenu()
{
	ScriptTrace();
	`log(`location @ "SHUTTLE CHECK");
	ShuttleToScreen = EOEMSTST_StartScreen;
}


// Invite System
//==================================================================================================================
//
// Current flow:
//  - OnlineSubsystem (PSN/LIVE/STEAM) activates the OnGameInviteAccepted delegates
//  - OnlineEventMgr.OnGameInviteAccepted is called and stores the result, then fires off for any listeners
//
//  - Any UI screen that wishes to handle invite acceptance

/**
 *  ShouldStartBootInviteProcess - Checks to see if the system was loaded with the boot flag
 *  and has not already attempted to boot into a MP Lobby.
 *  
 *  @return TRUE if ready to start the acceptance.
 */
function bool ShouldStartBootInviteProcess()
{
	`log(`location @ `ShowVar(OnlineSub.GameInterface.GameBootIsFromInvite()) @ `ShowVar(m_bBootInviteChecked), true, 'XCom_Online');
	return (OnlineSub.GameInterface.GameBootIsFromInvite() && (!m_bBootInviteChecked));
}

function SetBootInviteChecked(bool bChecked)
{
	m_bBootInviteChecked = bChecked;
}

function bool IsCurrentlyTriggeringBootInvite()
{
	`log(`location @ `ShowVar(m_bCurrentlyTriggeringBootInvite),,'XCom_Online');
	return m_bCurrentlyTriggeringBootInvite;
}

function ClearCurrentlyTriggeringBootInvite()
{
	`log(`location @ `ShowVar(m_bCurrentlyTriggeringBootInvite),,'XCom_Online');
	ScriptTrace();
	m_bCurrentlyTriggeringBootInvite = false;
}

function StartGameBootInviteProcess()
{
	m_bCurrentlyTriggeringBootInvite = true;
	InviteUserIndex = OnlineSub.GameInterface.GetGameBootInviteUserNum();
}

/**
 *  GameBootInviteAccept - Sets up the Online Subsystem data, then triggers the invite
 */
function GameBootInviteAccept()
{
	`log(`location @ "Setting m_bCurrentlyTriggeringBootInvite = true",,'XCom_Online');
	m_bCurrentlyTriggeringBootInvite = true;
	SetBootInviteChecked(true);
	OnlineSub.GameInterface.SetupGameBootInvitation();
}

function bool IsPlayerReadyForInviteTrigger()
{
	local delegate<CheckReadyForGameInviteAccept> dCheckReadyDelegate;
	local bool bAllListenersReady;

	if (!HasAcceptedInvites())
	{
		return false;
	}

	if (!m_bBootInviteChecked) // Wait for the call form XComShellPresentationLayer
	{
		`warn(`location @ "Attempted to accept an invite while still loading.");
		return false;
	}

	if (m_bCurrentlyTriggeringInvite)
	{
		`log(GetScriptTrace(),,'XCom_Online');
		`warn(`location @ "Will not add invite while one is currently being accepted!",,'XCom_Online');
		return false;
	}

	bAllListenersReady = true;
	foreach m_dCheckReadyForGameInviteAcceptListeners(dCheckReadyDelegate)
	{
		if (dCheckReadyDelegate != none)
		{
			bAllListenersReady = bAllListenersReady && dCheckReadyDelegate();
		}
	}
	if (!bAllListenersReady)
	{
		`log(GetScriptTrace(),,'XCom_Online');
		`warn(`location @ "Not all listeners are ready for the incoming Invite, attempt again later.",,'XCom_Online');
		return false;
	}

	return true;
}

function CancelInvite()
{
	// Reset the shuttling process
	ClearShuttleToScreen();
	m_bCurrentlyTriggeringInvite = false;

	ClearAcceptedInvites();
}

/**
 *  TriggerAcceptedInvite
 */
function bool TriggerAcceptedInvite()
{
	local PlayerController Controller;
	local OnlineGameSearchResult InviteResult;
	local delegate<GameInviteAccepted> dGameInviteAccepted;
	local bool bControllerInviteAcceptedSucces;

	if (!IsPlayerReadyForInviteTrigger())
	{
		return false;
	}

	if (InviteUserIndex != LocalUserIndex)
	{
		`log(GetScriptTrace(),,'XCom_Online');
		`warn(`location @ "We need to reset the shell login sequence, since the invited user is different than the current user.",,'XCom_Online');
		SwitchUsersThenTriggerAcceptedInvite();
		return false;
	}

	Controller = class'UIInteraction'.static.GetLocalPlayer(0).Actor;
	`log(`location @ `ShowVar(Controller) @ `ShowVar(HasAcceptedInvites(), HasAcceptedInvites), true, 'XCom_Online');
	if (None != Controller)
	{
		// Reset the shuttling process
		ClearShuttleToScreen();
		m_bCurrentlyTriggeringInvite = true;
		InviteResult = m_tAcceptedGameInviteResults[0];
		bControllerInviteAcceptedSucces = Controller.AttemptGameInviteAccepted(InviteResult, true);
		if(bControllerInviteAcceptedSucces)
		{
			if (class'WorldInfo'.static.IsConsoleBuild(CONSOLE_PS3) && OnlineSub.PlayerInterface.CanCommunicate(LocalUserIndex) == FPL_Disabled)
			{//PS3 user's chat is restricted, queue up a chat restricted message once we're in the lobby.
				QueueSystemMessage(SystemMessage_ChatRestricted, true);
			}
		}
		else
		{
			`log(`location @ "Controller failed to join invite game!");
		}

		//Trigger GameInviteAccepted delegates
		foreach m_dGameInviteAcceptedListeners(dGameInviteAccepted)
		{
			dGameInviteAccepted(bControllerInviteAcceptedSucces);
		}
	}

	return m_bCurrentlyTriggeringInvite;
}

function SwitchUsersThenTriggerAcceptedInvite()
{
	`log(`location,,'XCom_Online');
}


function OnGameInviteAcceptedUser0(const out OnlineGameSearchResult InviteResult, bool bWasSuccessful)
{
	InviteUserIndex = 0;
	OnGameInviteAccepted(InviteResult, bWasSuccessful);
}

function OnGameInviteAcceptedUser1(const out OnlineGameSearchResult InviteResult, bool bWasSuccessful)
{
	InviteUserIndex = 1;
	OnGameInviteAccepted(InviteResult, bWasSuccessful);
}

function OnGameInviteAcceptedUser2(const out OnlineGameSearchResult InviteResult, bool bWasSuccessful)
{
	InviteUserIndex = 2;
	OnGameInviteAccepted(InviteResult, bWasSuccessful);
}

function OnGameInviteAcceptedUser3(const out OnlineGameSearchResult InviteResult, bool bWasSuccessful)
{
	InviteUserIndex = 3;
	OnGameInviteAccepted(InviteResult, bWasSuccessful);
}

/**
 *  OnGameInviteAccepted - Callback from the OnlineSubsystem whenever a player accepts an invite.  This will store
 *    the invite data, since it is not stored elsewhere, and will allow the game to process invites through load
 *    screens or whenever the PlayerController will be destroyed.
 *    
 *    NOTE: This will be called multiple times with the same InviteResult, due to the way the invite callbacks are
 *    registered on all controllers.
 */
function OnGameInviteAccepted(const out OnlineGameSearchResult InviteResult, bool bWasSuccessful);  // Implemented in XComOnlineEventMgr
function InviteFailed(ESystemMessageType eSystemMessage, bool bTravelToMPMenus=false); // Implemented in XComOnlineEventMgr

function ControllerNotReadyForInvite()
{//called when a controller is not able to handle a game invite.
	//Saying that we're not currently triggering a invite
	//delays the current invite until the next TriggerAcceptedInvite().
	m_bCurrentlyTriggeringInvite = false; 
}

function OnLoginUIComplete(bool success)
{
	OnlineSub.PlayerInterface.ClearLoginUICompleteDelegate(OnLoginUIComplete);
	if (success && OnlineSub.SystemInterface.HasLinkConnection())
	{
		// Restart the invitation process
		OnlineSub.GameInterface.SetupGameBootInvitation(true);
	}
	else
	{
		QueueSystemMessage(SystemMessage_BootInviteFailed);
	}
}

function bool HasAcceptedInvites()
{
	return (m_tAcceptedGameInviteResults.Length > 0);
}

function ClearAcceptedInvites()
{
	m_tAcceptedGameInviteResults.Remove(0, m_tAcceptedGameInviteResults.Length);
}

// delegate bool CheckReadyForGameInviteAccept();
function AddCheckReadyForGameInviteAcceptDelegate(delegate<CheckReadyForGameInviteAccept> dCheckReadyForGameInviteAccept)
{
	`log(`location @ `ShowVar(dCheckReadyForGameInviteAccept), true, 'XCom_Online');
	if (m_dCheckReadyForGameInviteAcceptListeners.Find(dCheckReadyForGameInviteAccept) == INDEX_None)
	{
		m_dCheckReadyForGameInviteAcceptListeners[m_dCheckReadyForGameInviteAcceptListeners.Length] = dCheckReadyForGameInviteAccept;
	}
}

// delegate bool CheckReadyForInviteAccept();
function ClearCheckReadyForGameInviteAcceptDelegate(delegate<CheckReadyForGameInviteAccept> dCheckReadyForGameInviteAccept)
{
	local int i;

	`log(`location @ `ShowVar(dCheckReadyForGameInviteAccept), true, 'XCom_Online');
	i = m_dCheckReadyForGameInviteAcceptListeners.Find(dCheckReadyForGameInviteAccept);
	if (i != INDEX_None)
	{
		m_dCheckReadyForGameInviteAcceptListeners.Remove(i, 1);
	}
}

// delegate GameInviteAccepted();
function AddGameInviteAcceptedDelegate(delegate<GameInviteAccepted> dGameInviteAcceptedDelegate )
{
	`log(`location @ `ShowVar(dGameInviteAcceptedDelegate), true, 'XCom_Online');
	if (m_dGameInviteAcceptedListeners.Find(dGameInviteAcceptedDelegate) == INDEX_None)
	{
		m_dGameInviteAcceptedListeners[m_dGameInviteAcceptedListeners.Length] = dGameInviteAcceptedDelegate;
	}
}

// delegate GameInviteAccepted();
function ClearGameInviteAcceptedDelegate(delegate<GameInviteAccepted> dGameInviteAcceptedDelegate)
{
	local int i;

	`log(`location @ `ShowVar(dGameInviteAcceptedDelegate), true, 'XCom_Online');
	i = m_dGameInviteAcceptedListeners.Find(dGameInviteAcceptedDelegate);
	if (i != INDEX_None)
	{
		m_dGameInviteAcceptedListeners.Remove(i, 1);
	}
}

/**
 *  OnGameInviteComplete - Callback from the PlayerController if the invite has failed.
 */
function OnGameInviteComplete(ESystemMessageType MessageType, bool bWasSuccessful)
{
	local delegate<GameInviteComplete> dGameInviteComplete;

	`log(`location @ `ShowVar(MessageType) @ `ShowVar(bWasSuccessful), true, 'XCom_Online');

	if (bWasSuccessful)
	{
		// Don't accept another invite after this one, since it was successful.
		ClearAcceptedInvites();
	}
	else
	{
		// Attempt another invite in the queue if this one failed.
		if (m_tAcceptedGameInviteResults.Length > 0)
		{
			m_tAcceptedGameInviteResults.Remove(0, 1);
		}
	}
	m_bCurrentlyTriggeringInvite = false;

	if (!bWasSuccessful)
	{
		if(OnlineSub.PlayerInterface.GetLoginStatus(LocalUserIndex) != LS_LoggedIn)
		{// BUG 20822:The user fails to receive a message stating that they have been disconnected from Xbox LIVE when removing the Ethernet cable after accepting an invite
			InviteFailed(SystemMessage_LostConnection, true /*bTravelToMPMenus*/);
		}
		else
		{
			InviteFailed(MessageType, true /*bTravelToMPMenus*/);
		}
	}

	foreach m_dGameInviteCompleteListeners(dGameInviteComplete)
	{
		`log(`location @ `ShowVar(dGameInviteComplete), true, 'XCom_Online');
		dGameInviteComplete(MessageType, bWasSuccessful);
	}
}

// delegate GameInviteComplete(ESystemMessageType MessageType);
function AddGameInviteCompleteDelegate( delegate<GameInviteComplete> dGameInviteCompleteDelegate )
{
	`log(`location @ `ShowVar(dGameInviteCompleteDelegate), true, 'XCom_Online');
	if (m_dGameInviteCompleteListeners.Find(dGameInviteCompleteDelegate) == INDEX_None)
	{
		m_dGameInviteCompleteListeners[m_dGameInviteCompleteListeners.Length] = dGameInviteCompleteDelegate;
	}
}

// delegate GameInviteComplete(ESystemMessageType MessageType);
function ClearGameInviteCompleteDelegate(delegate<GameInviteComplete> dGameInviteCompleteDelegate)
{
	local int i;

	`log(`location @ `ShowVar(dGameInviteCompleteDelegate), true, 'XCom_Online');
	i = m_dGameInviteCompleteListeners.Find(dGameInviteCompleteDelegate);
	if (i != INDEX_None)
	{
		m_dGameInviteCompleteListeners.Remove(i, 1);
	}
}

function bool IsAcceptingGameInvite()
{
	return m_bCurrentlyTriggeringInvite;
}


// System Messaging
//==================================================================================================================
//
// ActivateAllSystemMessages
// ActivateNextSystemMessage
// QueueSystemMessage: Listeners - AddSystemMessageAddedDelegate, ClearSystemMessageAddedDelegate
// PeekSystemMessage
// PopSystemMessage: Listeners - AddSystemMessagePoppedDelegate, ClearSystemMessagePoppedDelegate
//

/**
 * ActivateAllSystemMessages - Individually shows all queued messages.
 */
event ActivateAllSystemMessages(optional bool bTriggerInvitesAfterAllMessages=false)
{
	`log("OnlineEventMgr::ActivateAllSystemMessages" @ `ShowVar(bTriggerInvitesAfterAllMessages),,'XCom_Online');

	DebugPrintSystemMessageQueue();
	//ScriptTrace();

	if (m_bCurrentlyTriggeringInvite)
	{
		`log(`location @ "Delaying, due to an invite travel, the activiation of system messages.",,'XCom_Online');
		return;
	}

	if (bTriggerInvitesAfterAllMessages)
	{
		m_bTriggerInvitesAfterMessages = true; // Instead of passing this variable through the system, just toggle it on the manager.
		if(LastGameWasAutomatch() && IsSystemMessageQueued(SystemMessage_GameFull))
		{
			if(OnSystemMessage_AutomatchGameFull())
			{
				ClearSystemMessages();
				return;
			}
		}
	}

	if (NumSystemMessages() == 0)
	{
		if (m_bTriggerInvitesAfterMessages)
			TriggerAcceptedInvite();
		m_bTriggerInvitesAfterMessages = false;
		return;
	}

	ActivateNextSystemMessage(OnDisplaySystemMessageComplete_All);
}

function OnDisplaySystemMessageComplete_All()
{
	local string sSystemMessage;
	local string sSystemTitle;

	PopSystemMessage(sSystemMessage, sSystemTitle);

	`log("OnlineEventMgr::OnDisplaySystemMessageComplete_All",,'XCom_Online');
	DebugPrintSystemMessageQueue();

	ActivateAllSystemMessages();
}

/**
 * ActivateNextSystemMessage - Displays the top message via the UI Presentation layer, 
 *      upon completion of the display, the default function will pop the top message.
 */
function ActivateNextSystemMessage(optional delegate<DisplaySystemMessageComplete> dOnDisplaySystemMessageComplete=OnDisplaySystemMessageComplete)
{
	local string sSystemMessage;
	local string sSystemTitle;

	if (NumSystemMessages() == 0)
		return;

	PeekSystemMessage(sSystemMessage, sSystemTitle);
	DisplaySystemMessage(sSystemMessage, sSystemTitle, dOnDisplaySystemMessageComplete);
}

// Override in subclass when a presentation layer is available.
function DisplaySystemMessage(string sSystemMessage, string sSystemTitle, optional delegate<DisplaySystemMessageComplete> dOnDisplaySystemMessageComplete=OnDisplaySystemMessageComplete)
{
	dOnDisplaySystemMessageComplete();
}

function OnDisplaySystemMessageComplete()
{
	local string sSystemMessage;
	local string sSystemTitle;

	PopSystemMessage(sSystemMessage, sSystemTitle);
}

/**
 * QueueNetworkErrorMessage - Converts a network error message into a suitable System
 *      Message and then puts it into the queue.
 */
native function QueueNetworkErrorMessage(String ErrorMsg);

/**
 * ShowSystemMessageOnMPMenus - Adds a message to be displayed to the user immediately on the MP menus,
 *      or immediately transitions the user into the MP menus to see the message.
 */
event ShowSystemMessageOnMPMenus(ESystemMessageType eMessageType)
{
	`log(self $ "::" $ GetFuncName() @ "-" @ `ShowVar(eMessageType) @ ", isAtMPMainMenu=" $ IsAtMPMainMenu(), true, 'XCom_Online');
	if(IsAtMPMainMenu())
	{
		QueueSystemMessage(eMessageType);
	}
	else
	{
		// Do not show message right away
		QueueSystemMessage(eMessageType, true);
		ReturnToMPMainMenuBase();
	}
}

/**
 * QueueSystemMessage - Adds a message to be displayed to the user at a later time,
 *      usually originating at the Engine due to problems with level loading and the
 *      clean-up of the UI during that process.  This waits for the UI to stabilize
 *      before prompting the end-user.
 */
event QueueSystemMessage(ESystemMessageType eMessageType, optional bool bIgnoreMsgAdd=false)
{
	local delegate<SystemMessageAdded> dSystemMessageAdded;
	local string sSystemMessage;
	local string sSystemTitle;

	`log("OnlineEventMgr::QueueSystemMessage",,'XCom_Online');

	if(m_eSystemMessageQueue.Find(eMessageType) == -1)
	{
		`log("OnlineEventMgr::QueueSystemMessage -> Adding New Message:" @ GetEnum(enum'ESystemMessageType', eMessageType),,'XCom_Online');

		sSystemTitle = GetSystemMessageTitle(eMessageType);
		sSystemMessage = GetSystemMessageString(eMessageType);
		m_eSystemMessageQueue[m_eSystemMessageQueue.Length] = eMessageType;

		DebugPrintSystemMessageQueue();

		if ( ! bIgnoreMsgAdd )
		{
			foreach m_dSystemMessageAddedListeners(dSystemMessageAdded)
			{
				`log(`location @ "Calling listener: " @ `ShowVar(dSystemMessageAdded), true, 'XCom_Online');
				dSystemMessageAdded(sSystemMessage, sSystemTitle);
			}
		}
		else
		{
			`log(`location @ "Skipping telling the listeners about the added system  message. Most likely caused by an immediate travel to another screen.");
		}
	}
	else
	{
		`log(`location @ "Ignoring duplicate message: " @ `ShowVar(eMessageType),,'XCom_Online');
	}
}

function bool OnSystemMessage_AutomatchGameFull();
function bool LastGameWasAutomatch();

// delegate SystemMessageAdded(string sSystemMessage);
function AddSystemMessageAddedDelegate( delegate<SystemMessageAdded> dSystemMessageAddedDelegate )
{
	`log(`location @ `ShowVar(dSystemMessageAddedDelegate), true, 'XCom_Online');
	if (m_dSystemMessageAddedListeners.Find(dSystemMessageAddedDelegate) == INDEX_None)
	{
		m_dSystemMessageAddedListeners[m_dSystemMessageAddedListeners.Length] = dSystemMessageAddedDelegate;
	}
}

// delegate SystemMessageAdded(string sSystemMessage);
function ClearSystemMessageAddedDelegate(delegate<SystemMessageAdded> dSystemMessageAddedDelegate)
{
	local int i;

	`log(`location @ `ShowVar(dSystemMessageAddedDelegate), true, 'XCom_Online');
	i = m_dSystemMessageAddedListeners.Find(dSystemMessageAddedDelegate);
	if (i != INDEX_None)
	{
		m_dSystemMessageAddedListeners.Remove(i, 1);
	}
}

/**
 * PeekSystemMessage - Returns the top most message
 */
function PeekSystemMessage(out string sSystemMessage, out string sSystemTitle)
{
	if (m_eSystemMessageQueue.Length > 0)
	{
		sSystemTitle = GetSystemMessageTitle(m_eSystemMessageQueue[0]);
		sSystemMessage = GetSystemMessageString(m_eSystemMessageQueue[0]);
	}
}

/**
 * PopSystemMessage - Removes the top message and tells any listeners to handle the associated message.
 */
function PopSystemMessage(out string sSystemMessage, out string sSystemTitle)
{
	local delegate<SystemMessagePopped> dSystemMessagePopped;

	if (m_eSystemMessageQueue.Length > 0)
	{
		`log(`location @ "Removing System Message:" @ `ShowVar(sSystemTitle) @ `ShowVar(sSystemMessage),,'XCom_Online');
		sSystemTitle = GetSystemMessageTitle(m_eSystemMessageQueue[0]);
		sSystemMessage = GetSystemMessageString(m_eSystemMessageQueue[0]);
		m_eSystemMessageQueue.Remove(0, 1);
		foreach m_dSystemMessagePoppedListeners(dSystemMessagePopped)
		{
			dSystemMessagePopped(sSystemMessage, sSystemTitle);
		}
	}
}

// delegate SystemMessagePopped(string sSystemMessage);
function AddSystemMessagePoppedDelegate(delegate<SystemMessagePopped> dSystemMessagePoppedDelegate)
{
	`log(`location @ `ShowVar(dSystemMessagePoppedDelegate), true, 'XCom_Online');
	if (m_dSystemMessagePoppedListeners.Find(dSystemMessagePoppedDelegate) == INDEX_None)
	{
		m_dSystemMessagePoppedListeners[m_dSystemMessagePoppedListeners.Length] = dSystemMessagePoppedDelegate;
	}
}

// delegate SystemMessagePopped(string sSystemMessage);
function ClearSystemMessagePoppedDelegate(delegate<SystemMessagePopped> dSystemMessagePoppedDelegate)
{
	local int i;

	`log(`location @ `ShowVar(dSystemMessagePoppedDelegate), true, 'XCom_Online');
	i = m_dSystemMessagePoppedListeners.Find(dSystemMessagePoppedDelegate);
	if (i != INDEX_None)
	{
		m_dSystemMessagePoppedListeners.Remove(i, 1);
	}
}

/**
 * ClearSystemMessages - Removes all messages without triggering callbacks.
 */
function int ClearSystemMessages(optional bool bClearCritialSystemMessages=false)
{
	local int i, iNumMessagesRemoved;
	local string strTrace;

	strTrace = GetScriptTrace();
	if (bClearCritialSystemMessages)
	{
		// Remove all messages!
		`log(`location @ "Clearing all System Messages!\n" @ strTrace,,'XCom_Online');
		iNumMessagesRemoved = m_eSystemMessageQueue.Length;
		m_eSystemMessageQueue.Remove(0, m_eSystemMessageQueue.Length);
	}
	else
	{
		iNumMessagesRemoved = 0;
		`log(`location @ "Clearing non-critical System Messages.\n" @ strTrace,,'XCom_Online');
		for (i = m_eSystemMessageQueue.Length-1; i >= 0; --i)
		{
			switch(m_eSystemMessageQueue[i])
			{
			case SystemMessage_ChatRestricted:
			case SystemMessage_CorruptedSave:
				break;
			default:
				++iNumMessagesRemoved;
				m_eSystemMessageQueue.Remove(i, 1);
				break;
			}
		}
	}
	return iNumMessagesRemoved;
}

function int NumSystemMessages()
{
	return m_eSystemMessageQueue.Length;
}

function bool IsSystemMessageQueued(ESystemMessageType msgType)
{
	return m_eSystemMessageQueue.Find(msgType) != INDEX_NONE;
}

function RemoveAllSystemMessagesOfType(ESystemMessageType msgType)
{
	local int i;

	DebugPrintSystemMessageQueue();
	`log("OnlineEventMgr::RemoveAllSystemMessagesOfType: '" $ GetEnum(enum'ESystemMessageType', msgType) $"'",,'XCom_Online');

	for(i = m_eSystemMessageQueue.Length - 1; i >= 0; --i)
	{
		if(m_eSystemMessageQueue[i] == msgType)
			m_eSystemMessageQueue.Remove(i, 1);
	}

	DebugPrintSystemMessageQueue();
}

function DebugPrintSystemMessageQueue()
{
`if(`notdefined(FINAL_RELEASE))
	local int i;

	`log("SYSTEM MESSAGE QUEUE:",,'XCom_Online');
	for(i = 0; i < m_eSystemMessageQueue.Length; ++i)
	{
		
		`log("[" $ i $ "] = " $ GetEnum(enum'ESystemMessageType', m_eSystemMessageQueue[i]) ,,'XCom_Online');
		if(i == m_eSystemMessageQueue.Length - 1)
			`log("END QUEUE",,'XCom_Online');
	}
`endif
}

/**
 * SystemMessageCleanup - Removes all messages, and unlinks all delegates.
 */
function SystemMessageCleanup()
{
	m_eSystemMessageQueue.Remove(0, m_eSystemMessageQueue.Length);
	m_dSystemMessageAddedListeners.Remove(0, m_dSystemMessageAddedListeners.Length);
	m_dSystemMessagePoppedListeners.Remove(0, m_dSystemMessagePoppedListeners.Length);
}

/**
 * StartMPLoadTimeout - Start the multiplayer load timeout time
 */
native function StartMPLoadTimeout();

/**
 * GetMPLoadTimeout - Get the multiplayer load timeout time
 */
native function float GetMPLoadTimeout();

/**
 * event OnMPLoadTimeout - The multiplayer load process has timed out.
 */
event OnMPLoadTimeout()
{
}

function ReturnToMPMainMenuBase();

function bool IsAtMPMainMenu();


cpptext
{
// FTickableObject interface

	/**
	 * Returns whether it is okay to tick this object. E.g. objects being loaded in the background shouldn't be ticked
	 * till they are finalized and unreachable objects cannot be ticked either.
	 *
	 * @return	TRUE if tickable, FALSE otherwise
	 */
	virtual UBOOL IsTickable() const;
	/**
	 * Used to determine if an object should be ticked when the game is paused.
	 *
	 * @return always TRUE as networking needs to be ticked even when paused
	 */
	virtual UBOOL IsTickableWhenPaused() const;
	/**
	 * Just calls the tick event
	 *
	 * @param DeltaTime The time that has passed since last frame.
	 */
	virtual void Tick(FLOAT DeltaTime);

	virtual void WaitForSavesToComplete();
}

defaultproperties
{
	InviteUserIndex=0
	m_bBootInviteChecked=false
	m_bCurrentlyTriggeringInvite=false
	m_bCurrentlyTriggeringBootInvite=false
}
