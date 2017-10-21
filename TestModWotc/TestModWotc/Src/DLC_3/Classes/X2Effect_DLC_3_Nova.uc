class X2Effect_DLC_3_Nova extends X2Effect_Persistent config(GameData_SoldierSkills);

var config float MultiTargetPerTickIncrease;
var config float SourcePerTickIncrease;

function int GetAttackingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, optional XComGameState NewGameState)
{
	local float ExtraDamage;
	local XComGameState_Unit UnitState;
	local UnitValue UnitVal;

	if( AbilityState.GetMyTemplateName() == class'X2Ability_SparkAbilitySet'.default.NovaAbilityName )
	{
		UnitState = XComGameState_Unit(TargetDamageable);

		if( UnitState != none )
		{
			Attacker.GetUnitValue('NovaUsedAmount', UnitVal);
			if( UnitState.ObjectID == Attacker.ObjectID )
			{
				// Target itself, so add the extra source damage
				ExtraDamage = UnitVal.fValue * default.SourcePerTickIncrease;
			}
			else
			{
				// Multitarget, so add the extra multitarget damage
				ExtraDamage = UnitVal.fValue * default.MultiTargetPerTickIncrease;
			}
		}
	}

	return int(ExtraDamage);
}

defaultproperties
{
	bDisplayInSpecialDamageMessageUI = true
}
