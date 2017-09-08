class X2Effect_Nearsighted extends X2Effect_Persistent;

var float DmgMod;

function int GetDefendingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, X2Effect_ApplyWeaponDamage WeaponDamageEffect, optional XComGameState NewGameState)
{
	local GameRulesCache_VisibilityInfo VisInfo;

	if (X2AbilityToHitCalc_StandardAim(AbilityState.GetMyTemplate().AbilityToHitCalc) != none)
	{
		if (`TACTICALRULES.VisibilityMgr.GetVisibilityInfo(Attacker.ObjectID, XComGameState_Unit(TargetDamageable).ObjectID, VisInfo))
		{
			if (VisInfo.bClearLOS && !VisInfo.bVisibleGameplay)
			{
				return CurrentDamage * DmgMod;
			}
		}
	}

	return 0;
}

DefaultProperties
{
	EffectName = "ChosenNearsighted"
	DuplicateResponse = eDupe_Ignore
	bDisplayInSpecialDamageMessageUI = true
}