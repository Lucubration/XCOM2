//-------------------------------------
//--------------------------------------------------
//  *********   FIRAXIS SOURCE CODE   ******************
//  FILE:    UITacticalQuickLaunch_SquadLoadout
//  AUTHOR:  Sam Batista --  02/26/14
//  PURPOSE: Provides functionality to outfit and loadout units.
//  NOTE:    Contains most GAME logic 
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//--------------------------------------------------------------------------------------- 

class UITacticalQuickLaunch_SquadLoadout extends UIScreen;

// GAME Vars
var XComGameState GameState;
				 
// UI Vars		 
var private int      m_iXPositionHelper;
var private int      m_iSlotsStartY;
var private UIPanel	 m_kContainer;
var private UIList	 m_kSoldierList;
var private UIButton m_kAddUnitButton;
var private UIButton m_kRemoveUnitButton;
var private UIButton m_kNewSquadButton;
var private UIButton m_kLaunchButton;

//----------------------------------------------------------------------------
// MEMBERS

simulated function InitScreen(XComPlayerController InitController, UIMovie InitMovie, optional name InitName)
{
	local UIPanel kBG, kLine;
	local UIText kTitle;
	local int headerButtonY;       //bsg-nlong (1.10.17): Start positions for the header buttons when using a controller
	local int headerButtonStartX;

	super.InitScreen(InitController, InitMovie, InitName);

	// Create Container
	m_kContainer = Spawn(class'UIPanel', self);
	m_kContainer.InitPanel();
	m_kContainer.Navigator.LoopSelection = false; 

	// Create BG
	kBG = Spawn(class'UIBGBox', m_kContainer).InitBG('BG', 0, 0, 1840, 1020);

	// Center Container using BG
	m_kContainer.CenterWithin(kBG);

	// MOUSE GUARD - PREVENT USERS FROM CHANGING DROPDOWN OPTIONS
	// Spawn(class'UIBGBox', self).InitBG('',40,120,kBG.width,kBG.height-90).ProcessMouseEvents(none).SetAlpha(75);

	// Create Title text
	kTitle = Spawn(class'UIText', m_kContainer);
	kTitle.InitText('', "TACTICAL LOADOUT", true);
	kTitle.SetPosition(10, 5).SetWidth(kBG.width);

	// bsg-nlong (1.10.17): When using a controller the text was not appearing on the buttons when they where children of the itemContainer
	// so if we're using a controller we parent them to this screen and give them different coordinates
	headerButtonY = `ISCONTROLLERACTIVE ? 40 : 10;
	headerButtonStartX = `ISCONTROLLERACTIVE ? 345 : 320;

	// Create Add / Remove Slot + Launch Tactical Map buttons
	m_kAddUnitButton = Spawn(class'UIButton', `ISCONTROLLERACTIVE ? self : m_kContainer );
	m_kAddUnitButton.InitButton('', "ADD UNIT", AddSlot, (`ISCONTROLLERACTIVE) ? eUIButtonStyle_HOTLINK_WHEN_SANS_MOUSE : eUIButtonStyle_NONE);
	m_kAddUnitButton.SetPosition( headerButtonStartX, headerButtonY);
	m_kAddUnitButton.SetGamepadIcon(class'UIUtilities_Input'.const.ICON_X_SQUARE);

	m_kRemoveUnitButton = Spawn(class'UIButton', `ISCONTROLLERACTIVE ? self : m_kContainer );
	m_kRemoveUnitButton.InitButton('', "REMOVE UNIT", RemoveSlot, (`ISCONTROLLERACTIVE) ? eUIButtonStyle_HOTLINK_WHEN_SANS_MOUSE : eUIButtonStyle_NONE);
	m_kRemoveUnitButton.SetPosition(headerButtonStartX + 160, headerButtonY); //160
	m_kRemoveUnitButton.SetGamepadIcon(class'UIUtilities_Input'.const.ICON_Y_TRIANGLE);

	m_kNewSquadButton = Spawn(class'UIButton', `ISCONTROLLERACTIVE ? self : m_kContainer );
	m_kNewSquadButton.InitButton('', "NEW SQUAD", NewSquad, (`ISCONTROLLERACTIVE) ? eUIButtonStyle_HOTLINK_WHEN_SANS_MOUSE : eUIButtonStyle_NONE);
	m_kNewSquadButton.SetPosition(headerButtonStartX + 360, headerButtonY); //360
	m_kNewSquadButton.SetGamepadIcon(class'UIUtilities_Input'.const.ICON_RB_R1);

	m_kLaunchButton = Spawn(class'UIButton', `ISCONTROLLERACTIVE ? self : m_kContainer );
	m_kLaunchButton.InitButton('', "SAVE & EXIT", LaunchTacticalMap, (`ISCONTROLLERACTIVE) ? eUIButtonStyle_HOTLINK_WHEN_SANS_MOUSE : eUIButtonStyle_NONE);
	m_kLaunchButton.SetPosition(kBG.width - 160, headerButtonY);
	m_kLaunchButton.SetGamepadIcon(class'UIUtilities_Input'.const.ICON_START);
	// bsg-nlong (1.10.17): end
	
	// Add divider line
	kLine = Spawn(class'UIPanel', m_kContainer);
	kLine.bIsNavigable = false;
	kLine.InitPanel('', class'UIUtilities_Controls'.const.MC_GenericPixel);
	kLine.SetSize(kBG.width - 10, 2).SetPosition(5, 50).SetAlpha(50);

	// Add column headers (order matters)
	CreateColumnHeader("CHARACTER TYPE");
	CreateColumnHeader("SOLDIER CLASS");
	CreateColumnHeader("WEAPONS");
	//CreateColumnHeader("HEAVY WEAPON"); TODO (NOT YET IMPLEMENTED BY GAMEPLAY)
	CreateColumnHeader("ARMOR / MISSION ITEM");
	CreateColumnHeader("UTILITY ITEMS");

	// Add divider line
	kLine = Spawn(class'UIPanel', m_kContainer);
	kLine.bIsNavigable = false; 
	kLine.InitPanel('', class'UIUtilities_Controls'.const.MC_GenericPixel);
	kLine.SetPosition(5, 90).SetSize(kBG.width - 10, 2).SetAlpha(50);
	
	// Get initial GameState
	GameState = Movie.Pres.TacticalStartState;

	m_kSoldierList = Spawn(class'UIList', m_kContainer);
	m_kSoldierList.bSortStandardDepths = true;
	m_kSoldierList.bLoopSelection = true;
	m_kSoldierList.InitList('SoldierList',0, m_iSlotsStartY, kBG.Width - 20 /* space for scrollbar */, class'UITacticalQuickLaunch_UnitSlot'.default.Height * 4);
	m_kSoldierList.Navigator.LoopSelection = true;

	// Load units from GameState
	LoadUnits();
	Navigator.SetSelected(m_kSoldierList);
	m_kContainer.Navigator.SetSelected(m_kSoldierList); // bsg-nlong (1.10.17): We need to make this screen and the item container navigators match up to avoid recursive loops
	m_kSoldierList.SetSelectedIndex(0);
}

simulated private function CreateColumnHeader(string label)
{
	local UIText kText;
	kText = Spawn(class'UIText', m_kContainer).InitText();
	kText.SetText(label).SetPosition(m_iXPositionHelper + 35, 60);
	kText.DisableNavigation();
	m_iXPositionHelper += class'UITacticalQuickLaunch_UnitSlot'.default.m_iDropdownWidth;
}

simulated private function AddSlot(UIButton kButton)
{
	local UITacticalQuickLaunch_UnitSlot UnitSlot;
	//if (m_kSoldierList.ItemCount < class'X2StrategyGameRulesetDataStructures'.static.GetMaxSoldiersAllowedOnMission())
	//{
		UnitSlot = UITacticalQuickLaunch_UnitSlot(m_kSoldierList.CreateItem(class'UITacticalQuickLaunch_UnitSlot')).InitSlot();
		m_kSoldierList.MoveItemToTop(UnitSlot);
		RealizeSlots();
		// bsg-nlong (1.10.17): Rebuild the navigator when adding another list item
		if(`ISCONTROLLERACTIVE)
		{
			RefreshListNavigator();
		}
		else
		{
			m_kSoldierList.Navigator.SelectFirstAvailableIfNoCurrentSelection();
		}
		// bsg-nlong (1.10.17): end
	//}
}

simulated private function RemoveSlot(UIButton kButton)
{
	if(m_kSoldierList.ItemCount > 0)
	{
		m_kSoldierList.GetItem(m_kSoldierList.ItemCount - 1).Remove();
		RealizeSlots();
		// bsg-nlong (1.10.17): Rebuild the navigator when removing list item
		if( `ISCONTROLLERACTIVE)
		{
			RefreshListNavigator();
		}
		// bsg-nlong (1.10.17): end
	}
}

simulated private function NewSquad(UIButton kButton)
{
	m_kSoldierList.ClearItems();

	//Obliterate any previously added Units / Items
	PurgeGameState();

	LoadUnits();
}

// Called when slots are modified
simulated private function RealizeSlots()
{
	// update button availability
	m_kLaunchButton.SetDisabled(m_kSoldierList.ItemCount == 0);
	m_kRemoveUnitButton.SetDisabled(m_kSoldierList.ItemCount == 0);
	//m_kAddUnitButton.SetDisabled(m_kSoldierList.ItemCount == class'X2StrategyGameRulesetDataStructures'.static.GetMaxSoldiersAllowedOnMission());
}

// bsg-nlong (1.10.17): a function that clears the Navigator of this screen and the item container and rebuilds them to match
simulated private function RefreshListNavigator()
{
	local int index;

	m_kSoldierList.Navigator.Clear();
	m_kSoldierList.ItemContainer.Navigator.Clear();

	for(index = 0; index < m_kSoldierList.GetItemCount(); ++index)
	{
		m_kSoldierList.Navigator.AddControl(m_kSoldierList.GetItem(index));
		m_kSoldierList.ItemContainer.Navigator.AddControl(m_kSoldierList.GetItem(index));

	}
}
// bsg-nlong (1.10.17): end

simulated private function LaunchTacticalMap(UIButton kButton)
{
	WriteLoadoutToProfile();

	if(!Movie.Stack.IsInStack(class'UITacticalQuickLaunch'))
		ConsoleCommand( GetBattleData().m_strMapCommand );
	else
		Movie.Stack.Pop(self);
}

simulated function WriteLoadoutToProfile()
{
	local int i;
	local UITacticalQuickLaunch_UnitSlot UnitSlot;
	local XComGameState_Player TeamXComPlayer;

	//Find the player associated with the player's team
	foreach GameState.IterateByClassType(class'XComGameState_Player', TeamXComPlayer, eReturnType_Reference)
	{
		if( TeamXComPlayer != None && TeamXComPlayer.TeamFlag == eTeam_XCom )
		{
			break;
		}
	}

	//Obliterate any previously added Units / Items
	PurgeGameState();

	for(i = m_kSoldierList.ItemCount - 1; i >= 0; --i)
	{
		UnitSlot = UITacticalQuickLaunch_UnitSlot(m_kSoldierList.GetItem(i));
		UnitSlot.AddUnitToGameState(GameState, TeamXComPlayer);
	}

	//Write GameState to profile
	`XPROFILESETTINGS.WriteTacticalGameStartState(GameState);

	`ONLINEEVENTMGR.SaveProfileSettings();
}

simulated function LoadUnits()
{
	local bool createdUnits;
	local XComGameState_Unit Unit;
	local UITacticalQuickLaunch_UnitSlot UnitSlot;

	foreach GameState.IterateByClassType(class'XComGameState_Unit', Unit)
	{
		UnitSlot = UITacticalQuickLaunch_UnitSlot(m_kSoldierList.CreateItem(class'UITacticalQuickLaunch_UnitSlot'));
		UnitSlot.LoadTemplatesFromCharacter(Unit, GameState); // load template data first, then init
		UnitSlot.InitSlot();
		
		if( `ISCONTROLLERACTIVE )
			m_kSoldierList.MoveItemToTop(UnitSlot); // bsg-nlong (1.10.17): We always want to do this to make sure dropdowns of units higher on the list render
												    // in front of unit slots below it
		createdUnits = true;
	}

	// If we don't have stored units, create defaults and reload
	if(!createdUnits)
	{
		class'XComOnlineProfileSettings'.static.AddDefaultSoldiersToStartState(GameState);

		// Make sure that actually loaded some units - if not we'll end up in an infinite loop
		foreach GameState.IterateByClassType(class'XComGameState_Unit', Unit)
		{
			createdUnits = true;
			break;
		}
		`assert(createdUnits);

		LoadUnits();
	}
	else
	{
		RealizeSlots();
		// bsg-nlong (1.10.17): now that the initial units are created. Build the Navigator
		if( `ISCONTROLLERACTIVE )
		{
			RefreshListNavigator();
		}
		// bsg-nlong (1.10.17): end
	}
}

function XComGameState_BattleData GetBattleData()
{
	local XComGameState_BattleData BattleData;

	BattleData = XComGameState_BattleData(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_BattleData'));

	return BattleData;
}

// Purge the GameState of any XComGameState_Unit or XComGameState_Item objects
function PurgeGameState()
{
	local int i;
	local array<int> arrObjectIDs;
	local XComGameState_Unit Unit;
	local XComGameState_Item Item;
	local XComGameStateHistory LocalHistory;
	local XComGameState StartState;

	LocalHistory = `XCOMHISTORY;
	StartState = LocalHistory.GetStartState();
	`assert( StartState != none );

	// Enumerate objects
	foreach StartState.IterateByClassType(class'XComGameState_Unit', Unit)
	{
		arrObjectIDs.AddItem(Unit.ObjectID);
	}
	foreach StartState.IterateByClassType(class'XComGameState_Item', Item)
	{
		arrObjectIDs.AddItem(Item.ObjectID);
	}
	
	// Purge objects
	for(i = 0 ; i < arrObjectIDs.Length; ++i)
	{
		LocalHistory.PurgeObjectIDFromStartState(arrObjectIDs[i], false);
	}

	LocalHistory.UpdateStateObjectCache( );
}

//-----------------------------------------------------------------------------

simulated function bool OnUnrealCommand(int cmd, int arg)
{
	local bool bHandled;

	if ( !CheckInputIsReleaseOrDirectionRepeat(cmd, arg) )
		return false;

	bHandled = true;

	// bsg-nlong (1.10.17): if we are on an open dropdown then we should pass input to it isntead of the rest of the list
	if( m_kSoldierList.Navigator.GetSelected() != none &&
		m_kSoldierList.Navigator.GetSelected().Navigator.GetSelected() != none &&
		m_kSoldierList.Navigator.GetSelected().Navigator.GetSelected().IsA('UIDropdown') &&
		UIDropdown(m_kSoldierList.Navigator.GetSelected().Navigator.GetSelected()).IsOpen )
	{
		return m_kSoldierList.Navigator.GetSelected().OnUnrealCommand(cmd, arg);
	}
	// bsg-nlong (1.10.17): end

/*	if (m_kSoldierList.OnUnrealCommand(cmd, arg))
	{
		return true;
	}*/

	switch( cmd )
	{
	case class'UIUtilities_Input'.const.FXS_BUTTON_X :
		AddSlot(none);
		break;
	case class'UIUtilities_Input'.const.FXS_BUTTON_Y :
		RemoveSlot(none);
		break;
	case class'UIUtilities_Input'.const.FXS_BUTTON_START :
		LaunchTacticalMap(none);
		break;
	default:
		bHandled = false;
		break;
	}

	if( bHandled ) return true; 
	bHandled = super.OnUnrealCommand(cmd, arg);
	if( bHandled ) return true; 

	switch( cmd )
	{
	case class'UIUtilities_Input'.const.FXS_BUTTON_B :
	case class'UIUtilities_Input'.const.FXS_KEY_ESCAPE :
	case class'UIUtilities_Input'.const.FXS_R_MOUSE_DOWN :
		Movie.Stack.Pop(self);
		break;
	}
	return false; 
}

//-----------------------------------------------------------------------------

simulated function OnRemoved()
{
	super.OnRemoved();
}

//==============================================================================

defaultproperties
{
	InputState    = eInputState_Consume;
	m_iSlotsStartY  = 120;
}
