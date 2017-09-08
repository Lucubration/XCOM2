class X2Effect_Unkillable extends X2Effect_Persistent;

function bool PreDeathCheck(XComGameState NewGameState, XComGameState_Unit UnitState, XComGameState_Effect EffectState)
{
	UnitState.SetCurrentStat(eStat_HP, 1);

	return true;
}

function bool PreBleedoutCheck(XComGameState NewGameState, XComGameState_Unit UnitState, XComGameState_Effect EffectState)
{
	return PreDeathCheck(NewGameState, UnitState, EffectState);
}

defaultproperties
{
	EffectName="UnkillableEffect"
	bInfiniteDuration=true
	bRemoveWhenSourceDies=false
	bIgnorePlayerCheckOnTick=true
}