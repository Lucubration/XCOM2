class X2StrategyElement_Lucu_Infantry_AcademyUnlocks extends X2StrategyElement;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;
		
	//Templates.AddItem(SteadfastUnlock());
	Templates.AddItem(ExtraConditioningUnlock());

	return Templates;
}

static function X2SoldierAbilityUnlockTemplate SteadfastUnlock()
{
	local X2SoldierAbilityUnlockTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2SoldierAbilityUnlockTemplate', Template, 'Lucu_Infantry_SteadfastUnlock');

	//`LOG("Lucubration Infantry Class: Creating Steadfast perk unlock.");

	Template.AllowedClasses.AddItem('Lucu_Infantry');
	Template.AbilityName = 'Lucu_Infantry_Steadfast';
	Template.strImage = "img:///UILibrary_InfantryClass.GTS.GTS_Infantry";
	
	// Requirements
	Template.Requirements.RequiredHighestSoldierRank = 5;
	Template.Requirements.RequiredSoldierClass = 'Lucu_Infantry';
	Template.Requirements.RequiredSoldierRankClassCombo = true;
	Template.Requirements.bVisibleIfSoldierRankGatesNotMet = true;

	// Cost
	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = 75;
	Template.Cost.ResourceCosts.AddItem(Resources);

	return Template;
}

static function X2SoldierAbilityUnlockTemplate ExtraConditioningUnlock()
{
	local X2SoldierAbilityUnlockTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2SoldierAbilityUnlockTemplate', Template, 'Lucu_Infantry_ExtraConditioningUnlock');

	`LOG("Lucubration Infantry Class: Creating Extra Conditioning perk unlock.");

	Template.AllowedClasses.AddItem('Lucu_Infantry');
	Template.AbilityName = 'Lucu_Infantry_ExtraConditioning';
	Template.strImage = "img:///UILibrary_InfantryClass.GTS.GTS_Infantry";
	
	// Requirements
	Template.Requirements.RequiredHighestSoldierRank = 5;
	Template.Requirements.RequiredSoldierClass = 'Lucu_Infantry';
	Template.Requirements.RequiredSoldierRankClassCombo = true;
	Template.Requirements.bVisibleIfSoldierRankGatesNotMet = true;

	// Cost
	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = 75;
	Template.Cost.ResourceCosts.AddItem(Resources);

	return Template;
}
