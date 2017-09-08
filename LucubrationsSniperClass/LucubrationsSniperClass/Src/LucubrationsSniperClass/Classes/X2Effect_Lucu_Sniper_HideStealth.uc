class X2Effect_Lucu_Sniper_HideStealth extends X2Effect_Persistent;

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameState_Unit UnitState;

	super.OnEffectAdded(ApplyEffectParameters, kNewTargetState, NewGameState, NewEffectState);
	
	UnitState = XComGameState_Unit(kNewTargetState);
	if (UnitState != none)
	{
		// Enter concealment when the effect is added
		`XEVENTMGR.TriggerEvent('EffectEnterUnitConcealment', UnitState, UnitState, NewGameState);

		`LOG("Lucubration Sniper Class: Hide Stealth effect applied concealment on unit " @ UnitState.GetFullName() @ ".");
	}

	super.OnEffectAdded(ApplyEffectParameters, kNewTargetState, NewGameState, NewEffectState);
}

function bool PostAbilityCostPaid(XComGameState_Effect EffectState, XComGameStateContext_Ability AbilityContext, XComGameState_Ability kAbility, XComGameState_Unit SourceUnit, XComGameState_Item AffectWeapon, XComGameState NewGameState, const array<name> PreCostActionPoints, const array<name> PreCostReservePoints)
{
	if (AbilityContext.InputContext.MovementPaths[0].MovementTiles.Length > 0)
	{
		// If the unit moved for any reason, break concealment
		`XEVENTMGR.TriggerEvent('EffectBreakUnitConcealment', SourceUnit, SourceUnit, NewGameState);
	}

	return false;
}

simulated function OnEffectRemoved(const out EffectAppliedData ApplyEffectParameters, XComGameState NewGameState, bool bCleansed, XComGameState_Effect RemovedEffectState)
{
	local XComGameState_Unit UnitState;
	local XComGameState_Effect TargetEffect;
	local bool HasRangerStealth;

	super.OnEffectRemoved(ApplyEffectParameters, NewGameState, bCleansed, RemovedEffectState);

	// Find the unit losing this effect
	UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(ApplyEffectParameters.TargetStateObjectRef.ObjectID));
	if (UnitState != none)
	{
		// Look for ranger stealth
		HasRangerStealth = false;
		foreach NewGameState.IterateByClassType(class'XComGameState_Effect', TargetEffect)
		{
			if (TargetEffect.GetX2Effect().EffectName == class'X2Effect_RangerStealth'.default.EffectName &&
				TargetEffect.ApplyEffectParameters.TargetStateObjectRef.ObjectID == UnitState.ObjectID)
			{
				HasRangerStealth = true;
				break;
			}
		}

		if (!HasRangerStealth)
		{
			// Break concealment when this effect is removed
			`XEVENTMGR.TriggerEvent('EffectBreakUnitConcealment', UnitState, UnitState, NewGameState);

			`LOG("Lucubration Sniper Class: Hide Stealth effect broke concealment on unit " @ UnitState.GetFullName() @ ".");
		}
		else
		{
			// I guess the unit could have ranger stealth from hack rewards. If we find it, do not break concealment when Escape and Evade stealth ends
			//`LOG("Lucubration Sniper Class: Hide Stealth effect skipped breaking concealment on unit " @ UnitState.GetFullName() @ " (has Ranger stealth).");
		}
	}
}

DefaultProperties
{
	EffectName = "EscapeAndEvadeStealth"
}