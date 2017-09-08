class X2Condition_Beags_Escalation_UnitHasAbility extends X2Condition;

var name MatchAbilityTemplateName;

event name CallAbilityMeetsCondition(XComGameState_Ability kAbility, XComGameState_BaseObject kTarget)
{
	local XComGameState_Unit UnitState;

	UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(kAbility.OwnerStateObject.ObjectID));
	if (UnitState == none)
		return 'AA_AbilityUnavailable';

	if (MatchAbilityTemplateName != '')
	{
		if (!UnitHasAbilityTemplate(UnitState))
			return 'AA_AbilityUnavailable';
	}

	return 'AA_Success';
}

event bool UnitHasAbilityTemplate(XComGameState_Unit UnitState)
{
	local X2CharacterTemplate				CharacterTemplate;
	local XComGameState_Player				PlayerState;
	local name								AbilityName, UnlockName;
	local array<SoldierClassAbilityType>	EarnedSoldierAbilities;
	local X2SoldierAbilityUnlockTemplate	AbilityUnlockTemplate;
	local int								i;
	
	CharacterTemplate = UnitState.GetMyTemplate();
	PlayerState = XComGameState_Player(`XCOMHISTORY.GetGameStateForObjectID(UnitState.ControllingPlayer.ObjectID));

	// Gather default abilities if allowed
	if (!CharacterTemplate.bSkipDefaultAbilities)
	{
		foreach class'X2Ability_DefaultAbilitySet'.default.DefaultAbilitySet(AbilityName)
		{
			if (AbilityName == MatchAbilityTemplateName)
				return true;
		}
	}
	// Gather character specific abilities
	foreach CharacterTemplate.Abilities(AbilityName)
	{
		if (AbilityName == MatchAbilityTemplateName)
			return true;
	}
	// Gather soldier class abilities
	EarnedSoldierAbilities = UnitState.GetEarnedSoldierAbilities();
	for (i = 0; i < EarnedSoldierAbilities.Length; ++i)
	{
		AbilityName = EarnedSoldierAbilities[i].AbilityName;
		if (AbilityName == MatchAbilityTemplateName)
			return true;
	}
	// Add abilities based on the player state
	if (PlayerState != none && PlayerState.IsAIPlayer())
	{
		foreach class'X2Ability_AlertMechanics'.default.AlertAbilitySet(AbilityName)
		{
			if (AbilityName == MatchAbilityTemplateName)
				return true;
		}
	}
	if (PlayerState != none && PlayerState.SoldierUnlockTemplates.Length > 0)
	{
		foreach PlayerState.SoldierUnlockTemplates(UnlockName)
		{
			AbilityUnlockTemplate = X2SoldierAbilityUnlockTemplate(class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager().FindStrategyElementTemplate(UnlockName));
			if (AbilityUnlockTemplate == none)
				continue;
			if (!AbilityUnlockTemplate.UnlockAppliesToUnit(UnitState))
				continue;

			if (AbilityUnlockTemplate.AbilityName == MatchAbilityTemplateName)
				return true;
		}
	}

	if (UnitState.bIsShaken && MatchAbilityTemplateName == 'ShakenPassive')
		return true;

	return UnitState.FindAbility(MatchAbilityTemplateName).ObjectID != 0;
}