class X2Effect_Lucu_Infantry_ZoneOfControlCounterAttack extends X2Effect_Persistent;

function bool CanAbilityHitUnit(name AbilityName) 
{
	local int CounterAttackRoll;

	if (class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager().FindAbilityTemplate(AbilityName).IsMelee())
	{
		// Random roll out of 100
		CounterAttackRoll = `SYNC_RAND(100);

		`LOG("Lucubration Infantry Class: Zone of Control defense effect challenge for ability " @ AbilityName @ " (" @ string(CounterAttackRoll) @ " vs " @ string(class'X2Ability_Lucu_Infantry_InfantryAbilitySet'.default.ZoneOfControlCounterAttackChance) @ ").");

		// If the roll is greater than our chance of forcing the counterattack then the ability can hit (we don't force a miss)
		return CounterAttackRoll > class'X2Ability_Lucu_Infantry_InfantryAbilitySet'.default.ZoneOfControlCounterAttackChance;
	}

	return true;
}
