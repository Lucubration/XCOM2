//---------------------------------------------------------------------------------------
//  FILE:    X2Effect_BondmateAimAdjust.uc
//  AUTHOR:  David Burchanowski  --  10/28/2016
//  PURPOSE: Effect to increase aim against enemies that are targeting your bondmate
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class X2Effect_BondmateAimAdjust extends X2Effect_Persistent
	config(GameCore);

var protected const config int ThreatenedBondmateAimBonus;

var protected const config int BondmateTargetAimBonus;
var protected const config int BondmateTargetCritBonus;

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	super.OnEffectAdded(ApplyEffectParameters, kNewTargetState, NewGameState, NewEffectState);

	BuildPersistentEffect(0, true);
	SetDisplayInfo(ePerkBuff_Bonus, 
					class'X2Ability_DefaultBondmateAbilities'.default.BondmateAimAdjustName, 
					class'X2Ability_DefaultBondmateAbilities'.default.BondmateAimAdjustDesc, 
					"img:///UILibrary_PerkIcons.UIPerk_aim");
}

function GetToHitModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
	local StateObjectReference BondmateRef;
	local XComGameState_Unit BondmateUnit;
	local SoldierBond BondData;
	local ShotModifierInfo ShotInfo;

	if(!Attacker.HasSoldierBond(BondmateRef, BondData))
	{
		return;
	}

	BondmateUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(BondmateRef.ObjectID));
	if(BondmateUnit == none)
	{
		return;
	}

	if (BondData.BondLevel >= 2 && IsBondmateThreatenedByTarget(BondmateUnit, Target))
	{
		ShotInfo.ModType = eHit_Success;
		ShotInfo.Reason = class'X2Ability_DefaultBondmateAbilities'.default.DefendBondmateAimAdjustName;
		ShotInfo.Value = ThreatenedBondmateAimBonus;
		ShotModifiers.AddItem(ShotInfo);
	}

	if (BondData.BondLevel >= 3 && HasBondmateAttackedTargetSinceLastTurn(BondmateUnit, Target))
	{
		ShotInfo.ModType = eHit_Success;
		ShotInfo.Reason = class'X2Ability_DefaultBondmateAbilities'.default.AssistBondmateAimAdjustName;;
		ShotInfo.Value = BondmateTargetAimBonus;
		ShotModifiers.AddItem(ShotInfo);

		ShotInfo.ModType = eHit_Crit;
		ShotInfo.Reason = class'X2Ability_DefaultBondmateAbilities'.default.AssistBondmateCritAdjustName;;
		ShotInfo.Value = BondmateTargetCritBonus;
		ShotModifiers.AddItem(ShotInfo);
	}
}

protected function bool IsBondmateThreatenedByTarget(XComGameState_Unit BondmateUnit, XComGameState_Unit Target)
{
	local XComGameState_Ability AbilityState;
	local X2AbilityTargetStyle TargetStyle;

	// If the target flanks our bondmate, they are threatened
	if(BondmateUnit.IsFlanked(Target.GetReference()))
	{
		return true;
	}

	// If the target can melee our bondmate, they are threatened
	if(HasMeleeAbility(Target, AbilityState))
	{
		TargetStyle = AbilityState.GetMyTemplate().AbilityTargetStyle;
		if(TargetStyle != none && TargetStyle.ValidatePrimaryTargetOption(AbilityState, Target, BondmateUnit))
		{
			return true;
		}
	}

	// If the target attacked our bondmate in the last turn, they are threatened
	if(HasTargetAttackedBuddySinceTheStartOfLastTurn(BondmateUnit, Target))
	{
		return true;
	}

	return false;
}

protected function bool HasMeleeAbility(XComGameState_Unit UnitState, out XComGameState_Ability MeleeAbility)
{
	local XComGameStateHistory History;
	local StateObjectReference AbilityObjectRef;
	local XComGameState_Ability AbilityState;

	History = `XCOMHISTORY;

	foreach UnitState.Abilities(AbilityObjectRef)
	{
		AbilityState = XComGameState_Ability(History.GetGameStateForObjectID(AbilityObjectRef.ObjectID));
		if(AbilityState.GetMyTemplate().Hostility == eHostility_Offensive && AbilityState.IsMeleeAbility())
		{
			MeleeAbility = AbilityState;
			return true;
		}
	}

	return false;
}

protected function bool HasTargetAttackedBuddySinceTheStartOfLastTurn(XComGameState_Unit BondmateUnit, XComGameState_Unit Target)
{
	local XComGameStateHistory History;
	local XComGameState_Ability AbilityState;
	local XComGameStateContext_TacticalGameRule RuleContext;
	local XComGameStateContext_Ability AbilityContext;
	local int StartOfLastTargetTurnIndex;

	// Find the start of the target's last turn
	StartOfLastTargetTurnIndex = 0;
	History = `XCOMHISTORY;
	foreach History.IterateContextsByClassType(class'XComGameStateContext_TacticalGameRule', RuleContext)
	{
		if(RuleContext.GameRuleType == eGameRule_PlayerTurnBegin && RuleContext.PlayerRef.ObjectID == Target.GetAssociatedPlayerID())
		{
			StartOfLastTargetTurnIndex = RuleContext.AssociatedState.HistoryIndex;
			break;
		}
	}

	// and then see if the target has attacked our buddy since then
	foreach History.IterateContextsByClassType(class'XComGameStateContext_Ability', AbilityContext)
	{
		if(AbilityContext.AssociatedState.HistoryIndex < StartOfLastTargetTurnIndex)
		{
			return false;
		}

		if(AbilityContext.InputContext.SourceObject == Target.GetReference()
			&& AbilityContext.InputContext.PrimaryTarget == BondmateUnit.GetReference())
		{
			AbilityState = XComGameState_Ability(History.GetGameStateForObjectID(AbilityContext.InputContext.AbilityRef.ObjectID));
			if(AbilityState != none && AbilityState.GetMyTemplate().Hostility == eHostility_Offensive)
			{
				return true;
			}
		}
	}

	return true;
}

protected function bool HasBondmateAttackedTargetSinceLastTurn(XComGameState_Unit BondmateUnit, XComGameState_Unit Target)
{
	local XComGameStateHistory History;
	local XComGameState_Ability AbilityState;
	local XComGameStateContext_TacticalGameRule RuleContext;
	local XComGameStateContext_Ability AbilityContext;
	local int StartOfLastBondmateTurnIndex;

	// Find the start of the target's last turn
	StartOfLastBondmateTurnIndex = 0;
	History = `XCOMHISTORY;
	foreach History.IterateContextsByClassType(class'XComGameStateContext_TacticalGameRule', RuleContext)
	{
		if(RuleContext.GameRuleType == eGameRule_PlayerTurnBegin && RuleContext.PlayerRef.ObjectID == BondmateUnit.GetAssociatedPlayerID())
		{
			StartOfLastBondmateTurnIndex = RuleContext.AssociatedState.HistoryIndex;
			break;
		}
	}

	// and then see if the target has attacked our buddy since then
	foreach History.IterateContextsByClassType(class'XComGameStateContext_Ability', AbilityContext)
	{
		if(AbilityContext.AssociatedState.HistoryIndex < StartOfLastBondmateTurnIndex)
		{
			return false;
		}

		if(AbilityContext.InputContext.SourceObject == BondmateUnit.GetReference()
			&& AbilityContext.InputContext.PrimaryTarget == Target.GetReference())
		{
			AbilityState = XComGameState_Ability(History.GetGameStateForObjectID(AbilityContext.InputContext.AbilityRef.ObjectID));
			if(AbilityState != none && AbilityState.GetMyTemplate().Hostility == eHostility_Offensive)
			{
				return true;
			}
		}
	}

	return true;
}

DefaultProperties
{
	DuplicateResponse = eDupe_Ignore
	EffectName = "BondmateAimAdjust"
}