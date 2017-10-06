class X2StrategyElement_Lucu_CombatEngineer_AcademyUnlocks extends X2StrategyElement;

var name AcceptableTolerancesUnlockName;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;
		
	Templates.AddItem(AcceptableTolerancesUnlock());

	return Templates;
}

static function X2SoldierAbilityUnlockTemplate AcceptableTolerancesUnlock()
{
	local X2SoldierAbilityUnlockTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2SoldierAbilityUnlockTemplate', Template, default.AcceptableTolerancesUnlockName);

	`LOG("Lucubration Combat Engineer Class: Creating Acceptable Tolerances perk unlock.");

	Template.AllowedClasses.AddItem('Lucu_CombatEngineer');
	Template.AbilityName = class'X2Ability_Lucu_CombatEngineer_CombatEngineerAbilitySet'.default.AcceptableTolerancesAbilityTemplateName;
	Template.strImage = "img:///UILibrary_CombatEngineerClass.GTS.GTS_CombatEngineer";
	
	// Requirements
	Template.Requirements.RequiredHighestSoldierRank = 5;
	Template.Requirements.RequiredSoldierClass = 'Lucu_CombatEngineer';
	Template.Requirements.RequiredSoldierRankClassCombo = true;
	Template.Requirements.bVisibleIfSoldierRankGatesNotMet = true;

	// Cost
	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = 75;
	Template.Cost.ResourceCosts.AddItem(Resources);

	return Template;
}

DefaultProperties
{
    AcceptableTolerancesUnlockName="Lucu_CombatEngineer_AcceptableTolerancesUnlock"
}