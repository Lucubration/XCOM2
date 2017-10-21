//---------------------------------------------------------------------------------------
//  FILE:    X2Ability_DLC_Day90HackRewards.uc
//  AUTHOR:  Mark Nauta
//           
//	Creates and implements new hack rewards
//
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class X2Ability_DLC_Day90HackRewards extends X2Ability_HackRewards config(GameData_SoldierSkills);

//---------------------------------------------------------------------------------------
static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem(CreateControlAllDerelictMECsTemplate());

	return Templates;
}

//---------------------------------------------------------------------------------------
static function X2AbilityTemplate CreateControlAllDerelictMECsTemplate()
{
	local X2AbilityTemplate                 Template;
	local array<X2Effect>					SelectedEffects;
	local X2AbilityTrigger_EventListener    Listener;
	local X2AbilityMultiTarget_AllUnits		MultiTargetStyle;
	local int								EffectIndex;
	local X2Effect_MindControl				MindControlEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'ControlAllDerelictMECs');
	Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer);

	MindControlEffect = class'X2StatusEffects'.static.CreateMindControlStatusEffect(1);
	MindControlEffect.VisualizationFn = MassIntrusionVisualization;
	SelectedEffects.AddItem(MindControlEffect);
	SelectedEffects.AddItem(class'X2StatusEffects'.static.CreateMindControlRemoveEffects());

	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;

	Listener = new class'X2AbilityTrigger_EventListener';
	Listener.ListenerData.Deferral = ELD_OnStateSubmitted;
	Template.AbilityTargetStyle = default.SelfTarget;
	Listener.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
	Listener.ListenerData.EventID = class'X2HackRewardTemplateManager'.default.HackAbilityEventName;
	Listener.ListenerData.Filter = eFilter_None;
	Template.AbilityTriggers.AddItem(Listener);

	for(EffectIndex = 0; EffectIndex < SelectedEffects.Length; ++EffectIndex)
	{
		Template.AddMultiTargetEffect(SelectedEffects[EffectIndex]);
	}

	MultiTargetStyle = new class'X2AbilityMultiTarget_AllUnits';
	MultiTargetStyle.OnlyAllyOfType = 'FeralMEC_M1';
	Template.AbilityMultiTargetStyle = MultiTargetStyle;

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.bSkipFireAction = true;
	Template.bShowActivation = false;
	Template.bFrameEvenWhenUnitIsHidden = true;
	Template.FrameAbilityCameraType = eCameraFraming_Always;

	return Template;
}

static function MassIntrusionVisualization(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, const name EffectApplyResult)
{
	local X2Action_MindControlled MindControlAction;
	local XComGameState_Unit kUnit;

	if(EffectApplyResult != 'AA_Success')
		return;

	kUnit = XComGameState_Unit(ActionMetadata.StateObject_NewState);
	if(kUnit != none)
	{

		class'X2StatusEffects'.static.AddEffectSoundAndFlyOverToTrack(ActionMetadata, VisualizeGameState.GetContext(), class'X2StatusEffects'.default.HackedUnitFriendlyName, '', eColor_Bad, class'UIUtilities_Image'.const.UnitStatus_Haywire);
		class'X2StatusEffects'.static.AddEffectMessageToTrack(ActionMetadata,
															  class'X2StatusEffects'.default.HackedUnitEffectAcquiredString,
															  VisualizeGameState.GetContext(),
															  class'UIEventNoticesTactical'.default.HackedTitle,
															  class'UIUtilities_Image'.const.UnitStatus_Haywire,
															  eUIState_Bad);


		class'X2StatusEffects'.static.UpdateUnitFlag(ActionMetadata, VisualizeGameState.GetContext());
		MindControlAction = X2Action_MindControlled(class'X2Action_MindControlled'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext(), false, ActionMetadata.LastActionAdded));
		MindControlAction.bForceAllowNewAnimations = true;
	}
}