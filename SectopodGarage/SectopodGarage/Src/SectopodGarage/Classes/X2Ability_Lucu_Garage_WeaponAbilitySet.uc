class X2Ability_Lucu_Garage_WeaponAbilitySet extends X2Ability
	config(Lucu_Garage_DefaultConfig);

var config int Shatterer_MinDistance;
var config float Shatterer_DamageFalloff;
var config float Shatterer_MaxDamageFalloff;
var config int BlasterCannon_PowerCost;
var config int BlasterCannon_Cooldown;
var config int PlasmaBeam_PowerCost;
var config int PlasmaBeam_Cooldown;
var config int WrathCannon_PowerCost;
var config int WrathCannon_Cooldown;
var config float WrathCannon_TileLength;
var config float WrathCannon_TileWidth;
var config float ShredderCannon_TileLength;
var config float ShredderCannon_TileWidth;
var config float Mortar_ActionPoints;
var config float Mortar_TileMinRange;
var config float Flamethrower_TileLength;
var config float Flamethrower_TileWidth;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;
	
	Templates.AddItem(InitAmmoReserve());
	Templates.AddItem(Reload());
	Templates.AddItem(FreeReload());
	Templates.AddItem(StandardShotPower());
	Templates.AddItem(ShattererDamage());
	Templates.AddItem(MiniRocket());
	Templates.AddItem(BlasterCannon());
	Templates.AddItem(PlasmaBeam());
	Templates.AddItem(WrathCannon());
	Templates.AddItem(ShredderCannon());
	Templates.AddItem(Mortar());
	Templates.AddItem(Flamethrower());

	return Templates;
}


// **************************************************************************
// ***                         Init Ammo Reserve                          ***
// **************************************************************************


static function X2AbilityTemplate InitAmmoReserve()
{
	local X2AbilityTemplate							Template;
	local X2AbilityTargetStyle						TargetStyle;
	local X2AbilityTrigger							Trigger;
	local X2Effect_Lucu_Garage_AmmoReserveModify	AmmoEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Lucu_Garage_InitAmmoReserve');
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_squadsight";

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	
	Template.bDisplayInUITooltip = false;
	Template.bDisplayInUITacticalText = false;
	Template.bDontDisplayInAbilitySummary = true;

	Template.AbilityToHitCalc = default.DeadEye;

	TargetStyle = new class'X2AbilityTarget_Self';
	Template.AbilityTargetStyle = TargetStyle;

	Trigger = new class'X2AbilityTrigger_UnitPostBeginPlay';
	Template.AbilityTriggers.AddItem(Trigger);

	AmmoEffect = new class'X2Effect_Lucu_Garage_AmmoReserveModify';
	AmmoEffect.Amount = class'Lucu_Garage_Config'.default.AmmoReserveDefault;
	Template.AddTargetEffect(AmmoEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!

	return Template;
}


// **************************************************************************
// ***                             Reload                                 ***
// **************************************************************************


static function X2AbilityTemplate Reload()
{
	local X2AbilityTemplate								Template;
	local X2AbilityCost_Lucu_Garage_ReloadAmmo			AmmoCost;
	local X2AbilityCost_ActionPoints					ActionPointCost;
	local X2Condition_Lucu_Garage_WeaponInfiniteAmmo	AmmoCondition;
	local X2Condition_UnitProperty						ShooterPropertyCondition;
	local X2Condition_AbilitySourceWeapon				WeaponCondition;
	local X2AbilityTrigger_PlayerInput					InputTrigger;
	local array<name>									SkipExclusions;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Lucu_Garage_Reload');
	
	AmmoCost = new class'X2AbilityCost_Lucu_Garage_ReloadAmmo';
	Template.AbilityCosts.AddItem(AmmoCost);

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	Template.AbilityCosts.AddItem(ActionPointCost);
	
	AmmoCondition = new class'X2Condition_Lucu_Garage_WeaponInfiniteAmmo';
	AmmoCondition.HasInfiniteAmmo = false;
	Template.AbilityShooterConditions.AddItem(AmmoCondition);
	
	ShooterPropertyCondition = new class'X2Condition_UnitProperty';	
	ShooterPropertyCondition.ExcludeDead = true;                    //Can't reload while dead
	Template.AbilityShooterConditions.AddItem(ShooterPropertyCondition);
	WeaponCondition = new class'X2Condition_AbilitySourceWeapon';
	WeaponCondition.WantsReload = true;
	Template.AbilityShooterConditions.AddItem(WeaponCondition);
	Template.DefaultKeyBinding = class'UIUtilities_Input'.const.FXS_KEY_R;

	SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
	Template.AddShooterEffectExclusions(SkipExclusions);

	InputTrigger = new class'X2AbilityTrigger_PlayerInput';
	Template.AbilityTriggers.AddItem(InputTrigger);

	Template.AbilityToHitCalc = default.DeadEye;
	
	Template.AbilityTargetStyle = default.SelfTarget;
	
	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_ShowIfAvailable;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_reload";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.RELOAD_PRIORITY;
	Template.bNoConfirmationWithHotKey = true;
	Template.bDisplayInUITooltip = false;
	Template.bDisplayInUITacticalText = false;
	Template.bDontDisplayInAbilitySummary = true;
	Template.DisplayTargetHitChance = false;

	Template.ActivationSpeech = 'Reloading';

	Template.BuildNewGameStateFn = ReloadAbility_BuildGameState;
	Template.BuildVisualizationFn = ReloadAbility_BuildVisualization;

	Template.Hostility = eHostility_Neutral;

	Template.CinescriptCameraType="GenericAccentCam";

	return Template;	
}


// **************************************************************************
// ***                          Free Reload                               ***
// **************************************************************************


static function X2AbilityTemplate FreeReload()
{
	local X2AbilityTemplate								Template;
	local X2AbilityCost_Lucu_Garage_ReloadAmmo			AmmoCost;
	local X2AbilityCost_ActionPoints					ActionPointCost;
	local X2Condition_Lucu_Garage_WeaponInfiniteAmmo	AmmoCondition;
	local X2Condition_UnitProperty						ShooterPropertyCondition;
	local X2Condition_AbilitySourceWeapon				WeaponCondition;
	local X2AbilityTrigger_PlayerInput					InputTrigger;
	local array<name>									SkipExclusions;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Lucu_Garage_FreeReload');
	
	AmmoCost = new class'X2AbilityCost_Lucu_Garage_ReloadAmmo';
	Template.AbilityCosts.AddItem(AmmoCost);

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bFreeCost = true;
	Template.AbilityCosts.AddItem(ActionPointCost);
	
	AmmoCondition = new class'X2Condition_Lucu_Garage_WeaponInfiniteAmmo';
	AmmoCondition.HasInfiniteAmmo = false;
	Template.AbilityShooterConditions.AddItem(AmmoCondition);

	ShooterPropertyCondition = new class'X2Condition_UnitProperty';	
	ShooterPropertyCondition.ExcludeDead = true;                    //Can't reload while dead
	Template.AbilityShooterConditions.AddItem(ShooterPropertyCondition);
	WeaponCondition = new class'X2Condition_AbilitySourceWeapon';
	WeaponCondition.WantsReload = true;
	Template.AbilityShooterConditions.AddItem(WeaponCondition);
	Template.DefaultKeyBinding = class'UIUtilities_Input'.const.FXS_KEY_R;

	SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
	Template.AddShooterEffectExclusions(SkipExclusions);

	InputTrigger = new class'X2AbilityTrigger_PlayerInput';
	Template.AbilityTriggers.AddItem(InputTrigger);

	Template.AbilityToHitCalc = default.DeadEye;
	
	Template.AbilityTargetStyle = default.SelfTarget;
	
	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.AbilityIconColor = class'UIUtilities_Colors'.const.OBJECTIVEICON_HTML_COLOR;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_ShowIfAvailable;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_reload";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.RELOAD_PRIORITY;
	Template.bNoConfirmationWithHotKey = true;
	Template.bDisplayInUITooltip = false;
	Template.bDisplayInUITacticalText = false;
	Template.bDontDisplayInAbilitySummary = true;
	Template.DisplayTargetHitChance = false;

	Template.ActivationSpeech = 'Reloading';

	Template.BuildNewGameStateFn = ReloadAbility_BuildGameState;
	Template.BuildVisualizationFn = ReloadAbility_BuildVisualization;

	Template.Hostility = eHostility_Neutral;

	Template.CinescriptCameraType="GenericAccentCam";

	Template.OverrideAbilities.AddItem('Lucu_Garage_Reload');

	return Template;	
}

simulated function XComGameState ReloadAbility_BuildGameState(XComGameStateContext Context)
{
	local XComGameStateHistory History;
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_Lucu_Garage_Facility Facility;
	local XComGameState_Lucu_Garage_XtopodUnitState Xtopod;
	local XComGameState NewGameState;
	local XComGameState_Unit UnitState;
	local XComGameStateContext_Ability AbilityContext;
	local XComGameState_Ability AbilityState;
	local XComGameState_Item WeaponState, NewWeaponState;

	History = `XCOMHISTORY;

	NewGameState = `XCOMHISTORY.CreateNewGameState(true, Context);	
	AbilityContext = XComGameStateContext_Ability(Context);	
	AbilityState = XComGameState_Ability(`XCOMHISTORY.GetGameStateForObjectID(AbilityContext.InputContext.AbilityRef.ObjectID));

	WeaponState = AbilityState.GetSourceWeapon();
	NewWeaponState = XComGameState_Item(NewGameState.CreateStateObject(class'XComGameState_Item', WeaponState.ObjectID));

	UnitState = XComGameState_Unit(NewGameState.CreateStateObject(class'XComGameState_Unit', AbilityContext.InputContext.SourceObject.ObjectID));	

	AbilityState.GetMyTemplate().ApplyCost(AbilityContext, AbilityState, UnitState, NewWeaponState, NewGameState);	

	XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
	Facility = class'Lucu_Garage_Utilities'.static.GetFacilityComponent(XComHQ);
	Xtopod = class'Lucu_Garage_Utilities'.static.GetXtopodComponent(UnitState, Facility);

	// Refill the weapon's ammo
	NewWeaponState.Ammo += AbilityState.iAmmoConsumed;
	
	NewGameState.AddStateObject(Xtopod);
	NewGameState.AddStateObject(UnitState);
	NewGameState.AddStateObject(NewWeaponState);

	return NewGameState;	
}

simulated function ReloadAbility_BuildVisualization(XComGameState VisualizeGameState, out array<VisualizationTrack> OutVisualizationTracks)
{
	local XComGameStateHistory History;
	local XComGameStateContext_Ability  Context;
	local StateObjectReference          ShootingUnitRef;	
	local X2Action_PlayAnimation		PlayAnimation;

	local VisualizationTrack        EmptyTrack;
	local VisualizationTrack        BuildTrack;

	local XComGameState_Ability Ability;
	local X2Action_PlaySoundAndFlyOver SoundAndFlyover;

	History = `XCOMHISTORY;

	Context = XComGameStateContext_Ability(VisualizeGameState.GetContext());
	ShootingUnitRef = Context.InputContext.SourceObject;

	BuildTrack = EmptyTrack;
	BuildTrack.StateObject_OldState = History.GetGameStateForObjectID(ShootingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
	BuildTrack.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(ShootingUnitRef.ObjectID);
	BuildTrack.TrackActor = History.GetVisualizer(ShootingUnitRef.ObjectID);
					
	PlayAnimation = X2Action_PlayAnimation(class'X2Action_PlayAnimation'.static.AddToVisualizationTrack(BuildTrack, Context));
	PlayAnimation.Params.AnimName = 'HL_Reload';

	Ability = XComGameState_Ability(History.GetGameStateForObjectID(Context.InputContext.AbilityRef.ObjectID));
	SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTrack(BuildTrack, Context));
	SoundAndFlyOver.SetSoundAndFlyOverParameters(None, "", Ability.GetMyTemplate().ActivationSpeech, eColor_Good);

	OutVisualizationTracks.AddItem(BuildTrack);
}


// **************************************************************************
// ***                      Standard Shot (Power)                         ***
// **************************************************************************


static function X2AbilityTemplate StandardShotPower()
{
	local X2AbilityTemplate                 Template;	
	local X2AbilityCost_Lucu_Garage_Power   PowerCost;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local array<name>                       SkipExclusions;
	local X2Effect_Knockback				KnockbackEffect;
	local X2Condition_Visibility            VisibilityCondition;

	// Macro to do localisation and stuffs
	`CREATE_X2ABILITY_TEMPLATE(Template, 'Lucu_Garage_StandardShotPower');

	// Icon Properties
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_standard";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.STANDARD_SHOT_PRIORITY;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.DisplayTargetHitChance = true;
	Template.AbilitySourceName = 'eAbilitySource_Standard';                                       // color of the icon
	// Activated by a button press; additionally, tells the AI this is an activatable
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
	SkipExclusions.AddItem(class'X2StatusEffects'.default.BurningName);
	Template.AddShooterEffectExclusions(SkipExclusions);

	// Targeting Details
	// Can only shoot visible enemies
	VisibilityCondition = new class'X2Condition_Visibility';
	VisibilityCondition.bRequireGameplayVisible = true;
	VisibilityCondition.bAllowSquadsight = true;
	Template.AbilityTargetConditions.AddItem(VisibilityCondition);
	// Can't target dead; Can't target friendlies
	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);
	// Can't shoot while dead
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	// Only at single targets that are in range.
	Template.AbilityTargetStyle = default.SimpleSingleTarget;

	// Action Point
	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);	

	// Power
	PowerCost = new class'X2AbilityCost_Lucu_Garage_Power';
	PowerCost.Amount = 1;
	Template.AbilityCosts.AddItem(PowerCost);

	// Weapon Upgrade Compatibility
	Template.bAllowFreeFireWeaponUpgrade = true;                        // Flag that permits action to become 'free action' via 'Hair Trigger' or similar upgrade / effects

	//  Put holo target effect first because if the target dies from this shot, it will be too late to notify the effect.
	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());
	//  Various Soldier ability specific effects - effects check for the ability before applying	
	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.ShredderDamageEffect());
	
	// Damage Effect
	Template.AddTargetEffect(default.WeaponUpgradeMissDamage);

	// Hit Calculation (Different weapons now have different calculations for range)
	Template.AbilityToHitCalc = default.SimpleStandardAim;
	Template.AbilityToHitOwnerOnMissCalc = default.SimpleStandardAim;
		
	// Targeting Method
	Template.TargetingMethod = class'X2TargetingMethod_OverTheShoulder';
	Template.bUsesFiringCamera = true;
	Template.CinescriptCameraType = "StandardGunFiring";	

	Template.AssociatedPassives.AddItem('HoloTargeting');

	// MAKE IT LIVE!
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;	
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;

	Template.bDisplayInUITooltip = false;
	Template.bDisplayInUITacticalText = false;
	Template.bDontDisplayInAbilitySummary = true;

	KnockbackEffect = new class'X2Effect_Knockback';
	KnockbackEffect.KnockbackDistance = 2;
	KnockbackEffect.bUseTargetLocation = true;
	Template.AddTargetEffect(KnockbackEffect);

	return Template;
}


// **************************************************************************
// ***                         Shatterer Damage                           ***
// **************************************************************************


static function X2AbilityTemplate ShattererDamage()
{
	local X2AbilityTemplate						Template;
	local X2AbilityTargetStyle					TargetStyle;
	local X2AbilityTrigger						Trigger;
	local X2Effect_Lucu_Garage_ShattererDamage	ShattererDamage;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Lucu_Garage_ShattererDamage');
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_squadsight";

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.bDisplayInUITooltip = false;
	Template.bDisplayInUITacticalText = false;
	Template.bDontDisplayInAbilitySummary = true;

	Template.AbilityToHitCalc = default.DeadEye;

	TargetStyle = new class'X2AbilityTarget_Self';
	Template.AbilityTargetStyle = TargetStyle;

	Trigger = new class'X2AbilityTrigger_UnitPostBeginPlay';
	Template.AbilityTriggers.AddItem(Trigger);

	ShattererDamage = new class'X2Effect_Lucu_Garage_ShattererDamage';
	ShattererDamage.MinDistance = default.Shatterer_MinDistance;
	ShattererDamage.DamageFalloff = default.Shatterer_DamageFalloff;
	ShattererDamage.MaxDamageFalloff = default.Shatterer_MaxDamageFalloff;
	ShattererDamage.BuildPersistentEffect(1, true, true, true);
	ShattererDamage.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, false,,Template.AbilitySourceName);
	Template.AddTargetEffect(ShattererDamage);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!

	return Template;
}


// **************************************************************************
// ***                           Mini Rocket                              ***
// **************************************************************************


static function X2AbilityTemplate MiniRocket()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_Ammo                AmmoCost;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
	local X2AbilityTarget_Cursor            CursorTarget;
	local X2AbilityMultiTarget_Radius       RadiusMultiTarget;
	local X2Condition_UnitProperty          UnitPropertyCondition;
	local X2AbilityToHitCalc_StandardAim    StandardAim;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Lucu_Garage_MiniRocket');
	
	AmmoCost = new class'X2AbilityCost_Ammo';
	AmmoCost.iAmmo = 1;
	Template.AbilityCosts.AddItem(AmmoCost);
	
	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = false;
	Template.AbilityCosts.AddItem(ActionPointCost);
	
	StandardAim = new class'X2AbilityToHitCalc_StandardAim';
	StandardAim.bGuaranteedHit = true;
	Template.AbilityToHitCalc = StandardAim;
	
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.bExplosiveDamage = true;
	Template.AddMultiTargetEffect(WeaponDamageEffect);
	
	CursorTarget = new class'X2AbilityTarget_Cursor';
	CursorTarget.bRestrictToWeaponRange = true;
	Template.AbilityTargetStyle = CursorTarget;

	RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
	RadiusMultiTarget.bUseWeaponRadius = true;
	Template.AbilityMultiTargetStyle = RadiusMultiTarget;

	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeDead = true;
	Template.AbilityShooterConditions.AddItem(UnitPropertyCondition);

	Template.AddShooterEffectExclusions();

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	
	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_firerocket";
	Template.bUseAmmoAsChargesForHUD = true;
	Template.TargetingMethod = class'X2TargetingMethod_Lucu_Garage_Radius';
	
	Template.bDisplayInUITooltip = false;
	Template.bDisplayInUITacticalText = false;
	Template.bDontDisplayInAbilitySummary = true;

	Template.BuildNewGameStateFn = SecondaryWeaponAbility_BuildGameState;
	Template.BuildVisualizationFn = SecondaryWeaponAbility_BuildVisualization;
	Template.CinescriptCameraType = "Soldier_HeavyWeapons";

	return Template;
}


// **************************************************************************
// ***                         Blaster Cannon                             ***
// **************************************************************************


static function X2AbilityTemplate BlasterCannon()
{
	local X2AbilityTemplate                 Template;	
	local X2AbilityCost_Lucu_Garage_Power	PowerCost;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityCooldown					Cooldown;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
	local X2AbilityTarget_Cursor            CursorTarget;
	local X2AbilityMultiTarget_Radius       RadiusMultiTarget;
	local X2Condition_UnitProperty          UnitPropertyCondition;
	local X2AbilityTrigger_PlayerInput      InputTrigger;
	local X2AbilityToHitCalc_StandardAim    StandardAim;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Lucu_Garage_BlasterCannon');
	
	PowerCost = new class'X2AbilityCost_Lucu_Garage_Power';
	PowerCost.Amount = default.BlasterCannon_PowerCost;
	Template.AbilityCosts.AddItem(PowerCost);
	
	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);
	
	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.BlasterCannon_Cooldown;
	Template.AbilityCooldown = Cooldown;
	
	StandardAim = new class'X2AbilityToHitCalc_StandardAim';
	StandardAim.bGuaranteedHit = true;
	Template.AbilityToHitCalc = StandardAim;
	
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.bExplosiveDamage = true;
	Template.AddMultiTargetEffect(WeaponDamageEffect);
	
	CursorTarget = new class'X2AbilityTarget_Cursor';
	CursorTarget.bRestrictToWeaponRange = true;
	Template.AbilityTargetStyle = CursorTarget;

	RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
	RadiusMultiTarget.bUseWeaponRadius = true;
	Template.AbilityMultiTargetStyle = RadiusMultiTarget;

	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeDead = true;
	Template.AbilityShooterConditions.AddItem(UnitPropertyCondition);

	Template.AddShooterEffectExclusions();

	InputTrigger = new class'X2AbilityTrigger_PlayerInput';
	Template.AbilityTriggers.AddItem(InputTrigger);
	
	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_blasterlauncher";
	Template.TargetingMethod = class'X2TargetingMethod_Lucu_Garage_Radius';

	Template.bDisplayInUITooltip = false;
	Template.bDisplayInUITacticalText = false;
	Template.bDontDisplayInAbilitySummary = true;

	Template.BuildNewGameStateFn = SecondaryWeaponAbility_BuildGameState;
	Template.BuildVisualizationFn = SecondaryWeaponAbility_BuildVisualization;
	Template.CinescriptCameraType = "Soldier_HeavyWeapons";

	return Template;
}


// **************************************************************************
// ***                           Plasma Beam                              ***
// **************************************************************************


static function X2AbilityTemplate PlasmaBeam()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_Lucu_Garage_Power   PowerCost;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityCooldown					Cooldown;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
	local X2AbilityTarget_Cursor            CursorTarget;
	local X2AbilityMultiTarget_Line         LineMultiTarget;
	local X2Condition_UnitProperty          UnitPropertyCondition;
	local X2AbilityTrigger_PlayerInput      InputTrigger;
	local X2AbilityToHitCalc_StandardAim    StandardAim;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Lucu_Garage_PlasmaBeam');
	
	PowerCost = new class'X2AbilityCost_Lucu_Garage_Power';
	PowerCost.Amount = default.PlasmaBeam_PowerCost;
	Template.AbilityCosts.AddItem(PowerCost);
	
	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);
	
	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.PlasmaBeam_Cooldown;
	Template.AbilityCooldown = Cooldown;

	StandardAim = new class'X2AbilityToHitCalc_StandardAim';
	StandardAim.bGuaranteedHit = true;
	Template.AbilityToHitCalc = StandardAim;
	
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.bExplosiveDamage = true;
	Template.AddMultiTargetEffect(WeaponDamageEffect);
	
	CursorTarget = new class'X2AbilityTarget_Cursor';
	CursorTarget.bRestrictToWeaponRange = true;
	Template.AbilityTargetStyle = CursorTarget;
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.ARMOR_ACTIVE_PRIORITY;

	LineMultiTarget = new class'X2AbilityMultiTarget_Line';
	Template.AbilityMultiTargetStyle = LineMultiTarget;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeFriendlyToSource = false;
	UnitPropertyCondition.ExcludeDead = true;
	Template.AbilityMultiTargetConditions.AddItem(UnitPropertyCondition);

	InputTrigger = new class'X2AbilityTrigger_PlayerInput';
	Template.AbilityTriggers.AddItem(InputTrigger);
	
	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_plasmablaster";
	Template.TargetingMethod = class'X2TargetingMethod_Lucu_Garage_Line';

	Template.bDisplayInUITooltip = false;
	Template.bDisplayInUITacticalText = false;
	Template.bDontDisplayInAbilitySummary = true;

	Template.BuildNewGameStateFn = SecondaryWeaponAbility_BuildGameState;
	Template.BuildVisualizationFn = SecondaryWeaponAbility_BuildVisualization;
	Template.CinescriptCameraType = "Soldier_HeavyWeapons";

	return Template;
}


// **************************************************************************
// ***                           Wrath Cannon                             ***
// **************************************************************************


static function X2AbilityTemplate WrathCannon()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_Lucu_Garage_Power   PowerCost;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityCooldown					Cooldown;
	local X2AbilityMultiTarget_Cone         ConeMultiTarget;
	local X2AbilityTarget_Cursor            CursorTarget;
	local X2Condition_UnitProperty          UnitProperty;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Lucu_Garage_WrathCannon');
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_sectopod_wrathcannon";
	Template.Hostility = eHostility_Offensive;
	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.bShowActivation = true;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	
	PowerCost = new class'X2AbilityCost_Lucu_Garage_Power';
	PowerCost.Amount = default.WrathCannon_PowerCost;
	Template.AbilityCosts.AddItem(PowerCost);
	
	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);
	
	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.WrathCannon_Cooldown;
	Template.AbilityCooldown = Cooldown;
	
	UnitProperty = new class'X2Condition_UnitProperty';
	UnitProperty.ExcludeDead = true;
	Template.AbilityShooterConditions.AddItem(UnitProperty);

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AddShooterEffectExclusions();
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	
	Template.TargetingMethod = class'X2TargetingMethod_Lucu_Garage_Cone';
	
	ConeMultiTarget = new class'X2AbilityMultiTarget_Cone';
	ConeMultiTarget.bUseWeaponRadius = true;
	ConeMultiTarget.ConeEndDiameter = default.WrathCannon_TileWidth * class'XComWorldData'.const.WORLD_StepSize;
	ConeMultiTarget.ConeLength = default.WrathCannon_TileLength * class'XComWorldData'.const.WORLD_StepSize;
	Template.AbilityMultiTargetStyle = ConeMultiTarget;

	CursorTarget = new class'X2AbilityTarget_Cursor';
	CursorTarget.FixedAbilityRange = default.WrathCannon_TileLength;
	Template.AbilityTargetStyle = CursorTarget;

	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.bExplosiveDamage = true;
	Template.AddMultiTargetEffect(WeaponDamageEffect);
	Template.AddMultiTargetEffect(new class'X2Effect_ApplyFireToWorld');

	Template.bDisplayInUITooltip = false;
	Template.bDisplayInUITacticalText = false;
	Template.bDontDisplayInAbilitySummary = true;

	Template.BuildNewGameStateFn = SecondaryWeaponAbility_BuildGameState;
	Template.BuildVisualizationFn = SecondaryWeaponAbility_BuildVisualization;
	Template.CinescriptCameraType = "Soldier_HeavyWeapons";

	return Template;
}


// **************************************************************************
// ***                         Shredder Cannon                            ***
// **************************************************************************


static function X2AbilityTemplate ShredderCannon()
{
	local X2AbilityTemplate                 Template;	
	local X2AbilityCost_Ammo                AmmoCost;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
	local X2AbilityTarget_Cursor            CursorTarget;
	local X2AbilityMultiTarget_Cone         ConeMultiTarget;
	local X2Condition_UnitProperty          UnitPropertyCondition;
	local X2AbilityTrigger_PlayerInput      InputTrigger;
	local X2AbilityToHitCalc_StandardAim    StandardAim;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Lucu_Garage_ShredderCannon');
	
	AmmoCost = new class'X2AbilityCost_Ammo';	
	AmmoCost.iAmmo = 1;
	Template.AbilityCosts.AddItem(AmmoCost);
		
	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	StandardAim = new class'X2AbilityToHitCalc_StandardAim';
	StandardAim.bGuaranteedHit = true;
	Template.AbilityToHitCalc = StandardAim;
	
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.bExplosiveDamage = true;
	Template.AddMultiTargetEffect(WeaponDamageEffect);
	
	CursorTarget = new class'X2AbilityTarget_Cursor';
	CursorTarget.bRestrictToWeaponRange = true;
	Template.AbilityTargetStyle = CursorTarget;
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.ARMOR_ACTIVE_PRIORITY;

	ConeMultiTarget = new class'X2AbilityMultiTarget_Cone';
	ConeMultiTarget.bUseWeaponRadius = true;
	ConeMultiTarget.ConeEndDiameter = default.ShredderCannon_TileWidth * class'XComWorldData'.const.WORLD_StepSize;
	ConeMultiTarget.ConeLength = default.ShredderCannon_TileLength * class'XComWorldData'.const.WORLD_StepSize;
	Template.AbilityMultiTargetStyle = ConeMultiTarget;

	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeDead = true;
	Template.AbilityShooterConditions.AddItem(UnitPropertyCondition);

	Template.AddShooterEffectExclusions();

	InputTrigger = new class'X2AbilityTrigger_PlayerInput';
	Template.AbilityTriggers.AddItem(InputTrigger);
	
	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_shreddergun";
	Template.bUseAmmoAsChargesForHUD = true;
	Template.TargetingMethod = class'X2TargetingMethod_Lucu_Garage_Cone';

	Template.bDisplayInUITooltip = false;
	Template.bDisplayInUITacticalText = false;
	Template.bDontDisplayInAbilitySummary = true;

	Template.BuildNewGameStateFn = SecondaryWeaponAbility_BuildGameState;
	Template.BuildVisualizationFn = SecondaryWeaponAbility_BuildVisualization;
	Template.CinescriptCameraType = "Soldier_HeavyWeapons";

	return Template;
}


// **************************************************************************
// ***                              Mortar                                ***
// **************************************************************************


static function X2AbilityTemplate Mortar()
{
	local X2AbilityTemplate						Template;	
	local X2AbilityCost_Ammo					AmmoCost;
	local X2AbilityCost_ActionPoints			ActionPointCost;
	local X2Effect_ApplyWeaponDamage			WeaponDamageEffect;
	local X2AbilityTarget_Lucu_Garage_Cursor	CursorTarget;
	local X2AbilityMultiTarget_Radius			RadiusMultiTarget;
	local X2Condition_UnitProperty				UnitPropertyCondition;
	local X2AbilityTrigger_PlayerInput			InputTrigger;
	local X2AbilityToHitCalc_StandardAim		StandardAim;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Lucu_Garage_Mortar');
	
	AmmoCost = new class'X2AbilityCost_Ammo';	
	AmmoCost.iAmmo = 1;
	Template.AbilityCosts.AddItem(AmmoCost);
		
	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = default.Mortar_ActionPoints;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	StandardAim = new class'X2AbilityToHitCalc_StandardAim';
	StandardAim.bGuaranteedHit = true;
	Template.AbilityToHitCalc = StandardAim;
	
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.bExplosiveDamage = true;
	Template.AddMultiTargetEffect(WeaponDamageEffect);
	
	CursorTarget = new class'X2AbilityTarget_Lucu_Garage_Cursor';
	CursorTarget.bRestrictToWeaponRange = true;
	CursorTarget.MinTargetingRange = default.Mortar_TileMinRange;
	Template.AbilityTargetStyle = CursorTarget;
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.ARMOR_ACTIVE_PRIORITY;
	
	RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
	RadiusMultiTarget.bUseWeaponRadius = true;
	Template.AbilityMultiTargetStyle = RadiusMultiTarget;

	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeDead = true;
	Template.AbilityShooterConditions.AddItem(UnitPropertyCondition);

	Template.AddShooterEffectExclusions();

	InputTrigger = new class'X2AbilityTrigger_PlayerInput';
	Template.AbilityTriggers.AddItem(InputTrigger);
	
	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_firerocket";
	Template.bUseAmmoAsChargesForHUD = true;
	Template.TargetingMethod = class'X2TargetingMethod_Lucu_Garage_Mortar';

	Template.bDisplayInUITooltip = false;
	Template.bDisplayInUITacticalText = false;
	Template.bDontDisplayInAbilitySummary = true;

	Template.BuildNewGameStateFn = SecondaryWeaponAbility_BuildGameState;
	Template.BuildVisualizationFn = SecondaryWeaponAbility_BuildVisualization;
	Template.CinescriptCameraType = "Soldier_HeavyWeapons";

	return Template;
}


// **************************************************************************
// ***                           Flamethrower                             ***
// **************************************************************************


static function X2AbilityTemplate Flamethrower()
{
	local X2AbilityTemplate                 Template;	
	local X2AbilityCost_Ammo                AmmoCost;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
	local X2AbilityTarget_Cursor            CursorTarget;
	local X2AbilityMultiTarget_Cone         ConeMultiTarget;
	local X2Condition_UnitProperty          UnitPropertyCondition;
	local X2AbilityTrigger_PlayerInput      InputTrigger;
	local X2Effect_ApplyFireToWorld         FireToWorldEffect;
	local X2AbilityToHitCalc_StandardAim    StandardAim;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Lucu_Garage_Flamethrower');
	
	AmmoCost = new class'X2AbilityCost_Ammo';	
	AmmoCost.iAmmo = 1;
	Template.AbilityCosts.AddItem(AmmoCost);
		
	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	StandardAim = new class'X2AbilityToHitCalc_StandardAim';
	StandardAim.bGuaranteedHit = true;
	Template.AbilityToHitCalc = StandardAim;
	
	FireToWorldEffect = new class'X2Effect_ApplyFireToWorld';
	FireToWorldEffect.bUseFireChanceLevel = true;
	FireToWorldEffect.bDamageFragileOnly = true;
	FireToWorldEffect.FireChance_Level1 = 0.0f;
	FireToWorldEffect.FireChance_Level2 = 0.5f;
	FireToWorldEffect.FireChance_Level3 = 0.25f;
	FireToWorldEffect.bCheckForLOSFromTargetLocation = false; //The flamethrower does its own LOS filtering

	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.bExplosiveDamage = true;
	Template.AddMultiTargetEffect(WeaponDamageEffect);
	Template.AddMultiTargetEffect(FireToWorldEffect);
	
	CursorTarget = new class'X2AbilityTarget_Cursor';
	CursorTarget.bRestrictToWeaponRange = true;
	Template.AbilityTargetStyle = CursorTarget;
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.ARMOR_ACTIVE_PRIORITY;

	ConeMultiTarget = new class'X2AbilityMultiTarget_Cone';
	ConeMultiTarget.bUseWeaponRadius = true;
	ConeMultiTarget.ConeEndDiameter = default.Flamethrower_TileWidth * class'XComWorldData'.const.WORLD_StepSize;
	ConeMultiTarget.ConeLength = default.Flamethrower_TileLength * class'XComWorldData'.const.WORLD_StepSize;
	Template.AbilityMultiTargetStyle = ConeMultiTarget;

	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeDead = true;
	Template.AbilityShooterConditions.AddItem(UnitPropertyCondition);

	Template.AddShooterEffectExclusions();

	InputTrigger = new class'X2AbilityTrigger_PlayerInput';
	Template.AbilityTriggers.AddItem(InputTrigger);
	
	Template.bDisplayInUITooltip = false;
	Template.bDisplayInUITacticalText = false;
	Template.bDontDisplayInAbilitySummary = true;

	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_flamethrower";
	Template.bUseAmmoAsChargesForHUD = true;

	Template.bCheckCollision = true;
	Template.bAffectNeighboringTiles = true;
	Template.bFragileDamageOnly = true;

	Template.ActionFireClass = class'X2Action_Fire_Flamethrower';
	
	Template.TargetingMethod = class'X2TargetingMethod_Lucu_Garage_Cone';

	Template.BuildNewGameStateFn = SecondaryWeaponAbility_BuildGameState;
	Template.BuildVisualizationFn = SecondaryWeaponAbility_BuildVisualization;
	Template.CinescriptCameraType = "Soldier_HeavyWeapons";

	return Template;
}

static function XComGameState SecondaryWeaponAbility_BuildGameState(XComGameStateContext Context)
{
	local XComGameState NewGameState;

	NewGameState = `XCOMHISTORY.CreateNewGameState(true, Context);

	SecondaryWeaponAbility_FillOutGameState(NewGameState);

	return NewGameState;
}

static function SecondaryWeaponAbility_FillOutGameState(XComGameState NewGameState)
{
	local XComGameStateHistory History;
	local XComGameState_Ability ShootAbilityState;
	local X2AbilityTemplate AbilityTemplate;
	local XComGameStateContext_Ability AbilityContext;
	local int TargetIndex;	

	local XComGameState_BaseObject AffectedTargetObject_OriginalState;	
	local XComGameState_BaseObject AffectedTargetObject_NewState;
	local XComGameState_Unit       SourceObject_OriginalState;
	local XComGameState_Unit       SourceObject_NewState;
	local XComGameState_Item       SourceWeapon, SourceWeapon_NewState;
	local X2AmmoTemplate           AmmoTemplate;
	local X2GrenadeTemplate        GrenadeTemplate;
	local X2WeaponTemplate         WeaponTemplate;
	local EffectResults            MultiTargetEffectResults, EmptyResults;
	local EffectTemplateLookupType MultiTargetLookupType;
	
	local TTile SourceTile;
	local Vector SourceLocation;
	local Rotator DesiredOrientation;

	History = `XCOMHISTORY;	

	//Build the new game state frame, and unit state object for the acting unit
	`assert(NewGameState != none);
	AbilityContext = XComGameStateContext_Ability(NewGameState.GetContext());
	ShootAbilityState = XComGameState_Ability(History.GetGameStateForObjectID(AbilityContext.InputContext.AbilityRef.ObjectID));	
	AbilityTemplate = ShootAbilityState.GetMyTemplate();
	SourceObject_OriginalState = XComGameState_Unit(History.GetGameStateForObjectID(AbilityContext.InputContext.SourceObject.ObjectID));
	SourceWeapon = ShootAbilityState.GetSourceWeapon();
	ShootAbilityState = XComGameState_Ability(NewGameState.CreateStateObject(ShootAbilityState.Class, ShootAbilityState.ObjectID));
	NewGameState.AddStateObject(ShootAbilityState);

	//Any changes to the shooter / source object are made to this game state
	SourceObject_NewState = XComGameState_Unit(NewGameState.CreateStateObject(SourceObject_OriginalState.Class, AbilityContext.InputContext.SourceObject.ObjectID));
	NewGameState.AddStateObject(SourceObject_NewState);

	if (SourceWeapon != none)
	{
		SourceWeapon_NewState = XComGameState_Item(NewGameState.CreateStateObject(class'XComGameState_Item', SourceWeapon.ObjectID));
		NewGameState.AddStateObject(SourceWeapon_NewState);
	}

	if (AbilityTemplate.bRecordValidTiles && AbilityContext.InputContext.TargetLocations.Length > 0)
	{
		AbilityTemplate.AbilityMultiTargetStyle.GetValidTilesForLocation(ShootAbilityState, AbilityContext.InputContext.TargetLocations[0], AbilityContext.ResultContext.RelevantEffectTiles);
	}
	
	if (AbilityContext.InputContext.TargetLocations.Length > 0)
	{
		SourceTile = SourceObject_NewState.TileLocation;
		SourceLocation = `XWORLD.GetPositionFromTileCoordinates(SourceTile);

		DesiredOrientation = Rotator(AbilityContext.InputContext.TargetLocations[0] - SourceLocation);
		SourceObject_NewState.MoveOrientation = DesiredOrientation;
	}

	//If there is a target location, generate a list of projectile events to use if a projectile is requested
	if(AbilityContext.InputContext.ProjectileEvents.Length > 0)
	{
		GenerateDamageEvents(NewGameState, AbilityContext);
	}

	//  Apply effects to shooter
	if (AbilityTemplate.AbilityShooterEffects.Length > 0)
	{
		AffectedTargetObject_OriginalState = SourceObject_OriginalState;
		AffectedTargetObject_NewState = SourceObject_NewState;				
			
		ApplyEffectsToTarget(
			AbilityContext, 
			AffectedTargetObject_OriginalState, 
			SourceObject_OriginalState, 
			ShootAbilityState, 
			AffectedTargetObject_NewState, 
			NewGameState, 
			AbilityContext.ResultContext.HitResult,
			AbilityContext.ResultContext.ArmorMitigation,
			AbilityContext.ResultContext.StatContestResult,
			AbilityTemplate.AbilityShooterEffects, 
			AbilityContext.ResultContext.ShooterEffectResults, 
			AbilityTemplate.DataName, 
			TELT_AbilityShooterEffects);
			
		NewGameState.AddStateObject(AffectedTargetObject_NewState);
	}

	//  Apply effects to primary target
	if (AbilityContext.InputContext.PrimaryTarget.ObjectID != 0)
	{
		AffectedTargetObject_OriginalState = History.GetGameStateForObjectID(AbilityContext.InputContext.PrimaryTarget.ObjectID, eReturnType_Reference);
		AffectedTargetObject_NewState = NewGameState.CreateStateObject(AffectedTargetObject_OriginalState.Class, AbilityContext.InputContext.PrimaryTarget.ObjectID);
		
		if (AbilityTemplate.AbilityTargetEffects.Length > 0)
		{
			if (ApplyEffectsToTarget(
				AbilityContext, 
				AffectedTargetObject_OriginalState, 
				SourceObject_OriginalState, 
				ShootAbilityState, 
				AffectedTargetObject_NewState, 
				NewGameState, 
				AbilityContext.ResultContext.HitResult,
				AbilityContext.ResultContext.ArmorMitigation,
				AbilityContext.ResultContext.StatContestResult,
				AbilityTemplate.AbilityTargetEffects, 
				AbilityContext.ResultContext.TargetEffectResults, 
				AbilityTemplate.DataName, 
				TELT_AbilityTargetEffects))

			{
				if (AbilityTemplate.bAllowAmmoEffects && SourceWeapon_NewState != none && SourceWeapon_NewState.HasLoadedAmmo())
				{
					AmmoTemplate = X2AmmoTemplate(SourceWeapon_NewState.GetLoadedAmmoTemplate(ShootAbilityState));
					if (AmmoTemplate != none && AmmoTemplate.TargetEffects.Length > 0)
					{
						ApplyEffectsToTarget(
							AbilityContext, 
							AffectedTargetObject_OriginalState, 
							SourceObject_OriginalState, 
							ShootAbilityState, 
							AffectedTargetObject_NewState, 
							NewGameState, 
							AbilityContext.ResultContext.HitResult,
							AbilityContext.ResultContext.ArmorMitigation,
							AbilityContext.ResultContext.StatContestResult,
							AmmoTemplate.TargetEffects, 
							AbilityContext.ResultContext.TargetEffectResults, 
							AmmoTemplate.DataName,  //Use the ammo template for TELT_AmmoTargetEffects
							TELT_AmmoTargetEffects);
					}
				}
				if (AbilityTemplate.bAllowBonusWeaponEffects && SourceWeapon_NewState != none)
				{
					WeaponTemplate = X2WeaponTemplate(SourceWeapon_NewState.GetMyTemplate());
					if (WeaponTemplate != none && WeaponTemplate.BonusWeaponEffects.Length > 0)
					{
						ApplyEffectsToTarget(
							AbilityContext,
							AffectedTargetObject_OriginalState, 
							SourceObject_OriginalState, 
							ShootAbilityState, 
							AffectedTargetObject_NewState, 
							NewGameState, 
							AbilityContext.ResultContext.HitResult,
							AbilityContext.ResultContext.ArmorMitigation,
							AbilityContext.ResultContext.StatContestResult,
							WeaponTemplate.BonusWeaponEffects, 
							AbilityContext.ResultContext.TargetEffectResults, 
							WeaponTemplate.DataName,
							TELT_WeaponEffects);
					}
				}
			}
		}
			
		NewGameState.AddStateObject(AffectedTargetObject_NewState);

		if (AbilityTemplate.Hostility == eHostility_Offensive && AffectedTargetObject_NewState.CanEarnXp() && XComGameState_Unit(AffectedTargetObject_NewState).IsEnemyUnit(SourceObject_NewState))
		{
			`TRIGGERXP('XpGetShotAt', AffectedTargetObject_NewState.GetReference(), SourceObject_NewState.GetReference(), NewGameState);
		}
	}

	if (AbilityTemplate.bUseLaunchedGrenadeEffects)
	{
		GrenadeTemplate = X2GrenadeTemplate(SourceWeapon.GetLoadedAmmoTemplate(ShootAbilityState));
		MultiTargetLookupType = TELT_LaunchedGrenadeEffects;
	}
	else if (AbilityTemplate.bUseThrownGrenadeEffects)
	{
		GrenadeTemplate = X2GrenadeTemplate(SourceWeapon.GetMyTemplate());
		MultiTargetLookupType = TELT_ThrownGrenadeEffects;
	}
	else
	{
		MultiTargetLookupType = TELT_AbilityMultiTargetEffects;
	}

	//  Apply effects to multi targets
	if( (AbilityTemplate.AbilityMultiTargetEffects.Length > 0 || GrenadeTemplate != none) && AbilityContext.InputContext.MultiTargets.Length > 0)
	{		
		for( TargetIndex = 0; TargetIndex < AbilityContext.InputContext.MultiTargets.Length; ++TargetIndex )
		{
			AffectedTargetObject_OriginalState = History.GetGameStateForObjectID(AbilityContext.InputContext.MultiTargets[TargetIndex].ObjectID, eReturnType_Reference);
			AffectedTargetObject_NewState = NewGameState.CreateStateObject(AffectedTargetObject_OriginalState.Class, AbilityContext.InputContext.MultiTargets[TargetIndex].ObjectID);
			
			MultiTargetEffectResults = EmptyResults;        //  clear struct for use - cannot pass dynamic array element as out parameter
			if (ApplyEffectsToTarget(
				AbilityContext, 
				AffectedTargetObject_OriginalState, 
				SourceObject_OriginalState, 
				ShootAbilityState, 
				AffectedTargetObject_NewState, 
				NewGameState, 
				AbilityContext.ResultContext.MultiTargetHitResults[TargetIndex],
				AbilityContext.ResultContext.MultiTargetArmorMitigation[TargetIndex],
				AbilityContext.ResultContext.MultiTargetStatContestResult[TargetIndex],
				AbilityTemplate.bUseLaunchedGrenadeEffects ? GrenadeTemplate.LaunchedGrenadeEffects : (AbilityTemplate.bUseThrownGrenadeEffects ? GrenadeTemplate.ThrownGrenadeEffects : AbilityTemplate.AbilityMultiTargetEffects), 
				MultiTargetEffectResults, 
				GrenadeTemplate == none ? AbilityTemplate.DataName : GrenadeTemplate.DataName, 
				MultiTargetLookupType ))
			{
				AbilityContext.ResultContext.MultiTargetEffectResults[TargetIndex] = MultiTargetEffectResults;  //  copy results into dynamic array
			}
							
			NewGameState.AddStateObject(AffectedTargetObject_NewState);
		}
	}
	
	//Give all effects a chance to make world modifications ( ie. add new state objects independent of targeting )
	ApplyEffectsToWorld(AbilityContext, SourceObject_OriginalState, ShootAbilityState, NewGameState, AbilityTemplate.AbilityShooterEffects, AbilityTemplate.DataName, TELT_AbilityShooterEffects);
	ApplyEffectsToWorld(AbilityContext, SourceObject_OriginalState, ShootAbilityState, NewGameState, AbilityTemplate.AbilityTargetEffects, AbilityTemplate.DataName, TELT_AbilityTargetEffects);	
	if (GrenadeTemplate != none)
	{
		if (AbilityTemplate.bUseLaunchedGrenadeEffects)
		{
			ApplyEffectsToWorld(AbilityContext, SourceObject_OriginalState, ShootAbilityState, NewGameState, GrenadeTemplate.LaunchedGrenadeEffects, GrenadeTemplate.DataName, TELT_LaunchedGrenadeEffects);
		}
		else if (AbilityTemplate.bUseThrownGrenadeEffects)
		{
			ApplyEffectsToWorld(AbilityContext, SourceObject_OriginalState, ShootAbilityState, NewGameState, GrenadeTemplate.ThrownGrenadeEffects, GrenadeTemplate.DataName, TELT_ThrownGrenadeEffects);
		}
	}
	else
	{
		ApplyEffectsToWorld(AbilityContext, SourceObject_OriginalState, ShootAbilityState, NewGameState, AbilityTemplate.AbilityMultiTargetEffects, AbilityTemplate.DataName, TELT_AbilityMultiTargetEffects);
	}

	//Apply the cost of the ability
	AbilityTemplate.ApplyCost(AbilityContext, ShootAbilityState, SourceObject_NewState, SourceWeapon_NewState, NewGameState);
}

function SecondaryWeaponAbility_BuildVisualization(XComGameState VisualizeGameState, out array<VisualizationTrack> OutVisualizationTracks)
{		
	local X2AbilityTemplate             AbilityTemplate;
	local XComGameStateContext_Ability  Context;
	local AbilityInputContext           AbilityContext;
	local StateObjectReference          ShootingUnitRef;	
	local X2Action                      AddedAction;
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
	local X2Action_PlayAnimation    ResumeAnimation;

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
			class'X2Action_Lucu_Garage_SecondaryWeaponStartFire'.static.AddToVisualizationTrack(SourceTrack, Context);
		}

		// no move, just add the fire action
		AddedAction = AbilityTemplate.ActionFireClass.static.AddToVisualizationTrack(SourceTrack, Context);

		if( AbilityTemplate.AbilityToHitCalc != None )
		{
			X2Action_Fire(AddedAction).SetFireParameters(true);
		}
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
			// Play the animation to get him to his looping idle
			ResumeAnimation = X2Action_PlayAnimation(class'X2Action_PlayAnimation'.static.AddToVisualizationTrack(SourceTrack, Context));
			ResumeAnimation.Params.AnimName = 'NO_WrathCannonStopA';

			//class'X2Action_EnterCover'.static.AddToVisualizationTrack(SourceTrack, Context);
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
