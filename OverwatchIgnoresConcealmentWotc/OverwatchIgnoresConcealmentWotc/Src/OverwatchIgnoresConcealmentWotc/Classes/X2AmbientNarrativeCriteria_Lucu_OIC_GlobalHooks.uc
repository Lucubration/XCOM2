class X2AmbientNarrativeCriteria_Lucu_OIC_GlobalHooks extends X2AmbientNarrativeCriteria;

static function array<X2DataTemplate> CreateTemplates()
{
	// This turns out to be a good hook for doing global template modification because subclasses of X2AmbientNarrativeCriteria
	// are the last ones loaded when the game is setting up. We'll just return an empty list of templates for template creation
	// (because we're not actually using this to create any templates) and put our template modifications in-between
	local X2DataTemplate DataTemplate;
	local X2AbilityTemplate AbilityTemplate;
	local X2AbilityToHitCalc_StandardAim StandardAim;
	local array<X2DataTemplate> Templates;
	Templates.Length = 0;

	// Try to apply Xcom 1 reaction fire rules to all reaction fire abilities in the game
	foreach class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager().IterateTemplates(DataTemplate, none)
	{
		AbilityTemplate = X2AbilityTemplate(DataTemplate);
		if (AbilityTemplate != none)
		{
			StandardAim = X2AbilityToHitCalc_StandardAim(AbilityTemplate.AbilityToHitCalc);
			// We can do a quick check to see if this is an Overwatch *shot* to pre-filter here
			if (StandardAim != none && StandardAim.bReactionFire)
				ApplyIgnoreConcealmentFiringRulesToAbility(AbilityTemplate);

			// We can't do a quick check to see if this is an Overwatch ability, so just look for the concealed effect on every
			// ability and adjust it where we find it
			ApplyIgnoreConcealmentAimingRulesToAbility(AbilityTemplate);
		}
	}

	return Templates;
}

static function ApplyIgnoreConcealmentFiringRulesToAbility(X2AbilityTemplate AbilityTemplate)
{
	local X2Condition_UnitProperty ShooterCondition;
	local int i;
	
	// Look for any unit conditions which 'ExcludeConcealed'. Undo that
	for (i = 0; i < AbilityTemplate.AbilityShooterConditions.Length; i++)
	{
		ShooterCondition = X2Condition_UnitProperty(AbilityTemplate.AbilityShooterConditions[i]);
		if (ShooterCondition.ExcludeConcealed)
		{
			ShooterCondition.ExcludeConcealed = false;

			`LOG("Lucubration Overwatch Ignores Concealment: Applied concealment firing ignore to ability template " @ string(AbilityTemplate.DataName) @ ".");
		}
	}
}

static function ApplyIgnoreConcealmentAimingRulesToAbility(X2AbilityTemplate AbilityTemplate)
{
	local X2Effect_SetUnitValue TargetEffect;
	local int i;

	// Look for target effects that set the unit value 'ConcealedOverwatch'. Apply a new condition that always fails
	for (i = 0; i < AbilityTemplate.AbilityTargetEffects.Length; i++)
	{
		TargetEffect = X2Effect_SetUnitValue(AbilityTemplate.AbilityTargetEffects[i]);
		if (TargetEffect != none)
		{
			if (TargetEffect.UnitName == class'X2Ability_DefaultAbilitySet'.default.ConcealedOverwatchTurn)
			{
				TargetEffect.TargetConditions.AddItem(new class'X2Condition_Lucu_OIC_False');

				`LOG("Lucubration Overwatch Ignores Concealment: Applied concealment aiming ignore to ability template " @ string(AbilityTemplate.DataName) @ ".");
			}
		}
	}
}