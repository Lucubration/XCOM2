//---------------------------------------------------------------------------------------
//  FILE:    X2Item_XpackResources.uc
//  AUTHOR:  Mark Nauta  --  07/20/2016
//  PURPOSE: Create Xpack resource item templates
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class X2Item_XpackResources extends X2Item;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Resources;

	Resources.AddItem(CreateChosenInformationTemplate());
	Resources.AddItem(CreateAbilityPointTemplate());

	// Stat Boost Items
	Resources.AddItem(CreateStatBoostHPTemplate());
	Resources.AddItem(CreateStatBoostMobilityTemplate());
	Resources.AddItem(CreateStatBoostAimTemplate());
	Resources.AddItem(CreateStatBoostWillTemplate());
	Resources.AddItem(CreateStatBoostDodgeTemplate());
	Resources.AddItem(CreateStatBoostHackingTemplate());

	// Corpses
	Resources.AddItem(CreateCorpseSpectre());
	Resources.AddItem(CreateCorpseAdventPurifier());
	Resources.AddItem(CreateCorpseAdventPriest());
	Resources.AddItem(CreateCorpseTheLost());

	// Mission Quest Item Loot
	Resources.AddItem(CreateChosenAssassinShotgun());
	Resources.AddItem(CreateChosenAssassinSword());
	Resources.AddItem(CreateChosenHunterSniperRifle());
	Resources.AddItem(CreateChosenHunterPistol());
	Resources.AddItem(CreateChosenWarlockRifle());

	Resources.AddItem(CreateRescueCivilianRewardTemplate());

	//	Special Loot
	Resources.AddItem(BasicFocusLoot());

	return Resources;
}

static function X2DataTemplate CreateChosenInformationTemplate()
{
	local X2ItemTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ItemTemplate', Template, 'ChosenInformation');
	
	Template.ItemCat = 'resource';
	Template.CanBeBuilt = false;
	Template.HideInInventory = true;
	Template.HideInLootRecovered = true;
	Template.bOneTimeBuild = false;
	Template.bBlocked = false;
	Template.OnAcquiredFn = OnChosenInformationAcquired;
	Template.strImage = "img:///UILibrary_XPACK_StrategyImages.Inv_ChosenFragments";

	// Requirements
	Template.Requirements.SpecialRequirementsFn = IsChosenInfoRewardAvailable;

	return Template;
}

static function bool IsChosenInfoRewardAvailable()
{
	local XComGameStateHistory History;
	local XComGameState_AdventChosen ChosenState;

	History = `XCOMHISTORY;

	foreach History.IterateByClassType(class'XComGameState_AdventChosen', ChosenState)
	{
		// Must be a active chosen not at max awareness
		if (ChosenState.GetRivalFaction().bMetXCom && ChosenState.bMetXCom && !ChosenState.bDefeated && !ChosenState.IsStrongholdMissionAvailable())
		{
			return true;
		}
	}

	return false;
}

static function bool OnChosenInformationAcquired(XComGameState NewGameState, XComGameState_Item ItemState)
{ 
	local XComGameStateHistory History;
	local XComGameState_AdventChosen ChosenState;
	local XComGameState_ResistanceFaction FactionState;
	local XComGameState_CovertAction ActionState;
	local StateObjectReference ActionRef;

	History = `XCOMHISTORY;

	foreach History.IterateByClassType(class'XComGameState_AdventChosen', ChosenState)
	{
		if(ChosenState.GetReference() == ItemState.LinkedEntity)
		{
			FactionState = ChosenState.GetRivalFaction();
			
			foreach FactionState.GoldenPathActions(ActionRef)
			{
				// Search for a "Hunt the Chosen" covert action
				ActionState = XComGameState_CovertAction(History.GetGameStateForObjectID(ActionRef.ObjectID));
				if (!ActionState.bCompleted && ActionState.CanActionBeDisplayed())
				{
					ActionState = XComGameState_CovertAction(NewGameState.ModifyStateObject(class'XComGameState_CovertAction', ActionRef.ObjectID));
					ActionState.ModifyRemainingTime(0.5); // Cut the remaining time in half
					
					return true; // Should only ever have one Hunt Chosen Action available at a time, so return after modifying one
				}
			}
		}
	}

	return false;
}

static function X2DataTemplate CreateAbilityPointTemplate()
{
	local X2ItemTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ItemTemplate', Template, 'AbilityPoint');
	Template.CanBeBuilt = false;
	Template.HideInInventory = true;

	Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_Supplies";
	Template.ItemCat = 'resource';

	return Template;
}

static function X2DataTemplate CreateStatBoostHPTemplate()
{
	local X2EquipmentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2EquipmentTemplate', Template, 'StatBoost_HP');

	Template.ItemCat = 'resource';
	Template.CanBeBuilt = false;
	Template.HideInInventory = true;
	Template.HideInLootRecovered = true;
	Template.OnAcquiredFn = OnStatBoostAcquired;
	Template.StatsToBoost.AddItem(eStat_HP);
	Template.StatBoostPowerLevel = 4;
	Template.bUseBoostIncrement = true;

	return Template;
}

static function X2DataTemplate CreateStatBoostAimTemplate()
{
	local X2EquipmentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2EquipmentTemplate', Template, 'StatBoost_Aim');

	Template.ItemCat = 'resource';
	Template.CanBeBuilt = false;
	Template.HideInInventory = true;
	Template.HideInLootRecovered = true;
	Template.OnAcquiredFn = OnStatBoostAcquired;
	Template.StatsToBoost.AddItem(eStat_Offense);
	Template.StatBoostPowerLevel = 4;

	return Template;
}

static function X2DataTemplate CreateStatBoostMobilityTemplate()
{
	local X2EquipmentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2EquipmentTemplate', Template, 'StatBoost_Mobility');

	Template.ItemCat = 'resource';
	Template.CanBeBuilt = false;
	Template.HideInInventory = true;
	Template.HideInLootRecovered = true;
	Template.OnAcquiredFn = OnStatBoostAcquired;
	Template.StatsToBoost.AddItem(eStat_Mobility);
	Template.StatBoostPowerLevel = 4;
	Template.bUseBoostIncrement = true;

	return Template;
}

static function X2DataTemplate CreateStatBoostDodgeTemplate()
{
	local X2EquipmentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2EquipmentTemplate', Template, 'StatBoost_Dodge');

	Template.ItemCat = 'resource';
	Template.CanBeBuilt = false;
	Template.HideInInventory = true;
	Template.HideInLootRecovered = true;
	Template.OnAcquiredFn = OnStatBoostAcquired;
	Template.StatsToBoost.AddItem(eStat_Dodge);
	Template.StatBoostPowerLevel = 4;

	return Template;
}

static function X2DataTemplate CreateStatBoostWillTemplate()
{
	local X2EquipmentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2EquipmentTemplate', Template, 'StatBoost_Will');

	Template.ItemCat = 'resource';
	Template.CanBeBuilt = false;
	Template.HideInInventory = true;
	Template.HideInLootRecovered = true;
	Template.OnAcquiredFn = OnStatBoostAcquired;
	Template.StatsToBoost.AddItem(eStat_Will);
	Template.StatBoostPowerLevel = 4;

	return Template;
}

static function X2DataTemplate CreateStatBoostHackingTemplate()
{
	local X2EquipmentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2EquipmentTemplate', Template, 'StatBoost_Hacking');

	Template.ItemCat = 'resource';
	Template.CanBeBuilt = false;
	Template.HideInInventory = true;
	Template.HideInLootRecovered = true;
	Template.OnAcquiredFn = OnStatBoostAcquired;
	Template.StatsToBoost.AddItem(eStat_Hacking);
	Template.StatBoostPowerLevel = 4;

	return Template;
}

static function bool OnStatBoostAcquired(XComGameState NewGameState, XComGameState_Item ItemState)
{
	local XComGameState_Unit UnitState;
	local StatBoost ItemStatBoost;
	local float NewMaxStat;
	
	UnitState = XComGameState_Unit(NewGameState.GetGameStateForObjectID(ItemState.LinkedEntity.ObjectID));
	if (UnitState == none)
	{
		UnitState = XComGameState_Unit(NewGameState.ModifyStateObject(class'XComGameState_Unit', ItemState.LinkedEntity.ObjectID));
	}
	
	if (UnitState == none)
	{
		// Should not happen if the item is set up as a reward properly
		`RedScreen("Tried to give a stat boost item, but there is no linked unit to increase stats @gameplay @jweinhoffer");
		return false;
	}

	foreach ItemState.StatBoosts(ItemStatBoost)
	{
		NewMaxStat = int(UnitState.GetMaxStat(ItemStatBoost.StatType) + ItemStatBoost.Boost);

		if ((ItemStatBoost.StatType == eStat_HP) && `SecondWaveEnabled('BetaStrike'))
		{
			NewMaxStat += ItemStatBoost.Boost * (class'X2StrategyGameRulesetDataStructures'.default.SecondWaveBetaStrikeHealthMod - 1.0);
		}

		UnitState.SetBaseMaxStat(ItemStatBoost.StatType, NewMaxStat);
		
		if (ItemStatBoost.StatType != eStat_HP || !UnitState.IsInjured())
		{
			UnitState.SetCurrentStat(ItemStatBoost.StatType, NewMaxStat);
		}
	}

	return true;
}

static function X2DataTemplate CreateCorpseSpectre()
{
	local X2ItemTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ItemTemplate', Template, 'CorpseSpectre');

	Template.strImage = "img:///UILibrary_XPACK_StrategyImages.Corpse_Spectre";
	Template.ItemCat = 'resource';
	Template.TradingPostValue = 5;
	Template.MaxQuantity = 6;
	Template.LeavesExplosiveRemains = true;
	
	return Template;
}

static function X2DataTemplate CreateCorpseAdventPurifier()
{
	local X2ItemTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ItemTemplate', Template, 'CorpseAdventPurifier');

//BEGIN AUTOGENERATED CODE: Template Overrides 'CorpseAdventPurifier'
	Template.strImage = "img:///UILibrary_XPACK_StrategyImages.Corpse_Advent_Purifier";
//END AUTOGENERATED CODE: Template Overrides 'CorpseAdventPurifier'
	Template.ItemCat = 'resource';
	Template.TradingPostValue = 3;
	Template.MaxQuantity = 1;
	Template.LeavesExplosiveRemains = true;

	return Template;
}

static function X2DataTemplate CreateCorpseAdventPriest()
{
	local X2ItemTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ItemTemplate', Template, 'CorpseAdventPriest');

//BEGIN AUTOGENERATED CODE: Template Overrides 'CorpseAdventPriest'
	Template.strImage = "img:///UILibrary_XPACK_StrategyImages.Corpse_Advent_Priest";
//END AUTOGENERATED CODE: Template Overrides 'CorpseAdventPriest'
	Template.ItemCat = 'resource';
	Template.TradingPostValue = 4;
	Template.MaxQuantity = 1;
	Template.LeavesExplosiveRemains = true;

	return Template;
}

static function X2DataTemplate CreateCorpseTheLost()
{
	local X2ItemTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ItemTemplate', Template, 'CorpseTheLost');

	Template.strImage = "img:///UILibrary_XPACK_StrategyImages.Corpse_Lost";
	Template.ItemCat = 'resource';
	Template.TradingPostValue = 0;
	Template.MaxQuantity = 1;
	Template.LeavesExplosiveRemains = true;

	return Template;
}

///////////////////////////////////////////////////////////////////
// Mission Loot Items

static function X2DataTemplate CreateChosenAssassinShotgun()
{
	local X2ItemTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ItemTemplate', Template, 'ChosenAssassinShotgun');

//BEGIN AUTOGENERATED CODE: Template Overrides 'ChosenAssassinShotgun'
	Template.strImage = "img:///UILibrary_XPACK_StrategyImages.Inv_Chosen_Shotgun";
//END AUTOGENERATED CODE: Template Overrides 'ChosenAssassinShotgun'
	Template.ItemCat = 'goldenpath';
	Template.CanBeBuilt = false;
	Template.HideInInventory = false;
	Template.bOneTimeBuild = false;
	Template.bBlocked = false;

	return Template;
}

static function X2DataTemplate CreateChosenAssassinSword()
{
	local X2ItemTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ItemTemplate', Template, 'ChosenAssassinSword');

//BEGIN AUTOGENERATED CODE: Template Overrides 'ChosenAssassinSword'
	Template.strImage = "img:///UILibrary_XPACK_StrategyImages.Inv_Chosen_Sword";
//END AUTOGENERATED CODE: Template Overrides 'ChosenAssassinSword'
	Template.ItemCat = 'goldenpath';
	Template.CanBeBuilt = false;
	Template.HideInInventory = false;
	Template.bOneTimeBuild = false;
	Template.bBlocked = false;

	return Template;
}

static function X2DataTemplate CreateChosenHunterSniperRifle()
{
	local X2ItemTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ItemTemplate', Template, 'ChosenHunterSniperRifle');

//BEGIN AUTOGENERATED CODE: Template Overrides 'ChosenHunterSniperRifle'
	Template.strImage = "img:///UILibrary_XPACK_StrategyImages.Inv_Chosen_Sniper";
//END AUTOGENERATED CODE: Template Overrides 'ChosenHunterSniperRifle'
	Template.ItemCat = 'goldenpath';
	Template.CanBeBuilt = false;
	Template.HideInInventory = false;
	Template.bOneTimeBuild = false;
	Template.bBlocked = false;

	return Template;
}

static function X2DataTemplate CreateChosenHunterPistol()
{
	local X2ItemTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ItemTemplate', Template, 'ChosenHunterPistol');

//BEGIN AUTOGENERATED CODE: Template Overrides 'ChosenHunterPistol'
	Template.strImage = "img:///UILibrary_XPACK_StrategyImages.Inv_Chosen_Pistol";
//END AUTOGENERATED CODE: Template Overrides 'ChosenHunterPistol'
	Template.ItemCat = 'goldenpath';
	Template.CanBeBuilt = false;
	Template.HideInInventory = false;
	Template.bOneTimeBuild = false;
	Template.bBlocked = false;

	return Template;
}

static function X2DataTemplate CreateChosenWarlockRifle()
{
	local X2ItemTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ItemTemplate', Template, 'ChosenWarlockRifle');

//BEGIN AUTOGENERATED CODE: Template Overrides 'ChosenWarlockRifle'
	Template.strImage = "img:///UILibrary_XPACK_StrategyImages.Inv_Chosen_AssaultRifle";
//END AUTOGENERATED CODE: Template Overrides 'ChosenWarlockRifle'
	Template.ItemCat = 'goldenpath';
	Template.CanBeBuilt = false;
	Template.HideInInventory = false;
	Template.bOneTimeBuild = false;
	Template.bBlocked = false;

	return Template;
}

static function X2DataTemplate CreateRescueCivilianRewardTemplate()
{
	local X2ItemTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ItemTemplate', Template, 'RescueCivilianReward');
	
	Template.ItemCat = 'quest';
	Template.CanBeBuilt = false;
	Template.strImage = "img:///UILibrary_StrategyImages.X2StrategyMap.Alert_Resistance_Ops_Appear";
	Template.HideInInventory = true;
	Template.bOneTimeBuild = false;
	Template.OnAcquiredFn = OnRescueCivilianRewardAcquired;

	return Template;
}

static function bool OnRescueCivilianRewardAcquired(XComGameState NewGameState, XComGameState_Item ItemState)
{
	local XComGameStateHistory History;
	local X2StrategyElementTemplateManager StratMgr;
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_MissionSite MissionState;
	local XComGameState_Reward RewardState;
	local XComGameState_WorldRegion RegionState;
	local X2RewardTemplate RewardTemplate;
	local int RewardAmount;
	local XGParamTag ParamTag;

	History = `XCOMHISTORY;
	StratMgr = class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager();
	XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
	MissionState = XComGameState_MissionSite(History.GetGameStateForObjectID(XComHQ.MissionRef.ObjectID));
	
	// This resource should only be given during loot after missions, so this should be valid
	if (MissionState != none)
	{
		RegionState = MissionState.GetWorldRegion();
		ParamTag = XGParamTag(`XEXPANDCONTEXT.FindTag("XGParam"));
		
		// Increase region income per civilian rescued
		RewardAmount = ItemState.Quantity * class'X2StrategyElement_XpackRewards'.static.GetRescueCivilianIncomeIncreaseReward();

		RewardTemplate = X2RewardTemplate(StratMgr.FindStrategyElementTemplate('Reward_IncreaseIncome'));
		RewardState = RewardTemplate.CreateInstanceFromTemplate(NewGameState);
		RewardState.GenerateReward(NewGameState, , RegionState.GetReference());
		RewardState.SetReward(, RewardAmount); 
		RewardState.GiveReward(NewGameState);

		ParamTag.StrValue0 = RegionState.GetMyTemplate().DisplayName;
		class'XComGameState_HeadquartersResistance'.static.AddGlobalEffectString(NewGameState, `XEXPAND.ExpandString(class'UIRewardsRecap'.default.m_strIncreasedRegionSupplyOutput), false);
		ParamTag.StrValue0 = string(RewardAmount);
		class'XComGameState_HeadquartersResistance'.static.AddGlobalEffectString(NewGameState, `XEXPAND.ExpandString(class'UIRewardsRecap'.default.m_strIncreasedSupplyIncome), false);
	}
			
	return true;
}

static function X2FocusLootItemTemplate BasicFocusLoot()
{
	local X2FocusLootItemTemplate Template;

	`CREATE_X2TEMPLATE(class'X2FocusLootItemTemplate', Template, 'BasicFocusLoot');	
	Template.LootStaticMesh = None;
	Template.LootParticleSystem = ParticleSystem'FX_Psi_Loot.P_Psi_Loot_Persistent';
	Template.HideInInventory = true;
	Template.HideInLootRecovered = true;
//BEGIN AUTOGENERATED CODE: Template Overrides 'BasicFocusLoot'
	Template.LootParticleSystemEnding = ParticleSystem'FX_Psi_Loot.P_Psi_Loot_Expired';
//END AUTOGENERATED CODE: Template Overrides 'BasicFocusLoot'

	return Template;
}
