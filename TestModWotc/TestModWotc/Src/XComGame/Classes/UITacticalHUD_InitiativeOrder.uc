//---------------------------------------------------------------------------------------
//  *********   FIRAXIS SOURCE CODE   ******************
//  FILE:    UITacticalHUD_InitiativeOrder.uc
//  AUTHOR:  Dan Kaplan
//  PURPOSE: Displays the initiative order of tactical groups. 
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//--------------------------------------------------------------------------------------- 

class UITacticalHUD_InitiativeOrder extends UIPanel;

enum EActiveStateStatus
{
	EASS_None,
	EASS_Disabled,
	EASS_Active,
	EASS_Pending,
};

struct GroupInitiativeDisplayInfo
{
	// The group ref
	var StateObjectReference GroupRef;

	// the current state of this group in the initiative order
	var EActiveStateStatus ActiveState;

	// the UI Panel
	var UIPanel DisplayPanel;
};

struct PlayerInitiativeDisplayInfo
{
	// the player ref
	var StateObjectReference PlayerRef;

	// the player's status
	var EActiveStateStatus ActiveState;

	// the groups part of this player's initiative
	var array<GroupInitiativeDisplayInfo> Groups;

	// the UI Panel
	var UIPanel DisplayPanel;
};


var array<PlayerInitiativeDisplayInfo> PlayerDisplayInfos;


simulated function UITacticalHUD_InitiativeOrder InitInitiativeOrder()
{
	InitPanel();
	AnchorTopLeft();
	SetY(200);

	return self;
}

simulated function OnInit()
{
	super.OnInit();

	WorldInfo.MyWatchVariableMgr.RegisterWatchVariable(`TACTICALRULES, 'CachedUnitActionInitiativeRef', self, UpdateInitiativeOrder);
}

simulated function UpdateInitiativeOrder()
{
	local XComGameStateHistory History;
	local XComGameState_BattleData BattleDataState;
	local X2TacticalGameRuleset TacticalRuleset;
	local StateObjectReference InitiativeRef;
	local XComGameState_Player PlayerState;
	local XComGameState_AIGroup GroupState;
	local PlayerInitiativeDisplayInfo CurrentPlayerInfo, EmptyPlayerInfo;
	local GroupInitiativeDisplayInfo CurrentGroupInfo, EmptryGroupInfo;
	local int ActivePlayerIndex;
	local bool bActiveGroupFound;
	local array<int> LivingUnitIDs;
	
	bActiveGroupFound = false;
	ActivePlayerIndex = -1;
	TacticalRuleset = `TACTICALRULES;
	History = `XCOMHISTORY;
	BattleDataState = XComGameState_BattleData(History.GetSingleGameStateObjectForClass(class'XComGameState_BattleData'));

	ClearInitiativeOrder();

	PlayerDisplayInfos.Remove(0, PlayerDisplayInfos.Length);

	foreach BattleDataState.PlayerTurnOrder(InitiativeRef)
	{
		PlayerState = XComGameState_Player(History.GetGameStateForObjectID(InitiativeRef.ObjectID));
		if( PlayerState != None )
		{
			// add the previous player info to the array
			if( CurrentPlayerInfo.PlayerRef.ObjectID > 0 && CurrentPlayerInfo.Groups.Length > 0 )
			{
				PlayerDisplayInfos.AddItem(CurrentPlayerInfo);
			}

			// create the new info
			CurrentPlayerInfo = EmptyPlayerInfo;
			CurrentPlayerInfo.PlayerRef = InitiativeRef;
			if( InitiativeRef.ObjectID == TacticalRuleset.GetCachedUnitActionPlayerRef().ObjectID )
			{
				CurrentPlayerInfo.ActiveState = EASS_Active;
				ActivePlayerIndex = PlayerDisplayInfos.Length;

				if( InitiativeRef.ObjectID == TacticalRuleset.CachedUnitActionInitiativeRef.ObjectID )
				{
					bActiveGroupFound = true;
				}
			}
			else if( ActivePlayerIndex >= 0 )
			{
				CurrentPlayerInfo.ActiveState = EASS_Pending;
			}
			else
			{
				CurrentPlayerInfo.ActiveState = EASS_Disabled;
			}
		}
		else
		{
			CurrentGroupInfo = EmptryGroupInfo;
			CurrentGroupInfo.GroupRef = InitiativeRef;
			if( InitiativeRef.ObjectID == TacticalRuleset.CachedUnitActionInitiativeRef.ObjectID )
			{
				CurrentGroupInfo.ActiveState = EASS_Active;
				bActiveGroupFound = true;
			}
			else if( bActiveGroupFound )
			{
				CurrentGroupInfo.ActiveState = EASS_Pending;
			}
			else
			{
				CurrentGroupInfo.ActiveState = EASS_Disabled;
			}

			GroupState = XComGameState_AIGroup(History.GetGameStateForObjectID(InitiativeRef.ObjectID));
			if( !GroupState.bSummoningSicknessCleared )
			{
				CurrentGroupInfo.ActiveState = EASS_Disabled;
			}

			LivingUnitIDs.Remove(0, LivingUnitIDs.Length);
			if( GroupState != None && GroupState.bProcessedScamper && GroupState.GetLivingMembers(LivingUnitIDs) ) // only the groups that have scampered are known to the player
			{
				CurrentPlayerInfo.Groups.AddItem(CurrentGroupInfo);
			}
		}
	}

	// add the final player info to the array
	if( CurrentPlayerInfo.PlayerRef.ObjectID > 0 && CurrentPlayerInfo.Groups.Length > 0 )
	{
		PlayerDisplayInfos.AddItem(CurrentPlayerInfo);
	}

	DrawInitiativeOrder();
}

function ClearInitiativeOrder()
{
	local int PlayerIndex;
	local int GroupIndex;

	for( PlayerIndex = 0; PlayerIndex < PlayerDisplayInfos.Length; ++PlayerIndex )
	{
		for( GroupIndex = 0; GroupIndex < PlayerDisplayInfos[PlayerIndex].Groups.Length; ++GroupIndex )
		{
			if( PlayerDisplayInfos[PlayerIndex].Groups[GroupIndex].DisplayPanel != None )
			{
				PlayerDisplayInfos[PlayerIndex].Groups[GroupIndex].DisplayPanel.Remove();
			}
		}

		// remove the panel for the player
		if( PlayerDisplayInfos[PlayerIndex].DisplayPanel != None )
		{
			PlayerDisplayInfos[PlayerIndex].DisplayPanel.Remove();
		}
	}
}


function DrawInitiativeOrder()
{
	local int PlayerIndex;
	local int GroupIndex;
	local UIBGBox PlayerBG;
	local EUIState PlayerColorState;
	local UIBGBox GroupBG;
	local EUIState GroupColorState;
	local int PlayerBGX, PlayerBGY, PlayerBGWidth, PlayerBGHeight;
	local int GroupBGX, GroupBGY, GroupBGWidth, GroupBGHeight;
	local int CumulativeX;
	local bool PlayerHighlight, GroupHighlight;
	local XComGameState_Player PlayerState;
	//local XComGameState_AIGroup GroupState;
	local XComGameStateHistory History;
	local string TeamString;

	History = `XCOMHISTORY;

	CumulativeX = 0;

	PlayerBGY = 300;
	PlayerBGHeight = 100;

	GroupBGY = 330;
	GroupBGWidth = 100;
	GroupBGHeight = 50;

	for( PlayerIndex = 0; PlayerIndex < PlayerDisplayInfos.Length; ++PlayerIndex )
	{
		// create the panel for the player
		PlayerDisplayInfos[PlayerIndex].DisplayPanel = Spawn(class'UIPanel', self);
		PlayerDisplayInfos[PlayerIndex].DisplayPanel.InitPanel('');
		PlayerDisplayInfos[PlayerIndex].DisplayPanel.SetAnchor(class'UIUtilities'.const.ANCHOR_TOP_LEFT);
		PlayerDisplayInfos[PlayerIndex].DisplayPanel.SetAlpha(0.8);

		switch( PlayerDisplayInfos[PlayerIndex].ActiveState )
		{
		case EASS_Active:
			PlayerColorState = eUIState_Highlight;
			PlayerHighlight = true;
			break;
		case EASS_Disabled:
			PlayerColorState = eUIState_Disabled;
			PlayerHighlight = false;
			break;
		case EASS_Pending:
			PlayerColorState = eUIState_Good;
			PlayerHighlight = false;
			break;
		}

		PlayerBG = Spawn(class'UIBGBox', PlayerDisplayInfos[PlayerIndex].DisplayPanel);
		PlayerBGX = 50 + CumulativeX;
		PlayerBGWidth = 10 + (GroupBGWidth + 10) * PlayerDisplayInfos[PlayerIndex].Groups.Length;
		CumulativeX += PlayerBGWidth;

		PlayerBG.InitBG('', PlayerBGX, PlayerBGY, PlayerBGWidth, PlayerBGHeight, PlayerColorState);
		PlayerBG.SetAlpha(0.8);
		PlayerBG.SetHighlighed(PlayerHighlight);


		PlayerState = XComGameState_Player(History.GetGameStateForObjectID(PlayerDisplayInfos[PlayerIndex].PlayerRef.ObjectID));

		switch( PlayerState.TeamFlag )
		{
		case eTeam_XCom:
			TeamString = "XCOM"; // TODO: localize me
			break;
		case eTeam_Alien:
			TeamString = "ALIENS"; // TODO: localize me
			break;
		case eTeam_TheLost:
			TeamString = "THE LOST"; // TODO: localize me
			break;
		case eTeam_Resistance:
			TeamString = "RESISTANCE"; // TODO: localize me
			break;
		}

		AddTitleTo(TeamString, eUIState_Good, 14, PlayerBG, 5, 5, PlayerBG.Width - 20, 20);

		for( GroupIndex = 0; GroupIndex < PlayerDisplayInfos[PlayerIndex].Groups.Length; ++GroupIndex )
		{
			// create the panel for the group
			PlayerDisplayInfos[PlayerIndex].Groups[GroupIndex].DisplayPanel = Spawn(class'UIPanel', self);
			PlayerDisplayInfos[PlayerIndex].Groups[GroupIndex].DisplayPanel.InitPanel('');
			PlayerDisplayInfos[PlayerIndex].Groups[GroupIndex].DisplayPanel.SetAnchor(class'UIUtilities'.const.ANCHOR_TOP_LEFT);
			PlayerDisplayInfos[PlayerIndex].Groups[GroupIndex].DisplayPanel.SetAlpha(0.8);

			switch( PlayerDisplayInfos[PlayerIndex].Groups[GroupIndex].ActiveState )
			{
			case EASS_Active:
				GroupColorState = eUIState_Highlight;
				GroupHighlight = true;
				break;
			case EASS_Disabled:
				GroupColorState = eUIState_Disabled;
				GroupHighlight = false;
				break;
			case EASS_Pending:
				GroupColorState = eUIState_Good;
				GroupHighlight = false;
				break;
			}

			GroupBG = Spawn(class'UIBGBox', PlayerDisplayInfos[PlayerIndex].Groups[GroupIndex].DisplayPanel);
			GroupBGX = PlayerBGX + 10 + (GroupBGWidth + 10) * GroupIndex;
			GroupBG.InitBG('', GroupBGX, GroupBGY, GroupBGWidth, GroupBGHeight, GroupColorState);
			GroupBG.SetAlpha(0.8);
			GroupBG.SetHighlighed(GroupHighlight);

			//GroupState = XComGameState_AIGroup(History.GetGameStateForObjectID(PlayerDisplayInfos[PlayerIndex].Groups[GroupIndex].GroupRef.ObjectID));

			AddTitleCenteredWithin("Group " $ GroupIndex, eUIState_Good, 25, GroupBG, 5);
		}
	}
}

simulated function UIText AddTitleCenteredWithin(String strText, EUIState ColorState, int FontSize, UIPanel Parent, int Padding)
{
	return AddTitleTo(strText, ColorState, FontSize, Parent, Padding, Padding, Parent.Width - 2 * Padding, Parent.Height - 2 * Padding);
}

simulated function UIText AddTitleTo(String strText, EUIState ColorState, int FontSize, UIPanel Parent, int InX, int InY, int InWidth, int InHeight)
{
	local UIText TextWidget;

	TextWidget = Spawn(class'UIText', Parent);
	TextWidget.InitText('', class'UIUtilities_Text'.static.GetColoredText(strText, ColorState, FontSize), true);
	TextWidget.SetPosition(InX, InY);
	TextWidget.SetSize(InWidth, InHeight);
	TextWidget.SetHtmlText(class'UIUtilities_Text'.static.AlignCenter(TextWidget.Text));

	return TextWidget;
}


defaultproperties
{
	MCName = "initiativeOrder";
	bAnimateOnInit = false;
}

