class X2Item_Lucu_CombatEngineer_Weapons extends X2Item
    config(Lucu_CombatEngineer_Item);

var config int DetPackRange;
var config int DetPackRadius;

var name DetpackCVItemName;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Weapons;

	Weapons.AddItem(DetPackCV());

	return Weapons;
}

static function X2DataTemplate DetPackCV()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2GrenadeTemplate', Template, default.DetpackCVItemName);
	Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer); //invalidates multiplayer availability

	Template.strImage = "img:///UILibrary_Lucu_CombatEngineer.X2InventoryIcons.Inv_X4";
	Template.EquipSound = "StrategyUI_Grenade_Equip";
	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'lucu_combatengineer_detpack';
	Template.WeaponTech = 'conventional';
	Template.InventorySlot = eInvSlot_SecondaryWeapon;
    
    // These parameters give us proper target visualizations when throwing detpacks
	Template.iRange = default.DetPackRange;
	Template.iRadius = default.DetPackRadius;
	
	Template.GameArchetype = "UILibrary_Lucu_CombatEngineer.WP_Grenade_DetPack";

	Template.iPhysicsImpulse = 10;

    Template.StartingItem = true;
	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;
    
	Template.WeaponPrecomputedPathData.MaxNumberOfBounces = 0;

	return Template;
}

DefaultProperties
{
	DetpackCVItemName="Lucu_CombatEngineer_DetPack_CV"
}
