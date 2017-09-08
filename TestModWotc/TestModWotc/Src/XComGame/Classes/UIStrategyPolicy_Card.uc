//---------------------------------------------------------------------------------------
//  *********   FIRAXIS SOURCE CODE   ******************
//  FILE:    UIStrategyPolicy_Card.uc
//  AUTHOR:  Brit Steiner
//  PURPOSE: Strategy card to play on the policy screen.
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//--------------------------------------------------------------------------------------- 

class UIStrategyPolicy_Card extends UIPanel;

//NOTE: these are mirrored in Flash. 
const NORMAL_BG_HEIGHT = 238;
const NORMAL_BG_WIDTH = 140; // FLASH:  442;
const NORMAL_IMAGE_HEIGHT = 214;
const USED_BG_HEIGHT = 170;
const USED_BG_WIDTH = 350;
const USED_IMAGE_HEIGHT = 146;
const MAX_BG_WIDTH = 350;

enum EUIStrategyPolicyCardState
{
	//Defined also in Flash 
	eUIStrategyPolicyCardState_Slot,
	eUIStrategyPolicyCardState_Hand,
	eUIStrategyPolicyCardState_Highlight,
	eUIStrategyPolicyCardState_SlotHighlight,
};
enum EUIStrategyPolicyCardFaction
{
	//Defined also in Flash 
	eUIStrategyPolicyCardFaction_Blank,
	eUIStrategyPolicyCardFaction_XCOM,
	eUIStrategyPolicyCardFaction_Reaper,
	eUIStrategyPolicyCardFaction_Skirmisher,
	eUIStrategyPolicyCardFaction_Templar,
	eUIStrategyPolicyCardFaction_Locked,
};

var name AssociatedFactionName;
var int ColumnIndex;
var int ColumnSlot;
var StateObjectReference CardRef;
var bool bLocked;
var bool bVital;
var EUIStrategyPolicyCardFaction eFaction;
var EUIStrategyPolicyCardState eState;

//==============================================================================
//==============================================================================

simulated function OnInit()
{
	super.OnInit();
}

function SetCardData(string Title, string Desc, string Quote, string Image, bool bShowAttentionIcon)
{
	MC.BeginFunctionOp("SetCardData");
	MC.QueueString(class'UIUtilities_Text'.static.CapsCheckForGermanScharfesS(Title));
	MC.QueueString(Desc);
	MC.QueueString(Quote);
	MC.QueueString(Image);
	MC.QueueBoolean(bShowAttentionIcon);
	MC.EndOp();
}

function MarkCardAsSpecial(bool bSpecial)
{
	MC.BeginFunctionOp("SetCardSpecial");
	MC.QueueBoolean(bSpecial);
	MC.EndOp();

	bVital = bSpecial;
}

function SetCardFactionIcon(StackedUIIconData factionIcon )
{
	local int i;
	local StackedUIIconData EmptyIcon; 

	MC.BeginFunctionOp("SetCardFactionIcon");
	
	if( factionIcon == EmptyIcon )
	{
		MC.QueueBoolean(false);
		MC.QueueString("img:///" $ class'UIUtilities_Image'.const.FactionIcon_XCOM);
	}
	else
	{
		MC.QueueBoolean(factionIcon.bInvert);
		for( i = 0; i < factionIcon.Images.Length; i++ )
		{
			MC.QueueString("img:///" $ factionIcon.Images[i]);
		}
	}
	MC.EndOp();
} 

function SetCardSlotHint(string DisplayString)
{
	MC.FunctionString("SetCardSlotHint", DisplayString);
}

function SetCardState(EUIStrategyPolicyCardState CardState)
{
	eState = CardState;
	MC.FunctionNum("SetCardState", int(eState));

	switch (CardState)
	{
	case eUIStrategyPolicyCardState_Slot:
	case eUIStrategyPolicyCardState_SlotHighlight:
		Width = 0.8 * USED_BG_WIDTH;
		Height = 0.8 * USED_BG_HEIGHT;
		break;
	/*case eUIStrategyPolicyCardState_SlotHighlight:
		Width = USED_BG_WIDTH;
		Height = USED_BG_HEIGHT;
		break;*/
	case eUIStrategyPolicyCardState_Hand:
	case eUIStrategyPolicyCardState_Highlight:
		Width = 0.8 *  NORMAL_BG_WIDTH;
		Height = 0.8 * NORMAL_BG_HEIGHT;
		break;
	/*case eUIStrategyPolicyCardState_Highlight:
		Width = NORMAL_BG_WIDTH;
		Height = NORMAL_BG_HEIGHT;
		break;*/
	}
}

function SetCardFaction(name AssociatedEntity)
{
	switch(AssociatedEntity)
	{
	case 'Faction_Skirmishers':
		eFaction = eUIStrategyPolicyCardFaction_Skirmisher;
		break;
	case 'Faction_Reapers':
		eFaction = eUIStrategyPolicyCardFaction_Reaper;
		break;
	case 'Faction_Templars':
		eFaction = eUIStrategyPolicyCardFaction_Templar;
		break;
	case '':
		eFaction = eUIStrategyPolicyCardFaction_Blank;
		break;
	case 'Locked':
		eFaction = eUIStrategyPolicyCardFaction_Locked;
		break;
	case 'XCOM':
	default: 
		eFaction = eUIStrategyPolicyCardFaction_XCOM;
	}

	MC.FunctionNum("SetCardFaction", int(eFaction));
}

function SetCardLocked()
{
	bLocked = true;
	SetCardFaction('Locked');
}

simulated function OnMouseEvent(int cmd, array<string> args)
{
	local UIStrategyPolicy PolicyScreen;

	PolicyScreen = UIStrategyPolicy(Screen);

	switch (cmd)
	{
	case class'UIUtilities_Input'.const.FXS_L_MOUSE_UP :
	case class'UIUtilities_Input'.const.FXS_L_MOUSE_DOUBLE_UP :
		if( CanDragCard() && PolicyScreen.bEnableDragging)
		{
			PolicyScreen.SelectCard(self);
		}
		PolicyScreen.EndDrag(true);
		break;

	case class'UIUtilities_Input'.const.FXS_L_MOUSE_IN :
		if( PolicyScreen.bDragging ) 
			PolicyScreen.SelectCard(self);
		else if(CanDragCard())
			PolicyScreen.Inspect(self);
		break;

	case class'UIUtilities_Input'.const.FXS_L_MOUSE_OUT :
		PolicyScreen.ClearInspector(true);
		break;

	case class'UIUtilities_Input'.const.FXS_L_MOUSE_DOWN :
		if( CanDragCard() )
		{
			if (PolicyScreen.bEnableDragging)
			{
				PolicyScreen.ClearInspector();
				PolicyScreen.SelectCard(self);
				PolicyScreen.BeginDrag();
			}
			else
			{
				// If it is not the end of the month, display a popup informing the player that Orders cant be changed
				`SOUNDMGR.PlaySoundEvent("Play_MenuClickNegative"); //TODO: @sound : better card sounds! 
				`HQPRES.UICantChangeOrders();
			}
		}
		break;
	}
}

function bool CanDragCard()
{
	local UIStrategyPolicy PolicyScreen;

	PolicyScreen = UIStrategyPolicy(Screen);
	
	if( eFaction == eUIStrategyPolicyCardFaction_Blank ) return false;
	if( eFaction == eUIStrategyPolicyCardFaction_Locked ) return false;
	if(bVital) return false;
	if( !PolicyScreen.bEnableDragging && eState != eUIStrategyPolicyCardState_Hand) return false; 

	return true;
}

function bool CanInspectCard()
{
	if( eFaction == eUIStrategyPolicyCardFaction_Blank && !`ISCONTROLLERACTIVE ) return false;
	if( eFaction == eUIStrategyPolicyCardFaction_Locked ) return false;

	return true;
}

function Highlight(bool bShouldHighlight)
{
	if( bShouldHighlight )
		MC.FunctionVoid("onHighlight");
	else
		MC.FunctionVoid("onUnhighlight");
}

simulated function AnimateIn(optional float Delay = -1.0)
{
	if( Delay == -1.0 && ParentPanel != none )
		Delay = ParentPanel.GetChildIndex(self) * class'UIUtilities'.const.INTRO_ANIMATION_DELAY_PER_INDEX;

	AddTweenBetween("_x", 200, Alpha, 2.0, Delay);
}

simulated function DealAnimation( int Index )
{
	local float Delay; 
	Delay = Index * 0.2; 

	AddTweenBetween("_x", class'UIStrategyPolicy_DeckList'.const.MAX_WIDTH_BEFORE_SCROLL + 200, X, 0.7, Delay, "easeInQuad");
}


defaultproperties
{
	LibID = "StrategyPolicyCard";
	bIsNavigable = true;
	bProcessesMouseEvents = true;
	bAnimateOnInit = false; 
}
