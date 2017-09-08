class X2Effect_Beags_Escalation_Executioner extends X2Effect_Persistent
	config(Beags_Escalation_Ability);

function GetToHitModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
	local ShotModifierInfo ModInfo;

	if (Target.GetCurrentStat(eStat_HP) <= (Target.GetMaxStat(eStat_HP) / 2))
	{
		ModInfo.ModType = eHit_Success;
		ModInfo.Reason = FriendlyName;
		ModInfo.Value = class'X2Ability_Beags_Escalation_CommonAbilitySet'.default.ExecutionerHitBonus;
		ShotModifiers.AddItem(ModInfo);

		ModInfo.ModType = eHit_Crit;
		ModInfo.Reason = FriendlyName;
		ModInfo.Value = class'X2Ability_Beags_Escalation_CommonAbilitySet'.default.ExecutionerCritBonus;
		ShotModifiers.AddItem(ModInfo);
	}
}