//---------------------------------------------------------------------------------------
//  FILE:    X2StrategyElement_XpackTechs.uc
//  AUTHOR:  Joe Weinhoffer  --  10/26/2016
//  PURPOSE: Create Xpack tech templates
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class X2StrategyElement_XpackTechs extends X2StrategyElement_DefaultTechs config(GameData);

var config array<int> ProvingGroundProjectCostReductionM1Bonus;
var config array<int> ProvingGroundProjectCostReductionM2Bonus;
var config array<int> GTSUnlockCostReductionM1Bonus;
var config array<int> GTSUnlockCostReductionM2Bonus;
var config array<int> FacilityCostReductionBonus;
var config array<int> FacilityUpgradeCostReductionBonus;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Techs;

	// Autopsies
	Techs.AddItem(CreateAutopsyAdventPurifierTemplate());
	Techs.AddItem(CreateAutopsyAdventPriestTemplate());
	Techs.AddItem(CreateAutopsyTheLostTemplate());
	Techs.AddItem(CreateAutopsySpectreTemplate());

	// Chosen Weapons
	Techs.AddItem(CreateChosenAssassinWeaponsTemplate());
	Techs.AddItem(CreateChosenHunterWeaponsTemplate());
	Techs.AddItem(CreateChosenWarlockWeaponsTemplate());
	
	////////////////////
	// Breakthroughs  //
	////////////////////

	//Weapon Tier Damage
	Techs.AddItem(CreateBreakthroughConventionalWeaponDamageTemplate());
	Techs.AddItem(CreateBreakthroughMagneticWeaponDamageTemplate());
	Techs.AddItem(CreateBreakthroughBeamWeaponDamageTemplate());
	
	// Armor Health
	Techs.AddItem(CreateBreakthroughLightArmorHealthTemplate());
	Techs.AddItem(CreateBreakthroughHeavyArmorHealthTemplate());
	
	// Weapon Damage
	Techs.AddItem(CreateBreakthroughAssaultRifleDamageTemplate());
	Techs.AddItem(CreateBreakthroughSniperRifleDamageTemplate());
	Techs.AddItem(CreateBreakthroughShotgunDamageTemplate());
	Techs.AddItem(CreateBreakthroughCannonDamageTemplate());
	Techs.AddItem(CreateBreakthroughVektorRifleDamageTemplate());
	Techs.AddItem(CreateBreakthroughBullpupDamageTemplate());
	Techs.AddItem(CreateBreakthroughPistolDamageTemplate());
	Techs.AddItem(CreateBreakthroughSidearmDamageTemplate());
	Techs.AddItem(CreateBreakthroughSwordDamageTemplate());
	
	// Weapon Upgrades
	Techs.AddItem(CreateBreakthroughAssaultRifleWeaponUpgradeTemplate());
	Techs.AddItem(CreateBreakthroughSniperRifleWeaponUpgradeTemplate());
	Techs.AddItem(CreateBreakthroughShotgunWeaponUpgradeTemplate());
	Techs.AddItem(CreateBreakthroughCannonWeaponUpgradeTemplate());
	Techs.AddItem(CreateBreakthroughVektorRifleWeaponUpgradeTemplate());
	Techs.AddItem(CreateBreakthroughBullpupWeaponUpgradeTemplate());

	// Facility Cost Reduction
	Techs.AddItem(CreateBreakthroughLaboratoryCostReductionTemplate());
	Techs.AddItem(CreateBreakthroughWorkshopCostReductionTemplate());
	Techs.AddItem(CreateBreakthroughProvingGroundCostReductionTemplate());
	Techs.AddItem(CreateBreakthroughPowerRelayCostReductionTemplate());
	Techs.AddItem(CreateBreakthroughAWCCostReductionTemplate());
	Techs.AddItem(CreateBreakthroughShadowChamberCostReductionTemplate());
	Techs.AddItem(CreateBreakthroughGTSCostReductionTemplate());
	Techs.AddItem(CreateBreakthroughUFODefenseCostReductionTemplate());
	Techs.AddItem(CreateBreakthroughResistanceCommsCostReductionTemplate());
	Techs.AddItem(CreateBreakthroughPsiChamberCostReductionTemplate());
	Techs.AddItem(CreateBreakthroughResistanceRingCostReductionTemplate());
	Techs.AddItem(CreateBreakthroughRecoveryCenterCostReductionTemplate());

	// Facility Upgrade Cost Reduction
	Techs.AddItem(CreateBreakthroughAdditionalWorkbenchCostReductionTemplate());
	Techs.AddItem(CreateBreakthroughAdditionalResearchStationCostReductionTemplate());
	Techs.AddItem(CreateBreakthroughPowerConduitCostReductionTemplate());
	Techs.AddItem(CreateBreakthroughEleriumConduitCostReductionTemplate());
	Techs.AddItem(CreateBreakthroughAdditionalCommStationCostReductionTemplate());
	Techs.AddItem(CreateBreakthroughQuadTurretsCostReductionTemplate());
	Techs.AddItem(CreateBreakthroughSecondCellCostReductionTemplate());
	Techs.AddItem(CreateBreakthroughRingUpgradeICostReductionTemplate());
	Techs.AddItem(CreateBreakthroughRingUpgradeIICostReductionTemplate());
	Techs.AddItem(CreateBreakthroughRecoveryChamberCostReductionTemplate());

	// Strategy Modifiers
	Techs.AddItem(CreateBreakthroughReuseWeaponUpgradesTemplate());
	Techs.AddItem(CreateBreakthroughReusePCSTemplate());
	Techs.AddItem(CreateBreakthroughProvingGroundProjectCostReductionM1Template());
	Techs.AddItem(CreateBreakthroughProvingGroundProjectCostReductionM2Template());
	Techs.AddItem(CreateBreakthroughGTSUnlockCostReductionM1Template());
	Techs.AddItem(CreateBreakthroughGTSUnlockCostReductionM2Template());
	Techs.AddItem(CreateBreakthroughInstantExcavationTemplate());

	return Techs;
}

// #######################################################################################
// -------------------- AUTOPSY TECHS ---------------------------------------------------
// #######################################################################################

// We'll cheat this one a little and add it to the tactical tech breakthroughs even though it's an autopsy
// and not strictly a breakthrough
function AutopsyAdventPurifierTacticalBonusCompleted(XComGameState NewGameState, XComGameState_Tech TechState)
{
	local XComGameState_HeadquartersXCom XComHQ;

	XComHQ = XComGameState_HeadquartersXCom( `XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom') );
	XComHQ = XComGameState_HeadquartersXCom( NewGameState.ModifyStateObject(class'XComGameState_HeadquartersXCom', XComHQ.ObjectID) );
	XComHQ.TacticalTechBreakthroughs.AddItem( TechState.GetReference() );
	XComHQ.bReinforcedUnderlay = true;
}

static function X2DataTemplate CreateAutopsyAdventPurifierTemplate()
{
	local X2TechTemplate Template;
	local ArtifactCost Artifacts;
	local X2BreakthroughCondition_ItemType TechCondition;

	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, 'AutopsyAdventPurifier');
	Template.PointsToComplete = 2000;
	Template.strImage = "img:///UILibrary_XPACK_StrategyImages.IC_Purifier";
	Template.bAutopsy = true;
	Template.bCheckForceInstant = true;
	Template.SortingTier = 2;

	Template.TechStartedNarrative = "XPACK_NarrativeMoments.Autopsy_AdventPurifier";

	// Requirements
	Template.Requirements.RequiredTechs.AddItem('AlienBiotech');
	Template.Requirements.RequiredItems.AddItem('CorpseAdventPurifier');
	Template.Requirements.RequiredTechs.AddItem('AutopsyAdventOfficer');

	// Instant Requirements. Will become the Cost if the tech is forced to Instant.
	Artifacts.ItemTemplateName = 'CorpseAdventPurifier';
	Artifacts.Quantity = 6;
	Template.InstantRequirements.RequiredItemQuantities.AddItem(Artifacts);

	// Cost
	Artifacts.ItemTemplateName = 'CorpseAdventPurifier';
	Artifacts.Quantity = 1;
	Template.Cost.ArtifactCosts.AddItem(Artifacts);

	Template.ResearchCompletedFn = AutopsyAdventPurifierTacticalBonusCompleted;

	Template.RewardName = 'PurifierAutopsyVestBonus';

	TechCondition = new class'X2BreakthroughCondition_ItemType';
	TechCondition.ItemTypeMatch = 'defense';
	Template.BreakthroughCondition = TechCondition;

	return Template;
}

static function X2DataTemplate CreateAutopsyAdventPriestTemplate()
{
	local X2TechTemplate Template;
	local ArtifactCost Artifacts;

	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, 'AutopsyAdventPriest');
	Template.PointsToComplete = 1600;
	Template.strImage = "img:///UILibrary_XPACK_StrategyImages.IC_Priest";
	Template.bAutopsy = true;
	Template.bCheckForceInstant = true;
	Template.SortingTier = 2;

	Template.TechStartedNarrative = "XPACK_NarrativeMoments.Autopsy_AdventPriest";

	// Requirements
	Template.Requirements.RequiredTechs.AddItem('AlienBiotech');
	Template.Requirements.RequiredItems.AddItem('CorpseAdventPriest');
	Template.Requirements.RequiredTechs.AddItem('AutopsyAdventOfficer');

	// Instant Requirements. Will become the Cost if the tech is forced to Instant.
	Artifacts.ItemTemplateName = 'CorpseAdventPriest';
	Artifacts.Quantity = 8;
	Template.InstantRequirements.RequiredItemQuantities.AddItem(Artifacts);

	// Cost
	Artifacts.ItemTemplateName = 'CorpseAdventPriest';
	Artifacts.Quantity = 1;
	Template.Cost.ArtifactCosts.AddItem(Artifacts);

	return Template;
}

static function X2DataTemplate CreateAutopsyTheLostTemplate()
{
	local X2TechTemplate Template;
	local ArtifactCost Artifacts;

	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, 'AutopsyTheLost');
	Template.PointsToComplete = 960;
	Template.strImage = "img:///UILibrary_XPACK_StrategyImages.IC_Lost";
	Template.bAutopsy = true;
	Template.bCheckForceInstant = true;
	Template.SortingTier = 2;

	Template.TechStartedNarrative = "XPACK_NarrativeMoments.Autopsy_Lost";

	// Requirements
	Template.Requirements.RequiredTechs.AddItem('AlienBiotech');
	Template.Requirements.RequiredItems.AddItem('CorpseTheLost');

	// Instant Requirements. Will become the Cost if the tech is forced to Instant.
	Artifacts.ItemTemplateName = 'CorpseTheLost';
	Artifacts.Quantity = 80;
	Template.InstantRequirements.RequiredItemQuantities.AddItem(Artifacts);

	// Cost
	Artifacts.ItemTemplateName = 'CorpseTheLost';
	Artifacts.Quantity = 1;
	Template.Cost.ArtifactCosts.AddItem(Artifacts);

	return Template;
}

static function X2DataTemplate CreateAutopsySpectreTemplate()
{
	local X2TechTemplate Template;
	local ArtifactCost Artifacts;

	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, 'AutopsySpectre');
	Template.PointsToComplete = 3300;
	Template.strImage = "img:///UILibrary_XPACK_StrategyImages.IC_Spectre";
	Template.bAutopsy = true;
	Template.bCheckForceInstant = true;
	Template.SortingTier = 2;

	Template.TechStartedNarrative = "XPACK_NarrativeMoments.Autopsy_Spectre";

	// Requirements
	Template.Requirements.RequiredTechs.AddItem('AlienBiotech');
	Template.Requirements.RequiredItems.AddItem('CorpseSpectre');

	// Instant Requirements. Will become the Cost if the tech is forced to Instant.
	Artifacts.ItemTemplateName = 'CorpseSpectre';
	Artifacts.Quantity = 6;
	Template.InstantRequirements.RequiredItemQuantities.AddItem(Artifacts);

	// Cost
	Artifacts.ItemTemplateName = 'CorpseSpectre';
	Artifacts.Quantity = 1;
	Template.Cost.ArtifactCosts.AddItem(Artifacts);

	return Template;
}

// #######################################################################################
// ------------------------ CHOSEN WEAPONS -----------------------------------------------
// #######################################################################################

static function X2DataTemplate CreateChosenAssassinWeaponsTemplate()
{
	local X2TechTemplate Template;
	local ArtifactCost ArtifactReq;

	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, 'ChosenAssassinWeapons');
	Template.PointsToComplete = 5000;
	Template.strImage = "img:///UILibrary_XPACK_StrategyImages.IC_Assassin_Weapons";
	Template.SortingTier = 1;

	Template.Requirements.RequiredItems.AddItem('ChosenAssassinShotgun');
	Template.Requirements.RequiredItems.AddItem('ChosenAssassinSword');
	Template.ResearchCompletedFn = GiveItems;

	// Item Rewards
	Template.ItemRewards.AddItem('ChosenShotgun_Schematic'); // Giving the schematic will also give the item
	Template.ItemRewards.AddItem('ChosenSword_Schematic');
	
	// Cost
	ArtifactReq.ItemTemplateName = 'ChosenAssassinShotgun';
	ArtifactReq.Quantity = 1;
	Template.Cost.ArtifactCosts.AddItem(ArtifactReq);

	ArtifactReq.ItemTemplateName = 'ChosenAssassinSword';
	ArtifactReq.Quantity = 1;
	Template.Cost.ArtifactCosts.AddItem(ArtifactReq);

	return Template;
}

static function X2DataTemplate CreateChosenHunterWeaponsTemplate()
{
	local X2TechTemplate Template;
	local ArtifactCost ArtifactReq;

	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, 'ChosenHunterWeapons');
	Template.PointsToComplete = 5000;
	Template.strImage = "img:///UILibrary_XPACK_StrategyImages.IC_Hunter_Weapons";
	Template.SortingTier = 1;

	Template.Requirements.RequiredItems.AddItem('ChosenHunterSniperRifle');
	Template.Requirements.RequiredItems.AddItem('ChosenHunterPistol');
	Template.ResearchCompletedFn = GiveItems;

	// Item Rewards
	Template.ItemRewards.AddItem('ChosenSniperRifle_Schematic'); // Giving the schematic will also give the item
	Template.ItemRewards.AddItem('ChosenSniperPistol_Schematic');

	// Cost
	ArtifactReq.ItemTemplateName = 'ChosenHunterSniperRifle';
	ArtifactReq.Quantity = 1;
	Template.Cost.ArtifactCosts.AddItem(ArtifactReq);

	ArtifactReq.ItemTemplateName = 'ChosenHunterPistol';
	ArtifactReq.Quantity = 1;
	Template.Cost.ArtifactCosts.AddItem(ArtifactReq);

	return Template;
}

static function X2DataTemplate CreateChosenWarlockWeaponsTemplate()
{
	local X2TechTemplate Template;
	local ArtifactCost ArtifactReq;

	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, 'ChosenWarlockWeapons');
	Template.PointsToComplete = 3500;
	Template.strImage = "img:///UILibrary_XPACK_StrategyImages.IC_Warlock_Weapon";
	Template.SortingTier = 1;

	Template.Requirements.RequiredItems.AddItem('ChosenWarlockRifle');
	Template.ResearchCompletedFn = GiveItems;

	// Item Rewards
	Template.ItemRewards.AddItem('ChosenRifle_Schematic'); // Giving the schematic will also give the item

	// Cost
	ArtifactReq.ItemTemplateName = 'ChosenWarlockRifle';
	ArtifactReq.Quantity = 1;
	Template.Cost.ArtifactCosts.AddItem(ArtifactReq);

	return Template;
}

// #######################################################################################
// -------------------- BREAKTHROUGH TECHS -----------------------------------------------
// #######################################################################################

function BreakthroughItemTacticalBonusCompleted(XComGameState NewGameState, XComGameState_Tech TechState)
{
	local XComGameState_HeadquartersXCom XComHQ;

	XComHQ = XComGameState_HeadquartersXCom( `XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom') );
	XComHQ = XComGameState_HeadquartersXCom( NewGameState.ModifyStateObject(class'XComGameState_HeadquartersXCom', XComHQ.ObjectID) );
	XComHQ.TacticalTechBreakthroughs.AddItem( TechState.GetReference() );
}

////////////////////////
// Weapon Tier Damage //
////////////////////////

static function X2DataTemplate CreateBreakthroughConventionalWeaponDamageTemplate()
{
	local X2TechTemplate Template;
	local X2BreakthroughCondition_WeaponTech TechCondition;

	Template = CreateBreakthroughTechTemplate('BreakthroughConventionalWeaponDamage');
	Template.strImage = "img:///UILibrary_XPACK_Common.BT_dmgconv";
	Template.ResearchCompletedFn = BreakthroughItemTacticalBonusCompleted;

	Template.UnavailableIfResearched = 'MagnetizedWeapons';

	TechCondition = new class'X2BreakthroughCondition_WeaponTech';
	TechCondition.WeaponTechMatch = 'conventional';
	Template.BreakthroughCondition = TechCondition;

	Template.RewardName = 'WeaponTechBreakthroughBonus';

	return Template;
}

static function X2DataTemplate CreateBreakthroughMagneticWeaponDamageTemplate()
{
	local X2TechTemplate Template;
	local X2BreakthroughCondition_WeaponTech TechCondition;

	Template = CreateBreakthroughTechTemplate('BreakthroughMagneticWeaponDamage');
	Template.strImage = "img:///UILibrary_XPACK_Common.BT_dmgmag";
	Template.ResearchCompletedFn = BreakthroughItemTacticalBonusCompleted;

	Template.Requirements.RequiredTechs.AddItem('MagnetizedWeapons');
	Template.UnavailableIfResearched = 'PlasmaRifle';

	TechCondition = new class'X2BreakthroughCondition_WeaponTech';
	TechCondition.WeaponTechMatch = 'magnetic';
	Template.BreakthroughCondition = TechCondition;

	Template.RewardName = 'WeaponTechBreakthroughBonus';

	return Template;
}

static function X2DataTemplate CreateBreakthroughBeamWeaponDamageTemplate()
{
	local X2TechTemplate Template;
	local X2BreakthroughCondition_WeaponTech TechCondition;

	Template = CreateBreakthroughTechTemplate('BreakthroughBeamWeaponDamage');
	Template.strImage = "img:///UILibrary_XPACK_Common.BT_dmgplas";
	Template.ResearchCompletedFn = BreakthroughItemTacticalBonusCompleted;

	Template.Requirements.RequiredTechs.AddItem('PlasmaRifle');

	TechCondition = new class'X2BreakthroughCondition_WeaponTech';
	TechCondition.WeaponTechMatch = 'beam';
	Template.BreakthroughCondition = TechCondition;

	Template.RewardName = 'WeaponTechBreakthroughBonus';

	return Template;
}

//////////////////
// Armor Health //
//////////////////

static function X2DataTemplate CreateBreakthroughLightArmorHealthTemplate()
{
	local X2TechTemplate Template;
	local X2BreakthroughCondition_ArmorType ArmorTypeCondition;

	Template = CreateBreakthroughTechTemplate('BreakthroughLightArmorHealth');
	Template.strImage = "img:///UILibrary_XPACK_Common.BT_armorlight";
	Template.ResearchCompletedFn = BreakthroughItemTacticalBonusCompleted;

	Template.Requirements.RequiredTechs.AddItem('PlatedArmor');

	ArmorTypeCondition = new class'X2BreakthroughCondition_ArmorType';
	ArmorTypeCondition.ArmorTypeMatch = 'light';
	Template.BreakthroughCondition = ArmorTypeCondition;

	Template.RewardName = 'ArmorTypeBreakthroughBonus';

	return Template;
}

static function X2DataTemplate CreateBreakthroughHeavyArmorHealthTemplate()
{
	local X2TechTemplate Template;
	local X2BreakthroughCondition_ArmorType ArmorTypeCondition;

	Template = CreateBreakthroughTechTemplate('BreakthroughHeavyArmorHealth');
	Template.strImage = "img:///UILibrary_XPACK_Common.BT_armorheavy";
	Template.ResearchCompletedFn = BreakthroughItemTacticalBonusCompleted;

	Template.Requirements.RequiredTechs.AddItem('PlatedArmor');

	ArmorTypeCondition = new class'X2BreakthroughCondition_ArmorType';
	ArmorTypeCondition.ArmorTypeMatch = 'heavy';
	Template.BreakthroughCondition = ArmorTypeCondition;

	Template.RewardName = 'ArmorTypeBreakthroughBonus';

	return Template;
}

///////////////////
// Weapon Damage //
///////////////////

static function X2DataTemplate CreateBreakthroughAssaultRifleDamageTemplate()
{
	local X2TechTemplate Template;
	local X2BreakthroughCondition_WeaponType WeaponTypeCondition;

	Template = CreateBreakthroughTechTemplate('BreakthroughAssaultRifleDamage');
	Template.strImage = "img:///UILibrary_XPACK_Common.BT_dmgassaultrifle";
	Template.ResearchCompletedFn = BreakthroughItemTacticalBonusCompleted;

	WeaponTypeCondition = new class'X2BreakthroughCondition_WeaponType';
	WeaponTypeCondition.WeaponTypeMatch = 'rifle';
	Template.BreakthroughCondition = WeaponTypeCondition;

	Template.RewardName = 'WeaponTypeBreakthroughBonus';

	return Template;
}

static function X2DataTemplate CreateBreakthroughSniperRifleDamageTemplate()
{
	local X2TechTemplate Template;
	local X2BreakthroughCondition_WeaponType WeaponTypeCondition;

	Template = CreateBreakthroughTechTemplate('BreakthroughSniperRifleDamage');
	Template.strImage = "img:///UILibrary_XPACK_Common.BT_dmgsniper";
	Template.ResearchCompletedFn = BreakthroughItemTacticalBonusCompleted;

	Template.Requirements.RequiredSoldierClass = 'Sharpshooter';

	WeaponTypeCondition = new class'X2BreakthroughCondition_WeaponType';
	WeaponTypeCondition.WeaponTypeMatch = 'sniper_rifle';
	Template.BreakthroughCondition = WeaponTypeCondition;

	Template.RewardName = 'WeaponTypeBreakthroughBonus';

	return Template;
}

static function X2DataTemplate CreateBreakthroughShotgunDamageTemplate()
{
	local X2TechTemplate Template;
	local X2BreakthroughCondition_WeaponType WeaponTypeCondition;

	Template = CreateBreakthroughTechTemplate('BreakthroughShotgunDamage');
	Template.strImage = "img:///UILibrary_XPACK_Common.BT_dmgshotgun";
	Template.ResearchCompletedFn = BreakthroughItemTacticalBonusCompleted;

	Template.Requirements.RequiredSoldierClass = 'Ranger';

	WeaponTypeCondition = new class'X2BreakthroughCondition_WeaponType';
	WeaponTypeCondition.WeaponTypeMatch = 'shotgun';
	Template.BreakthroughCondition = WeaponTypeCondition;

	Template.RewardName = 'WeaponTypeBreakthroughBonus';

	return Template;
}

static function X2DataTemplate CreateBreakthroughCannonDamageTemplate()
{
	local X2TechTemplate Template;
	local X2BreakthroughCondition_WeaponType WeaponTypeCondition;

	Template = CreateBreakthroughTechTemplate('BreakthroughCannonDamage');
	Template.strImage = "img:///UILibrary_XPACK_Common.BT_dmgcannon";
	Template.ResearchCompletedFn = BreakthroughItemTacticalBonusCompleted;

	Template.Requirements.RequiredSoldierClass = 'Grenadier';

	WeaponTypeCondition = new class'X2BreakthroughCondition_WeaponType';
	WeaponTypeCondition.WeaponTypeMatch = 'cannon';
	Template.BreakthroughCondition = WeaponTypeCondition;

	Template.RewardName = 'WeaponTypeBreakthroughBonus';

	return Template;
}

static function X2DataTemplate CreateBreakthroughVektorRifleDamageTemplate()
{
	local X2TechTemplate Template;
	local X2BreakthroughCondition_WeaponType WeaponTypeCondition;

	Template = CreateBreakthroughTechTemplate('BreakthroughVektorRifleDamage');
	Template.strImage = "img:///UILibrary_XPACK_Common.BT_dmgvektor";
	Template.ResearchCompletedFn = BreakthroughItemTacticalBonusCompleted;

	Template.Requirements.RequiredSoldierClass = 'Reaper';

	WeaponTypeCondition = new class'X2BreakthroughCondition_WeaponType';
	WeaponTypeCondition.WeaponTypeMatch = 'vektor_rifle';
	Template.BreakthroughCondition = WeaponTypeCondition;

	Template.RewardName = 'WeaponTypeBreakthroughBonus';

	return Template;
}

static function X2DataTemplate CreateBreakthroughBullpupDamageTemplate()
{
	local X2TechTemplate Template;
	local X2BreakthroughCondition_WeaponType WeaponTypeCondition;

	Template = CreateBreakthroughTechTemplate('BreakthroughBullpupDamage');
	Template.strImage = "img:///UILibrary_XPACK_Common.BT_dmgbullpup";
	Template.ResearchCompletedFn = BreakthroughItemTacticalBonusCompleted;

	Template.Requirements.RequiredSoldierClass = 'Skirmisher';

	WeaponTypeCondition = new class'X2BreakthroughCondition_WeaponType';
	WeaponTypeCondition.WeaponTypeMatch = 'bullpup';
	Template.BreakthroughCondition = WeaponTypeCondition;

	Template.RewardName = 'WeaponTypeBreakthroughBonus';

	return Template;
}

static function X2DataTemplate CreateBreakthroughPistolDamageTemplate()
{
	local X2TechTemplate Template;
	local X2BreakthroughCondition_WeaponType WeaponTypeCondition;

	Template = CreateBreakthroughTechTemplate('BreakthroughPistolDamage');
	Template.strImage = "img:///UILibrary_XPACK_Common.BT_dmgpistol";
	Template.ResearchCompletedFn = BreakthroughItemTacticalBonusCompleted;

	Template.Requirements.RequiredSoldierClass = 'Sharpshooter';

	WeaponTypeCondition = new class'X2BreakthroughCondition_WeaponType';
	WeaponTypeCondition.WeaponTypeMatch = 'pistol';
	Template.BreakthroughCondition = WeaponTypeCondition;

	Template.RewardName = 'WeaponTypeBreakthroughBonus';

	return Template;
}

static function X2DataTemplate CreateBreakthroughSidearmDamageTemplate()
{
	local X2TechTemplate Template;
	local X2BreakthroughCondition_WeaponType WeaponTypeCondition;

	Template = CreateBreakthroughTechTemplate('BreakthroughSidearmDamage');
	Template.strImage = "img:///UILibrary_XPACK_Common.BT_dmgmachinepistol";
	Template.ResearchCompletedFn = BreakthroughItemTacticalBonusCompleted;

	Template.Requirements.RequiredSoldierClass = 'Templar';

	WeaponTypeCondition = new class'X2BreakthroughCondition_WeaponType';
	WeaponTypeCondition.WeaponTypeMatch = 'sidearm';
	Template.BreakthroughCondition = WeaponTypeCondition;

	Template.RewardName = 'WeaponTypeBreakthroughBonus';

	return Template;
}

static function X2DataTemplate CreateBreakthroughSwordDamageTemplate()
{
	local X2TechTemplate Template;
	local X2BreakthroughCondition_WeaponType WeaponTypeCondition;

	Template = CreateBreakthroughTechTemplate('BreakthroughSwordDamage');
	Template.strImage = "img:///UILibrary_XPACK_Common.BT_dmgsword";
	Template.ResearchCompletedFn = BreakthroughItemTacticalBonusCompleted;

	Template.Requirements.RequiredSoldierClass = 'Ranger';

	WeaponTypeCondition = new class'X2BreakthroughCondition_WeaponType';
	WeaponTypeCondition.WeaponTypeMatch = 'sword';
	Template.BreakthroughCondition = WeaponTypeCondition;

	Template.RewardName = 'WeaponTypeBreakthroughBonus';

	return Template;
}

/////////////////////
// Weapon Upgrades //
/////////////////////

static function X2DataTemplate CreateBreakthroughAssaultRifleWeaponUpgradeTemplate()
{
	local X2TechTemplate Template;

	Template = CreateBreakthroughTechTemplate('BreakthroughAssaultRifleWeaponUpgrade');
	Template.strImage = "img:///UILibrary_XPACK_Common.BT_modAR";
	Template.ResearchCompletedFn = BreakthroughWeaponUpgradeCompleted;
	Template.RewardName = 'rifle';

	Template.Requirements.RequiredTechs.AddItem('ModularWeapons');

	return Template;
}

static function X2DataTemplate CreateBreakthroughSniperRifleWeaponUpgradeTemplate()
{
	local X2TechTemplate Template;

	Template = CreateBreakthroughTechTemplate('BreakthroughSniperRifleWeaponUpgrade');
	Template.strImage = "img:///UILibrary_XPACK_Common.BT_modSN";
	Template.ResearchCompletedFn = BreakthroughWeaponUpgradeCompleted;
	Template.RewardName = 'sniper_rifle';

	Template.Requirements.RequiredTechs.AddItem('ModularWeapons');
	Template.Requirements.RequiredSoldierClass = 'Sharpshooter';

	return Template;
}

static function X2DataTemplate CreateBreakthroughShotgunWeaponUpgradeTemplate()
{
	local X2TechTemplate Template;

	Template = CreateBreakthroughTechTemplate('BreakthroughShotgunWeaponUpgrade');
	Template.strImage = "img:///UILibrary_XPACK_Common.BT_modshotgun";
	Template.ResearchCompletedFn = BreakthroughWeaponUpgradeCompleted;
	Template.RewardName = 'shotgun';

	Template.Requirements.RequiredTechs.AddItem('ModularWeapons');
	Template.Requirements.RequiredSoldierClass = 'Ranger';

	return Template;
}

static function X2DataTemplate CreateBreakthroughCannonWeaponUpgradeTemplate()
{
	local X2TechTemplate Template;

	Template = CreateBreakthroughTechTemplate('BreakthroughCannonWeaponUpgrade');
	Template.strImage = "img:///UILibrary_XPACK_Common.BT_modcannon";
	Template.ResearchCompletedFn = BreakthroughWeaponUpgradeCompleted;
	Template.RewardName = 'cannon';

	Template.Requirements.RequiredTechs.AddItem('ModularWeapons');
	Template.Requirements.RequiredSoldierClass = 'Grenadier';

	return Template;
}

static function X2DataTemplate CreateBreakthroughVektorRifleWeaponUpgradeTemplate()
{
	local X2TechTemplate Template;

	Template = CreateBreakthroughTechTemplate('BreakthroughVektorRifleWeaponUpgrade');
	Template.strImage = "img:///UILibrary_XPACK_Common.BT_modvektor";
	Template.ResearchCompletedFn = BreakthroughWeaponUpgradeCompleted;
	Template.RewardName = 'vektor_rifle';

	Template.Requirements.RequiredTechs.AddItem('ModularWeapons');
	Template.Requirements.RequiredSoldierClass = 'Reaper';

	return Template;
}

static function X2DataTemplate CreateBreakthroughBullpupWeaponUpgradeTemplate()
{
	local X2TechTemplate Template;

	Template = CreateBreakthroughTechTemplate('BreakthroughBullpupWeaponUpgrade');
	Template.strImage = "img:///UILibrary_XPACK_Common.BT_modbullpup";
	Template.ResearchCompletedFn = BreakthroughWeaponUpgradeCompleted;
	Template.RewardName = 'bullpup';

	Template.Requirements.RequiredTechs.AddItem('ModularWeapons');
	Template.Requirements.RequiredSoldierClass = 'Skirmisher';

	return Template;
}

function BreakthroughWeaponUpgradeCompleted(XComGameState NewGameState, XComGameState_Tech TechState)
{
	local XComGameState_HeadquartersXCom XComHQ;

	XComHQ = XComGameState_HeadquartersXCom(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
	XComHQ = XComGameState_HeadquartersXCom(NewGameState.ModifyStateObject(class'XComGameState_HeadquartersXCom', XComHQ.ObjectID));
	XComHQ.ExtraUpgradeWeaponCats.AddItem(TechState.GetMyTemplate().RewardName);
}

/////////////////////////////
// Facility Cost Reduction //
/////////////////////////////

function BreakthroughFacilityDiscountCompleted(XComGameState NewGameState, XComGameState_Tech TechState)
{
	local XComGameState_HeadquartersXCom XComHQ;
	local PendingFacilityDiscount NewDiscount;

	XComHQ = XComGameState_HeadquartersXCom(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
	XComHQ = XComGameState_HeadquartersXCom(NewGameState.ModifyStateObject(class'XComGameState_HeadquartersXCom', XComHQ.ObjectID));

	NewDiscount.TemplateName = TechState.GetMyTemplate().RewardName;
	NewDiscount.DiscountPercent = `ScaleStrategyArrayInt( FacilityCostReductionBonus );

	XComHQ.PendingFacilityDiscounts.AddItem( NewDiscount );
}

static function X2DataTemplate CreateBreakthroughLaboratoryCostReductionTemplate()
{
	local X2TechTemplate Template;

	Template = CreateBreakthroughTechTemplate('BreakthroughLaboratoryCostReduction');
	Template.strImage = "img:///UILibrary_XPACK_Common.BT_laboratory";
	Template.ResearchCompletedFn = BreakthroughFacilityDiscountCompleted;
	Template.GetValueFn = GetValueFacilityCostReduction;

	Template.Requirements.SpecialRequirementsFn = IsBreakthroughLaboratoryCostReductionAvailable;
	Template.RewardName = 'Laboratory';

	return Template;
}

function bool IsBreakthroughLaboratoryCostReductionAvailable()
{
	return IsFacilityCostReductionAvailable('Laboratory');
}

static function X2DataTemplate CreateBreakthroughWorkshopCostReductionTemplate()
{
	local X2TechTemplate Template;

	Template = CreateBreakthroughTechTemplate('BreakthroughWorkshopCostReduction');
	Template.strImage = "img:///UILibrary_XPACK_Common.BT_workshop";
	Template.ResearchCompletedFn = BreakthroughFacilityDiscountCompleted;
	Template.GetValueFn = GetValueFacilityCostReduction;

	Template.Requirements.SpecialRequirementsFn = IsBreakthroughWorkshopCostReductionAvailable;
	Template.RewardName = 'Workshop';

	return Template;
}

function bool IsBreakthroughWorkshopCostReductionAvailable()
{
	return IsFacilityCostReductionAvailable('Workshop');
}

static function X2DataTemplate CreateBreakthroughProvingGroundCostReductionTemplate()
{
	local X2TechTemplate Template;

	Template = CreateBreakthroughTechTemplate('BreakthroughProvingGroundCostReduction');
	Template.strImage = "img:///UILibrary_XPACK_Common.BT_provinggrounds";
	Template.ResearchCompletedFn = BreakthroughFacilityDiscountCompleted;
	Template.GetValueFn = GetValueFacilityCostReduction;

	Template.Requirements.SpecialRequirementsFn = IsBreakthroughProvingGroundCostReductionAvailable;
	Template.RewardName = 'ProvingGround';

	return Template;
}

function bool IsBreakthroughProvingGroundCostReductionAvailable()
{
	return IsFacilityCostReductionAvailable('ProvingGround');
}

static function X2DataTemplate CreateBreakthroughPowerRelayCostReductionTemplate()
{
	local X2TechTemplate Template;

	Template = CreateBreakthroughTechTemplate('BreakthroughPowerRelayCostReduction');
	Template.strImage = "img:///UILibrary_XPACK_Common.BT_powerrelay";
	Template.ResearchCompletedFn = BreakthroughFacilityDiscountCompleted;
	Template.GetValueFn = GetValueFacilityCostReduction;

	Template.Requirements.SpecialRequirementsFn = IsBreakthroughPowerRelayCostReductionAvailable;
	Template.RewardName = 'PowerRelay';

	return Template;
}

function bool IsBreakthroughPowerRelayCostReductionAvailable()
{
	return IsFacilityCostReductionAvailable('PowerRelay');
}

static function X2DataTemplate CreateBreakthroughAWCCostReductionTemplate()
{
	local X2TechTemplate Template;

	Template = CreateBreakthroughTechTemplate('BreakthroughAWCCostReduction');
	Template.strImage = "img:///UILibrary_XPACK_Common.BT_AWC";
	Template.ResearchCompletedFn = BreakthroughFacilityDiscountCompleted;
	Template.GetValueFn = GetValueFacilityCostReduction;

	Template.Requirements.SpecialRequirementsFn = IsBreakthroughAWCCostReductionAvailable;
	Template.RewardName = 'AdvancedWarfareCenter';

	return Template;
}

function bool IsBreakthroughAWCCostReductionAvailable()
{
	return IsFacilityCostReductionAvailable('AdvancedWarfareCenter');
}

static function X2DataTemplate CreateBreakthroughShadowChamberCostReductionTemplate()
{
	local X2TechTemplate Template;

	Template = CreateBreakthroughTechTemplate('BreakthroughShadowChamberCostReduction');
	Template.strImage = "img:///UILibrary_XPACK_Common.BT_shadowchamber";
	Template.ResearchCompletedFn = BreakthroughFacilityDiscountCompleted;
	Template.GetValueFn = GetValueFacilityCostReduction;

	Template.Requirements.SpecialRequirementsFn = IsBreakthroughShadowChamberCostReductionAvailable;
	Template.RewardName = 'ShadowChamber';

	return Template;
}

function bool IsBreakthroughShadowChamberCostReductionAvailable()
{
	return IsFacilityCostReductionAvailable('ShadowChamber');
}

static function X2DataTemplate CreateBreakthroughGTSCostReductionTemplate()
{
	local X2TechTemplate Template;

	Template = CreateBreakthroughTechTemplate('BreakthroughGTSCostReduction');
	Template.strImage = "img:///UILibrary_XPACK_Common.BT_gts";
	Template.ResearchCompletedFn = BreakthroughFacilityDiscountCompleted;
	Template.GetValueFn = GetValueFacilityCostReduction;

	Template.Requirements.SpecialRequirementsFn = IsBreakthroughGTSCostReductionAvailable;
	Template.RewardName = 'OfficerTrainingSchool';

	return Template;
}

function bool IsBreakthroughGTSCostReductionAvailable()
{
	return IsFacilityCostReductionAvailable('OfficerTrainingSchool');
}

static function X2DataTemplate CreateBreakthroughUFODefenseCostReductionTemplate()
{
	local X2TechTemplate Template;

	Template = CreateBreakthroughTechTemplate('BreakthroughUFODefenseCostReduction');
	Template.strImage = "img:///UILibrary_XPACK_Common.BT_defensematrix";
	Template.ResearchCompletedFn = BreakthroughFacilityDiscountCompleted;
	Template.GetValueFn = GetValueFacilityCostReduction;

	Template.Requirements.SpecialRequirementsFn = IsBreakthroughUFODefenseCostReductionAvailable;
	Template.RewardName = 'UFODefense';

	return Template;
}

function bool IsBreakthroughUFODefenseCostReductionAvailable()
{
	return IsFacilityCostReductionAvailable('UFODefense');
}

static function X2DataTemplate CreateBreakthroughResistanceCommsCostReductionTemplate()
{
	local X2TechTemplate Template;

	Template = CreateBreakthroughTechTemplate('BreakthroughResistanceCommsCostReduction');
	Template.strImage = "img:///UILibrary_XPACK_Common.BT_resistancecomms";
	Template.ResearchCompletedFn = BreakthroughFacilityDiscountCompleted;
	Template.GetValueFn = GetValueFacilityCostReduction;

	Template.Requirements.SpecialRequirementsFn = IsBreakthroughResistanceCommsCostReductionAvailable;
	Template.RewardName = 'ResistanceComms';

	return Template;
}

function bool IsBreakthroughResistanceCommsCostReductionAvailable()
{
	return IsFacilityCostReductionAvailable('ResistanceComms');
}

static function X2DataTemplate CreateBreakthroughPsiChamberCostReductionTemplate()
{
	local X2TechTemplate Template;

	Template = CreateBreakthroughTechTemplate('BreakthroughPsiChamberCostReduction');
	Template.strImage = "img:///UILibrary_XPACK_Common.BT_psilab";
	Template.ResearchCompletedFn = BreakthroughFacilityDiscountCompleted;
	Template.GetValueFn = GetValueFacilityCostReduction;

	Template.Requirements.SpecialRequirementsFn = IsBreakthroughPsiChamberCostReductionAvailable;
	Template.RewardName = 'PsiChamber';

	return Template;
}

function bool IsBreakthroughPsiChamberCostReductionAvailable()
{
	return IsFacilityCostReductionAvailable('PsiChamber');
}

static function X2DataTemplate CreateBreakthroughResistanceRingCostReductionTemplate()
{
	local X2TechTemplate Template;

	Template = CreateBreakthroughTechTemplate('BreakthroughResistanceRingCostReduction');
	Template.strImage = "img:///UILibrary_XPACK_Common.BT_resistancering";
	Template.ResearchCompletedFn = BreakthroughFacilityDiscountCompleted;
	Template.GetValueFn = GetValueFacilityCostReduction;

	Template.Requirements.SpecialRequirementsFn = IsBreakthroughResistanceRingCostReductionAvailable;
	Template.RewardName = 'ResistanceRing';

	return Template;
}

function bool IsBreakthroughResistanceRingCostReductionAvailable()
{
	return IsFacilityCostReductionAvailable('ResistanceRing');
}

static function X2DataTemplate CreateBreakthroughRecoveryCenterCostReductionTemplate()
{
	local X2TechTemplate Template;

	Template = CreateBreakthroughTechTemplate('BreakthroughRecoveryCenterCostReduction');
	Template.strImage = "img:///UILibrary_XPACK_Common.BT_trainingcenter";
	Template.ResearchCompletedFn = BreakthroughFacilityDiscountCompleted;
	Template.GetValueFn = GetValueFacilityCostReduction;

	Template.Requirements.SpecialRequirementsFn = IsBreakthroughRecoveryCenterCostReductionAvailable;
	Template.RewardName = 'RecoveryCenter';

	return Template;
}

function bool IsBreakthroughRecoveryCenterCostReductionAvailable()
{
	return IsFacilityCostReductionAvailable('RecoveryCenter');
}

/////////////////////////////////////
// Facility Upgrade Cost Reduction //
/////////////////////////////////////

function BreakthroughFacilityUpgradeDiscountCompleted(XComGameState NewGameState, XComGameState_Tech TechState)
{
	local XComGameState_HeadquartersXCom XComHQ;
	local PendingFacilityDiscount NewDiscount;

	XComHQ = XComGameState_HeadquartersXCom(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
	XComHQ = XComGameState_HeadquartersXCom(NewGameState.ModifyStateObject(class'XComGameState_HeadquartersXCom', XComHQ.ObjectID));

	NewDiscount.TemplateName = TechState.GetMyTemplate().RewardName;
	NewDiscount.DiscountPercent = `ScaleStrategyArrayInt( FacilityUpgradeCostReductionBonus );

	XComHQ.PendingFacilityDiscounts.AddItem( NewDiscount );
}

static function X2DataTemplate CreateBreakthroughAdditionalWorkbenchCostReductionTemplate()
{
	local X2TechTemplate Template;

	Template = CreateBreakthroughTechTemplate('BreakthroughAdditionalWorkbenchCostReduction');
	Template.strImage = "img:///UILibrary_XPACK_Common.BT_workshop2";
	Template.ResearchCompletedFn = BreakthroughFacilityUpgradeDiscountCompleted;
	Template.GetValueFn = GetValueFacilityUpgradeCostReduction;

	Template.Requirements.SpecialRequirementsFn = IsBreakthroughAdditionalWorkbenchCostReductionAvailable;
	Template.RewardName = 'Workshop_AdditionalWorkbench';

	return Template;
}

function bool IsBreakthroughAdditionalWorkbenchCostReductionAvailable()
{
	return IsFacilityUpgradeCostReductionAvailable('Workshop_AdditionalWorkbench');
}

static function X2DataTemplate CreateBreakthroughAdditionalResearchStationCostReductionTemplate()
{
	local X2TechTemplate Template;

	Template = CreateBreakthroughTechTemplate('BreakthroughAdditionalResearchStationCostReduction');
	Template.strImage = "img:///UILibrary_XPACK_Common.BT_laboratory2";
	Template.ResearchCompletedFn = BreakthroughFacilityUpgradeDiscountCompleted;
	Template.GetValueFn = GetValueFacilityUpgradeCostReduction;

	Template.Requirements.SpecialRequirementsFn = IsBreakthroughAdditionalResearchStationCostReductionAvailable;
	Template.RewardName = 'Laboratory_AdditionalResearchStation';

	return Template;
}

function bool IsBreakthroughAdditionalResearchStationCostReductionAvailable()
{
	return IsFacilityUpgradeCostReductionAvailable('Laboratory_AdditionalResearchStation');
}

static function X2DataTemplate CreateBreakthroughPowerConduitCostReductionTemplate()
{
	local X2TechTemplate Template;

	Template = CreateBreakthroughTechTemplate('BreakthroughPowerConduitCostReduction');
	Template.strImage = "img:///UILibrary_XPACK_Common.BT_powerrelay2";
	Template.ResearchCompletedFn = BreakthroughFacilityUpgradeDiscountCompleted;
	Template.GetValueFn = GetValueFacilityUpgradeCostReduction;

	Template.Requirements.SpecialRequirementsFn = IsBreakthroughPowerConduitCostReductionAvailable;
	Template.RewardName = 'PowerRelay_PowerConduit';

	return Template;
}

function bool IsBreakthroughPowerConduitCostReductionAvailable()
{
	return IsFacilityUpgradeCostReductionAvailable('PowerRelay_PowerConduit');
}

static function X2DataTemplate CreateBreakthroughEleriumConduitCostReductionTemplate()
{
	local X2TechTemplate Template;

	Template = CreateBreakthroughTechTemplate('BreakthroughEleriumConduitCostReduction');
	Template.strImage = "img:///UILibrary_XPACK_Common.BT_powerrelay2";
	Template.ResearchCompletedFn = BreakthroughFacilityUpgradeDiscountCompleted;
	Template.GetValueFn = GetValueFacilityUpgradeCostReduction;

	Template.Requirements.SpecialRequirementsFn = IsBreakthroughEleriumConduitCostReductionAvailable;
	Template.RewardName = 'PowerRelay_EleriumConduit';

	return Template;
}

function bool IsBreakthroughEleriumConduitCostReductionAvailable()
{
	return IsFacilityUpgradeCostReductionAvailable('PowerRelay_EleriumConduit');
}

static function X2DataTemplate CreateBreakthroughAdditionalCommStationCostReductionTemplate()
{
	local X2TechTemplate Template;

	Template = CreateBreakthroughTechTemplate('BreakthroughAdditionalCommStationCostReduction');
	Template.strImage = "img:///UILibrary_XPACK_Common.BT_resistancecomms2";
	Template.ResearchCompletedFn = BreakthroughFacilityUpgradeDiscountCompleted;
	Template.GetValueFn = GetValueFacilityUpgradeCostReduction;

	Template.Requirements.SpecialRequirementsFn = IsBreakthroughAdditionalCommStationCostReductionAvailable;
	Template.RewardName = 'ResistanceComms_AdditionalCommStation';

	return Template;
}

function bool IsBreakthroughAdditionalCommStationCostReductionAvailable()
{
	return IsFacilityUpgradeCostReductionAvailable('ResistanceComms_AdditionalCommStation');
}

static function X2DataTemplate CreateBreakthroughQuadTurretsCostReductionTemplate()
{
	local X2TechTemplate Template;

	Template = CreateBreakthroughTechTemplate('BreakthroughQuadTurretsCostReduction');
	Template.strImage = "img:///UILibrary_XPACK_Common.BT_defensematrix2";
	Template.ResearchCompletedFn = BreakthroughFacilityUpgradeDiscountCompleted;
	Template.GetValueFn = GetValueFacilityUpgradeCostReduction;

	Template.Requirements.SpecialRequirementsFn = IsBreakthroughQuadTurretsCostReductionAvailable;
	Template.RewardName = 'DefenseFacility_QuadTurrets';

	return Template;
}

function bool IsBreakthroughQuadTurretsCostReductionAvailable()
{
	return IsFacilityUpgradeCostReductionAvailable('DefenseFacility_QuadTurrets');
}

static function X2DataTemplate CreateBreakthroughSecondCellCostReductionTemplate()
{
	local X2TechTemplate Template;

	Template = CreateBreakthroughTechTemplate('BreakthroughSecondCellCostReduction');
	Template.strImage = "img:///UILibrary_XPACK_Common.BT_psilab2";
	Template.ResearchCompletedFn = BreakthroughFacilityUpgradeDiscountCompleted;
	Template.GetValueFn = GetValueFacilityUpgradeCostReduction;

	Template.Requirements.SpecialRequirementsFn = IsBreakthroughSecondCellCostReductionAvailable;
	Template.RewardName = 'PsiChamber_SecondCell';

	return Template;
}

function bool IsBreakthroughSecondCellCostReductionAvailable()
{
	return IsFacilityUpgradeCostReductionAvailable('PsiChamber_SecondCell');
}

static function X2DataTemplate CreateBreakthroughRingUpgradeICostReductionTemplate()
{
	local X2TechTemplate Template;

	Template = CreateBreakthroughTechTemplate('BreakthroughRingUpgradeICostReduction');
	Template.strImage = "img:///UILibrary_XPACK_Common.BT_resistancering2";
	Template.ResearchCompletedFn = BreakthroughFacilityUpgradeDiscountCompleted;
	Template.GetValueFn = GetValueFacilityUpgradeCostReduction;

	Template.Requirements.SpecialRequirementsFn = IsBreakthroughRingUpgradeICostReductionAvailable;
	Template.RewardName = 'ResistanceRing_UpgradeI';

	return Template;
}

function bool IsBreakthroughRingUpgradeICostReductionAvailable()
{
	return IsFacilityUpgradeCostReductionAvailable('ResistanceRing_UpgradeI');
}

static function X2DataTemplate CreateBreakthroughRingUpgradeIICostReductionTemplate()
{
	local X2TechTemplate Template;

	Template = CreateBreakthroughTechTemplate('BreakthroughRingUpgradeIICostReduction');
	Template.strImage = "img:///UILibrary_XPACK_Common.BT_resistancering2";
	Template.ResearchCompletedFn = BreakthroughFacilityUpgradeDiscountCompleted;
	Template.GetValueFn = GetValueFacilityUpgradeCostReduction;

	Template.Requirements.SpecialRequirementsFn = IsBreakthroughRingUpgradeIICostReductionAvailable;
	Template.RewardName = 'ResistanceRing_UpgradeI';

	return Template;
}

function bool IsBreakthroughRingUpgradeIICostReductionAvailable()
{
	return IsFacilityUpgradeCostReductionAvailable('ResistanceRing_UpgradeII');
}

static function X2DataTemplate CreateBreakthroughRecoveryChamberCostReductionTemplate()
{
	local X2TechTemplate Template;

	Template = CreateBreakthroughTechTemplate('BreakthroughRecoveryChamberCostReduction');
	Template.strImage = "img:///UILibrary_XPACK_Common.BT_AWC2";
	Template.ResearchCompletedFn = BreakthroughFacilityUpgradeDiscountCompleted;
	Template.GetValueFn = GetValueFacilityUpgradeCostReduction;

	Template.Requirements.SpecialRequirementsFn = IsBreakthroughRecoveryChamberCostReductionAvailable;
	Template.RewardName = 'Infirmary_RecoveryChamber';

	return Template;
}

function bool IsBreakthroughRecoveryChamberCostReductionAvailable()
{
	return IsFacilityUpgradeCostReductionAvailable('Infirmary_RecoveryChamber');
}

////////////////////////
// Strategy Modifiers //
////////////////////////

static function X2DataTemplate CreateBreakthroughReuseWeaponUpgradesTemplate()
{
	local X2TechTemplate Template;

	Template = CreateBreakthroughTechTemplate('BreakthroughReuseWeaponUpgrades');
	Template.strImage = "img:///UILibrary_XPACK_Common.BT_modreuse";
	Template.ResearchCompletedFn = BreakthroughReuseWeaponUpgradesCompleted;

	return Template;
}

function BreakthroughReuseWeaponUpgradesCompleted(XComGameState NewGameState, XComGameState_Tech TechState)
{
	local XComGameState_HeadquartersXCom XComHQ;

	XComHQ = GetNewXComHQState(NewGameState);
	XComHQ.bReuseUpgrades = true;
}

static function X2DataTemplate CreateBreakthroughReusePCSTemplate()
{
	local X2TechTemplate Template;

	Template = CreateBreakthroughTechTemplate('BreakthroughReusePCS');
	Template.strImage = "img:///UILibrary_XPACK_Common.BT_pcsreuse";
	Template.ResearchCompletedFn = BreakthroughReusePCSCompleted;

	return Template;
}

function BreakthroughReusePCSCompleted(XComGameState NewGameState, XComGameState_Tech TechState)
{
	local XComGameState_HeadquartersXCom XComHQ;

	XComHQ = GetNewXComHQState(NewGameState);
	XComHQ.bReusePCS = true;
}

static function X2DataTemplate CreateBreakthroughProvingGroundProjectCostReductionM1Template()
{
	local X2TechTemplate Template;

	Template = CreateBreakthroughTechTemplate('BreakthroughProvingGroundProjectCostReductionM1');
	Template.strImage = "img:///UILibrary_XPACK_Common.BT_provinggrounds";
	Template.ResearchCompletedFn = BreakthroughProvingGroundProjectCostReductionM1Completed;
	Template.GetValueFn = GetValueProvingGroundProjectCostReductionM1;

	Template.Requirements.RequiredFacilities.AddItem('ProvingGround');

	return Template;
}

function BreakthroughProvingGroundProjectCostReductionM1Completed(XComGameState NewGameState, XComGameState_Tech TechState)
{
	local XComGameState_HeadquartersXCom XComHQ;

	XComHQ = GetNewXComHQState(NewGameState);
	XComHQ.ProvingGroundPercentDiscount += `ScaleStrategyArrayInt(default.ProvingGroundProjectCostReductionM1Bonus);
}

function int GetValueProvingGroundProjectCostReductionM1()
{
	return `ScaleStrategyArrayInt(default.ProvingGroundProjectCostReductionM1Bonus);
}

static function X2DataTemplate CreateBreakthroughProvingGroundProjectCostReductionM2Template()
{
	local X2TechTemplate Template;

	Template = CreateBreakthroughTechTemplate('BreakthroughProvingGroundProjectCostReductionM2');
	Template.strImage = "img:///UILibrary_XPACK_Common.BT_provinggrounds";
	Template.ResearchCompletedFn = BreakthroughProvingGroundProjectCostReductionM2Completed;
	Template.GetValueFn = GetValueProvingGroundProjectCostReductionM2;

	Template.Requirements.RequiredTechs.AddItem('BreakthroughProvingGroundProjectCostReductionM1');
	Template.Requirements.RequiredFacilities.AddItem('ProvingGround');

	return Template;
}

function BreakthroughProvingGroundProjectCostReductionM2Completed(XComGameState NewGameState, XComGameState_Tech TechState)
{
	local XComGameState_HeadquartersXCom XComHQ;

	XComHQ = GetNewXComHQState(NewGameState);
	XComHQ.ProvingGroundPercentDiscount += `ScaleStrategyArrayInt(default.ProvingGroundProjectCostReductionM2Bonus);
}

function int GetValueProvingGroundProjectCostReductionM2()
{
	return `ScaleStrategyArrayInt(default.ProvingGroundProjectCostReductionM2Bonus);
}

static function X2DataTemplate CreateBreakthroughGTSUnlockCostReductionM1Template()
{
	local X2TechTemplate Template;

	Template = CreateBreakthroughTechTemplate('BreakthroughGTSUnlockCostReductionM1');
	Template.strImage = "img:///UILibrary_XPACK_Common.BT_gts";
	Template.ResearchCompletedFn = BreakthroughGTSUnlockCostReductionM1Completed;
	Template.GetValueFn = GetValueGTSUnlockCostReductionM1;

	Template.Requirements.RequiredFacilities.AddItem('OfficerTrainingSchool');

	return Template;
}

function BreakthroughGTSUnlockCostReductionM1Completed(XComGameState NewGameState, XComGameState_Tech TechState)
{
	local XComGameState_HeadquartersXCom XComHQ;

	XComHQ = GetNewXComHQState(NewGameState);
	XComHQ.GTSPercentDiscount += `ScaleStrategyArrayInt(default.GTSUnlockCostReductionM1Bonus);
}

function int GetValueGTSUnlockCostReductionM1()
{
	return `ScaleStrategyArrayInt(default.GTSUnlockCostReductionM1Bonus);
}

static function X2DataTemplate CreateBreakthroughGTSUnlockCostReductionM2Template()
{
	local X2TechTemplate Template;

	Template = CreateBreakthroughTechTemplate('BreakthroughGTSUnlockCostReductionM2');
	Template.strImage = "img:///UILibrary_XPACK_Common.BT_gts";
	Template.ResearchCompletedFn = BreakthroughGTSUnlockCostReductionM2Completed;
	Template.GetValueFn = GetValueGTSUnlockCostReductionM2;

	Template.Requirements.RequiredTechs.AddItem('BreakthroughGTSUnlockCostReductionM1');
	Template.Requirements.RequiredFacilities.AddItem('OfficerTrainingSchool');

	return Template;
}

function BreakthroughGTSUnlockCostReductionM2Completed(XComGameState NewGameState, XComGameState_Tech TechState)
{
	local XComGameState_HeadquartersXCom XComHQ;

	XComHQ = GetNewXComHQState(NewGameState);
	XComHQ.GTSPercentDiscount += `ScaleStrategyArrayInt(default.GTSUnlockCostReductionM2Bonus);
}

function int GetValueGTSUnlockCostReductionM2()
{
	return `ScaleStrategyArrayInt(default.GTSUnlockCostReductionM2Bonus);
}

static function X2DataTemplate CreateBreakthroughInstantExcavationTemplate()
{
	local X2TechTemplate Template;

	Template = CreateBreakthroughTechTemplate('BreakthroughInstantExcavation');
	Template.strImage = "img:///UILibrary_XPACK_Common.BT_excavation";
	Template.ResearchCompletedFn = BreakthroughInstantExcavationCompleted;

	Template.Requirements.SpecialRequirementsFn = IsBreakthroughInstantExcavationAvailable;

	return Template;
}

function bool IsBreakthroughInstantExcavationAvailable()
{
	local XComGameState_HeadquartersXCom XComHQ;

	XComHQ = XComGameState_HeadquartersXCom(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
	return XComHQ.HasUnexcavatedRoom();
}

function BreakthroughInstantExcavationCompleted(XComGameState NewGameState, XComGameState_Tech TechState)
{
	local XComGameState_HeadquartersXCom XComHQ;

	XComHQ = XComGameState_HeadquartersXCom(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
	XComHQ = XComGameState_HeadquartersXCom( NewGameState.ModifyStateObject( class'XComGameState_HeadquartersXCom', XComHQ.ObjectID ) );

	XComHQ.bInstantSingleExcavation = true;
}

// #######################################################################################
// -------------------- HELPER FUNCTIONS -------------------------------------------------
// #######################################################################################

static function X2TechTemplate CreateBreakthroughTechTemplate(name TechName)
{
	local X2TechTemplate Template;

	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, TechName);
	Template.PointsToComplete = StafferXDays(1, 5);
	Template.SortingTier = 1;
	Template.bBreakthrough = true;
	
	return Template;
}

function bool IsFacilityCostReductionAvailable(name TemplateName)
{
	local XComGameState_HeadquartersXCom XComHQ;
	local array<X2FacilityTemplate> BuildableFacilityTemplates;
	local X2FacilityTemplate FacilityTemplate;
		
	XComHQ = XComGameState_HeadquartersXCom(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
	if (!XComHQ.HasFacilityByName(TemplateName))
	{
		BuildableFacilityTemplates = class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager().GetBuildableFacilityTemplates();
		foreach BuildableFacilityTemplates(FacilityTemplate)
		{
			if (FacilityTemplate.DataName == TemplateName)
			{
				return true;
			}
		}
	}

	return false;
}

function int GetValueFacilityCostReduction()
{
	return `ScaleStrategyArrayInt(default.FacilityCostReductionBonus);
}

function bool IsFacilityUpgradeCostReductionAvailable(name TemplateName)
{
	local array<X2FacilityUpgradeTemplate> BuildableUpgradeTemplates;
	local X2FacilityUpgradeTemplate UpgradeTemplate;

	BuildableUpgradeTemplates = class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager().GetBuildableFacilityUpgradeTemplates();
	foreach BuildableUpgradeTemplates(UpgradeTemplate)
	{
		if (UpgradeTemplate.DataName == TemplateName)
		{
			return true;
		}
	}

	return false;
}

function int GetValueFacilityUpgradeCostReduction()
{
	return `ScaleStrategyArrayInt(default.FacilityUpgradeCostReductionBonus);
}