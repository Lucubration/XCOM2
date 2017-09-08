class X2Effect_Bewildered extends X2Effect_Persistent;

var float DmgMod;
var int NumHitsForMod;

function int GetDefendingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, X2Effect_ApplyWeaponDamage WeaponDamageEffect, optional XComGameState NewGameState)
{
	local XComGameState_Unit UnitState;
	local UnitValue HitsTakenThisTurn;

	UnitState = XComGameState_Unit(TargetDamageable);
	if (UnitState.GetUnitValue('HitsTakenThisTurn', HitsTakenThisTurn) && CurrentDamage > 0 && class'XComGameStateContext_Ability'.static.IsHitResultHit(AppliedData.AbilityResultContext.HitResult))
	{
		if (HitsTakenThisTurn.fValue >= NumHitsForMod - 1)		//	- 1 because HitsTakenThisTurn won't increment until this damage has already resolved
		{
			return CurrentDamage * DmgMod;
		}
	}
	return 0;
}

DefaultProperties
{
	bDisplayInSpecialDamageMessageUI = true
}