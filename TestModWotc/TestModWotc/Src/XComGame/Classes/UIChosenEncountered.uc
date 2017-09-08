//---------------------------------------------------------------------------------------
//  *********   FIRAXIS SOURCE CODE   ******************
//  FILE:    UIChosenEncounter.uc
//  AUTHOR:  Joe Weinhoffer -- 1/31/2017
//  PURPOSE: This file displays information about a newly encountered Chosen
//---------------------------------------------------------------------------------------
//  Copyright (c) 2017 Firaxis Games, Inc. All rights reserved.
//--------------------------------------------------------------------------------------- 

class UIChosenEncountered extends UIScreen;

var public localized String ChosenEncounteredTitle;
var public localized String ChosenEncounteredLabel;
var public localized String ChosenEncounteredBody;

var StateObjectReference ChosenRef;

var Texture2D PosterPicture;

var DynamicPropertySet DisplayPropertySet;

//----------------------------------------------------------------------------
// MEMBERS

simulated function OnInit()
{
	super.OnInit();

	`HQPRES.StrategyMap2D.Hide();

	BuildScreen();
}

simulated function BuildScreen()
{
	local XComGameState NewGameState;
	local XComGameState_AdventChosen ChosenState;
	local String strChosenType, strChosenName, strChosenNickname, strBody;
	local XComGameStateHistory History;
	local XGParamTag ParamTag;

	History = `XCOMHISTORY;
	ChosenState = XComGameState_AdventChosen(History.GetGameStateForObjectID(ChosenRef.ObjectID));
	
	if (ChosenState != None)
	{
		`XSTRATEGYSOUNDMGR.PlayPersistentSoundEvent(ChosenState.GetMyTemplate().FanfareEvent);

		strChosenType = ChosenState.GetChosenClassName();
		strChosenName = ChosenState.GetChosenName();
		strChosenNickname = ChosenState.GetChosenNickname();
	}

	ParamTag = XGParamTag(`XEXPANDCONTEXT.FindTag("XGParam"));
	ParamTag.StrValue0 = ChosenState.GetChosenName();
	strBody = `XEXPAND.ExpandString(ChosenEncounteredBody);
	
	AS_UpdateData(ChosenState.GetChosenPosterImage(),
		""/*InspectingChosen.GetChosenIcon()*/,
		string(ChosenState.Level),
		Caps(strChosenType),
		strChosenName,
		Caps(strChosenNickname),
		strBody);

		`HQPRES.m_kAvengerHUD.NavHelp.AddContinueButton(OnContinue);
		MC.FunctionVoid("AnimateIn");
	
	AS_SetInfoPanelIcon(ChosenState.GetChosenIcon());

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Trigger Event: Chosen Encountered");
	`XEVENTMGR.TriggerEvent(ChosenState.GetChosenMetEvent(), , , NewGameState);
	`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);
}

simulated function UpdatePosterImage(INT CampaignIndex)
{
	MC.BeginFunctionOp("UpdatePosterImage");
	MC.QueueString(class'UIUtilities_Image'.static.ValidateImagePath(PathName(`XENGINE.m_kPhotoManager.GetLatestPoster(CampaignIndex))));
	MC.EndOp();
}

public function AS_UpdateData(string Poster,
	string ChosenIcon,
	string ChosenLevel,
	string ChosenType,
	string ChosenName,
	string ChosenNickname,
	string Description)
{
	MC.BeginFunctionOp("UpdateData");
	MC.QueueString(ChosenEncounteredTitle); //default text
	MC.QueueString(Poster);
	MC.QueueString(ChosenIcon);
	MC.QueueString(ChosenLevel);
	MC.QueueString(ChosenType);
	MC.QueueString(ChosenName);
	MC.QueueString(ChosenNickname);
	MC.QueueString(Description);
	MC.EndOp();
}

public function AS_SetInfoPanelIcon(StackedUIIconData IconInfo)
{
	local int i;

	MC.BeginFunctionOp("UpdateChosenIcon");
	MC.QueueBoolean(IconInfo.bInvert);
	for (i = 0; i < IconInfo.Images.Length; i++)
	{
		MC.QueueString("img:///" $ IconInfo.Images[i]);
	}

	MC.EndOp();
}

//-----------------------------------------------------------------------

simulated function bool OnUnrealCommand(int cmd, int arg)
{
	local bool bHandled;

	if (!CheckInputIsReleaseOrDirectionRepeat(cmd, arg))
		return false;

	bHandled = true;

	switch (cmd)
	{
	case class'UIUtilities_Input'.const.FXS_BUTTON_A :
	case class'UIUtilities_Input'.const.FXS_KEY_ENTER :
	case class'UIUtilities_Input'.const.FXS_KEY_SPACEBAR :

		OnContinue();
		break;

	default:
		bHandled = false;
		break;
	}

	return bHandled || super.OnUnrealCommand(cmd, arg);
}

simulated public function OnContinue()
{
	`HQPRES.m_kAvengerHUD.NavHelp.ClearButtonHelp();
	CloseScreen();
}

simulated function CloseScreen()
{
	`XSTRATEGYSOUNDMGR.PlayPersistentSoundEvent("ChosenPopupClose");
	super.CloseScreen();
}

//==============================================================================

defaultproperties
{
	Package = "/ package/gfxXPACK_ChosenEncountered/XPACK_ChosenEncountered";
	InputState = eInputState_Consume;
}