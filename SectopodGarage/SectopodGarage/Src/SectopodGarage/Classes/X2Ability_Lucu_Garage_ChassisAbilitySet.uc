class X2Ability_Lucu_Garage_ChassisAbilitySet extends X2Ability
	config(Lucu_Garage_DefaultConfig);
	
var config int BasicPlating_Armor;
var config int RhinoPlating_Health;
var config int RhinoPlating_Armor;
var config int RaptorPlating_Mobility;
var config int RaptorPlating_Dodge;

var config int BasicChassisUpgrade_Health;
var config int AdvancedChassisUpgrade_Health;
var config int AlloyChassisUpgrade_Health;
var config int ExperimentalChassisUpgrade_Health;
	
static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;
	
	Templates.AddItem(BasicPlating());
	Templates.AddItem(RhinoPlating());
	Templates.AddItem(RaptorPlating());
	Templates.AddItem(BasicChassisUpgrade());
	Templates.AddItem(AdvancedChassisUpgrade());
	Templates.AddItem(AlloyChassisUpgrade());
	Templates.AddItem(ExperimentalChassisUpgrade());

	return Templates;
}


// **************************************************************************
// ***                          Basic Plating                             ***
// **************************************************************************


static function X2AbilityTemplate BasicPlating()
{
	local X2AbilityTemplate                 Template;	
	local X2AbilityTrigger					Trigger;
	local X2AbilityTarget_Self				TargetStyle;
	local X2Effect_PersistentStatChange		PersistentStatChangeEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Lucu_Garage_BasicPlating');

	Template.AbilitySourceName = 'eAbilitySource_Item';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.bDisplayInUITacticalText = false;
	
	Template.AbilityToHitCalc = default.DeadEye;
	
	TargetStyle = new class'X2AbilityTarget_Self';
	Template.AbilityTargetStyle = TargetStyle;

	Trigger = new class'X2AbilityTrigger_UnitPostBeginPlay';
	Template.AbilityTriggers.AddItem(Trigger);
	
	PersistentStatChangeEffect = new class'X2Effect_PersistentStatChange';
	PersistentStatChangeEffect.EffectName = 'Lucu_Garage_BasicPlating';
	PersistentStatChangeEffect.BuildPersistentEffect(1, true, false, false);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_ArmorChance, 100);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_ArmorMitigation, default.BasicPlating_Armor);
	PersistentStatChangeEffect.DuplicateResponse = eDupe_Ignore;
	Template.AddTargetEffect(PersistentStatChangeEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;	
}


// **************************************************************************
// ***                          Rhino Plating                             ***
// **************************************************************************


static function X2AbilityTemplate RhinoPlating()
{
	local X2AbilityTemplate								Template;	
	local X2AbilityTrigger								Trigger;
	local X2AbilityTarget_Self							TargetStyle;
	local X2Effect_Lucu_Garage_PersistentStatChange		PersistentStatChangeEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Lucu_Garage_RhinoPlating');

	Template.AbilitySourceName = 'eAbilitySource_Item';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.bDisplayInUITacticalText = false;
	
	Template.AbilityToHitCalc = default.DeadEye;
	
	TargetStyle = new class'X2AbilityTarget_Self';
	Template.AbilityTargetStyle = TargetStyle;

	Trigger = new class'X2AbilityTrigger_UnitPostBeginPlay';
	Template.AbilityTriggers.AddItem(Trigger);
	
	PersistentStatChangeEffect = new class'X2Effect_Lucu_Garage_PersistentStatChange';
	PersistentStatChangeEffect.EffectName = 'Lucu_Garage_RhinoPlating';
	PersistentStatChangeEffect.BuildPersistentEffect(1, true, false, false);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_HP, default.RhinoPlating_Health, true);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_ArmorChance, 100, false);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_ArmorMitigation, default.RhinoPlating_Armor, true);
	PersistentStatChangeEffect.DuplicateResponse = eDupe_Ignore;
	Template.AddTargetEffect(PersistentStatChangeEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;	
}


// **************************************************************************
// ***                         Raptor Plating                             ***
// **************************************************************************


static function X2AbilityTemplate RaptorPlating()
{
	local X2AbilityTemplate								Template;	
	local X2AbilityTrigger								Trigger;
	local X2AbilityTarget_Self							TargetStyle;
	local X2Effect_Lucu_Garage_PersistentStatChange		PersistentStatChangeEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Lucu_Garage_RaptorPlating');

	Template.AbilitySourceName = 'eAbilitySource_Item';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.bDisplayInUITacticalText = false;
	
	Template.AbilityToHitCalc = default.DeadEye;
	
	TargetStyle = new class'X2AbilityTarget_Self';
	Template.AbilityTargetStyle = TargetStyle;

	Trigger = new class'X2AbilityTrigger_UnitPostBeginPlay';
	Template.AbilityTriggers.AddItem(Trigger);
	
	PersistentStatChangeEffect = new class'X2Effect_Lucu_Garage_PersistentStatChange';
	PersistentStatChangeEffect.EffectName = 'Lucu_Garage_RaptorPlating';
	PersistentStatChangeEffect.BuildPersistentEffect(1, true, false, false);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_Mobility, default.RaptorPlating_Mobility, true);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_Dodge, default.RaptorPlating_Dodge, true);
	PersistentStatChangeEffect.DuplicateResponse = eDupe_Ignore;
	Template.AddTargetEffect(PersistentStatChangeEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;	
}


// **************************************************************************
// ***                      Basic Chassis Upgrade                         ***
// **************************************************************************


static function X2AbilityTemplate BasicChassisUpgrade()
{
	local X2AbilityTemplate                 Template;	
	local X2AbilityTrigger					Trigger;
	local X2AbilityTarget_Self				TargetStyle;
	local X2Effect_PersistentStatChange		PersistentStatChangeEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Lucu_Garage_BasicChassisUpgrade');

	Template.AbilitySourceName = 'eAbilitySource_Item';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.bDisplayInUITacticalText = false;
	
	Template.AbilityToHitCalc = default.DeadEye;
	
	TargetStyle = new class'X2AbilityTarget_Self';
	Template.AbilityTargetStyle = TargetStyle;

	Trigger = new class'X2AbilityTrigger_UnitPostBeginPlay';
	Template.AbilityTriggers.AddItem(Trigger);
	
	PersistentStatChangeEffect = new class'X2Effect_PersistentStatChange';
	PersistentStatChangeEffect.EffectName = 'Lucu_Garage_BasicChassisUpgrade';
	PersistentStatChangeEffect.BuildPersistentEffect(1, true, false, false);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_HP, default.BasicChassisUpgrade_Health);
	PersistentStatChangeEffect.DuplicateResponse = eDupe_Ignore;
	Template.AddTargetEffect(PersistentStatChangeEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;	
}


// **************************************************************************
// ***                     Advanced Chassis Upgrade                       ***
// **************************************************************************


static function X2AbilityTemplate AdvancedChassisUpgrade()
{
	local X2AbilityTemplate                 Template;	
	local X2AbilityTrigger					Trigger;
	local X2AbilityTarget_Self				TargetStyle;
	local X2Effect_PersistentStatChange		PersistentStatChangeEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Lucu_Garage_AdvancedChassisUpgrade');

	Template.AbilitySourceName = 'eAbilitySource_Item';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.bDisplayInUITacticalText = false;
	
	Template.AbilityToHitCalc = default.DeadEye;
	
	TargetStyle = new class'X2AbilityTarget_Self';
	Template.AbilityTargetStyle = TargetStyle;

	Trigger = new class'X2AbilityTrigger_UnitPostBeginPlay';
	Template.AbilityTriggers.AddItem(Trigger);
	
	PersistentStatChangeEffect = new class'X2Effect_PersistentStatChange';
	PersistentStatChangeEffect.EffectName = 'Lucu_Garage_AdvancedChassisUpgrade';
	PersistentStatChangeEffect.BuildPersistentEffect(1, true, false, false);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_HP, default.AdvancedChassisUpgrade_Health);
	PersistentStatChangeEffect.DuplicateResponse = eDupe_Ignore;
	Template.AddTargetEffect(PersistentStatChangeEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;	
}


// **************************************************************************
// ***                      Alloy Chassis Upgrade                         ***
// **************************************************************************


static function X2AbilityTemplate AlloyChassisUpgrade()
{
	local X2AbilityTemplate                 Template;	
	local X2AbilityTrigger					Trigger;
	local X2AbilityTarget_Self				TargetStyle;
	local X2Effect_PersistentStatChange		PersistentStatChangeEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Lucu_Garage_AlloyChassisUpgrade');

	Template.AbilitySourceName = 'eAbilitySource_Item';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.bDisplayInUITacticalText = false;
	
	Template.AbilityToHitCalc = default.DeadEye;
	
	TargetStyle = new class'X2AbilityTarget_Self';
	Template.AbilityTargetStyle = TargetStyle;

	Trigger = new class'X2AbilityTrigger_UnitPostBeginPlay';
	Template.AbilityTriggers.AddItem(Trigger);
	
	PersistentStatChangeEffect = new class'X2Effect_PersistentStatChange';
	PersistentStatChangeEffect.EffectName = 'Lucu_Garage_AlloyChassisUpgrade';
	PersistentStatChangeEffect.BuildPersistentEffect(1, true, false, false);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_HP, default.AlloyChassisUpgrade_Health);
	PersistentStatChangeEffect.DuplicateResponse = eDupe_Ignore;
	Template.AddTargetEffect(PersistentStatChangeEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;	
}


// **************************************************************************
// ***                   Experimental Chassis Upgrade                     ***
// **************************************************************************


static function X2AbilityTemplate ExperimentalChassisUpgrade()
{
	local X2AbilityTemplate                 Template;	
	local X2AbilityTrigger					Trigger;
	local X2AbilityTarget_Self				TargetStyle;
	local X2Effect_PersistentStatChange		PersistentStatChangeEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Lucu_Garage_ExperimentalChassisUpgrade');

	Template.AbilitySourceName = 'eAbilitySource_Item';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.bDisplayInUITacticalText = false;
	
	Template.AbilityToHitCalc = default.DeadEye;
	
	TargetStyle = new class'X2AbilityTarget_Self';
	Template.AbilityTargetStyle = TargetStyle;

	Trigger = new class'X2AbilityTrigger_UnitPostBeginPlay';
	Template.AbilityTriggers.AddItem(Trigger);
	
	PersistentStatChangeEffect = new class'X2Effect_PersistentStatChange';
	PersistentStatChangeEffect.EffectName = 'Lucu_Garage_ExperimentalChassisUpgrade';
	PersistentStatChangeEffect.BuildPersistentEffect(1, true, false, false);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_HP, default.ExperimentalChassisUpgrade_Health);
	PersistentStatChangeEffect.DuplicateResponse = eDupe_Ignore;
	Template.AddTargetEffect(PersistentStatChangeEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;	
}
