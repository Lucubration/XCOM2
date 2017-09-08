//---------------------------------------------------------------------------------------
//  FILE:    X2Effect_SuperConcealModifier.uc
//  AUTHOR:  Russell Aasland  --  7/11/2016
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class X2Effect_SuperConcealModifier extends X2Effect_Persistent;

var float ConcealAmountScalar;
var array<name> AbilitiesAffectedFilter;
var array<name> RemoveOnAbilityActivation;

function bool AdjustSuperConcealModifier(XComGameState_Unit UnitState, XComGameState_Effect EffectState, XComGameState_Ability AbilityState, XComGameState RespondToGameState, const int BaseModifier, out int Modifier)
{
	if ((AbilitiesAffectedFilter.Length > 0) && (AbilitiesAffectedFilter.Find( AbilityState.GetMyTemplateName() ) == INDEX_NONE))
	{
		return false;
	}

	Modifier += BaseModifier * ConcealAmountScalar;

	return true;
}

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
	local X2EventManager EventMgr;
	local Object EffectObj;
	local XComGameState_BaseObject TargetUnit;

	if (RemoveOnAbilityActivation.Length > 0) // if we're not going to be removed, don't bother listening for the events
	{
		EffectObj = EffectGameState;
		EventMgr = `XEVENTMGR;

		TargetUnit = `XCOMHISTORY.GetGameStateForObjectID( EffectGameState.ApplyEffectParameters.TargetStateObjectRef.ObjectID );

		EventMgr.RegisterForEvent(EffectObj, 'AbilityActivated', EffectGameState.RemoveSuperConcealModifierListener, ELD_OnStateSubmitted, , TargetUnit);
	}
}

DefaultProperties
{
	DuplicateResponse = eDupe_Ignore
}