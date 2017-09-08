class X2Effect_Lucu_Sniper_Sharpshooter extends X2Effect_Persistent;

var float HitModRoot;

function GetToHitModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
	local GameRulesCache_VisibilityInfo VisInfo;
	local ShotModifierInfo AccuracyInfo;

	if (Attacker != none && Target != none)
	{
		if (!bIndirectFire)
		{
			if (`TACTICALRULES.VisibilityMgr.GetVisibilityInfo(Attacker.ObjectID, Target.ObjectID, VisInfo))
			{	
				if (Target.CanTakeCover())
				{
					if (VisInfo.TargetCover == CT_Standing)
					{
						AccuracyInfo.ModType = eHit_Success;
						AccuracyInfo.Value = GetHighToLowCoverAimDifference();
						AccuracyInfo.Reason = FriendlyName;
						ShotModifiers.AddItem(AccuracyInfo);
					}
				}
			}
		}
	}
}

function int GetHighToLowCoverAimDifference()
{
	return class'X2AbilityToHitCalc_StandardAim'.default.HIGH_COVER_BONUS - class'X2AbilityToHitCalc_StandardAim'.default.LOW_COVER_BONUS;
}
