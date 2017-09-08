class X2AbilityMultiTarget_Beags_Escalation_ItemRadius extends X2AbilityMultiTarget_SoldierBonusRadius;

var array<name> SoldierAbilityNames;
var array<float> BonusRadii;

/**
 * GetTargetRadius
 * @return Unreal units for radius of targets
 */
simulated function float GetTargetRadius(const XComGameState_Ability Ability)
{
	local XComGameStateHistory History;
	local XComGameState_Unit Unit;
	local name FoundSoldierAbilityName;
	local float FoundBonusRadius;
	local int i;

	History = `XCOMHISTORY;

	FoundBonusRadius = 0.0f;

	// Check if the soldier has any of the listed abilities. If so, apply bonus radius
	Unit = XComGameState_Unit(History.GetGameStateForObjectID(Ability.OwnerStateObject.ObjectID));
	for (i = 0; i < SoldierAbilityNames.Length && i < BonusRadii.Length; i++)
	{
		if (Unit.FindAbility(SoldierAbilityNames[i]).ObjectID != 0)
		{
			FoundSoldierAbilityName = SoldierAbilityNames[i]; // We just need the name of any one ability that the soldier has that grants bonus radius
			FoundBonusRadius += BonusRadii[i]; // Accumulate all bonus radius for abilites that the soldier has that grant bonus radius
		}
	}

	// Replace the superclass values for bonus radius
	SoldierAbilityName = FoundSoldierAbilityName;
	BonusRadius = FoundBonusRadius;

	return super.GetTargetRadius(Ability);
}
