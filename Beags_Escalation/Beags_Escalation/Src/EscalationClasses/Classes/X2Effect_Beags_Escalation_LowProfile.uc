class X2Effect_Beags_Escalation_LowProfile extends X2Effect_LowProfile;

function GetToHitAsTargetModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
	local GameRulesCache_VisibilityInfo VisInfo;
	local ShotModifierInfo ShotMod;

	if (!bIndirectFire)
	{
		if (`TACTICALRULES.VisibilityMgr.GetVisibilityInfo(Attacker.ObjectID, Target.ObjectID, VisInfo))
		{
			if (VisInfo.TargetCover == CT_MidLevel)
			{
				ShotMod.ModType = eHit_Success;
				ShotMod.Value = class'X2AbilityToHitCalc_StandardAim'.default.LOW_COVER_BONUS - class'X2AbilityToHitCalc_StandardAim'.default.HIGH_COVER_BONUS;
				ShotMod.Reason = FriendlyName;
				ShotModifiers.AddItem(ShotMod);
			}
		}
	}	
}