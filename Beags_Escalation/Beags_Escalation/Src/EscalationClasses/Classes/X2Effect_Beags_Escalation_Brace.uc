// This effect is only applied to HMG users, so any firing performed with the HMG should include the applied aim penalty
class X2Effect_Beags_Escalation_Brace extends X2Effect_Persistent;

var int AimModifier;

function GetToHitModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
	local ShotModifierInfo ShotInfo;

	if (!bMelee)
	{
		ShotInfo.ModType = eHit_Success;
		ShotInfo.Reason = FriendlyName;
		ShotInfo.Value = AimModifier;
		ShotModifiers.AddItem(ShotInfo);
	}
}

function bool PostAbilityCostPaid(XComGameState_Effect EffectState, XComGameStateContext_Ability AbilityContext, XComGameState_Ability kAbility, XComGameState_Unit SourceUnit, XComGameState_Item AffectWeapon, XComGameState NewGameState, const array<name> PreCostActionPoints, const array<name> PreCostReservePoints)
{
	if (AbilityContext.InputContext.MovementPaths[0].MovementTiles.Length > 0)
	{
		// If the unit moved for any reason, remove this effect
		EffectState.RemoveEffect(NewGameState, NewGameState);
	}

	return false;
}
