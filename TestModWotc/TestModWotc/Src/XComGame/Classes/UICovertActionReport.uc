
//---------------------------------------------------------------------------------------
//  *********   FIRAXIS SOURCE CODE   ******************
//  FILE:    UICovertActionReport.uc
//  AUTHOR:  Brit Steiner -- 12/16/2016
//  PURPOSE: This file controls the covert actions complete report. 
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//--------------------------------------------------------------------------------------- 

class UICovertActionReport extends UIScreen;

var public localized String CovertOpsReport_Ambushed;
var public localized String CovertActions_ScreenHeader;
var public localized String CovertActions_SlotsHeader;

var StateObjectReference ActionRef;

var UILargeButton ContinueButton;
var UICovertActionSlotContainer SlotContainer;

var public delegate<OnStaffUpdated> onStaffUpdatedDelegate;
delegate onStaffUpdated();

//----------------------------------------------------------------------------
// MEMBERS

simulated function InitScreen(XComPlayerController InitController, UIMovie InitMovie, optional name InitName)
{
	super.InitScreen(InitController, InitMovie, InitName);

	if( `SCREENSTACK.IsInStack(class'UIStrategyMap') )
	{
		`HQPRES.CAMSaveCurrentLocation();
	}

	//TODO: bsteiner: remove this when the strategy map handles it's own visibility
	if( Package != class'UIScreen'.default.Package )
		`HQPRES.StrategyMap2D.Hide();
}

simulated function OnInit()
{
	super.OnInit();

	BuildScreen();
	UpdateData();
	MC.FunctionVoid("AnimateIn");
}

function BuildScreen()
{
	`XSTRATEGYSOUNDMGR.PlayPersistentSoundEvent("UI_CovertOps_Report");
	CreateSlotContainer();
}

function UpdateData()
{
	RefreshMainPanel();
	RefreshFactionPanel();
	RealizeSlots();
	RefreshConfirmPanel();
}

function RefreshConfirmPanel()
{
	if( ContinueButton == none )
	{
		ContinueButton = Spawn(class'UILargeButton', self);
		ContinueButton.bAnimateOnInit = false;

		if( `ISCONTROLLERACTIVE )
		{
			ContinueButton.InitLargeButton(, class'UIUtilities_Text'.static.InjectImage(
				//bsg-hlee(05.05.17): Changing nav help from X to A to match current functionality.
				class'UIUtilities_Input'.static.GetGamepadIconPrefix() $ class'UIUtilities_Input'.const.ICON_A_X, 26, 26, -10) @ class'UIUtilities_Text'.default.m_strGenericContinue, , OnContinueClicked);

			//bsg-crobinson (5.9.17): Disable button navigation
			ContinueButton.DisableNavigation();
			Navigator.Clear();
			//bsg-crobinson (5.9.17): end
		}
		else
		{
			ContinueButton.InitLargeButton(, class'UIUtilities_Text'.default.m_strGenericContinue, "", OnContinueClicked);
		}

		ContinueButton.AnchorBottomRight();
		ContinueButton.ShowBG(true);
	}
}

simulated function RefreshMainPanel()
{
	if( DoesActionHaveRewards() )
		AS_SetInfoData(GetActionImage(), CovertActions_ScreenHeader, CovertActions_SlotsHeader, Caps(GetActionName()), GetActionDescription(), class'UICovertActions'.default.CovertActions_RewardHeader, GetRewardString(), GetRewardDetailsString());
	else
		AS_SetInfoData(GetActionImage(), CovertActions_ScreenHeader, CovertActions_SlotsHeader, Caps(GetActionName()), GetActionDescription(), "", "", "");
}

simulated function CreateSlotContainer()
{
	if( SlotContainer == none )
	{
		SlotContainer = Spawn(class'UICovertActionSlotContainer', self);
		SlotContainer.InitSlotContainer();
	}
}

simulated function RealizeSlots()
{
	onStaffUpdatedDelegate = UpdateData;

	if( SlotContainer != none )
	{
		SlotContainer.Refresh(ActionRef, onStaffUpdatedDelegate);
	}
}

// -------------------------------------------------------------------------

function RefreshFactionPanel()
{
	local name FactionName;
	local string Title, Subtitle;

	FactionName = GetFactionTemplateName();
	Title = Caps(GetFactionTitle());
	Subtitle = "<font color='#" $ class'UIUtilities_Colors'.static.GetColorForFaction(FactionName) $"'>" $ Caps(GetFactionName()) $"</font>";

	AS_SeFactionIcon(GetAction().GetFaction().GetFactionIcon());
	AS_SetFactionData( Title, Subtitle);
}

// ----------------------------------------------------------------------

function AS_SetFactionData(string TItle, string Subtitle)
{
	MC.BeginFunctionOp("SetFactionData");
	MC.QueueString(Title);
	MC.QueueString(Subtitle);
	MC.EndOp();
}

function AS_SetInfoData(string Image, string Title, string Header, string MissionInfo, string Description, string RewardLabel, string RewardTitle, string RewardDesc)
{
	MC.BeginFunctionOp("SetInfoData");
	MC.QueueString(Image);
	MC.QueueString(Title);
	MC.QueueString(Header);
	MC.QueueString(MissionInfo);
	MC.QueueString(Description);
	MC.QueueString(RewardLabel);
	MC.QueueString(RewardTitle);
	MC.QueueString(RewardDesc);
	MC.EndOp();
}

function AS_SetSlotData(int Index, int NumState, string Image, string RankImage, string ClassImage, string Label, string Promote, string Value1, string Value2, string Value3, string Value4)
{
	MC.BeginFunctionOp("SetSlotData");
	MC.QueueNumber(Index);
	MC.QueueNumber(NumState);
	MC.QueueString(Image);
	MC.QueueString(RankImage);
	MC.QueueString(ClassImage);
	MC.QueueString(Label);
	MC.QueueString(Promote); //Intended to be HTML colored going in
	MC.QueueString(Value1);
	MC.QueueString(Value2);
	MC.QueueString(Value3);
	MC.QueueString(Value4);
	MC.EndOp();
}

function AS_SeFactionIcon(StackedUIIconData IconInfo)
{
	local int i;

	MC.BeginFunctionOp("SetFactionIcon");
	MC.QueueBoolean(IconInfo.bInvert);
	for( i = 0; i < IconInfo.Images.Length; i++ )
	{
		MC.QueueString("img:///" $ IconInfo.Images[i]);
	}

	MC.EndOp();
}

//-------------- GAME DATA HOOKUP --------------------------------------------------------
simulated function XComGameState_CovertAction GetAction()
{
	return XComGameState_CovertAction(`XCOMHISTORY.GetGameStateForObjectID(ActionRef.ObjectID));
}
simulated function String GetActionObjective()
{
	return GetAction().GetObjective();
}
simulated function String GetActionImage()
{
	return GetAction().GetImage();
}
simulated function String GetActionName()
{
	return GetAction().GetDisplayName();
}

simulated function String GetActionDescription()
{
	local string strSummary;

	strSummary = GetAction().GetSummary();

	if( GetAction().bAmbushed )
	{
		strSummary $= "\n\n" $ class'UIUtilities_Text'.static.GetColoredText(CovertOpsReport_Ambushed, eUIState_Bad);
	}

	return strSummary;
}
simulated function Name GetFactionTemplateName()
{
	return GetAction().GetFaction().GetMyTemplateName();
}
simulated function string GetFactionName()
{
	return GetAction().GetFaction().FactionName;
}
simulated function String GetFactionTitle()
{
	return GetAction().GetFaction().GetFactionTitle();
}
simulated function String GetRewardString()
{
	return GetAction().GetRewardValuesString();
}
simulated function String GetRewardDetailsString()
{
	return GetAction().GetRewardDetailsString();
}
simulated function String GetRewardIcon()
{
	return GetAction().GetRewardIconString();
}
simulated function bool DoesActionHaveRewards()
{
	return (GetAction().RewardRefs.Length > 0);
}
// Called when screen is removed from Stack
simulated function OnRemoved()
{
	super.OnRemoved();

	`HQPRES.m_kAvengerHUD.NavHelp.ClearButtonHelp();

	class'UIUtilities_Sound'.static.PlayCloseSound();
}

//-----------------------------------------------------------------------

simulated function bool OnUnrealCommand(int cmd, int arg)
{
	local bool bHandled;

	if( !CheckInputIsReleaseOrDirectionRepeat(cmd, arg) )
		return false;

	bHandled = true;

	switch( cmd )
	{
	case class'UIUtilities_Input'.const.FXS_BUTTON_A :
	case class'UIUtilities_Input'.const.FXS_KEY_ENTER :
	case class'UIUtilities_Input'.const.FXS_KEY_SPACEBAR :
	case class'UIUtilities_Input'.const.FXS_KEY_ESCAPE:

		OnContinueClicked(none);
		break;

	default:
		bHandled = false;
		break;
	}

	return bHandled || super.OnUnrealCommand(cmd, arg);
}


//==============================================================================
//		MOUSE HANDLING:
//==============================================================================
simulated function OnMouseEvent(int cmd, array<string> args)
{
	local string callbackObj, tmp, interiorButton;
	local int buttonIndex;

	if( cmd == class'UIUtilities_Input'.const.FXS_L_MOUSE_UP )
	{
		callbackObj = args[args.Length - 2];
		interiorButton = args[args.Length - 1];
		if( InStr(callbackObj, "slot") == -1 )
			return;

		tmp = GetRightMost(callbackObj);
		if( tmp != "" )
			buttonIndex = int(tmp);
		else
			buttonIndex = -1;

		// This can never ever happen.
		`assert(buttonIndex >= 0);

		SlotContainer.ActionSlots[buttonIndex].HandleClick(interiorButton);
	}
	super.OnMouseEvent(cmd, args);
}

simulated public function OnContinueClicked(UIButton button)
{
	CloseScreen();
	`HQPRES.UIActionCompleteRewards();
}

simulated function OnReceiveFocus()
{
	super.OnReceiveFocus();

	XComHQPresentationLayer(Movie.Pres).m_kAvengerHUD.NavHelp.ClearButtonHelp();
}

//==============================================================================

defaultproperties
{
	Package = "/ package/gfxXPACK_CovertOps/XPACK_CovertOps";
	LibID = "CovertOpsComplete";
	InputState = eInputState_Consume;
}