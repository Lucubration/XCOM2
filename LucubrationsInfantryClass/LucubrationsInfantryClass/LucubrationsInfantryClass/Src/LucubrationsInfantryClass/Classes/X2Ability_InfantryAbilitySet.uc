//---------------------------------------------------------------------------------------
//  FILE:    X2Ability_InfantryAbilitySet.uc
//  AUTHOR:  Lucubration
//  PURPOSE: Defines abilities used by the Infantry class.
//---------------------------------------------------------------------------------------

class X2Ability_InfantryAbilitySet extends X2Ability
	config(LucubrationsInfantryClass);

// Local variables are defined and initialized entirely in code
var name LightEmUpAbilityName;
var name EstablishedDefensesOverwatchArmorAbilityName;
var name EstablishedDefensesOverwatchArmorEffectName;
var name EstablishedDefensesOverwatchDefenseAbilityName;
var name EstablishedDefensesOverwatchDefenseEffectName;
var name EstablishedDefensesOverwatchPointsName;
var name CrippledEffectName;
var name StaggeredEffectName;
var name DeepReservesAbilityName;
var name StickAndMoveDamageAbilityName;
var name StickAndMoveDamageEffectName;
var name StickAndMoveMobilityAbilityName;
var name StickAndMoveMobilityEffectName;
var name StickAndMoveDodgeAbilityName;
var name StickAndMoveDodgeEffectName;
var name FlareStatusEffectName;
var name FlareRemoveTriggerName;
var name ZoneOfControlActionPointName;
var name ZoneOfControlReactionFireAbilityName;
var name ZoneOfControlCounterAttackAbilityName;
var name ZoneOfControlCounterAttackDefenseAbilityName;
var name ZoneOfControlCounterAttackDefenseEffectName;
var name EscapeAndEvadeActionPointName;
var name EscapeAndEvadeStealthAbilityName;

// Config variables are defined here but initialized using values in 'XComLucubrationsInfantryClass.ini'.
// This config file name has the safe suffix as the package name
// Localized strings are defined here but initialized using values in 'LucubrationsInfantryClass.int'.
// I'm truly unsure of how localization works, but I figure it doesn't hurt to get things set up in case
// I should localize the class, ability and effect descriptions later
var config int OpportunistAimBonus;
var config int EstablishedDefensesArmorBonus;
var config int EstablishedDefensesDefenseBonus;
var config int HarrierAimBonus;
var config int HarrierCritBonus;
var config int CripplingShotAimBonus;							// Deprecated
var config int CripplingShotAmmoCost;							// Deprecated
var config int CripplingShotActionPointCost;					// Deprecated
var config int CripplingShotCooldown;							// Deprecated
var config int CripplingShotDuration;							// Deprecated
var config int CripplingShotDodgeReduction;						// Deprecated
var config int CripplingShotMobilityReduction;					// Deprecated
var localized string CrippledFriendlyName;						// Deprecated
var localized string CrippledFriendlyDesc;						// Deprecated
var localized string CrippledEffectAcquiredString;				// Deprecated
var localized string CrippledEffectTickedString;				// Deprecated
var localized string CrippledEffectLostString;					// Deprecated
var config int StaggeringShotAimBonus;
var config int StaggeringShotDamageMultiplier;
var config int StaggeringShotAmmoCost;
var config int StaggeringShotActionPointCost;
var config int StaggeringShotCooldown;
var config int StaggeringShotDodgeReduction;
var config int StaggeringShotDuration;
var localized string StaggeredFriendlyName;
var localized string StaggeredFriendlyDesc;
var localized string StaggeredEffectAcquiredString;
var localized string StaggeredEffectTickedString;
var localized string StaggeredEffectLostString;
var config int ShakeItOffWillBonus;
var config int StickAndMoveDamageBonus;
var config int StickAndMoveDefenseBonus;
var config int StickAndMoveMobilityBonus;
var config int StickAndMoveMobilityDuration;					// Deprecated
var config int StickAndMoveDodgeBonus;
var config int StickAndMoveDodgeDuration;
var localized string StickAndMoveDamageFriendlyName;
var localized string StickAndMoveDamageFriendlyDesc;
var localized string StickAndMoveMobilityFriendlyName;
var localized string StickAndMoveMobilityFriendlyDesc;
var localized string StickAndMoveDodgeFriendlyName;
var localized string StickAndMoveDodgeFriendlyDesc;
var config int ExplosiveActionCooldown;
var config int ExplosiveActionBonusActionPoints;
var config int ExplosiveActionRecoveryDelay;
var config int ExplosiveActionRecoveryActionPoints;
var localized string ExplosiveActionRecoveryFriendlyName;
var localized string ExplosiveActionRecoveryFriendlyDesc;
var config int ZoneOfControlReactionFireRadius;
var config int ZoneOfControlReactionFireShotsPerTurn;
var config int ZoneOfControlCounterAttackChance;
var config int ZoneOfControlCounterAttacksPerTurn;
var localized string ZoneOfControlFriendlyName;
var config int EscapeAndEvadeCooldown;
var config int EscapeAndEvadeDodgeBonus;
var config int EscapeAndEvadeStealthDuration;
var config float EscapeAndEvadeDetectionRadiusModifier;
var config int FlareCharges;
var config int FlareCooldown;
var config int FlareRadius;
var config int FlareHeight;
var config int FlareRange;
var config int FlareDuration;
var localized string FlareFriendlyName;
var localized string FlareFriendlyDesc;
var localized string FlareEffectAcquiredString;
var localized string FlareEffectTickedString;
var localized string FlareEffectLostString;
var config float DeepReservesWoundPercentToHeal;
var config float DeepReservesDamagePercentToHeal;
var config int DeepReservesMaxHealPerTurn;
var config int DeepReservesMaxTotalHealAmount;
var config int FireForEffectCooldown;
var config int FireForEffectRadius;
var config int FireForEffectAmmoCost;
var config int FireForEffectAbilityPointCost;
var config int FireForEffectRange;
var config int ExtraConditioningHealthBonus;
var config int ExtraConditioningAimBonus;
var config int ExtraConditioningWillBonus;

// This method is natively called for subclasses of X2DataSet. It'll create and return ability templates for our new class
static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;
	
	Templates.Length = 0;
	// Abilities that don't need much can be created using this handy function from Firaxis
	// We have to access local variables using default values because these are static methods. Defaults are defined at the end
	// of the file, apparently by convention. Look for 'DefaultProperties'
	Templates.AddItem(PurePassive(default.LightEmUpAbilityName, "img:///UILibrary_InfantryClass.UIPerk_lightemup"));
	Templates.AddItem(Opportunist());
	Templates.AddItem(EstablishedDefenses());
	Templates.AddItem(EstablishedDefensesOverwatch());
	Templates.AddItem(EstablishedDefensesOverwatchArmor());
	Templates.AddItem(EstablishedDefensesOverwatchDefense());
	Templates.AddItem(Harrier()); // Many abilities will only require one template
	Templates.AddItem(CripplingShot());
	Templates.AddItem(CripplingShotDamage());
	Templates.AddItem(StaggeringShot());
	Templates.AddItem(StaggeringShotDamage());
	Templates.AddItem(ShakeItOff());
	Templates.AddItem(StickAndMove()); // Some abilities use a series of templates for performing more complex ability interactions
	Templates.AddItem(StickAndMoveDodge());
	Templates.AddItem(StickAndMoveDamage());
	Templates.AddItem(StickAndMoveMobility());
	Templates.AddItem(ExplosiveAction());
	Templates.Additem(ZoneOfControl());
	Templates.Additem(ZoneOfControlShot());
	Templates.Additem(ZoneOfControlCounterAttack());
	Templates.AddItem(ZoneOfControlCounterAttackDefense());
	Templates.AddItem(EscapeAndEvade());
	Templates.AddItem(EscapeAndEvadeActive());
	Templates.AddItem(EscapeAndEvadeStealth());
	Templates.AddItem(DeepReserves());
	Templates.AddItem(FireForEffect());
	Templates.AddItem(ExtraConditioning());
	Templates.AddItem(Flare());
	//Templates.AddItem(Steadfast());
	//Templates.AddItem(TestDisoriented());
	//Templates.AddItem(TestStunned());
	//Templates.AddItem(TestConfused());
	//Templates.AddItem(TestPanicked());
	//Templates.AddItem(TestUnconscious());

	return Templates;
}


//---------------------------------------------------------------------------------------------------
// Testing Abilities
//---------------------------------------------------------------------------------------------------

/*
static function X2AbilityTemplate TestDisoriented()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints		ActionCost;
	
	`CREATE_X2ABILITY_TEMPLATE(Template, 'TestDisoriented');
	
	// Icon Properties
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_shaken";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";
	
	// Activated by a button press; additionally, tells the AI this is an activatable
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	// Can't shoot while dead
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	
	ActionCost = new class'X2AbilityCost_ActionPoints';
	ActionCost.iNumPoints = 0;
	ActionCost.bFreeCost = true;
	Template.AbilityCosts.AddItem(ActionCost);
	
	Template.AbilityToHitCalc = default.DeadEye;

	Template.AbilityTargetStyle = default.SelfTarget;
	
	Template.AddTargetEffect(class'X2StatusEffects'.static.CreateDisorientedStatusEffect());

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	Template.Hostility = eHostility_Neutral;
	Template.bDisplayInUITooltip = false;
	Template.bLimitTargetIcons = true;
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	
	Template.bShowActivation = true;
	Template.bSkipFireAction = true;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	
	return Template;
}

static function X2AbilityTemplate TestStunned()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints		ActionCost;
	
	`CREATE_X2ABILITY_TEMPLATE(Template, 'TestStunned');
	
	// Icon Properties
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_shaken";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";
	
	// Activated by a button press; additionally, tells the AI this is an activatable
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	// Can't shoot while dead
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	
	ActionCost = new class'X2AbilityCost_ActionPoints';
	ActionCost.iNumPoints = 0;
	ActionCost.bFreeCost = true;
	Template.AbilityCosts.AddItem(ActionCost);
	
	Template.AbilityToHitCalc = default.DeadEye;

	Template.AbilityTargetStyle = default.SelfTarget;
	
	Template.AddTargetEffect(class'X2StatusEffects'.static.CreateStunnedStatusEffect(1, 100));

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	Template.Hostility = eHostility_Neutral;
	Template.bDisplayInUITooltip = false;
	Template.bLimitTargetIcons = true;
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	
	Template.bShowActivation = true;
	Template.bSkipFireAction = true;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	
	return Template;
}

static function X2AbilityTemplate TestConfused()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints		ActionCost;
	
	`CREATE_X2ABILITY_TEMPLATE(Template, 'TestConfused');
	
	// Icon Properties
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_shaken";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";
	
	// Activated by a button press; additionally, tells the AI this is an activatable
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	// Can't shoot while dead
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	
	ActionCost = new class'X2AbilityCost_ActionPoints';
	ActionCost.iNumPoints = 0;
	ActionCost.bFreeCost = true;
	Template.AbilityCosts.AddItem(ActionCost);
	
	Template.AbilityToHitCalc = default.DeadEye;

	Template.AbilityTargetStyle = default.SelfTarget;
	
	Template.AddTargetEffect(class'X2StatusEffects'.static.CreateConfusedStatusEffect(1));

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	Template.Hostility = eHostility_Neutral;
	Template.bDisplayInUITooltip = false;
	Template.bLimitTargetIcons = true;
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	
	Template.bShowActivation = true;
	Template.bSkipFireAction = true;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	
	return Template;
}

static function X2AbilityTemplate TestPanicked()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints		ActionCost;
	
	`CREATE_X2ABILITY_TEMPLATE(Template, 'TestPanicked');
	
	// Icon Properties
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_shaken";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";
	
	// Activated by a button press; additionally, tells the AI this is an activatable
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	// Can't shoot while dead
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	
	ActionCost = new class'X2AbilityCost_ActionPoints';
	ActionCost.iNumPoints = 0;
	ActionCost.bFreeCost = true;
	Template.AbilityCosts.AddItem(ActionCost);
	
	Template.AbilityToHitCalc = default.DeadEye;

	Template.AbilityTargetStyle = default.SelfTarget;
	
	Template.AddTargetEffect(class'X2StatusEffects'.static.CreatePanickedStatusEffect());

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	Template.Hostility = eHostility_Neutral;
	Template.bDisplayInUITooltip = false;
	Template.bLimitTargetIcons = true;
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	
	Template.bShowActivation = true;
	Template.bSkipFireAction = true;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	
	return Template;
}

static function X2AbilityTemplate TestUnconscious()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints		ActionCost;
	
	`CREATE_X2ABILITY_TEMPLATE(Template, 'TestUnconscious');
	
	// Icon Properties
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_shaken";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";
	
	// Activated by a button press; additionally, tells the AI this is an activatable
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	// Can't shoot while dead
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	
	ActionCost = new class'X2AbilityCost_ActionPoints';
	ActionCost.iNumPoints = 0;
	ActionCost.bFreeCost = true;
	Template.AbilityCosts.AddItem(ActionCost);
	
	Template.AbilityToHitCalc = default.DeadEye;

	Template.AbilityTargetStyle = default.SelfTarget;
	
	Template.AddTargetEffect(class'X2StatusEffects'.static.CreateUnconsciousStatusEffect());

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	Template.Hostility = eHostility_Neutral;
	Template.bDisplayInUITooltip = false;
	Template.bLimitTargetIcons = true;
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	
	Template.bShowActivation = true;
	Template.bSkipFireAction = true;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	
	return Template;
}
*/
	
//---------------------------------------------------------------------------------------------------
// Opportunist
//---------------------------------------------------------------------------------------------------


static function X2AbilityTemplate Opportunist()
{
	local X2AbilityTemplate						Template;
	//local X2Effect_Opportunist					Effect;
	local X2Effect_ModifyReactionFire			Effect;

	// This is some sort of macro by Firaxis that sets up an ability template with localized text from XComGame.int (and maybe some other stuff?)
	`CREATE_X2ABILITY_TEMPLATE(Template, 'Opportunist');

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow; // This ability doesn't show up on the action HUD (can't click to activate it)
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_InfantryClass.UIPerk_opportunist";

	Template.AbilityToHitCalc = default.DeadEye; // Always hits
	Template.AbilityTargetStyle = default.SelfTarget; // Applies to the unit with the ability
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger); // Basically begins immediately when the unit is spawned with the ability

	// I wanted to make sure I could do the original Opportunist, and that's what this effect does, but it's kind of strong so I'm putting back in
	// the same effect used by Cool Under Pressure
	/*
	Effect = new class'X2Effect_Opportunist';
	Effect.EffectName = 'Opportunist';
	Effect.DuplicateResponse = eDupe_Ignore; // Shouldn't be a case where multiple copies of the passive effect are applied, but if they are ignore the new one
	Effect.BuildPersistentEffect(1, true, false); // Lasts forever
	Effect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage,,,Template.AbilitySourceName);
	Template.AddTargetEffect(Effect); // Effects added to the primary target of an ability. In this case, that's our unit
	*/

	Effect = new class'X2Effect_ModifyReactionFire';
	Effect.bAllowCrit = true;
	Effect.ReactionModifier = default.OpportunistAimBonus;
	Effect.BuildPersistentEffect(1, true, true, true);
	Effect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage,,,Template.AbilitySourceName);
	Template.AddTargetEffect(Effect);


	// Function delegate for setting up a standard XComGameState_Ability object for this ability
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!
	// No function delegates for creating function visualizations because this passive ability isn't showy

	return Template;
}


//---------------------------------------------------------------------------------------------------
// Established Defenses
//---------------------------------------------------------------------------------------------------


static function X2AbilityTemplate EstablishedDefenses()
{
	local X2AbilityTemplate						Template;
	local X2Effect_EstablishedDefenses          Effect;

	// This is some sort of macro by Firaxis that sets up an ability template with localized text from XComGame.int (and maybe some other stuff?)
	`CREATE_X2ABILITY_TEMPLATE(Template, 'EstablishedDefenses');

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow; // This ability doesn't show up on the action HUD (can't click to activate it)
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_fortress";

	Template.AbilityToHitCalc = default.DeadEye; // Always hits
	Template.AbilityTargetStyle = default.SelfTarget; // Applies to the unit with the ability
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger); // Basically begins immediately when the unit is spawned with the ability

	// This passive effect contains the logic for updating armor values based on changing conditions
	Effect = new class'X2Effect_EstablishedDefenses';
	Effect.EffectName = 'EstablishedDefenses';
	Effect.DuplicateResponse = eDupe_Ignore; // Shouldn't be a case where multiple copies of the passive effect are applied, but if they are ignore the new one
	Effect.BuildPersistentEffect(1, true, false); // Lasts forever
	Effect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage,,,Template.AbilitySourceName);
	Template.AddTargetEffect(Effect); // Effects added to the primary target of an ability. In this case, that's our unit

	// Function delegate for setting up a standard XComGameState_Ability object for this ability
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!
	// No function delegates for creating function visualizations because this passive ability isn't showy

	return Template;
}

static function X2AbilityTemplate EstablishedDefensesOverwatch()
{
	local X2AbilityTemplate						Template;
	local X2Effect_EstablishedDefensesOverwatch	Effect;

	// This is some sort of macro by Firaxis that sets up an ability template with localized text from XComGame.int (and maybe some other stuff?)
	`CREATE_X2ABILITY_TEMPLATE(Template, 'EstablishedDefensesOverwatch');
	
	Template.AdditionalAbilities.AddItem(default.EstablishedDefensesOverwatchArmorAbilityName);
	Template.AdditionalAbilities.AddItem(default.EstablishedDefensesOverwatchDefenseAbilityName);

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow; // This ability doesn't show up on the action HUD (can't click to activate it)
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_fortress";

	Template.AbilityToHitCalc = default.DeadEye; // Always hits
	Template.AbilityTargetStyle = default.SelfTarget; // Applies to the unit with the ability
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger); // Basically begins immediately when the unit is spawned with the ability

	// This passive effect contains the logic for updating armor values based on changing conditions
	Effect = new class'X2Effect_EstablishedDefensesOverwatch';
	Effect.EffectName = 'EstablishedDefensesOverwatch';
	Effect.DuplicateResponse = eDupe_Ignore; // Shouldn't be a case where multiple copies of the passive effect are applied, but if they are ignore the new one
	Effect.BuildPersistentEffect(1, true, false); // Lasts forever
	Effect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage,,, Template.AbilitySourceName);
	Template.AddTargetEffect(Effect); // Effects added to the primary target of an ability. In this case, that's our unit

	// Function delegate for setting up a standard XComGameState_Ability object for this ability
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!
	// No function delegates for creating function visualizations because this passive ability isn't showy

	return Template;
}

static function X2AbilityTemplate EstablishedDefensesOverwatchArmor()
{
	local X2AbilityTemplate							Template;
	local X2Effect_EstablishedDefensesArmorBonus	Effect;

	// This is some sort of macro by Firaxis that sets up an ability template with localized text from XComGame.int (and maybe some other stuff?)
	`CREATE_X2ABILITY_TEMPLATE(Template, default.EstablishedDefensesOverwatchArmorAbilityName);

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow; // This ability doesn't show up on the action HUD (can't click to activate it)
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_fortress";

	Template.AbilityToHitCalc = default.DeadEye; // Always hits
	Template.AbilityTargetStyle = default.SelfTarget; // Applies to the unit with the ability
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger); // Basically begins immediately when the unit is spawned with the ability

	// Passive effect to grant 1 point of armor
	Effect = new class'X2Effect_EstablishedDefensesArmorBonus';
	Effect.EffectName = default.EstablishedDefensesOverwatchArmorEffectName;
	Effect.DuplicateResponse = eDupe_Allow; // Allow multiple effects to stack points of armor
	Effect.BuildPersistentEffect(1,,,, eGameRule_PlayerTurnBegin); // Lasts for 1 turn
	Effect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, false,, Template.AbilitySourceName);
	Template.AddShooterEffect(Effect); // Effects added to the shooter

	// Function delegate for setting up a standard XComGameState_Ability object for this ability
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!
	// No function delegates for creating function visualizations because this passive ability isn't showy

	return Template;
}

// Currently using the armor ability for Established Defenses, not this defense ability
static function X2AbilityTemplate EstablishedDefensesOverwatchDefense()
{
	local X2AbilityTemplate						Template;
	local X2Effect_PersistentStatChange         Effect;

	// This is some sort of macro by Firaxis that sets up an ability template with localized text from XComGame.int (and maybe some other stuff?)
	`CREATE_X2ABILITY_TEMPLATE(Template, default.EstablishedDefensesOverwatchDefenseAbilityName);

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow; // This ability doesn't show up on the action HUD (can't click to activate it)
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_fortress";

	Template.AbilityToHitCalc = default.DeadEye; // Always hits
	Template.AbilityTargetStyle = default.SelfTarget; // Applies to the unit with the ability
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger); // Basically begins immediately when the unit is spawned with the ability

	// This passive effect contains the logic for updating armor values based on changing conditions
	Effect = new class'X2Effect_PersistentStatChange';
	Effect.EffectName = default.EstablishedDefensesOverwatchDefenseEffectName;
	Effect.DuplicateResponse = eDupe_Allow; // Shouldn't be a case where multiple copies of the passive effect are applied, but if they are ignore the new one
	Effect.AddPersistentStatChange(eStat_Defense, default.EstablishedDefensesDefenseBonus);
	Effect.BuildPersistentEffect(1,,,, eGameRule_PlayerTurnBegin); // Lasts for 1 turn
	Effect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, false,, Template.AbilitySourceName);
	Template.AddShooterEffect(Effect); // Effects added to the shooter

	// Function delegate for setting up a standard XComGameState_Ability object for this ability
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!
	// No function delegates for creating function visualizations because this passive ability isn't showy

	return Template;
}


//---------------------------------------------------------------------------------------------------
// Harrier
//---------------------------------------------------------------------------------------------------


static function X2AbilityTemplate Harrier()
{
	local X2AbilityTemplate						Template;
	local X2Effect_ToHitModifier                Effect;
	local X2Condition_FlankedTarget             FlankedCondition;

	// Log statements write to the debug log window
	`LOG("Lucubration Infantry Class: Harrier aim bonus=" @ string(default.HarrierAimBonus));
	`LOG("Lucubration Infantry Class: Harrier crit bonus=" @ string(default.HarrierCritBonus));

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Harrier');

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_shadowstrike";

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	Effect = new class'X2Effect_ToHitModifier';
	Effect.EffectName = 'Harrier';
	Effect.DuplicateResponse = eDupe_Ignore;
	Effect.BuildPersistentEffect(1, true, false);
	Effect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage,,,Template.AbilitySourceName);
	Effect.AddEffectHitModifier(eHit_Success, default.HarrierAimBonus, Template.LocFriendlyName);//, /*StandardAim*/, true, true, true, false);
	Effect.AddEffectHitModifier(eHit_Crit, default.HarrierCritBonus, Template.LocFriendlyName);//, /*StandardAim*/, true, true, true, false);
	FlankedCondition = new class'X2Condition_FlankedTarget';
	Effect.ToHitConditions.AddItem(FlankedCondition);
	Template.AddTargetEffect(Effect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!
	
	Template.bCrossClassEligible = true;

	return Template;
}


//---------------------------------------------------------------------------------------------------
// Crippling Shot (Deprecated)
//---------------------------------------------------------------------------------------------------


static function X2AbilityTemplate CripplingShot()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_Ammo                AmmoCost;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2Effect_PersistentStatChange     CripplingEffect;
	local array<name>                       SkipExclusions;
	local X2AbilityToHitCalc_StandardAim    StandardAim;
	local X2AbilityCooldown                 Cooldown;
	
	`LOG("Lucubration Infantry Class: Crippling Shot aim bonus=" @ string(default.CripplingShotAimBonus));
	`LOG("Lucubration Infantry Class: Crippling Shot ammo cost=" @ string(default.CripplingShotAmmoCost));
	`LOG("Lucubration Infantry Class: Crippling Shot action point cost=" @ string(default.CripplingShotActionPointCost));
	`LOG("Lucubration Infantry Class: Crippling Shot cooldown=" @ string(default.CripplingShotCooldown));
	`LOG("Lucubration Infantry Class: Crippling Shot duration=" @ string(default.CripplingShotDuration));
	`LOG("Lucubration Infantry Class: Crippling Shot mobility reduction=" @ string(default.CripplingShotMobilityReduction));
	`LOG("Lucubration Infantry Class: Crippling Shot dodge reduction=" @ string(default.CripplingShotDodgeReduction));

	`CREATE_X2ABILITY_TEMPLATE(Template, 'CripplingShot');
	
	Template.AdditionalAbilities.AddItem('CripplingShotDamage');

	// Icon Properties
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_bulletshred";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_LIEUTENANT_PRIORITY;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.DisplayTargetHitChance = true;
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";

	// Activated by a button press; additionally, tells the AI this is an activatable
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	// *** VALIDITY CHECKS *** //
	//  Normal effect restrictions (except disoriented)
	SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
	Template.AddShooterEffectExclusions(SkipExclusions);

	// Targeting Details
	// Can only shoot visible enemies
	Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);
	// Can't target dead; Can't target friendlies
	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);
	// Can't shoot while dead
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	// Only at single targets that are in range.
	Template.AbilityTargetStyle = default.SimpleSingleTarget;

	// Action Point
	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = default.CripplingShotActionPointCost;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	// Ammo
	AmmoCost = new class'X2AbilityCost_Ammo';	
	AmmoCost.iAmmo = default.CripplingShotAmmoCost;
	Template.AbilityCosts.AddItem(AmmoCost);
	Template.bAllowAmmoEffects = true;

	// Cooldown
	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.CripplingShotCooldown;
	Template.AbilityCooldown = Cooldown;

	// Weapon Upgrade Compatibility
	Template.bAllowFreeFireWeaponUpgrade = true; // Flag that permits action to become 'free action' via 'Hair Trigger' or similar upgrade / effects

	// Allows this attack to work with the Holo-Targeting and Shredder perks, in case of AWC perkage
	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());
	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.ShredderDamageEffect());

	// There's some nice stuff built into the standard aim calculations, including a place to apply the aim bonus
	StandardAim = new class'X2AbilityToHitCalc_StandardAim';
	StandardAim.BuiltInHitMod = default.CripplingShotAimBonus;
	Template.AbilityToHitCalc = StandardAim;
	Template.AbilityToHitOwnerOnMissCalc = StandardAim;
		
	// Targeting Method. There's other ones that let you do grenade spheres, cones, etc. This is the standard, single-target selection
	Template.TargetingMethod = class'X2TargetingMethod_OverTheShoulder';
	Template.bUsesFiringCamera = true;
	Template.CinescriptCameraType = "StandardGunFiring";
	
	CripplingEffect = new class'X2Effect_PersistentStatChange';
	CripplingEffect.EffectName = default.CrippledEffectName;
	CripplingEffect.DuplicateResponse = eDupe_Refresh; // Refresh the duration of this debuff if it's already active
	CripplingEffect.BuildPersistentEffect(default.CripplingShotDuration,, false,,eGameRule_PlayerTurnBegin);
	CripplingEffect.SetDisplayInfo(ePerkBuff_Penalty, default.CrippledFriendlyName, default.CrippledFriendlyDesc, "img:///UILibrary_PerkIcons.UIPerk_disoriented");
	CripplingEffect.AddPersistentStatChange(eStat_Mobility, default.CripplingShotMobilityReduction);
	CripplingEffect.AddPersistentStatChange(eStat_Dodge, default.CripplingShotDodgeReduction);
	CripplingEffect.VisualizationFn = static.CrippledVisualization;
	CripplingEffect.EffectTickedVisualizationFn = static.CrippledVisualizationTicked;
	CripplingEffect.EffectRemovedVisualizationFn = static.CrippledVisualizationRemoved;
	CripplingEffect.EffectHierarchyValue = class'X2StatusEffects'.default.DISORIENTED_HIERARCHY_VALUE;
	CripplingEffect.bRemoveWhenTargetDies = true;
	CripplingEffect.bIsImpairingMomentarily = true;
	Template.AddTargetEffect(CripplingEffect);

	// MAKE IT LIVE!
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;	

	return Template;	
}

// I could either create a new X2Effect_Crippled to display these visualizations (the flyover text), or I could
// use these static functions as delegates for creating the visualizations using the X2Effect_PersistentStateChange.
// I'm not going to make a new class just for this if it's not required
static function CrippledVisualization(XComGameState VisualizeGameState, out VisualizationTrack BuildTrack, const name EffectApplyResult)
{
	if( EffectApplyResult != 'AA_Success' )
	{
		return;
	}
	if (XComGameState_Unit(BuildTrack.StateObject_NewState) == none)
		return;

	class'X2StatusEffects'.static.AddEffectSoundAndFlyOverToTrack(BuildTrack, VisualizeGameState.GetContext(), default.CrippledFriendlyName, '', eColor_Bad, class'UIUtilities_Image'.const.UnitStatus_Marked);
	class'X2StatusEffects'.static.AddEffectMessageToTrack(BuildTrack, default.CrippledEffectAcquiredString, VisualizeGameState.GetContext());
	class'X2StatusEffects'.static.UpdateUnitFlag(BuildTrack, VisualizeGameState.GetContext());
}

static function CrippledVisualizationTicked(XComGameState VisualizeGameState, out VisualizationTrack BuildTrack, const name EffectApplyResult)
{
	local XComGameState_Unit UnitState;

	UnitState = XComGameState_Unit(BuildTrack.StateObject_NewState);
	if (UnitState == none)
		return;

	// dead units should not be reported
	if( !UnitState.IsAlive() )
	{
		return;
	}

	class'X2StatusEffects'.static.AddEffectSoundAndFlyOverToTrack(BuildTrack, VisualizeGameState.GetContext(), default.CrippledFriendlyName, '', eColor_Bad, class'UIUtilities_Image'.const.UnitStatus_Marked);
	class'X2StatusEffects'.static.AddEffectMessageToTrack(BuildTrack, default.CrippledEffectTickedString, VisualizeGameState.GetContext());
	class'X2StatusEffects'.static.UpdateUnitFlag(BuildTrack, VisualizeGameState.GetContext());
}

static function CrippledVisualizationRemoved(XComGameState VisualizeGameState, out VisualizationTrack BuildTrack, const name EffectApplyResult)
{
	local XComGameState_Unit UnitState;

	UnitState = XComGameState_Unit(BuildTrack.StateObject_NewState);
	if (UnitState == none)
		return;

	// dead units should not be reported
	if( !UnitState.IsAlive() )
	{
		return;
	}

	class'X2StatusEffects'.static.AddEffectMessageToTrack(BuildTrack, default.CrippledEffectLostString, VisualizeGameState.GetContext());
	class'X2StatusEffects'.static.UpdateUnitFlag(BuildTrack, VisualizeGameState.GetContext());
}

// The damage reduction is a seperate effect because it affects the shooter, not the shooter's target. It's a persistent
// effect that hangs around on the shooter and just modifies the damage for the Crippling Shot ability when it sees it
static function X2AbilityTemplate CripplingShotDamage()
{
	local X2AbilityTemplate						Template;
	local X2Effect_CripplingShotDamage          DamageEffect;

	// Icon Properties
	`CREATE_X2ABILITY_TEMPLATE(Template, 'CripplingShotDamage');
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_momentum";

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	DamageEffect = new class'X2Effect_CripplingShotDamage';
	DamageEffect.BuildPersistentEffect(1, true, false);
	DamageEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, false,,Template.AbilitySourceName);
	Template.AddTargetEffect(DamageEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!

	return Template;
}


//---------------------------------------------------------------------------------------------------
// Staggering Shot
//---------------------------------------------------------------------------------------------------


static function X2AbilityTemplate StaggeringShot()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_Ammo                AmmoCost;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2Effect_Staggered			    StaggeredEffect;
	local array<name>                       SkipExclusions;
	local X2AbilityToHitCalc_StandardAim    StandardAim;
	local X2AbilityCooldown                 Cooldown;
	
	`LOG("Lucubration Infantry Class: Staggering Shot aim bonus=" @ string(default.StaggeringShotAimBonus));
	`LOG("Lucubration Infantry Class: Staggering Shot damage multiplier=" @ string(class'X2Effect_StaggeringShotDamage'.default.DamageMultiplier));
	`LOG("Lucubration Infantry Class: Staggering Shot ammo cost=" @ string(default.StaggeringShotAmmoCost));
	`LOG("Lucubration Infantry Class: Staggering Shot action point cost=" @ string(default.StaggeringShotActionPointCost));
	`LOG("Lucubration Infantry Class: Staggering Shot cooldown=" @ string(default.StaggeringShotCooldown));
	`LOG("Lucubration Infantry Class: Staggering Shot dodge reduction=" @ string(default.StaggeringShotDodgeReduction));
	`LOG("Lucubration Infantry Class: Staggering Shot duration=" @ string(default.StaggeringShotDuration));

	`CREATE_X2ABILITY_TEMPLATE(Template, 'StaggeringShot');
	
	Template.AdditionalAbilities.AddItem('StaggeringShotDamage');

	// Icon Properties
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_bulletshred";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_LIEUTENANT_PRIORITY;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.DisplayTargetHitChance = true;
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";

	// Activated by a button press; additionally, tells the AI this is an activatable
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	// *** VALIDITY CHECKS *** //
	//  Normal effect restrictions (except disoriented)
	SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
	Template.AddShooterEffectExclusions(SkipExclusions);

	// Targeting Details
	// Can only shoot visible enemies
	Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);
	// Can't target dead; Can't target friendlies
	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);
	// Can't shoot while dead
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	// Only at single targets that are in range.
	Template.AbilityTargetStyle = default.SimpleSingleTarget;

	// Action Point
	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = default.StaggeringShotActionPointCost;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	// Ammo
	AmmoCost = new class'X2AbilityCost_Ammo';	
	AmmoCost.iAmmo = default.StaggeringShotAmmoCost;
	Template.AbilityCosts.AddItem(AmmoCost);
	Template.bAllowAmmoEffects = true;

	// Cooldown
	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.StaggeringShotCooldown;
	Template.AbilityCooldown = Cooldown;

	// Weapon Upgrade Compatibility
	Template.bAllowFreeFireWeaponUpgrade = true; // Flag that permits action to become 'free action' via 'Hair Trigger' or similar upgrade / effects

	// Allows this attack to work with the Holo-Targeting and Shredder perks, in case of AWC perkage
	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());
	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.ShredderDamageEffect());

	// There's some nice stuff built into the standard aim calculations, including a place to apply the aim bonus
	StandardAim = new class'X2AbilityToHitCalc_StandardAim';
	StandardAim.BuiltInHitMod = default.StaggeringShotAimBonus;
	StandardAim.bAllowCrit = false;
	Template.AbilityToHitCalc = StandardAim;
	Template.AbilityToHitOwnerOnMissCalc = StandardAim;
		
	// Targeting Method. There's other ones that let you do grenade spheres, cones, etc. This is the standard, single-target selection
	Template.TargetingMethod = class'X2TargetingMethod_OverTheShoulder';
	Template.bUsesFiringCamera = true;
	Template.CinescriptCameraType = "StandardGunFiring";
	
	StaggeredEffect = new class'X2Effect_Staggered';
	StaggeredEffect.EffectName = default.StaggeredEffectName;
	StaggeredEffect.DuplicateResponse = eDupe_Refresh; // Refresh the duration of this debuff if it's already active
	StaggeredEffect.BuildPersistentEffect(default.StaggeringShotDuration,,, true, eGameRule_PlayerTurnBegin);
	StaggeredEffect.SetDisplayInfo(ePerkBuff_Penalty, default.StaggeredFriendlyName, default.StaggeredFriendlyDesc, "img:///UILibrary_PerkIcons.UIPerk_disoriented");
	StaggeredEffect.AddPersistentStatChange(eStat_Dodge, default.StaggeringShotDodgeReduction);
	StaggeredEffect.VisualizationFn = static.StaggeredVisualization;
	StaggeredEffect.EffectTickedVisualizationFn = static.StaggeredVisualizationTicked;
	StaggeredEffect.EffectRemovedVisualizationFn = static.StaggeredVisualizationRemoved;
	StaggeredEffect.EffectHierarchyValue = class'X2StatusEffects'.default.DISORIENTED_HIERARCHY_VALUE;
	StaggeredEffect.bRemoveWhenTargetDies = true;
	StaggeredEffect.bIsImpairingMomentarily = true;
	Template.AddTargetEffect(StaggeredEffect);
	
	// MAKE IT LIVE!
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	return Template;	
}

// The damage reduction is a seperate effect because it affects the shooter, not the shooter's target. It's a persistent
// effect that hangs around on the shooter and just modifies the damage for the Staggering Shot ability when it sees it
static function X2AbilityTemplate StaggeringShotDamage()
{
	local X2AbilityTemplate						Template;
	local X2Effect_StaggeringShotDamage			DamageEffect;

	// Icon Properties
	`CREATE_X2ABILITY_TEMPLATE(Template, 'StaggeringShotDamage');
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_momentum";

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	DamageEffect = new class'X2Effect_StaggeringShotDamage';
	DamageEffect.BuildPersistentEffect(1, true, false);
	DamageEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, false,,Template.AbilitySourceName);
	Template.AddTargetEffect(DamageEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!

	return Template;
}

static function StaggeredVisualization(XComGameState VisualizeGameState, out VisualizationTrack BuildTrack, const name EffectApplyResult)
{
	if( EffectApplyResult != 'AA_Success' )
	{
		return;
	}
	if (XComGameState_Unit(BuildTrack.StateObject_NewState) == none)
		return;

	class'X2StatusEffects'.static.AddEffectSoundAndFlyOverToTrack(BuildTrack, VisualizeGameState.GetContext(), default.StaggeredFriendlyName, '', eColor_Bad, class'UIUtilities_Image'.const.UnitStatus_Marked);
	class'X2StatusEffects'.static.AddEffectMessageToTrack(BuildTrack, default.StaggeredEffectAcquiredString, VisualizeGameState.GetContext());
	class'X2StatusEffects'.static.UpdateUnitFlag(BuildTrack, VisualizeGameState.GetContext());
}

static function StaggeredVisualizationTicked(XComGameState VisualizeGameState, out VisualizationTrack BuildTrack, const name EffectApplyResult)
{
	local XComGameState_Unit UnitState;

	UnitState = XComGameState_Unit(BuildTrack.StateObject_NewState);
	if (UnitState == none)
		return;

	// dead units should not be reported
	if( !UnitState.IsAlive() )
	{
		return;
	}

	class'X2StatusEffects'.static.AddEffectSoundAndFlyOverToTrack(BuildTrack, VisualizeGameState.GetContext(), default.StaggeredFriendlyName, '', eColor_Bad, class'UIUtilities_Image'.const.UnitStatus_Marked);
	class'X2StatusEffects'.static.AddEffectMessageToTrack(BuildTrack, default.StaggeredEffectTickedString, VisualizeGameState.GetContext());
	class'X2StatusEffects'.static.UpdateUnitFlag(BuildTrack, VisualizeGameState.GetContext());
}

static function StaggeredVisualizationRemoved(XComGameState VisualizeGameState, out VisualizationTrack BuildTrack, const name EffectApplyResult)
{
	local XComGameState_Unit UnitState;

	UnitState = XComGameState_Unit(BuildTrack.StateObject_NewState);
	if (UnitState == none)
		return;

	// dead units should not be reported
	if( !UnitState.IsAlive() )
	{
		return;
	}

	class'X2StatusEffects'.static.AddEffectMessageToTrack(BuildTrack, default.StaggeredEffectLostString, VisualizeGameState.GetContext());
	class'X2StatusEffects'.static.UpdateUnitFlag(BuildTrack, VisualizeGameState.GetContext());
}


//---------------------------------------------------------------------------------------------------
// Shake it Off
//---------------------------------------------------------------------------------------------------


static function X2AbilityTemplate ShakeItOff()
{
	local X2AbilityTemplate				Template;
	local X2Effect_ShakeItOff			Effect;
	
	`CREATE_X2ABILITY_TEMPLATE(Template, 'ShakeItOff');
	
	//Template.AdditionalAbilities.AddItem('TestDisoriented');
	//Template.AdditionalAbilities.AddItem('TestStunned');
	//Template.AdditionalAbilities.AddItem('TestConfused');
	//Template.AdditionalAbilities.AddItem('TestPanicked');
	//Template.AdditionalAbilities.AddItem('TestUnconscious');
	
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_revivalprotocol";
	Template.bIsPassive = true;
	
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	
	Effect = new class'X2Effect_ShakeItOff';
	Effect.EffectName='ShakeItOff';
	Effect.BuildPersistentEffect(1, true, false, true, eGameRule_PlayerTurnEnd);
	Effect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage,,,Template.AbilitySourceName);
	Effect.AddPersistentStatChange(eStat_Will, default.ShakeItOffWillBonus);
	Effect.DuplicateResponse = eDupe_Ignore;
	Template.AddTargetEffect(Effect);
	
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//Template.BuildVisualizationFn = TypicalAbility_BuildVisualization
	
	return Template;
}


//---------------------------------------------------------------------------------------------------
// Stick and Move
//---------------------------------------------------------------------------------------------------


static function X2AbilityTemplate StickAndMove()
{
	local X2AbilityTemplate         Template;
	local X2Effect_StickAndMove     Effect;
	
	`CREATE_X2ABILITY_TEMPLATE(Template, 'StickAndMove');

	Template.AdditionalAbilities.AddItem(default.StickAndMoveMobilityAbilityName);
	Template.AdditionalAbilities.AddItem(default.StickAndMoveDamageAbilityName);
	
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_stickandmove";
	Template.bIsPassive = true;
	
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
		
	Effect = new class'X2Effect_StickAndMove';
	Effect.EffectName='StickAndMove';
	Effect.BuildPersistentEffect(1, true, false);
	Effect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage,,,Template.AbilitySourceName);
	Effect.DuplicateResponse = eDupe_Ignore;
	Template.AddTargetEffect(Effect);
	
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!

	return Template;
}

static function X2AbilityTemplate StickAndMoveDamage()
{
	local X2AbilityTemplate                 Template;
	local X2Effect_StickAndMoveDamage		DamageEffect;
	local array<name>                       SkipExclusions;
	
	`LOG("Lucubration Infantry Class: Stick And Move damage bonus=" @ string(default.StickAndMoveDamageBonus));
	`LOG("Lucubration Infantry Class: Stick And Move defense bonus=" @ string(default.StickAndMoveDefenseBonus));

	`CREATE_X2ABILITY_TEMPLATE(Template, default.StickAndMoveDamageAbilityName);

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	// Triggered by the passive effect gamestate instead of using ability triggers. Not sure this
	// is the best way to do this, but I wanted to be pretty explicit about the conditions under
	// which it gets activated
	Template.AbilityTriggers.AddItem(new class'X2AbilityTrigger_Placeholder');
	
	// Specifically exclude activation while dead or already under the effect
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	SkipExclusions.AddItem(default.StickAndMoveMobilityEffectName);
	Template.AddShooterEffectExclusions(SkipExclusions);

	// The active effect (combines bonus damage and defense stat boost)
	DamageEffect = new class'X2Effect_StickAndMoveDamage';
	DamageEffect.EffectName = default.StickAndMoveDamageEffectName;
	DamageEffect.SetDisplayInfo(ePerkBuff_Bonus, default.StickAndMoveDamageFriendlyName, default.StickAndMoveDamageFriendlyDesc, "img:///UILibrary_PerkIcons.UIPerk_momentum");
	DamageEffect.AddPersistentStatChange(eStat_Defense, default.StickAndMoveDefenseBonus);
	DamageEffect.BuildPersistentEffect(1, true);
	Template.AddTargetEffect(DamageEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!

	return Template;
}

static function X2AbilityTemplate StickAndMoveMobility()
{
	local X2AbilityTemplate                 Template;
	local X2Effect_PersistentStatChange		MoveEffect;
	local array<name>                       SkipExclusions;
	
	`LOG("Lucubration Infantry Class: Stick And Move mobility bonus=" @ string(default.StickAndMoveMobilityBonus));

	`CREATE_X2ABILITY_TEMPLATE(Template, default.StickAndMoveMobilityAbilityName);

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	// Triggered by the passive effect gamestate instead of using ability triggers. Not sure this
	// is the best way to do this, but I wanted to be pretty explicit about the conditions under
	// which it gets activated
	Template.AbilityTriggers.AddItem(new class'X2AbilityTrigger_Placeholder');
	
	// Specifically exclude activation while dead or already under the effect
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	SkipExclusions.AddItem(default.StickAndMoveMobilityEffectName);
	Template.AddShooterEffectExclusions(SkipExclusions);

	// The active effect
	MoveEffect = new class'X2Effect_PersistentStatChange';
	MoveEffect.EffectName = default.StickAndMoveMobilityEffectName;
	MoveEffect.SetDisplayInfo(ePerkBuff_Bonus, default.StickAndMoveMobilityFriendlyName, default.StickAndMoveMobilityFriendlyDesc, "img:///UILibrary_PerkIcons.UIPerk_momentum");
	MoveEffect.AddPersistentStatChange(eStat_Mobility, default.StickAndMoveMobilityBonus);
	MoveEffect.BuildPersistentEffect(1, true);
	Template.AddTargetEffect(MoveEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!

	return Template;
}

static function X2AbilityTemplate StickAndMoveDodge()
{
	local X2AbilityTemplate                 Template;
	local X2Effect_PersistentStatChange		MoveEffect;
	local array<name>                       SkipExclusions;
	
	`LOG("Lucubration Infantry Class: Stick And Move dodge bonus=" @ string(default.StickAndMoveDodgeBonus));
	`LOG("Lucubration Infantry Class: Stick And Move dodge duration=" @ string(default.StickAndMoveDodgeDuration));

	`CREATE_X2ABILITY_TEMPLATE(Template, default.StickAndMoveDodgeAbilityName);

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	// Specifically exclude activation while dead or already under the effect
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	SkipExclusions.AddItem(default.StickAndMoveDodgeEffectName);
	Template.AddShooterEffectExclusions(SkipExclusions);

	// Triggered by the passive effect gamestate instead of using ability triggers. Not sure this
	// is the best way to do this, but I wanted to be pretty explicit about the conditions under
	// which it gets activated
	Template.AbilityTriggers.AddItem(new class'X2AbilityTrigger_Placeholder');
	
	// The active effect
	MoveEffect = new class'X2Effect_PersistentStatChange';
	MoveEffect.EffectName = 'StickAndMoveDodge';
	MoveEffect.SetDisplayInfo(ePerkBuff_Bonus, default.StickAndMoveDodgeFriendlyName, default.StickAndMoveDodgeFriendlyDesc, "img:///UILibrary_PerkIcons.UIPerk_momentum");
	MoveEffect.AddPersistentStatChange(eStat_Dodge, default.StickAndMoveDodgeBonus);
	MoveEffect.BuildPersistentEffect(default.StickAndMoveDodgeDuration,,,, eGameRule_PlayerTurnBegin);
	Template.AddTargetEffect(MoveEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!

	return Template;
}


//---------------------------------------------------------------------------------------------------
// Explosive Action
//---------------------------------------------------------------------------------------------------


static function X2AbilityTemplate ExplosiveAction()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityCooldown					Cooldown;
	local X2Effect_ExplosiveAction          ActionEffect;
	local X2Effect_ExplosiveActionRecovery	RecoveryEffect;
	
	`LOG("Lucubration Infantry Class: Explosive Action cooldown=" @ string(default.ExplosiveActionCooldown));
	`LOG("Lucubration Infantry Class: Explosive Action bonus action points=" @ string(default.ExplosiveActionBonusActionPoints));
	`LOG("Lucubration Infantry Class: Explosive Action recovery delay=" @ string(default.ExplosiveActionRecoveryDelay));
	`LOG("Lucubration Infantry Class: Explosive Action recovery action points=" @ string(default.ExplosiveActionRecoveryActionPoints));

	`CREATE_X2ABILITY_TEMPLATE(Template, 'ExplosiveAction');
	
	// Icon Properties
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_shaken";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";
	
	// Activated by a button press; additionally, tells the AI this is an activatable
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	// Can't shoot while dead
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	
	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bFreeCost = true;
	Template.AbilityCosts.AddItem(ActionPointCost);
	
	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.ExplosiveActionCooldown;
	Template.AbilityCooldown = Cooldown;

	Template.AbilityToHitCalc = default.DeadEye;

	Template.AbilityTargetStyle = default.SelfTarget;
	
	// Effect to immediately add action point(s)
	ActionEffect = new class'X2Effect_ExplosiveAction';
	ActionEffect.BonusActionPoints = default.ExplosiveActionBonusActionPoints;
	Template.AddTargetEffect(ActionEffect);

	// Delayed effect to eventually remove action point(s)
	RecoveryEffect = new class'X2Effect_ExplosiveActionRecovery';
	RecoveryEffect.EffectName = 'ExplosivelyRecovering';
	RecoveryEffect.DuplicateResponse = eDupe_Ignore;
	RecoveryEffect.EffectHierarchyValue = class'X2StatusEffects'.default.FRENZY_HIERARCHY_VALUE;
	RecoveryEffect.bRemoveWhenTargetDies = true;
	RecoveryEffect.RecoveryActionPoints = default.ExplosiveActionRecoveryActionPoints;
	RecoveryEffect.SetDisplayInfo(ePerkBuff_Penalty, default.ExplosiveActionRecoveryFriendlyName, default.ExplosiveActionRecoveryFriendlyDesc, "img:///UILibrary_PerkIcons.UIPerk_shaken", true,, Template.AbilitySourceName);
	RecoveryEffect.BuildPersistentEffect(default.ExplosiveActionRecoveryDelay,,,, eGameRule_PlayerTurnBegin);
	Template.AddTargetEffect(RecoveryEffect);
	
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	Template.Hostility = eHostility_Defensive;
	Template.bDisplayInUITooltip = false;
	Template.bLimitTargetIcons = true;
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.ActivationSpeech = 'CombatStim';
	
	Template.bShowActivation = true;
	Template.bSkipFireAction = true;
	Template.CustomSelfFireAnim = 'FF_FireMedkitSelf';
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	
	Template.bCrossClassEligible = true;

	return Template;
}


//---------------------------------------------------------------------------------------------------
// Zone of Control
//---------------------------------------------------------------------------------------------------


static function X2AbilityTemplate ZoneOfControl()
{
	local X2AbilityTemplate						Template;
	local X2Effect_ZoneOfControl				Effect;
	//local X2Effect_SetUnitValue					SetUnitValueEffect;
	
	`LOG("Lucubration Infantry Class: Zone of Control reaction fire radius=" @ string(default.ZoneOfControlReactionFireRadius));
	`LOG("Lucubration Infantry Class: Zone of Control reaction fire shots per turn=" @ string(default.ZoneOfControlReactionFireShotsPerTurn));
	`LOG("Lucubration Infantry Class: Zone of Control counterattack chance=" @ string(default.ZoneOfControlCounterAttackChance));
	`LOG("Lucubration Infantry Class: Zone of Control counterattacks per turn=" @ string(default.ZoneOfControlCounterAttacksPerTurn));

	`CREATE_X2ABILITY_TEMPLATE(Template, 'ZoneOfControl');

	Template.AdditionalAbilities.AddItem(default.ZoneOfControlReactionFireAbilityName);
	Template.AdditionalAbilities.AddItem(default.ZoneOfControlCounterAttackAbilityName);
	Template.AdditionalAbilities.AddItem(default.ZoneOfControlCounterAttackDefenseAbilityName);

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_sentinel";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_LIEUTENANT_PRIORITY;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	// This effect controls adding action points to allow the unit to perform reaction fires and counterattacks
	Effect = new class'X2Effect_ZoneOfControl';
	Effect.EffectName = 'ZoneOfControl';
	Effect.DuplicateResponse = eDupe_Ignore;
	Effect.BuildPersistentEffect(1, true, false,, eGameRule_PlayerTurnBegin);
	Effect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage,,,Template.AbilitySourceName);
	Template.AddTargetEffect(Effect);
	
	// This unit value is checked by the engine to convert misses and grazes into counterattacks. The soldier can
	// always counterattack, so this is being set once and left active for the whole tactical mission. We will only
	// force one counterattack per turn, however; others will occur naturally if at all
	
	// Now trying to perform the same listening manually instead of via the counterattack listener
	//SetUnitValueEffect = new class'X2Effect_SetUnitValue';
	//SetUnitValueEffect.UnitName = class'X2Ability'.default.CounterattackDodgeEffectName;
	//SetUnitValueEffect.NewValueToSet = class'X2Ability'.default.CounterattackDodgeUnitValue;
	//SetUnitValueEffect.CleanupType = eCleanup_BeginTactical;
	//Template.AddTargetEffect(SetUnitValueEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!

	return Template;
}

static function X2AbilityTemplate ZoneOfControlShot()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ReserveActionPoints ReserveActionPointCost;
	local X2AbilityTrigger_Event	        Trigger;
	local X2Condition_ZoneOfControlRange	RangeCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, default.ZoneOfControlReactionFireAbilityName);	
	class'X2Ability_DefaultAbilitySet'.static.PistolOverwatchShotHelper(Template);
	Template.bShowActivation = true;
	
	// Replace the cost with our reserved action point type
	ReserveActionPointCost = X2AbilityCost_ReserveActionPoints(Template.AbilityCosts[0]);
	ReserveActionPointCost.AllowedTypes.Length = 0;
	ReserveActionPointCost.AllowedTypes.AddItem(default.ZoneOfControlActionPointName);

	// Add an attack trigger
	Trigger = new class'X2AbilityTrigger_Event';
	Trigger.EventObserverClass = class'X2TacticalGameRuleset_AttackObserver';
	Trigger.MethodName = 'InterruptGameState';
	Template.AbilityTriggers.AddItem(Trigger);
	
	// Don't shoot at targets outside the Zone of Control range
	RangeCondition = new class'X2Condition_ZoneOfControlRange';
	RangeCondition.ReactionFireRadius = default.ZoneOfControlReactionFireRadius;
	Template.AbilityTargetConditions.AddItem(RangeCondition);
	
	return Template;
}

static function X2AbilityTemplate ZoneOfControlCounterAttack()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints		ActionPointCost;
	//local X2AbilityTrigger_EventListener	EventListener;
	local X2Condition_ZoneOfControlRange	RangeCondition;
	local X2Effect_RemoveEffects			RemoveEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, default.ZoneOfControlCounterAttackAbilityName);
	class'X2Ability_DefaultAbilitySet'.static.PistolOverwatchShotHelper(Template);
	Template.bShowActivation = true;
	
	Template.AbilityToHitCalc = new class'X2AbilityToHitCalc_StandardMelee'; // Pretend this is a melee attack
	
	// Clear the existing action point costs
	Template.AbilityCosts.Length = 0;
	// Create an action point cost for melee counterattack
	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.AllowedTypes.AddItem(class'X2CharacterTemplateManager'.default.CounterattackActionPoint);
	Template.AbilityCosts.AddItem(ActionPointCost);
	
	// Replace the movement trigger with the counter attack event listener
	Template.AbilityTriggers.Length = 0;
	// Stop annoying redscreen error
	Template.AbilityTriggers.AddItem(new class'X2AbilityTrigger_Placeholder');
	
	// Now trying to perform the same listening manually instead of via the counterattack listener
	//EventListener = new class'X2AbilityTrigger_EventListener';
	//EventListener.ListenerData.Deferral = ELD_OnStateSubmitted;
	//EventListener.ListenerData.EventID = 'AbilityActivated';
	//EventListener.ListenerData.EventFn = class'XComGameState_Ability'.static.MeleeCounterattackListener;
	//Template.AbilityTriggers.AddItem(EventListener);

	// Don't shoot at targets outside the melee range
	RangeCondition = new class'X2Condition_ZoneOfControlRange';
	RangeCondition.ReactionFireRadius = 1;
	Template.AbilityTargetConditions.AddItem(RangeCondition);

	// Remove the defense effect when the counterattack executes
	RemoveEffect = new class'X2Effect_RemoveEffects';
	RemoveEffect.EffectNamesToRemove.AddItem(default.ZoneOfControlCounterAttackDefenseEffectName);
	RemoveEffect.bApplyOnMiss = true;
	Template.AddShooterEffect(RemoveEffect);
	
	// Animation works now, so we're going to rifle-butt them. Yay!
	Template.CustomFireAnim = 'FF_Melee';//'FF_Fire';
	Template.BuildVisualizationFn = ZoneOfControlCounterAttack_BuildVisualization;
	// Not interuptable on purpose
	Template.BuildInterruptGameStateFn = none;
	
	return Template;
}

static function X2AbilityTemplate ZoneOfControlCounterAttackDefense()
{
	local X2AbilityTemplate						Template;
	local X2Effect_ZoneOfControlCounterAttack	Effect;
	
	`CREATE_X2ABILITY_TEMPLATE(Template, default.ZoneOfControlCounterAttackDefenseAbilityName);

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_sentinel";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_LIEUTENANT_PRIORITY;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(new class'X2AbilityTrigger_Placeholder'); // We'll apply this effect programmatically

	// Muton performs counterattack by activating an ability that gives him lots of melee dodge, and the game engine turns grazes into counterattacks.
	// I'm not entirely clear on how this doesn't make the Muton super-dodgy against other attacks in general because the melee attack he wants to counter.
	// Instead of doing that, I'm going to apply an effect that just does a random roll to see if a given melee attack should be auto-missed.
	Effect = new class'X2Effect_ZoneOfControlCounterAttack';
	Effect.EffectName = default.ZoneOfControlCounterAttackDefenseEffectName;
	Effect.DuplicateResponse = eDupe_Ignore;
	Effect.BuildPersistentEffect(1, true); // This effect lasts until it's removed by the counterattack action
	Effect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, false,,Template.AbilitySourceName);
	Template.AddShooterEffect(Effect);
	
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!

	return Template;
}

function ZoneOfControlCounterAttack_BuildVisualization(XComGameState VisualizeGameState, out array<VisualizationTrack> OutVisualizationTracks)
{		
	local X2AbilityTemplate             AbilityTemplate;
	local XComGameStateContext_Ability  Context;
	local AbilityInputContext           AbilityContext;
	local StateObjectReference          ShootingUnitRef;	
	local XComGameState_Unit			ShootingUnit;
	local X2Action                      AddedAction;
	local XComGameState_BaseObject      TargetStateObject;//Container for state objects within VisualizeGameState	
	local XComGameState_Item            SourceWeapon, FakeSourceWeapon;
	local X2AmmoTemplate                AmmoTemplate;
	local X2WeaponTemplate              WeaponTemplate;
	local array<X2Effect>               MultiTargetEffects;
	local bool							bSourceIsAlsoTarget;
	
	local Actor                     TargetVisualizer, ShooterVisualizer;
	local X2VisualizerInterface     TargetVisualizerInterface, ShooterVisualizerInterface;
	local int                       EffectIndex;
	local XComGameState_EnvironmentDamage EnvironmentDamageEvent;
	local XComGameState_WorldEffectTileData WorldDataUpdate;

	local VisualizationTrack        EmptyTrack;
	local VisualizationTrack        BuildTrack;
	local VisualizationTrack        SourceTrack, InterruptTrack;
	local XComGameStateHistory      History;
	local X2Action_MoveTurn         MoveTurnAction;

	local X2Action_PlaySoundAndFlyOver SoundAndFlyover;
	local name         ApplyResult;

	local XComGameState_InteractiveObject InteractiveObject;
	local XComGameState_Ability     AbilityState;
		
	History = `XCOMHISTORY;
	Context = XComGameStateContext_Ability(VisualizeGameState.GetContext());
	AbilityContext = Context.InputContext;
	AbilityState = XComGameState_Ability(History.GetGameStateForObjectID(AbilityContext.AbilityRef.ObjectID));
	AbilityTemplate = class'XComGameState_Ability'.static.GetMyTemplateManager().FindAbilityTemplate(AbilityContext.AbilityTemplateName);
	ShootingUnitRef = Context.InputContext.SourceObject;
	ShootingUnit = XComGameState_Unit(History.GetGameStateForObjectID(AbilityContext.AbilityRef.ObjectID));
	
	//Configure the visualization track for the shooter, part I. We split this into two parts since
	//in some situations the shooter can also be a target
	//****************************************************************************************
	ShooterVisualizer = History.GetVisualizer(ShootingUnitRef.ObjectID);
	ShooterVisualizerInterface = X2VisualizerInterface(ShooterVisualizer);

	XGUnitNativeBase(ShooterVisualizer).GetPawn().UpdateAnimations();

	SourceTrack = EmptyTrack;
	SourceTrack.StateObject_OldState = History.GetGameStateForObjectID(ShootingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
	SourceTrack.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(ShootingUnitRef.ObjectID);
	if (SourceTrack.StateObject_NewState == none)
		SourceTrack.StateObject_NewState = SourceTrack.StateObject_OldState;
	SourceTrack.TrackActor = ShooterVisualizer;

	SourceTrack.AbilityName = AbilityTemplate.DataName;

	SourceWeapon = XComGameState_Item(History.GetGameStateForObjectID(AbilityContext.ItemObject.ObjectID));
	if (SourceWeapon != None)
	{
		WeaponTemplate = X2WeaponTemplate(SourceWeapon.GetMyTemplate());
		AmmoTemplate = X2AmmoTemplate(SourceWeapon.GetLoadedAmmoTemplate(AbilityState));
	}
	
	SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyover'.static.AddToVisualizationTrack(SourceTrack, Context));
	SoundAndFlyOver.SetSoundAndFlyOverParameters(None, class'XLocalizedData'.default.CounterattackMessage, AbilityTemplate.ActivationSpeech, eColor_Good, AbilityTemplate.IconImage);

	// Override the source weapon for the visualization because it looks a lot better without messing with the pistol
	// (the ability technically uses the secondary weapon)
	Context.InputContext.ItemObject.ObjectID = ShootingUnit.GetItemInSlot(eInvSlot_PrimaryWeapon).ObjectID;

	if (!AbilityTemplate.bSkipExitCoverWhenFiring)
	{
		class'X2Action_ExitCover'.static.AddToVisualizationTrack(SourceTrack, Context);
	}

	// No move, just add the fire action
	AddedAction = AbilityTemplate.ActionFireClass.static.AddToVisualizationTrack(SourceTrack, Context);

	if( AbilityTemplate.AbilityToHitCalc != None )
	{
		X2Action_Fire(AddedAction).SetFireParameters( Context.IsResultContextHit() );
	}

	//If there are effects added to the shooter, add the visualizer actions for them
	for (EffectIndex = 0; EffectIndex < AbilityTemplate.AbilityShooterEffects.Length; ++EffectIndex)
	{
		AbilityTemplate.AbilityShooterEffects[EffectIndex].AddX2ActionsForVisualization(VisualizeGameState, SourceTrack, Context.FindShooterEffectApplyResult(AbilityTemplate.AbilityShooterEffects[EffectIndex]));		
	}
	//****************************************************************************************

	//Configure the visualization track for the target(s). This functionality uses the context primarily
	//since the game state may not include state objects for misses.
	//****************************************************************************************	
	bSourceIsAlsoTarget = AbilityContext.PrimaryTarget.ObjectID == AbilityContext.SourceObject.ObjectID; //The shooter is the primary target
	if (AbilityTemplate.AbilityTargetEffects.Length > 0 &&			//There are effects to apply
		AbilityContext.PrimaryTarget.ObjectID > 0)				//There is a primary target
	{
		TargetVisualizer = History.GetVisualizer(AbilityContext.PrimaryTarget.ObjectID);
		TargetVisualizerInterface = X2VisualizerInterface(TargetVisualizer);

		if( bSourceIsAlsoTarget )
		{
			BuildTrack = SourceTrack;
		}
		else
		{
			BuildTrack = InterruptTrack;        //  interrupt track will either be empty or filled out correctly
		}

		BuildTrack.TrackActor = TargetVisualizer;

		TargetStateObject = VisualizeGameState.GetGameStateForObjectID(AbilityContext.PrimaryTarget.ObjectID);
		if( TargetStateObject != none )
		{
			History.GetCurrentAndPreviousGameStatesForObjectID(AbilityContext.PrimaryTarget.ObjectID, 
															   BuildTrack.StateObject_OldState, BuildTrack.StateObject_NewState,
															   eReturnType_Reference,
															   VisualizeGameState.HistoryIndex);
			`assert(BuildTrack.StateObject_NewState == TargetStateObject);
		}
		else
		{
			//If TargetStateObject is none, it means that the visualize game state does not contain an entry for the primary target. Use the history version
			//and show no change.
			BuildTrack.StateObject_OldState = History.GetGameStateForObjectID(AbilityContext.PrimaryTarget.ObjectID);
			BuildTrack.StateObject_NewState = BuildTrack.StateObject_OldState;
		}

		// if this is a melee attack, make sure the target is facing the location he will be melee'd from
		if(!AbilityTemplate.bSkipFireAction 
			&& !bSourceIsAlsoTarget 
			&& AbilityContext.MovementPaths.Length > 0
			&& AbilityContext.MovementPaths[0].MovementData.Length > 0
			&& XGUnit(TargetVisualizer) != none)
		{
			MoveTurnAction = X2Action_MoveTurn(class'X2Action_MoveTurn'.static.AddToVisualizationTrack(BuildTrack, Context));
			MoveTurnAction.m_vFacePoint = AbilityContext.MovementPaths[0].MovementData[AbilityContext.MovementPaths[0].MovementData.Length - 1].Position;
			MoveTurnAction.m_vFacePoint.Z = TargetVisualizerInterface.GetTargetingFocusLocation().Z;
			MoveTurnAction.UpdateAimTarget = true;
		}

		//Make the target wait until signaled by the shooter that the projectiles are hitting
		if (!AbilityTemplate.bSkipFireAction && !bSourceIsAlsoTarget)
		{
			class'X2Action_WaitForAbilityEffect'.static.AddToVisualizationTrack(BuildTrack, Context);
		}
		
		//Add any X2Actions that are specific to this effect being applied. These actions would typically be instantaneous, showing UI world messages
		//playing any effect specific audio, starting effect specific effects, etc. However, they can also potentially perform animations on the 
		//track actor, so the design of effect actions must consider how they will look/play in sequence with other effects.
		for (EffectIndex = 0; EffectIndex < AbilityTemplate.AbilityTargetEffects.Length; ++EffectIndex)
		{
			ApplyResult = Context.FindTargetEffectApplyResult(AbilityTemplate.AbilityTargetEffects[EffectIndex]);

			// Target effect visualization
			AbilityTemplate.AbilityTargetEffects[EffectIndex].AddX2ActionsForVisualization(VisualizeGameState, BuildTrack, ApplyResult);

			// Source effect visualization
			AbilityTemplate.AbilityTargetEffects[EffectIndex].AddX2ActionsForVisualizationSource(VisualizeGameState, SourceTrack, ApplyResult);
		}

		//the following is used to handle Rupture flyover text
		if (XComGameState_Unit(BuildTrack.StateObject_OldState).GetRupturedValue() == 0 &&
			XComGameState_Unit(BuildTrack.StateObject_NewState).GetRupturedValue() > 0)
		{
			//this is the frame that we realized we've been ruptured!
			class 'X2StatusEffects'.static.RuptureVisualization(VisualizeGameState, BuildTrack);
		}

		if (AbilityTemplate.bAllowAmmoEffects && AmmoTemplate != None)
		{
			for (EffectIndex = 0; EffectIndex < AmmoTemplate.TargetEffects.Length; ++EffectIndex)
			{
				ApplyResult = Context.FindTargetEffectApplyResult(AmmoTemplate.TargetEffects[EffectIndex]);
				AmmoTemplate.TargetEffects[EffectIndex].AddX2ActionsForVisualization(VisualizeGameState, BuildTrack, ApplyResult);
				AmmoTemplate.TargetEffects[EffectIndex].AddX2ActionsForVisualizationSource(VisualizeGameState, SourceTrack, ApplyResult);
			}
		}
		if (AbilityTemplate.bAllowBonusWeaponEffects && WeaponTemplate != none)
		{
			for (EffectIndex = 0; EffectIndex < WeaponTemplate.BonusWeaponEffects.Length; ++EffectIndex)
			{
				ApplyResult = Context.FindTargetEffectApplyResult(WeaponTemplate.BonusWeaponEffects[EffectIndex]);
				WeaponTemplate.BonusWeaponEffects[EffectIndex].AddX2ActionsForVisualization(VisualizeGameState, BuildTrack, ApplyResult);
				WeaponTemplate.BonusWeaponEffects[EffectIndex].AddX2ActionsForVisualizationSource(VisualizeGameState, SourceTrack, ApplyResult);
			}
		}

		if (Context.IsResultContextMiss() && (AbilityTemplate.LocMissMessage != "" || AbilityTemplate.TargetMissSpeech != ''))
		{
			SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyover'.static.AddToVisualizationTrack(BuildTrack, Context));
			SoundAndFlyOver.SetSoundAndFlyOverParameters(None, AbilityTemplate.LocMissMessage, AbilityTemplate.TargetMissSpeech, eColor_Bad);
		}
		else if( Context.IsResultContextHit() && (AbilityTemplate.LocHitMessage != "" || AbilityTemplate.TargetHitSpeech != '') )
		{
			SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyover'.static.AddToVisualizationTrack(BuildTrack, Context));
			SoundAndFlyOver.SetSoundAndFlyOverParameters(None, AbilityTemplate.LocHitMessage, AbilityTemplate.TargetHitSpeech, eColor_Good);
		}

		if( TargetVisualizerInterface != none )
		{
			//Allow the visualizer to do any custom processing based on the new game state. For example, units will create a death action when they reach 0 HP.
			TargetVisualizerInterface.BuildAbilityEffectsVisualization(VisualizeGameState, BuildTrack);
		}

		if (!bSourceIsAlsoTarget && BuildTrack.TrackActions.Length > 0)
		{
			OutVisualizationTracks.AddItem(BuildTrack);
		}

		if( bSourceIsAlsoTarget )
		{
			SourceTrack = BuildTrack;
		}
	}

	//****************************************************************************************

	//Finish adding the shooter's track
	//****************************************************************************************
	if( !bSourceIsAlsoTarget && ShooterVisualizerInterface != none)
	{
		ShooterVisualizerInterface.BuildAbilityEffectsVisualization(VisualizeGameState, SourceTrack);				
	}	

	if (!AbilityTemplate.bSkipFireAction)
	{
		if (!AbilityTemplate.bSkipExitCoverWhenFiring)
		{
			Context.InputContext.ItemObject.ObjectID = ShootingUnit.GetItemInSlot(eInvSlot_PrimaryWeapon).ObjectID;
			class'X2Action_EnterCover'.static.AddToVisualizationTrack(SourceTrack, Context);
		}
	}
	
	OutVisualizationTracks.AddItem(SourceTrack);
	//****************************************************************************************

	//Configure the visualization tracks for the environment
	//****************************************************************************************
	foreach VisualizeGameState.IterateByClassType(class'XComGameState_EnvironmentDamage', EnvironmentDamageEvent)
	{
		BuildTrack = EmptyTrack;
		BuildTrack.TrackActor = none;
		BuildTrack.StateObject_NewState = EnvironmentDamageEvent;
		BuildTrack.StateObject_OldState = EnvironmentDamageEvent;

		//Wait until signaled by the shooter that the projectiles are hitting
		if (!AbilityTemplate.bSkipFireAction)
			class'X2Action_WaitForAbilityEffect'.static.AddToVisualizationTrack(BuildTrack, Context);

		for (EffectIndex = 0; EffectIndex < AbilityTemplate.AbilityShooterEffects.Length; ++EffectIndex)
		{
			AbilityTemplate.AbilityShooterEffects[EffectIndex].AddX2ActionsForVisualization(VisualizeGameState, BuildTrack, 'AA_Success');		
		}

		for (EffectIndex = 0; EffectIndex < AbilityTemplate.AbilityTargetEffects.Length; ++EffectIndex)
		{
			AbilityTemplate.AbilityTargetEffects[EffectIndex].AddX2ActionsForVisualization(VisualizeGameState, BuildTrack, 'AA_Success');
		}

		for (EffectIndex = 0; EffectIndex < MultiTargetEffects.Length; ++EffectIndex)
		{
			MultiTargetEffects[EffectIndex].AddX2ActionsForVisualization(VisualizeGameState, BuildTrack, 'AA_Success');	
		}

		OutVisualizationTracks.AddItem(BuildTrack);
	}

	foreach VisualizeGameState.IterateByClassType(class'XComGameState_WorldEffectTileData', WorldDataUpdate)
	{
		BuildTrack = EmptyTrack;
		BuildTrack.TrackActor = none;
		BuildTrack.StateObject_NewState = WorldDataUpdate;
		BuildTrack.StateObject_OldState = WorldDataUpdate;

		//Wait until signaled by the shooter that the projectiles are hitting
		if (!AbilityTemplate.bSkipFireAction)
			class'X2Action_WaitForAbilityEffect'.static.AddToVisualizationTrack(BuildTrack, Context);

		for (EffectIndex = 0; EffectIndex < AbilityTemplate.AbilityShooterEffects.Length; ++EffectIndex)
		{
			AbilityTemplate.AbilityShooterEffects[EffectIndex].AddX2ActionsForVisualization(VisualizeGameState, BuildTrack, 'AA_Success');		
		}

		for (EffectIndex = 0; EffectIndex < AbilityTemplate.AbilityTargetEffects.Length; ++EffectIndex)
		{
			AbilityTemplate.AbilityTargetEffects[EffectIndex].AddX2ActionsForVisualization(VisualizeGameState, BuildTrack, 'AA_Success');
		}

		for (EffectIndex = 0; EffectIndex < MultiTargetEffects.Length; ++EffectIndex)
		{
			MultiTargetEffects[EffectIndex].AddX2ActionsForVisualization(VisualizeGameState, BuildTrack, 'AA_Success');	
		}

		OutVisualizationTracks.AddItem(BuildTrack);
	}
	//****************************************************************************************

	//Process any interactions with interactive objects
	foreach VisualizeGameState.IterateByClassType(class'XComGameState_InteractiveObject', InteractiveObject)
	{
		// Add any doors that need to listen for notification
		if (InteractiveObject.IsDoor() && InteractiveObject.HasDestroyAnim()) //Is this a closed door?
		{
			BuildTrack = EmptyTrack;
			//Don't necessarily have a previous state, so just use the one we know about
			BuildTrack.StateObject_OldState = InteractiveObject;
			BuildTrack.StateObject_NewState = InteractiveObject;
			BuildTrack.TrackActor = History.GetVisualizer(InteractiveObject.ObjectID);

			if (!AbilityTemplate.bSkipFireAction)
				class'X2Action_WaitForAbilityEffect'.static.AddToVisualizationTrack(BuildTrack, Context);

			class'X2Action_BreakInteractActor'.static.AddToVisualizationTrack(BuildTrack, Context);

			OutVisualizationTracks.AddItem(BuildTrack);
		}
	}
}


//---------------------------------------------------------------------------------------------------
// Escape and Evade
//---------------------------------------------------------------------------------------------------


static function X2AbilityTemplate EscapeAndEvade()
{
	local X2AbilityTemplate						Template;
	local X2Effect_EscapeAndEvade				Effect;
	
	//`LOG("Lucubration Infantry Class: Escape and Evade dodge bonus=" @ string(default.EscapeAndEvadeDodgeBonus));

	`CREATE_X2ABILITY_TEMPLATE(Template, 'EscapeAndEvade');

	Template.AdditionalAbilities.AddItem(default.EscapeAndEvadeStealthAbilityName);

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_stealth";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_MAJOR_PRIORITY;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	// Combine stat change and event registration on the same effect
	Effect = new class'X2Effect_EscapeAndEvade';
	Effect.EffectName = 'EscapeAndEvade';
	Effect.AbilityToActivate = default.EscapeAndEvadeStealthAbilityName;
	Effect.ActionPointName = default.EscapeAndEvadeActionPointName;
	Effect.DuplicateResponse = eDupe_Ignore;
	Effect.AddPersistentStatChange(eStat_Dodge, default.EscapeAndEvadeDodgeBonus);
	Effect.BuildPersistentEffect(1, true, false);
	Effect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage,,,Template.AbilitySourceName);
	Template.AddTargetEffect(Effect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!

	return Template;
}

static function X2AbilityTemplate EscapeAndEvadeActive()
{
	local X2AbilityTemplate						Template;
	local X2AbilityCost_ActionPoints			ActionPointCost;
	local X2Effect_RangerStealth				StealthEffect;
	local X2Effect_EscapeAndEvadeStealthRemover	StealthRemoverEffect;
	local X2AbilityCooldown						Cooldown;
	
	`LOG("Lucubration Infantry Class: Escape and Evade cooldown=" @ string(default.EscapeAndEvadeCooldown));
	`LOG("Lucubration Infantry Class: Escape and Evade duration=" @ string(default.EscapeAndEvadeStealthDuration));
	`LOG("Lucubration Infantry Class: Escape and Evade detection radius modifier=" @ string(default.EscapeAndEvadeDetectionRadiusModifier));

	`CREATE_X2ABILITY_TEMPLATE(Template, 'EscapeAndEvadeActive');

	Template.AdditionalAbilities.AddItem(default.EscapeAndEvadeStealthAbilityName);

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_stealth";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_MAJOR_PRIORITY;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	
	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bFreeCost = true;
	Template.AbilityCosts.AddItem(ActionPointCost);
	
	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.EscapeAndEvadeCooldown;
	Template.AbilityCooldown = Cooldown;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AbilityShooterConditions.AddItem(new class'X2Condition_EscapeAndEvade');

	// Core stealth effect. Does not seem to actually remove concealment with the persistent effect runs out. That's weird
	StealthEffect = new class'X2Effect_RangerStealth';
	StealthEffect.EffectName = 'EscapeAndEvadeStealth';
	StealthEffect.DuplicateResponse = eDupe_Refresh;
	StealthEffect.BuildPersistentEffect(default.EscapeAndEvadeStealthDuration, , , , eGameRule_PlayerTurnBegin);
	StealthEffect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage,,,Template.AbilitySourceName);
	StealthEffect.bRemoveWhenTargetConcealmentBroken = true;
	Template.AddTargetEffect(StealthEffect);

	// Combine stat change and stealth remover effect
	StealthRemoverEffect = new class'X2Effect_EscapeAndEvadeStealthRemover';
	StealthRemoverEffect.EffectName = 'EscapeAndEvadeDetectionModifier';
	StealthRemoverEffect.DuplicateResponse = eDupe_Refresh;
	StealthRemoverEffect.AddPersistentStatChange(eStat_DetectionModifier, default.EscapeAndEvadeDetectionRadiusModifier);
	StealthRemoverEffect.BuildPersistentEffect(default.EscapeAndEvadeStealthDuration, , , , eGameRule_PlayerTurnBegin);
	StealthRemoverEffect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, false,,Template.AbilitySourceName);
	StealthRemoverEffect.bRemoveWhenTargetConcealmentBroken = true;
	Template.AddTargetEffect(StealthRemoverEffect);

	Template.AddTargetEffect(class'X2Effect_Spotted'.static.CreateUnspottedEffect());

	Template.ActivationSpeech = 'ActivateConcealment';
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.bSkipFireAction = true;

	return Template;
}

static function X2AbilityTemplate EscapeAndEvadeStealth()
{
	local X2AbilityTemplate						Template;
	local X2AbilityCost_ReserveActionPoints		ReserveActionPointCost;
	local X2AbilityTrigger_Event				Trigger;
	local X2Effect_RangerStealth				StealthEffect;
	//local X2AbilityCharges                      Charges;

	`CREATE_X2ABILITY_TEMPLATE(Template, default.EscapeAndEvadeStealthAbilityName);

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_stealth";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_MAJOR_PRIORITY;
	Template.bShowActivation = true;
	Template.bDontDisplayInAbilitySummary = true;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	//Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	//Template.AbilityCosts.AddItem(new class'X2AbilityCost_Charges');
	ReserveActionPointCost = new class'X2AbilityCost_ReserveActionPoints';
	ReserveActionPointCost.iNumPoints = 1;
	ReserveActionPointCost.AllowedTypes.AddItem(default.EscapeAndEvadeActionPointName);
	Template.AbilityCosts.AddItem(ReserveActionPointCost);

	//Charges = new class'X2AbilityCharges';
	//Charges.InitialCharges = default.STEALTH_CHARGES;
	//Template.AbilityCharges = Charges;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AbilityShooterConditions.AddItem(new class'X2Condition_Stealth');
	
	//Trigger on movement - interrupt the move
	Trigger = new class'X2AbilityTrigger_Event';
	Trigger.EventObserverClass = class'X2TacticalGameRuleset_AttackObserver';
	Trigger.MethodName = 'InterruptGameState';
	Template.AbilityTriggers.AddItem(Trigger);

	StealthEffect = new class'X2Effect_RangerStealth';
	StealthEffect.BuildPersistentEffect(default.EscapeAndEvadeStealthDuration, , , , eGameRule_PlayerTurnEnd);
	StealthEffect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, true);
	StealthEffect.bRemoveWhenTargetConcealmentBroken = true;
	Template.AddTargetEffect(StealthEffect);

	Template.AddTargetEffect(class'X2Effect_Spotted'.static.CreateUnspottedEffect());

	Template.ActivationSpeech = 'ActivateConcealment';
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.bSkipFireAction = true;

	return Template;
}


//---------------------------------------------------------------------------------------------------
// Deep Reserves
//---------------------------------------------------------------------------------------------------


static function X2AbilityTemplate DeepReserves()
{
	local X2AbilityTemplate						Template;
	local X2Effect_DeepReserves					Effect;
	
	`LOG("Lucubration Infantry Class: Deep Reserves damage percent to heal=" @ string(default.EscapeAndEvadeDodgeBonus));
	`LOG("Lucubration Infantry Class: Deep Reserves max heal per turn=" @ string(default.EscapeAndEvadeDodgeBonus));
	`LOG("Lucubration Infantry Class: Deep Reserves max total heal amount=" @ string(default.DeepReservesMaxTotalHealAmount));

	`CREATE_X2ABILITY_TEMPLATE(Template, default.DeepReservesAbilityName);

	Template.AdditionalAbilities.AddItem(default.EscapeAndEvadeStealthAbilityName);

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_rapidregeneration";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_MAJOR_PRIORITY;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	// Combine stat change and event registration on the same effect
	Effect = new class'X2Effect_DeepReserves';
	Effect.EffectName = 'DeepReserves';
	Effect.DuplicateResponse = eDupe_Ignore;
	Effect.BuildPersistentEffect(1, true, false, , eGameRule_PlayerTurnBegin);
	Effect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage,,,Template.AbilitySourceName);
	Effect.HealAmountPerTurn = default.DeepReservesMaxHealPerTurn;
	Effect.HealDamagePercent = default.DeepReservesDamagePercentToHeal;
	Effect.MaxTotalHealAmount = default.DeepReservesMaxTotalHealAmount;
	Effect.HealthRegeneratedName = 'DeepReservesHealthRegenerated';
	Effect.DamageTakenName = 'DeepReservesDamageTaken';
	Template.AddTargetEffect(Effect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!
	
	return Template;
}


//---------------------------------------------------------------------------------------------------
// Fire for Effect
//---------------------------------------------------------------------------------------------------


static function X2AbilityTemplate FireForEffect()
{
	local X2AbilityTemplate					Template;
	local X2AbilityCost_ActionPoints		ActionPointCost;
	local X2AbilityCost_Ammo				AmmoCost;
	local X2AbilityTarget_Cursor			CursorTarget;
	local X2AbilityMultiTarget_Radius		RadiusMultiTarget;
	local X2AbilityToHitCalc_StandardAim    ToHitCalc;
	local X2AbilityCooldown                 Cooldown;
	local X2Condition_UnitProperty          UnitPropertyCondition;
	
	`LOG("Lucubration Infantry Class: Fire for Effect damage ability point cost=" @ string(default.FireForEffectAbilityPointCost));
	`LOG("Lucubration Infantry Class: Fire for Effect damage ammo cost=" @ string(default.FireForEffectAmmoCost));
	`LOG("Lucubration Infantry Class: Fire for Effect damage cooldown=" @ string(default.FireForEffectCooldown));
	`LOG("Lucubration Infantry Class: Fire for Effect damage radius=" @ string(default.FireForEffectRadius));

	`CREATE_X2ABILITY_TEMPLATE(Template, 'FireForEffect');

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = default.FireForEffectAbilityPointCost;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	AmmoCost = new class'X2AbilityCost_Ammo';
	AmmoCost.iAmmo = default.FireForEffectAmmoCost;
	Template.AbilityCosts.AddItem(AmmoCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.FireForEffectCooldown;
	Template.AbilityCooldown = Cooldown;

	ToHitCalc = new class'X2AbilityToHitCalc_StandardAim';
	ToHitCalc.bMultiTargetOnly = true;
	ToHitCalc.bGuaranteedHit = true;
	ToHitCalc.bAllowCrit = false;
	Template.AbilityToHitCalc = ToHitCalc;
	
	CursorTarget = new class'X2AbilityTarget_Cursor';
	CursorTarget.FixedAbilityRange = default.FireForEffectRange;
	//CursorTarget.bRestrictToWeaponRange = true;
	Template.AbilityTargetStyle = CursorTarget;
	
	RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
	RadiusMultiTarget.fTargetRadius = default.FireForEffectRadius;
	Template.AbilityMultiTargetStyle = RadiusMultiTarget;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();
	
	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeDead = true;
	UnitPropertyCondition.ExcludeFriendlyToSource = false;
	Template.AbilityShooterConditions.AddItem(UnitPropertyCondition);
	Template.AbilityTargetConditions.AddItem(UnitPropertyCondition);

	// Allows this attack to work with the Holo-Targeting and Shredder perks, in case of AWC perkage
	Template.AddMultiTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());
	Template.AddMultiTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.ShredderDamageEffect());
	Template.bAllowAmmoEffects = true;

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY;
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_hailofbullets";
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";
	
	Template.TargetingMethod = class'X2TargetingMethod_FireForEffect';
	
	Template.ActionFireClass = class'X2Action_Fire_Faceoff';

	Template.ActivationSpeech = 'SaturationFire';
	Template.CinescriptCameraType = "Grenadier_SaturationFire";
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = FireForEffect_BuildVisualization;
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;

	return Template;
}

// A custom attack visualization that's basically the same as the normal attack visualization except that we step out of cover
// and play the shoot animation twice, to reinforce the impression that we are sending more rounds downrange than normal
function FireForEffect_BuildVisualization(XComGameState VisualizeGameState, out array<VisualizationTrack> OutVisualizationTracks)
{		
	local X2AbilityTemplate             AbilityTemplate;
	local XComGameStateContext_Ability  Context;
	local AbilityInputContext           AbilityContext;
	local StateObjectReference          ShootingUnitRef;	
	local X2Action                      AddedAction;
	local array<X2Action>				AddedActions;
	local XComGameState_BaseObject      TargetStateObject;//Container for state objects within VisualizeGameState	
	local XComGameState_Item            SourceWeapon;
	local X2GrenadeTemplate             GrenadeTemplate;
	local X2AmmoTemplate                AmmoTemplate;
	local X2WeaponTemplate              WeaponTemplate;
	local array<X2Effect>               MultiTargetEffects;
	local bool							bSourceIsAlsoTarget;
	local bool							bMultiSourceIsAlsoTarget;
	
	local Actor                     TargetVisualizer, ShooterVisualizer;
	local X2VisualizerInterface     TargetVisualizerInterface, ShooterVisualizerInterface;
	local int                       EffectIndex, TargetIndex;
	local XComGameState_EnvironmentDamage EnvironmentDamageEvent;
	local XComGameState_WorldEffectTileData WorldDataUpdate;

	local VisualizationTrack        EmptyTrack;
	local VisualizationTrack        BuildTrack;
	local VisualizationTrack        SourceTrack, InterruptTrack;
	local int						TrackIndex;
	local bool						bAlreadyAdded;
	local XComGameStateHistory      History;
	local X2Action_MoveTurn         MoveTurnAction;

	local XComGameStateContext_Ability CounterAttackContext;
	local X2AbilityTemplate			CounterattackTemplate;
	local array<VisualizationTrack> OutCounterattackVisualizationTracks;
	local int						ActionIndex;

	local X2Action_PlaySoundAndFlyOver SoundAndFlyover;
	local name         ApplyResult;

	local XComGameState_InteractiveObject InteractiveObject;
	local XComGameState_Ability     AbilityState;
		
	History = `XCOMHISTORY;
	Context = XComGameStateContext_Ability(VisualizeGameState.GetContext());
	AbilityContext = Context.InputContext;
	AbilityState = XComGameState_Ability(History.GetGameStateForObjectID(AbilityContext.AbilityRef.ObjectID));
	AbilityTemplate = class'XComGameState_Ability'.static.GetMyTemplateManager().FindAbilityTemplate(AbilityContext.AbilityTemplateName);
	ShootingUnitRef = Context.InputContext.SourceObject;

	//Configure the visualization track for the shooter, part I. We split this into two parts since
	//in some situations the shooter can also be a target
	//****************************************************************************************
	ShooterVisualizer = History.GetVisualizer(ShootingUnitRef.ObjectID);
	ShooterVisualizerInterface = X2VisualizerInterface(ShooterVisualizer);

	SourceTrack = EmptyTrack;
	SourceTrack.StateObject_OldState = History.GetGameStateForObjectID(ShootingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
	SourceTrack.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(ShootingUnitRef.ObjectID);
	if (SourceTrack.StateObject_NewState == none)
		SourceTrack.StateObject_NewState = SourceTrack.StateObject_OldState;
	SourceTrack.TrackActor = ShooterVisualizer;

	SourceTrack.AbilityName = AbilityTemplate.DataName;

	SourceWeapon = XComGameState_Item(History.GetGameStateForObjectID(AbilityContext.ItemObject.ObjectID));
	if (SourceWeapon != None)
	{
		WeaponTemplate = X2WeaponTemplate(SourceWeapon.GetMyTemplate());
		AmmoTemplate = X2AmmoTemplate(SourceWeapon.GetLoadedAmmoTemplate(AbilityState));
	}
	if(AbilityTemplate.bShowPostActivation)
	{
		//Show the text flyover at the end of the visualization after the camera pans back
		Context.PostBuildVisualizationFn.AddItem(ActivationFlyOver_PostBuildVisualization);
	}
	if (AbilityTemplate.bShowActivation || AbilityTemplate.ActivationSpeech != '')
	{
		SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyover'.static.AddToVisualizationTrack(SourceTrack, Context));

		if (SourceWeapon != None)
		{
			GrenadeTemplate = X2GrenadeTemplate(SourceWeapon.GetMyTemplate());
		}

		if (GrenadeTemplate != none)
		{
			SoundAndFlyOver.SetSoundAndFlyOverParameters(None, "", GrenadeTemplate.OnThrowBarkSoundCue, eColor_Good);
		}
		else
		{
			SoundAndFlyOver.SetSoundAndFlyOverParameters(None, AbilityTemplate.bShowActivation ? AbilityTemplate.LocFriendlyName : "", AbilityTemplate.ActivationSpeech, eColor_Good, AbilityTemplate.bShowActivation ? AbilityTemplate.IconImage : "");
		}
	}

	if( Context.IsResultContextMiss() && AbilityTemplate.SourceMissSpeech != '' )
	{
		SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyover'.static.AddToVisualizationTrack(BuildTrack, Context));
		SoundAndFlyOver.SetSoundAndFlyOverParameters(None, "", AbilityTemplate.SourceMissSpeech, eColor_Bad);
	}
	else if( Context.IsResultContextHit() && AbilityTemplate.SourceHitSpeech != '' )
	{
		SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyover'.static.AddToVisualizationTrack(BuildTrack, Context));
		SoundAndFlyOver.SetSoundAndFlyOverParameters(None, "", AbilityTemplate.SourceHitSpeech, eColor_Good);
	}

	if (!AbilityTemplate.bSkipFireAction)
	{
		if (!AbilityTemplate.bSkipExitCoverWhenFiring)
		{
			class'X2Action_ExitCover'.static.AddToVisualizationTrack(SourceTrack, Context);
		}

		// no move, just add the fire action

		// Lucubration: The only special thing I'm going to do here is to try to chain together several attack animations in sequence
		// for this single attack ability
		AddedAction = class'X2Action_Fire_OpenUnfinishedAnim'.static.AddToVisualizationTrack(SourceTrack, Context);

		AddedAction = AbilityTemplate.ActionFireClass.static.AddToVisualizationTrack(SourceTrack, Context);
		AddedActions.AddItem(AddedAction);
		AddedAction = AbilityTemplate.ActionFireClass.static.AddToVisualizationTrack(SourceTrack, Context);
		AddedActions.AddItem(AddedAction);

		if( AbilityTemplate.AbilityToHitCalc != None )
		{
			foreach AddedActions(AddedAction)
			{
				X2Action_Fire(AddedAction).SetFireParameters( Context.IsResultContextHit() );
			}
		}

		//Process a potential counter attack from the target here
		if (Context.ResultContext.HitResult == eHit_CounterAttack)
		{
			CounterAttackContext = class'X2Ability'.static.FindCounterAttackGameState(Context, XComGameState_Unit(SourceTrack.StateObject_OldState));
			if (CounterAttackContext != none)
			{
				//Entering this code block means that we were the target of a counter attack to our original attack. Here, we look forward in the history
				//and append the necessary visualization tracks so that the counter attack can happen visually as part of our original attack.

				//Get the ability template for the counter attack against us
				CounterattackTemplate = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager().FindAbilityTemplate(CounterAttackContext.InputContext.AbilityTemplateName);
				CounterattackTemplate.BuildVisualizationFn(CounterAttackContext.AssociatedState, OutCounterattackVisualizationTracks);

				//Take the visualization actions from the counter attack game state ( where we are the target )
				for(TrackIndex = 0; TrackIndex < OutCounterattackVisualizationTracks.Length; ++TrackIndex)
				{
					if(OutCounterattackVisualizationTracks[TrackIndex].StateObject_OldState.ObjectID == SourceTrack.StateObject_OldState.ObjectID)
					{
						for(ActionIndex = 0; ActionIndex < OutCounterattackVisualizationTracks[TrackIndex].TrackActions.Length; ++ActionIndex)
						{
							//Don't include waits
							if(!OutCounterattackVisualizationTracks[TrackIndex].TrackActions[ActionIndex].IsA('X2Action_WaitForAbilityEffect'))
							{
								SourceTrack.TrackActions.AddItem(OutCounterattackVisualizationTracks[TrackIndex].TrackActions[ActionIndex]);
							}
						}
						break;
					}
				}
				
				//Notify the visualization mgr that the counter attack visualization is taken care of, so it can be skipped
				`XCOMVISUALIZATIONMGR.SkipVisualization(CounterAttackContext.AssociatedState.HistoryIndex);
			}
		}
	}

	//If there are effects added to the shooter, add the visualizer actions for them
	for (EffectIndex = 0; EffectIndex < AbilityTemplate.AbilityShooterEffects.Length; ++EffectIndex)
	{
		AbilityTemplate.AbilityShooterEffects[EffectIndex].AddX2ActionsForVisualization(VisualizeGameState, SourceTrack, Context.FindShooterEffectApplyResult(AbilityTemplate.AbilityShooterEffects[EffectIndex]));		
	}
	// Lucubration: Taking this stuff about the primary target out now that FFE is a free-targeted cone rather than locked to a target
	//****************************************************************************************

	//Configure the visualization track for the target(s). This functionality uses the context primarily
	//since the game state may not include state objects for misses.
	//****************************************************************************************	
	//bSourceIsAlsoTarget = AbilityContext.PrimaryTarget.ObjectID == AbilityContext.SourceObject.ObjectID; //The shooter is the primary target
	//if (AbilityTemplate.AbilityTargetEffects.Length > 0 &&			//There are effects to apply
		//AbilityContext.PrimaryTarget.ObjectID > 0)				//There is a primary target
	//{
		//TargetVisualizer = History.GetVisualizer(AbilityContext.PrimaryTarget.ObjectID);
		//TargetVisualizerInterface = X2VisualizerInterface(TargetVisualizer);
//
		//if( bSourceIsAlsoTarget )
		//{
			//BuildTrack = SourceTrack;
		//}
		//else
		//{
			//BuildTrack = InterruptTrack;        //  interrupt track will either be empty or filled out correctly
		//}
//
		//BuildTrack.TrackActor = TargetVisualizer;
//
		//TargetStateObject = VisualizeGameState.GetGameStateForObjectID(AbilityContext.PrimaryTarget.ObjectID);
		//if( TargetStateObject != none )
		//{
			//History.GetCurrentAndPreviousGameStatesForObjectID(AbilityContext.PrimaryTarget.ObjectID, 
															   //BuildTrack.StateObject_OldState, BuildTrack.StateObject_NewState,
															   //eReturnType_Reference,
															   //VisualizeGameState.HistoryIndex);
			//`assert(BuildTrack.StateObject_NewState == TargetStateObject);
		//}
		//else
		//{
			////If TargetStateObject is none, it means that the visualize game state does not contain an entry for the primary target. Use the history version
			////and show no change.
			//BuildTrack.StateObject_OldState = History.GetGameStateForObjectID(AbilityContext.PrimaryTarget.ObjectID);
			//BuildTrack.StateObject_NewState = BuildTrack.StateObject_OldState;
		//}
//
		//// if this is a melee attack, make sure the target is facing the location he will be melee'd from
		//if(!AbilityTemplate.bSkipFireAction 
			//&& !bSourceIsAlsoTarget 
			//&& AbilityContext.MovementPaths.Length > 0
			//&& AbilityContext.MovementPaths[0].MovementData.Length > 0
			//&& XGUnit(TargetVisualizer) != none)
		//{
			//MoveTurnAction = X2Action_MoveTurn(class'X2Action_MoveTurn'.static.AddToVisualizationTrack(BuildTrack, Context));
			//MoveTurnAction.m_vFacePoint = AbilityContext.MovementPaths[0].MovementData[AbilityContext.MovementPaths[0].MovementData.Length - 1].Position;
			//MoveTurnAction.m_vFacePoint.Z = TargetVisualizerInterface.GetTargetingFocusLocation().Z;
			//MoveTurnAction.UpdateAimTarget = true;
		//}
//
		////Make the target wait until signaled by the shooter that the projectiles are hitting
		//if (!AbilityTemplate.bSkipFireAction && !bSourceIsAlsoTarget)
		//{
			//class'X2Action_WaitForAbilityEffect'.static.AddToVisualizationTrack(BuildTrack, Context);
		//}
		//
		////Add any X2Actions that are specific to this effect being applied. These actions would typically be instantaneous, showing UI world messages
		////playing any effect specific audio, starting effect specific effects, etc. However, they can also potentially perform animations on the 
		////track actor, so the design of effect actions must consider how they will look/play in sequence with other effects.
		//for (EffectIndex = 0; EffectIndex < AbilityTemplate.AbilityTargetEffects.Length; ++EffectIndex)
		//{
			//ApplyResult = Context.FindTargetEffectApplyResult(AbilityTemplate.AbilityTargetEffects[EffectIndex]);
//
			//// Target effect visualization
			//AbilityTemplate.AbilityTargetEffects[EffectIndex].AddX2ActionsForVisualization(VisualizeGameState, BuildTrack, ApplyResult);
//
			//// Source effect visualization
			//AbilityTemplate.AbilityTargetEffects[EffectIndex].AddX2ActionsForVisualizationSource(VisualizeGameState, SourceTrack, ApplyResult);
		//}
//
		////the following is used to handle Rupture flyover text
		//if (XComGameState_Unit(BuildTrack.StateObject_OldState).GetRupturedValue() == 0 &&
			//XComGameState_Unit(BuildTrack.StateObject_NewState).GetRupturedValue() > 0)
		//{
			////this is the frame that we realized we've been ruptured!
			//class 'X2StatusEffects'.static.RuptureVisualization(VisualizeGameState, BuildTrack);
		//}
//
		//if (AbilityTemplate.bAllowAmmoEffects && AmmoTemplate != None)
		//{
			//for (EffectIndex = 0; EffectIndex < AmmoTemplate.TargetEffects.Length; ++EffectIndex)
			//{
				//ApplyResult = Context.FindTargetEffectApplyResult(AmmoTemplate.TargetEffects[EffectIndex]);
				//AmmoTemplate.TargetEffects[EffectIndex].AddX2ActionsForVisualization(VisualizeGameState, BuildTrack, ApplyResult);
				//AmmoTemplate.TargetEffects[EffectIndex].AddX2ActionsForVisualizationSource(VisualizeGameState, SourceTrack, ApplyResult);
			//}
		//}
		//if (AbilityTemplate.bAllowBonusWeaponEffects && WeaponTemplate != none)
		//{
			//for (EffectIndex = 0; EffectIndex < WeaponTemplate.BonusWeaponEffects.Length; ++EffectIndex)
			//{
				//ApplyResult = Context.FindTargetEffectApplyResult(WeaponTemplate.BonusWeaponEffects[EffectIndex]);
				//WeaponTemplate.BonusWeaponEffects[EffectIndex].AddX2ActionsForVisualization(VisualizeGameState, BuildTrack, ApplyResult);
				//WeaponTemplate.BonusWeaponEffects[EffectIndex].AddX2ActionsForVisualizationSource(VisualizeGameState, SourceTrack, ApplyResult);
			//}
		//}
//
		//if (Context.IsResultContextMiss() && (AbilityTemplate.LocMissMessage != "" || AbilityTemplate.TargetMissSpeech != ''))
		//{
			//SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyover'.static.AddToVisualizationTrack(BuildTrack, Context));
			//SoundAndFlyOver.SetSoundAndFlyOverParameters(None, AbilityTemplate.LocMissMessage, AbilityTemplate.TargetMissSpeech, eColor_Bad);
		//}
		//else if( Context.IsResultContextHit() && (AbilityTemplate.LocHitMessage != "" || AbilityTemplate.TargetHitSpeech != '') )
		//{
			//SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyover'.static.AddToVisualizationTrack(BuildTrack, Context));
			//SoundAndFlyOver.SetSoundAndFlyOverParameters(None, AbilityTemplate.LocHitMessage, AbilityTemplate.TargetHitSpeech, eColor_Good);
		//}
//
		//if( TargetVisualizerInterface != none )
		//{
			////Allow the visualizer to do any custom processing based on the new game state. For example, units will create a death action when they reach 0 HP.
			//TargetVisualizerInterface.BuildAbilityEffectsVisualization(VisualizeGameState, BuildTrack);
		//}
//
		//if (!bSourceIsAlsoTarget && BuildTrack.TrackActions.Length > 0)
		//{
			//OutVisualizationTracks.AddItem(BuildTrack);
		//}
//
		//if( bSourceIsAlsoTarget )
		//{
			//SourceTrack = BuildTrack;
		//}
	//}

	if (AbilityTemplate.bUseLaunchedGrenadeEffects)
	{
		MultiTargetEffects = X2GrenadeTemplate(SourceWeapon.GetLoadedAmmoTemplate(AbilityState)).LaunchedGrenadeEffects;
	}
	else if (AbilityTemplate.bUseThrownGrenadeEffects)
	{
		MultiTargetEffects = X2GrenadeTemplate(SourceWeapon.GetMyTemplate()).ThrownGrenadeEffects;
	}
	else
	{
		MultiTargetEffects = AbilityTemplate.AbilityMultiTargetEffects;
	}

	//  Apply effects to multi targets
	if( MultiTargetEffects.Length > 0 && AbilityContext.MultiTargets.Length > 0)
	{
		for( TargetIndex = 0; TargetIndex < AbilityContext.MultiTargets.Length; ++TargetIndex )
		{	
			bMultiSourceIsAlsoTarget = false;
			if( AbilityContext.MultiTargets[TargetIndex].ObjectID == AbilityContext.SourceObject.ObjectID )
			{
				bMultiSourceIsAlsoTarget = true;
				bSourceIsAlsoTarget = bMultiSourceIsAlsoTarget;				
			}

			//Some abilities add the same target multiple times into the targets list - see if this is the case and avoid adding redundant tracks
			bAlreadyAdded = false;
			for( TrackIndex = 0; TrackIndex < OutVisualizationTracks.Length; ++TrackIndex )
			{
				if( OutVisualizationTracks[TrackIndex].StateObject_NewState.ObjectID == AbilityContext.MultiTargets[TargetIndex].ObjectID )
				{
					bAlreadyAdded = true;
				}
			}

			if( !bAlreadyAdded )
			{
				TargetVisualizer = History.GetVisualizer(AbilityContext.MultiTargets[TargetIndex].ObjectID);
				TargetVisualizerInterface = X2VisualizerInterface(TargetVisualizer);

				if( bMultiSourceIsAlsoTarget )
				{
					BuildTrack = SourceTrack;
				}
				else
				{
					BuildTrack = EmptyTrack;
				}
				BuildTrack.TrackActor = TargetVisualizer;

				TargetStateObject = VisualizeGameState.GetGameStateForObjectID(AbilityContext.MultiTargets[TargetIndex].ObjectID);
				if( TargetStateObject != none )
				{
					History.GetCurrentAndPreviousGameStatesForObjectID(AbilityContext.MultiTargets[TargetIndex].ObjectID, 
																	   BuildTrack.StateObject_OldState, BuildTrack.StateObject_NewState,
																	   eReturnType_Reference,
																	   VisualizeGameState.HistoryIndex);
					`assert(BuildTrack.StateObject_NewState == TargetStateObject);
				}			
				else
				{
					//If TargetStateObject is none, it means that the visualize game state does not contain an entry for the primary target. Use the history version
					//and show no change.
					BuildTrack.StateObject_OldState = History.GetGameStateForObjectID(AbilityContext.PrimaryTarget.ObjectID);
					BuildTrack.StateObject_NewState = BuildTrack.StateObject_OldState;
				}

				//Make the target wait until signaled by the shooter that the projectiles are hitting
				if (!AbilityTemplate.bSkipFireAction && !bMultiSourceIsAlsoTarget)
				{
					class'X2Action_WaitForAbilityEffect'.static.AddToVisualizationTrack(BuildTrack, Context);
				}
		
				//Add any X2Actions that are specific to this effect being applied. These actions would typically be instantaneous, showing UI world messages
				//playing any effect specific audio, starting effect specific effects, etc. However, they can also potentially perform animations on the 
				//track actor, so the design of effect actions must consider how they will look/play in sequence with other effects.
				for (EffectIndex = 0; EffectIndex < MultiTargetEffects.Length; ++EffectIndex)
				{
					ApplyResult = Context.FindMultiTargetEffectApplyResult(MultiTargetEffects[EffectIndex], TargetIndex);

					// Target effect visualization
					MultiTargetEffects[EffectIndex].AddX2ActionsForVisualization(VisualizeGameState, BuildTrack, ApplyResult);

					// Source effect visualization
					MultiTargetEffects[EffectIndex].AddX2ActionsForVisualizationSource(VisualizeGameState, SourceTrack, ApplyResult);
				}			

				//the following is used to handle Rupture flyover text
				if (XComGameState_Unit(BuildTrack.StateObject_OldState).GetRupturedValue() == 0 &&
					XComGameState_Unit(BuildTrack.StateObject_NewState).GetRupturedValue() > 0)
				{
					//this is the frame that we realized we've been ruptured!
					class 'X2StatusEffects'.static.RuptureVisualization(VisualizeGameState, BuildTrack);
				}

				if( TargetVisualizerInterface != none )
				{
					//Allow the visualizer to do any custom processing based on the new game state. For example, units will create a death action when they reach 0 HP.
					TargetVisualizerInterface.BuildAbilityEffectsVisualization(VisualizeGameState, BuildTrack);
				}

				if( !bMultiSourceIsAlsoTarget && BuildTrack.TrackActions.Length > 0 )
				{
					OutVisualizationTracks.AddItem(BuildTrack);
				}

				if( bMultiSourceIsAlsoTarget )
				{
					SourceTrack = BuildTrack;
				}
			}
		}
	}
	//****************************************************************************************

	//Finish adding the shooter's track
	//****************************************************************************************
	if( !bSourceIsAlsoTarget && ShooterVisualizerInterface != none)
	{
		ShooterVisualizerInterface.BuildAbilityEffectsVisualization(VisualizeGameState, SourceTrack);				
	}	

	if (!AbilityTemplate.bSkipFireAction)
	{
		if (!AbilityTemplate.bSkipExitCoverWhenFiring)
		{
			class'X2Action_EnterCover'.static.AddToVisualizationTrack(SourceTrack, Context);
		}
	}
	
	OutVisualizationTracks.AddItem(SourceTrack);
	//****************************************************************************************

	//Configure the visualization tracks for the environment
	//****************************************************************************************
	foreach VisualizeGameState.IterateByClassType(class'XComGameState_EnvironmentDamage', EnvironmentDamageEvent)
	{
		BuildTrack = EmptyTrack;
		BuildTrack.TrackActor = none;
		BuildTrack.StateObject_NewState = EnvironmentDamageEvent;
		BuildTrack.StateObject_OldState = EnvironmentDamageEvent;

		//Wait until signaled by the shooter that the projectiles are hitting
		if (!AbilityTemplate.bSkipFireAction)
			class'X2Action_WaitForAbilityEffect'.static.AddToVisualizationTrack(BuildTrack, Context);

		for (EffectIndex = 0; EffectIndex < AbilityTemplate.AbilityShooterEffects.Length; ++EffectIndex)
		{
			AbilityTemplate.AbilityShooterEffects[EffectIndex].AddX2ActionsForVisualization(VisualizeGameState, BuildTrack, 'AA_Success');		
		}

		for (EffectIndex = 0; EffectIndex < AbilityTemplate.AbilityTargetEffects.Length; ++EffectIndex)
		{
			AbilityTemplate.AbilityTargetEffects[EffectIndex].AddX2ActionsForVisualization(VisualizeGameState, BuildTrack, 'AA_Success');
		}

		for (EffectIndex = 0; EffectIndex < MultiTargetEffects.Length; ++EffectIndex)
		{
			MultiTargetEffects[EffectIndex].AddX2ActionsForVisualization(VisualizeGameState, BuildTrack, 'AA_Success');	
		}

		OutVisualizationTracks.AddItem(BuildTrack);
	}

	foreach VisualizeGameState.IterateByClassType(class'XComGameState_WorldEffectTileData', WorldDataUpdate)
	{
		BuildTrack = EmptyTrack;
		BuildTrack.TrackActor = none;
		BuildTrack.StateObject_NewState = WorldDataUpdate;
		BuildTrack.StateObject_OldState = WorldDataUpdate;

		//Wait until signaled by the shooter that the projectiles are hitting
		if (!AbilityTemplate.bSkipFireAction)
			class'X2Action_WaitForAbilityEffect'.static.AddToVisualizationTrack(BuildTrack, Context);

		for (EffectIndex = 0; EffectIndex < AbilityTemplate.AbilityShooterEffects.Length; ++EffectIndex)
		{
			AbilityTemplate.AbilityShooterEffects[EffectIndex].AddX2ActionsForVisualization(VisualizeGameState, BuildTrack, 'AA_Success');		
		}

		for (EffectIndex = 0; EffectIndex < AbilityTemplate.AbilityTargetEffects.Length; ++EffectIndex)
		{
			AbilityTemplate.AbilityTargetEffects[EffectIndex].AddX2ActionsForVisualization(VisualizeGameState, BuildTrack, 'AA_Success');
		}

		for (EffectIndex = 0; EffectIndex < MultiTargetEffects.Length; ++EffectIndex)
		{
			MultiTargetEffects[EffectIndex].AddX2ActionsForVisualization(VisualizeGameState, BuildTrack, 'AA_Success');	
		}

		OutVisualizationTracks.AddItem(BuildTrack);
	}
	//****************************************************************************************

	//Process any interactions with interactive objects
	foreach VisualizeGameState.IterateByClassType(class'XComGameState_InteractiveObject', InteractiveObject)
	{
		// Add any doors that need to listen for notification
		if (InteractiveObject.IsDoor() && InteractiveObject.HasDestroyAnim()) //Is this a closed door?
		{
			BuildTrack = EmptyTrack;
			//Don't necessarily have a previous state, so just use the one we know about
			BuildTrack.StateObject_OldState = InteractiveObject;
			BuildTrack.StateObject_NewState = InteractiveObject;
			BuildTrack.TrackActor = History.GetVisualizer(InteractiveObject.ObjectID);

			if (!AbilityTemplate.bSkipFireAction)
				class'X2Action_WaitForAbilityEffect'.static.AddToVisualizationTrack(BuildTrack, Context);

			class'X2Action_BreakInteractActor'.static.AddToVisualizationTrack(BuildTrack, Context);

			OutVisualizationTracks.AddItem(BuildTrack);
		}
	}
}


//---------------------------------------------------------------------------------------------------
// Steadfast
//---------------------------------------------------------------------------------------------------


static function X2AbilityTemplate Steadfast()
{
	local X2AbilityTemplate						Template;
	local X2Effect_Steadfast					Effect;
	
	`CREATE_X2ABILITY_TEMPLATE(Template, 'Steadfast');

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_InfantryClass.UIPerk_steadfast";

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	// Combine stat change and event registration on the same effect
	Effect = new class'X2Effect_Steadfast';
	Effect.EffectName = 'Steadfast';
	Effect.DuplicateResponse = eDupe_Ignore;
	Effect.BuildPersistentEffect(1, true, true, true);
	Effect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage,,,Template.AbilitySourceName);
	Template.AddTargetEffect(Effect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!
	
	return Template;
}


//---------------------------------------------------------------------------------------------------
// Extra Conditioning
//---------------------------------------------------------------------------------------------------


static function X2AbilityTemplate ExtraConditioning()
{
	local X2AbilityTemplate						Template;
	local X2Effect_PersistentStatChange			Effect;
	
	`LOG("Lucubration Infantry Class: Extra Conditioning health bonus=" @ string(default.ExtraConditioningHealthBonus));
	`LOG("Lucubration Infantry Class: Extra Conditioning aim bonus=" @ string(default.ExtraConditioningAimBonus));
	`LOG("Lucubration Infantry Class: Extra Conditioning will bonus=" @ string(default.ExtraConditioningWillBonus));

	`CREATE_X2ABILITY_TEMPLATE(Template, 'ExtraConditioning');

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_InfantryClass.UIPerk_extraconditioning";

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	// Combine stat change and event registration on the same effect
	Effect = new class'X2Effect_PersistentStatChange';
	Effect.EffectName = 'ExtraConditioning';
	Effect.DuplicateResponse = eDupe_Ignore;
	Effect.AddPersistentStatChange(eStat_HP, default.ExtraConditioningHealthBonus);
	Effect.AddPersistentStatChange(eStat_Offense, default.ExtraConditioningAimBonus);
	Effect.AddPersistentStatChange(eStat_Will, default.ExtraConditioningWillBonus);
	Effect.BuildPersistentEffect(1, true, false);
	Effect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage,,,Template.AbilitySourceName);
	Template.AddTargetEffect(Effect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!

	return Template;
}


//---------------------------------------------------------------------------------------------------
// Flare
//---------------------------------------------------------------------------------------------------


static function X2AbilityTemplate Flare()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityCharges					Charges;
	local X2AbilityCost_Charges				ChargeCost;
	local X2AbilityCooldown					Cooldown;
	local X2AbilityTarget_Cursor            CursorTarget;
	local X2AbilityMultiTarget_Radius       RadiusMultiTarget;
	local X2Condition_UnitProperty          UnitPropertyCondition;
	local X2AbilityTrigger_PlayerInput      InputTrigger;
	local X2Effect_ApplyFlareTargetToWorld	FlareEffect;
	
	`LOG("Lucubration Infantry Class: Flare charges=" @ string(default.FlareCharges));
	`LOG("Lucubration Infantry Class: Flare radius=" @ string(default.FlareRadius));
	`LOG("Lucubration Infantry Class: Flare height=" @ string(default.FlareHeight));
	`LOG("Lucubration Infantry Class: Flare range=" @ string(default.FlareRange));

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Flare');
	
	Template.bDontDisplayInAbilitySummary = false;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_demolition";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_CORPORAL_PRIORITY;
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.bShowActivation = false;
	Template.bShowPostActivation = false;
	Template.bSkipFireAction = false;
	Template.CustomFireAnim = 'HL_SignalPoint';

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bFreeCost = true;
	Template.AbilityCosts.AddItem(ActionPointCost);
	
	Charges = new class 'X2AbilityCharges';
	Charges.InitialCharges = default.FlareCharges;
	Template.AbilityCharges = Charges;
	
	ChargeCost = new class'X2AbilityCost_Charges';
	ChargeCost.NumCharges = 1;
	Template.AbilityCosts.AddItem(ChargeCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.FlareCooldown;
	Template.AbilityCooldown = Cooldown;

	Template.AbilityToHitCalc = default.DeadEye;
	
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	// The actual flare FX goes in shooter array as there will be no single target hit and no side effects of the flare FX on other units
	FlareEffect = new class'X2Effect_ApplyFlareTargetToWorld';
	FlareEffect.DuplicateResponse = eDupe_Allow;
	FlareEffect.BuildPersistentEffect(default.FlareDuration, false, false, false, eGameRule_PlayerTurnEnd);
	FlareEffect.SetDisplayInfo(ePerkBuff_Bonus, "Flare", "TESING: Flare effect is applied.", "img:///UILibrary_PerkIcons.UIPerk_shaken", false,, 'Flare');
	FlareEffect.EffectName = 'Flare';
	Template.AddShooterEffect(FlareEffect);

	// Apply the negative status to targets
	Template.AddMultiTargetEffect(static.CreateFlareStatusEffect());

	CursorTarget = new class'X2AbilityTarget_Cursor';
	CursorTarget.FixedAbilityRange = default.FlareRange;
	Template.AbilityTargetStyle = CursorTarget;
	
	RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
	RadiusMultiTarget.fTargetRadius = default.FlareRadius;
	RadiusMultiTarget.bIgnoreBlockingCover = true;
	Template.AbilityMultiTargetStyle = RadiusMultiTarget;

	// Prevent the effect from apply to dead targets
	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeDead = true;
	Template.AbilityShooterConditions.AddItem(UnitPropertyCondition); 
	Template.AddShooterEffectExclusions();

	InputTrigger = new class'X2AbilityTrigger_PlayerInput';
	Template.AbilityTriggers.AddItem(InputTrigger);
	
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = Flare_BuildVisualization;
	Template.CinescriptCameraType = "Viper_PoisonSpit";

	Template.TargetingMethod = class'X2TargetingMethod_Flare';

	// This action is considered 'hostile' and can be interrupted!
	Template.Hostility = eHostility_Offensive;
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;
	
	return Template;
}

static function X2Effect_Illuminated CreateFlareStatusEffect()
{
	local X2Effect_Illuminated				FlareEffect;
	local X2Condition_UnitProperty			UnitPropCondition;

	// Flare effect always lasts for 1 turn. The ticking of the world spawn flare refreshes it on enemies
	// inside the flare AoE, and entering the flare AoE will apply it to enemies
	FlareEffect = new class'X2Effect_Illuminated';
	FlareEffect.EffectName = default.FlareStatusEffectName;
	FlareEffect.DuplicateResponse = eDupe_Refresh;
	FlareEffect.BuildPersistentEffect(1,,,,eGameRule_PlayerTurnEnd);
	FlareEffect.SetDisplayInfo(ePerkBuff_Penalty, default.FlareFriendlyName, default.FlareFriendlyDesc, "img:///UILibrary_PerkIcons.UIPerk_demolition", true,, 'eAbilitySource_Perk');
	FlareEffect.VisualizationFn = static.IlluminatedVisualization;
	FlareEffect.EffectTickedVisualizationFn = static.IlluminatedVisualizationTicked;
	FlareEffect.EffectRemovedVisualizationFn = static.IlluminatedVisualizationRemoved;
	FlareEffect.bRemoveWhenTargetDies = true;

	UnitPropCondition = new class'X2Condition_UnitProperty';
	UnitPropCondition.ExcludeFriendlyToSource = false;
	FlareEffect.TargetConditions.AddItem(UnitPropCondition);

	return FlareEffect;
}

static function IlluminatedVisualization(XComGameState VisualizeGameState, out VisualizationTrack BuildTrack, const name EffectApplyResult)
{
	if( EffectApplyResult != 'AA_Success' )
	{
		return;
	}
	if (XComGameState_Unit(BuildTrack.StateObject_NewState) == none)
		return;

	class'X2StatusEffects'.static.AddEffectSoundAndFlyOverToTrack(BuildTrack, VisualizeGameState.GetContext(), default.FlareFriendlyName, '', eColor_Bad, class'UIUtilities_Image'.const.UnitStatus_Marked);
	class'X2StatusEffects'.static.AddEffectMessageToTrack(BuildTrack, default.FlareEffectAcquiredString, VisualizeGameState.GetContext());
	class'X2StatusEffects'.static.UpdateUnitFlag(BuildTrack, VisualizeGameState.GetContext());
}

static function IlluminatedVisualizationTicked(XComGameState VisualizeGameState, out VisualizationTrack BuildTrack, const name EffectApplyResult)
{
	local XComGameState_Unit UnitState;

	UnitState = XComGameState_Unit(BuildTrack.StateObject_NewState);
	if (UnitState == none)
		return;

	// dead units should not be reported
	if( !UnitState.IsAlive() )
	{
		return;
	}

	class'X2StatusEffects'.static.AddEffectSoundAndFlyOverToTrack(BuildTrack, VisualizeGameState.GetContext(), default.FlareFriendlyName, '', eColor_Bad, class'UIUtilities_Image'.const.UnitStatus_Marked);
	class'X2StatusEffects'.static.AddEffectMessageToTrack(BuildTrack, default.FlareEffectTickedString, VisualizeGameState.GetContext());
	class'X2StatusEffects'.static.UpdateUnitFlag(BuildTrack, VisualizeGameState.GetContext());
}

static function IlluminatedVisualizationRemoved(XComGameState VisualizeGameState, out VisualizationTrack BuildTrack, const name EffectApplyResult)
{
	local XComGameState_Unit UnitState;

	UnitState = XComGameState_Unit(BuildTrack.StateObject_NewState);
	if (UnitState == none)
		return;

	// dead units should not be reported
	if( !UnitState.IsAlive() )
	{
		return;
	}

	class'X2StatusEffects'.static.AddEffectMessageToTrack(BuildTrack, default.FlareEffectLostString, VisualizeGameState.GetContext());
	class'X2StatusEffects'.static.UpdateUnitFlag(BuildTrack, VisualizeGameState.GetContext());
}

simulated function Flare_BuildVisualization(XComGameState VisualizeGameState, out array<VisualizationTrack> OutVisualizationTracks)
{
	local X2AbilityTemplate             AbilityTemplate;
	local XComGameStateContext_Ability  Context;
	local AbilityInputContext           AbilityContext;
	local StateObjectReference          ShootingUnitRef;
	local XComGameState_BaseObject      TargetStateObject;//Container for state objects within VisualizeGameState	
	local array<X2Effect>               MultiTargetEffects;
	local bool							bSourceIsAlsoTarget;
	local bool							bMultiSourceIsAlsoTarget;
	
	local Actor                     TargetVisualizer, ShooterVisualizer;
	local X2VisualizerInterface     TargetVisualizerInterface, ShooterVisualizerInterface;
	local int                       EffectIndex, TargetIndex;
	local XComGameState_WorldEffectTileData WorldDataUpdate;

	local VisualizationTrack        EmptyTrack;
	local VisualizationTrack        BuildTrack;
	local VisualizationTrack        SourceTrack;
	local int						TrackIndex;
	local bool						bAlreadyAdded;
	local XComGameStateHistory      History;

	//local X2Action_WaitForAbilityEffect		WaitForAbilityEffect;
	local X2Action_PlayAnimation            PlayAnimation;

	local name         ApplyResult;
		
	History = `XCOMHISTORY;
	Context = XComGameStateContext_Ability(VisualizeGameState.GetContext());

	AbilityContext = Context.InputContext;
	AbilityTemplate = class'XComGameState_Ability'.static.GetMyTemplateManager().FindAbilityTemplate(AbilityContext.AbilityTemplateName);

	//Configure the visualization track for the shooter, part I. We split this into two parts since
	//in some situations the shooter can also be a target
	//****************************************************************************************
	ShootingUnitRef = Context.InputContext.SourceObject;
	ShooterVisualizer = History.GetVisualizer(ShootingUnitRef.ObjectID);
	ShooterVisualizerInterface = X2VisualizerInterface(ShooterVisualizer);

	SourceTrack = EmptyTrack;
	SourceTrack.StateObject_OldState = History.GetGameStateForObjectID(ShootingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
	SourceTrack.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(ShootingUnitRef.ObjectID);
	SourceTrack.TrackActor = ShooterVisualizer;

	if (!AbilityTemplate.bSkipFireAction)
	{
		if (!AbilityTemplate.bSkipExitCoverWhenFiring)
		{
			class'X2Action_ExitCover'.static.AddToVisualizationTrack(SourceTrack, Context);
		}
	}
	
	PlayAnimation = X2Action_PlayAnimation(class'X2Action_PlayAnimation'.static.AddToVisualizationTrack(SourceTrack, Context));
	PlayAnimation.Params.AnimName = 'HL_SignalPoint';
	
	//If there are effects added to the shooter, add the visualizer actions for them
	for (EffectIndex = 0; EffectIndex < AbilityTemplate.AbilityShooterEffects.Length; ++EffectIndex)
	{
		AbilityTemplate.AbilityShooterEffects[EffectIndex].AddX2ActionsForVisualization(VisualizeGameState, SourceTrack, Context.FindShooterEffectApplyResult(AbilityTemplate.AbilityShooterEffects[EffectIndex]));
	}

	//****************************************************************************************

	//Configure the visualization track for the target(s). This functionality uses the context primarily
	//since the game state may not include state objects for misses.
	//****************************************************************************************
	MultiTargetEffects = AbilityTemplate.AbilityMultiTargetEffects;
	
	// Apply effects to multi targets
	if( MultiTargetEffects.Length > 0 && AbilityContext.MultiTargets.Length > 0)
	{
		for( TargetIndex = 0; TargetIndex < AbilityContext.MultiTargets.Length; ++TargetIndex )
		{	
			bMultiSourceIsAlsoTarget = false;
			if( AbilityContext.MultiTargets[TargetIndex].ObjectID == AbilityContext.SourceObject.ObjectID )
			{
				bMultiSourceIsAlsoTarget = true;
				bSourceIsAlsoTarget = bMultiSourceIsAlsoTarget;				
			}

			//Some abilities add the same target multiple times into the targets list - see if this is the case and avoid adding redundant tracks
			bAlreadyAdded = false;
			for( TrackIndex = 0; TrackIndex < OutVisualizationTracks.Length; ++TrackIndex )
			{
				if( OutVisualizationTracks[TrackIndex].StateObject_NewState.ObjectID == AbilityContext.MultiTargets[TargetIndex].ObjectID )
				{
					bAlreadyAdded = true;
				}
			}

			if( !bAlreadyAdded )
			{
				TargetVisualizer = History.GetVisualizer(AbilityContext.MultiTargets[TargetIndex].ObjectID);
				TargetVisualizerInterface = X2VisualizerInterface(TargetVisualizer);

				if( bMultiSourceIsAlsoTarget )
				{
					BuildTrack = SourceTrack;
				}
				else
				{
					BuildTrack = EmptyTrack;
				}
				BuildTrack.TrackActor = TargetVisualizer;

				TargetStateObject = VisualizeGameState.GetGameStateForObjectID(AbilityContext.MultiTargets[TargetIndex].ObjectID);
				if( TargetStateObject != none )
				{
					History.GetCurrentAndPreviousGameStatesForObjectID(AbilityContext.MultiTargets[TargetIndex].ObjectID, 
																	   BuildTrack.StateObject_OldState, BuildTrack.StateObject_NewState,
																	   eReturnType_Reference,
																	   VisualizeGameState.HistoryIndex);
					`assert(BuildTrack.StateObject_NewState == TargetStateObject);
				}			
				else
				{
					//If TargetStateObject is none, it means that the visualize game state does not contain an entry for the primary target. Use the history version
					//and show no change.
					BuildTrack.StateObject_OldState = History.GetGameStateForObjectID(AbilityContext.PrimaryTarget.ObjectID);
					BuildTrack.StateObject_NewState = BuildTrack.StateObject_OldState;
				}

				//Make the target wait until signaled by the shooter that the projectiles are hitting
				if (!AbilityTemplate.bSkipFireAction && !bMultiSourceIsAlsoTarget)
				{
					//WaitForAbilityEffect = X2Action_WaitForAbilityEffect(class'X2Action_WaitForAbilityEffect'.static.AddToVisualizationTrack(BuildTrack, Context));
					//WaitForAbilityEffect.ChangeTimeoutLength(5.0f);
				}
		
				//Add any X2Actions that are specific to this effect being applied. These actions would typically be instantaneous, showing UI world messages
				//playing any effect specific audio, starting effect specific effects, etc. However, they can also potentially perform animations on the 
				//track actor, so the design of effect actions must consider how they will look/play in sequence with other effects.
				for (EffectIndex = 0; EffectIndex < MultiTargetEffects.Length; ++EffectIndex)
				{
					ApplyResult = Context.FindMultiTargetEffectApplyResult(MultiTargetEffects[EffectIndex], TargetIndex);

					// Target effect visualization
					MultiTargetEffects[EffectIndex].AddX2ActionsForVisualization(VisualizeGameState, BuildTrack, ApplyResult);
				}			

				if( TargetVisualizerInterface != none )
				{
					//Allow the visualizer to do any custom processing based on the new game state. For example, units will create a death action when they reach 0 HP.
					TargetVisualizerInterface.BuildAbilityEffectsVisualization(VisualizeGameState, BuildTrack);
				}

				if( !bMultiSourceIsAlsoTarget && BuildTrack.TrackActions.Length > 0 )
				{
					OutVisualizationTracks.AddItem(BuildTrack);
				}

				if( bMultiSourceIsAlsoTarget )
				{
					SourceTrack = BuildTrack;
				}
			}
		}
	}
	//****************************************************************************************

	//Finish adding the shooter's track
	//****************************************************************************************
	if( !bSourceIsAlsoTarget && ShooterVisualizerInterface != none)
	{
		ShooterVisualizerInterface.BuildAbilityEffectsVisualization(VisualizeGameState, SourceTrack);				
	}	

	if (!AbilityTemplate.bSkipFireAction)
	{
		if (!AbilityTemplate.bSkipExitCoverWhenFiring)
		{
			class'X2Action_EnterCover'.static.AddToVisualizationTrack(SourceTrack, Context);
		}
	}

	OutVisualizationTracks.AddItem(SourceTrack);

	foreach VisualizeGameState.IterateByClassType(class'XComGameState_WorldEffectTileData', WorldDataUpdate)
	{
		BuildTrack = EmptyTrack;
		BuildTrack.TrackActor = none;
		BuildTrack.StateObject_NewState = WorldDataUpdate;
		BuildTrack.StateObject_OldState = WorldDataUpdate;

		//Wait until signaled by the shooter that the projectiles are hitting
		//if (!AbilityTemplate.bSkipFireAction)
			//class'X2Action_WaitForAbilityEffect'.static.AddToVisualizationTrack(BuildTrack, Context);

		for (EffectIndex = 0; EffectIndex < AbilityTemplate.AbilityShooterEffects.Length; ++EffectIndex)
		{
			AbilityTemplate.AbilityShooterEffects[EffectIndex].AddX2ActionsForVisualization(VisualizeGameState, BuildTrack, 'AA_Success');		
		}

		for (EffectIndex = 0; EffectIndex < AbilityTemplate.AbilityTargetEffects.Length; ++EffectIndex)
		{
			AbilityTemplate.AbilityTargetEffects[EffectIndex].AddX2ActionsForVisualization(VisualizeGameState, BuildTrack, 'AA_Success');
		}

		for (EffectIndex = 0; EffectIndex < MultiTargetEffects.Length; ++EffectIndex)
		{
			MultiTargetEffects[EffectIndex].AddX2ActionsForVisualization(VisualizeGameState, BuildTrack, 'AA_Success');	
		}

		OutVisualizationTracks.AddItem(BuildTrack);
	}
}

DefaultProperties
{
	// I don't know why names are initialized using strings
	LightEmUpAbilityName="LightEmUp"
	EstablishedDefensesOverwatchDefenseAbilityName="EstablishedDefensesOverwatchDefense"
	EstablishedDefensesOverwatchDefenseEffectName="EstablishedDefensesOverwatchDefense"
	EstablishedDefensesOverwatchArmorAbilityName="EstablishedDefensesOverwatchArmor"
	EstablishedDefensesOverwatchArmorEffectName="EstablishedDefensesOverwatchArmor"
	EstablishedDefensesOverwatchPointsName="EstablishedDefensesOverwatchPoints"
	CrippledEffectName="Crippled"
	StaggeredEffectName="Staggered"
	DeepReservesAbilityName="DeepReserves"
	StickAndMoveDamageAbilityName="StickAndMoveDamage"
	StickAndMoveDamageEffectName="StickAndMoveDamage"
	StickAndMoveMobilityAbilityName="StickAndMoveMobility"
	StickAndMoveMobilityEffectName="StickAndMoveMobility"
	StickAndMoveDodgeAbilityName="StickAndMoveDodge"
	StickAndMoveDodgeEffectName="StickAndMoveDodge"
	FlareStatusEffectName="Illuminated"
	ZoneOfControlActionPointName="zoneofcontrol"
	ZoneOfControlReactionFireAbilityName="ZoneOfControlShot"
	ZoneOfControlCounterAttackAbilityName="ZoneOfControlCounterattack"
	ZoneOfControlCounterAttackDefenseAbilityName="ZoneOfControlCounterAttackDefense"
	ZoneOfControlCounterAttackDefenseEffectName="ZoneOfControlCounterAttackDefense"
	EscapeAndEvadeActionPointName="escapeandevade"
	EscapeAndEvadeStealthAbilityName="EscapeAndEvadeStealth"
}
