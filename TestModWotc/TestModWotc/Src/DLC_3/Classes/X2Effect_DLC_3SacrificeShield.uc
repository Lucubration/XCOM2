//---------------------------------------------------------------------------------------
//  FILE:    X2Effect_DLC_3SacrificeShield.uc
//  AUTHOR:  Joshua Bouscher
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class X2Effect_DLC_3SacrificeShield extends X2Effect_Persistent config(GameData_SoldierSkills);

var config array<name> IgnoreDamageTypes;       //  effects with the listed damage type will be allowed to hit the original target
var config array<name> IgnoreAbilities;         //  abilities listed here will be allowed to hit the original target
var config array<name> AbilitiesDisabledForAI;	// AI Ability names listed here will not be used against any units affected by this effect.

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

	EventMgr.RegisterForEvent(EffectObj, 'ImpairingEffect', EffectGameState.OnSourceBecameImpaired, ELD_OnStateSubmitted,, SourceUnitState);
}

function bool IsEffectCurrentlyRelevant(XComGameState_Effect EffectGameState, XComGameState_Unit TargetUnit)
{
	local XComGameState_Unit SourceUnit;

	SourceUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectGameState.ApplyEffectParameters.SourceStateObjectRef.ObjectID));
	
	if (SourceUnit == none || SourceUnit.IsDead() || SourceUnit.IsInStasis() || 
		TargetUnit == none || TargetUnit.IsDead() || TargetUnit.IsInStasis() ||
		TargetUnit.ObjectID == SourceUnit.ObjectID)
		return false;

	return class'Helpers'.static.IsTileInRange(SourceUnit.TileLocation, TargetUnit.TileLocation, class'X2Ability_SparkAbilitySet'.default.SACRIFICE_DISTANCE_SQ);
}

function bool EffectShouldRedirect(XComGameStateContext_Ability AbilityContext, XComGameState_Ability SourceAbility, XComGameState_Effect EffectState, const X2Effect PotentialRedirect, XComGameState_Unit SourceUnit, XComGameState_Unit TargetUnit, out StateObjectReference RedirectTarget, out name Reason, out name OverrideEffectResult)
{
	local name IgnoreType;
	local int MultiTargetIndex, i, OurMultiTargetIndex;
	local bool bFirstHitMultiTarget;

	if (!PotentialRedirect.bCanBeRedirected)
		return false;

	if (IsEffectCurrentlyRelevant(EffectState, TargetUnit))
	{
		//  check for damage types we don't handle
		foreach default.IgnoreDamageTypes(IgnoreType)
		{
			if (PotentialRedirect.DamageTypes.Find(IgnoreType) != INDEX_NONE)
				return false;
		}
		//  check for abilities we don't handled
		if (default.IgnoreAbilities.Find(AbilityContext.InputContext.AbilityTemplateName) != INDEX_NONE)
			return false;

		//  is this actually a hostile attack
		if (SourceAbility.GetMyTemplate().Hostility != eHostility_Offensive)
			return false;
		
		//  don't bother to redirect misses
		if (AbilityContext.InputContext.PrimaryTarget.ObjectID == TargetUnit.ObjectID)
		{
			if (AbilityContext.IsResultContextMiss())
				return false;
		}
		MultiTargetIndex = AbilityContext.InputContext.MultiTargets.Find('ObjectID', TargetUnit.ObjectID);
		if (MultiTargetIndex != INDEX_NONE)
		{
			if (AbilityContext.IsResultContextMultiMiss(MultiTargetIndex))
				return false;

			//  If it's a multi target hit, we only take the redirects from the first hit unit.
			//  The rest of them, we do sacrifice, but we don't suffer the consequences - we are immune to them.
			//  If we are naturally part of the multi targets, and we were hit naturally, then make sure we are immune to everyone else's redirects.
			OurMultiTargetIndex = AbilityContext.InputContext.MultiTargets.Find('ObjectID', EffectState.ApplyEffectParameters.SourceStateObjectRef.ObjectID);
			if (OurMultiTargetIndex != INDEX_NONE && AbilityContext.IsResultContextMultiHit(OurMultiTargetIndex))
			{
				bFirstHitMultiTarget = false;
			}
			else
			{
				bFirstHitMultiTarget = true;
				for (i = 0; i < MultiTargetIndex; ++i)
				{
					if (AbilityContext.IsResultContextMultiHit(i))
					{
						bFirstHitMultiTarget = false;
					}
				}
			}
			if (!bFirstHitMultiTarget)
				OverrideEffectResult = 'AA_Sacrifice';
		}

		//  only redirect if we aren't the source unit
		if (TargetUnit.ObjectID != EffectState.ApplyEffectParameters.SourceStateObjectRef.ObjectID)
		{
			RedirectTarget = EffectState.ApplyEffectParameters.SourceStateObjectRef;
			Reason = 'AA_Sacrifice';
			return true;
		}
	}
	return false;
}

function GetToHitAsTargetModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
	local ShotModifierInfo ModInfo;
	local XComGameState_Unit UnitState;

	if (IsEffectCurrentlyRelevant(EffectState, Target))
	{
		UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectState.ApplyEffectParameters.SourceStateObjectRef.ObjectID));
		ModInfo.Reason = FriendlyName;

		//  adjust hit chance based on defense of the sacrifice source unit. 
		if (!bIndirectFire)
		{
			ModInfo.ModType = eHit_Success;
			ModInfo.Value = Target.GetCurrentStat(eStat_Defense) - UnitState.GetCurrentStat(eStat_Defense);
			ShotModifiers.AddItem(ModInfo);
		}
		//  adjust dodge chance as well.
		ModInfo.ModType = eHit_Graze;
		ModInfo.Value = -(Target.GetCurrentStat(eStat_Dodge)) + UnitState.GetCurrentStat(eStat_Dodge);
		ShotModifiers.AddItem(ModInfo);
	}
}

function name TargetAdditiveAnimOnApplyWeaponDamage(XComGameStateContext Context, XComGameState_Unit TargetUnit, XComGameState_Effect EffectState)
{
	if (TargetUnit.ObjectID == EffectState.ApplyEffectParameters.SourceStateObjectRef.ObjectID)
		return 'ADD_Sacrifice_Damage';

	return '';
}

DefaultProperties
{
	EffectName = "DLC_3SacrificeShield"
	DuplicateResponse = eDupe_Ignore
}