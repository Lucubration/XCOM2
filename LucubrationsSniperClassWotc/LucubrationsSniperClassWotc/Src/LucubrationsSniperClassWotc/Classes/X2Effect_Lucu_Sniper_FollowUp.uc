class X2Effect_Lucu_Sniper_FollowUp extends X2Effect_Persistent;

var int Grants;

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
	local X2EventManager EventMgr;
	local XComGameState_Unit UnitState;
	local Object EffectObj;

	EventMgr = `XEVENTMGR;

	EffectObj = EffectGameState;
	UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectGameState.ApplyEffectParameters.SourceStateObjectRef.ObjectID));

	EventMgr.RegisterForEvent(EffectObj, 'Lucu_Sniper_FollowUpTriggered', EffectGameState.TriggerAbilityFlyover, ELD_OnStateSubmitted, , UnitState);
}

function bool PostAbilityCostPaid(XComGameState_Effect EffectState, XComGameStateContext_Ability AbilityContext, XComGameState_Ability kAbility, XComGameState_Unit SourceUnit, XComGameState_Item AffectWeapon, XComGameState NewGameState, const array<name> PreCostActionPoints, const array<name> PreCostReservePoints)
{
	local XComGameState_Unit TargetUnit;
	local XComGameState_Ability AbilityState;
	local int Check, i;
	local bool Grant;
	local UnitValue Value;
	local EffectAppliedData TargetEffectData;
	local X2Effect_Persistent TargetEffect;
	
	// Only during the controlling player's turn
	if (`TACTICALRULES.GetCachedUnitActionPlayerRef().ObjectID == SourceUnit.ControllingPlayer.ObjectID)
	{
		// Applies to offensive abilities only
		if (kAbility.GetMyTemplate().Hostility == eHostility_Offensive && kAbility.GetMyTemplate().TargetEffectsDealDamage(kAbility.GetSourceWeapon(), kAbility))
		{
			// Check if we've already granted enough Follow-Up action points this turn
			if (SourceUnit.GetUnitValue(class'X2Ability_Lucu_Sniper_SniperAbilitySet'.default.FollowUpName, Value))
				Check = Value.fValue;
			else
				Check = 0;
			if (Check < Grants)
			{
				// Check if the primary target was hit but didn't die
				TargetUnit = XComGameState_Unit(NewGameState.GetGameStateForObjectID(AbilityContext.InputContext.PrimaryTarget.ObjectID));
				if (AbilityContext.IsResultContextHit())
				{
					if (TargetUnit != none && TargetUnit.ObjectID > 0 && !TargetUnit.IsDead())
					{
						Grant = true;
					}
				}

				if (!Grant && AbilityContext.InputContext.MultiTargets.Length > 0)
				{
					for (i = 0; i < AbilityContext.InputContext.MultiTargets.Length; i++)
					{
						// Check if any multi-targets were hit but didn't die
						if (AbilityContext.IsResultContextMultiHit(i))
						{
							TargetUnit = XComGameState_Unit(NewGameState.GetGameStateForObjectID(AbilityContext.InputContext.MultiTargets[i].ObjectID));
							if (TargetUnit != none && TargetUnit.ObjectID > 0 && !TargetUnit.IsDead())
							{
								Grant = true;
								break;
							}
						}
					}
				}

				if (Grant)
				{
					// Add the follow-up action point
					SourceUnit.ActionPoints.AddItem(class'X2Ability_Lucu_Sniper_SniperAbilitySet'.default.FollowUpActionPoint);

					// Apply the follow-up target effect to the target
					TargetEffectData.EffectRef.SourceTemplateName = class'X2Ability_Lucu_Sniper_SniperAbilitySet'.default.FollowUpShotAbilityName;
					TargetEffectData.EffectRef.LookupType = TELT_AbilityTargetEffects;
					TargetEffectData.EffectRef.TemplateEffectLookupArrayIndex = 0;
					TargetEffect = X2Effect_Persistent(class'X2Effect'.static.GetX2Effect(TargetEffectData.EffectRef));
					if (TargetEffect != none)
						TargetEffect.ApplyEffect(TargetEffectData, TargetUnit, NewGameState);

					// Update the grants for this turn
					SourceUnit.SetUnitFloatValue(class'X2Ability_Lucu_Sniper_SniperAbilitySet'.default.FollowUpName, Check + 1, eCleanup_BeginTurn);
					
					AbilityState = XComGameState_Ability(`XCOMHISTORY.GetGameStateForObjectID(EffectState.ApplyEffectParameters.AbilityStateObjectRef.ObjectID));
					if (AbilityState != none)
						`XEVENTMGR.TriggerEvent('Lucu_Sniper_FollowUpTriggered', AbilityState, SourceUnit, NewGameState);

					return true;
				}
			}
		}
	}

	return false;
}
