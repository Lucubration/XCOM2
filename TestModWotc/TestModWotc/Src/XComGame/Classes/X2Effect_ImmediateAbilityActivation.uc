class X2Effect_ImmediateAbilityActivation extends X2Effect_Persistent;

var name AbilityName;      // Used to identify the ability that this effect will trigger

var private name EventName;

// By default this effect fires the ability on the source. If this value is set to true, the
// ability will instead be found and triggered on the target
var bool ActivateAbilityOnTarget;

// By default, the ability will only be activated on the target of the effect. If this is false,
// then the effect will be activated on all available targets
var bool EffectTargetOnly;

static private function TriggerAssociatedEvent(X2Effect_Persistent PersistentEffect, const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState)
{
	local XComGameState_Unit SourceUnit, TargetUnit;
	local X2Effect_ImmediateAbilityActivation ImmediateEffect;
	local XComGameStateHistory History;
	local X2EventManager EventManager;

	ImmediateEffect = X2Effect_ImmediateAbilityActivation(PersistentEffect);
	if (ImmediateEffect.AbilityName == '')
	{
		`RedScreen("X2Effect_ImmediateAbilityActivation - AbilityName must be set:"@ImmediateEffect.AbilityName);
	}

	History = `XCOMHISTORY;
	SourceUnit = XComGameState_Unit(History.GetGameStateForObjectID(ApplyEffectParameters.SourceStateObjectRef.ObjectID));
	TargetUnit = XComGameState_Unit(History.GetGameStateForObjectID(ApplyEffectParameters.TargetStateObjectRef.ObjectID));

	EventManager = `XEVENTMGR;
	EventManager.TriggerEvent(default.EventName, TargetUnit, SourceUnit);
}

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
	local X2EventManager EventMgr;
	local XComGameState_Unit SourceUnitState;
	local XComGameStateHistory History;
	local Object EffectObj;

	History = `XCOMHISTORY;
	EventMgr = `XEVENTMGR;

	EffectObj = EffectGameState;
	SourceUnitState = XComGameState_Unit(History.GetGameStateForObjectID(EffectGameState.ApplyEffectParameters.SourceStateObjectRef.ObjectID));

	// Register for the required events
	EventMgr.RegisterForEvent(EffectObj, default.EventName, EffectGameState.OnFireImmediateAbility, ELD_OnStateSubmitted,, SourceUnitState);
}

defaultproperties
{
	EffectAddedFn=TriggerAssociatedEvent
	EventName="TriggerImmediateAbility"

	ActivateAbilityOnTarget=false
	EffectTargetOnly=true
}