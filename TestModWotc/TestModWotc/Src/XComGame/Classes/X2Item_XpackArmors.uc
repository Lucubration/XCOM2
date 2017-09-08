class X2Item_XpackArmors extends X2Item;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Armors;
	
	Armors.AddItem(CreateReaperArmor());
	Armors.AddItem(CreatePlatedReaperArmor());
	Armors.AddItem(CreatePoweredReaperArmor());

	Armors.AddItem(CreateSkirmisherArmor());
	Armors.AddItem(CreatePlatedSkirmisherArmor());
	Armors.AddItem(CreatePoweredSkirmisherArmor());

	Armors.AddItem(CreateTemplarArmor());
	Armors.AddItem(CreatePlatedTemplarArmor());
	Armors.AddItem(CreatePoweredTemplarArmor());

	return Armors;
}

static function X2DataTemplate CreateReaperArmor()
{
	local X2ArmorTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ArmorTemplate', Template, 'ReaperArmor');
	Template.strImage = "img:///UILibrary_XPACK_StrategyImages.Inv_HORArmorConv";
	Template.StartingItem = false;
	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;
	Template.ArmorTechCat = 'conventional';
	Template.ArmorCat = 'reaper';
	Template.Tier = 0;
	Template.AkAudioSoldierArmorSwitch = 'Conventional';
	Template.EquipSound = "StrategyUI_Armor_Equip_Conventional";

	Template.SetUIStatMarkup(class'XLocalizedData'.default.HealthLabel, eStat_HP, 0, true);

	return Template;
}

static function X2DataTemplate CreatePlatedReaperArmor()
{
	local X2ArmorTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ArmorTemplate', Template, 'PlatedReaperArmor');
	Template.strImage = "img:///UILibrary_XPACK_StrategyImages.Inv_HORArmorPlat";
	Template.ItemCat = 'armor';
	Template.bAddsUtilitySlot = false;
	Template.StartingItem = false;
	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;
	Template.TradingPostValue = 20;
	Template.PointsToComplete = 0;
	Template.Abilities.AddItem('MediumPlatedArmorStats');
	Template.ArmorTechCat = 'plated';
	Template.ArmorCat = 'reaper';
	Template.Tier = 1;
	Template.AkAudioSoldierArmorSwitch = 'Predator';
	Template.EquipNarrative = "X2NarrativeMoments.Strategy.CIN_ArmorIntro_PlatedMedium";
	Template.EquipSound = "StrategyUI_Armor_Equip_Plated";

	Template.CreatorTemplateName = 'MediumPlatedArmor_Schematic'; // The schematic which creates this item
	Template.BaseItem = 'ReaperArmor'; // Which item this will be upgraded from

	Template.SetUIStatMarkup(class'XLocalizedData'.default.HealthLabel, eStat_HP, class'X2Ability_ItemGrantedAbilitySet'.default.MEDIUM_PLATED_HEALTH_BONUS, true);

	return Template;
}

static function X2DataTemplate CreatePoweredReaperArmor()
{
	local X2ArmorTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ArmorTemplate', Template, 'PoweredReaperArmor');
	Template.strImage = "img:///UILibrary_XPACK_StrategyImages.Inv_HORArmorPowr";
	Template.ItemCat = 'armor';
	Template.bAddsUtilitySlot = false;
	Template.StartingItem = false;
	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;
	Template.TradingPostValue = 60;
	Template.PointsToComplete = 0;
	Template.Abilities.AddItem('MediumPoweredArmorStats');
	Template.ArmorTechCat = 'powered';
	Template.ArmorCat = 'reaper';
	Template.Tier = 3;
	Template.AkAudioSoldierArmorSwitch = 'Warden';
	Template.EquipNarrative = "X2NarrativeMoments.Strategy.CIN_ArmorIntro_PoweredMedium";
	Template.EquipSound = "StrategyUI_Armor_Equip_Powered";

	Template.CreatorTemplateName = 'MediumPoweredArmor_Schematic'; // The schematic which creates this item
	Template.BaseItem = 'PlatedReaperArmor'; // Which item this will be upgraded from

	Template.SetUIStatMarkup(class'XLocalizedData'.default.HealthLabel, eStat_HP, class'X2Ability_ItemGrantedAbilitySet'.default.MEDIUM_POWERED_HEALTH_BONUS, true);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.ArmorLabel, eStat_ArmorMitigation, class'X2Ability_ItemGrantedAbilitySet'.default.MEDIUM_POWERED_MITIGATION_AMOUNT);

	return Template;
}

static function X2DataTemplate CreateSkirmisherArmor()
{
	local X2ArmorTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ArmorTemplate', Template, 'SkirmisherArmor');
	Template.strImage = "img:///UILibrary_XPACK_StrategyImages.Inv_HORArmorConv";
	Template.StartingItem = false;
	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;
	Template.ArmorTechCat = 'conventional';
	Template.ArmorCat = 'skirmisher';
	Template.Tier = 0;
	Template.AkAudioSoldierArmorSwitch = 'Conventional';
	Template.EquipSound = "StrategyUI_Armor_Equip_Conventional";

	Template.SetUIStatMarkup(class'XLocalizedData'.default.HealthLabel, eStat_HP, 0, true);

	return Template;
}

static function X2DataTemplate CreatePlatedSkirmisherArmor()
{
	local X2ArmorTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ArmorTemplate', Template, 'PlatedSkirmisherArmor');
	Template.strImage = "img:///UILibrary_XPACK_StrategyImages.Inv_HORArmorPlat";
	Template.ItemCat = 'armor';
	Template.bAddsUtilitySlot = false;
	Template.StartingItem = false;
	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;
	Template.TradingPostValue = 20;
	Template.PointsToComplete = 0;
	Template.Abilities.AddItem('MediumPlatedArmorStats');
	Template.ArmorTechCat = 'plated';
	Template.ArmorCat = 'skirmisher';
	Template.Tier = 1;
	Template.AkAudioSoldierArmorSwitch = 'Predator';
	Template.EquipNarrative = "X2NarrativeMoments.Strategy.CIN_ArmorIntro_PlatedMedium";
	Template.EquipSound = "StrategyUI_Armor_Equip_Plated";

	Template.CreatorTemplateName = 'MediumPlatedArmor_Schematic'; // The schematic which creates this item
	Template.BaseItem = 'SkirmisherArmor'; // Which item this will be upgraded from

	Template.SetUIStatMarkup(class'XLocalizedData'.default.HealthLabel, eStat_HP, class'X2Ability_ItemGrantedAbilitySet'.default.MEDIUM_PLATED_HEALTH_BONUS, true);

	return Template;
}

static function X2DataTemplate CreatePoweredSkirmisherArmor()
{
	local X2ArmorTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ArmorTemplate', Template, 'PoweredSkirmisherArmor');
	Template.strImage = "img:///UILibrary_XPACK_StrategyImages.Inv_HORArmorPowr";
	Template.ItemCat = 'armor';
	Template.bAddsUtilitySlot = false;
	Template.StartingItem = false;
	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;
	Template.TradingPostValue = 60;
	Template.PointsToComplete = 0;
	Template.Abilities.AddItem('MediumPoweredArmorStats');
	Template.ArmorTechCat = 'powered';
	Template.ArmorCat = 'skirmisher';
	Template.Tier = 3;
	Template.AkAudioSoldierArmorSwitch = 'Warden';
	Template.EquipNarrative = "X2NarrativeMoments.Strategy.CIN_ArmorIntro_PoweredMedium";
	Template.EquipSound = "StrategyUI_Armor_Equip_Powered";

	Template.CreatorTemplateName = 'MediumPoweredArmor_Schematic'; // The schematic which creates this item
	Template.BaseItem = 'PlatedSkirmisherArmor'; // Which item this will be upgraded from

	Template.SetUIStatMarkup(class'XLocalizedData'.default.HealthLabel, eStat_HP, class'X2Ability_ItemGrantedAbilitySet'.default.MEDIUM_POWERED_HEALTH_BONUS, true);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.ArmorLabel, eStat_ArmorMitigation, class'X2Ability_ItemGrantedAbilitySet'.default.MEDIUM_POWERED_MITIGATION_AMOUNT);

	return Template;
}

static function X2DataTemplate CreateTemplarArmor()
{
	local X2ArmorTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ArmorTemplate', Template, 'TemplarArmor');
	Template.strImage = "img:///UILibrary_XPACK_StrategyImages.Inv_HORArmorConv";
	Template.StartingItem = false;
	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;
	Template.ArmorTechCat = 'conventional';
	Template.ArmorCat = 'templar';
	Template.Tier = 0;
	Template.AkAudioSoldierArmorSwitch = 'Conventional';
	Template.EquipSound = "StrategyUI_Armor_Equip_Conventional";

	Template.SetUIStatMarkup(class'XLocalizedData'.default.HealthLabel, eStat_HP, 0, true);

	return Template;
}

static function X2DataTemplate CreatePlatedTemplarArmor()
{
	local X2ArmorTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ArmorTemplate', Template, 'PlatedTemplarArmor');
	Template.strImage = "img:///UILibrary_XPACK_StrategyImages.Inv_HORArmorPlat";
	Template.ItemCat = 'armor';
	Template.bAddsUtilitySlot = false;
	Template.StartingItem = false;
	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;
	Template.TradingPostValue = 20;
	Template.PointsToComplete = 0;
	Template.Abilities.AddItem('MediumPlatedArmorStats');
	Template.ArmorTechCat = 'plated';
	Template.ArmorCat = 'templar';
	Template.Tier = 1;
	Template.AkAudioSoldierArmorSwitch = 'Predator';
	Template.EquipNarrative = "X2NarrativeMoments.Strategy.CIN_ArmorIntro_PlatedMedium";
	Template.EquipSound = "StrategyUI_Armor_Equip_Plated";

	Template.CreatorTemplateName = 'MediumPlatedArmor_Schematic'; // The schematic which creates this item
	Template.BaseItem = 'TemplarArmor'; // Which item this will be upgraded from

	Template.SetUIStatMarkup(class'XLocalizedData'.default.HealthLabel, eStat_HP, class'X2Ability_ItemGrantedAbilitySet'.default.MEDIUM_PLATED_HEALTH_BONUS, true);

	return Template;
}

static function X2DataTemplate CreatePoweredTemplarArmor()
{
	local X2ArmorTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ArmorTemplate', Template, 'PoweredTemplarArmor');
	Template.strImage = "img:///UILibrary_XPACK_StrategyImages.Inv_HORArmorPowr";
	Template.ItemCat = 'armor';
	Template.bAddsUtilitySlot = false;
	Template.StartingItem = false;
	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;
	Template.TradingPostValue = 60;
	Template.PointsToComplete = 0;
	Template.Abilities.AddItem('MediumPoweredArmorStats');
	Template.ArmorTechCat = 'powered';
	Template.ArmorCat = 'templar';
	Template.Tier = 3;
	Template.AkAudioSoldierArmorSwitch = 'Warden';
	Template.EquipNarrative = "X2NarrativeMoments.Strategy.CIN_ArmorIntro_PoweredMedium";
	Template.EquipSound = "StrategyUI_Armor_Equip_Powered";

	Template.CreatorTemplateName = 'MediumPoweredArmor_Schematic'; // The schematic which creates this item
	Template.BaseItem = 'PlatedTemplarArmor'; // Which item this will be upgraded from

	Template.SetUIStatMarkup(class'XLocalizedData'.default.HealthLabel, eStat_HP, class'X2Ability_ItemGrantedAbilitySet'.default.MEDIUM_POWERED_HEALTH_BONUS, true);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.ArmorLabel, eStat_ArmorMitigation, class'X2Ability_ItemGrantedAbilitySet'.default.MEDIUM_POWERED_MITIGATION_AMOUNT);

	return Template;
}