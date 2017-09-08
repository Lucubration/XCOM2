class X2Ability_Beags_Escalation_GunnerAbilitySet extends X2Ability
	config(Beags_Escalation_Ability);

var config float HMGSquadsightRange;
var config array<name> ShredderAmmoUpgradeName;
var config int CollateralDamageCooldown;
var config float CollateralDamageRadius;
var config int CollateralDamageDamage;
var config float FireSuperiorityReturnFireRadius;
var config float IronCurtainConeEndDiameter;
var config int IronCurtainActionPointCost;
var config int IronCurtainAimBonus;
var config int IronCurtainAmmoCost;
var config int IronCurtainCooldown;
var config float IronCurtainDamageMultiplier;
var config int IronCurtainDuration;
var config float BraceRange;
var config int BraceAimPenalty;
var config int SuppressingFireAimPenalty;

var localized string HMGBracedFriendlyName;
var localized string HMGBracedFriendlyDesc;
var localized string HMGMovedFriendlyName;
var localized string HMGMovedFriendlyDesc;
var localized string HMGSquadsightFriendlyName;
var localized string HMGSquadsightFriendlyDesc;

var name HMGMovementObserverAbilityName;
var name HMGMovedEffectName;
var name HMGBracedEffectName;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;
	
	Templates.Length = 0;
	Templates.AddItem(HMGMovementObserverAbility());
	Templates.AddItem(HMGMovedAbility());
	Templates.AddItem(HMGSquadsightAbility());
	Templates.AddItem(HMGOverwatch());
	Templates.AddItem(ShredderAmmo());
	Templates.AddItem(CollateralDamage());
	Templates.AddItem(FireSuperiority());
	Templates.AddItem(SuppressionShotAttack());
	Templates.AddItem(IronCurtain());
	Templates.AddItem(IronCurtainDamage());
	Templates.AddItem(Brace());
	Templates.AddItem(SuppressingFire());

	return Templates;
}


//---------------------------------------------------------------------------------------------------
// HMG Movement Observer
//---------------------------------------------------------------------------------------------------


static function X2AbilityTemplate HMGMovementObserverAbility()
{
	local X2AbilityTemplate								Template;
	local X2Effect_Beags_Escalation_HMGMovementObserver	ObserverEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, default.HMGMovementObserverAbilityName);

	Template.AbilitySourceName = 'eAbilitySource_Item';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.bDisplayInUITacticalText = false;
	
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	
	ObserverEffect = new class'X2Effect_Beags_Escalation_HMGMovementObserver';
	ObserverEffect.BuildPersistentEffect(1, true, false);
	ObserverEffect.AddPersistentStatChange(eStat_Mobility, -1);
	ObserverEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, false,, Template.AbilitySourceName);
	ObserverEffect.DuplicateResponse = eDupe_Ignore;
	Template.AddTargetEffect(ObserverEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;	
}


//---------------------------------------------------------------------------------------------------
// HMG Moved Ability
//---------------------------------------------------------------------------------------------------


static function X2AbilityTemplate HMGMovedAbility()
{
	local X2AbilityTemplate		Template;
	local X2Effect_Persistent	MovedEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Beags_Escalation_HMGMoved');

	Template.AbilitySourceName = 'eAbilitySource_Item';
	Template.IconImage = "img:///UILibrary_Beags_Escalation_Icons.UIPerk_snapshot";
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.bDisplayInUITacticalText = false;
	
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(new class'X2AbilityTrigger_Placeholder');
	
	// Effect prevents firing of HMG unless the Brace effect is also present
	MovedEffect = new class'X2Effect_Persistent';
	MovedEffect.EffectName = default.HMGMovedEffectName;
	MovedEffect.BuildPersistentEffect(1,,,, eGameRule_PlayerTurnBegin);
	MovedEffect.SetDisplayInfo(ePerkBuff_Penalty, default.HMGMovedFriendlyName, default.HMGMovedFriendlyDesc, Template.IconImage,,, Template.AbilitySourceName);
	MovedEffect.DuplicateResponse = eDupe_Ignore;
	Template.AddTargetEffect(MovedEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;	
}


static function X2AbilityTemplate HMGOverwatch()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_Ammo                AmmoCost;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2Effect_ReserveActionPoints      ReserveActionPointsEffect;
	local array<name>                       SkipExclusions;
	local X2Effect_CoveringFire             CoveringFireEffect;
	local X2Condition_AbilityProperty       CoveringFireCondition;
	local X2Condition_UnitProperty          ConcealedCondition;
	local X2Effect_SetUnitValue             UnitValueEffect;
	local X2Condition_UnitEffects           SuppressedCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Beags_Escalation_HMGOverwatch');
	
	Template.bDontDisplayInAbilitySummary = true;
	AmmoCost = new class'X2AbilityCost_Ammo';
	AmmoCost.iAmmo = 1;
	AmmoCost.bFreeCost = true;                  //  ammo is consumed by the shot, not by this, but this should verify ammo is available
	Template.AbilityCosts.AddItem(AmmoCost);
	
	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.bConsumeAllPoints = true;   //  this will guarantee the unit has at least 1 action point
	ActionPointCost.bFreeCost = true;           //  ReserveActionPoints effect will take all action points away
	Template.AbilityCosts.AddItem(ActionPointCost);
	
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
	Template.AddShooterEffectExclusions(SkipExclusions);

	SuppressedCondition = new class'X2Condition_UnitEffects';
	SuppressedCondition.AddExcludeEffect(class'X2Effect_Suppression'.default.EffectName, 'AA_UnitIsSuppressed');
	Template.AbilityShooterConditions.AddItem(SuppressedCondition);
	
	ReserveActionPointsEffect = new class'X2Effect_ReserveOverwatchPoints';
	Template.AddTargetEffect(ReserveActionPointsEffect);
	Template.DefaultKeyBinding = class'UIUtilities_Input'.const.FXS_KEY_Y;

	CoveringFireEffect = new class'X2Effect_CoveringFire';
	CoveringFireEffect.AbilityToActivate = 'LongWatchShot';
	CoveringFireEffect.BuildPersistentEffect(1, false, true, false, eGameRule_PlayerTurnBegin);
	CoveringFireCondition = new class'X2Condition_AbilityProperty';
	CoveringFireCondition.OwnerHasSoldierAbilities.AddItem('CoveringFire');
	CoveringFireEffect.TargetConditions.AddItem(CoveringFireCondition);
	Template.AddTargetEffect(CoveringFireEffect);

	ConcealedCondition = new class'X2Condition_UnitProperty';
	ConcealedCondition.ExcludeFriendlyToSource = false;
	ConcealedCondition.IsConcealed = true;
	UnitValueEffect = new class'X2Effect_SetUnitValue';
	UnitValueEffect.UnitName = class'X2Ability_DefaultAbilitySet'.default.ConcealedOverwatchTurn;
	UnitValueEffect.CleanupType = eCleanup_BeginTurn;
	UnitValueEffect.NewValueToSet = 1;
	UnitValueEffect.TargetConditions.AddItem(ConcealedCondition);
	Template.AddTargetEffect(UnitValueEffect);

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	
	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_HideIfOtherAvailable;
	Template.HideIfAvailable.AddItem('LongWatch');
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_long_watch";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.OVERWATCH_PRIORITY;
	Template.bNoConfirmationWithHotKey = true;
	Template.bDisplayInUITooltip = false;
	Template.bDisplayInUITacticalText = false;
	Template.AbilityConfirmSound = "Unreal2DSounds_OverWatch";

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = class'X2Ability_DefaultAbilitySet'.static.OverwatchAbility_BuildVisualization;
	Template.CinescriptCameraType = "Overwatch";

	Template.Hostility = eHostility_Defensive;

	return Template;
}


//---------------------------------------------------------------------------------------------------
// HMG Squadsight Ability
//---------------------------------------------------------------------------------------------------


static function X2AbilityTemplate HMGSquadsightAbility()
{
	local X2AbilityTemplate							Template;
	local X2Effect_Beags_Escalation_SquadsightRange	SquadsightEffect;
	
	`LOG("Beags Escalation: HMG Squadsight range=" @ string(default.HMGSquadsightRange));

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Beags_Escalation_HMGSquadsight');

	Template.AbilitySourceName = 'eAbilitySource_Item';
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_squadsight";
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.bDisplayInUITacticalText = false;
	
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	
	// Effect prevents firing of HMG unless the Brace effect is also present
	SquadsightEffect = new class'X2Effect_Beags_Escalation_SquadsightRange';
	SquadsightEffect.Range = default.HMGSquadsightRange;
	SquadsightEffect.BuildPersistentEffect(1, true, false);
	SquadsightEffect.SetDisplayInfo(ePerkBuff_Passive, default.HMGSquadsightFriendlyName, default.HMGSquadsightFriendlyDesc, Template.IconImage,,, Template.AbilitySourceName);
	SquadsightEffect.DuplicateResponse = eDupe_Ignore;
	Template.AddTargetEffect(SquadsightEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;	
}


//---------------------------------------------------------------------------------------------------
// Shredder Ammo
//---------------------------------------------------------------------------------------------------


static function X2AbilityTemplate ShredderAmmo()
{
	local X2AbilityTemplate							Template;
	local X2Effect_Beags_Escalation_ShredderAmmo	ShredderEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Beags_Escalation_ShredderAmmo');

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_shredder";
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.bDisplayInUITacticalText = false;
	
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	
	ShredderEffect = new class'X2Effect_Beags_Escalation_ShredderAmmo';
	ShredderEffect.EffectName = 'Beags_Escalation_ShredderAmmo';
	ShredderEffect.InventorySlot = eInvSlot_PrimaryWeapon;
	ShredderEffect.BuildPersistentEffect(1, true, false);
	ShredderEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage,,, Template.AbilitySourceName);
	ShredderEffect.DuplicateResponse = eDupe_Ignore;
	Template.AddTargetEffect(ShredderEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}


//---------------------------------------------------------------------------------------------------
// Shredder Ammo
//---------------------------------------------------------------------------------------------------


static function X2AbilityTemplate CollateralDamage()
{
	local X2AbilityTemplate						Template;
	local X2AbilityCost_ActionPoints			ActionPointCost;
	local X2AbilityCost_Ammo					AmmoCost;
	local X2AbilityTarget_Cursor				CursorTarget;
	local X2AbilityMultiTarget_Radius			RadiusMultiTarget;
	local X2AbilityCooldown						Cooldown;
	local X2Effect_ApplyWeaponDamage			WorldDamage;
	
	`LOG("Beags Escalation: Collateral Damage cooldown=" @ string(default.CollateralDamageCooldown));
	`LOG("Beags Escalation: Collateral Damage radius=" @ string(default.CollateralDamageRadius));
	`LOG("Beags Escalation: Collateral Damage environmental damage=" @ string(default.CollateralDamageDamage));

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Beags_Escalation_CollateralDamage');

	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_SERGEANT_PRIORITY;
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.IconImage = "img:///UILibrary_Beags_Escalation_Icons.UIPerk_collateraldamage";
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";
	Template.bLimitTargetIcons = true;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	if (default.CollateralDamageCooldown > 0)
	{
		Cooldown = new class'X2AbilityCooldown';
		Cooldown.iNumTurns = default.CollateralDamageCooldown;
		Template.AbilityCooldown = Cooldown;
	}

	AmmoCost = new class'X2AbilityCost_Ammo';
	AmmoCost.iAmmo = 3;
	Template.AbilityCosts.AddItem(AmmoCost);
	
	CursorTarget = new class'X2AbilityTarget_Cursor';
	CursorTarget.bRestrictToWeaponRange = true;
	Template.AbilityTargetStyle = CursorTarget;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.TargetingMethod = class'X2TargetingMethod_Beags_Escalation_Radius';
	
	RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
	RadiusMultiTarget.fTargetRadius = `UNITSTOMETERS(default.CollateralDamageRadius);
	Template.AbilityMultiTargetStyle = RadiusMultiTarget;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);

	WorldDamage = new class'X2Effect_ApplyWeaponDamage';
	WorldDamage.EnvironmentalDamageAmount = default.CollateralDamageDamage;
	WorldDamage.bApplyOnHit = false;
	WorldDamage.bApplyOnMiss = false;
	WorldDamage.bApplyToWorldOnHit = true;
	WorldDamage.bApplyToWorldOnMiss = true;
	Template.AddTargetEffect(WorldDamage);

	Template.bOverrideVisualResult = true;
	Template.OverrideVisualResult = eHit_Miss;

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;

	return Template;
}


//---------------------------------------------------------------------------------------------------
// Fire Superiority
//---------------------------------------------------------------------------------------------------


static function X2DataTemplate FireSuperiority()
{
	local X2AbilityTemplate								Template;
	local X2Effect_Beags_Escalation_FireSuperiority		PersistentEffect;

	`LOG("Beags Escalation: Fire Superiority return fire radius=" @ string(default.FireSuperiorityReturnFireRadius));
	
	`CREATE_X2ABILITY_TEMPLATE(Template, 'Beags_Escalation_FireSuperiority');

	Template.AdditionalAbilities.AddItem('Beags_Escalation_SuppressionShotAttack');
	
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_Beags_Escalation_Icons.UIPerk_firesuperiority";

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	PersistentEffect = new class'X2Effect_Beags_Escalation_FireSuperiority';
	PersistentEffect.EffectName = 'Beags_Escalation_FireSuperiority';
	PersistentEffect.BuildPersistentEffect(1, true, false);
	PersistentEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.LocLongDescription, Template.IconImage,,, Template.AbilitySourceName);
	PersistentEffect.DuplicateResponse = eDupe_Ignore;
	Template.AddTargetEffect(PersistentEffect);
	
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!

	return Template;
}


//---------------------------------------------------------------------------------------------------
// Suppression Shot (Attack)
//---------------------------------------------------------------------------------------------------


// This is a specialized version of the suppression shot that occurs when the target attacks
static function X2AbilityTemplate SuppressionShotAttack()
{
	local X2AbilityTemplate							Template;
	local X2AbilityTrigger_Event					Trigger;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Beags_Escalation_SuppressionShotAttack');

	SuppressionShotHelper(Template);
	
	// Trigger on attacks - interrupt the move
	Trigger = new class'X2AbilityTrigger_Event';
	Trigger.EventObserverClass = class'X2TacticalGameRuleset_AttackObserver';
	Trigger.MethodName = 'InterruptGameState';
	Template.AbilityTriggers.AddItem(Trigger);

	return Template;
}

static function X2AbilityTemplate SuppressionShotHelper(X2AbilityTemplate Template)
{
	local X2AbilityCost_ReserveActionPoints							ReserveActionPointCost;
	local X2AbilityToHitCalc_StandardAim							StandardAim;
	local X2Condition_Visibility									TargetVisibilityCondition;
	local array<name>												SkipExclusions;
	local X2Condition_Beags_Escalation_UnitEffectsWithAbilitySource	TargetEffectCondition;
	local X2Effect													ShotEffect;

	Template.bDontDisplayInAbilitySummary = true;
	ReserveActionPointCost = new class'X2AbilityCost_ReserveActionPoints';
	ReserveActionPointCost.bFreeCost = true;
	ReserveActionPointCost.iNumPoints = 1;
	ReserveActionPointCost.AllowedTypes.AddItem('Suppression');
	Template.AbilityCosts.AddItem(ReserveActionPointCost);
	
	StandardAim = new class'X2AbilityToHitCalc_StandardAim';
	StandardAim.bReactionFire = true;
	Template.AbilityToHitCalc = StandardAim;
	Template.AbilityToHitOwnerOnMissCalc = StandardAim;

	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);

	TargetEffectCondition = new class'X2Condition_Beags_Escalation_UnitEffectsWithAbilitySource';
	TargetEffectCondition.AddRequireEffect(class'X2Effect_Suppression'.default.EffectName, 'AA_UnitIsNotSuppressed');
	Template.AbilityTargetConditions.AddItem(TargetEffectCondition);

	TargetVisibilityCondition = new class'X2Condition_Visibility';	
	TargetVisibilityCondition.bRequireGameplayVisible = true;
	Template.AbilityTargetConditions.AddItem(TargetVisibilityCondition);

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
	Template.AddShooterEffectExclusions(SkipExclusions);
	Template.bAllowAmmoEffects = true;

	Template.AbilityTargetStyle = default.SimpleSingleTarget;

	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_supression";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_LIEUTENANT_PRIORITY;
	Template.bDisplayInUITooltip = false;
	Template.bDisplayInUITacticalText = false;

	// Don't want to exit cover, we are already in suppression/alert mode.
	Template.bSkipExitCoverWhenFiring = true;

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.bAllowFreeFireWeaponUpgrade = true;	

	ShotEffect = class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect();
	ShotEffect.TargetConditions.AddItem(class'X2Ability_DefaultAbilitySet'.static.OverwatchTargetEffectsCondition());
	Template.AddTargetEffect(ShotEffect);
	ShotEffect = class'X2Ability_GrenadierAbilitySet'.static.ShredderDamageEffect();
	ShotEffect.TargetConditions.AddItem(class'X2Ability_DefaultAbilitySet'.static.OverwatchTargetEffectsCondition());
	Template.AddTargetEffect(ShotEffect);

	return Template;	
}


//---------------------------------------------------------------------------------------------------
// Iron Curtain
//---------------------------------------------------------------------------------------------------


static function X2AbilityTemplate IronCurtain()
{
	local X2AbilityTemplate						Template;	
	local X2AbilityCost_Ammo					AmmoCost;
	local X2AbilityCost_ActionPoints			ActionPointCost;
	local X2AbilityTarget_Cursor				CursorTarget;
	local X2AbilityMultiTarget_Cone				ConeMultiTarget;
	local X2Condition_UnitProperty				UnitPropertyCondition;
	local X2AbilityToHitCalc_StandardAim		StandardAim;
	local X2AbilityCooldown						Cooldown;
	local X2Effect_Beags_Escalation_Staggered	StaggeredEffect;

	`LOG("Beags Escalation: Iron Curtain cone end diameter=" @ string(default.IronCurtainConeEndDiameter));
	`LOG("Beags Escalation: Iron Curtain action point cost=" @ string(default.IronCurtainActionPointCost));
	`LOG("Beags Escalation: Iron Curtain aim bonus=" @ string(default.IronCurtainAimBonus));
	`LOG("Beags Escalation: Iron Curtain ammo cost=" @ string(default.IronCurtainAmmoCost));
	`LOG("Beags Escalation: Iron Curtain cooldown=" @ string(default.IronCurtainCooldown));
	`LOG("Beags Escalation: Iron Curtain damage multiplier=" @ string(default.IronCurtainDamageMultiplier));
	`LOG("Beags Escalation: Iron Curtain duration=" @ string(default.IronCurtainDuration));

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Beags_Escalation_IronCurtain');

	Template.AdditionalAbilities.AddItem('Beags_Escalation_IronCurtainDamage');
	
	AmmoCost = new class'X2AbilityCost_Ammo';	
	AmmoCost.iAmmo = default.IronCurtainAmmoCost;
	Template.AbilityCosts.AddItem(AmmoCost);
	
	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = default.IronCurtainActionPointCost;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.IronCurtainCooldown;
	Template.AbilityCooldown = Cooldown;
	
	StandardAim = new class'X2AbilityToHitCalc_StandardAim';
	StandardAim.BuiltInHitMod = default.IronCurtainAimBonus;
	StandardAim.bMultiTargetOnly = true;
	Template.AbilityToHitCalc = StandardAim;
	
	Template.bOverrideAim = true;

	StaggeredEffect = new class'X2Effect_Beags_Escalation_Staggered';
	StaggeredEffect.EffectName = 'Beags_Escalation_Staggered';
	StaggeredEffect.DuplicateResponse = eDupe_Refresh; // Refresh the duration of this debuff if it's already active
	StaggeredEffect.BuildPersistentEffect(default.IronCurtainDuration,,, true, eGameRule_PlayerTurnBegin);
	StaggeredEffect.SetDisplayInfo(ePerkBuff_Penalty, class'X2StatusEffects_Beags_Escalation'.default.StaggeredFriendlyName, class'X2StatusEffects_Beags_Escalation'.default.StaggeredFriendlyDesc, "img:///UILibrary_PerkIcons.UIPerk_disoriented");
	StaggeredEffect.VisualizationFn = class'X2StatusEffects_Beags_Escalation'.static.StaggeredVisualization;
	StaggeredEffect.EffectTickedVisualizationFn = class'X2StatusEffects_Beags_Escalation'.static.StaggeredVisualizationTicked;
	StaggeredEffect.EffectRemovedVisualizationFn = class'X2StatusEffects_Beags_Escalation'.static.StaggeredVisualizationRemoved;
	StaggeredEffect.EffectHierarchyValue = class'X2StatusEffects'.default.DISORIENTED_HIERARCHY_VALUE;
	StaggeredEffect.bRemoveWhenTargetDies = true;
	StaggeredEffect.bIsImpairingMomentarily = true;
	Template.AddMultiTargetEffect(StaggeredEffect);
	Template.AddMultiTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());
	Template.AddMultiTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.ShredderDamageEffect());
	
	CursorTarget = new class'X2AbilityTarget_Cursor';
	Template.AbilityTargetStyle = CursorTarget;	

	ConeMultiTarget = new class'X2AbilityMultiTarget_Cone';
	ConeMultiTarget.bExcludeSelfAsTargetIfWithinRadius = true;
	ConeMultiTarget.ConeEndDiameter = default.IronCurtainConeEndDiameter;
	ConeMultiTarget.bUseWeaponRangeForLength = true;
	ConeMultiTarget.fTargetRadius = 99;     //  large number to handle weapon range - targets will get filtered according to cone constraints
	ConeMultiTarget.bIgnoreBlockingCover = false;
	Template.AbilityMultiTargetStyle = ConeMultiTarget;

	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeDead = true;
	UnitPropertyCondition.ExcludeFriendlyToSource = false;
	Template.AbilityShooterConditions.AddItem(UnitPropertyCondition);
	Template.AbilityTargetConditions.AddItem(UnitPropertyCondition);

	Template.AddShooterEffectExclusions();

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY;
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.IconImage = "img:///UILibrary_Beags_Escalation_Icons.UIPerk_ironcurtain";
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";

	Template.ActionFireClass = class'X2Action_Fire_SaturationFire';

	Template.TargetingMethod = class'X2TargetingMethod_Cone';

	Template.ActivationSpeech = 'SaturationFire';
	Template.CinescriptCameraType = "Grenadier_SaturationFire";
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	return Template;	
}

static function X2AbilityTemplate IronCurtainDamage()
{
	local X2AbilityTemplate										Template;
	local X2Effect_Beags_Escalation_AbilityDamageMultiplier		DamageEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Beags_Escalation_IronCurtainDamage');
	
	Template.IconImage = "img:///UILibrary_Beags_Escalation_Icons.UIPerk_ironcurtain";

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	DamageEffect = new class'X2Effect_Beags_Escalation_AbilityDamageMultiplier';
	DamageEffect.EffectName = 'Beags_Escalation_IronCurtainDamage';
	DamageEffect.DamageMultiplier = default.IronCurtainDamageMultiplier;
	DamageEffect.AbilityNames.AddItem('Beags_Escalation_IronCurtain');
	DamageEffect.BuildPersistentEffect(1, true, false);
	DamageEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, false,,Template.AbilitySourceName);
	DamageEffect.DuplicateResponse = eDupe_Ignore;
	Template.AddTargetEffect(DamageEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!

	return Template;
}


//---------------------------------------------------------------------------------------------------
// Brace
//---------------------------------------------------------------------------------------------------


static function X2AbilityTemplate Brace()
{
	local X2AbilityTemplate										Template;
	local X2AbilityCost_ActionPoints							ActionPointCost;
	local array<name>											SkipExclusions;
	local EffectReason											ExcludeEffectReason;
	local X2Condition_UnitProperty								UnitPropertyCondition;
	local X2Condition_Beags_Escalation_Brace					BraceCondition;
	local X2Condition_UnitEffects								ExcludeEffectsCondition;
	local X2Effect_Beags_Escalation_Reload						ReloadEffect;
	local X2Effect_Beags_Escalation_Brace						BraceEffect;
	local X2Condition_UnitEffects								EffectCondition;
	local EffectReason											EffectReason;
	local X2Effect_Beags_Escalation_RemoveEffect				RemoveEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Beags_Escalation_Brace');
	
	`LOG("Beags Escalation: Brace range=" @ string(default.BraceRange));
	`LOG("Beags Escalation: Brace aim penalty=" @ string(default.BraceAimPenalty));
	
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.STANDARD_GRENADE_PRIORITY;
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_Beags_Escalation_Icons.UIPerk_brace";
	
	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SimpleSingleTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	
	SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
	Template.AddShooterEffectExclusions(SkipExclusions);
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeDead = true;
	UnitPropertyCondition.ExcludeAlive = false;
	UnitPropertyCondition.ExcludeHostileToSource = true;
	UnitPropertyCondition.ExcludeFriendlyToSource = false;
	UnitPropertyCondition.RequireSquadmates = true;
	UnitPropertyCondition.RequireWithinRange = true;
	UnitPropertyCondition.WithinRange = default.BraceRange;
	Template.AbilityTargetConditions.AddItem(UnitPropertyCondition);

	ExcludeEffectsCondition = new class'X2Condition_UnitEffects';
	ExcludeEffectReason.EffectName = 'Beags_Escalation_Brace';
	ExcludeEffectReason.Reason = 'AA_UnitIsImmune';
	ExcludeEffectsCondition.ExcludeEffects.AddItem(ExcludeEffectReason);
	Template.AbilityTargetConditions.AddItem(ExcludeEffectsCondition);
	
	BraceCondition = new class'X2Condition_Beags_Escalation_Brace';
	Template.AbilityTargetConditions.AddItem(BraceCondition);

	ReloadEffect = new class'X2Effect_Beags_Escalation_Reload';
	Template.AddTargetEffect(ReloadEffect);

	// The Brace effect is only applied to HMG users who have moved this turn. It should last until the start of the soldier next turn
	BraceEffect = new class'X2Effect_Beags_Escalation_Brace';
	BraceEffect.EffectName = default.HMGBracedEffectName;
	BraceEffect.BuildPersistentEffect(1, false, false,, eGameRule_PlayerTurnBegin);
	BraceEffect.SetDisplayInfo(ePerkBuff_Bonus, default.HMGBracedFriendlyName, default.HMGBracedFriendlyDesc, Template.IconImage,,,Template.AbilitySourceName);
	BraceEffect.DuplicateResponse = eDupe_Ignore;
	BraceEffect.AimModifier = default.BraceAimPenalty;
	EffectCondition = new class'X2Condition_UnitEffects';
	EffectReason.EffectName = default.HMGMovedEffectName;
	EffectReason.Reason = 'AA_UnitIsNotImpaired';
	EffectCondition.RequireEffects.AddItem(EffectReason);
	BraceEffect.TargetConditions.AddItem(EffectCondition);
	Template.AddTargetEffect(BraceEffect);

	// Cleanse the Moved (HMG) effect
	RemoveEffect = new class'X2Effect_Beags_Escalation_RemoveEffect';
	RemoveEffect.EffectNameToRemove = default.HMGMovedEffectName;
	Template.AddTargetEffect(RemoveEffect);
	
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_ShowIfAvailable;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = class'X2Ability_DefaultAbilitySet'.static.InteractAbility_BuildVisualization;

	return Template;
}


//---------------------------------------------------------------------------------------------------
// Suppressing Fire
//---------------------------------------------------------------------------------------------------


static function X2AbilityTemplate SuppressingFire()
{
	local X2AbilityTemplate             Template;
	local X2Effect_Persistent           PersistentEffect;

	`LOG("Beags Escalation: Suppressing Fire aim penalty=" @ string(default.SuppressingFireAimPenalty));

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Beags_Escalation_SuppressingFire');
	
	Template.IconImage = "img:///UILibrary_Beags_Escalation_Icons.UIPerk_suppressingfire";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.bIsPassive = true;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	//  This is a dummy effect so that an icon shows up in the UI.
	//  Shot and Suppression abilities make use of HoloTargetEffect().
	PersistentEffect = new class'X2Effect_Persistent';
	PersistentEffect.BuildPersistentEffect(1, true, true);
	PersistentEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.LocLongDescription, Template.IconImage, true,,Template.AbilitySourceName);
	Template.AddTargetEffect(PersistentEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	// Note: no visualization on purpose!

	Template.bCrossClassEligible = true;

	return Template;
}

static function X2Effect_Beags_Escalation_SuppressingFire SuppressingFireEffect()
{
	local X2Effect_Beags_Escalation_SuppressingFire		Effect;
	local X2Condition_Beags_Escalation_AbilityProperty	AbilityCondition;

	Effect = new class'X2Effect_Beags_Escalation_SuppressingFire';
	Effect.BuildPersistentEffect(1, false, false, false, eGameRule_PlayerTurnBegin);
	Effect.bRemoveWhenTargetDies = true;
	Effect.bUseSourcePlayerState = true;

	Effect.SetDisplayInfo(ePerkBuff_Penalty, class'X2StatusEffects_Beags_Escalation'.default.SuppressingFiredFriendlyName, class'X2StatusEffects_Beags_Escalation'.default.SuppressingFiredFriendlyDesc, "img:///UILibrary_Beags_Escalation_Icons.UIPerk_suppressingfire", true);
	Effect.VisualizationFn = class'X2StatusEffects_Beags_Escalation'.static.SuppressingFiredVisualization;
	Effect.DuplicateResponse = eDupe_Allow;

	AbilityCondition = new class'X2Condition_Beags_Escalation_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('Beags_Escalation_SuppressingFire');
	Effect.TargetConditions.AddItem(AbilityCondition);

	return Effect;
}

DefaultProperties
{
	HMGMovementObserverAbilityName="Beags_Escalation_HMGMovementObserver"
	HMGMovedEffectName="Beags_Escalation_HMGMoved"
	HMGBracedEffectName="Beags_Escalation_HMGBraced"
}