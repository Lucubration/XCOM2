class X2Effect_Parry extends X2Effect_Persistent;

function bool ChangeHitResultForTarget(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit TargetUnit, XComGameState_Ability AbilityState, bool bIsPrimaryTarget, const EAbilityHitResult CurrentResult, out EAbilityHitResult NewHitResult)
{
	local UnitValue ParryUnitValue;

	`log("X2Effect_Parry::ChangeHitResultForTarget", , 'XCom_HitRolls');
	//	check for parry - if the unit value is set, then a parry is guaranteed
	if (TargetUnit.GetUnitValue('Parry', ParryUnitValue) && TargetUnit.IsAbleToAct())
	{
		if (ParryUnitValue.fValue > 0)
		{
			`log("Parry available - using!", , 'XCom_HitRolls');
			NewHitResult = eHit_Parry;
			TargetUnit.SetUnitFloatValue('Parry', ParryUnitValue.fValue - 1);
			return true;
		}
	}
	
	`log("Parry not available.", , 'XCom_HitRolls');
	return false;
}

DefaultProperties
{
	DuplicateResponse = eDupe_Ignore
	EffectName = "Parry"
}