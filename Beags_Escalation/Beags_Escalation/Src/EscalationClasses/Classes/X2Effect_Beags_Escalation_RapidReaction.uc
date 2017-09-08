// This class is the passive effect that sets up the listener for Overwatch attacks
class X2Effect_Beags_Escalation_RapidReaction extends X2Effect_Persistent;

var name RapidReactionGrantsName;
	
function RegisterForEvents(XComGameState_Effect EffectGameState)
{
	local X2EventManager EventMgr;
	local XComGameState_Unit UnitState;
	local Object EffectObj;

	EventMgr = `XEVENTMGR;

	EffectObj = EffectGameState;
	UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectGameState.ApplyEffectParameters.SourceStateObjectRef.ObjectID));

	EventMgr.RegisterForEvent(EffectObj, 'Beags_Escalation_RapidReactionTriggered', EffectGameState.TriggerAbilityFlyover, ELD_OnStateSubmitted, , UnitState);
}

// Triggered on the unit after they pay for an ability. If it's overwatch or pistol overwatch, check the unit state and refund them if necessary
function bool PostAbilityCostPaid(XComGameState_Effect EffectState, XComGameStateContext_Ability AbilityContext, XComGameState_Ability kAbility, XComGameState_Unit SourceUnit, XComGameState_Item AffectWeapon, XComGameState NewGameState, const array<name> PreCostActionPoints, const array<name> PreCostReservePoints)
{
	local XComGameStateHistory History;
	local XComGameState_Ability AbilityState;
	local X2EventManager EventMgr;
	local UnitValue UnitValue;
	local int RapidReactionGrants;
	
	// Check if this is an overwatch ability
	if (kAbility.GetMyTemplate().DataName == 'OverwatchShot' || kAbility.GetMyTemplate().DataName == 'PistolOverwatchShot' || kAbility.GetMyTemplate().DataName == 'LongWatchShot')
	{
		//`LOG("Beags Escalation: Rapid Reaction 'PostAbilityCostPaid' override called for overwatch shot ability " @ kAbility.GetMyTemplate().DataName @ ".");

		// Check if this was a hit
		if (AbilityContext.IsResultContextHit())
		{
			// Check if action points were spent
			if (SourceUnit.ReserveActionPoints.Length < PreCostReservePoints.Length)
			{
				// Check if we have any remaining points for rapid reaction
				RapidReactionGrants = 0;
				if (SourceUnit.GetUnitValue(default.RapidReactionGrantsName, UnitValue))
					RapidReactionGrants = UnitValue.fValue;

				if (RapidReactionGrants < class'X2Ability_Beags_Escalation_CommonAbilitySet'.default.RapidReactionBonusOverwatchShots)
				{
					History = `XCOMHISTORY;
					AbilityState = XComGameState_Ability(History.GetGameStateForObjectID(EffectState.ApplyEffectParameters.AbilityStateObjectRef.ObjectID));
					if (AbilityState != none)
					{
						// Restore the pre cost action points to fully refund this action
						SourceUnit.ReserveActionPoints = PreCostReservePoints;

						RapidReactionGrants = RapidReactionGrants + 1;
				
						// Set unit value with the number of Rapid Reaction grants this turn
						SourceUnit.SetUnitFloatValue(default.RapidReactionGrantsName, RapidReactionGrants, eCleanup_BeginTurn);

						EventMgr = `XEVENTMGR;
						EventMgr.TriggerEvent('Beags_Escalation_RapidReactionTriggered', AbilityState, SourceUnit, NewGameState);

						`LOG("Beags Escalation: Rapid Reaction refunded reserve action points (" @ RapidReactionGrants @ " grants remaining).");

						return true;
					}
					else
					{
						//`LOG("Beags Escalation: Rapid Reaction reserve action points not refunded (unit ability state not found).");
					}
				}
				else
				{
					//`LOG("Beags Escalation: Rapid Reaction reserve action points not refunded (unit has 0 remaining grants).");
				}
			}
			else
			{
				//`LOG("Beags Escalation: Rapid Reaction reserve action points not refunded (unit spent no action points).");
			}
		}
		else
		{
			//`LOG("Beags Escalation: Rapid Reaction reserve action points not refunded (unit did not hit with overwatch ability).");
		}
	}
	return false;
}

DefaultProperties
{
	RapidReactionGrantsName="Beags_Escalation_RapidReactionGrants"
}