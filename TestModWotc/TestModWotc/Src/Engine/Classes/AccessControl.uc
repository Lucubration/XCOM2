//=============================================================================
// AccessControl.
//
// AccessControl is a helper class for GameInfo.
// The AccessControl class determines whether or not the player is allowed to
// login in the PreLogin() function, controls whether or not a player can enter
// as a spectator or a game administrator, and handles authentication of
// clients with the online subsystem (including the listen server host).
//
// Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
//=============================================================================
class AccessControl extends Info
	dependson(OnlineAuthInterfaceBaseImpl)
	config(Game);

/** Contains policies for allowing/denying IP addresses */
var globalconfig array<string>		IPPolicies;

/** Contains the list of banned UIDs */
var globalconfig array<UniqueNetID>	BannedIDs;


/** Various localized strings */
var localized string			IPBanned;
var localized string			WrongPassword;
var localized string			NeedPassword;
var localized string			SessionBanned;
var localized string			KickedMsg;
var localized string			DefaultKickReason;
var localized string			IdleKickReason;


var class<Admin>			AdminClass;

/** Password required for admin privileges */
var private globalconfig string		AdminPassword;

/** Password required to enter the game */
var private globalconfig string		GamePassword;

var localized string			ACDisplayText[3];
var localized string			ACDescText[3];

var bool				bDontAddDefaultAdmin;

/** On seamless travel this is set to True, so the new GameInfo after seamless travel knows to initialize with this */
var bool				bPendingPostSeamlessInit;


/** Wether or not to authenticate clients (specifically their UID's) when they join; client UID's can't be trusted until they are authenticated */
var globalconfig bool			bAuthenticateClients;

/** Wether or not to authenticate the game server with clients; a client must be fully authenticated before it can authenticate the server */
var globalconfig bool			bAuthenticateServer;

/** Wether or not to authenticate the listen host, on lists servers */
var globalconfig bool			bAuthenticateListenHost;

/** The maximum number of times to retry authentication */
var globalconfig int			MaxAuthRetryCount;

/** The delay between authentication attempts */
var globalconfig int			AuthRetryDelay;


/** Caches a local reference to the online subsystem */
var OnlineSubsystem			OnlineSub;

/** Caches a local reference to the online subsystems auth interface, if it has one set */
var OnlineAuthInterfaceBaseImpl		CachedAuthInt;


/** Struct used for tracking clients pending authentication */
struct PendingClientAuth
{
	var Player	ClientConnection;	// The NetConnection of the client pending auth
	var UniqueNetId	ClientUID;		// The UID of the client

	var float	AuthTimestamp;		// The timestamp for when authentication was started
	var int		AuthRetryCount;		// The number of times authentication has been retried for this client
};

/** Tracks clients who are currently pending authentication */
var array<PendingClientAuth>		ClientsPendingAuth;


/** Struct used for tracking server auth retry counts */
struct ServerAuthRetry
{
	var UniqueNetId	ClientUID;		// The UID of the client requesting retries
	var int		AuthRetryCount;		// The number of times server authentication has been retried for this client
};

/** Tracks server auth retry requests for clients */
var array<ServerAuthRetry>		ServerAuthRetries;


/** Wether or not the listen host is pending authentication */
var bool bPendingListenAuth;

/** Stores the UID of the listen server auth blob */
var int ListenAuthBlobUID;

/** The number of times listen host auth has been retried */
var int ListenAuthRetryCount;


function PostBeginPlay()
{
	OnlineSub = Class'GameEngine'.static.GetOnlineSubsystem();

	if (OnlineSub != none)
	{
		CachedAuthInt = OnlineAuthInterfaceBaseImpl(OnlineSub.AuthInterface);
	}

	if (bAuthenticateClients)
	{
		if (CachedAuthInt != none)
		{
			if (!CachedAuthInt.IsReady())
			{
				CachedAuthInt.AddAuthReadyDelegate(OnAuthReady);
			}

			CachedAuthInt.AddAuthRequestServerDelegate(OnAuthRequestServer);
			CachedAuthInt.AddAuthBlobReceivedClientDelegate(OnAuthBlobReceivedClient);
			CachedAuthInt.AddAuthCompleteClientDelegate(OnAuthCompleteClient);
			CachedAuthInt.AddClientConnectionCloseDelegate(OnClientConnectionClose);
			CachedAuthInt.AddAuthRetryServerDelegate(OnAuthRetryServer);

			CachedAuthInt.ClearClientConnectionCloseDelegate(Class'AccessControl'.static.StaticOnClientConnectionClose);

			if (OnlineSub.GameInterface != none)
			{
				OnlineSub.GameInterface.AddDestroyOnlineGameCompleteDelegate(OnDestroyOnlineGameComplete);
			}
		}
		else
		{
			`log("AccessControl: bAuthenticateClients is True, but current online subsystem does not support authentication");
		}
	}
}

function Destroyed()
{
	Cleanup();
}

/**
 * Checks wether or not the specified PlayerController is an admin
 *
 * @param P	The PlayerController to check
 * @return	TRUE if the specified player has admin priveleges.
 */
function bool IsAdmin(PlayerController P)
{
	if ( P != None )
	{
		if ( Admin(P) != None )
		{
			return true;
		}

		if ( P.PlayerReplicationInfo != None && P.PlayerReplicationInfo.bAdmin )
		{
			return true;
		}
	}

	return false;
}

function bool SetAdminPassword(string P)
{
	AdminPassword = P;
	return true;
}

function SetGamePassword(string P)
{
	GamePassword = P;
	WorldInfo.Game.UpdateGameSettings();
}

function bool RequiresPassword()
{
	return GamePassword != "";
}

/**
 * Takes a string and tries to find the matching controller associated with it.  First it searches as if the string is the
 * player's name.  If it doesn't find a match, it attempts to resolve itself using the target as the player id.
 *
 * @Params	Target		The search key
 *
 * @returns the controller assoicated with the key.  NONE is a valid return and means not found.
 */
function Controller GetControllerFromString(string Target)
{
	local Controller C,FinalC;
	local int i;

	FinalC = none;
	foreach WorldInfo.AllControllers(class'Controller', C)
	{
		if (C.PlayerReplicationInfo != None && (C.PlayerReplicationInfo.PlayerName ~= Target || C.PlayerReplicationInfo.PlayerName ~= Target))
		{
			FinalC = C;
			break;
		}
	}

	// if we didn't find it by name, attemtp to convert the target to a player index and look him up if possible.
	if ( C == none && WorldInfo != none && WorldInfo.GRI != none )
	{
		for (i=0;i<WorldInfo.GRI.PRIArray.Length;i++)
		{
			if ( String(WorldInfo.GRI.PRIArray[i].PlayerID) == Target )
			{
				FinalC = Controller(WorldInfo.GRI.PRIArray[i].Owner);
				break;
			}
		}
	}

	return FinalC;
}

function Kick( string Target )
{
	local Controller C;

	C = GetControllerFromString(Target);
	if ( C != none && C.PlayerReplicationInfo != None )
	{
		if (PlayerController(C) != None)
		{
			KickPlayer(PlayerController(C), DefaultKickReason);
		}
		else if (C.PlayerReplicationInfo != None)
		{
			if (C.Pawn != None)
			{
				C.Pawn.Destroy();
			}
			if (C != None)
			{
				C.Destroy();
			}
		}
	}
}

function KickBan( string Target )
{
	local PlayerController P;
	local string IP;

	P =  PlayerController( GetControllerFromString(Target) );
	if ( NetConnection(P.Player) != None )
	{
		if (!WorldInfo.IsConsoleBuild())
		{
			IP = P.GetPlayerNetworkAddress();
			if( CheckIPPolicy(IP) )
			{
				IP = Left(IP, InStr(IP, ":"));
				`Log("Adding IP Ban for: "$IP);
				IPPolicies[IPPolicies.length] = "DENY," $ IP;
				SaveConfig();
			}
		}

		if ( P.PlayerReplicationInfo.UniqueId != P.PlayerReplicationInfo.default.UniqueId &&
			!IsIDBanned(P.PlayerReplicationInfo.UniqueID) )
		{
			BannedIDs.AddItem(P.PlayerReplicationInfo.UniqueId);
			SaveConfig();
		}
		KickPlayer(P, DefaultKickReason);
		return;
	}
}

function bool ForceKickPlayer(PlayerController C, string KickReason)
{
	if (C != None && NetConnection(C.Player)!=None )
	{
		if (C.Pawn != None)
		{
			C.Pawn.Suicide();
		}
		C.ClientWasKicked();
		if (C != None)
		{
			C.Destroy();
		}
		return true;
	}
	return false;
}

function bool KickPlayer(PlayerController C, string KickReason)
{
	// Do not kick logged admins
	if (C != None && !IsAdmin(C) && NetConnection(C.Player)!=None )
	{
		return ForceKickPlayer(C, KickReason);
	}
	return false;
}

function bool AdminLogin( PlayerController P, string Password )
{
	if (AdminPassword == "")
	{
		return false;
	}

	if (Password == AdminPassword)
	{
		P.PlayerReplicationInfo.bAdmin = true;
		return true;
	}

	return false;
}

function bool AdminLogout(PlayerController P)
{
	if (P.PlayerReplicationInfo.bAdmin)
	{
		P.PlayerReplicationInfo.bAdmin = false;
		P.bGodMode = false;
		P.Suicide();

		return true;
	}

	return false;
}

function AdminEntered( PlayerController P )
{
	local string LoginString;

	LoginString = P.PlayerReplicationInfo.PlayerName@"logged in as a server administrator.";

	`log(LoginString);
	WorldInfo.Game.Broadcast( P, LoginString );
}
function AdminExited( PlayerController P )
{
	local string LogoutString;

	LogoutString = P.PlayerReplicationInfo.PlayerName$"is no longer logged in as a server administrator.";

	`log(LogoutString);
	WorldInfo.Game.Broadcast( P, LogoutString );
}

/**
 * Parses the specified string for admin auto-login options
 *
 * @param	Options		a string containing key/pair options from the URL (?key=value,?key=value)
 *
 * @return	TRUE if the options contained name and password which were valid for admin login.
 */
function bool ParseAdminOptions( string Options )
{
	local string InAdminName, InPassword;

	InPassword = class'GameInfo'.static.ParseOption( Options, "Password" );
	InAdminName= class'GameInfo'.static.ParseOption( Options, "AdminName" );

	return ValidLogin(InAdminName, InPassword);
}

/**
 * @return	TRUE if the specified username + password match the admin username/password
 */
function bool ValidLogin(string UserName, string Password)
{
	return (AdminPassword != "" && Password==AdminPassword);
}

function bool CheckIPPolicy(string Address)
{
	local int i, j;
`if(`notdefined(FINAL_RELEASE))
	local int LastMatchingPolicy;
`endif
	local string Policy, Mask;
	local bool bAcceptAddress, bAcceptPolicy;

	// strip port number
	j = InStr(Address, ":");
	if(j != -1)
		Address = Left(Address, j);

	bAcceptAddress = True;
	for(i=0; i<IPPolicies.Length; i++)
	{
		j = InStr(IPPolicies[i], ",");
		if(j==-1)
			continue;
		Policy = Left(IPPolicies[i], j);
		Mask = Mid(IPPolicies[i], j+1);
		if(Policy ~= "ACCEPT")
			bAcceptPolicy = True;
			else if(Policy ~= "DENY")
			bAcceptPolicy = False;
		else
			continue;

		j = InStr(Mask, "*");
		if(j != -1)
		{
			if(Left(Mask, j) == Left(Address, j))
			{
				bAcceptAddress = bAcceptPolicy;
				`if(`notdefined(FINAL_RELEASE))
				LastMatchingPolicy = i;
				`endif
			}
		}
		else
		{
			if(Mask == Address)
			{
				bAcceptAddress = bAcceptPolicy;
				`if(`notdefined(FINAL_RELEASE))
				LastMatchingPolicy = i;
				`endif
			}
		}
	}

	if(!bAcceptAddress)
	{
		`Log("Denied connection for "$Address$" with IP policy "$IPPolicies[LastMatchingPolicy]);
	}

	return bAcceptAddress;
}

function bool IsIDBanned(const out UniqueNetID NetID)
{
	local int i;

	for (i = 0; i < BannedIDs.length; i++)
	{
		if (BannedIDs[i] == NetID)
		{
			return true;
		}
	}
	return false;
}


/**
 * Client authentication (and PreLogin handling)
 */

/**
 * Accept or reject a joining player on the server; fails login if OutError is set to a non-empty string
 * NOTE: UniqueId requires authentication before it can be trusted
 *
 * @param Options	URL options the player used when connecting
 * @param Address	The IP address of the player
 * @param UniqueId	The UID of the player (requires authentication before it can be trusted)
 * @param bSupportsAuth	Wether or not the client supports authentication (i.e. has an AuthInterface set)
 * @param OutError	If the player fails any checks in this function, set this to a non-empty value to reject the player
 * @param bSpectator	Wether or not the player is trying to join as a spectator
 */
event PreLogin(string Options, string Address, const UniqueNetId UniqueId, bool bSupportsAuth, out string OutError, bool bSpectator)
{
	local string InPassword;
	local int i, CurIP, CurPort, ClientIP, LingeringPort;
	local bool bFound, bSuccess;
	local UniqueNetId NullId, HostUID;
	local Player ClientConn, CurConn;

	OutError="";
	InPassword = WorldInfo.Game.ParseOption(Options, "Password");

	// Check server capacity and passwords
	if (WorldInfo.NetMode != NM_Standalone && WorldInfo.Game.AtCapacity(bSpectator))
	{
		OutError = PathName(WorldInfo.Game.GameMessageClass)$".MaxedOutMessage";
	}
	else if (GamePassword != "" && !(InPassword == GamePassword) && (AdminPassword == "" || !(InPassword == AdminPassword)))
	{
		OutError = (InPassword == "") ? "Engine.AccessControl.NeedPassword" : "Engine.AccessControl.WrongPassword";
	}

	// Check server IP bans (UID bans are checked in GameInfo::PreLogin)
	if (!CheckIPPolicy(Address))
	{
		OutError = "Engine.AccessControl.IPBanned";
	}


	// If the client was not already rejected, handle authentication of the clients UID
	if (bAuthenticateClients && OutError == "" && CachedAuthInt != none)
	{
		// If the client does not support authentication, reject him immediately
		if (!bSupportsAuth)
		{
			if (OnlineSub.Class.Name == 'OnlineSubsystemSteamworks')
			{
				OutError = "Engine.Errors.SteamClientRequired";
			}
			else
			{
				// @todo: Localize this
				OutError = "Server requires authentication";
			}
		}


		// Pause the login process for the client
		if (OutError == "")
		{
			ClientConn = WorldInfo.Game.PauseLogin();
		}

		if (ClientConn != none)
		{
			// If there are any other client connections from the same UID and IP, kick them (fixes an auth issue,
			//	preventing players from rejoining if they were disconnected, and the old connection still lingers)

			// First find the joining clients IP
			foreach WorldInfo.AllClientConnections(CurConn, CurIP, CurPort)
			{
				if (CurConn == ClientConn)
				{
					ClientIP = CurIP;
					break;
				}
			}

			// See if there is an active auth session matching the same IP and UID
			LingeringPort = 0;

			for (i=0; i<CachedAuthInt.ClientAuthSessions.Length; ++i)
			{
				if (CachedAuthInt.ClientAuthSessions[i].EndPointIP == ClientIP &&
					CachedAuthInt.ClientAuthSessions[i].EndPointUID == UniqueId)
				{
					LingeringPort = CachedAuthInt.ClientAuthSessions[i].EndPointPort;
					break;
				}
			}

			// If there was an existing active auth session, match it up to the lingering connection and disconnect it
			if (LingeringPort != 0)
			{
				foreach WorldInfo.AllClientConnections(CurConn, CurIP, CurPort)
				{
					if (CurConn != ClientConn && CurIP == ClientIP && CurPort == LingeringPort)
					{
						`log("Closing old connection with duplicate IP ("$Address$") and SteamId ("$
							Class'OnlineSubsystem'.static.UniqueNetIdToString(UniqueId)$")",, 'DevNet');

						WorldInfo.Game.RejectLogin(CurConn, "");

						break;
					}
				}
			}


			// If there are other client connections from the same UID, but not the same IP, reject the new player
			// NOTE: The above code shouldn't affect this, as OnClientConnectionClose (which cleans up lists)
			//		is called during RejectLogin
			for (i=0; i<ClientsPendingAuth.Length; i++)
			{
				if (ClientsPendingAuth[i].ClientUID == UniqueId)
				{
					bFound = True;
					break;
				}
			}

			for (i=0; i<CachedAuthInt.ClientAuthSessions.Length; ++i)
			{
				if (CachedAuthInt.ClientAuthSessions[i].EndPointUID == UniqueId &&
					CachedAuthInt.ClientAuthSessions[i].EndPointIP != ClientIP)
				{
					bFound = True;
					break;
				}
			}


			// Make sure the player is not trying to join with a listen hosts UID
			if (WorldInfo.NetMode == NM_ListenServer && OnlineSub.PlayerInterface != none &&
				OnlineSub.PlayerInterface.GetUniquePlayerId(0, HostUID) && UniqueId == HostUID)
			{
				bFound = True;
			}


			// If the UID is not already present on server, and is not otherwise invalid, begin authentication
			if (!bFound && UniqueId != NullId)
			{
				// Begin authentication, and if it kicks off successfully, start tracking the auth progress
				if (CachedAuthInt.IsReady())
				{
					bSuccess = CachedAuthInt.SendAuthRequestClient(ClientConn, UniqueId);

					if (bSuccess && !IsTimerActive('PendingAuthTimer'))
					{
						SetTimer(3.0, True, 'PendingAuthTimer');
					}
				}
				// If the auth interface is not ready, add an entry anyway, and kick off auth later when it is ready
				else
				{
					bSuccess = True;
				}

				if (bSuccess)
				{
					i = ClientsPendingAuth.Length;
					ClientsPendingAuth.Length = i+1;

					ClientsPendingAuth[i].ClientConnection = ClientConn;
					ClientsPendingAuth[i].ClientUID = UniqueId;
					ClientsPendingAuth[i].AuthTimestamp = WorldInfo.RealTimeSeconds;
				}
				else
				{
					// @todo: Localized error required
					OutError = "Failed to kickoff authentication";
				}
			}
			// Reject the client if the current UID is already being authenticated
			else if (bFound)
			{
				// @todo: Localized error required
				OutError = "Duplicate UID";
			}
			// Reject the client straight away if their UID is null
			else
			{
				// @todo: Localized error required
				OutError = "Invalid UID";
			}
		}
		else if (OutError == "")
		{
			// @todo: Localized error required
			OutError = "Failed to kickoff authentication";
		}
	}
}

/**
 * Called once every 3 seconds, to see if any auth attempts have timed out
 */
function PendingAuthTimer()
{
	local int i, ClientSessionIdx, CurIP;
	local UniqueNetId CurUID;
	local bool bFailed;

	for (i=0; i<ClientsPendingAuth.Length; ++i)
	{
		// Remove any connections that have become invalid
		if (ClientsPendingAuth[i].ClientConnection == none)
		{
			ClientsPendingAuth.Remove(i, 1);
			i--;
		}
		// Need to detect level change messing up timestamps (and reset it)
		else if (WorldInfo.RealTimeSeconds < ClientsPendingAuth[i].AuthTimestamp)
		{
			ClientsPendingAuth[i].AuthTimestamp = WorldInfo.RealTimeSeconds;
		}
		// Handle timeouts and retries
		else if (WorldInfo.RealTimeSeconds - ClientsPendingAuth[i].AuthTimestamp >= 5.0)
		{
			ClientSessionIdx = CachedAuthInt.FindClientAuthSession(ClientsPendingAuth[i].ClientConnection);

			if (ClientSessionIdx != INDEX_None)
			{
				CurIP = CachedAuthInt.ClientAuthSessions[ClientSessionIdx].EndPointIP;
				CurUID = CachedAuthInt.ClientAuthSessions[ClientSessionIdx].EndPointUID;

				if (ClientsPendingAuth[i].AuthRetryCount < MaxAuthRetryCount)
				{
					// End the auth session first before retrying
					CachedAuthInt.EndRemoteClientAuthSession(CurUID, CurIP);

					// Get the client to end it his end too (this should execute on client before the new auth request below)
					CachedAuthInt.SendAuthKillClient(ClientsPendingAuth[i].ClientConnection);

					// Start the new auth session
					if (CachedAuthInt.SendAuthRequestClient(ClientsPendingAuth[i].ClientConnection, CurUID))
					{
						ClientsPendingAuth[i].AuthTimestamp = WorldInfo.RealTimeSeconds;
						ClientsPendingAuth[i].AuthRetryCount++;
					}
					else
					{
						bFailed = True;
					}
				}
				else
				{
					bFailed = True;
				}

				if (bFailed)
				{
					`log("Client authentication timed out after"@MaxAuthRetryCount@"tries",, 'DevOnline');

					// @todo: Localize error
					WorldInfo.Game.RejectLogin(ClientsPendingAuth[i].ClientConnection, "Authentication failed");
				}
			}
		}
	}

	if (ClientsPendingAuth.Length == 0)
	{
		ClearTimer('PendingAuthTimer');
	}
}

/**
 * Called when the auth interface is ready to perform authentication (may not be called, if the auth interface was already ready)
 * NOTE: Listen host authentication may be kicked off here
 */
function OnAuthReady()
{
	local int i, OldLength;

	// If there are any pending client auth's queued, kickoff authentication
	for (i=0; i<ClientsPendingAuth.Length; ++i)
	{
		// Remove invalid entries
		if (ClientsPendingAuth[i].ClientConnection == none)
		{
			ClientsPendingAuth.Remove(i, 1);
			i--;

			continue;
		}


		if (CachedAuthInt.SendAuthRequestClient(clientsPendingAuth[i].ClientConnection, ClientsPendingAuth[i].ClientUID))
		{
			ClientsPendingAuth[i].AuthTimestamp = WorldInfo.RealTimeSeconds;
		}
		else
		{
			OldLength = ClientsPendingAuth.Length;

			// Kick the client
			WorldInfo.Game.RejectLogin(ClientsPendingAuth[i].ClientConnection, "Authentication failed");

			// If OnClientConnectionClose did not alter ClientsPendingAuth, remove the entry now
			if (OldLength == ClientsPendingAuth.Length)
			{
				ClientsPendingAuth.Remove(i, 1);
			}

			i--;

			continue;
		}
	}

	// If any clients are now pending auth, activate the pending auth timer
	if (ClientsPendingAuth.Length > 0)
	{
		`log("OnAuthReady: Kicking off delayed auth for clients");

		SetTimer(3.0, True, 'PendingAuthTimer');
	}

	if (bAuthenticateListenHost && WorldInfo.NetMode == NM_ListenServer && bPendingListenAuth)
	{
		BeginListenHostAuth();
	}
}

/**
 * Called when the server receives auth data from a client, needed for authentication
 *
 * @param ClientUID		The UID of the client
 * @param ClientIP		The IP of the client
 * @param AuthBlobUID		The UID used to reference the auth data
 */
function OnAuthBlobReceivedClient(UniqueNetId ClientUID, int ClientIP, int AuthBlobUID)
{
	local bool bSuccess;
	local int i, PendingIdx, OldLength;

	// Check that we are expecting auth data from this client
	PendingIdx = INDEX_None;

	for (i=0; i<ClientsPendingAuth.Length; i++)
	{
		if (ClientsPendingAuth[i].ClientUID == ClientUID)
		{
			PendingIdx = i;
			break;
		}
	}


	if (PendingIdx != INDEX_None)
	{
		// Now that the client has sent auth data required for verification, finish verifying the client
		bSuccess = CachedAuthInt.VerifyClientAuthSession(ClientUID, ClientIP, 0, AuthBlobUID);

		// If auth verification failed to kickoff successfully, kick the client
		if (!bSuccess)
		{
			OldLength = ClientsPendingAuth.Length;

			// Kick the client
			WorldInfo.Game.RejectLogin(ClientsPendingAuth[i].ClientConnection, "Authentication failed");


			// If OnClientConnectionClose did not alter ClientsPendingAuth, remove the tracking entry here
			if (OldLength == ClientsPendingAuth.Length)
			{
				ClientsPendingAuth.Remove(PendingIdx, 1);
			}
		}
	}
	else
	{
		`log("AccessControl::OnAuthBlobReceivedClient: Received unexpected auth blob from client",, 'DevOnline');
	}
}

/**
 * Called on the server, when the authentication result for a client auth session has returned
 * NOTE: This is the first place, where a clients UID is verified as valid
 *
 * @param bSuccess		Wether or not authentication was successful
 * @param ClientUID		The UID of the client
 * @param ClientConnection	The connection associated with the client (for retrieving auth session data)
 * @param ExtraInfo		Extra information about authentication, e.g. failure reasons
 */
function OnAuthCompleteClient(bool bSuccess, UniqueNetId ClientUID, Player ClientConnection, string ExtraInfo)
{
	local UniqueNetId HostUID;
	local int i, PendingIdx, ClientSessionIdx, ClientIP, ClientPort;
	local PlayerController P;
	local PlayerReplicationInfo PRI;
	local bool bResumeLogin;

	// Check if the auth result was for the listen host
	if (WorldInfo.NetMode == NM_ListenServer && OnlineSub.PlayerInterface != none &&
		OnlineSub.PlayerInterface.GetUniquePlayerId(0, HostUID) && HostUID == ClientUID)
	{
		if (bSuccess)
		{
			`log("Listen host successfully authenticated");

			ClearTimer('ListenHostAuthTimeout');
			ClearTimer('ContinueListenHostAuth');
		}

		return;
	}

	// Check that we are expecting an auth result for this client
	PendingIdx = INDEX_None;

	for (i=0; i<ClientsPendingAuth.Length; i++)
	{
		if ((ClientConnection != none && ClientsPendingAuth[i].ClientConnection == ClientConnection) ||
			(ClientConnection == none && ClientsPendingAuth[i].ClientUID == ClientUID))
		{
			PendingIdx = i;
			break;
		}
	}

	if (PendingIdx != INDEX_None)
	{
		if (ClientConnection != none)
		{
			if (bSuccess)
			{
				foreach WorldInfo.AllControllers(Class'PlayerController', P)
				{
					if (P.Player == ClientConnection)
					{
						PRI = P.PlayerReplicationInfo;
						break;
					}
				}

				if (PRI != none)
				{
					// If the code is setup to >not< pause at login, the UID needs to be stored in the PRI from here
					P.PlayerReplicationInfo.SetUniqueId(ClientUID);

					`log("Client '"$PRI.PlayerName$"'passed authentication, UID:"@
						Class'OnlineSubsystem'.static.UniqueNetIdToString(ClientUID));
				}
				else
				{
					`log("Client passed authentication, UID:"@Class'OnlineSubsystem'.static.UniqueNetIdToString(ClientUID));
				}

				bResumeLogin = True;


				// Kick off server auth
				if (bAuthenticateServer)
				{
					ClientSessionIdx = CachedAuthInt.FindClientAuthSession(ClientConnection);

					if (ClientSessionIdx != INDEX_None)
					{
						ClientIP = CachedAuthInt.ClientAuthSessions[ClientSessionIdx].EndPointIP;
						ClientPort = CachedAuthInt.ClientAuthSessions[ClientSessionIdx].EndPointPort;

						OnAuthRequestServer(ClientConnection, ClientUID, ClientIP, ClientPort);
					}
					else
					{
						`log("Failed to kickoff server auth; could not find matching client session");
					}
				}
			}
			else
			{
				`log("Client failed authentication (unauthenticated UID:"@
					Class'OnlineSubsystem'.static.UniqueNetIdToString(ClientUID)$"), kicking");

				// Kick the client
				WorldInfo.Game.RejectLogin(ClientConnection, "Authentication failed");
			}
		}

		// Remove the tracking entry
		ClientsPendingAuth.Remove(PendingIdx, 1);
	}
	else
	{
		`log("AccessControl::OnAuthCompleteClient: Received unexpected auth result for client",, 'DevOnline');
	}


	if (bResumeLogin)
	{
		WorldInfo.Game.ResumeLogin(ClientConnection);
	}
}


/**
 * Server authentication
 */

/**
 * Called when the server receives a message from a client, requesting a server auth session
 *
 * @param ClientConnection	The NetConnection of the client the request came from
 * @param ClientUID		The UID of the client making the request
 * @param ClientIP		The IP of the client making the request
 * @param ClientPort		The port the client is on
 */
function OnAuthRequestServer(Player ClientConnection, UniqueNetId ClientUID, int ClientIP, int ClientPort)
{
	local int AuthBlobUID, i, ExistingSessionIdx;

	// NOTE: Native code handles checking of wether or not client is authenticated
	if (bAuthenticateServer)
	{
		// Make sure there is not already a server auth session for this client
		ExistingSessionIdx = INDEX_None;

		for (i=0; i<CachedAuthInt.LocalServerAuthSessions.Length; ++i)
		{
			if (CachedAuthInt.LocalServerAuthSessions[i].EndPointUID == ClientUID &&
				CachedAuthInt.LocalServerAuthSessions[i].EndPointIP == ClientIP)
			{
				ExistingSessionIdx = i;
			}
		}

		if (ExistingSessionIdx == INDEX_None)
		{
			// Kickoff server auth
			if (CachedAuthInt.CreateServerAuthSession(ClientUID, ClientIP, ClientPort, AuthBlobUID))
			{
				if (!CachedAuthInt.SendAuthBlobServer(ClientConnection, AuthBlobUID))
				{
					`log("WARNING!!! Failed to send auth blob to client");
				}
			}
			else
			{
				`log("Failed to kickoff server auth",, 'DevOnline');
			}
		}
	}
}

/**
 * Called when the server receives a server auth retry request from a client
 *
 * @param ClientConnection	The client NetConnection
 */
function OnAuthRetryServer(Player ClientConnection)
{
	local int CurSessionIdx, ClientIP, ClientPort, i, CurRetryIdx;
	local UniqueNetId ClientUID;

	if (bAuthenticateServer && ClientConnection != none)
	{
		CurSessionIdx = CachedAuthInt.FindClientAuthSession(ClientConnection);

		// Only execute a server auth retry, if the client is fully authenticated
		if (CurSessionIdx != INDEX_None && CachedAuthInt.ClientAuthSessions[CurSessionIdx].AuthStatus == AUS_Authenticated)
		{
			ClientUID = CachedAuthInt.ClientAuthSessions[CurSessionIdx].EndPointUID;
			ClientIP = CachedAuthInt.ClientAuthSessions[CurSessionIdx].EndPointIP;
			ClientPort = CachedAuthInt.ClientAuthSessions[CurSessionIdx].EndPointPort;

			CurRetryIdx = INDEX_None;

			for (i=0; i<ServerAuthRetries.Length; ++i)
			{
				if (ServerAuthRetries[i].ClientUID == ClientUID)
				{
					CurRetryIdx = i;
					break;
				}
			}

			if (CurRetryIdx == INDEX_None)
			{
				CurRetryIdx = ServerAuthRetries.Length;
				ServerAuthRetries.Length = CurRetryIdx + 1;

				ServerAuthRetries[CurRetryIdx].ClientUId = ClientUID;
			}


			// Only attempt server auth retry, if the retry count has not been exceeded
			if (ServerAuthRetries[CurRetryIdx].AuthRetryCount < MaxAuthRetryCount)
			{
				// End the current server auth session
				for (i=0; i<CachedAuthInt.LocalServerAuthSessions.Length; ++i)
				{
					if (CachedAuthInt.LocalServerAuthSessions[i].EndPointUID == ClientUID)
					{
						CachedAuthInt.EndLocalServerAuthSession(ClientUID, ClientIP);

						break;
					}
				}

				// Kick off a new server auth session
				OnAuthRequestServer(ClientConnection, ClientUID, ClientIP, ClientPort);


				// Update the retry count
				ServerAuthRetries[CurRetryIdx].AuthRetryCount++;
			}
			// Kick the client, if they spam retry requests
			else if (ServerAuthRetries[CurRetryIdx].AuthRetryCount > Max(30, MaxAuthRetryCount + 20))
			{
				WorldInfo.Game.RejectLogin(ClientConnection, "Spamming server auth");
			}
			else
			{
				// Update the retry count
				ServerAuthRetries[CurRetryIdx].AuthRetryCount++;
			}
		}
	}
}


/**
 * Listen host authentication
 */

/**
 * Called by GameInfo, when StartOnlineGame has kicked off
 */
function NotifyStartOnlineGame()
{
	// Listen host authentication is kicked off here, since some online subsystems (Steam primarily) require an active game session to auth
	if (bAuthenticateListenHost && WorldInfo.NetMode == NM_ListenServer && CachedAuthInt != none)
	{
		if (CachedAuthInt.IsReady())
		{
			BeginListenHostAuth();
		}
		else
		{
			bPendingListenAuth = True;
		}
	}
}

/**
 * Kicks off authentication of the listen host
 */
function BeginListenHostAuth()
{
	local UniqueNetId ServerUID, HostUID;
	local int ServerIP, ServerPort, i, ListenSessionIdx;
	local OnlineGameSettings GameSettings;
	local bool bSecure;

	bPendingListenAuth = False;

	if (CachedAuthInt.IsReady() && CachedAuthInt.GetServerUniqueId(ServerUID) && CachedAuthInt.GetServerAddr(ServerIP, ServerPort) &&
		OnlineSub.PlayerInterface.GetUniquePlayerId(0, HostUID))
	{
		// Search for an existing listen host auth session first
		ListenSessionIdx = INDEX_None;

		for (i=0; i<CachedAuthInt.ClientAuthSessions.Length; i++)
		{
			if (CachedAuthInt.ClientAuthSessions[i].EndPointUID == HostUID &&
				CachedAuthInt.ClientAuthSessions[i].EndPointIP == ServerIP)
			{
				ListenSessionIdx = i;
				break;
			}
		}


		// If there is not an existing session, kick one off
		if (ListenSessionIdx == INDEX_None)
		{
			`log("Kicking off listen auth session");

			if (OnlineSub.GameInterface != none)
			{
				GameSettings = OnlineSub.GameInterface.GetGameSettings('none');
			}

			if (GameSettings != none)
			{
				bSecure = GameSettings.bAntiCheatProtected;
			}


			// Kickoff authentication
			if (CachedAuthInt.CreateClientAuthSession(ServerUID, ServerIP, ServerPort, bSecure, ListenAuthBlobUID))
			{
				// Give the auth interface a moment to setup the auth session, before verifying
				SetTimer(1.0, False, 'ContinueListenHostAuth');
			}

			SetTimer(AuthRetryDelay, False, 'ListenHostAuthTimeout');
		}
		// If there is an existing session, do nothing if already authenticated, or enable timeout if not
		else if (CachedAuthInt.ClientAuthSessions[i].AuthStatus != AUS_Authenticated && !IsTimerActive('ListenHostAuthTimeout'))
		{
			`log("BeginListenHostAuth was called when there is already a listen auth session, but the timeout is not active");

			SetTimer(AuthRetryDelay, False, 'ListenHostAuthTimeout');
		}
	}
	else
	{
		`log("Failed to kickoff listen host authentication");
	}
}

/**
 * After listen host authentication kicks off, this is called after a short delay, to continue authentication
 */
function ContinueListenHostAuth()
{
	local UniqueNetId HostUID;
	local int ServerIP, ServerPort;

	if (OnlineSub.PlayerInterface != none && OnlineSub.PlayerInterface.GetUniquePlayerId(0, HostUID) &&
		CachedAuthInt.GetServerAddr(ServerIP, ServerPort))
	{
		if (!CachedAuthInt.VerifyClientAuthSession(HostUID, ServerIP, ServerPort, ListenAuthBlobUID))
		{
			`log("VerifyClientAuthSession failed for listen host");
		}
	}
}

/**
 * Ends any active listen host auth sessions
 */
function EndListenHostAuth()
{
	local UniqueNetId ServerUID, HostUID;
	local int ServerIP, ServerPort;

	if (CachedAuthInt.GetServerUniqueId(ServerUID) && CachedAuthInt.GetServerAddr(ServerIP, ServerPort) &&
		OnlineSub.PlayerInterface != none && OnlineSub.PlayerInterface.GetUniquePlayerId(0, HostUID))
	{
		CachedAuthInt.EndLocalClientAuthSession(ServerUID, ServerIP, ServerPort);
		CachedAuthInt.EndRemoteClientAuthSession(HostUID, ServerIP);
	}
	else
	{
		`log("Failed to end listen host auth session");
	}
}

/**
 * Triggered upon listen host authentication failure, or timeout
 */
function ListenHostAuthTimeout()
{
	local UniqueNetId ServerUID;
	local int ServerIP, ServerPort;
	local OnlineGameSettings GameSettings;
	local bool bSecure;

	ClearTimer('ListenHostAuthTimeout');
	ClearTimer('ContinueListenHostAuth');

	if (ListenAuthRetryCount < MaxAuthRetryCount)
	{
		ListenAuthRetryCount++;

		// Retry authentication
		CachedAuthInt.GetServerUniqueId(ServerUID);
		CachedAuthInt.GetServerAddr(ServerIP, ServerPort);

		if (OnlineSub.GameInterface != none)
		{
			GameSettings = OnlineSub.GameInterface.GetGameSettings('none');
		}

		if (GameSettings != none)
		{
			bSecure = GameSettings.bAntiCheatProtected;
		}

		if (CachedAuthInt.CreateClientAuthSession(ServerUID, ServerIP, ServerPort, bSecure, ListenAuthBlobUID))
		{
			// Give the auth interface a moment to setup the auth session, before verifying
			SetTimer(1.0, False, 'ContinueListenHostAuth');
			SetTimer(AuthRetryDelay, False, 'ListenHostAuthTimeout');
		}
		else
		{
			SetTimer(1.0, False, 'ListenHostAuthTimeout');
		}
	}
	else
	{
		`log("Listen host authentication failed after"@MaxAuthRetryCount@"attempts");
		EndListenHostAuth();
	}
}


/**
 * Client disconnect cleanup
 */

/**
 * Called on the server when a clients net connection is closing (so auth sessions can be ended)
 *
 * @param ClientConnection	The client NetConnection that is closing
 */
function OnClientConnectionClose(Player ClientConnection)
{
	local int i;

	if (ClientConnection != none)
	{
		// End the auth session for the exiting client (done in the static function to keep it in one place)
		StaticOnClientConnectionClose(ClientConnection);

		// Remove from tracking
		for (i=0; i<ClientsPendingAuth.Length; ++i)
		{
			if (ClientConnection != none && ClientsPendingAuth[i].ClientConnection == ClientConnection)
			{
				ClientsPendingAuth.Remove(i, 1);
				break;
			}
		}
	}
}

/**
 * It is extremely important that client disconnects are detected, even when an AccessControl does not exist;
 * otherwise, clients may be kept in an active auth sessions, even though they should not be (Steam in particular, is picky about this).
 *
 * When the AccessControl is cleaning up before server travel, it adds this static function as a delegate, until after server travel;
 * ensuring disconnects are always handled
 *
 * @param ClientConnection	The client NetConnection that is closing
 */
static final function StaticOnClientConnectionClose(Player ClientConnection)
{
	local OnlineSubsystem CurOnlineSub;
	local OnlineAuthInterfaceBaseImpl CurAuthInt;
	local int CurSessionIdx, CurIP, i;
	local UniqueNetId CurUID;
	local WorldInfo WI;

	CurOnlineSub = Class'GameEngine'.static.GetOnlineSubsystem();

	if (CurOnlineSub != none)
	{
		CurAuthInt = OnlineAuthInterfaceBaseImpl(CurOnlineSub.AuthInterface);
	}

	if (CurAuthInt != none && ClientConnection != none)
	{
		// End the client session
		CurSessionIdx = CurAuthInt.FindClientAuthSession(ClientConnection);

		if (CurSessionIdx != INDEX_None && CurAuthInt.ClientAuthSessions[CurSessionIdx].AuthStatus == AUS_Authenticated)
		{
			CurUID = CurAuthInt.ClientAuthSessions[CurSessionIdx].EndPointUID;
			CurIP = CurAuthInt.ClientAuthSessions[CurSessionIdx].EndPointIP;

			CurAuthInt.EndRemoteClientAuthSession(CurUID, CurIP);
		}


		// End any local server session
		CurSessionIdx = CurAuthInt.FindLocalServerAuthSession(ClientConnection);

		if (CurSessionIdx != INDEX_None)
		{
			CurUID = CurAuthInt.LocalServerAuthSessions[CurSessionIdx].EndPointUID;
			CurIP = CurAuthInt.LocalServerAuthSessions[CurSessionIdx].EndPointIP;

			CurAuthInt.EndLocalServerAuthSession(CurUID, CurIP);

			// Remove any 'ServerAuthRetries' entry
			WI = Class'WorldInfo'.static.GetWorldInfo();

			if (WI != none && WI.Game != none && WI.Game.AccessControl != none)
			{
				for (i=0; i<WI.Game.AccessControl.ServerAuthRetries.Length; ++i)
				{
					if (WI.Game.AccessControl.ServerAuthRetries[i].ClientUID == CurUID)
					{
						WI.Game.AccessControl.ServerAuthRetries.Remove(i, 1);
						break;
					}
				}
			}
		}
	}
}


/**
 * Exit/mapchange cleanup
 */

/**
 * Triggered when the current online game has ended; used to end auth sessions
 * NOTE: Delegate cleanup does not happen here
 */
function OnDestroyOnlineGameComplete(name SessionName, bool bWasSuccessful)
{
	local int i, ClientIP, ClientPort, CurIP, CurPort;
	local EAuthStatus ClientAuthStatus;
	local UniqueNetId ClientUID;
	local Player ClientConn, CurConn;

	// End listen host auth
	if (WorldInfo.NetMode == NM_ListenServer)
	{
		EndListenHostAuth();
	}

	// End auth for all connected clients
	for (i=0; i<CachedAuthInt.ClientAuthSessions.Length; ++i)
	{
		ClientAuthStatus = CachedAuthInt.ClientAuthSessions[i].AuthStatus;

		if (ClientAuthStatus == AUS_Authenticated)
		{
			ClientIP = CachedAuthInt.ClientAuthSessions[i].EndPointIP;
			ClientPort = CachedAuthInt.ClientAuthSessions[i].EndPointPort;
			ClientUID = CachedAuthInt.ClientAuthSessions[i].EndPointUID;

			// End the client auth session
			CachedAuthInt.EndRemoteClientAuthSession(ClientUID, ClientIP);


			// Tell the client to end the auth session their end
			foreach WorldInfo.AllClientConnections(CurConn, CurIP, CurPort)
			{
				if (CurIP == ClientIP && CurPort == ClientPort)
				{
					ClientConn = CurConn;
					break;
				}
			}

			if (ClientConn != none)
			{
				if (!CachedAuthInt.SendAuthKillClient(ClientConn))
				{
					`log("Failed to send client kill auth request");
				}
			}
			else
			{
				`log("WARNING!!! Came across client auth session with no matching NetConnection");
			}
		}
	}

	// End all local server auth sessions
	for (i=0; i<CachedAuthInt.LocalServerAuthSessions.Length; ++i)
	{
		ClientUID = CachedAuthInt.LocalServerAuthSessions[i].EndPointUID;
		ClientIP = CachedAuthInt.LocalServerAuthSessions[i].EndPointIP;

		CachedAuthInt.EndLocalServerAuthSession(ClientUID, ClientIP);
	}

	// Clear the 'ServerAuthRetries' lists
	ServerAuthRetries.Length = 0;
}

/**
 * Called by GameInfo when servertravel begins, to allow for online subsystem cleanup
 * NOTE: Worth keeping, in addition to NotifyGameEnding, as it is triggered earlier and can check for seamless travel
 *
 * @param bSeamless	Wether or not travel is seamless
 */
function NotifyTravel(bool bSeamless)
{
	if (bSeamless)
	{
		bPendingPostSeamlessInit = True;
	}
	else
	{
		Cleanup();
	}
}

/**
 * Called by GameInfo when the game is ending (either through exit or non-seamless travel), to allow for online subsystem cleanup
 */
function NotifyGameEnding()
{
	local GameEngine Engine;

	Engine = GameEngine(Class'Engine'.static.GetEngine());

	// If the server is just switching level, do a normal cleanup
	// @todo: This way of distinguishing travel from exit is quite hacky (but works and is necessary); implement a better solution
	if (WorldInfo.NextURL != "" || Engine.TravelURL != "")
	{
		Cleanup();
	}
	// Otherwise, the game is exiting an NotifyExit may need to do special handling
	else
	{
		NotifyExit();
	}
}

/**
 * Called by GameInfo when the game is exiting, to allow for online subsystem cleanup
 */
function NotifyExit()
{
	Cleanup(True);
}

/**
 * Cleanup any online subsystem references
 */
function Cleanup(optional bool bExit)
{
	local int i, CurIP;
	local UniqueNetId CurUID;

	if (CachedAuthInt != none)
	{
		CachedAuthInt.ClearAuthReadyDelegate(OnAuthReady);
		CachedAuthInt.ClearAuthRequestServerDelegate(OnAuthRequestServer);
		CachedAuthInt.ClearAuthBlobReceivedClientDelegate(OnAuthBlobReceivedClient);
		CachedAuthInt.ClearAuthCompleteClientDelegate(OnAuthCompleteClient);
		CachedAuthInt.ClearClientConnectionCloseDelegate(OnClientConnectionClose);
		CachedAuthInt.ClearAuthRetryServerDelegate(OnAuthRetryServer);

		// If the game is exiting, end all auth sessions
		if (bExit)
		{
			// End all client auth sessions
			for (i=0; i<CachedAuthInt.ClientAuthSessions.Length; ++i)
			{
				if (CachedAuthInt.ClientAuthSessions[i].AuthStatus == AUS_Pending ||
					CachedAuthInt.ClientAuthSessions[i].AuthStatus == AUS_Authenticated)
				{
					CurIP = CachedAuthInt.ClientAuthSessions[i].EndPointIP;
					CurUID = CachedAuthInt.ClientAuthSessions[i].EndPointUID;

					CachedAuthInt.EndRemoteClientAuthSession(CurUID, CurIP);
				}
			}

			// End all local server auth sessions
			for (i=0; i<CachedAuthInt.LocalServerAuthSessions.Length; ++i)
			{
				CurIP = CachedAuthInt.LocalServerAuthSessions[i].EndPointIP;
				CurUID = CachedAuthInt.LocalServerAuthSessions[i].EndPointUID;

				CachedAuthInt.EndLocalServerAuthSession(CurUID, CurIP);
			}

			// Clear the 'ServerAuthRetries' list
			ServerAuthRetries.Length = 0;
		}
		// OnClientConnectionClose must still be handled, even if the AccessControl does not exist during non-seamless travel
		else
		{
			CachedAuthInt.AddClientConnectionCloseDelegate(Class'AccessControl'.static.StaticOnClientConnectionClose);
		}

		if (OnlineSub.GameInterface != none)
		{
			OnlineSub.GameInterface.ClearDestroyOnlineGameCompleteDelegate(OnDestroyOnlineGameComplete);
		}
	}

	CachedAuthInt = none;
	OnlineSub = none;
}


/**
 * Helper functions
 */

/**
 * Wether or not the specified player UID is awaiting authentication
 *
 * @param PlayerUID	The UID of the player
 * @return		Returns True if the UID is awaiting authentication, False otherwise
 */
function bool IsPendingAuth(UniqueNetId PlayerUID)
{
	local int i;

	for (i=0; i<ClientsPendingAuth.Length; ++i)
	{
		if (ClientsPendingAuth[i].ClientUID == PlayerUID)
		{
			return True;
		}
	}

	return False;
}


defaultproperties
{
	AdminClass=class'Engine.Admin'
}
