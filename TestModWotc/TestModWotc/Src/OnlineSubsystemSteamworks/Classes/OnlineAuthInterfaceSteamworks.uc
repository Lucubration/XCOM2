/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

/**
 * Class that implements the Steamworks specific auth functionality
 */
Class OnlineAuthInterfaceSteamworks extends OnlineAuthInterfaceImpl within OnlineSubsystemCommonImpl
	native;

cpptext
{
#if WITH_UE3_NETWORKING && WITH_STEAMWORKS
	/**
	 * Cleanup
	 */
	virtual void FinishDestroy();

	/**
	 * Control channel messages
	 */

	/**
	 * Control channel message sent from one client to another (relayed by server), requesting an auth session with that client
	 *
	 * @param Connection		The NetConnection the message came from
	 * @param RemoteUID		The UID of the client that sent the request
	 */
	void OnAuthRequestPeer(UNetConnection* Connection, QWORD RemoteUID);

	/**
	 * Control message sent from one client to another (relayed by server), containing data for auth verification
	 *
	 * @param Connection		The NetConnection the message came from
	 * @param RemoteUID		The UID of the client that sent the blob data
	 * @param BlobChunk		The current chunk of auth blob data
	 * @param Current		The current sequence of blob data
	 * @param Num			The total number of blobs being received
	 */
	void OnAuthBlobPeer(UNetConnection* Connection, QWORD RemoteUID, const FString& BlobChunk, BYTE Current, BYTE Num);

	/**
	 * Control message sent from the server to client, for ending an active auth session
	 *
	 * @param Connection		The NetConnection the message came from
	 */
	void OnAuthKillClient(UNetConnection* Connection);

	/**
	 * Control message sent from one client to another (relayed by server), for ending an active auth session
	 *
	 * @param Connection		The NetConnection the message came from
	 * @param RemoteUID		The UID of the client that's ending the auth session
	 */
	void OnAuthKillPeer(UNetConnection* Connection, QWORD RemoteUID);

	/**
	 * Control message sent from client to server, requesting an auth retry
	 *
	 * @param Connection		The NetConnection the message came from
	 */
	void OnAuthRetry(UNetConnection* Connection);


	/**
	 * Steam callbacks
	 */

	/**
	 * Steam callback: Steam auth approved client
	 * @todo: redo desc
	 */
	void OnGSClientApprove(GSClientApprove_t* CallbackData);

	/**
	 * Steam callback: Steam auth denied client
	 * @todo: redo desc
	 */
	void OnGSClientDeny(GSClientDeny_t* CallbackData);

	/**
	 * Steam callback: Steam auth result client
	 * @todo: redo desc
	 */
	void OnGSClientValidateAuth(ValidateAuthTicketResponse_t* CallbackData);

	/**
	 * Steam callback: Steam auth kicked client
	 * @todo: redo desc
	 */
	void OnGSClientKick(GSClientKick_t* CallbackData);


	/**
	 * Called when GSteamGameServer is fully setup and ready to authenticate players
	 */
	void NotifyGameServerAuthReady();

	/**
	 * Handles client authentication success/fails
	 * @todo: Copy from cpp
	 */
	void ClientAuthComplete(UBOOL bSuccess, const QWORD SteamId, const FString ExtraInfo);
#endif	// WITH_UE3_NETWORKING && WITH_STEAMWORKS
}

/** Pointer to the class which handles callbacks from Steam */
var native pointer AuthCallbackBridge{SteamAuthCallbackBridge};


/**
 * Sends a client auth request to the specified client
 * NOTE: It is important to specify the ClientUID from PreLogin
 *
 * @param ClientConnection	The NetConnection of the client to send the request to
 * @param ClientUID		The UID of the client (as taken from PreLogin)
 * @return			Wether or not the request kicked off successfully
 */
native function bool SendAuthRequestClient(Player ClientConnection, UniqueNetId ClientUID);

/**
 * Sends a server auth request to the server
 *
 * @param ServerUID		The UID of the server
 * @return			Wether or not the request kicked off successfully
 */
native function bool SendAuthRequestServer(UniqueNetId ServerUID);


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
native function bool CreateClientAuthSession(UniqueNetId ServerUID, int ServerIP, int ServerPort, bool bSecure, out int OutAuthBlobUID);

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
native function bool VerifyClientAuthSession(UniqueNetId ClientUID, int ClientIP, int ClientPort, int AuthBlobUID);

/**
 * Ends the clientside half of a client auth session
 * NOTE: This call must be matched on the server, with EndRemoteClientAuthSession
 *
 * @param ServerUID		The UID of the server
 * @param ServerIP		The external (public) IP address of the server
 * @param ServerPort		The port of the server
 */
native function EndLocalClientAuthSession(UniqueNetId ServerUID, int ServerIP, int ServerPort);

/**
 * Ends the serverside half of a client auth session
 * NOTE: This call must be matched on the client, with EndLocalClientAuthSession
 *
 * @param ClientUID		The UID of the client
 * @param ClientIP		The IP address of the client
 */
native function EndRemoteClientAuthSession(UniqueNetId ClientUID, int ClientIP);


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
native function bool CreateServerAuthSession(UniqueNetId ClientUID, int ClientIP, int ClientPort, out int OutAuthBlobUID);

/**
 * Kicks off asynchronous verification and setup of a server auth session, on the client;
 * auth success/failure is returned through OnAuthCompleteServer
 *
 * @param ServerUID		The UID of the server
 * @param ServerIP		The external/public IP address of the server
 * @param AuthBlobUID		The UID of the auth data sent by the server (as obtained through OnAuthBlobReceivedServer)
 * @return			Wether or not asynchronous verification was kicked off successfully
 */
native function bool VerifyServerAuthSession(UniqueNetId ServerUID, int ServerIP, int AuthBlobUID);

/**
 * Ends the serverside half of a server auth session
 * NOTE: This call must be matched on the other end, with EndRemoteServerAuthSession
 *
 * @param ClientUID		The UID of the client
 * @param ClientIP		The IP address of the client
 */
native function EndLocalServerAuthSession(UniqueNetId ClientUID, int ClientIP);

/**
 * Ends the clientside half of a server auth session
 * NOTE: This call must be matched on the other end, with EndLocalServerAuthSession
 *
 * @param ServerUID		The UID of the server
 * @param ServerIP		The external/public IP address of the server
 */
native function EndRemoteServerAuthSession(UniqueNetId ServerUID, int ServerIP);


/**
 * Platform-specific erver information
 */

/**
 * If this is a server, retrieves the platform-specific UID of the server; used for authentication (not supported on all platforms)
 * NOTE: This is primarily used serverside, for listen host authentication
 *
 * @param OutServerUID		The UID of the server
 * @return			Wether or not the server UID was retrieved
 */
native function bool GetServerUniqueId(out UniqueNetId OutServerUID);

/**
 * If this is a server, retrieves the platform-specific IP and port of the server; used for authentication
 * NOTE: This is primarily used serverside, for listen host authentication
 *
 * @param OutServerIP		The public IP of the server (or, for platforms which don't support it, the local IP)
 * @param OutServerPort		The port of the server
 */
native function bool GetServerAddr(out int OutServerIP, out int OutServerPort);







