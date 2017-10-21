/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

/**
 * This interface deals with multiplayer authentication between players and servers
 *
 * NOTE: It is not a good idea to store 'Player' object references outside of Actor classes (and even then, you must be careful);
 *		instead, Player/NetConnection's should be tracked by IP and Port, where possible (see 'AllClientConnections' in WorldInfo)
 */
interface OnlineAuthInterface
	dependson(OnlineSubsystem);

/**
 * Used to check if the auth interface is ready to perform authentication
 *
 * @return	Wether or not the auth interface is ready
 */
function bool IsReady();

/**
 * Called when the auth interface is ready to perform authentication
 */
delegate OnAuthReady();

/**
 * Sets the delegate used to notify when the auth interface is ready to perform authentication
 *
 * @param AuthReadyDelegate	The delegate to use for notification
 */
function AddAuthReadyDelegate(delegate<OnAuthReady> AuthReadyDelegate);

/**
 * Removes the specified delegate from the notification list
 *
 * @param AuthReadyDelegate	The delegate to remove from the list
 */
function ClearAuthReadyDelegate(delegate<OnAuthReady> AuthReadyDelegate);

/**
 * Called when the client receives a message from the server, requesting a client auth session
 *
 * @param ServerUID		The UID of the game server
 * @param ServerIP		The public (external) IP of the game server
 * @param ServerPort		The port of the game server
 * @param bSecure		Wether or not the server has anticheat enabled (relevant to OnlineSubsystemSteamworks and VAC)
 */
delegate OnAuthRequestClient(UniqueNetId ServerUID, int ServerIP, int ServerPort, bool bSecure);

/**
 * Sets the delegate used to notify when the client receives a message from the server, requesting a client auth session
 *
 * @param AuthRequestClientDelegate	The delegate to use for notifications
 */
function AddAuthRequestClientDelegate(delegate<OnAuthRequestClient> AuthRequestClientDelegate);

/**
 * Removes the specified delegate from the notification list
 *
 * @param AuthRequestClientDelegate	The delegate to remove from the list
 */
function ClearAuthRequestClientDelegate(delegate<OnAuthRequestClient> AuthRequestClientDelegate);

/**
 * Called when the server receives a message from a client, requesting a server auth session
 *
 * @param ClientConnection	The NetConnection of the client the request came from
 * @param ClientUID		The UID of the client making the request
 * @param ClientIP		The IP of the client making the request
 * @param ClientPort		The port the client is on
 */
delegate OnAuthRequestServer(Player ClientConnection, UniqueNetId ClientUID, int ClientIP, int ClientPort);

/**
 * Sets the delegate used to notify when the server receives a message from a client, requesting a server auth session
 *
 * @param AuthRequestServerDelegate	The delegate to use for notifications
 */
function AddAuthRequestServerDelegate(delegate<OnAuthRequestServer> AuthRequestServerDelegate);

/**
 * Removes the specified delegate from the notification list
 *
 * @param AuthRequestServerDelegate	The delegate to remove from the list
 */
function ClearAuthRequestServerDelegate(delegate<OnAuthRequestServer> AuthRequestServerDelegate);

/**
 * Called when the server receives auth data from a client, needed for authentication
 *
 * @param ClientUID		The UID of the client
 * @param ClientIP		The IP of the client
 * @param AuthBlobUID		The UID used to reference the auth data
 */
delegate OnAuthBlobReceivedClient(UniqueNetId ClientUID, int ClientIP, int AuthBlobUID);

/**
 * Sets the delegate used to notify when the server receives a auth data from a client
 *
 * @param AuthBlobReceivedClientDelegate	The delegate to use for notifications
 */
function AddAuthBlobReceivedClientDelegate(delegate<OnAuthBlobReceivedClient> AuthBlobReceivedClientDelegate);

/**
 * Removes the specified delegate from the notification list
 *
 * @param AuthBlobReceivedClientDelegate	The delegate to remove from the list
 */
function ClearAuthBlobReceivedClientDelegate(delegate<OnAuthBlobReceivedClient> AuthBlobReceivedClientDelegate);

/**
 * Called when the client receives auth data from the server, needed for authentication
 *
 * @param ServerUID		The UID of the server
 * @param ServerIP		The IP of the server
 * @param AuthBlobUID		The UID used to reference the auth data
 */
delegate OnAuthBlobReceivedServer(UniqueNetId ServerUID, int ServerIP, int AuthBlobUID);

/**
 * Sets the delegate used to notify when the client receives a auth data from the server
 *
 * @param AuthBlobReceivedServerDelegate	The delegate to use for notifications
 */
function AddAuthBlobReceivedServerDelegate(delegate<OnAuthBlobReceivedServer> AuthBlobReceivedServerDelegate);

/**
 * Removes the specified delegate from the notification list
 *
 * @param AuthBlobReceivedServerDelegate	The delegate to remove from the list
 */
function ClearAuthBlobReceivedServerDelegate(delegate<OnAuthBlobReceivedServer> AuthBlobReceivedServerDelegate);

/**
 * Called on the server, when the authentication result for a client auth session has returned
 * NOTE: This is the first place, where a clients UID is verified as valid
 *
 * @param bSuccess		Wether or not authentication was successful
 * @param ClientUID		The UID of the client
 * @param ClientConnection	The connection associated with the client (for retrieving auth session data)
 * @param ExtraInfo		Extra information about authentication, e.g. failure reasons
 */
delegate OnAuthCompleteClient(bool bSuccess, UniqueNetId ClientUID, Player ClientConnection, string ExtraInfo);

/**
 * Sets the delegate used to notify when the server receives the authentication result for a client
 *
 * @param AuthCompleteClientDelegate	The delegate to use for notifications
 */
function AddAuthCompleteClientDelegate(delegate<OnAuthCompleteClient> AuthCompleteClientDelegate);

/**
 * Removes the specified delegate from the notification list
 *
 * @param AuthCompleteClientDelegate	The delegate to remove from the list
 */
function ClearAuthCompleteClientDelegate(delegate<OnAuthCompleteClient> AuthCompleteClientDelegate);

/**
 * Called on the client, when the authentication result for the server has returned
 *
 * @param bSuccess		Wether or not authentication was successful
 * @param ServerUID		The UID of the server
 * @param ServerConnection	The connection associated with the server (for retrieving auth session data)
 * @param ExtraInfo		Extra information about authentication, e.g. failure reasons
 */
delegate OnAuthCompleteServer(bool bSuccess, UniqueNetId ServerUID, Player ServerConnection, string ExtraInfo);

/**
 * Sets the delegate used to notify when the client receives the authentication result for the server
 *
 * @param AuthCompleteServerDelegate	The delegate to use for notifications
 */
function AddAuthCompleteServerDelegate(delegate<OnAuthCompleteServer> AuthCompleteServerDelegate);

/**
 * Removes the specified delegate from the notification list
 *
 * @param AuthCompleteServerDelegate	The delegate to remove from the list
 */
function ClearAuthCompleteServerDelegate(delegate<OnAuthCompleteServer> AuthCompleteServerDelegate);

/**
 * Called when the client receives a request from the server, to end an active auth session
 *
 * @param ServerConnection	The server NetConnection
 */
delegate OnAuthKillClient(Player ServerConnection);

/**
 * Sets the delegate used to notify when the client receives a request from the server, to end an active auth session
 *
 * @param AuthKillClientDelegate	The delegate to use for notifications
 */
function AddAuthKillClientDelegate(delegate<OnAuthKillClient> AuthKillClientDelegate);

/**
 * Removes the specified delegate from the notification list
 *
 * @param AuthKillClientDelegate	The delegate to remove from the list
 */
function ClearAuthKillClientDelegate(delegate<OnAuthKillClient> AuthKillClientDelegate);

/**
 * Called when the server receives a server auth retry request from a client
 *
 * @param ClientConnection	The client NetConnection
 */
delegate OnAuthRetryServer(Player ClientConnection);

/**
 * Sets the delegate used to notify when the server receives a request from the client, to retry server auth
 *
 * @param AuthRetryServerDelegate	The delegate to use for notifications
 */
function AddAuthRetryServerDelegate(delegate<OnAuthRetryServer> AuthRetryServerDelegate);

/**
 * Removes the specified delegate from the notification list
 *
 * @param AuthRetryServerDelegate	The delegate to remove from the list
 */
function ClearAuthRetryServerDelegate(delegate<OnAuthRetryServer> AuthRetryServerDelegate);

/**
 * Called on the server when a clients net connection is closing (so auth sessions can be ended)
 *
 * @param ClientConnection	The client NetConnection that is closing
 */
delegate OnClientConnectionClose(Player ClientConnection);

/**
 * Sets the delegate used to notify when the a client net connection is closing
 *
 * @param ClientConnectionCloseDelegate		The delegate to use for notifications
 */
function AddClientConnectionCloseDelegate(delegate<OnClientConnectionClose> ClientConnectionCloseDelegate);

/**
 * Removes the specified delegate from the notification list
 *
 * @param ClientConnectionCloseDelegate		The delegate to remove from the list
 */
function ClearClientConnectionCloseDelegate(delegate<OnClientConnectionClose> ClientConnectionCloseDelegate);

/**
 * Called on the client when a server net connection is closing (so auth sessions can be ended)
 *
 * @param ServerConnection	The server NetConnection that is closing
 */
delegate OnServerConnectionClose(Player ServerConnection);

/**
 * Sets the delegate used to notify when the a server net connection is closing
 *
 * @param ServerConnectionCloseDelegate		The delegate to use for notifications
 */
function AddServerConnectionCloseDelegate(delegate<OnServerConnectionClose> ServerConnectionCloseDelegate);

/**
 * Removes the specified delegate from the notification list
 *
 * @param ServerConnectionCloseDelegate		The delegate to remove from the list
 */
function ClearServerConnectionCloseDelegate(delegate<OnServerConnectionClose> ServerConnectionCloseDelegate);


/**
 * Sends a client auth request to the specified client
 * NOTE: It is important to specify the ClientUID from PreLogin
 *
 * @param ClientConnection	The NetConnection of the client to send the request to
 * @param ClientUID		The UID of the client (as taken from PreLogin)
 * @return			Wether or not the request kicked off successfully
 */
function bool SendAuthRequestClient(Player ClientConnection, UniqueNetId ClientUID);

/**
 * Sends a server auth request to the server
 *
 * @param ServerUID		The UID of the server
 * @return			Wether or not the request kicked off successfully
 */
function bool SendAuthRequestServer(UniqueNetId ServerUID);

/**
 * Sends the specified auth blob from the client to the server
 *
 * @param AuthBlobUID		The UID of the auth blob, as retrieved by CreateClientAuthSession
 * @return			Wether or not the auth blob was sent successfully
 */
function bool SendAuthBlobClient(int AuthBlobUID);

/**
 * Sends the specified auth blob from the server to the client
 *
 * @param ClientConnection	The NetConnection of the client to send the auth blob to
 * @param AuthBlobUID		The UID of the auth blob, as retrieved by CreateServerAuthSession
 * @return			Wether or not the auth blob was sent successfully
 */
function bool SendAuthBlobServer(Player ClientConnection, int AuthBlobUID);

/**
 * Sends an auth kill request to the specified client
 *
 * @param ClientConnection	The NetConnection of the client to send the request to
 * @return			Wether or not the request was sent successfully
 */
function bool SendAuthKillClient(Player ClientConnection);

/**
 * Sends a server auth retry request to the server
 *
 * @return			Wether or not the request was sent successfully
 */
function bool SendAuthRetryServer();


/**
 * Client auth functions, for authenticating clients with a game server
 */

/**
 * Creates a client auth session with the server; the session doesn't start until the auth blob is verified by the server
 * NOTE: This must be called clientside
 *
 * @param ServerUID		The UID of the server
 * @param ServerIP		The external/public IP address of the server
 * @param ServerPort		The port of the server
 * @param bSecure		Wether or not the server has cheat protection enabled
 * @param OutAuthBlobUID	Outputs the UID of the auth data, which is used to verify the auth session on the server
 * @return			Wether or not the local half of the auth session was kicked off successfully
 */
function bool CreateClientAuthSession(UniqueNetId ServerUID, int ServerIP, int ServerPort, bool bSecure, out int OutAuthBlobUID);

/**
 * Kicks off asynchronous verification and setup of a client auth session, on the server;
 * auth success/failure is returned through OnAuthCompleteClient
 *
 * @param ClientUID		The UID of the client
 * @param ClientIP		The IP address of the client
 * @param ClientPort		The port the client is on
 * @param AuthBlobUID		The UID for the auth data sent by the client (as obtained through OnAuthBlobReceivedClient)
 * @return			Wether or not asynchronous verification was kicked off successfully
 */
function bool VerifyClientAuthSession(UniqueNetId ClientUID, int ClientIP, int ClientPort, int AuthBlobUID);

/**
 * Ends the clientside half of a client auth session
 * NOTE: This call must be matched on the server, with EndRemoteClientAuthSession
 *
 * @param ServerUID		The UID of the server
 * @param ServerIP		The external (public) IP address of the server
 * @param ServerPort		The port of the server
 */
function EndLocalClientAuthSession(UniqueNetId ServerUID, int ServerIP, int ServerPort);

/**
 * Ends the serverside half of a client auth session
 * NOTE: This call must be matched on the client, with EndLocalClientAuthSession
 *
 * @param ClientUID		The UID of the client
 * @param ClientIP		The IP address of the client
 */
function EndRemoteClientAuthSession(UniqueNetId ClientUID, int ClientIP);


/**
 * Server auth functions, for authenticating the server with clients
 */

/**
 * Creates a server auth session with a client; the session doesn't start until the auth blob is verified by the client
 * NOTE: This must be called serverside; if using server auth, the server should create a server auth session for every client
 *
 * @param ClientUID		The UID of the client
 * @param ClientIP		The IP address of the client
 * @param ClientPort		The port of the client
 * @param OutAuthBlobUID	Outputs the UID of the auth data, which is used to verify the auth session on the client
 * @return			Wether or not the local half of the auth session was kicked off successfully
 */
function bool CreateServerAuthSession(UniqueNetId ClientUID, int ClientIP, int ClientPort, out int OutAuthBlobUID);

/**
 * Kicks off asynchronous verification and setup of a server auth session, on the client;
 * auth success/failure is returned through OnAuthCompleteServer
 *
 * @param ServerUID		The UID of the server
 * @param ServerIP		The external/public IP address of the server
 * @param AuthBlobUID		The UID of the auth data sent by the server (as obtained through OnAuthBlobReceivedServer)
 * @return			Wether or not asynchronous verification was kicked off successfully
 */
function bool VerifyServerAuthSession(UniqueNetId ServerUID, int ServerIP, int AuthBlobUID);

/**
 * Ends the serverside half of a server auth session
 * NOTE: This call must be matched on the other end, with EndRemoteServerAuthSession
 *
 * @param ClientUID		The UID of the client
 * @param ClientIP		The IP address of the client
 */
function EndLocalServerAuthSession(UniqueNetId ClientUID, int ClientIP);

/**
 * Ends the clientside half of a server auth session
 * NOTE: This call must be matched on the other end, with EndLocalServerAuthSession
 *
 * @param ServerUID		The UID of the server
 * @param ServerIP		The external/public IP address of the server
 */
function EndRemoteServerAuthSession(UniqueNetId ServerUID, int ServerIP);


/**
 * Platform specific server information
 */

/**
 * If this is a server, retrieves the platform-specific UID of the server; used for authentication (not supported on all platforms)
 * NOTE: This is primarily used serverside, for listen host authentication
 *
 * @param OutServerUID		The UID of the server
 * @return			Wether or not the server UID was retrieved
 */
function bool GetServerUniqueId(out UniqueNetId OutServerUID);

/**
 * If this is a server, retrieves the platform-specific IP and port of the server; used for authentication
 * NOTE: This is primarily used serverside, for listen host authentication
 *
 * @param OutServerIP		The public IP of the server (or, for platforms which don't support it, the local IP)
 * @param OutServerPort		The port of the server
 */
function bool GetServerAddr(out int OutServerIP, out int OutServerPort);







