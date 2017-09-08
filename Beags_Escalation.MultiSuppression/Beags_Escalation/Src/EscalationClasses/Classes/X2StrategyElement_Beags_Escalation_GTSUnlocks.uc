class X2StrategyElement_Beags_Escalation_GTSUnlocks extends X2StrategyElement;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;
		
	Templates.AddItem(ReconUnlock());
	Templates.AddItem(LowProfileUnlock());
	Templates.AddItem(WeaponsTeamUnlock());
	Templates.AddItem(RocketSnapshotUnlock());

	return Templates;
}

//---------------------------------------------------------------------------------------------------
// Scout Unlocks
//---------------------------------------------------------------------------------------------------


static function X2SoldierAbilityUnlockTemplate ReconUnlock()
{
	local X2SoldierAbilityUnlockTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2SoldierAbilityUnlockTemplate', Template, 'Beags_Escalation_Recon_Unlock');

	`LOG("Beags Escalation: Creating Recon perk unlock.");

	Template.bAllClasses = true;
	Template.AbilityName = 'Beags_Escalation_Recon';
	Template.strImage = "img:///UILibrary_Beags_Escalation_Icons.GTS.GTS_ScoutSGT";
	
	// Requirements
	Template.Requirements.RequiredHighestSoldierRank = 4;
	Template.Requirements.RequiredSoldierClass = 'Beags_Escalation_Scout';
	Template.Requirements.RequiredSoldierRankClassCombo = true;
	Template.Requirements.bVisibleIfSoldierRankGatesNotMet = true;

	// Cost
	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = 75;
	Template.Cost.ResourceCosts.AddItem(Resources);

	return Template;
}

static function X2SoldierAbilityUnlockTemplate LowProfileUnlock()
{
	local X2SoldierAbilityUnlockTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2SoldierAbilityUnlockTemplate', Template, 'Beags_Escalation_LowProfile_Unlock');

	`LOG("Beags Escalation: Creating Low Profile perk unlock.");

	Template.AllowedClasses.AddItem('Beags_Escalation_Scout');
	Template.AbilityName = 'Beags_Escalation_LowProfile';
	Template.strImage = "img:///UILibrary_Beags_Escalation_Icons.GTS.GTS_Scout";
	
	// Requirements
	Template.Requirements.RequiredHighestSoldierRank = 5;
	Template.Requirements.RequiredSoldierClass = 'Beags_Escalation_Scout';
	Template.Requirements.RequiredSoldierRankClassCombo = true;
	Template.Requirements.bVisibleIfSoldierRankGatesNotMet = true;

	// Cost
	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = 75;
	Template.Cost.ResourceCosts.AddItem(Resources);

	return Template;
}


//---------------------------------------------------------------------------------------------------
// Rocketeer Unlocks
//---------------------------------------------------------------------------------------------------


static function X2SoldierAbilityUnlockTemplate WeaponsTeamUnlock()
{
	local X2SoldierAbilityUnlockTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2SoldierAbilityUnlockTemplate', Template, 'Beags_Escalation_WeaponsTeam_Unlock');

	`LOG("Beags Escalation: Creating Weapons Team perk unlock.");
	
	Template.bAllClasses = true;
	Template.AbilityName = 'Beags_Escalation_WeaponsTeam';
	Template.strImage = "img:///UILibrary_Beags_Escalation_Icons.GTS.GTS_RocketeerSGT";
	
	// Requirements
	Template.Requirements.RequiredHighestSoldierRank = 4;
	Template.Requirements.RequiredSoldierClass = 'Beags_Escalation_Rocketeer';
	Template.Requirements.RequiredSoldierRankClassCombo = true;
	Template.Requirements.bVisibleIfSoldierRankGatesNotMet = true;

	// Cost
	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = 75;
	Template.Cost.ResourceCosts.AddItem(Resources);

	return Template;
}

static function X2SoldierAbilityUnlockTemplate RocketSnapshotUnlock()
{
	local X2SoldierAbilityUnlockTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2SoldierAbilityUnlockTemplate', Template, 'Beags_Escalation_RocketSnapshot_Unlock');

	`LOG("Beags Escalation: Creating Snapshot (Rocketeer) perk unlock.");

	Template.AllowedClasses.AddItem('Beags_Escalation_Rocketeer');
	Template.AbilityName = 'Beags_Escalation_RocketSnapshot';
	Template.strImage = "img:///UILibrary_Beags_Escalation_Icons.GTS.GTS_Rocketeer";
	
	// Requirements
	Template.Requirements.RequiredHighestSoldierRank = 5;
	Template.Requirements.RequiredSoldierClass = 'Beags_Escalation_Rocketeer';
	Template.Requirements.RequiredSoldierRankClassCombo = true;
	Template.Requirements.bVisibleIfSoldierRankGatesNotMet = true;

	// Cost
	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = 75;
	Template.Cost.ResourceCosts.AddItem(Resources);

	return Template;
}
