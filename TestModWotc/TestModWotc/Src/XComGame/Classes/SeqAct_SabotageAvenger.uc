///---------------------------------------------------------------------------------------
//  FILE:    SeqAct_SabotageAvenger.uc
//  AUTHOR:  Joe Weinhoffer  --  5/17/17
//  PURPOSE: Action to trigger a Sabotage event in the Strategy layer from tactical
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2017 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class SeqAct_SabotageAvenger extends SequenceAction;

var string SabotageName; // the name of the sabotage
var string SabotageDesc; // the sabotage desc to display

event Activated()
{
	local X2StrategyElementTemplateManager StratMgr;
	local X2SabotageTemplate SabotageTemplate;
	local XComGameState_ChosenAction ActionState;

	ActionState = SabotageAvenger();

	if(ActionState != None)
	{
		StratMgr = class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager();
		SabotageTemplate = X2SabotageTemplate(StratMgr.FindStrategyElementTemplate(ActionState.StoredTemplateName));
		SabotageName = SabotageTemplate.DisplayName;
		SabotageDesc = ActionState.StoredShortDescription;
	
		OutputLinks[0].bHasImpulse = true;
		OutputLinks[1].bHasImpulse = false;
	}
	else
	{
		OutputLinks[0].bHasImpulse = false;
		OutputLinks[1].bHasImpulse = true;
	}
}

static function XComGameState_ChosenAction SabotageAvenger()
{
	local XComGameStateHistory History;
	local XComGameState NewGameState;
	local XComGameState_HeadquartersAlien AlienHQ;
	local XComGameState_AdventChosen ChosenState;
	local XComGameState_Unit UnitState;
	local XComGameState_ChosenAction ActionState;
	local X2StrategyElementTemplateManager StratMgr;
	local X2ChosenActionTemplate ActionTemplate;

	History = `XCOMHISTORY;
	StratMgr = class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager();
	
	// Find the Chosen that is on this mission
	AlienHQ = XComGameState_HeadquartersAlien(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersAlien'));
	if (AlienHQ != None)
	{
		UnitState = AlienHQ.GetChosenOnMission();
		ChosenState = UnitState.GetChosenGameState();
	}

	if (ChosenState == None)
	{
		// No Chosen found on mission, so can't complete sabotage
		return None;
	}

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Sabotage Avenger");
	ActionTemplate = X2ChosenActionTemplate(StratMgr.FindStrategyElementTemplate('ChosenAction_Sabotage'));
	ActionState = XComGameState_ChosenAction(NewGameState.CreateNewStateObject(class'XComGameState_ChosenAction', ActionTemplate));
	ActionState.ChosenRef = ChosenState.GetReference();
	ActionState.RollValue = 0; // Ensure the sabotage succeeds
	
	if (ActionTemplate.OnActivatedFn != none)
	{
		// Activate the sabotage, which will choose a random valid one and complete it
		ActionTemplate.OnActivatedFn(NewGameState, ActionState.GetReference());
	}
	
	`TACTICALRULES.SubmitGameState(NewGameState);

	return ActionState;
}

defaultproperties
{
	ObjName = "Sabotage Avenger"
	ObjCategory = "Scripting"
	bCallHandler = false

	bConvertedForReplaySystem = true
	bCanBeUsedForGameplaySequence = true
	bAutoActivateOutputLinks = false

	OutputLinks(0) = (LinkDesc = "Success")
	OutputLinks(1) = (LinkDesc = "Failed")

	VariableLinks(0) = (ExpectedType = class'SeqVar_String',LinkDesc = "Sabotage Name",PropertyName = SabotageName)
	VariableLinks(1) = (ExpectedType = class'SeqVar_String',LinkDesc = "Sabotage Description",PropertyName = SabotageDesc)
}