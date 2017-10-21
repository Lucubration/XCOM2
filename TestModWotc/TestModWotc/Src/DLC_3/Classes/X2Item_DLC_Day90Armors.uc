class X2Item_DLC_Day90Armors extends X2Item config(GameData);

var config int TIER1_INTIMIDATE_STRENGTH, TIER2_INTIMIDATE_STRENGTH, TIER3_INTIMIDATE_STRENGTH;
var config WeaponDamageValue TIER1_STRIKE_DMG, TIER2_STRIKE_DMG, TIER3_STRIKE_DMG;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Armors;

	Armors.AddItem(CreateSparkArmor());
	Armors.AddItem(CreatePlatedSparkArmor());
	Armors.AddItem(CreatePoweredSparkArmor());

	return Armors;
}

static function X2DataTemplate CreateSparkArmor()
{
	local X2SparkArmorTemplate_DLC_3 Template;

	`CREATE_X2TEMPLATE(class'X2SparkArmorTemplate_DLC_3', Template, 'SparkArmor');
	Template.strImage = "img:///UILibrary_DLC3Images.Inv_Spark_Conventional_A";
	Template.StartingItem = false;
	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;
	Template.ArmorTechCat = 'conventional';
	Template.ArmorCat = 'spark';
	Template.Tier = 0;
	Template.AkAudioSoldierArmorSwitch = 'Conventional';
	Template.EquipSound = "StrategyUI_Armor_Equip_Conventional_Spark";

	Template.IntimidateStrength = default.TIER1_INTIMIDATE_STRENGTH;
	Template.StrikeDamage = default.TIER1_STRIKE_DMG;
	
	Template.SetUIStatMarkup(class'XLocalizedData'.default.HealthLabel, eStat_HP, 0, true);

	return Template;
}

static function X2DataTemplate CreatePlatedSparkArmor()
{
	local X2SparkArmorTemplate_DLC_3 Template;

	`CREATE_X2TEMPLATE(class'X2SparkArmorTemplate_DLC_3', Template, 'PlatedSparkArmor');
	Template.strImage = "img:///UILibrary_DLC3Images.Inv_Spark_Plated_A";
	Template.ItemCat = 'armor';
	Template.StartingItem = false;
	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;
	Template.TradingPostValue = 20;
	Template.PointsToComplete = 0;
	Template.Abilities.AddItem('PlatedSparkArmorStats');
	Template.ArmorTechCat = 'plated';
	Template.ArmorCat = 'spark';
	Template.Tier = 1;
	Template.AkAudioSoldierArmorSwitch = 'Predator';
	Template.EquipSound = "StrategyUI_Armor_Equip_Plated_Spark";

	Template.CreatorTemplateName = 'PlatedSparkArmor_Schematic'; // The schematic which creates this item
	Template.BaseItem = 'SparkArmor'; // Which item this will be upgraded from

	Template.IntimidateStrength = default.TIER2_INTIMIDATE_STRENGTH;
	Template.StrikeDamage = default.TIER2_STRIKE_DMG;

	Template.SetUIStatMarkup(class'XLocalizedData'.default.HealthLabel, eStat_HP, class'X2Ability_DLC_Day90ItemGrantedAbilitySet'.default.SPARK_PLATED_HEALTH_BONUS, true);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.ArmorLabel, eStat_ArmorMitigation, class'X2Ability_DLC_Day90ItemGrantedAbilitySet'.default.SPARK_PLATED_MITIGATION_AMOUNT);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.MobilityLabel, eStat_Mobility, class'X2Ability_DLC_Day90ItemGrantedAbilitySet'.default.SPARK_PLATED_MOBILITY_BONUS);

	return Template;
}

static function X2DataTemplate CreatePoweredSparkArmor()
{
	local X2SparkArmorTemplate_DLC_3 Template;

	`CREATE_X2TEMPLATE(class'X2SparkArmorTemplate_DLC_3', Template, 'PoweredSparkArmor');
	Template.strImage = "img:///UILibrary_DLC3Images.Inv_Spark_Powered_A";
	Template.ItemCat = 'armor';
	Template.StartingItem = false;
	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;
	Template.TradingPostValue = 60;
	Template.PointsToComplete = 0;
	Template.Abilities.AddItem('PoweredSparkArmorStats');
	Template.ArmorTechCat = 'powered';
	Template.ArmorCat = 'spark';
	Template.Tier = 3;
	Template.AkAudioSoldierArmorSwitch = 'Warden';
	Template.EquipSound = "StrategyUI_Armor_Equip_Powered_Spark";

	Template.CreatorTemplateName = 'PoweredSparkArmor_Schematic'; // The schematic which creates this item
	Template.BaseItem = 'PlatedSparkArmor'; // Which item this will be upgraded from

	Template.IntimidateStrength = default.TIER3_INTIMIDATE_STRENGTH;
	Template.StrikeDamage = default.TIER3_STRIKE_DMG;

	Template.SetUIStatMarkup(class'XLocalizedData'.default.HealthLabel, eStat_HP, class'X2Ability_DLC_Day90ItemGrantedAbilitySet'.default.SPARK_POWERED_HEALTH_BONUS, true);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.ArmorLabel, eStat_ArmorMitigation, class'X2Ability_DLC_Day90ItemGrantedAbilitySet'.default.SPARK_POWERED_MITIGATION_AMOUNT);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.MobilityLabel, eStat_Mobility, class'X2Ability_DLC_Day90ItemGrantedAbilitySet'.default.SPARK_POWERED_MOBILITY_BONUS);

	return Template;
}