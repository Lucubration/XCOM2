class X2Effect_Impatient extends X2Effect_Persistent;

var float DmgMod;

function int GetDefendingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, X2Effect_ApplyWeaponDamage WeaponDamageEffect, optional XComGameState NewGameState) 
{ 
	local X2AbilityToHitCalc_StandardAim StandardHit;

	StandardHit = X2AbilityToHitCalc_StandardAim(AbilityState.GetMyTemplate().AbilityToHitCalc);
	if (StandardHit != none && StandardHit.bReactionFire)
	{
		return CurrentDamage * DmgMod;
	}

	return 0; 
}