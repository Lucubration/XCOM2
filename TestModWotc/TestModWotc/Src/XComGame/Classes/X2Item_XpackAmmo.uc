class X2Item_XpackAmmo extends X2Item config(GameCore);

var config int HUNTER_BLEEDING_NUM_TURNS;
var config int HUNTER_BLEEDING_TICK_DMG;
var config int HUNTER_BLEEDING_CHANCE_PERCENT;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Items;

	Items.AddItem(CreateHunterBleedingRounds());
	
	return Items;
}

static function X2DataTemplate CreateHunterBleedingRounds()
{
	local X2AmmoTemplate Template;
	local WeaponDamageValue DamageValue;
	local X2Effect_Persistent BleedingEffect;

	`CREATE_X2TEMPLATE(class'X2AmmoTemplate', Template, 'HunterBleedingRounds');
	Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_Bleeding_Rounds";
	DamageValue.Damage = 0;
	DamageValue.DamageType = 'bleeding';
	Template.AddAmmoDamageModifier(none, DamageValue);
	BleedingEffect = class'X2StatusEffects'.static.CreateBleedingStatusEffect(default.HUNTER_BLEEDING_NUM_TURNS, default.HUNTER_BLEEDING_TICK_DMG);
	BleedingEffect.ApplyChance = default.HUNTER_BLEEDING_CHANCE_PERCENT;
	Template.TargetEffects.AddItem(BleedingEffect);
	Template.CanBeBuilt = false;
	Template.TradingPostValue = 0;
	Template.PointsToComplete = 0;
	Template.Tier = 1;
	Template.EquipSound = "StrategyUI_Ammo_Equip";

	//FX Reference
	Template.GameArchetype = "Ammo_Bleeding.PJ_Bleeding";

	return Template;
}