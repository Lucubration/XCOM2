class PA_Armors extends X2Item;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Armors;

	`log ("davea debug armor-create-templates-enter");
	Armors.AddItem(CreateChrysArmor());
	Armors.AddItem(CreateMecArmor());
	Armors.AddItem(CreateMutonArmor());
	Armors.AddItem(CreateViperArmor());
	Armors.Additem(CreateBerserkerArmor());
	Armors.Additem(CreateMecHeavyArmor());
	// Note!  If you add one, add to the case in PA_UIArmory_Loadout.uc
	// and also add to the GiveAlienArmor command in HeadquartersCheatManager
	`log ("davea debug armor-create-templates-done");
	return Armors;
}

static function X2DataTemplate CreateChrysArmor()
{
	local X2ArmorTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ArmorTemplate', Template, 'PA_ChrysArmor');
	Template.strImage = "img:///UILibrary_PlayableAdvent.ChrysArmor";
	Template.StartingItem = false;
	Template.CanBeBuilt = false;
	Template.ArmorTechCat = 'conventional';
	Template.Tier = 0;
	Template.AkAudioSoldierArmorSwitch = 'Conventional';
	Template.EquipSound = "StrategyUI_Armor_Equip_Conventional";
	Template.bInfiniteItem = true;
	return Template;
}

static function X2DataTemplate CreateMecArmor()
{
	local X2ArmorTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ArmorTemplate', Template, 'PA_MecArmor');
	Template.strImage = "img:///UILibrary_PlayableAdvent.MecArmor";
	Template.StartingItem = false;
	Template.CanBeBuilt = false;
	Template.ArmorTechCat = 'conventional';
	Template.Tier = 0;
	Template.AkAudioSoldierArmorSwitch = 'Conventional';
	Template.EquipSound = "StrategyUI_Armor_Equip_Conventional";
	Template.bInfiniteItem = true;
	return Template;
}

static function X2DataTemplate CreateMecHeavyArmor()
{
	local X2ArmorTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ArmorTemplate', Template, 'PA_MecHeavyArmor');
	Template.strImage = "img:///UILibrary_PlayableAdvent.MecArmor";
	Template.StartingItem = false;
	Template.CanBeBuilt = false;
	Template.ArmorTechCat = 'powered';
	Template.Tier = 2;
	Template.AkAudioSoldierArmorSwitch = 'Conventional';
	Template.EquipSound = "StrategyUI_Armor_Equip_Conventional";
	Template.bInfiniteItem = true;
	Template.bHeavyWeapon = true;
	Template.CreatorTemplateName = 'PA_MecHeavyArmor_Schematic';
	Template.BaseItem = 'PA_MecArmor';
	return Template;
}

static function X2DataTemplate CreateMutonArmor()
{
	local X2ArmorTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ArmorTemplate', Template, 'PA_MutonArmor');
	Template.strImage = "img:///UILibrary_PlayableAdvent.MutonArmor";
	Template.StartingItem = false;
	Template.CanBeBuilt = false;
	Template.ArmorTechCat = 'conventional';
	Template.Tier = 0;
	Template.AkAudioSoldierArmorSwitch = 'Conventional';
	Template.EquipSound = "StrategyUI_Armor_Equip_Conventional";
	Template.bInfiniteItem = true;
	return Template;
}

static function X2DataTemplate CreateViperArmor()
{
	local X2ArmorTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ArmorTemplate', Template, 'PA_ViperArmor');
	Template.strImage = "img:///UILibrary_PlayableAdvent.ViperArmor";
	Template.StartingItem = false;
	Template.CanBeBuilt = false;
	Template.ArmorTechCat = 'conventional';
	Template.Tier = 0;
	Template.AkAudioSoldierArmorSwitch = 'Conventional';
	Template.EquipSound = "StrategyUI_Armor_Equip_Conventional";
	Template.bInfiniteItem = true;
	return Template;
}

static function X2DataTemplate CreateBerserkerArmor()
{
	local X2ArmorTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ArmorTemplate', Template, 'PA_BerserkerArmor');
	Template.strImage = "img:///UILibrary_PlayableAdvent.MutonArmor";
	Template.StartingItem = false;
	Template.CanBeBuilt = false;
	Template.ArmorTechCat = 'conventional';
	Template.Tier = 0;
	Template.AkAudioSoldierArmorSwitch = 'Conventional';
	Template.EquipSound = "StrategyUI_Armor_Equip_Conventional";
	return Template;
}
