class X2AbilityCooldown_Rend extends X2AbilityCooldown;

simulated function int GetNumTurns(XComGameState_Ability kAbility, XComGameState_BaseObject AffectState, XComGameState_Item AffectWeapon, XComGameState NewGameState)
{
	local XComGameState_Unit OwnerUnit;
	local int FocusLevel;

	OwnerUnit = XComGameState_Unit(NewGameState.GetGameStateForObjectID(kAbility.OwnerStateObject.ObjectID));
	if (OwnerUnit == none)
		OwnerUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(kAbility.OwnerStateObject.ObjectID));

	FocusLevel = OwnerUnit.GetTemplarFocusLevel();

	if (FocusLevel == 1)
		return iNumTurns - 1;
	if (FocusLevel > 1)
		return 0;

	return iNumTurns;
}

DefaultProperties
{
	iNumTurns = 3;
}