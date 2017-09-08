// This class is the passive effect that sets up the listener for the Overwatch ability and attacks
class X2Effect_Lucu_Infantry_EstablishedDefensesOverwatch extends X2Effect_Persistent;
	
function RegisterForEvents(XComGameState_Effect EffectGameState)
{
	local X2EventManager EventMgr;
	local XComGameState_Unit UnitState;
	local Object EffectObj;

	EventMgr = `XEVENTMGR;

	EffectObj = EffectGameState;
	UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectGameState.ApplyEffectParameters.SourceStateObjectRef.ObjectID));

	EventMgr.RegisterForEvent(EffectObj, 'Lucu_Infantry_EstablishedDefensesTriggered', EffectGameState.TriggerAbilityFlyover, ELD_OnStateSubmitted, , UnitState);
}

// Triggered on the unit after they pay for an ability. If it's overwatch or pistol overwatch, check the unit state and refund them if necessary
function bool PostAbilityCostPaid(XComGameState_Effect EffectState, XComGameStateContext_Ability AbilityContext, XComGameState_Ability kAbility, XComGameState_Unit SourceUnit, XComGameState_Item AffectWeapon, XComGameState NewGameState, const array<name> PreCostActionPoints, const array<name> PreCostReservePoints)
{
	local XComGameStateHistory History;
	local XComGameState_Unit HistoricalUnit;
	local X2EventManager EventMgr;
	local XComGameState_Ability AbilityState;
	local UnitValue UnitValue;
	local int i, EstablishedDefensesOverwatchPoints;
	local EffectAppliedData ApplyData;
	local X2Effect_Lucu_Infantry_EstablishedDefensesArmorBonus ArmorEffect;
	
	History = `XCOMHISTORY;
	
	// Check if this is an overwatch ability
	if (kAbility.GetMyTemplate().DataName == 'Overwatch' || kAbility.GetMyTemplate().DataName == 'PistolOverwatch' || kAbility.GetMyTemplate().DataName == 'SniperRifleOverwatch' || kAbility.GetMyTemplate().DataName == 'LongWatch')
	{
		HistoricalUnit = XComGameState_Unit(History.GetGameStateForObjectID(AbilityContext.InputContext.SourceObject.ObjectID));

		//`LOG("Lucubration Infantry Class: Established Defenses 'PostAbilityCostPaid' override called for overwatch ability " @ kAbility.GetMyTemplate().DataName @ ".");

		// Use the pre cost standard action points to apply the defense effects and prepare for restoring extra overwatch action points
		if (HistoricalUnit.ActionPoints.Length != PreCostActionPoints.Length)
		{
			// Count up the standard action points
			EstablishedDefensesOverwatchPoints = 0;
			for (i = 0; i < HistoricalUnit.ActionPoints.Length; i++)
				if (HistoricalUnit.ActionPoints[i] == class'X2CharacterTemplateManager'.default.StandardActionPoint)
					EstablishedDefensesOverwatchPoints++;

			if (EstablishedDefensesOverwatchPoints > 0)
			{
				// Set unit value with banked Established Defenses action points
				SourceUnit.SetUnitFloatValue(class'X2Ability_Lucu_Infantry_InfantryAbilitySet'.default.EstablishedDefensesOverwatchPointsName, EstablishedDefensesOverwatchPoints, eCleanup_BeginTurn);

				// Apply some effects to the unit
				for (i = 0; i < EstablishedDefensesOverwatchPoints; i++)
				{
					// Apply the Established Defenses armor effect directly to the unit
					ApplyData.EffectRef.LookupType = TELT_AbilityShooterEffects;
					ApplyData.EffectRef.TemplateEffectLookupArrayIndex = 0;
					ApplyData.EffectRef.SourceTemplateName = class'X2Ability_Lucu_Infantry_InfantryAbilitySet'.default.EstablishedDefensesOverwatchArmorAbilityName;
					ApplyData.PlayerStateObjectRef = SourceUnit.ControllingPlayer;
					ApplyData.SourceStateObjectRef = SourceUnit.GetReference();
					ApplyData.TargetStateObjectRef = SourceUnit.GetReference();
					ArmorEffect = X2Effect_Lucu_Infantry_EstablishedDefensesArmorBonus(class'X2Effect'.static.GetX2Effect(ApplyData.EffectRef));
					`assert(ArmorEffect != none);
					ArmorEffect.ApplyEffect(ApplyData, SourceUnit, NewGameState);

					//`LOG("Lucubration Infantry Class: Established Defenses applied bonus armor effect.");
				}

				//`LOG("Lucubration Infantry Class: Established Defenses registered " @ EstablishedDefensesOverwatchPoints @ " extra action points.");
				
				return true;
			}

			//`LOG("Lucubration Infantry Class: Established Defenses registered " @ EstablishedDefensesOverwatchPoints @ " extra action points.");
		}
	}
	else if (kAbility.GetMyTemplate().DataName == 'OverwatchShot' || kAbility.GetMyTemplate().DataName == 'PistolOverwatchShot')
	{
		//`LOG("Lucubration Infantry Class: Established Defenses 'PostAbilityCostPaid' override called for overwatch shot ability " @ kAbility.GetMyTemplate().DataName @ ".");

		// Check if action points were spent
		if (SourceUnit.ReserveActionPoints.Length != PreCostReservePoints.Length)
		{
			// Check if we have any remaining points banked from Established Defenses
			if (SourceUnit.GetUnitValue(class'X2Ability_Lucu_Infantry_InfantryAbilitySet'.default.EstablishedDefensesOverwatchPointsName, UnitValue))
			{
				EstablishedDefensesOverwatchPoints = UnitValue.fValue;

				if (EstablishedDefensesOverwatchPoints > 0)
				{
					AbilityState = XComGameState_Ability(`XCOMHISTORY.GetGameStateForObjectID(EffectState.ApplyEffectParameters.AbilityStateObjectRef.ObjectID));
					if (AbilityState != none)
					{
						// Restore the pre cost action points to fully refund this action
						SourceUnit.ReserveActionPoints = PreCostReservePoints;
				
						EstablishedDefensesOverwatchPoints--;

						// Set unit value with remaining Established Defenses points
						SourceUnit.SetUnitFloatValue(class'X2Ability_Lucu_Infantry_InfantryAbilitySet'.default.EstablishedDefensesOverwatchPointsName, EstablishedDefensesOverwatchPoints, eCleanup_BeginTurn);

						EventMgr = `XEVENTMGR;
						EventMgr.TriggerEvent('Lucu_Infantry_EstablishedDefensesTriggered', AbilityState, SourceUnit, NewGameState);

						//`LOG("Lucubration Infantry Class: Established Defenses spent 1 reserved Established Defenses overwatch point (" @ EstablishedDefensesOverwatchPoints @ " remaining).");

						return true;
					}
					else
					{
						//`LOG("Lucubration Infantry Class: Established Defenses overwatch point not refunded (unit Established Defenses ability state not found).");
					}
				}
				else
				{
					//`LOG("Lucubration Infantry Class: Established Defenses overwatch point not refunded (unit has 0 reserved Established Defenses overwatch points).");
				}
			}
			else
			{
				//`LOG("Lucubration Infantry Class: Established Defenses overwatch point not refunded (unit did not reserve Established Defenses overwatch points).");
			}
		}
		else
		{
			//`LOG("Lucubration Infantry Class: Established Defenses overwatch point not refunded (unit spent no action points).");
		}
	}
	return false;
}
