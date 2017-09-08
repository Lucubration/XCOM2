class X2Effect_Beags_Escalation_DoubleTap extends X2Effect_Persistent;

var name DoubleTapGrantsName;
	
function RegisterForEvents(XComGameState_Effect EffectGameState)
{
	local X2EventManager EventMgr;
	local XComGameState_Unit UnitState;
	local Object EffectObj;

	EventMgr = `XEVENTMGR;

	EffectObj = EffectGameState;
	UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectGameState.ApplyEffectParameters.SourceStateObjectRef.ObjectID));

	EventMgr.RegisterForEvent(EffectObj, 'Beags_Escalation_DoubleTapTriggered', EffectGameState.TriggerAbilityFlyover, ELD_OnStateSubmitted, , UnitState);
}

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameState_Unit TargetUnit;
	
	TargetUnit = XComGameState_Unit(kNewTargetState);

	// Empty the target's action points, grant them two Double Tap action points
	TargetUnit.ActionPoints.Length = 0;
	TargetUnit.ActionPoints.AddItem(class'X2Ability_Beags_Escalation_CommonAbilitySet'.default.DoubleTapActionPointName);
	TargetUnit.ActionPoints.AddItem(class'X2Ability_Beags_Escalation_CommonAbilitySet'.default.DoubleTapActionPointName);
	TargetUnit.ReserveActionPoints.Length = 0;
						
	`LOG("Beags Escalation: Double Tap action points granted.");
}

function bool PostAbilityCostPaid(XComGameState_Effect EffectState, XComGameStateContext_Ability AbilityContext, XComGameState_Ability kAbility, XComGameState_Unit SourceUnit, XComGameState_Item AffectWeapon, XComGameState NewGameState, const array<name> PreCostActionPoints, const array<name> PreCostReservePoints)
{
	local X2EventManager		EventMgr;
	local UnitValue				UnitValue;
	local int					DoubleTapActionPoints, i;
	local name					ActionPointName;
	
	//`LOG("Beags Escalation: Double Tap 'PostAbilityCostPaid' override called for overwatch shot ability " @ kAbility.GetMyTemplate().DataName @ ".");

	// Check if the unit spent a Double Tap skill
	if (class'X2Ability_Beags_Escalation_CommonAbilitySet'.static.IsDoubleTapAbility(kAbility.GetMyTemplate().DataName))
	{
		// Check if the unit has been granted Double Tap action points this turn
		if (!SourceUnit.GetUnitValue(default.DoubleTapGrantsName, UnitValue))
		{
			// Restore the unit to 2 Double Tap action points
			DoubleTapActionPoints = 0;
			foreach SourceUnit.ActionPoints(ActionPointName)
			{
				if (ActionPointName == class'X2Ability_Beags_Escalation_CommonAbilitySet'.default.DoubleTapActionPointName)
					DoubleTapActionPoints++;
			}

			for (i = DoubleTapActionPoints; i < 2; i++)
			{
				SourceUnit.ActionPoints.AddItem(class'X2Ability_Beags_Escalation_CommonAbilitySet'.default.DoubleTapActionPointName);
			}

			// Set unit value to indicate that Double Tap action points have been granted this turn
			SourceUnit.SetUnitFloatValue(default.DoubleTapGrantsName, 1, eCleanup_BeginTurn);

			EventMgr = `XEVENTMGR;
			EventMgr.TriggerEvent('Beags_Escalation_DoubleTapTriggered', kAbility, SourceUnit, NewGameState);

			`LOG("Beags Escalation: Double Tap action points granted.");

			return true;
		}
		else
		{
			// The second time the unit uses a Double Tap ability, remove all Double Tap action points from the unit
			for (i = SourceUnit.ActionPoints.Length - 1; i >= 0; i--)
			{
				if (SourceUnit.ActionPoints[i] == class'X2Ability_Beags_Escalation_CommonAbilitySet'.default.DoubleTapActionPointName)
					SourceUnit.ActionPoints.Remove(i, 1);
			}

			// Remove the Double Tap effect from the unit
			EffectState.RemoveEffect(NewGameState, NewGameState, true);
						
			`LOG("Beags Escalation: Double Tap action points cleared.");
		}
	}

	return false;
}

DefaultProperties
{
	DoubleTapGrantsName="Beags_Escalation_DoubleTapGrants"
}