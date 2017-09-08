class X2Effect_Illuminated extends X2Effect_Persistent
	config(LucubrationsInfantryClass);

var config int DefensePenalty;

function GetToHitAsTargetModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
	local ShotModifierInfo AccuracyInfo;

	AccuracyInfo.ModType = eHit_Success;
	AccuracyInfo.Value = -1 * default.DefensePenalty;
	AccuracyInfo.Reason = FriendlyName;
	ShotModifiers.AddItem(AccuracyInfo);
}