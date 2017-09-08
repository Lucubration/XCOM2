
//---------------------------------------------------------------------------------------
//  *********   FIRAXIS SOURCE CODE   ******************
//  FILE:    UIResistanceReport_ChosenEvents
//  AUTHOR:  Dan Kaplan
//  PURPOSE: Shows end of month information summary.
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//--------------------------------------------------------------------------------------- 


class UIResistanceReport_ChosenEvents extends UIX2SimpleScreen;

var name DisplayTag;
var string CameraTag;

var float m_fAnimateTime;
var float m_fAnimateRate;

var array<name> ChosenOrder;
var array<StateObjectReference> ChosenRefs;
var array<StateObjectReference> ChosenLevelUpRefs;
var bool bSimpleView;
var bool bShowChosenWarningPopup;

var MaterialInstanceConstant UIDisplayMIC;

var UIPanel warningPopup;
var UIButton WarningButton;

var localized string ChosenActivityTitle;
var localized string PrevMonthActivitiesHeader;
var localized string UnknownChosenLabel;
var localized string DefeatedChosenLabel;
var localized string KnowledgeLabel;
var localized string ActionHeader;
var localized string KnowledgeGainPrefix;
var localized string KnowledgePopupTitle;
var localized string KnowledgePopupText;
var localized string KnowledgePopupButtonTitle;

simulated function InitScreen(XComPlayerController InitController, UIMovie InitMovie, optional name InitName)
{
	super.InitScreen(InitController, InitMovie, InitName);
	
	`HQPRES.CAMLookAtNamedLocation(CameraTag, `HQINTERPTIME);
	`HQPRES.m_kAvengerHUD.FacilityHeader.Hide();
	`HQPRES.StrategyMap2D.ClearDarkEvents();
	
}

simulated function OnInit()
{
	local StateObjectReference ChosenRef;

	super.OnInit();

	warningPopup = Spawn(class'UIPanel', self);
	warningPopup.bAnimateOnInit = false;
	warningPopup.InitPanel('warningPopup', 'tutorialPopup');
	
	if(`ISCONTROLLERACTIVE)
		warningPopup.DisableNavigation();
	else
		warningPopup.SetSelectedNavigation();
	
	WarningButton = Spawn(class'UIButton', warningPopup);
	
	WarningButton.ResizeToText = false;

	if(`ISCONTROLLERACTIVE)
	   WarningButton.InitButton('theButton', "", OnPopupButton, eUIButtonStyle_HOTLINK_WHEN_SANS_MOUSE);
	else
		WarningButton.InitButton('theButton', "", OnPopupButton);
	
	WarningButton.bAnimateOnInit = false;

	InitializeStrategyData();
	SetScreenTitle();

	if(bShowChosenWarningPopup)
	{
		SetChosenWarningPopup();
		HQPRES().m_kAvengerHUD.NavHelp.ClearButtonHelp();
	}

	if (ChosenLevelUpRefs.Length > 0)
	{
		HQPRES().m_kAvengerHUD.NavHelp.ClearButtonHelp();
		foreach ChosenLevelUpRefs(ChosenRef)
		{
			`HQPRES.UIChosenLevelUp(ChosenRef);
		}
	}
	else
	{
		RealizeColumns();
		UpdateNavHelp();
		MC.FunctionVoid("AnimateIn");
		PlayChosenSound("ChosenEndOfMonth_Start");
	}

	ResetChosenImage("0");
	ResetChosenImage("1");
	ResetChosenImage("2");

}

simulated function InitializeStrategyData()
{
	local array<XComGameState_AdventChosen> AllChosen;
	local name ChosenName;
	local int idx;
	local bool bChosenGainedKnowledgeLevel;
	
	AllChosen = ALIENHQ().GetAllChosen();
	bChosenGainedKnowledgeLevel = false;

	// Try to put the chosen in a set order
	foreach ChosenOrder(ChosenName)
	{
		for(idx = 0; idx < AllChosen.Length; idx++)
		{
			if(AllChosen[idx].GetMyTemplateName() == ChosenName)
			{
				if(AllChosen[idx].bJustIncreasedKnowledgeLevel)
				{
					bChosenGainedKnowledgeLevel = true;
				}

				if(AllChosen[idx].bJustLeveledUp && AllChosen[idx].bMetXCom && AllChosen[idx].NumEncounters > 0)
				{
					ChosenLevelUpRefs.AddItem(AllChosen[idx].GetReference());
				}

				ChosenRefs.AddItem(AllChosen[idx].GetReference());
				AllChosen.Remove(idx, 1);
				break;
			}
		}
	}

	// Append rest to end of the list if needed
	for(idx = 0; idx < AllChosen.Length; idx++)
	{
		if(AllChosen[idx].bJustIncreasedKnowledgeLevel)
		{
			bChosenGainedKnowledgeLevel = true;
		}

		if (AllChosen[idx].bJustLeveledUp && AllChosen[idx].bMetXCom && AllChosen[idx].NumEncounters > 0)
		{
			ChosenLevelUpRefs.AddItem(AllChosen[idx].GetReference());
		}

		ChosenRefs.AddItem(AllChosen[idx].GetReference());
	}

	bShowChosenWarningPopup = (!ALIENHQ().bSeenChosenKnowledgeGain && bChosenGainedKnowledgeLevel);
}

simulated function bool OnUnrealCommand(int cmd, int arg)
{
	if (!CheckInputIsReleaseOrDirectionRepeat(cmd, arg))
	{
		return false;
	}

	switch(cmd)
	{
	case class'UIUtilities_Input'.const.FXS_BUTTON_A:
	case class'UIUtilities_Input'.const.FXS_KEY_ENTER:
		//bsg-hlee (05.03.17): If there is no popup then close this screen.
		if(!bShowChosenWarningPopup)
		{
			OnContinue();
		}
		else //The popup is still active and on the top so take care of it first.
		{
			OnPopupButton(WarningButton);
		}
		//bsg-hlee (05.03.17): End
		return true;
		break;
	case class'UIUtilities_Input'.const.FXS_BUTTON_B:
		return false;
	}

	return super.OnUnrealCommand(cmd, arg);
}

//-------------- EVENT HANDLING ----------------------------------------------------------
simulated function OnCommand(string cmd, string arg)
{
	switch (cmd)
	{
		case "PlayChosenSound": PlayChosenSound(arg);
		break;
		case "ShowChosenImage": ShowChosenImage(arg);
		break;
	}
}

simulated function OnContinue()
{
	CloseScreen();
}

simulated function UpdateNavHelp()
{
	if( HQPRES() != none )
	{
		HQPRES().m_kAvengerHUD.NavHelp.ClearButtonHelp();
		//bsg-hlee (05.03.17): If there is a popup then hide this button because the popup is higher.
		if(!bShowChosenWarningPopup)
		{
			HQPRES().m_kAvengerHUD.NavHelp.AddContinueButton(OnContinue);
		}
		//bsg-hlee (05.03.17): End
	}
}

simulated function CloseScreen()
{
	PlayChosenSound( "ChosenEndOfMonth_Stop" );
	`XCOMGRI.DoRemoteEvent('HideChosenDarkEventTint');
	if( !bSimpleView ) HQPRES().m_kAvengerHUD.NavHelp.ClearButtonHelp();
	if( !bSimpleView ) ClearChosenMonthActivities();
	super.CloseScreen();
	if( !bSimpleView ) HQPRES().UIAdventOperations(true);
}

simulated function ClearChosenMonthActivities()
{
	local XComGameState NewGameState;
	local XComGameState_AdventChosen ChosenState;
	local int idx;

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Clear Chosen Month Activities");

	for(idx = 0; idx < ChosenRefs.Length; idx++)
	{
		ChosenState = XComGameState_AdventChosen(NewGameState.ModifyStateObject(class'XComGameState_AdventChosen', ChosenRefs[idx].ObjectID));
		ChosenState.ClearMonthActivities();
	}

	`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);
}

simulated function OnLoseFocus()
{
	if(!bIsFocused)
		return;
	super.OnLoseFocus();
	HQPRES().m_kAvengerHUD.NavHelp.ClearButtonHelp(); //bsg-crobinson (5.11.17): Clear button help on lose focus
	Hide();
}

simulated function OnReceiveFocus()
{
	super.OnReceiveFocus();
	Show();
	RealizeColumns();
	UpdateNavHelp();
	MC.FunctionVoid("AnimateIn");
	PlayChosenSound("ChosenEndOfMonth_Start");
}

simulated function ResetChosenImage(string arg)
{
	local XComLevelActor DisplayActor;
	local MaterialInterface BaseMaterial;
	local name TargetTag;
	local XComGameState_AdventChosen ChosenState;

	ChosenState = XComGameState_AdventChosen(`XCOMHISTORY.GetGameStateForObjectID(ChosenRefs[int(arg)].ObjectID));

	//Bail if we haven't met this chosen. 
	if (!ChosenState.bMetXCom) return;

	TargetTag = ChosenState.GetMyTemplate().ResistanceReportTag;

	foreach class'Engine'.static.GetCurrentWorldInfo().AllActors(class'XComLevelActor', DisplayActor)
	{
		if (DisplayActor.Tag == TargetTag)
		{
			BaseMaterial = DisplayActor.StaticMeshComponent.GetMaterial(0);
			UIDisplayMIC = MaterialInstanceConstant(BaseMaterial);
			UIDisplayMIC.SetScalarParameterValue('MetXcom', 0);
			break;
		}
	}
}

simulated function ShowChosenImage( string arg )
{
	local XComLevelActor DisplayActor;
	local MaterialInterface BaseMaterial;
	local name TargetTag;
	local XComGameState_AdventChosen ChosenState;

	ChosenState = XComGameState_AdventChosen(`XCOMHISTORY.GetGameStateForObjectID(ChosenRefs[int(arg)].ObjectID));
	
	//Bail if we haven't met this chosen. 
	if( !ChosenState.bMetXCom ) return;

	TargetTag = ChosenState.GetMyTemplate().ResistanceReportTag;

	foreach class'Engine'.static.GetCurrentWorldInfo().AllActors(class'XComLevelActor', DisplayActor)
	{
		if( DisplayActor.Tag == TargetTag )
		{
			BaseMaterial = DisplayActor.StaticMeshComponent.GetMaterial(0);
			UIDisplayMIC = MaterialInstanceConstant(BaseMaterial);
			UIDisplayMIC.SetScalarParameterValue('MetXcom', 0);
			SetTimer(m_fAnimateRate, true, 'AnimateChosenMaterial');
			break;
		}
	}
}

simulated function AnimateChosenMaterial(optional float Delay = 0.5)
{
	m_fAnimateTime += m_fAnimateRate;

	UIDisplayMIC.SetScalarParameterValue('MetXcom', m_fAnimateTime);

	if (m_fAnimateTime > 1)
	{
		ClearTimer('AnimateChosenMaterial');
		m_fAnimateTime = 0;
	}
}

simulated function PlayChosenSound( string arg )
{
	`XSTRATEGYSOUNDMGR.PlayPersistentSoundEvent(arg);
}

//-------------- FLASH DIRECT ACCESS --------------------------------------------------
simulated function SetScreenTitle()
{
	`XCOMGRI.DoRemoteEvent('ShowChosenDarkEventTint');
	MC.BeginFunctionOp("SetChosenPolicyTitle");
	MC.QueueString(ChosenActivityTitle);
	MC.EndOp();
}

simulated function SetChosenWarningPopup()
{
	MC.BeginFunctionOp("SetChosenWarningPopup");
	MC.QueueString(KnowledgePopupTitle);
	MC.QueueString(KnowledgePopupText);
	MC.QueueString(KnowledgePopupButtonTitle);
	MC.EndOp();
}

simulated function OnPopupButton(UIButton button)
{
	local XComGameState NewGameState;
	local XComGameState_HeadquartersAlien NewAlienHQ;

	NewAlienHQ = ALIENHQ();
	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Set Knowledge Warning Flag");
	NewAlienHQ = XComGameState_HeadquartersAlien(NewGameState.ModifyStateObject(class'XComGameState_HeadquartersAlien', NewAlienHQ.ObjectID));
	NewAlienHQ.bSeenChosenKnowledgeGain = true;
	`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);

	bShowChosenWarningPopup = false; // bsg-hlee (05.03.17): No longer showing the popup.

	MC.FunctionVoid("CloseWarningPopup");
	UpdateNavHelp();
}

simulated function RealizeColumns()
{
	local XComGameStateHistory History;
	local XComGameState NewGameState;
	local XComGameState_AdventChosen ChosenState, TriggerVOChosen;
	local XComGameState_ChosenAction ActionState;
	local int idx;

	History = `XCOMHISTORY;

	for(idx = 0; idx < ChosenRefs.Length; idx++)
	{
		ChosenState = XComGameState_AdventChosen(History.GetGameStateForObjectID(ChosenRefs[idx].ObjectID));
		ActionState = XComGameState_ChosenAction(History.GetGameStateForObjectID(ChosenState.CurrentMonthAction.ObjectID));
		
		SetChosenIcon(idx, ChosenState.GetChosenIcon());

		RealizeColumn(ChosenState, ActionState, idx);

		if (ChosenState.bJustIncreasedKnowledgeLevel && (TriggerVOChosen == None || ChosenState.GetKnowledgeScore() > TriggerVOChosen.GetKnowledgeScore()))
		{
			TriggerVOChosen = ChosenState;
		}
	}

	if (TriggerVOChosen != None)
	{
		NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Trigger Event: Chosen Knowledge Threshold Increased");
		`XEVENTMGR.TriggerEvent(TriggerVOChosen.GetThresholdIncreasedEvent(), , , NewGameState);
		
		if(ChosenState.GetKnowledgeLevel() == eChosenKnowledge_Sentinel)
			`XEVENTMGR.TriggerEvent('ChosenKnowledgeHalfway', , , NewGameState);
		else if (ChosenState.GetKnowledgeLevel() == eChosenKnowledge_Raider)
			`XEVENTMGR.TriggerEvent('ChosenKnowledgeComplete', , , NewGameState);
		
		`GAMERULES.SubmitGameState(NewGameState);
	}
}

simulated function RealizeColumn(XComGameState_AdventChosen ChosenState, XComGameState_ChosenAction ActionState, int Index)
{
	MC.BeginFunctionOp("SetChosenPolicyColumnData");
	MC.QueueNumber(Index); // Column Index
	MC.QueueString(ChosenState.bMetXCom ? "" : UnknownChosenLabel); // Has the Chosen met XCOM
	MC.QueueString(""); // Chosen Icon
	MC.QueueString(string(ChosenState.Level + 1)); // Chosen Level
	MC.QueueBoolean(false); // Is this Chosen favored
	MC.QueueString(ChosenState.GetChosenClassName()); // Type of the Chosen
	MC.QueueString(ChosenState.GetChosenName()); // Chosen Name
	MC.QueueString("'" $ ChosenState.GetChosenNickname() $ "'"); // Chosen Nickname
	MC.QueueNumber(ChosenState.GetKnowledgePercent()); // Previous Chosen Knowledge percent
	MC.QueueNumber(ChosenState.GetKnowledgePercent(true)); // Current Chosen Knowledge percent
	MC.QueueString(KnowledgeLabel); // Knowledge Label
	MC.QueueString(ChosenState.GetMonthActivitiesList()); // List of Chosen activities
	MC.QueueString(ChosenState.bDefeated ? DefeatedChosenLabel : "");
	MC.QueueString(ActionState.GetDisplayName()); // Action label
	MC.QueueString(ActionState.GetSummaryText()); // Action description
	MC.QueueString(ActionState.GetQuote()); // Action quote
	MC.QueueString(ActionState.GetImagePath()); // Action image
	MC.QueueString(ActionHeader); // Action Header label
	MC.QueueString(ChosenState.bJustIncreasedKnowledgeLevel ? KnowledgeGainPrefix @ ChosenState.KnowledgeGainTitle[ChosenState.GetKnowledgeLevel()] : ""); // Knowledge gain label
	MC.QueueString(ChosenState.bJustIncreasedKnowledgeLevel ? ChosenState.KnowledgeGainFirstBullet[ChosenState.GetKnowledgeLevel()] : ""); // Knowledge string 1
	MC.QueueString(ChosenState.bJustIncreasedKnowledgeLevel ? ChosenState.KnowledgeGainSecondBullet[ChosenState.GetKnowledgeLevel()] : ""); // Knowledge string 2
	MC.QueueString(ChosenState.bJustIncreasedKnowledgeLevel ? ChosenState.KnowledgeGainThirdBullet[ChosenState.GetKnowledgeLevel()] : ""); // Knowledge string 3
	MC.EndOp();
}

simulated function SetChosenIcon(int Index, StackedUIIconData IconInfo)
{
	local int i;

	MC.BeginFunctionOp("SetChosenPolicyColumnIcon");
	MC.QueueNumber( Index );
	MC.QueueBoolean(IconInfo.bInvert);
	for (i = 0; i < IconInfo.Images.Length; i++)
	{
		MC.QueueString("img:///" $ IconInfo.Images[i]);
	}

	MC.EndOp();
}

//------------------------------------------------------

defaultproperties
{
	Package = "/ package/gfxXPACK_ChosenPolicy/XPACK_ChosenPolicy";
	bAnimateOnInit = false;
	bHideOnLoseFocus = true;
	DisplayTag = "UIDisplay_Council_ChosenEvents";
	CameraTag = "UIDisplayCam_ResistanceScreen_DarkEvents";
	ChosenOrder[0] = "Chosen_Assassin";
	ChosenOrder[1] = "Chosen_Warlock";
	ChosenOrder[2] = "Chosen_Hunter";
	bSimpleView = false; 
	m_fAnimateRate = 0.01f;
}
