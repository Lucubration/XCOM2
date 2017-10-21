//---------------------------------------------------------------------------------------
//  *********   FIRAXIS SOURCE CODE   ******************
//  FILE:    OnlineGameInterfaceXCom.uc
//  AUTHOR:  Timothy Talley  --  01/12/2012
//  PURPOSE: Extends the Steamworks Implementation to allow the use of Lobbies as the 
//  main source of matchmaking instead of the built in Steam Server implementation.
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class OnlineGameInterfaceXCom extends OnlineGameInterfaceSteamworks within OnlineSubsystemCommonImpl
	native
	config(Engine);

cpptext
{
	/** 
	 *  OnlineGameInterfaceSteamworks Overrides
	 */
	DWORD FindInternetGames();
	DWORD CancelFindInternetGames();
	DWORD CancelFindLanGames();
	DWORD CreateInternetGame(BYTE HostingPlayerNum);
	UBOOL JoinOnlineGame(BYTE PlayerNum,FName SessionName,const FOnlineGameSearchResult& DesiredGame);
	DWORD JoinInternetGame(BYTE PlayerNum);
	DWORD StartInternetGame();
	DWORD EndInternetGame();
	DWORD DestroyInternetGame();
	DWORD FindLanGames();
	DWORD CreateLanGame(BYTE HostingPlayerNum);
	UBOOL PublishSteamServer(const EServerMode ServerMode);
	void RefreshPublishedGameSettings();
	void TickInternetTasks(FLOAT DeltaTime);
	void UpdateGameSettingsData(UOnlineGameSettings* GameSettings, const SteamRulesMap &Rules);

	/** 
	 *  OnlineLobbyInterfaceSteamworks Functionality 
	 */

	/** Cleanup */
	void FinishDestroy();

	/** Steam callback: Lobby creation has completed */
	void OnSteamLobbyCreated(LobbyCreated_t* CallbackData);

	/** Steam callback: Joining lobby has completed */
	void OnSteamLobbyEnter(LobbyEnter_t* CallbackData);

	/** Steam callback: Lobby settings, or a lobby members settings have updated */
	void OnSteamLobbyDataUpdate(LobbyDataUpdate_t* CallbackData);

	/** Steam callback: Lobby chat state has changed (e.g. a user joining/leaving) */
	void OnSteamLobbyChatUpdate(LobbyChatUpdate_t* CallbackData);

	/** Steam callback: Lobby game has been created */
	void OnSteamLobbyGameCreated(LobbyGameCreated_t* CallbackData);

	/** @todo: If LobbyKicked_t is needed, stick it here (test it eventually anyway) */

	/** Steam callback: Lobby message received */
	void OnSteamLobbyChatMessage(LobbyChatMsg_t* CallbackData);

	/** Steam callback: Lobby search has completed */
	void OnSteamLobbyMatchList(LobbyMatchList_t* CallbackData);

	/** Steam callback: You were invited to a lobby */
	void OnSteamLobbyInvite(LobbyInvite_t* CallbackData);

	/** Steam callback: You accepted an invitation to a lobby */
	void OnSteamAcceptLobbyInvite(GameLobbyJoinRequested_t* CallbackData);

	void OnP2PSessionRequest_Client(P2PSessionRequest_t* CallbackData);
	void OnP2PSessionConnectFail_Client(P2PSessionConnectFail_t* CallbackData);
	void OnP2PSessionRequest_Server(P2PSessionRequest_t* CallbackData);
	void OnP2PSessionConnectFail_Server(P2PSessionConnectFail_t* CallbackData);


	/** 
	 *  General Functionality 
	 */

	/** Steam callback: Game server connection to Steam obtained. */
	void OnGSSteamServersConnected(SteamServersConnected_t *CallbackData);

	/** Steam callback: Game server connection to Steam lost. */
	void OnGSSteamServersDisconnected(SteamServersDisconnected_t *CallbackData);

	/** Steam callback: game server is ready. */
	void OnGSPolicyResponse(GSPolicyResponse_t *CallbackData);

	UBOOL AddGameSearchFiltersToFindLobbyList();

	/** Attempts to parse the specified lobbies settings into the target array, returning FALSE if the data needs to be requested first */
	UBOOL FillLobbySettings(TArray<FOnlineGameInterfaceXCom_LobbyMetaData>& TargetArray, FUniqueNetId LobbyId);

	/** Sets up Server details for a particular lobby, used for adding to the game search results */
	UBOOL FillServerFromLobbySettings(gameserveritem_t* Server, FUniqueNetId LobbyId);

	/** Attempts to parse the settings of a member in the specified lobby, into the target array */
	UBOOL FillMemberSettings(TArray<FOnlineGameInterfaceXCom_LobbyMetaData>& TargetArray, FUniqueNetId LobbyId, FUniqueNetId MemberId);

	struct FUniqueNetId GetLobbyIDFromCommandLine();
}

/** Tracks the SessionName of the OSSJoinGame Conclusion */
var const name CurrentSessionName;

/** Keeps track of the pending invite steam lobby id */
var const UniqueNetId PendingLobbyId;

/** Indicates that the current pending invite is a boot invite.  This will make the game interface automatically trigger accept the invite once the lobby data is retrieved. */
var bool bPendingIsBootInvite;

/** Keeps track of the active steam lobby id, either created or joined */
var const UniqueNetId CurrentLobbyId;

/** Keeps track of the active game server steam id */
var const UniqueNetId CurrentGameServerId;

/** Pointer to the class which handles callbacks from Steam */
var native pointer XComLobbyCallbackBridge{OnlineGameInterfaceXCom_LobbyCallbackBridge};

/**
 * The visibility/connectivity type of a lobby
 */
enum EOnlineGameInterfaceXCom_LobbyVisibility
{
	XLV_Public,		// Lobby is visible to everyone
	XLV_Friends,		// Visible to friends and invited players only
	XLV_Private,		// Can only join by invite
	XLV_Invisible		// @todo: Figure what this does exactly
};

/**
 * A basic key/value pair for holding various lobby settings
 */
struct native OnlineGameInterfaceXCom_LobbyMetaData
{
	var string	Key;	// The key identifying the setting
	var string	Value;	// The value of the setting
};

/** Stores Settings passed into CreateLobby, until they can be set */
var array<OnlineGameInterfaceXCom_LobbyMetaData> CreateLobbySettings;

/** Stores the UID of the created lobby, while initial lobby settings are being set asynchronously */
var const UniqueNetId PendingCreateLobbyResult;

/** The list of delegates fired when 'CreateLobby' completes */
var array<delegate<OnCreateLobbyComplete> > CreateLobbyCompleteDelegates;


/**
 * Used to specify the desired geographical distance when searching for lobbies
 */
enum EOnlineGameInterfaceXCom_LobbyDistance
{
	XLD_Best,	// Prefers close lobbies, but will search farther if none available (default)
	XLD_Close,	// Only lobbies in the same general region (low latency)
	XLD_Far,		// Returns lobbies from half way across the globe (high latency) (@todo: see if >only< returns far)
	XLD_Any		// No distance filtering; returns lobbies from anywhere
};

/**
 * Used for specifying filters based on key/value pairs, when searching for lobbies
 * NOTE: Max size of a key is 255
 */
struct native OnlineGameInterfaceXCom_LobbyFilter
{
	var string				Key;		// The key to be filtered
	var string				Value;		// The value to filter against
	var EOnlineGameSearchComparisonType	Operator;	// The operator to use for comparison

	var bool				bNumeric;	// Wether or not this filter is numeric (treated as string otherwise)
};

/**
 * Used for specifying the order in which lobby search results should be sorted
 */
struct native OnlineGameInterfaceXCom_LobbySortFilter
{
	var string	Key;		// The key to use for sorting
	var int		TargetValue;	// The value to sort upon (the closer a key is to this value, the higher up in the results)
};

/**
 * Struct describing basic information about a lobby, typically from a lobby search result
 */
struct native OnlineGameInterfaceXCom_BasicLobbyInfo
{
	var const UniqueNetId		LobbyUID;	// The unique id of the lobby
	var const array<OnlineGameInterfaceXCom_LobbyMetaData>	LobbySettings;	// The list of settings read for this lobby
};


/** Wether or not a lobby search is in progress */
var const bool bLobbySearchInProgress;

/** Stores the most recent results from 'FindLobbies'; the 'LobbyList' parameter for 'OnFindLobbiesComplete' directly references this property */
var const array<OnlineGameInterfaceXCom_BasicLobbyInfo> CachedFindLobbyResults;

/** The list of delegates fired when 'FindLobbies' completes */
var array<delegate<OnFindLobbiesComplete> > FindLobbiesCompleteDelegates;


/**
 * Describes information about a member of a lobby we are active in
 */
struct native OnlineGameInterfaceXCom_LobbyMember
{
	var const UniqueNetId		PlayerUID;	// The unique id of the player
	var const array<OnlineGameInterfaceXCom_LobbyMetaData>	PlayerSettings;	// The list of settings read for this player

	// @todo: Decide wether or not to put extra fields here, e.g. avatar/community-name etc. (may be best to leave that up
	//	to the actual ingame implementation of lobbies)
};

/**
 * Describes all available information about a lobby we are active in
 */
struct native OnlineGameInterfaceXCom_ActiveLobbyInfo extends OnlineGameInterfaceXCom_BasicLobbyInfo
{
	var const array<OnlineGameInterfaceXCom_LobbyMember>	Members;	// The list of members of a lobby we are in
};


/** Lobbies the player is currently connected to; many callback delegates have out parameters directly referencing this property */
var const array<OnlineGameInterfaceXCom_ActiveLobbyInfo> ActiveLobbies;

/** The list of delegates fired when 'JoinLobby' completes */
var array<delegate<OnJoinLobbyComplete> > JoinLobbyCompleteDelegates;

/** Determines the set of keys that should be read from lobby members */
var config array<string> LobbyMemberKeys;

/** The list of delegates fired when a lobbies settings are updated */
var array<delegate<OnLobbySettingsUpdate> > LobbySettingsUpdateDelegates;

/** The list of delegates fired when a lobby members settings are updated */
var array<delegate<OnLobbyMemberSettingsUpdate> > LobbyMemberSettingsUpdateDelegates;

/** The list of delegates fired when a lobby members status has changed */
var array<delegate<OnLobbyMemberStatusUpdate> > LobbyMemberStatusUpdateDelegates;

/** The list of delegates fired when a message is received from a lobby */
var array<delegate<OnLobbyReceiveMessage> > LobbyReceiveMessageDelegates;

/** The list of delegates fired when binary data is received from a lobby */
var array<delegate<OnLobbyReceiveBinaryData> > LobbyReceiveBinaryDataDelegates;

/** Stores the most recently received binary from a lobby; the 'Data' parameter for 'OnLobbyReceiveBinaryData' directly references this property */
var const array<byte> CachedBinaryData;

/** The list of delegates fired when a lobby directs players to join a server */
var array<delegate<OnLobbyJoinGame> > LobbyJoinGameDelegates;

/** The list of delegates fired when the player receives or accepts a lobby invite */
var array<delegate<OnLobbyInvite> > LobbyInviteDelegates;

/** Makes sure that the delegates are not setup multiple times */
var bool bDelegatesAdded;

// @todo: Add bools here, which locks the arrays being passed as out parameters, and spits out a log warning if anything tries to modify them
//		while they are being accessed like this (this is important, even though you are not doing a compiler hack to pass array elements)


/** Sets up native callback bridges */
native function bool InitGameInterface();

/** Connects to the LAN IP or the Internet steam.#### address */
native function bool GetResolvedConnectString(name SessionName,out string ConnectInfo);

/** Updates Steam with the current lobby settings */
native function bool RefreshPublishLobbySettings();

/** Configures server (GSteamServer) and lobby (CurrentLobbyId) data by setting key=>value data */
native function bool SetSteamData(string key, string value);

native function bool PublishSteamServer();

///
/// Debug functionality
///
native function bool SendP2PData(UniqueNetId SteamId, array<byte> Data, optional bool bForceClient=false);
native function bool ReadP2PData(out array<byte> Data, out UniqueNetId SteamId, optional bool bForceClient=false);
native function bool AcceptP2PSessionWithUser(UniqueNetId SteamId, optional bool bForceClient=false);
native function bool CloseP2PSessionWithUser(UniqueNetId SteamId, optional bool bForceClient=false);
native function AllowP2PPacketRelay(bool bAllow, optional bool bForceClient=false);
native function bool GetP2PSessionState(UniqueNetId SteamId, optional bool bForceClient=false);

/**
 * Creates a lobby, joins it, and optionally assigns its initial settings, triggering callbacks when done
 *
 * @param MaxPlayers		The maximum number of lobby members
 * @param Type			The type of lobby to setup (public/private/etc.)
 * @param InitialSettings	The list of settings to apply to the lobby upon creation
 * @return			Returns True if successful, False otherwise
 */
native function bool CreateLobby(int MaxPlayers, optional EOnlineGameInterfaceXCom_LobbyVisibility Type, optional array<OnlineGameInterfaceXCom_LobbyMetaData> InitialSettings);

/**
 * Called when 'CreateLobby' completes, returning success/failure, and (if successful) the new lobby UID
 *
 * @param bWasSuccessful	Wether or not 'CreateLobby' was successful
 * @param LobbyId		If successful, the UID of the new lobby
 * @param Error			If lobby creation failed, returns the error type
 */
delegate OnCreateLobbyComplete(bool bWasSuccessful, UniqueNetId LobbyId, string Error);

/**
 * Sets the delegate used to notify when a call to 'CreateLobby' has completed
 *
 * @param CreateLobbyCompleteDelegate	The delegate to use for notifications
 */
function AddCreateLobbyCompleteDelegate(delegate<OnCreateLobbyComplete> CreateLobbyCompleteDelegate)
{
	if (CreateLobbyCompleteDelegates.Find(CreateLobbyCompleteDelegate) == INDEX_None)
	{
		CreateLobbyCompleteDelegates[CreateLobbyCompleteDelegates.Length] = CreateLobbyCompleteDelegate;
	}
}

/**
 * Removes the specified delegate from the notification list
 *
 * @param CreateLobbyCompleteDelegate	The delegate to remove from the list
 */
function ClearCreateLobbyCompleteDelegate(delegate<OnCreateLobbyComplete> CreateLobbyCompleteDelegate)
{
	local int i;

	i = CreateLobbyCompleteDelegates.Find(CreateLobbyCompleteDelegate);

	if (i != INDEX_None)
	{
		CreateLobbyCompleteDelegates.Remove(i, 1);
	}
}

/**
 * Kicks off a search for available lobbies, matching the specified filters, triggering callbacks when done
 * @todo: Clean up the parameter list here, it's quite messy
 * @todo: It may be best to roll up the 'distance' filter, as a hardcoded filter key in the 'Filters' list; this standardizes
 *		the lobby implementation a bit more, allowing other subsystems to use it
 *
 * @param MaxResults	The maximum number of results to return
 * @param Filters	Filters used for restricting returned lobbies
 * @param SortFilters	Influences sorting of the returned lobby list, with the first filter influencing the most
 * @param MinSlots	Minimum required number of open slots (@todo: Test to see this doesn't list >exact< number of slots)
 * @param Distance	The desired geographical distance of returned lobbies
 * @return		Returns True if successful, False otherwise
 */
native function bool FindLobbies(optional int MaxResults=32, optional array<OnlineGameInterfaceXCom_LobbyFilter> Filters, optional array<OnlineGameInterfaceXCom_LobbySortFilter> SortFilters,
					optional int MinSlots, optional EOnlineGameInterfaceXCom_LobbyDistance Distance=XLD_Best);

/**
 * Updates the lobby settings for all current lobby search results, and removes lobbies if they have become invalid
 * NOTE: Triggers OnFindLobbiesComplete when done
 * @todo: See if you really want this (could be used to update lobby search results, as well as grab more info for specific lobbies a lobby
 *		when passing bUIDOnly to FindLobbies
 * @todo: Should this really trigger OnFindLobbiesComplete when done? That returns the entire lobby list
 *
 * @param LobbyId	Allows you to specify the id of one particular lobby you want to update
 * @return		Returns True if successful, False otherwise
 */
native function bool UpdateFoundLobbies(optional UniqueNetId LobbyId);

/**
 * Called when 'FindLobbies' completes, returning success/failure, and (if successful) the final lobby list
 *
 * @param bWasSuccessful	Wether or not 'FindLobbies' was successful
 * @param LobbyList		The list of returned lobbies
 */
delegate OnFindLobbiesComplete(bool bWasSuccessful, const out array<OnlineGameInterfaceXCom_BasicLobbyInfo> LobbyList);

/**
 * Triggers all 'OnFindLobbiesComplete' delegates; done from UScript, as C++ can't pass CachedFindLobbyResults as an out parameter, without copying
 *
 * @param bWasSuccessful	Wether or not 'FindLobbies' was successful
 */
event TriggerFindLobbiesCompleteDelegates(bool bWasSuccessful)
{
	local array<delegate<OnFindLobbiesComplete> > DelList;
	local delegate<OnFindLobbiesComplete> CurDel;

	DelList = FindLobbiesCompleteDelegates;

	foreach DelList(CurDel)
	{
		CurDel(bWasSuccessful, CachedFindLobbyResults);
	}
}

/**
 * Sets the delegate used to notify when a call to 'FindLobbies' has completed
 *
 * @param FindLobbiesCompleteDelegate	The delegate to use for notifications
 */
function AddFindLobbiesCompleteDelegate(delegate<OnFindLobbiesComplete> FindLobbiesCompleteDelegate)
{
	if (FindLobbiesCompleteDelegates.Find(FindLobbiesCompleteDelegate) == INDEX_None)
		FindLobbiesCompleteDelegates[FindLobbiesCompleteDelegates.Length] = FindLobbiesCompleteDelegate;
}

/**
 * Removes the specified delegate from the notification list
 *
 * @param FindLobbiesCompleteDelegate	The delegate to remove from the list
 */
function ClearFindLobbiesCompleteDelegate(delegate<OnFindLobbiesComplete> FindLobbiesCompleteDelegate)
{
	local int i;

	i = FindLobbiesCompleteDelegates.Find(FindLobbiesCompleteDelegate);

	if (i != INDEX_None)
		FindLobbiesCompleteDelegates.Remove(i, 1);
}


/**
 * Joins the specified lobby, triggering callbacks when done
 *
 * @param LobbyId	The unique id of the lobby to join
 * @return		Returns True if successful, False otherwise
 */
native function bool JoinLobby(UniqueNetId LobbyId);

/**
 * Called when 'JoinLobby' completes, returning success/failure, and (if successful) the full lobby info
 *
 * @param bWasSuccessful	Wether or not 'JoinLobby' was successful
 * @param LobbyList		The list of active lobbies
 * @param LobbyIndex		The index of the lobby we joined
 * @param LobbyUID		The UID of the lobby (for when joining failed, and there is no valid LobbyIndex)
 * @param Error			If 'JoinLobby' failed, returns the error type
 */
delegate OnJoinLobbyComplete(bool bWasSuccessful, const out array<OnlineGameInterfaceXCom_ActiveLobbyInfo> LobbyList, int LobbyIndex, UniqueNetId LobbyUID, string Error);

/**
 * Triggers all 'OnJoinLobbyComplete' delegates; done from UScript, as C++ can't pass ActiveLobbies as an out parameter, without copying it
 *
 * @param bWasSuccessful	Wether or not 'JoinLobby' was successful
 * @param LobbyIndex		The index of the lobby we joined
 * @param LobbyUID		The UID of the lobby (for when joining failed, and there is no valid LobbyIndex)
 * @param Error			If 'JoinLobby' failed, returns the error type
 */
event TriggerJoinLobbyCompleteDelegates(bool bWasSuccessful, int LobbyIndex, UniqueNetId LobbyUID, string Error)
{
	local array<delegate<OnJoinLobbyComplete> > DelList;
	local delegate<OnJoinLobbyComplete> CurDel;

	DelList = JoinLobbyCompleteDelegates;

	foreach DelList(CurDel)
	{
		CurDel(bWasSuccessful, ActiveLobbies, LobbyIndex, LobbyUID, Error);
	}
}

/**
 * Sets the delegate used to notify when a call to 'JoinLobby' has completed
 *
 * @param JoinLobbyCompleteDelegate	The delegate to use for notifications
 */
function AddJoinLobbyCompleteDelegate(delegate<OnJoinLobbyComplete> JoinLobbyCompleteDelegate)
{
	if (JoinLobbyCompleteDelegates.Find(JoinLobbyCompleteDelegate) == INDEX_None)
		JoinLobbyCompleteDelegates[JoinLobbyCompleteDelegates.Length] = JoinLobbyCompleteDelegate;
}

/**
 * Removes the specified delegate from the notification list
 *
 * @param JoinLobbyCompleteDelegate	The delegate to remove from the list
 */
function ClearJoinLobbyCompleteDelegate(delegate<OnJoinLobbyComplete> JoinLobbyCompleteDelegate)
{
	local int i;

	i = JoinLobbyCompleteDelegates.Find(JoinLobbyCompleteDelegate);

	if (i != INDEX_None)
		JoinLobbyCompleteDelegates.Remove(i, 1);
}

/**
 * Exits the specified lobby; always returns True, and has no callbacks
 * @todo: Is the corresponding callback for this 'OnLobbyKicked', since it says that is triggered upon disconnect as well?
 *
 * @param LobbyId	The UID of the lobby to exit
 * @return		Returns True if successful, False otherwise
 */
native function bool LeaveLobby(UniqueNetId LobbyId);


/**
 * Changes the value of a setting for the local user in the specified lobby
 * NOTE: You should specify any keys you set, in the 'LobbyMemberKeys' config array; otherwise they aren't read
 *
 * @param LobbyId	The UID of the lobby where the change is to be applied
 * @param Key		The name of the setting to change
 * @param Value		The new value of the setting
 */
native function bool SetLobbyUserSetting(UniqueNetId LobbyId, string Key, string Value);

/**
 * Sends a chat message to the specified lobby
 *
 * @param LobbyId	The UID of the lobby where the message should be sent
 * @param Message	The message to send to the lobby
 * @return		Returns True if the message was sent successfully, False otherwise
 */
native function bool SendLobbyMessage(UniqueNetId LobbyId, string Message);

/**
 * Sends binary data to the specified lobby
 *
 * @param LobbyId	The UID of the lobby where the data should be sent
 * @param Data		The binary data which should be sent to the lobby (limit of around 2048 bytes)
 */
native function bool SendLobbyBinaryData(UniqueNetId LobbyId, const out array<byte> Data);

/**
 * Called when lobby settings have been updated
 *
 * @param LobbyList		The list of active lobbies
 * @param LobbyIndex		The index of the lobby whose settings have been updated
 */
delegate OnLobbySettingsUpdate(const out array<OnlineGameInterfaceXCom_ActiveLobbyInfo> LobbyList, int LobbyIndex);

/**
 * Triggers all 'OnLobbySettingsUpdate' delegates; done from UScript, as C++ can't pass ActiveLobbies as an out parameter, without copying it
 *
 * @param LobbyIndex		The index of the lobby whose settings have been updated
 */
event TriggerLobbySettingsUpdateDelegates(int LobbyIndex)
{
	local array<delegate<OnLobbySettingsUpdate> > DelList;
	local delegate<OnLobbySettingsUpdate> CurDel;

	DelList = LobbySettingsUpdateDelegates;

	foreach DelList(CurDel)
	{
		CurDel(ActiveLobbies, LobbyIndex);
	}
}

/**
 * Sets the delegate used to notify when a lobbies settings have updated
 *
 * @param LobbySettingsUpdateDelegate	The delegate to use for notifications
 */
function AddLobbySettingsUpdateDelegate(delegate<OnLobbySettingsUpdate> LobbySettingsUpdateDelegate)
{
	if (LobbySettingsUpdateDelegates.Find(LobbySettingsUpdateDelegate) == INDEX_None)
		LobbySettingsUpdateDelegates[LobbySettingsUpdateDelegates.Length] = LobbySettingsUpdateDelegate;
}

/**
 * Removes the specified delegate from the notification list
 *
 * @param LobbySettingsUpdateDelegate	The delegate to remove from the list
 */
function ClearLobbySettingsUpdateDelegate(delegate<OnLobbySettingsUpdate> LobbySettingsUpdateDelegate)
{
	local int i;

	i = LobbySettingsUpdateDelegates.Find(LobbySettingsUpdateDelegate);

	if (i != INDEX_None)
		LobbySettingsUpdateDelegates.Remove(i, 1);
}

/**
 * Called when the settings of a specific lobby member have been updated
 *
 * @param LobbyList		The list of active lobbies
 * @param LobbyIndex		The index of the lobby
 * @param MemberIndex		The index of the member whose settings have been updated
 */
delegate OnLobbyMemberSettingsUpdate(const out array<OnlineGameInterfaceXCom_ActiveLobbyInfo> LobbyList, int LobbyIndex, int MemberIndex);

/**
 * Triggers all 'OnLobbyMemberSettingsUpdate' delegates; done from UScript, as C++ can't pass ActiveLobbies as an out parameter, without copying it
 * @param LobbyIndex		The index of the lobby
 * @param MemberIndex		The index of the member whose settings have been updated
 */
event TriggerLobbyMemberSettingsUpdateDelegates(int LobbyIndex, int MemberIndex)
{
	local array<delegate<OnLobbyMemberSettingsUpdate> > DelList;
	local delegate<OnLobbyMemberSettingsUpdate> CurDel;

	DelList = LobbyMemberSettingsUpdateDelegates;

	foreach DelList(CurDel)
	{
		CurDel(ActiveLobbies, LobbyIndex, MemberIndex);
	}
}

/**
 * Sets the delegate used to notify when a lobby members settings have been updated
 *
 * @param LobbyMemberSettingsUpdateDelegate		The delegate to use for notifications
 */
function AddLobbyMemberSettingsUpdateDelegate(delegate<OnLobbyMemberSettingsUpdate> LobbyMemberSettingsUpdateDelegate)
{
	if (LobbyMemberSettingsUpdateDelegates.Find(LobbyMemberSettingsUpdateDelegate) == INDEX_None)
		LobbyMemberSettingsUpdateDelegates[LobbyMemberSettingsUpdateDelegates.Length] = LobbyMemberSettingsUpdateDelegate;
}

/**
 * Removes the specified delegate from the notification list
 *
 * @param LobbyMemberSettingsUpdateDelegate 	The delegate to remove from the list
 */
function ClearLobbyMemberSettingsUpdateDelegate(delegate<OnLobbyMemberSettingsUpdate> LobbyMemberSettingsUpdateDelegate)
{
	local int i;

	i = LobbyMemberSettingsUpdateDelegates.Find(LobbyMemberSettingsUpdateDelegate);

	if (i != INDEX_None)
		LobbyMemberSettingsUpdateDelegates.Remove(i, 1);
}

/**
 * Called when the status of a lobby member changes (e.g. entering/leaving)
 * NOTE: If the lobby member was kicked/banned, InstigatorIndex is set to the lobby member who kicked/banned the player
 *
 * @param LobbyList		The list of active lobbies
 * @param LobbyIndex		The index of the lobby
 * @param MemberIndex		The index of the member whose status has changed
 * @param InstigatorIndex	The index of the member (probably admin) who changed the other members status (may be INDEX_None)
 * @param Status		The new status of the member
 */
delegate OnLobbyMemberStatusUpdate(const out array<OnlineGameInterfaceXCom_ActiveLobbyInfo> LobbyList, int LobbyIndex, int MemberIndex, int InstigatorIndex,
					string Status);

/**
 * Triggers all 'OnLobbyMemberStatusUpdate' delegates; done from UScript, as C++ can't pass ActiveLobbies as an out parameter, without copying it
 *
 * @param LobbyIndex		The index of the lobby
 * @param MemberIndex		The index of the member whose status has changed
 * @param InstigatorIndex	The index of the member (probably admin) who changed the other members status (may be INDEX_None)
 * @param Status		The new status of the member
 */
event TriggerLobbyMemberStatusUpdateDelegates(int LobbyIndex, int MemberIndex, int InstigatorIndex, string Status)
{
	local array<delegate<OnLobbyMemberStatusUpdate> > DelList;
	local delegate<OnLobbyMemberStatusUpdate> CurDel;

	DelList = LobbyMemberStatusUpdateDelegates;

	foreach DelList(CurDel)
	{
		CurDel(ActiveLobbies, LobbyIndex, MemberIndex, InstigatorIndex, Status);
	}
}

/**
 * Sets the delegate used to notify when a lobby members status has changed
 *
 * @param LobbyMemberStatusUpdateDelegate	The delegate to use for notifications
 */
function AddLobbyMemberStatusUpdateDelegate(delegate<OnLobbyMemberStatusUpdate> LobbyMemberStatusUpdateDelegate)
{
	if (LobbyMemberStatusUpdateDelegates.Find(LobbyMemberStatusUpdateDelegate) == INDEX_None)
		LobbyMemberStatusUpdateDelegates[LobbyMemberStatusUpdateDelegates.Length] = LobbyMemberStatusUpdateDelegate;
}

/**
 * Removes the specified delegate from the notification list
 *
 * @param LobbyMemberStatusUpdateDelegate	The delegate to remove from the list
 */
function ClearLobbyMemberStatusUpdateDelegate(delegate<OnLobbyMemberStatusUpdate> LobbyMemberStatusUpdateDelegate)
{
	local int i;

	i = LobbyMemberStatusUpdateDelegates.Find(LobbyMemberStatusUpdateDelegate);

	if (i != INDEX_None)
		LobbyMemberStatusUpdateDelegates.Remove(i, 1);
}


/**
 * Called when a chat message has been received from the lobby
 * @todo: Remove 'Type' if it's not used by Steam
 *
 * @param LobbyList	The list of active lobbies
 * @param LobbyIndex	The index of the lobby the message came from
 * @param MemberIndex	The index of the member the message is from
 * @param Type		The type of message (chat/is-typing/game-starting/etc.)
 * @param Message	The actual message
 */
delegate OnLobbyReceiveMessage(const out array<OnlineGameInterfaceXCom_ActiveLobbyInfo> LobbyList, int LobbyIndex, int MemberIndex, string Type, string Message);

/**
 * Triggers all 'OnLobbyReceiveMessage' delegates; done from UScript, as C++ can't pass ActiveLobbies as an out parameter, without copying it
 *
 * @param LobbyIndex	The index of the lobby the message came from
 * @param MemberIndex	The index of the member the message is from
 * @param Type		The type of message (chat/is-typing/game-starting/etc.)
 * @param Message	The actual message
 */
event TriggerLobbyReceiveMessageDelegates(int LobbyIndex, int MemberIndex, string Type, string Message)
{
	local array<delegate<OnLobbyReceiveMessage> > DelList;
	local delegate<OnLobbyReceiveMessage> CurDel;

	DelList = LobbyReceiveMessageDelegates;

	foreach DelList(CurDel)
	{
		CurDel(ActiveLobbies, LobbyIndex, MemberIndex, Type, Message);
	}
}

/**
 * Sets the delegate used to notify when a lobby message is received
 *
 * @param LobbyReceiveMessageDelegate		The delegate to use for notifications
 */
function AddLobbyReceiveMessageDelegate(delegate<OnLobbyReceiveMessage> LobbyReceiveMessageDelegate)
{
	if (LobbyReceiveMessageDelegates.Find(LobbyReceiveMessageDelegate) == INDEX_None)
		LobbyReceiveMessageDelegates[LobbyReceiveMessageDelegates.Length] = LobbyReceiveMessageDelegate;
}

/**
 * Removes the specified delegate from the notification list
 *
 * @param LobbyReceiveMessageDelegate		The delegate to remove from the list
 */
function ClearLobbyReceiveMessageDelegate(delegate<OnLobbyReceiveMessage> LobbyReceiveMessageDelegate)
{
	local int i;

	i = LobbyReceiveMessageDelegates.Find(LobbyReceiveMessageDelegate);

	if (i != INDEX_None)
		LobbyReceiveMessageDelegates.Remove(i, 1);
}

/**
 * Called when a binary message has been received from the lobby
 *
 * @param LobbyList	The list of active lobbies
 * @param LobbyIndex	The index of the lobby the message came from
 * @param MemberIndex	The index of the member the message is from
 * @param Data		The received binary data
 */
delegate OnLobbyReceiveBinaryData(const out array<OnlineGameInterfaceXCom_ActiveLobbyInfo> LobbyList, int LobbyIndex, int MemberIndex, const out array<byte> Data);

/**
 * Triggers all 'OnLobbyReceiveBinaryData' delegates; done from UScript, as C++ can't pass ActiveLobbies/CachedBinaryData as out parameters
 *
 * @param LobbyIndex	The index of the lobby the message came from
 * @param MemberIndex	The index of the member the message is from
 */
event TriggerLobbyReceiveBinaryDataDelegates(int LobbyIndex, int MemberIndex)
{
	local array<delegate<OnLobbyReceiveBinaryData> > DelList;
	local delegate<OnLobbyReceiveBinaryData> CurDel;

	DelList = LobbyReceiveBinaryDataDelegates;

	foreach DelList(CurDel)
	{
		CurDel(ActiveLobbies, LobbyIndex, MemberIndex, CachedBinaryData);
	}
}

/**
 * Sets the delegate used to notify when binary data is received from a lobby
 *
 * @param LobbyReceiveMessageDelegate		The delegate to use for notifications
 */
function AddLobbyReceiveBinaryDataDelegate(delegate<OnLobbyReceiveBinaryData> LobbyReceiveBinaryDataDelegate)
{
	if (LobbyReceiveBinaryDataDelegates.Find(LobbyReceiveBinaryDataDelegate) == INDEX_None)
		LobbyReceiveBinaryDataDelegates[LobbyReceiveBinaryDataDelegates.Length] = LobbyReceiveBinaryDataDelegate;
}

/**
 * Removes the specified delegate from the notification list
 *
 * @param LobbyReceiveBinaryDataDelegate	The delegate to remove from the list
 */
function ClearLobbyReceiveBinaryDataDelegate(delegate<OnLobbyReceiveBinaryData> LobbyReceiveBinaryDataDelegate)
{
	local int i;

	i = LobbyReceiveBinaryDataDelegates.Find(LobbyReceiveBinaryDataDelegate);

	if (i != INDEX_None)
		LobbyReceiveBinaryDataDelegates.Remove(i, 1);
}

/**
 * Called when the lobby activity has completed, and the player is directed towards a server
 * NOTE: Player does not automatically leave the lobby when this is triggered
 *
 * @param LobbyList	The list of active lobbies
 * @param LobbyIndex	The index of the lobby making the join-game request
 * @param ServerId	The UID of the server to join
 * @param ServerIP	The IP of the server to join
 */
delegate OnLobbyJoinGame(const out array<OnlineGameInterfaceXCom_ActiveLobbyInfo> LobbyList, int LobbyIndex, UniqueNetId ServerId, string ServerIP);

/**
 * Triggers all 'OnLobbyJoinGame' delegates; done from UScript, as C++ can't pass ActiveLobbies as an out parameter, without copying it
 *
 * @param LobbyIndex	The index of the lobby making the join-game request
 * @param ServerId	The UID of the server to join
 * @param ServerIP	The IP of the server to join
 */
event TriggerLobbyJoinGameDelegates(int LobbyIndex, UniqueNetId ServerId, string ServerIP)
{
	local array<delegate<OnLobbyJoinGame> > DelList;
	local delegate<OnLobbyJoinGame> CurDel;

	DelList = LobbyJoinGameDelegates;

	foreach DelList(CurDel)
	{
		CurDel(ActiveLobbies, LobbyIndex, ServerId, ServerIP);
	}
}

/**
 * Sets the delegate used to notify when a lobby directs the player towards a server
 *
 * @param LobbyJoinGameDelegate		The delegate to use for notifications
 */
function AddLobbyJoinGameDelegate(delegate<OnLobbyJoinGame> LobbyJoinGameDelegate)
{
	if (LobbyJoinGameDelegates.Find(LobbyJoinGameDelegate) == INDEX_None)
		LobbyJoinGameDelegates[LobbyJoinGameDelegates.Length] = LobbyJoinGameDelegate;
}

/**
 * Removes the specified delegate from the notification list
 *
 * @param LobbyJoinGameDelegate		The delegate to remove from the list
 */
function ClearLobbyJoinGameDelegate(delegate<OnLobbyJoinGame> LobbyJoinGameDelegate)
{
	local int i;

	i = LobbyJoinGameDelegates.Find(LobbyJoinGameDelegate);

	if (i != INDEX_None)
		LobbyJoinGameDelegates.Remove(i, 1);
}

/**
 * Called when the
 * @todo: IMPORTANT: It is suggested by searching the Steam partner documentation, that this may not even be implemented;
 *		remove it if you can't test it, and don't implement this callback until you have tested the native part
 * @todo: Should this be named OnLobbyDisconnect? Does this get called when the player leaves a lobby through LeaveLobby?
 * @todo: Update this to take a const out array, with an index
 */
delegate OnLobbyKicked(const out array<OnlineGameInterfaceXCom_ActiveLobbyInfo> LobbyList, int LobbyIndex, int AdminIndex);


/**
 * Returns the UID of the person who is admin of the specified lobby
 *
 * @param LobbyId	The UID of the lobby to check
 * @param AdminId	Outputs the UID of the lobby admin
 * @return		Returns True if successful, False otherwise
 */
native function bool GetLobbyAdmin(UniqueNetId LobbyId, out UniqueNetId AdminId);

/**
 * Sets the value of a specified setting, in the specified lobby
 * NOTE: Admin-only
 *
 * @param LobbyId	The UID of the lobby where the setting should be changed
 * @param Key		The name of the setting to change
 * @param Value		The new value for the setting
 * @return		Returns True if successful, False otherwise
 */
native function bool SetLobbySetting(UniqueNetId LobbyId, string Key, string Value);

/**
 * Removes the specified setting, from the specified lobby
 * NOTE: Admin-only
 *
 * @param LobbyId	The UID of the lobby where the setting should be removed
 * @param Key		The name of the setting to remove
 * @return		Returns True if successful, False otherwise
 */
native function bool RemoveLobbySetting(UniqueNetId LobbyId, string Key);

/**
 * Sets the game server to be joined for the specified lobby
 * NOTE: Admin-only
 *
 * @param LobbyId	The UID of the lobby where the game server should be set
 * @param ServerUID	The UID of the game server
 * @param ServerIP	The IP address of the game server
 * @return		Returns True if successful, False otherwise
 */
native function bool SetLobbyServer(UniqueNetId LobbyId, UniqueNetId ServerUID, string ServerIP);

/**
 * Changes the visibility/connectivity type for the specified lobby
 * NOTE: Admin-only
 *
 * @param LobbyId	The UID of the lobby where the change should be made
 * @param Type		The new visibility/connectivity type for the lobby
 * @return		Returns True if successful, False otherwise
 */
native function bool SetLobbyType(UniqueNetId LobbyId, EOnlineGameInterfaceXCom_LobbyVisibility Type);

/**
 * Locks/unlocks the specified lobby (i.e. sets wether or not people can join it, regardless of friend/invite status)
 * NOTE: Admin-only
 *
 * @param LobbyId	The UID of the lobby to be locked/unlocked
 * @param bLocked	Wether to lock or unlock the lobby
 * @return		Returns True if successful, False otherwise
 */
native function bool SetLobbyLock(UniqueNetId LobbyId, bool bLocked);

/**
 * Changes the owner of the specfied lobby
 * NOTE: Admin-only
 *
 * @param LobbyId	The UID of the lobby where ownership should be changed
 * @param NewOwner	The UID of the new lobby owner (must be present in lobby)
 */
native function bool SetLobbyOwner(UniqueNetId LobbyId, UniqueNetId NewOwner);

/**
 * Invites a player to the specified lobby
 *
 * @param LobbyId	The UID of the lobby to invite the player to
 * @param PlayerId	The UID of the player to invite
 * @return		Returns True if the invitation was sent successfully, False otherwise
 */
native function bool InviteToLobby(UniqueNetId LobbyId, UniqueNetId PlayerId);

/**
 * Called when the user receives or accepts a lobby invite
 *
 * @param LobbyId	The UID of the lobby the player was invited to
 * @param FriendId	The UID of the player who invited the user to the lobby (may be invalid, if not invited directly by a friend)
 * @param bAccepted	Wether or not the player has already accepted the invite
 */
delegate OnLobbyInvite(UniqueNetId LobbyId, UniqueNetId FriendId, bool bAccepted);

/**
 * Sets the delegate used to notify when the player receives or accepts a lobby invite
 *
 * @param AcceptLobbyInviteDelegate	The delegate to use for notifications
 */
function AddLobbyInviteDelegate(delegate<OnLobbyInvite> LobbyInviteDelegate)
{
	if (LobbyInviteDelegates.Find(LobbyInviteDelegate) == INDEX_None)
		LobbyInviteDelegates[LobbyInviteDelegates.Length] = LobbyInviteDelegate;
}

/**
 * Removes the specifed delegate from the notification list
 *
 * @param LobbyInviteDelegate	The delegate to remove from the list
 */
function ClearLobbyInviteDelegate(delegate<OnLobbyInvite> LobbyInviteDelegate)
{
	local int i;

	i = LobbyInviteDelegates.Find(LobbyInviteDelegate);

	if (i != INDEX_None)
		LobbyInviteDelegates.Remove(i, 1);
}

/**
 * If the player accepted a lobby invite from outside of the game, this grabs the lobby UID from the commandline
 *
 * @param LobbyId		Outputs the UID of the lobby to be joined
 * @param bMarkAsJoined		Set this when the lobby is joined; future calls to this function will return False, but will still output the UID
 * @return			Returns True if a lobby UID is on the commandline, but returns False if it has been joined
 */
native function bool GetLobbyFromCommandline(out UniqueNetId LobbyId, optional bool bMarkAsJoined=True);

/**
 * Displays the received invites ui
 *
 * @param LocalUserNum the local user sending the invite
 */
native function bool ShowReceivedInviteUI(byte LocalUserNum);

/**
 * Used to determine if the game was launched from an external invite system.
 * 
 * @return the system was booted from an invite
 */
native function bool GameBootIsFromInvite();

/**
 * Since the system needs to be initialized prior to the setting of any invitations, 
 * this will make sure that the boot invitation data is set properly.
 */
native function SetupGameBootInvitation(optional bool bIgnoreBootCheck=false);


//
// Subsystem hookups
//

native function OnSteamServersConnected();
native function OnSteamServersConnectFailure();
native function OnSteamServersDisconnected();

event SetupConnectionDelegates()
{
	if ( !bDelegatesAdded )
	{
		bDelegatesAdded = true;
		OnlineSubsystemSteamworks(OwningSubsystem).AddConnectionStatusChangeDelegate(OnConnectionStatusChange);
	}
}

event SetPendingIsBootInvite(bool bIsBootInvite)
{
	bPendingIsBootInvite = bIsBootInvite;
}

function OnConnectionStatusChange(EOnlineServerConnectionStatus ConnectionStatus)
{
	switch(ConnectionStatus)
	{
		case OSCS_Connected:
			OnSteamServersConnected();
			break;
		case OSCS_ConnectionDropped:
			OnSteamServersDisconnected();
			break;
		case OSCS_NoNetworkConnection:
		case OSCS_ServiceUnavailable:
		case OSCS_UpdateRequired:
		case OSCS_ServersTooBusy:
		case OSCS_DuplicateLoginDetected:
		case OSCS_InvalidUser:
			OnSteamServersConnectFailure();
			break;
		default:
			break;
	}
}

defaultproperties
{
	bDelegatesAdded=false
	bPendingIsBootInvite=false
}