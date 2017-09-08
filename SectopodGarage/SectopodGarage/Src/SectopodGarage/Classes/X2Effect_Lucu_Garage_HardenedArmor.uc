class X2Effect_Lucu_Garage_HardenedArmor extends X2Effect_Persistent;

var int CritModifier;

function GetToHitAsTargetModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
	local float ArmorMitigation;
	local ShotModifierInfo ShotMod;

	ArmorMitigation = Target.GetArmorMitigationForUnitFlag();
	if (ArmorMitigation > 0)
	{
		ShotMod.ModType = eHit_Crit;
		ShotMod.Value = ArmorMitigation * CritModifier;
		ShotMod.Reason = FriendlyName;
		ShotModifiers.AddItem(ShotMod);
	}
}
