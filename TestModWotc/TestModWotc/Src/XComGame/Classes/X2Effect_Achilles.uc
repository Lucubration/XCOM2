class X2Effect_Achilles extends X2Effect_Persistent;

var int ToHitMin;
var float DmgMod;

function int GetDefendingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, X2Effect_ApplyWeaponDamage WeaponDamageEffect, optional XComGameState NewGameState)
{
	local X2AbilityToHitCalc_StandardAim Aim;
	local AvailableTarget kTarget;
	local ShotBreakdown kBreakdown;

	Aim = X2AbilityToHitCalc_StandardAim(AbilityState.GetMyTemplate().AbilityToHitCalc);
	if (Aim != none && !Aim.bIndirectFire && !Aim.bMultiTargetOnly)
	{
		kTarget.PrimaryTarget = XComGameState_BaseObject(TargetDamageable).GetReference();
		if (AbilityState.GetShotBreakdown(kTarget, kBreakdown) >= ToHitMin)
			return CurrentDamage * DmgMod;
	}

	return 0;
}