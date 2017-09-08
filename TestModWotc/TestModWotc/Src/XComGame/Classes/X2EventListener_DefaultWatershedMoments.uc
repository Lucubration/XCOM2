//---------------------------------------------------------------------------------------
//  FILE:    X2EventListener_DefaultWatershedMoments.uc
//  AUTHOR:  David Burchanowski
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class X2EventListener_DefaultWatershedMoments extends X2EventListener;

// text that appears above soldier's heads when they have a watershed moment
var localized string WatershedMomentFlyover;

// text that appears in the corner of the screen when two soldiers have a watershed moment
var localized string WatershedMomentWorldMessage;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem(CreateEvacWithWoundedSoldierMomentTemplate());
	Templates.AddItem(CreateRescueSoldierMomentTemplate());
	Templates.AddItem(CreateSurvivedMissionMomentTemplate());

	return Templates;
}

static function X2EventListenerTemplate CreateEvacWithWoundedSoldierMomentTemplate()
{
	local X2EventListenerTemplate Template;

	`CREATE_X2TEMPLATE(class'X2EventListenerTemplate', Template, 'EvacWithWoundedSoldierMoment');

	Template.RegisterInTactical = true;
	Template.AddEvent('EvacActivated', CheckForEvacWithWoundedSoldierMoment);

	return Template;
}

static protected function EventListenerReturn CheckForEvacWithWoundedSoldierMoment(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local XComGameStateHistory History;
	local XComGameState_Effect CarryEffect;
	local XComGameState_Unit EvacUnit;
	local XComGameState_Unit CarriedUnit;

	EvacUnit = XComGameState_Unit(EventSource);

	// check if the evacuating unit was carrying somebody at the time of evac
	CarryEffect = EvacUnit.GetUnitApplyingEffectState(class'X2Ability_CarryUnit'.default.CarryUnitEffectName);

	if(CarryEffect != none)
	{
		History = `XCOMHISTORY;

		// both units have a watershed moment
		CarriedUnit = XComGameState_Unit(History.GetGameStateForObjectID(CarryEffect.ApplyEffectParameters.TargetStateObjectRef.ObjectID,, GameState.HistoryIndex - 1));
	
		if(CarriedUnit != none)
		{
			DoWatershedMoment(EvacUnit, CarriedUnit);
		}
	}

	return ELR_NoInterrupt;
}

static function X2EventListenerTemplate CreateRescueSoldierMomentTemplate()
{
	local X2EventListenerTemplate Template;

	`CREATE_X2TEMPLATE(class'X2EventListenerTemplate', Template, 'RescueSoldierMoment');

	Template.RegisterInTactical = true;
	Template.AddEvent('VIPRescued', CheckForRescueSoldierMoment);

	return Template;
}

// Returns the proxy unit for the given original, if any. Otherwise just returns the original
static protected function XComGameState_Unit GetProxyUnit(XComGameState_Unit OriginalUnit)
{
	local XComGameStateHistory History;
	local XComGameState_BattleData BattleData;
	local int Index;

	History = `XCOMHISTORY;

	BattleData = XComGameState_BattleData(History.GetSingleGameStateObjectForClass(class'XComGameState_BattleData'));
	for (Index = 0; Index < BattleData.RewardUnitOriginals.Length; Index++)
	{
		if(BattleData.RewardUnitOriginals[Index].ObjectID == OriginalUnit.ObjectID)
		{
			return XComGameState_Unit(History.GetGameStateForObjectID(BattleData.RewardUnits[Index].ObjectID));
		}
	}

	return OriginalUnit;
}

// Returns the original unit for the given proxy, if ProxyUnit is a proxy
static protected function XComGameState_Unit GetOriginalUnit(XComGameState_Unit ProxyUnit)
{
	local XComGameStateHistory History;
	local XComGameState_BattleData BattleData;
	local int Index;

	History = `XCOMHISTORY;

	BattleData = XComGameState_BattleData(History.GetSingleGameStateObjectForClass(class'XComGameState_BattleData'));
	for (Index = 0; Index < BattleData.RewardUnitOriginals.Length; Index++)
	{
		if(BattleData.RewardUnits[Index].ObjectID == ProxyUnit.ObjectID)
		{
			return XComGameState_Unit(History.GetGameStateForObjectID(BattleData.RewardUnitOriginals[Index].ObjectID));
		}
	}

	return ProxyUnit;
}

static protected function EventListenerReturn CheckForRescueSoldierMoment(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local XComGameState_Unit VipUnit;
	local XComGameState_Unit RescuingUnit;
	local XComGameStateContext_Ability AbilityContext;

	VipUnit = XComGameState_Unit(EventSource);
	if(VipUnit == none)
	{
		`Redscreen("CheckForRescueSoldierMoment did not receive a unit.");
		return ELR_NoInterrupt;
	}

	// Vips in tactical are almost always proxy units, so grab the original
	VipUnit = GetOriginalUnit(VipUnit);

	// if the VIP is a soldier, have a watershed moment with them
	if(VipUnit.IsSoldier())
	{
		// find the soldier that gets credit for rescuing the VIP. He's the guy that started this event chain
		AbilityContext = XComGameStateContext_Ability(GameState.GetContext().GetFirstStateInEventChain().GetContext());
		if(AbilityContext != none)
		{
			RescuingUnit = XComGameState_Unit(AbilityContext.AssociatedState.GetGameStateForObjectID(AbilityContext.InputContext.SourceObject.ObjectID));
			
			if(RescuingUnit.IsSoldier())
			{
				DoWatershedMoment(VipUnit, RescuingUnit);
			}
		}
	}

	return ELR_NoInterrupt;
}

static function X2EventListenerTemplate CreateSurvivedMissionMomentTemplate()
{
	local X2EventListenerTemplate Template;

	`CREATE_X2TEMPLATE(class'X2EventListenerTemplate', Template, 'SurvivedMissionMoment');

	Template.RegisterInTactical = true;
	Template.AddEvent('TacticalGameEnd', CheckForSurvivedMissionMoment);

	return Template;
}

static protected function EventListenerReturn CheckForSurvivedMissionMoment(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local XComGameStateHistory History;
	local XComGameState_HeadquartersXCom XComHQ;
	local StateObjectReference SquadMemberRef;
	local StateObjectReference BondmateRef;
	local XComGameState_Unit SquadMember;
	local array<XComGameState_Unit> Survivors;
	local array<XComGameState_Unit> SoldiersWithPreviousBondmates;
	
	History = `XCOMHISTORY;

	// two ways to have an end of mission watershed moment.
	// type a: Half (or more) of the squad is lost, survivors have a watershed moment
	// type b: Two soldiers who previously had bondmates survive a mission together, they have a watershed moment

	XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom', true));
	if(XComHQ == none)
	{
		return ELR_NoInterrupt; // no HQ, probably in PIE or TQL
	}

	// gather survivors, and survivors that previously had a bond mate but no longer do
	foreach XComHQ.Squad(SquadMemberRef)
	{
		SquadMember = XComGameState_Unit(History.GetGameStateForObjectID(SquadMemberRef.ObjectID));
		if(SquadMember.IsAlive() && !SquadMember.bBleedingOut)
		{
			Survivors.AddItem(SquadMember);

			if(!SquadMember.HasSoldierBond(BondmateRef) && SquadMember.HasEverHadSoldierBond())
			{
				SoldiersWithPreviousBondmates.AddItem(SquadMember);
			}
		}
	}

	// start with watershed moments for survivors of a terrible battle
	if(Survivors.Length <= XComHQ.Squad.Length / 2 && Survivors.Length > 1)
	{
		DoWatershedMoments(Survivors);
	}

	// and add in moments for survivors who don't have a bondmate any more
	if(SoldiersWithPreviousBondmates.Length > 1)
	{
		DoWatershedMoments(SoldiersWithPreviousBondmates);
	}
		
	return ELR_NoInterrupt;
}

protected static function WatershedMoment_BuildVisualization(XComGameState VisualizeGameState)
{
	local VisualizationActionMetadata ActionMetadata;
	local X2Action_PlaySoundAndFlyover FlyoverAction;
	local X2Action_PlayMessageBanner WorldMessageAction;
	local XComGameState_Unit UnitState;
	local XGParamTag Tag;

	// add a flyover track for every unit in the game state. This timing of this is too late to look good
	// but since Ryan is tearing it all out there is no reason to augment the visualization system to allow
	// it to look pretty
	foreach VisualizeGameState.IterateByClassType(class'XComGameState_Unit', UnitState)
	{
		// units in the game state are always the original unit, but it's possible one of the units in tactical
		// is a proxy. Since we need to visualize on the proxy, grab it
		UnitState = GetProxyUnit(UnitState);
		ActionMetadata.StateObject_OldState = UnitState;
		ActionMetadata.StateObject_NewState = UnitState;

		FlyoverAction = X2Action_PlaySoundAndFlyover(class'X2Action_PlaySoundAndFlyover'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext(), false, ActionMetadata.LastActionAdded));
		FlyoverAction.SetSoundAndFlyOverParameters(none, default.WatershedMomentFlyover, '', eColor_Good);

		Tag = XGParamTag(`XEXPANDCONTEXT.FindTag("XGParam"));
		Tag.StrValue0 = UnitState.GetFullName();
		WorldMessageAction = X2Action_PlayMessageBanner(class'X2Action_PlayMessageBanner'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext(), false, ActionMetadata.LastActionAdded));
		WorldMessageAction.AddMessageBanner(class'UIEventNoticesTactical'.default.WatershedMomentTitle,
									   ,
									   UnitState.GetName(eNameType_RankFull),
									   `XEXPAND.ExpandString(default.WatershedMomentWorldMessage),
									   eUIState_Good);
	}
}

// creates a watershed moment between two soldiers
static function DoWatershedMoment(XComGameState_Unit Unit1, XComGameState_Unit Unit2)
{
	local array<XComGameState_Unit> Units;

	Units.AddItem(Unit1);
	Units.AddItem(Unit2);
	DoWatershedMoments(Units);
}

// Creates an arbitrary number of watershed moments between a group of units
static function DoWatershedMoments(array<XComGameState_Unit> UnitStates)
{
	local XComGameState NewGameState;
	//local XComGameStateContext_ChangeContainer NewContext;
	local XComGameState_Unit Unit1;
	local XComGameState_Unit Unit2;
	local SoldierBond BondData;
	local int Unit1Index;
	local int Unit2Index;

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Watershed Moment");
	//NewContext = XComGameStateContext_ChangeContainer(NewGameState.GetContext());
	//NewContext.BuildVisualizationFn = WatershedMoment_BuildVisualization;	// since this is not really reading right now, we're removing the visualization of it; the gameplay is still a nice buff so we'll leave that in

	for(Unit1Index = 0; Unit1Index < UnitStates.Length; Unit1Index++)
	{
		for(Unit2Index = Unit1Index + 1; Unit2Index < UnitStates.Length; Unit2Index++)
		{
			Unit1 = UnitStates[Unit1Index];
			Unit2 = UnitStates[Unit2Index];
			`assert(Unit1 != none && Unit2 != none);

			if(!Unit1.GetSoldierClassTemplate().bCanHaveBonds || !Unit2.GetSoldierClassTemplate().bCanHaveBonds)
			{
				continue;
			}
		
			// Add the units to the new game state
			Unit1 = XComGameState_Unit(NewGameState.ModifyStateObject(Unit1.Class, Unit1.ObjectId));
			Unit2 = XComGameState_Unit(NewGameState.ModifyStateObject(Unit2.Class, Unit2.ObjectId));

			// if the unit's compatibility is negative, reroll it to be postitve
			if(!Unit1.GetBondData(Unit2.GetReference(), BondData) || BondData.Compatibility < 0)
			{
				class'X2StrategyGameRulesetDataStructures'.static.DetermineSoldierCompatibility(Unit1, Unit2, true);
			}

			`XEVENTMGR.TriggerEvent('OnWatershedMoment', , , NewGameState);
		}
	}

	if(NewGameState.GetNumGameStateObjects() > 0)
	{
		`TACTICALRULES.SubmitGameState(NewGameState);
	}
	else
	{
		// none of the supplied units could have a watershed moment, so remove them all
		`XCOMHISTORY.CleanupPendingGameState(NewGameState);
	}
}