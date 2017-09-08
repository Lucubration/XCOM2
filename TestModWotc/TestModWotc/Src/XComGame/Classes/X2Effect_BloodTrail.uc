class X2Effect_BloodTrail extends X2Effect_Persistent;

var() int BonusDamage;

function int GetAttackingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, optional XComGameState NewGameState)
{
	local XComGameState_Unit TargetUnit;
	local UnitValue DamageUnitValue;

	if (class'XComGameStateContext_Ability'.static.IsHitResultHit(AppliedData.AbilityResultContext.HitResult) && AbilityState.IsAbilityInputTriggered())
	{
		if (AbilityState.SourceWeapon == EffectState.ApplyEffectParameters.ItemStateObjectRef)
		{
			TargetUnit = XComGameState_Unit(TargetDamageable);
			if (TargetUnit != none)
			{
			TargetUnit.GetUnitValue('DamageThisTurn', DamageUnitValue);
			if (DamageUnitValue.fValue > 0)
				return BonusDamage;
		}
	}
	}
	
	return 0;
}

DefaultProperties
{
	DuplicateResponse = eDupe_Ignore
	EffectName = "BloodTrail"
	bDisplayInSpecialDamageMessageUI = true
}
