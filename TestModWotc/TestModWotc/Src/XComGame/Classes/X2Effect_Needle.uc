class X2Effect_Needle extends X2Effect_Persistent;

var int ArmorPierce;

function int GetExtraArmorPiercing(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData)
{
	if (Attacker.IsSuperConcealed() && AbilityState.GetSourceWeapon() != none && class'XComGameStateContext_Ability'.static.IsHitResultHit(AppliedData.AbilityResultContext.HitResult))
	{
		if (AbilityState.GetSourceWeapon().ObjectID == Attacker.GetItemInSlot(eInvSlot_PrimaryWeapon).ObjectID)
		{
			return ArmorPierce;
		}
	}
	return 0;
}

DefaultProperties
{
	DuplicateResponse = eDupe_Ignore
	EffectName = "Needle"
}
