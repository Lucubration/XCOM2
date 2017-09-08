class X2AmbientNarrativeCriteria_Beags_Escalation_TemplateModificator extends X2AmbientNarrativeCriteria;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;
	local X2DataTemplate DataTemplate;
	local X2AbilityTemplate AbilityTemplate;

	// This turns out to be a good hook for doing global template modification because subclasses of X2AmbientNarrativeCriteria
	// are the last ones loaded when the game is setting up. We'll just return an empty list of templates for template creation
	// (because we're not actually using this to create any templates) and put our template modifications in-between
	Templates.Length = 0;

	foreach class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager().IterateTemplates(DataTemplate, none)
	{
		AbilityTemplate = X2AbilityTemplate(DataTemplate);
		if (AbilityTemplate != none)
		{
			// For every single ability template with a multi-target style, we're going to try to modify the vanilla targeting style
			// X2AbilityMultiTarget_SoldierBonusRadius to our own X2AbilityMultiTarget_Beags_Escalation_ItemRadius, if appropriate, so
			// that we can double-up on increasing the radius of explosive effects with our own perks
			if (AbilityTemplate.AbilityMultiTargetStyle != none)
				TryModifyBonusRadiusAbility(AbilityTemplate);

			// For every single ability template in the DoubleTapAbilities array, modify the ability template's action point cost to
			// allow the Double Tap action point type
			if (class'X2Ability_Beags_Escalation_CommonAbilitySet'.static.IsDoubleTapAbility(AbilityTemplate.DataName))
				TryModifyDoubleTapAbility(AbilityTemplate);
		}
	}

	return Templates;
}

static function TryModifyBonusRadiusAbility(X2AbilityTemplate Template)
{
	local X2AbilityMultiTarget_SoldierBonusRadius OldRadiusMultiTarget;
	local X2AbilityMultiTarget_Beags_Escalation_ItemRadius NewRadiusMultiTarget;

	OldRadiusMultiTarget = X2AbilityMultiTarget_SoldierBonusRadius(Template.AbilityMultiTargetStyle);

	if (OldRadiusMultiTarget != none)
	{
		NewRadiusMultiTarget = new class'X2AbilityMultiTarget_Beags_Escalation_ItemRadius';
		NewRadiusMultiTarget.bUseWeaponRadius = OldRadiusMultiTarget.bUseWeaponRadius;
		NewRadiusMultiTarget.bIgnoreBlockingCover = OldRadiusMultiTarget.bIgnoreBlockingCover;
		NewRadiusMultiTarget.fTargetRadius = OldRadiusMultiTarget.fTargetRadius;
		NewRadiusMultiTarget.fTargetCoveragePercentage = OldRadiusMultiTarget.fTargetCoveragePercentage;
		NewRadiusMultiTarget.bAddPrimaryTargetAsMultiTarget = OldRadiusMultiTarget.bAddPrimaryTargetAsMultiTarget;
		NewRadiusMultiTarget.bAllowDeadMultiTargetUnits = OldRadiusMultiTarget.bAllowDeadMultiTargetUnits;
		NewRadiusMultiTarget.bExcludeSelfAsTargetIfWithinRadius = OldRadiusMultiTarget.bExcludeSelfAsTargetIfWithinRadius;
		NewRadiusMultiTarget.SoldierAbilityNames.AddItem(OldRadiusMultiTarget.SoldierAbilityName);
		NewRadiusMultiTarget.SoldierAbilityNames.AddItem(class'X2Ability_Beags_Escalation_CommonAbilitySet'.default.DangerZoneAbilityName);
		NewRadiusMultiTarget.BonusRadii.AddItem(OldRadiusMultiTarget.BonusRadius);
		NewRadiusMultiTarget.BonusRadii.AddItem(`UNITSTOTILES(class'X2Ability_Beags_Escalation_CommonAbilitySet'.default.DangerZoneExplosiveRadiusBonus));
		Template.AbilityMultiTargetStyle = NewRadiusMultiTarget;
		
		`LOG("Beags Escalation: Updated ability template " @ Template.DataName @ " with Danger Zone targeting style.");
	}
}

static function TryModifyDoubleTapAbility(X2AbilityTemplate Template)
{
	local X2AbilityCost_ActionPoints ActionPointCost;
	local int i;

	// Find the action point cost. It's not always the first item, so find it in the list
	for (i = 0; i < Template.AbilityCosts.Length; i++)
	{
		ActionPointCost = X2AbilityCost_ActionPoints(Template.AbilityCosts[i]);
		if (ActionPointCost == none)
			continue;

		// Check for the Double Tap action point type; if not allowed, add it as an allowed type
		if (ActionPointCost.AllowedTypes.Find(class'X2Ability_Beags_Escalation_CommonAbilitySet'.default.DoubleTapActionPointName) == INDEX_NONE)
		{
			ActionPointCost.AllowedTypes.AddItem(class'X2Ability_Beags_Escalation_CommonAbilitySet'.default.DoubleTapActionPointName);

			`LOG("Beags Escalation: Ability Template " @ Template.DataName @ " updated to allow Double Tap.");
		}
	}
}
