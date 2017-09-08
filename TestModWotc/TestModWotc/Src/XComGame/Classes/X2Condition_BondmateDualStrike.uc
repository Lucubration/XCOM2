class X2Condition_BondmateDualStrike extends X2Condition;

event name CallMeetsConditionWithSource(XComGameState_BaseObject kTarget, XComGameState_BaseObject kSource)
{ 
	local XComGameState_Unit SourceUnit, BondUnit;
	local SoldierBond BondData;
	local StateObjectReference BondRef;
	local GameRulesCache_VisibilityInfo VisInfo;
	local XComGameState_Ability BondAbility;
	local XComGameStateHistory History;

	SourceUnit = XComGameState_Unit(kSource);
	if (SourceUnit == none)
		return 'AA_NotAUnit';

	if (!SourceUnit.HasSoldierBond(BondRef, BondData))
		return 'AA_NotABondmate';

	if (BondData.BondLevel < 3)
		return 'AA_WrongBondLevel';

	History = `XCOMHISTORY;
	BondUnit = XComGameState_Unit(History.GetGameStateForObjectID(BondRef.ObjectID));
	if (!BondUnit.IsAbleToAct())
		return 'AA_NotABondmate';

	if (!`TACTICALRULES.VisibilityMgr.GetVisibilityInfo(BondUnit.ObjectID, kTarget.ObjectID, VisInfo))
		return 'AA_NotVisible';

	if (!VisInfo.bVisibleGameplay)
		return 'AA_NotVisible';

	BondAbility = XComGameState_Ability(History.GetGameStateForObjectID(BondUnit.FindAbility('BondmateDualStrikeFollowup').ObjectID));
	if (BondAbility == none)
		return 'AA_AbilityUnavailable';

	if (BondAbility.CanActivateAbility(BondUnit) != 'AA_Success')
		return 'AA_AbilityUnavailable';

	return 'AA_Success'; 
}