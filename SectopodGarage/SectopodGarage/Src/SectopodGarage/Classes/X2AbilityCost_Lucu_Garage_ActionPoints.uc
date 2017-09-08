class X2AbilityCost_Lucu_Garage_ActionPoints extends X2AbilityCost_ActionPoints;

var array<name> FreeCostEffects;
var array<name> FreeCostSoldierAbilities;

simulated function ApplyCost(XComGameStateContext_Ability AbilityContext, XComGameState_Ability kAbility, XComGameState_BaseObject AffectState, XComGameState_Item AffectWeapon, XComGameState NewGameState)
{
	local XComGameState_Unit AbilityOwner;
	local int i;
	
	AbilityOwner = XComGameState_Unit(AffectState);

	for (i = 0; i < FreeCostEffects.Length; i++)
	{
		if (AbilityOwner.IsUnitAffectedByEffectName(FreeCostEffects[i]))
			return;
	}
	for (i = 0; i < FreeCostSoldierAbilities.Length; i++)
	{
		if (AbilityOwner.HasSoldierAbility(FreeCostSoldierAbilities[i]))
			return;
	}

	super.ApplyCost(AbilityContext, kAbility, AffectState, AffectWeapon, NewGameState);
}
