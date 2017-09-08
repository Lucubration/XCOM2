class X2Effect_Deflect extends X2Effect_Persistent
	config(GameData_SoldierSkills);

var config int DeflectMinFocus, DeflectBaseChance, DeflectPerFocusChance;
var config int ReflectMinFocus, ReflectBaseChance;

function bool ChangeHitResultForTarget(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit TargetUnit, XComGameState_Ability AbilityState, bool bIsPrimaryTarget, const EAbilityHitResult CurrentResult, out EAbilityHitResult NewHitResult)
{
	local UnitValue ParryUnitValue;
	local int FocusLevel, Chance, RandRoll;
	local X2AbilityToHitCalc_StandardAim AttackToHit;

	//	don't respond to reaction fire
	AttackToHit = X2AbilityToHitCalc_StandardAim(AbilityState.GetMyTemplate().AbilityToHitCalc);
	if (AttackToHit != none && AttackToHit.bReactionFire)
		return false;

	//	don't change a natural miss
	if (!class'XComGameStateContext_Ability'.static.IsHitResultHit(CurrentResult))
		return false;

	if (!TargetUnit.IsAbleToAct())
		return false;

	`log("X2Effect_Deflect::ChangeHitResultForTarget", , 'XCom_HitRolls');
	//	check for parry first - if the unit value is set, then a parry is guaranteed, so do not check for deflect or reflect
	if (TargetUnit.HasSoldierAbility('Parry') && TargetUnit.GetUnitValue('Parry', ParryUnitValue))
	{
		if (ParryUnitValue.fValue > 0)
		{
			`log("Parry is available - not triggering deflect or reflect!", , 'XCom_HitRolls');
			return false;
		}		
	}

	//	only parry can block melee abilities, so only check non-melee abilities
	if (!AbilityState.IsMeleeAbility() && bIsPrimaryTarget)
	{
		FocusLevel = TargetUnit.GetTemplarFocusLevel();
		//	check reflect first, and if the roll fails, don't attempt to deflect
		if (TargetUnit.HasSoldierAbility('Reflect') && FocusLevel >= default.ReflectMinFocus)
		{
			Chance = default.ReflectBaseChance + ((FocusLevel - 1) * default.DeflectPerFocusChance);
			RandRoll = `SYNC_RAND(100);
			if (RandRoll <= Chance)
			{
				`log("Reflect chance was" @ Chance @ "rolled" @ RandRoll @ "- success!", , 'XCom_HitRolls');
				NewHitResult = eHit_Reflect;
				return true;
			}
			`log("Reflect chance was" @ Chance @ "rolled" @ RandRoll @ "- failed. Cannot Reflect or Deflect.", , 'XCom_HitRolls');
			return false;
		}
		`log("Unit does not have Reflect, or not enough Focus to trigger it.", , 'XCom_HitRolls');
		//	if reflect couldn't happen, check for deflect
		if (FocusLevel >= default.DeflectMinFocus)
		{
			Chance = default.DeflectBaseChance + ((FocusLevel - 1) * default.DeflectPerFocusChance);
			RandRoll = `SYNC_RAND(100);
			if (RandRoll <= Chance)
			{
				`log("Deflect chance was" @ Chance @ "rolled" @ RandRoll @ "- success!", , 'XCom_HitRolls');
				NewHitResult = eHit_Deflect;
				return true;
			}
			`log("Deflect chance was" @ Chance @ "rolled" @ RandRoll @ "- failed.", , 'XCom_HitRolls');
		}
		else
		{
			`log("Unit does not have enough focus for Deflect.", , 'XCom_HitRolls');
		}
	}
	else
	{
		`log("Ability is a melee attack or an AOE attack - cannot be Reflected or Deflected.", , 'XCom_HitRolls');
	}

	return false;
}

DefaultProperties
{
	DuplicateResponse = eDupe_Ignore
	EffectName = "Deflect"
}