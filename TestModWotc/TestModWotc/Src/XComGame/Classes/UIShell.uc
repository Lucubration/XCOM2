//---------------------------------------------------------------------------------------
//  *********   FIRAXIS SOURCE CODE   ******************
//  FILE:    UIShell
//  AUTHOR:  Katie Hirsch       --  04/10/09
//           Tronster Hartley   --  04/23/09
//  PURPOSE: This file controls the game side of the shell menu UI screen.
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//--------------------------------------------------------------------------------------- 

class UIShell extends UIScreen
	config(UI);

//------------------------------------------------------
// LOCALIZED STRINGS
var localized string m_strDemo;
var localized string m_sLoad;
var localized string m_sSpecial;
var localized string m_sOptions;
var localized string m_sStrategy;
var localized string m_sTactical;
var localized string m_sTutorial;
var localized string m_sFinalShellDebug;

//------------------------------------------------------
// MEMBER DATA
var bool      m_bDisableActions;

var bool bLoginInitialized;

var const String strTutorialSave;
var const String strDirectedDemoSave;

var UIPanel MainMenuContainer;
var array<UIButton> MainMenu;
var UIPanel MainMenuBG;
var UIPanel DebugMenuContainer;
var UIPanel Logo; 
var UIScrollingText TickerText;
var UINavigationHelp NavHelp;
var UIPanel TickerBG;
var float DefaultMainMenuOffset;
var float TickerHeight;

var const config float BufferSpace; // pixel buffer between category buttons. 

//bsg-crobinson (5.8.17): Add the bumper icons
var UIGamepadIcons LeftBumperIcon;
var UIGamepadIcons RightBumperIcon;
//bsg-crobinson (5.8.17): end

delegate OnClickedDelegate(UIButton Button);

//==============================================================================
//		INITIALIZATION & INPUT:
//==============================================================================
simulated function InitScreen(XComPlayerController InitController, UIMovie InitMovie, optional name InitName)
{
	super.InitScreen(InitController, InitMovie, InitName);

	if(class'GameEngine'.static.GetOnlineSubsystem() != none && class'GameEngine'.static.GetOnlineSubsystem().GameInterface.GetGameSettings('Game') != none)
	{
		class'GameEngine'.static.GetOnlineSubsystem().GameInterface.DestroyOnlineGame('Game');
	}
	InitMainMenu();

	Navigator.HorizontalNavigation = true;
	
	Logo = Spawn(class'UIPanel', self).InitPanel('X2Logo', 'X2Logo');
	Logo.SetOrigin(class'UIUtilities'.const.ANCHOR_TOP_LEFT);
	Logo.SetAnchor(class'UIUtilities'.const.ANCHOR_TOP_LEFT);
	Logo.SetPosition(20, 20);
	Logo.DisableNavigation();

	`FXSLIVE.AddReceivedMOTDDelegate(OnReceivedMOTD);
	`FXSLIVE.FirstClientInit();
	CreateTicker();
	Logo.DisableNavigation();
}

simulated function OnInit()
{	
	local XComGameStateNetworkManager NetworkMgr;

	super.OnInit();	

	if( !WorldInfo.IsConsoleBuild() )
	{
		SetTimer(0.1f, false, nameof(DelayedLogin));
	}

	// Will display any pending information for the user since the screen has been transitioned. -ttalley
	`ONLINEEVENTMGR.PerformNewScreenInit();
	m_bDisableActions = false;

	// Force any network connections at this point to close
	NetworkMgr = `XCOMNETMANAGER;
	NetworkMgr.Disconnect();

	// The player's profile settings load asynchronously, and update the movie when loaded. This watch ensures we respond to that if it has not yet occurred.
	WorldInfo.MyWatchVariableMgr.RegisterWatchVariable(Movie.Pres.Get2DMovie(), 'MouseActive', self, UpdateNavHelp); 
	UpdateNavHelp();
}
//----------------------------------------------------------

//bsg-crobinson (5.8.17): Spawn and Set the bumper icons
simulated function SpawnNavHelpIcons()
{
	local float IconSizeRatio;
	local float newHeight;
	local float newWidth;
	
	IconSizeRatio = 1.625;
	newHeight = 30;
	newWidth = newHeight * IconSizeRatio;

	LeftBumperIcon = Spawn(class'UIGamepadIcons', self);
	LeftBumperIcon.InitGamepadIcon('NavButtonLeftBumper', class'UIUtilities_Input'.const.ICON_LB_L1);
	LeftBumperIcon.SetSize(newWidth, newHeight);
	LeftBumperIcon.AnchorBottomCenter();
	LeftBumperIcon.SetY(MainMenucontainer.Y - 20);

	RightBumperIcon = Spawn(class'UIGamepadIcons', self);
	RightBumperIcon.InitGamepadIcon('NavButtonRightBumper', class'UIUtilities_Input'.const.ICON_RB_R1);
	RightBumperIcon.SetSize(newWidth, newHeight);
	RightBumperIcon.AnchorBottomCenter();
	RightBumperIcon.SetY(MainMenucontainer.Y - 20);
}
//bsg-crobinson (5.8.17): end

event PreBeginPlay()
{
	super.PreBeginPlay();
	
	SubscribeToOnCleanupWorld();
	`ONLINEEVENTMGR.AddGameInviteAcceptedDelegate(OnGameInviteAccepted);
	`ONLINEEVENTMGR.AddGameInviteCompleteDelegate(OnGameInviteComplete);
}

event Destroyed()
{
	UnsubscribeFromOnCleanupWorld();
	Cleanup();

	super.Destroyed();
}

simulated event OnCleanupWorld()
{
	Cleanup();
	super.OnCleanupWorld();
}

simulated function Cleanup()
{
	`ONLINEEVENTMGR.ClearGameInviteAcceptedDelegate(OnGameInviteAccepted);
	`ONLINEEVENTMGR.ClearGameInviteCompleteDelegate(OnGameInviteComplete);
	`FXSLIVE.ClearReceivedMOTDDelegate(OnReceivedMOTD);
}

simulated function OnGameInviteAccepted(bool bWasSuccessful)
{
	local XComPresentationLayerBase Presentation;
	local TProgressDialogData kDialogData;

	`log(`location, true, 'XCom_Online');
	if(bWasSuccessful)
	{
		m_bDisableActions = true; // BUG 14008: TCR # 115 - [ONLINE] - Users will enter a single player game as they accept an invite and attempt to start a new single player game on the Main Menu. -ttalley

		Presentation = XComPlayerController(class'UIInteraction'.static.GetLocalPlayer(0).Actor).Pres;
		kDialogData.strTitle = `ONLINEEVENTMGR.m_sAcceptingGameInvitation;
		kDialogData.strDescription = `ONLINEEVENTMGR.m_sAcceptingGameInvitationBody;
		Presentation.UIProgressDialog(kDialogData);
	}
}

simulated function OnGameInviteComplete(ESystemMessageType MessageType, bool bWasSuccessful)
{
	local XComPresentationLayerBase Presentation;

	if (!bWasSuccessful)
	{
		// Only close the progress dialog if there was a failure.
		Presentation = XComPlayerController(class'UIInteraction'.static.GetLocalPlayer(0).Actor).Pres;
		Presentation.UICloseProgressDialog();
		`ONLINEEVENTMGR.QueueSystemMessage(MessageType);

		m_bDisableActions = false; // BUG 12284: [ONLINE] The user will soft crash on a 'Checking for Downloadable Content' prompt after backing out of a multiplayer lobby, then accepting an expired invite from the title screen, and pressing start at the title screen.
	}
}

function OnMusicLoaded(object LoadedObject)
{
	local MusicTrackStruct MusicTrack;
	local SoundCue MusicCue;

	MusicCue = SoundCue(LoadedObject);
	if (MusicCue != none)
	{
		MusicTrack.TheSoundCue = MusicCue;
		MusicTrack.FadeInTime = 0.0f;
		MusicTrack.FadeOutTime = 0.0f;
		MusicTrack.bAutoPlay = true;

		WorldInfo.UpdateMusicTrack(MusicTrack);
	}
}

function DelayedLogin()
{
	if( !`ONLINEEVENTMGR.bHasProfileSettings )
	{
		`log("Shell Calling Login",,'XCom_Online');
		`ONLINEEVENTMGR.BeginShellLogin(0);
	}

	if(!XComShellPresentationLayer(Movie.Pres).m_bHadNetworkConnectionAtInit && !`ONLINEEVENTMGR.bWarnedOfOfflineStatus)
	{
		`ONLINEEVENTMGR.bWarnedOfOfflineStatus = true;
		Movie.Pres.UIRaiseDialog(XComShellPresentationLayer(Movie.Pres).GetOnlineNoNetworkConnectionDialogBoxData());
	}
}
//===============================================================================
//		SCREEN FUNCTIONALITY & DISPLAY:
//===============================================================================

simulated function InitMainMenu()
{
	MainMenuContainer = Spawn(class'UIPanel', self).InitPanel('ShellMenuContainer');
	MainMenuContainer.Navigator.HorizontalNavigation = true;
	MainMenuContainer.bCascadeFocus = false;
	MainMenuContainer.SetSize(300, 600);
	MainMenuContainer.AnchorBottomCenter();
	MainMenuContainer.SetPosition(0, DefaultMainMenuOffset);

	MainMenuBG = Spawn(class'UIPanel', MainMenuContainer).InitPanel('ShellMenuBG', 'X2MenuBG');
	MainMenuBG.SetY(24);
	MainMenuBG.DisableNavigation();

	if (`ISCONTROLLERACTIVE) //bsg-crobinson (5.8.17): Be sure to spawn the bumpers if controller is active
		SpawnNavHelpIcons();
	
	UpdateMenu();
}

simulated function ClearMenu()
{
	local int i; 
	for( i = MainMenu.Length - 1; i >= 0; i-- )
	{
		MainMenu[i].Remove();
	}
	MainMenu.Length = 0;
}

simulated function UpdateMenu()
{
	InitDebugOptions();

	ClearMenu();

	CreateItem('Tactical', m_sTactical);
	CreateItem('Strategy', m_sStrategy);
	CreateItem('Load', m_sLoad);
	CreateItem('Special', m_sSpecial);
	CreateItem('Options', m_sOptions);
	CreateItem('Tutorial', m_sTutorial);

	MainMenuContainer.Navigator.SelectFirstAvailable();
}

function CreateItem(Name ButtonName, string Label)
{
	local UIX2MenuButton Button; 

	Button = Spawn(class'UIX2MenuButton', MainMenuContainer);

	Button.InitMenuButton(false, ButtonName, Label, OnMenuButtonClicked);
	Button.OnSizeRealized = OnButtonSizeRealized;
	MainMenu.AddItem(Button);
}

simulated function OnButtonSizeRealized()
{
	local int i, CurrentX;
	
	//bsg-crobinson (5.8.17): Spacing
	CurrentX = `ISCONTROLLERACTIVE ? BufferSpace * 0.5 : BufferSpace;
	
	for( i = 0; i < MainMenu.Length; i++ )
	{
		MainMenu[i].SetX(CurrentX);

		if (!`ISCONTROLLERACTIVE)
			CurrentX += MainMenu[i].Width + BufferSpace;
		else //bsg-crobinson (5.8.17): Spacing needs to be a little different for controller
			CurrentX += MainMenu[i].Width + BufferSpace * 0.5;
	}

	MainMenuBG.SetWidth(CurrentX);

	// Center to the category list along the bottom of the screen.
	MainMenuContainer.SetX(CurrentX * -0.5);

	//bsg-crobinson (5.8.17): Position the bumpers
	LeftBumperIcon.SetX((MainMenuContainer.X + MainMenu[0].X) - LeftBumperIcon.Width - BufferSpace + 4);
	RightBumperIcon.SetX(MainMenuContainer.X + CurrentX);
	//bsg-crobinson (5.8.17): end
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
	case 'Tactical': 
		`XCOMHISTORY.ResetHistory( , false);
		ConsoleCommand("open TacticalQuickLaunch");
		break;
	case 'Strategy':
		`XCOMHISTORY.ResetHistory();
		XComShellPresentationLayer(Owner).UIStrategyShell();
		break;
	case 'Load':
		`XCOMHISTORY.ResetHistory();
		XComShellPresentationLayer(Owner).UILoadScreen();
		break;
	case 'Special':
		`XCOMHISTORY.ResetHistory();
		`ONLINEEVENTMGR.bInitiateReplayAfterLoad = true;
		XComShellPresentationLayer(Owner).UILoadScreen();
		break;
	case 'Options':
		// Reset the focus in the cases where we are coming back to the screen after having swapped mouse/controller
		MainMenuContainer.Navigator.GetSelected().OnLoseFocus();
		MainMenuContainer.Navigator.SetSelected(UIX2MenuButton(button));
		
		XComPresentationLayerBase(Owner).UIPCOptions();
		break;
	case 'Tutorial':
		//Controlled Start / Demo Direct
		`XCOMHISTORY.ResetHistory();
		`ONLINEEVENTMGR.bTutorial = true;
		`ONLINEEVENTMGR.bInitiateReplayAfterLoad = true;
		`ONLINEEVENTMGR.LoadSaveFromFile(strTutorialSave);
		break;
	}
}
simulated function bool OnUnrealCommand(int cmd, int arg)
{
	switch (cmd)
	{
	case class'UIUtilities_Input'.const.FXS_BUTTON_LBUMPER:
		if (arg == class'UIUtilities_Input'.const.FXS_ACTION_PRESS)
		{
			`SOUNDMGR.PlaySoundEvent("Play_Mouseover");
			Navigator.Prev();
			return true;
		}

		break;

	case class'UIUtilities_Input'.const.FXS_BUTTON_RBUMPER:
		if (arg == class'UIUtilities_Input'.const.FXS_ACTION_PRESS)
		{
			`SOUNDMGR.PlaySoundEvent("Play_Mouseover");
			Navigator.Next();
			return true;
		}

		break;
	}
	
	
	
	return super.OnUnrealCommand(cmd, arg);
}

//----------------------------------------------------------

//bsg-crobinson (5.8.17): Ensure proper updating if mouse is changed to controller or visa versa
function RealizeBumperHelp()
{
	if(LeftBumperIcon == none || RightBumperIcon == none)
		SpawnNavHelpIcons();

	if(!`ISCONTROLLERACTIVE)
	{
		LeftBumperIcon.Hide();
		RightBumperIcon.Hide();
	}
	else
	{
		LeftBumperIcon.Show();
		RightBumperIcon.Show();
	}
}
//bsg-crobinson (5.8.17): end

simulated function UpdateNavHelp()
{
	if(NavHelp != none)
		NavHelp.ClearButtonHelp();

	RealizeBumperHelp(); //bsg-crobinson (5.8.17): Assess if bumpers should be drawn

	if(`ISCONTROLLERACTIVE)
	{
		if(NavHelp == none)
			NavHelp = Spawn(class'UINavigationHelp', self).InitNavHelp();
		else
			NavHelp.SetY(-5);

		NavHelp.bIsVerticalHelp = true;
		NavHelp.SetY(-35); // bsg-jrebar (4.3.17): Push the navhelp up above the bottom of screen ticker.

		NavHelp.AddSelectNavHelp();
	}
}

//----------------------------------------------------------

simulated function InitDebugOptions()
{
	local UIButton Button;

	if (DebugMenuContainer != none) return;

	DebugMenuContainer = Spawn(class'UIPanel', self).InitPanel('DebugMenuContainer');
	DebugMenuContainer.bCascadeFocus = false;
	DebugMenuContainer.Navigator.HorizontalNavigation = false;

	Spawn(class'UIButton', DebugMenuContainer)
		.InitButton('DynamicDebug', "DEBUG DYNAMIC UI", UIDebugButtonClicked, eUIButtonStyle_NONE)
		.SetOrigin(class'UIUtilities'.const.ANCHOR_TOP_RIGHT)
		.SetAnchor(class'UIUtilities'.const.ANCHOR_TOP_RIGHT)
		.SetPosition(-10, 10); //Offset when anchored (absolute positioning when not)

	Spawn(class'UIButton', DebugMenuContainer)
		.InitButton('CharacterPool', "CHARACTER POOL", UIDebugButtonClicked, eUIButtonStyle_NONE)
		.SetOrigin(class'UIUtilities'.const.ANCHOR_TOP_RIGHT)
		.SetAnchor(class'UIUtilities'.const.ANCHOR_TOP_RIGHT)
		.SetPosition(-10, 50); //Offset when anchored (absolute positioning when not)

	Button = Spawn(class'UIButton', DebugMenuContainer);
	Button.InitButton('IntervalChallenge', "CHALLENGE MODE", UIDebugButtonClicked, eUIButtonStyle_NONE);
	Button.SetOrigin(class'UIUtilities'.const.ANCHOR_TOP_RIGHT);
	Button.SetAnchor(class'UIUtilities'.const.ANCHOR_TOP_RIGHT);
	Button.SetPosition(-10, 90); //Offset when anchored (absolute positioning when not)
	//Button.SetGamepadIcon(class'UIUtilities_Input'.static.GetAdvanceButtonIcon());

	`ONLINEEVENTMGR.RefreshLoginStatus();
	if (`XENGINE.MCPManager == none || !(`ONLINEEVENTMGR.bHasLogin))
	{
		Button.DisableButton("Not logged into online service!");
	}

	Button = Spawn(class'UIButton', DebugMenuContainer);
	Button.InitButton('FiraxisLiveLogin', "FIRAXIS LIVE", UIDebugButtonClicked, eUIButtonStyle_NONE);
	Button.SetOrigin(class'UIUtilities'.const.ANCHOR_TOP_RIGHT);
	Button.SetAnchor(class'UIUtilities'.const.ANCHOR_TOP_RIGHT);
	Button.SetPosition(-10, 130); //Offset when anchored (absolute positioning when not)

	Button = Spawn(class'UIButton', DebugMenuContainer);
	Button.InitButton('DirectedDemo', "DIRECTED DEMO", UIDebugButtonClicked, eUIButtonStyle_NONE);
	Button.SetOrigin(class'UIUtilities'.const.ANCHOR_TOP_RIGHT);
	Button.SetAnchor(class'UIUtilities'.const.ANCHOR_TOP_RIGHT);
	Button.SetPosition(-10, 170); //Offset when anchored (absolute positioning when not)

	Button = Spawn(class'UIButton', DebugMenuContainer);
	Button.InitButton('MultiplayerMenus', "MULTIPLAYER MENUS", UIDebugButtonClicked, eUIButtonStyle_NONE);
	Button.SetOrigin(class'UIUtilities'.const.ANCHOR_TOP_RIGHT);
	Button.SetAnchor(class'UIUtilities'.const.ANCHOR_TOP_RIGHT);
	Button.SetPosition(-10, 210); //Offset when anchored (absolute positioning when not)

	Button = Spawn(class'UIButton', DebugMenuContainer);
	Button.InitButton('FinalShellMenu', m_sFinalShellDebug, UIDebugButtonClicked, eUIButtonStyle_NONE);
	Button.SetOrigin(class'UIUtilities'.const.ANCHOR_TOP_RIGHT);
	Button.SetAnchor(class'UIUtilities'.const.ANCHOR_TOP_RIGHT);
	Button.SetPosition(-10, 250); //Offset when anchored (absolute positioning when not)	
}

// Debug keyboard callback (called when 'U' key is pressed)
simulated function UIDebugKeyPressed()
{
	XComShellPresentationLayer(Owner).UIDynamicDebugScreen();
}
// Button callbacks
simulated function UIDebugButtonClicked(UIButton button)
{
	switch( button.MCName )
	{
	case 'DynamicDebug': XComShellPresentationLayer(Owner).UIDynamicDebugScreen(); break;
	case 'MultiplayerMenus': XComShellPresentationLayer(Owner).StartMPShellState(); break;
	case 'CharacterPool':
		XComPresentationLayerBase(Owner).UICharacterPool();
		break;
	case 'IntervalChallenge': `CHALLENGEMODE_MGR.OpenChallengeModeUI(); break;
	case 'FiraxisLiveLogin': XComPresentationLayerBase(Owner).UIFiraxisLiveLogin(); break;

	case 'DirectedDemo':
		`XCOMHISTORY.ResetHistory();
		`ONLINEEVENTMGR.bTutorial = true;
		`ONLINEEVENTMGR.bDemoMode = true;
		`ONLINEEVENTMGR.bInitiateReplayAfterLoad = true;
		`ONLINEEVENTMGR.LoadSaveFromFile(strDirectedDemoSave);
		break;
	case 'FinalShellMenu':
		XComShellPresentationLayer(Owner).UIFinalShellScreen();
		break;

	case 'XComDatabase':
		XComPresentationLayerBase(Owner).UIXComDatabase();
		break;
		
	}
}

//=======================================================================
simulated function OnReceiveFocus()
{
	local XComOnlineProfileSettings kProfileSettings;

	super.OnReceiveFocus();

	// Controller vs. Mouse navigation - check every time 
	kProfileSettings = `XPROFILESETTINGS;
	if ( kProfileSettings.Data.IsMouseActive() )
	{
		Movie.ActivateMouse();
		MainMenuContainer.Navigator.GetSelected().OnLoseFocus();
	}
	else
	{
		Movie.DeactivateMouse();
		MainMenuContainer.Navigator.GetSelected().OnLoseFocus();
		MainMenuContainer.Navigator.GetSelected().OnReceiveFocus();
	}

	XComShellPresentationLayer(Movie.Pres).Get3DMovie().ShowDisplay('UIShellBlueprint');

	if( DebugMenuContainer != none )
	{
		//Refresh the buttons.
		InitDebugOptions();
	}
	//Use the panel version 
	super(UIPanel).AnimateIn();

	UpdateNavHelp();
}


simulated function  CreateTicker()
{
	TickerBG = Spawn(class'UIPanel', self).InitPanel('BGBoxSimpleBG', class'UIUtilities_Controls'.const.MC_X2BackgroundSimple);
	TickerBG.AnchorBottomLeft().SetY(-35);
	TickerBG.SetSize(Movie.m_v2ScaledFullscreenDimension.X, TickerHeight);
	TickerBG.SetAlpha(80);
	TickerBG.DisableNavigation();
	TickerBG.Hide();
	TickerBG.bAnimateOnInit = false;

	TickerBG.DisableNavigation();
	TickerText = Spawn(class'UIScrollingText', self).InitScrollingText();
	TickerText.AnchorBottomLeft().SetY(-TickerHeight + 10);
	TickerText.SetWidth(Movie.m_v2ScaledFullscreenDimension.X);
	TickerText.Hide();
	TickerText.bAnimateOnInit = false;

	// Call this to update, or blank string to hide the ticker: 
	// UIShell(ShellPres.Screenstack.GetScreen(class'UIShell')).SetTicker("%ATTENTIONICON New ticker text.");	
	// Use %ATTENTIONICON to inject the cool HTML icon.
	if(!`FXSLIVE.GetMOTD("MainMenu", GetLanguage()))
	{
		SetTicker("");
	}
}

function OnReceivedMOTD(string Category, array<MOTDMessageData> Messages)
{
	local int MessageIdx;
	`log(self $ "::" $ GetFuncName() @ `ShowVar(Category) @ `ShowVar(Messages.Length),, 'XCom_Online');
	if( InStr(Category, "MainMenu",,true) > -1 )
	{
		for(MessageIdx = 0; MessageIdx < Messages.Length; ++MessageIdx)
		{
			if( InStr(Messages[MessageIdx].MessageType, GetLanguage(),,true) > -1 )
			{
				`log(self $ "::" $ GetFuncName() @ "   -> Setting Ticker: " @ `ShowVar(Messages[MessageIdx].MessageType, MessageType) @ `ShowVar(Messages[MessageIdx].Message, Message),, 'XCom_Online');
				SetTicker(Messages[MessageIdx].Message);
			}
		}
	}
}


simulated function SetTicker(string DisplayMessage)
{
	local string UpdateDisplayMessage; 
	
	UpdateDisplayMessage = Repl(DisplayMessage, "%ATTENTIONICON", class'UIUtilities_Text'.static.InjectImage(class'UIUtilities_Image'.const.HTML_AttentionIcon, 20, 20, -4), false);

	TickerText.SetHtmlText(UpdateDisplayMessage);
	
	if( DisplayMessage == "" )
	{
		TickerText.Hide();
		TickerBG.Hide();
		MainMenuContainer.SetY(DefaultMainMenuOffset);
		MainMenuBG.SetHeight(57); //Large enough to go offscreen 
	}
	else
	{
		TickerText.Show();
		TickerBG.Show();
		MainMenuContainer.SetY(DefaultMainMenuOffset - TickerHeight + 10); //10 px art adjustment
		MainMenuBG.SetHeight(27);
	}
}

//==============================================================================
//		DEFAULTS:
//==============================================================================
DefaultProperties
{
	InputState = eInputState_Evaluate; 
	bLoginInitialized = false
	m_bDisableActions = false
	bHideOnLoseFocus = true;

	strTutorialSave = "..\\Tutorial\\Tutorial"
	strDirectedDemoSave = "..\\Demo\\Demo"

	DefaultMainMenuOffset = -55;
	TickerHeight = 40;
}
