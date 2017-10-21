/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

/**
 * Class that implements a base cross-platform version of the auth interface
 */
Class OnlineAuthInterfaceImpl extends OnlineAuthInterfaceBaseImpl within OnlineSubsystemCommonImpl
	native;

/** The owning subsystem that this object is providing an implementation for */
var OnlineSubsystemCommonImpl OwningSubsystem;


/** The list of 'OnAuthReady' delegates fired when the auth interface is ready to perform authentication */
var array<delegate<OnAuthRequestClient> > AuthReadyDelegates;

/** The list of 'OnAuthRequestClient' delegates fired when the client receives an auth request from the server */
var array<delegate<OnAuthRequestClient> > AuthRequestClientDelegates;

/** The list of 'OnAuthRequestServer' delegates fired when the server receives an auth request from a client */
var array<delegate<OnAuthRequestServer> > AuthRequestServerDelegates;

/** The list of 'OnAuthBlobReceivedClient' delegates fired when the server receives auth data from a client */
var array<delegate<OnAuthBlobReceivedClient> > AuthBlobReceivedClientDelegates;

/** The list of 'OnAuthBlobReceivedServer' delegates fired when the client receives auth data from the server */
var array<delegate<OnAuthBlobReceivedServer> > AuthBlobReceivedServerDelegates;

/** The list of 'OnAuthCompleteClient' delegates fired when the server receives the authentication result for a client */
var array<delegate<OnAuthCompleteClient> > AuthCompleteClientDelegates;

/** The list of 'OnAuthCompleteServer' delegates fired when the client receives the authentication result for the server */
var array<delegate<OnAuthCompleteServer> > AuthCompleteServerDelegates;

/** The list of 'OnAuthKillClient' delegates fired when the client receives a request from the server, to end an active auth session */
var array<delegate<OnAuthKillClient> > AuthKillClientDelegates;

/** The list of 'OnAuthRetryServer' delegates fired when the server receives a request from the client, to retry server auth */
var array<delegate<OnAuthRetryServer> > AuthRetryServerDelegates;

/** The list of 'OnClientConnectionClose' delegates fired when a client connection is closing on the server */
var array<delegate<OnClientConnectionClose> > ClientConnectionCloseDelegates;

/** The list of 'OnServerConnectionClose' delegates fired when a server connection is closing on the client */
var array<delegate<OnServerConnectionClose> > ServerConnectionCloseDelegates;


/**
 * Called when the auth interface is ready to perform authentication
 */
//delegate OnAuthReady();

/**
 * Sets the delegate used to notify when the auth interface is ready to perform authentication
 *
 * @param AuthReadyDelegate	The delegate to use for notification
 */
function AddAuthReadyDelegate(delegate<OnAuthReady> AuthReadyDelegate)
{
	if (AuthReadyDelegates.Find(AuthReadyDelegate) == INDEX_None)
	{
		AuthReadyDelegates[AuthReadyDelegates.Length] = AuthReadyDelegate;
	}
}

/**
 * Removes the specified delegate from the notification list
 *
 * @param AuthReadyDelegate	The delegate to remove from the list
 */
function ClearAuthReadyDelegate(delegate<OnAuthReady> AuthReadyDelegate)
{
	local int i;

	i = AuthReadyDelegates.Find(AuthReadyDelegate);

	if (i != INDEX_None)
	{
		AuthReadyDelegates.Remove(i, 1);
	}
}

/**
 * Called when the client receives a message from the server, requesting a client auth session
 *
 * @param ServerUID		The UID of the game server
 * @param ServerIP		The public (external) IP of the game server
 * @param ServerPort		The port of the game server
 * @param bSecure		Wether or not the server has anticheat enabled (relevant to OnlineSubsystemSteamworks and VAC)
 */
//delegate OnAuthRequestClient(UniqueNetId ServerUID, int ServerIP, int ServerPort, bool bSecure);

/**
 * Sets the delegate used to notify when the client receives a message from the server, requesting a client auth session
 *
 * @param AuthRequestClientDelegate	The delegate to use for notifications
 */
function AddAuthRequestClientDelegate(delegate<OnAuthRequestClient> AuthRequestClientDelegate)
{
	if (AuthRequestClientDelegates.Find(AuthRequestClientDelegate) == INDEX_None)
	{
		AuthRequestClientDelegates[AuthRequestClientDelegates.Length] = AuthRequestClientDelegate;
	}
}

/**
 * Removes the specified delegate from the notification list
 *
 * @param AuthRequestClientDelegate	The delegate to remove from the list
 */
function ClearAuthRequestClientDelegate(delegate<OnAuthRequestClient> AuthRequestClientDelegate)
{
	local int i;

	i = AuthRequestClientDelegates.Find(AuthRequestClientDelegate);

	if (i != INDEX_None)
	{
		AuthRequestClientDelegates.Remove(i, 1);
	}
}

/**
 * Called when the server receives a message from a client, requesting a server auth session
 *
 * @param ClientConnection	The NetConnection of the client the request came from
 * @param ClientUID		The UID of the client making the request
 * @param ClientIP		The IP of the client making the request
 * @param ClientPort		The port the client is on
 */
//delegate OnAuthRequestServer(Player ClientConnection, UniqueNetId ClientUID, int ClientIP, int ClientPort);

/**
 * Sets the delegate used to notify when the server receives a message from a client, requesting a server auth session
 *
 * @param AuthRequestServerDelegate	The delegate to use for notifications
 */
function AddAuthRequestServerDelegate(delegate<OnAuthRequestServer> AuthRequestServerDelegate)
{
	if (AuthRequestServerDelegates.Find(AuthRequestServerDelegate) == INDEX_None)
	{
		AuthRequestServerDelegates[AuthRequestServerDelegates.Length] = AuthRequestServerDelegate;
	}
}

/**
 * Removes the specified delegate from the notification list
 *
 * @param AuthRequestServerDelegate	The delegate to remove from the list
 */
function ClearAuthRequestServerDelegate(delegate<OnAuthRequestServer> AuthRequestServerDelegate)
{
	local int i;

	i = AuthRequestServerDelegates.Find(AuthRequestServerDelegate);

	if (i != INDEX_None)
	{
		AuthRequestServerDelegates.Remove(i, 1);
	}
}

/**
 * Called when the server receives auth data from a client, needed for authentication
 *
 * @param ClientUID		The UID of the client
 * @param ClientIP		The IP of the client
 * @param AuthBlobUID		The UID used to reference the auth data
 */
//delegate OnAuthBlobReceivedClient(UniqueNetId ClientUID, int ClientIP, int AuthBlobUID);

/**
 * Sets the delegate used to notify when the server receives a auth data from a client
 *
 * @param AuthBlobReceivedClientDelegate	The delegate to use for notifications
 */
function AddAuthBlobReceivedClientDelegate(delegate<OnAuthBlobReceivedClient> AuthBlobReceivedClientDelegate)
{
	if (AuthBlobReceivedClientDelegates.Find(AuthBlobReceivedClientDelegate) == INDEX_None)
	{
		AuthBlobReceivedClientDelegates[AuthBlobReceivedClientDelegates.Length] = AuthBlobReceivedClientDelegate;
	}
}

/**
 * Removes the specified delegate from the notification list
 *
 * @param AuthBlobReceivedClientDelegate	The delegate to remove from the list
 */
function ClearAuthBlobReceivedClientDelegate(delegate<OnAuthBlobReceivedClient> AuthBlobReceivedClientDelegate)
{
	local int i;

	i = AuthBlobReceivedClientDelegates.Find(AuthBlobReceivedClientDelegate);

	if (i != INDEX_None)
	{
		AuthBlobReceivedClientDelegates.Remove(i, 1);
	}
}

/**
 * Called when the client receives auth data from the server, needed for authentication
 *
 * @param ServerUID		The UID of the server
 * @param ServerIP		The IP of the server
 * @param AuthBlobUID		The UID used to reference the auth data
 */
//delegate OnAuthBlobReceivedServer(UniqueNetId ServerUID, int ServerIP, int AuthBlobUID);

/**
 * Sets the delegate used to notify when the client receives a auth data from the server
 *
 * @param AuthBlobReceivedServerDelegate	The delegate to use for notifications
 */
function AddAuthBlobReceivedServerDelegate(delegate<OnAuthBlobReceivedServer> AuthBlobReceivedServerDelegate)
{
	if (AuthBlobReceivedServerDelegates.Find(AuthBlobReceivedServerDelegate) == INDEX_None)
	{
		AuthBlobReceivedServerDelegates[AuthBlobReceivedServerDelegates.Length] = AuthBlobReceivedServerDelegate;
	}
}

/**
 * Removes the specified delegate from the notification list
 *
 * @param AuthBlobReceivedServerDelegate	The delegate to remove from the list
 */
function ClearAuthBlobReceivedServerDelegate(delegate<OnAuthBlobReceivedServer> AuthBlobReceivedServerDelegate)
{
	local int i;

	i = AuthBlobReceivedServerDelegates.Find(AuthBlobReceivedServerDelegate);

	if (i != INDEX_None)
	{
		AuthBlobReceivedServerDelegates.Remove(i, 1);
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
//delegate OnAuthCompleteClient(bool bSuccess, UniqueNetId ClientUID, Player ClientConnection, string ExtraInfo);

/**
 * Sets the delegate used to notify when the server receives the authentication result for a client
 *
 * @param AuthCompleteClientDelegate	The delegate to use for notifications
 */
function AddAuthCompleteClientDelegate(delegate<OnAuthCompleteClient> AuthCompleteClientDelegate)
{
	if (AuthCompleteClientDelegates.Find(AuthCompleteClientDelegate) == INDEX_None)
	{
		AuthCompleteClientDelegates[AuthCompleteClientDelegates.Length] = AuthCompleteClientDelegate;
	}
}

/**
 * Removes the specified delegate from the notification list
 *
 * @param AuthCompleteClientDelegate	The delegate to remove from the list
 */
function ClearAuthCompleteClientDelegate(delegate<OnAuthCompleteClient> AuthCompleteClientDelegate)
{
	local int i;

	i = AuthCompleteClientDelegates.Find(AuthCompleteClientDelegate);

	if (i != INDEX_None)
	{
		AuthCompleteClientDelegates.Remove(i, 1);
	}
}

/**
 * Called on the client, when the authentication result for the server has returned
 *
 * @param bSuccess		Wether or not authentication was successful
 * @param ServerUID		The UID of the server
 * @param ServerConnection	The connection associated with the server (for retrieving auth session data)
 * @param ExtraInfo		Extra information about authentication, e.g. failure reasons
 */
//delegate OnAuthCompleteServer(bool bSuccess, UniqueNetId ServerUID, Player ServerConnection, string ExtraInfo);

/**
 * Sets the delegate used to notify when the client receives the authentication result for the server
 *
 * @param AuthCompleteServerDelegate	The delegate to use for notifications
 */
function AddAuthCompleteServerDelegate(delegate<OnAuthCompleteServer> AuthCompleteServerDelegate)
{
	if (AuthCompleteServerDelegates.Find(AuthCompleteServerDelegate) == INDEX_None)
	{
		AuthCompleteServerDelegates[AuthCompleteServerDelegates.Length] = AuthCompleteServerDelegate;
	}
}

/**
 * Removes the specified delegate from the notification list
 *
 * @param AuthCompleteServerDelegate	The delegate to remove from the list
 */
function ClearAuthCompleteServerDelegate(delegate<OnAuthCompleteServer> AuthCompleteServerDelegate)
{
	local int i;

	i = AuthCompleteServerDelegates.Find(AuthCompleteServerDelegate);

	if (i != INDEX_None)
	{
		AuthCompleteServerDelegates.Remove(i, 1);
	}
}

/**
 * Called when the client receives a request from the server, to end an active auth session
 *
 * @param ServerConnection	The server NetConnection
 */
//delegate OnAuthKillClient(Player ServerConnection);

/**
 * Sets the delegate used to notify when the client receives a request from the server, to end an active auth session
 *
 * @param AuthKillClientDelegate	The delegate to use for notifications
 */
function AddAuthKillClientDelegate(delegate<OnAuthKillClient> AuthKillClientDelegate)
{
	if (AuthKillClientDelegates.Find(AuthKillClientDelegate) == INDEX_None)
	{
		AuthKillClientDelegates[AuthKillClientDelegates.Length] = AuthKillClientDelegate;
	}
}

/**
 * Removes the specified delegate from the notification list
 *
 * @param AuthKillClientDelegate	The delegate to remove from the list
 */
function ClearAuthKillClientDelegate(delegate<OnAuthKillClient> AuthKillClientDelegate)
{
	local int i;

	i = AuthKillClientDelegates.Find(AuthKillClientDelegate);

	if (i != INDEX_None)
	{
		AuthKillClientDelegates.Remove(i, 1);
	}
}

/**
 * Called when the server receives a server auth retry request from a client
 *
 * @param ClientConnection	The client NetConnection
 */
//delegate OnAuthRetryServer(Player ClientConnection);

/**
 * Sets the delegate used to notify when the server receives a request from the client, to retry server auth
 *
 * @param AuthRetryServerDelegate	The delegate to use for notifications
 */
function AddAuthRetryServerDelegate(delegate<OnAuthRetryServer> AuthRetryServerDelegate)
{
	if (AuthRetryServerDelegates.Find(AuthRetryServerDelegate) == INDEX_None)
	{
		AuthRetryServerDelegates[AuthRetryServerDelegates.Length] = AuthRetryServerDelegate;
	}
}

/**
 * Removes the specified delegate from the notification list
 *
 * @param AuthRetryServerDelegate	The delegate to remove from the list
 */
function ClearAuthRetryServerDelegate(delegate<OnAuthRetryServer> AuthRetryServerDelegate)
{
	local int i;

	i = AuthRetryServerDelegates.Find(AuthRetryServerDelegate);

	if (i != INDEX_None)
	{
		AuthRetryServerDelegates.Remove(i, 1);
	}
}

/**
 * Called on the server when a clients net connection is closing (so auth sessions can be ended)
 *
 * @param ClientConnection	The client NetConnection that is closing
 */
//delegate OnClientConnectionClose(Player ClientConnection);

/**
 * Sets the delegate used to notify when the a client net connection is closing
 *
 * @param ClientConnectionCloseDelegate		The delegate to use for notifications
 */
function AddClientConnectionCloseDelegate(delegate<OnClientConnectionClose> ClientConnectionCloseDelegate)
{
	if (ClientConnectionCloseDelegates.Find(ClientConnectionCloseDelegate) == INDEX_None)
	{
		ClientConnectionCloseDelegates[ClientConnectionCloseDelegates.Length] = ClientConnectionCloseDelegate;
	}
}

/**
 * Removes the specified delegate from the notification list
 *
 * @param ClientConnectionCloseDelegate		The delegate to remove from the list
 */
function ClearClientConnectionCloseDelegate(delegate<OnClientConnectionClose> ClientConnectionCloseDelegate)
{
	local int i;

	i = ClientConnectionCloseDelegates.Find(ClientConnectionCloseDelegate);

	if (i != INDEX_None)
	{
		ClientConnectionCloseDelegates.Remove(i, 1);
	}
}


/**
 * Called on the client when a server net connection is closing (so auth sessions can be ended)
 *
 * @param ServerConnection	The server NetConnection that is closing
 */
//delegate OnServerConnectionClose(Player ServerConnection);

/**
 * Sets the delegate used to notify when the a server net connection is closing
 *
 * @param ServerConnectionCloseDelegate		The delegate to use for notifications
 */
function AddServerConnectionCloseDelegate(delegate<OnServerConnectionClose> ServerConnectionCloseDelegate)
{
	if (ServerConnectionCloseDelegates.Find(ServerConnectionCloseDelegate) == INDEX_None)
	{
		ServerConnectionCloseDelegates[ServerConnectionCloseDelegates.Length] = ServerConnectionCloseDelegate;
	}
}

/**
 * Removes the specified delegate from the notification list
 *
 * @param ServerConnectionCloseDelegate		The delegate to remove from the list
 */
function ClearServerConnectionCloseDelegate(delegate<OnServerConnectionClose> ServerConnectionCloseDelegate)
{
	local int i;

	i = ServerConnectionCloseDelegates.Find(ServerConnectionCloseDelegate);

	if (i != INDEX_None)
	{
		ServerConnectionCloseDelegates.Remove(i, 1);
	}
}


/**
 * Sends the specified auth blob from the client to the server
 *
 * @param AuthBlobUID		The UID of the auth blob, as retrieved by CreateClientAuthSession
 * @return			Wether or not the auth blob was sent successfully
 */
native function bool SendAuthBlobClient(int AuthBlobUID);

/**
 * Sends the specified auth blob from the server to the client
 *
 * @param ClientConnection	The NetConnection of the client to send the auth blob to
 * @param AuthBlobUID		The UID of the auth blob, as retrieved by CreateServerAuthSession
 * @return			Wether or not the auth blob was sent successfully
 */
native function bool SendAuthBlobServer(Player ClientConnection, int AuthBlobUID);

/**
 * Sends an auth kill request to the specified client
 *
 * @param ClientConnection	The NetConnection of the client to send the request to
 * @return			Wether or not the request was sent successfully
 */
native function bool SendAuthKillClient(Player ClientConnection);

/**
 * Sends a server auth retry request to the server
 *
 * @return			Wether or not the request was sent successfully
 */
native function bool SendAuthRetryServer();


/**
 * Auth info access functions
 */

/**
 * Find the index of an active/pending client auth session, for the client associated with the specified NetConnection
 *
 * @param ClientConnection	The NetConnection associated with the client
 * @return			The index into ClientAuthSessions, or INDEX_None if it was not found
 */
native function int FindClientAuthSession(Player ClientConnection);

/**
 * Find the index for the clientside half of an active/pending client auth session
 *
 * @param ServerConnection	The NetConnection associated with the server
 * @return			The index into ClientAuthSessions, or INDEX_None if it was not found
 */
native function int FindLocalClientAuthSession(Player ServerConnection);

/**
 * Find the index of an active/pending server auth session, for the specified server connection
 *
 * @param ServerConnection	The NetConnection associated with the server
 * @return			The index into ClientAuthSessions, or INDEX_None if it was not found
 */
native function int FindServerAuthSession(Player ServerConnection);

/**
 * Find the index for the serverside half of an active/pending server auth session
 *
 * @param ClientConnection	The NetConnection associated with the client
 * @return			The index into ClientAuthSessions, or INDEX_None if it was not found
 */
native function int FindLocalServerAuthSession(Player ClientConnection);







