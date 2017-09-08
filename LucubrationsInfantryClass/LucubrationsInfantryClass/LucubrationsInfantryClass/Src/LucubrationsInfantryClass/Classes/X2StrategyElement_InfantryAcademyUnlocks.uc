class X2StrategyElement_InfantryAcademyUnlocks extends X2StrategyElement;

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

	`CREATE_X2TEMPLATE(class'X2SoldierAbilityUnlockTemplate', Template, 'SteadfastUnlock');

	//`LOG("Lucubration Infantry Class: Creating Steadfast perk unlock.");

	Template.AllowedClasses.AddItem('Infantry');
	Template.AbilityName = 'Steadfast';
	Template.strImage = "img:///UILibrary_InfantryClass.GTS.GTS_Infantry";
	
	// Requirements
	Template.Requirements.RequiredHighestSoldierRank = 5;
	Template.Requirements.RequiredSoldierClass = 'Infantry';
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

	`CREATE_X2TEMPLATE(class'X2SoldierAbilityUnlockTemplate', Template, 'ExtraConditioningUnlock');

	`LOG("Lucubration Infantry Class: Creating Extra Conditioning perk unlock.");

	Template.AllowedClasses.AddItem('Infantry');
	Template.AbilityName = 'ExtraConditioning';
	Template.strImage = "img:///UILibrary_InfantryClass.GTS.GTS_Infantry";
	
	// Requirements
	Template.Requirements.RequiredHighestSoldierRank = 5;
	Template.Requirements.RequiredSoldierClass = 'Infantry';
	Template.Requirements.RequiredSoldierRankClassCombo = true;
	Template.Requirements.bVisibleIfSoldierRankGatesNotMet = true;

	// Cost
	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = 75;
	Template.Cost.ResourceCosts.AddItem(Resources);

	return Template;
}
