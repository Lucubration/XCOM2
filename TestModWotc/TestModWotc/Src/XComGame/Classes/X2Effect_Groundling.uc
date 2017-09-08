class X2Effect_Groundling extends X2Effect_Persistent;

var int HeightBonus;		//	amount of additional aim attacker will receive when they have height advantage over the unit with this effect

function GetToHitAsTargetModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
	local ShotModifierInfo ShotInfo;

	if (!bMelee && Attacker.HasHeightAdvantageOver(Target, true))
	{
		ShotInfo.ModType = eHit_Success;
		ShotInfo.Value = HeightBonus;
		ShotInfo.Reason = FriendlyName;
		ShotModifiers.AddItem(ShotInfo);
	}
}