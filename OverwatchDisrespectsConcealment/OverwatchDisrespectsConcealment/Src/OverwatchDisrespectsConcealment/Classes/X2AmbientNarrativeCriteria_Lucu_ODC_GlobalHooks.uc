class X2AmbientNarrativeCriteria_Lucu_ODC_GlobalHooks extends X2AmbientNarrativeCriteria;

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

	// Try to apply Anti-Jake Solomon to all reaction fire abilities in the game
	foreach class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager().IterateTemplates(DataTemplate, none)
	{
		AbilityTemplate = X2AbilityTemplate(DataTemplate);
		if (AbilityTemplate != none)
		{
			StandardAim = X2AbilityToHitCalc_StandardAim(AbilityTemplate.AbilityToHitCalc);
			if (StandardAim != none && StandardAim.bReactionFire)
				ApplyAntiJakeSolomonToAbility(AbilityTemplate);
		}
	}

	return Templates;
}

static function ApplyAntiJakeSolomonToAbility(X2AbilityTemplate AbilityTemplate)
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

			`LOG("Lucubration Overwatch Disrespects Concealment: Applied Anti-Jake Solomon to ability template " @ string(AbilityTemplate.DataName) @ ".");
		}
	}
}
