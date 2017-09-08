// Rocket snapshot effects can add or remove penalties for Rocketeers based on the previous actions of the Rocketeer.
// This is a specialized case of a flat movement bonus; ultimately, the total of all snapshot effects on a Rocketeer
// cannot result in a positive rocket range modifier
class X2Effect_Beags_Escalation_RocketRangeModifySnapshot extends X2Effect_Persistent;

var float RangeModifier;
var bool UseWeaponRangeModifier;

function float ModifyRocketRange(XComGameState_Unit UnitState, XComGameState_Ability AbilityState, float RocketRange)
{
	local UnitValue Value;
	local XComGameState_Item WeaponState;
	local X2RocketLauncherTemplate_Beags_Escalation WeaponTemplate;

	if ((UnitState.GetUnitValue('MovesThisTurn', Value) && Value.fValue > 0) ||
		(UnitState.GetUnitValue('AttacksThisTurn', Value) && Value.fValue > 0))
	{
		if (UseWeaponRangeModifier)
		{
			WeaponState = AbilityState.GetSourceWeapon();
			if (WeaponState != none)
			{
				WeaponTemplate = X2RocketLauncherTemplate_Beags_Escalation(WeaponState.GetMyTemplate());
				if (WeaponTemplate != none)
					return RocketRange + WeaponTemplate.MoveRangePenalty;
			}
		}
		else
		{
			return RocketRange + RangeModifier;
		}
	}

	return RocketRange;
}
