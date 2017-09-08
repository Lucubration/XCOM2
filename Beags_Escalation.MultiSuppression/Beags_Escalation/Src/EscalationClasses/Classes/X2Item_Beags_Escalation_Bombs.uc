class X2Item_Beags_Escalation_Bombs extends X2Item
	config (Beags_Escalation);

var config WeaponDamageValue BreachingChargeBaseDamage;
var config int BreachingChargeClipSize;
var config float BreachingChargeConeAngle;
var config int BreachingChargeConeRadius;
var config int BreachingChargeEnvironmentDamage;
var config int BreachingChargeRange;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Bombs;

	//Bombs.AddItem(BreachingCharge());

	return Bombs;
}

static function X2BombTemplate_Beags_Escalation BreachingCharge()
{
	local X2BombTemplate_Beags_Escalation Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2BombTemplate_Beags_Escalation', Template, 'Beags_Escalation_BreachingCharge');

	Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_Proximity_Mine";
	Template.EquipSound = "StrategyUI_Grenade_Equip";
	Template.iRange = default.BreachingChargeRange;
	Template.iRadius = default.BreachingChargeConeRadius;
	Template.fAngle = default.BreachingChargeConeAngle;
	Template.iClipSize = default.BreachingChargeClipSize;
	Template.BaseDamage = default.BreachingChargeBaseDamage;
	Template.iSoundRange = 10;
	Template.iEnvironmentDamage = default.BreachingChargeEnvironmentDamage;
	Template.DamageTypeTemplateName = 'Explosion';
	Template.Tier = 2;

	Template.Abilities.AddItem(class'X2Ability_Beags_Escalation_Bombs'.default.BreachingChargePlantAbilityName);
	Template.Abilities.AddItem(class'X2Ability_Beags_Escalation_Bombs'.default.BreachingChargeDetonationAbilityName);
	Template.Abilities.AddItem('GrenadeFuse');

	Template.bOverrideConcealmentRule = true;               // Override the normal behavior for the plant bomb ability
	Template.OverrideConcealmentRule = eConceal_Always;     // Always stay concealed when planting a breaching charge
	
	Template.GameArchetype = "WP_Proximity_Mine.WP_Proximity_Mine";

	Template.iPhysicsImpulse = 10;

	Template.CanBeBuilt = true;	
	Template.TradingPostValue = 25;
	
	// Requirements
	Template.Requirements.RequiredTechs.AddItem('AutopsyAdventOfficer');

	// Cost
	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = 25;
	Template.Cost.ResourceCosts.AddItem(Resources);

	return Template;
}
