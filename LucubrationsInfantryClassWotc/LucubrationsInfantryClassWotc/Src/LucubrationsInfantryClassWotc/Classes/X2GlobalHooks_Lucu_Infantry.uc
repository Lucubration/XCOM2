class X2GlobalHooks_Lucu_Infantry extends X2AmbientNarrativeCriteria;

static function array<X2DataTemplate> CreateTemplates()
{
	// This turns out to be a good hook for doing global template modification because subclasses of X2AmbientNarrativeCriteria
	// are the last ones loaded when the game is setting up. We'll just return an empty list of templates for template creation
	// (because we're not actually using this to create any templates) and put our template modifications in-between
	local array<X2DataTemplate> Templates;
	Templates.Length = 0;

	// Try to apply Light 'Em Up to all of the standard attacks from the base game, as well any new attacks in this mod
	ApplyLightEmUpToAbility('StandardShot');
	ApplyLightEmUpToAbility('HailOfBullets');
	ApplyLightEmUpToAbility('ChainShot');
	ApplyLightEmUpToAbility('BulletShred');
	ApplyLightEmUpToAbility('RapidFire');
	ApplyLightEmUpToAbility('SaturationFire');
	ApplyLightEmUpToAbility('Deadeye');
	ApplyLightEmUpToAbility('Lucu_Infantry_StaggeringShot');
	//ApplyLightEmUpToAbility('Lucu_Infantry_FireForEffect');

	return Templates;
}

static function ApplyLightEmUpToAbility(name abilityName)
{
	local X2AbilityTemplate AbilityTemplate;
	local X2AbilityCost_ActionPoints ActionPointCost;
	local bool UpdatedAbility;
	local int i;
	
	AbilityTemplate = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager().FindAbilityTemplate(abilityName);

	// Find the action point cost. It's not always the first item, so find it in the list
	for (i = 0; i < AbilityTemplate.AbilityCosts.Length; i++)
	{
		ActionPointCost = X2AbilityCost_ActionPoints(AbilityTemplate.AbilityCosts[i]);
		if (ActionPointCost != none)
			break;
	}

	if (ActionPointCost == none)
	{
		//`LOG("Lucubration Infantry Class: Failed to apply Light 'Em Up to ability template " @ string(abilityName) @ " (missing action point cost).");
		return;
	}

	// Determine if the ability's action point cost was already updated. This member of the X2AbilityCost_ActionPoints class
	// lists any abilities that will NOT consume action points as otherwise directed by the object
	UpdatedAbility = false;
	for (i = 0; i < ActionPointCost.DoNotConsumeAllSoldierAbilities.Length; i++)
	{
		if (ActionPointCost.DoNotConsumeAllSoldierAbilities[i] == 'Lucu_Infantry_LightEmUp')
		{
			UpdatedAbility = true;
			break;
		}
	}

	// Update the ability's action point cost if Light 'Em Up isn't listed
	if (!UpdatedAbility)
	{
		ActionPointCost.DoNotConsumeAllSoldierAbilities.AddItem('Lucu_Infantry_LightEmUp');
		`LOG("Lucubration Infantry Class: Applied Light 'Em Up to ability template " @ string(abilityName) @ ".");
	}
	else
	{
		//`LOG("Lucubration Infantry Class: Did not apply Light 'Em Up to ability template " @ string(abilityName) @ " (already applied).");
	}
}
