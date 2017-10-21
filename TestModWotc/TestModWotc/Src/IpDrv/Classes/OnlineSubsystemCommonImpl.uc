/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

/**
 * Class that implements commonly needed members/features across all platforms
 */
class OnlineSubsystemCommonImpl extends OnlineSubsystem
	native
	abstract
	config(Engine);

//Firaxis BEGIN
/** Struct that holds the data for a single cross title savegame */
struct native OnlineCrossTitleSaveGame extends OnlineSaveGame
{
	/** The title id this content is for */
	var int TitleId;
};



//RAM - support for unified cross platform save/load
/** Holds the cached state of the content list for a single player */
struct native ContentListCache
{
	/** The list of returned savegame content */
	var array<OnlineContent> SaveGameContent;
	/** Indicates the state of the savegame async read */
	var EOnlineEnumerationReadState SaveGameReadState;
	/** The delegate to call when the savegame read is complete */
	var array<delegate<OnReadContentComplete> > SaveGameReadCompleteDelegates;
	/** The list of returned DLC content */
	var array<OnlineContent> Content;
	/** Indicates the state of the async read */
	var EOnlineEnumerationReadState ReadState;
	/** The delegate to call when the content has changed (user logged in, etc) */
	var array<delegate<OnContentChange> > ContentChangeDelegates;
	/** The delegate to call when the read is complete */
	var array<delegate<OnReadContentComplete> > ReadCompleteDelegates;
	/** The number of new downloadable content packages available */
	var int NewDownloadCount;
	/** The total number of downloadable content packages available */
	var int TotalDownloadCount;
	/** The delegate to call when the read is complete */
	var array<delegate<OnQueryAvailableDownloadsComplete> > QueryDownloadsDelegates;
	/** The delegate to call when the savegame data read is complete */
	var array<delegate<OnReadSaveGameDataComplete> > ReadSaveGameDataCompleteDelegates;
	/** The delegate to call when the savegame data write is complete */
	var array<delegate<OnWriteSaveGameDataComplete> > WriteSaveGameDataCompleteDelegates;
	/** The delegate to call when the savegame delete is complete - only needed on ps3*/
	var array<delegate<OnDeleteSaveGameDataComplete> > DeleteSaveGameDataCompleteDelegates;

	/** Holds the list of savegames that are in progress or cached */
	var array<OnlineSaveGame> SaveGames;
	/** The delegate to call when the cross title savegame read is complete */
	var array<delegate<OnReadCrossTitleContentComplete> > SaveGameReadCrossTitleCompleteDelegates;
	/** Indicates the state of the cross title savegame async read */
	var EOnlineEnumerationReadState SaveGameCrossTitleReadState;
	/** The delegate to call when the cross title read is complete */
	var array<delegate<OnReadCrossTitleContentComplete> > ReadCrossTitleCompleteDelegates;
	/** Indicates the state of the cross title async read */
	var EOnlineEnumerationReadState ReadCrossTitleState;
	/** The list of returned cross title savegame content */
	var array<OnlineCrossTitleContent> CrossTitleSaveGameContent;
	/** The list of returned cross title content */
	var array<OnlineCrossTitleContent> CrossTitleContent;
	/** Holds the list of savegames that are in progress or cached */
	var array<OnlineCrossTitleSaveGame> CrossTitleSaveGames;
	/** The delegate to call when the cross title savegame data read is complete */
	var array<delegate<OnReadCrossTitleSaveGameDataComplete> > ReadCrossTitleSaveGameDataCompleteDelegates;
	/** The delegate to call when an invitation is received */
	var array<delegate<OnInviteRequestReceived> > InviteRequestReceivedDelegates;
};

/** Cache of content list per player */
var ContentListCache ContentCache[4];

/** List of delegates requiring notification when the external asynchronous login UI completes */
var array<delegate<OnLoginUIComplete> > LoginUICompleteDelegates;

/** List of delegates requiring notification when the external asynchronous login UI completes */
var array<delegate<OnRequestUserInformationComplete> > RequestUserInformationDelegates;

//Firaxis END

/**
 * Holds the pointer to the platform specific FVoiceInterface implementation
 * used for voice communication
 */
var const native transient pointer VoiceEngine{class FVoiceInterface};

/** Holds the maximum number of local talkers allowed */
var config int MaxLocalTalkers;

/** Holds the maximum number of remote talkers allowed (clamped to 30 which is XHV max) */
var config int MaxRemoteTalkers;

/** Whether speech recognition is enabled */
var config bool bIsUsingSpeechRecognition;

/** The object that handles the game interface implementation across platforms */
var OnlineGameInterfaceImpl GameInterfaceImpl;

/** The object that handles the auth interface implementation across platforms */
var OnlineAuthInterfaceImpl AuthInterfaceImpl;

// FIRAXIS BEGIN
/** True when the last write failed because we are out of space */
var protectedwrite bool bStorageFull;
// FIRAXIS END

/**
 * Delegate used when the cross title content read request has completed
 *
 * @param bWasSuccessful true if the async action completed without error, false if there was an error
 * @param LocalUserNum the user that was initiating the data read
 * @param DeviceId the device that the read was on
 * @param TitleId the title id the save game is from
 * @param FriendlyName the friendly name of the save game that was returned by enumeration
 * @param FileName the file to read from inside of the content package
 * @param SaveFileName the file name of the save game inside the content package
 */
delegate OnReadCrossTitleSaveGameDataComplete(bool bWasSuccessful,byte LocalUserNum,int DeviceId,int TitleId,string FriendlyName,string FileName,string SaveFileName);

/**
 * Delegate used when the content read request has completed
 *
 * @param bWasSuccessful true if the async action completed without error, false if there was an error
 */
delegate OnReadCrossTitleContentComplete(bool bWasSuccessful);

/**
 * Delegate used when the content read request has completed
 *
 * @param bWasSuccessful true if the async action completed without error, false if there was an error
 */
delegate OnReadContentComplete(bool bWasSuccessful);

/**
 * Delegate used in content change (add or deletion) notifications
 * for any user
 */
delegate OnContentChange();

/**
 * Called once the download query completes
 *
 * @param bWasSuccessful true if the async action completed without error, false if there was an error
 */
delegate OnQueryAvailableDownloadsComplete(bool bWasSuccessful);

/**
 * Delegate used when the content read request has completed
 *
 * @param bWasSuccessful true if the async action completed without error, false if there was an error
 * @param LocalUserNum the user that was initiating the data read
 * @param DeviceId the device that the read was on
 * @param FriendlyName the friendly name of the save game that was returned by enumeration
 * @param FileName the file to read from inside of the content package
 * @param SaveFileName the file name of the save game inside the content package
 */
delegate OnReadSaveGameDataComplete(bool bWasSuccessful,byte LocalUserNum,int DeviceId,string FriendlyName,string FileName,string SaveFileName);

/**
 * Delegate used when the content write request has completed
 *
 * @param bWasSuccessful true if the async action completed without error, false if there was an error
 * @param LocalUserNum the user that was initiating the data write
 * @param DeviceId the device to write the same game to
 * @param FriendlyName the friendly name of the save game
 * @param FileName the file to write to inside of the content package
 * @param SaveGameData the data to write to the save game file
 */
delegate OnWriteSaveGameDataComplete(bool bWasSuccessful,byte LocalUserNum,int DeviceId,string FriendlyName,string FileName,string SaveFileName);

delegate OnDeleteSaveGameDataComplete(byte LocalUserNum);


/**
 * Returns the name of the player for the specified index
 *
 * @param UserIndex the user to return the name of
 *
 * @return the name of the player at the specified index
 */
event string GetPlayerNicknameFromIndex(int UserIndex);

// TODO: i don't know why the 3rd party steamworks changes removed this... -tsmith 
///**
// * Returns the unique id of the player for the specified index
// *
// * @param UserIndex the user to return the id of
// *
// * @return the unique id of the player at the specified index
// */
//event UniqueNetId GetPlayerUniqueNetIdFromIndex(int UserIndex);

/**
 * Determine if the player is registered in the specified session
 *
 * @param PlayerId the player to check if in session or not
 * @return TRUE if the player is a registrant in the session
 */
native function bool IsPlayerInSession(name SessionName,UniqueNetId PlayerId);

/**
 * Get a list of the net ids for the players currently registered on the session
 *
 * @param SessionName name of the session to find
 * @param OutRegisteredPlayers [out] list of player net ids in the session (empty if not found)
 */
function GetRegisteredPlayers(name SessionName,out array<UniqueNetId> OutRegisteredPlayers)
{
	local int Idx,PlayerIdx;

	OutRegisteredPlayers.Length = 0;
	for (Idx=0; Idx < Sessions.Length; Idx++)
	{
		// find session by name
		if (Sessions[Idx].SessionName == SessionName)
		{
			// return list of player ids currently registered on the session
			OutRegisteredPlayers.Length = Sessions[Idx].Registrants.Length;
			for (PlayerIdx=0; PlayerIdx < Sessions[Idx].Registrants.Length; PlayerIdx++)
			{
				OutRegisteredPlayers[PlayerIdx] = Sessions[Idx].Registrants[PlayerIdx].PlayerNetId;
			}
			break;
		}
	}
}

// FIRAXIS BEGIN
function bool IsStorageFull()
{
	return bStorageFull;
}
// FIRAXIS END

// FIRAXIS begin: In-Game Invite Setup -ttalley
/**
 * Triggered whenever the player receives an invite from another.
 * 
 * @param LocalUserNum which user is receiving the invite
 */
delegate OnInviteRequestReceived(byte LocalUserNum);

/**
 * Queries the online system for the number of invites for this game.
 * 
 * @return number of invites
 */
function int GetPendingInviteCount(byte LocalUserNum)
{
	return 0;
}

/**
 * Displays the received invites ui
 *
 * @param LocalUserNum the local user sending the invite
 */
function bool ShowReceivedInviteUI(byte LocalUserNum)
{
	`log(`location @ "Not implemented!");
	return false;
}

/**
 * Sets the delegate used to notify the gameplay code when a game invite has been issued to the player from another
 *
 * @param LocalUserNum the user to request notification for
 * @param InviteRequestReceivedDelegate the delegate to use for notifications
 */
function AddInviteRequestReceivedDelegate(byte LocalUserNum, delegate<OnInviteRequestReceived> InviteRequestReceivedDelegate)
{
	// Make sure it's within range
	if (LocalUserNum >= 0 && LocalUserNum < 4)
	{
		if (ContentCache[LocalUserNum].InviteRequestReceivedDelegates.Find(InviteRequestReceivedDelegate) == INDEX_NONE)
		{
			ContentCache[LocalUserNum].InviteRequestReceivedDelegates.AddItem(InviteRequestReceivedDelegate);
		}
	}
	else
	{
		`Warn("Invalid index ("$LocalUserNum$") passed to AddQueryAvailableDownloadsComplete()");
	}
}

/**
 * Removes the delegate from the list of notifications
 *
 * @param InviteRequestReceivedDelegate the delegate to use for notifications
 */
function ClearInviteRequestReceivedDelegate(byte LocalUserNum, delegate<OnInviteRequestReceived> InviteRequestReceivedDelegate)
{
	local int RemoveIndex;

	// Make sure it's within range
	if (LocalUserNum >= 0 && LocalUserNum < 4)
	{
		RemoveIndex = ContentCache[LocalUserNum].InviteRequestReceivedDelegates.Find(InviteRequestReceivedDelegate);
		if (RemoveIndex != INDEX_NONE)
		{
			ContentCache[LocalUserNum].InviteRequestReceivedDelegates.Remove(RemoveIndex,1);
		}
	}
	else
	{
		`warn("Invalid index ("$LocalUserNum$") passed to ClearQueryAvailableDownloadsComplete()");
	}
}
// FIRAXIS end: In-Game Invite Setup -ttalley


// FIRAXIS begin: Adding LoginUIComplete handling for PS3 TRC R142, BUG 2650 -ttalley
delegate OnLoginUIComplete( bool success );

function AddLoginUICompleteDelegate(delegate<OnLoginUIComplete> LoginUICompleteDelegate )
{
	// Add this delegate to the array if not already present
	if (LoginUICompleteDelegates.Find(LoginUICompleteDelegate) == INDEX_NONE)
	{
		LoginUICompleteDelegates.AddItem(LoginUICompleteDelegate);
	}
}

function ClearLoginUICompleteDelegate(delegate<OnLoginUIComplete> LoginUICompleteDelegate )
{
	local int RemoveIndex;

	// Remove this delegate from the array if found
	RemoveIndex = LoginUICompleteDelegates.Find(LoginUICompleteDelegate);
	if (RemoveIndex != INDEX_NONE)
	{
		LoginUICompleteDelegates.Remove(RemoveIndex,1);
	}
}
// FIRAXIS end: Adding LoginUIComplete handling for PS3 TRC R142, BUG 2650 -ttalley

function ResetLogin()
{
}

/**
* Sends a request to the subsystem to return the current name for the specified player id.
*
* @param LocalUserNum local player index
* @param PlayerId retrieves the name for this unique player identifier
*
* @return TRUE if the request fires off, FALSE if it failed
*/
function bool RequestUserInformation(byte LocalUserNum, UniqueNetId PlayerId)
{
	return FALSE;
}

/**
* Delegate is called when the user information comes back and name is available
*
* @param bWasSuccessful true if the async action completed without error, false if there was an error
* @param PlayerId the player id associated with the information retrieval
* @param PlayerName the looked-up name for the given player id
*/
delegate OnRequestUserInformationComplete(bool bWasSuccessful, UniqueNetId PlayerId, string PlayerName);

/**
* Adds the delegate used to notify the gameplay code that user information has been retrieved
*
* @param RequestUserInformationDelegate the delegate to use for notifications
*/
function AddRequestUserInformationCompleteDelegate(delegate<OnRequestUserInformationComplete> RequestUserInformationDelegate)
{
	// Add this delegate to the array if not already present
	if (RequestUserInformationDelegates.Find(RequestUserInformationDelegate) == INDEX_NONE)
	{
		RequestUserInformationDelegates.AddItem(RequestUserInformationDelegate);
	}
}

/**
* Clears the delegate used to notify the gameplay code that the user information has been retrieved
*
* @param OnRequestUserInformationComplete the delegate to use for notifications
*/
function ClearRequestUserInformationCompleteDelegate(delegate<OnRequestUserInformationComplete> RequestUserInformationDelegate)
{
	local int RemoveIndex;

	// Remove this delegate from the array if found
	RemoveIndex = RequestUserInformationDelegates.Find(RequestUserInformationDelegate);
	if (RemoveIndex != INDEX_NONE)
	{
		RequestUserInformationDelegates.Remove(RemoveIndex, 1);
	}
}
