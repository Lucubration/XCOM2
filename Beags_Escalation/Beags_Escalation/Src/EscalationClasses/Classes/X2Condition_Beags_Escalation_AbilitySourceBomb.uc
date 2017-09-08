class X2Condition_Beags_Escalation_AbilitySourceBomb extends X2Condition;

var name MatchBombType;

event name CallAbilityMeetsCondition(XComGameState_Ability kAbility, XComGameState_BaseObject kTarget)
{
	local XComGameState_Item SourceWeapon;
	local X2BombTemplate_Beags_Escalation BombTemplate;

	SourceWeapon = kAbility.GetSourceWeapon();
	if (SourceWeapon != none)
	{
		if (MatchBombType != '')
		{
			BombTemplate = X2BombTemplate_Beags_Escalation(SourceWeapon.GetMyTemplate());
			if (BombTemplate == none)
				BombTemplate = X2BombTemplate_Beags_Escalation(SourceWeapon.GetLoadedAmmoTemplate(kAbility));
			if (BombTemplate == none || BombTemplate.DataName != MatchBombType)
				return 'AA_WeaponIncompatible';
		}
	}
	return 'AA_Success';
}