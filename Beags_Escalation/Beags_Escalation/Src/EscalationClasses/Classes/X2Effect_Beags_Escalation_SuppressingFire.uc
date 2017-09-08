class X2Effect_Beags_Escalation_SuppressingFire extends X2Effect_Persistent;

function GetToHitModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
	local ShotModifierInfo AccuracyInfo;

	AccuracyInfo.ModType = eHit_Success;
	AccuracyInfo.Value = class'X2Ability_Beags_Escalation_GunnerAbilitySet'.default.SuppressingFireAimPenalty;
	AccuracyInfo.Reason = FriendlyName;
	ShotModifiers.AddItem(AccuracyInfo);
}
