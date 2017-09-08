class X2Effect_Lucu_Sniper_SniperTraining extends X2Effect_Persistent;

var int AimPenalty;

function GetToHitModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
	local ShotModifierInfo AccuracyInfo;
	local UnitValue Value;

	if ((Attacker.GetUnitValue('MovesThisTurn', Value) && Value.fValue > 0) ||
		(Attacker.GetUnitValue('AttacksThisTurn', Value) && Value.fValue > 0))
	{
		if (AbilityState.SourceWeapon == EffectState.ApplyEffectParameters.ItemStateObjectRef)
		{
			AccuracyInfo.ModType = eHit_Success;
			AccuracyInfo.Value = AimPenalty;
			AccuracyInfo.Reason = FriendlyName;
			ShotModifiers.AddItem(AccuracyInfo);
		}
	}
}
