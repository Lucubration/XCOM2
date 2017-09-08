/**
 * Copyright 1998-2008 Epic Games, Inc. All Rights Reserved.
 */
//=============================================================================
// CheatManager
// Object within playercontroller that manages "cheat" commands
//=============================================================================

class XComShellCheatManager extends XComCheatManager // within XComPlayerControllerNativeBase
	dependson(XComShellPresentationLayer);
	//native;



exec function  Help(optional string tok)
{  
	`log( "=============== Add more Help in XComShellCheatManager =" );

	super.Help(tok);

	HelpDESC( "listui",   "list all UI screens currently in the manager,  in the log ");
	HelpDESC( "flushonlinestats",   "flushes out all online stats for session 'game' unless another name is specified");
	HelpDESC( "displaympmatchcriteria", "prints out all criteria used for multiplayer match making");
	OutputMsg("====================================================");
}

function HelpDESC( string func, string description)
{
	OutputMsg(""@func@"-"@description);
}

function OutputMsg( string msg)
{
    local Console PlayerConsole;
    local LocalPlayer LP;

	LP = LocalPlayer( Outer.Player );
	if( ( LP != none )  && ( LP.ViewportClient.ViewportConsole != none ) )
	{
		PlayerConsole = LocalPlayer( Player ).ViewportClient.ViewportConsole;
		PlayerConsole.OutputText(msg);
	}

    //Output to log just encase..
	`log(msg);
}

exec function listui()
{
	XComPlayerController(Outer).Pres.UIStatus();
}

exec function uitracethings( int numTraces )
{
	UIStartScreen(XComShellPresentationLayer(XComPlayerController(Outer).Pres).ScreenStack.GetScreen(class'UIStartScreen')).AS_TraceThings( numTraces );
}

exec function uinotrace( int numTraces )
{
	UIStartScreen(XComShellPresentationLayer(XComPlayerController(Outer).Pres).ScreenStack.GetScreen(class'UIStartScreen')).AS_NoTrace();
}

exec function flushonlinestats( name SessionName='Game')
{
	`log(`location @ `ShowVar(SessionName) @ `ShowVar(XComPlayerController(Outer).PlayerReplicationInfo,PlayerReplicationInfo));
	OnlineSub.StatsInterface.FlushOnlineStats(SessionName);
}

exec function displaympmatchcriteria()
{
	local string ByteCodeHash, INIHash;
	local int InstalledDLCHash, InstalledModsHash;
	local bool IsDevConsoleEnabled;

	ByteCodeHash = class'Helpers'.static.NetGetVerifyPackageHashes();
	InstalledDLCHash = class'Helpers'.static.NetGetInstalledMPFriendlyDLCHash();
	InstalledModsHash = class'Helpers'.static.NetGetInstalledModsHash();
	INIHash = class'Helpers'.static.NetGetMPINIHash();
	IsDevConsoleEnabled = class'Helpers'.static.IsDevConsoleEnabled();

	OutputMsg("ByteCodeHash #:" @ ByteCodeHash);
	OutputMsg("InstalledDLCHash #:" @ InstalledDLCHash);
	OutputMsg("InstalledModsHash:" @ InstalledModsHash);
	OutputMsg("INIHash:" @ INIHash);
	OutputMsg("IsDevConsoleEnabled:" @ IsDevConsoleEnabled);
}

exec function GetMOTD(optional string Category, optional string MessageType)
{
	`FXSLIVE.AddReceivedMOTDDelegate(OnReceivedMOTD);
	`FXSLIVE.GetMOTD(Category, MessageType);
}

function OnReceivedMOTD(string Category, array<MOTDMessageData> Messages)
{
	local int MessageIdx;
	local string MessageType, Message;
	for( MessageIdx = 0; MessageIdx < Messages.Length; ++MessageIdx )
	{
		MessageType = Messages[MessageIdx].MessageType;
		Message = Messages[MessageIdx].Message;
		`log(self $ "::" $ GetFuncName() @ `ShowVar(Category) @ `ShowVar(MessageType) @ `ShowVar(Message));
	}
	`FXSLIVE.ClearReceivedMOTDDelegate(OnReceivedMOTD);
}

exec function ToggleChallengeModeIntervalDropdown()
{
	`log(`location);
	UIChallengeMode_SquadSelect(XComShellPresentationLayer(XComPlayerController(Outer).Pres).ScreenStack.GetScreen(class'UIChallengeMode_SquadSelect')).ToggleIntervalDropdown();
}

exec function SetChallengeLeaderboardName(string LeaderboardName)
{
	UIChallengeLeaderboards(XComShellPresentationLayer(XComPlayerController(Outer).Pres).ScreenStack.GetScreen(class'UIChallengeLeaderboards')).SetOverrideName(LeaderboardName);
}

exec function DebugProgressDialog()
{
	local TProgressDialogData kConfirmData;

	kConfirmData.strTitle = "DEBUG - Title";
	kConfirmData.strDescription = "Some weird cancel button issue";
	kConfirmData.fnCallback = CloseDebugProgressDialog;

	XComShellPresentationLayer(XComPlayerController(Outer).Pres).UIProgressDialog(kConfirmData);
}

exec function CloseDebugProgressDialog()
{
	XComShellPresentationLayer(XComPlayerController(Outer).Pres).UICloseProgressDialog();
}

defaultproperties
{
}
