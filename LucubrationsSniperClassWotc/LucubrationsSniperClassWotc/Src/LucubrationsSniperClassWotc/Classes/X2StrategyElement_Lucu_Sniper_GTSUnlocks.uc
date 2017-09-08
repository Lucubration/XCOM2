class X2StrategyElement_Lucu_Sniper_GTSUnlocks extends X2StrategyElement;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;
		
	Templates.AddItem(BallisticsExpertUnlock());

	return Templates;
}

static function X2SoldierAbilityUnlockTemplate BallisticsExpertUnlock()
{
	local X2SoldierAbilityUnlockTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2SoldierAbilityUnlockTemplate', Template, 'Lucu_Sniper_BallisticsExpertUnlock');

	`LOG("Lucubration Sniper Class: Creating Ballistics Expert perk unlock.");

	Template.AllowedClasses.AddItem('Lucu_Sniper');
	Template.AbilityName = 'Lucu_Sniper_BallisticsExpert';
	Template.strImage = "img:///UILibrary_Lucu_Sniper_Icons.GTS.GTS_Sniper";
	
	// Requirements
	Template.Requirements.RequiredHighestSoldierRank = 5;
	Template.Requirements.RequiredSoldierClass = 'Lucu_Sniper';
	Template.Requirements.RequiredSoldierRankClassCombo = true;
	Template.Requirements.bVisibleIfSoldierRankGatesNotMet = true;

	// Cost
	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = 75;
	Template.Cost.ResourceCosts.AddItem(Resources);

	return Template;
}
