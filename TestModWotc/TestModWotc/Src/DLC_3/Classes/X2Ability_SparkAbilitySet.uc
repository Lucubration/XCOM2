//---------------------------------------------------------------------------------------
//  FILE:    X2Ability_SparkAbilitySet.uc
//  AUTHOR:  Joe Weinhoffer  --  03/06/2014
//  PURPOSE: Defines all Spark Based Class Abilities
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class X2Ability_SparkAbilitySet extends X2Ability
	dependson(XComGameStateContext_Ability) config(GameData_SoldierSkills);

var config int OVERDRIVE_COOLDOWN;
var config int BULWARK_ARMOR;
var config int STRIKE_COOLDOWN;
var config int STRIKE_HITMOD;
var config int REPAIR_CHARGES, REPAIR_HP;
var config float SPARK_DEATH_EXPLOSION_RADIUS_METERS;
var config int SPARK_PSI_EXPLOSION_ENV_DMG;
var config int NOVA_COOLDOWN;
var config float NOVA_RADIUS_METERS;
var config int NOVA_ENV_DMG;
var config int HUNTERPROTOCOL_CHANCE;
var config int SACRIFICE_COOLDOWN;
var config float SACRIFICE_DISTANCE_SQ;
var config int SACRIFICE_DEFENSE;
var config int SACRIFICE_ARMOR;
var config int BOMBARD_CHARGES;
var config int BOMBARD_NUM_COOLDOWN_TURNS;
var config float BOMBARD_DAMAGE_RADIUS_METERS;
var config int BOMBARD_ENV_DMG;
var config float WAIT_SECS_PER_TILE;
var config int RAINMAKER_DMG_ROCKETLAUNCHER;
var config int RAINMAKER_DMG_SHREDDERGUN;
var config int RAINMAKER_DMG_SHREDSTORM;
var config int RAINMAKER_DMG_FLAMETHROWER;
var config int RAINMAKER_DMG_FLAMETHROWER2;
var config int RAINMAKER_DMG_BLASTERLAUNCHER;
var config int RAINMAKER_DMG_PLASMABLASTER;
var config float RAINMAKER_RADIUS_ROCKETLAUNCHER, RAINMAKER_RADIUS_BLASTERLAUNCHER;
var config float RAINMAKER_CONELENGTH_SHREDDERGUN, RAINMAKER_CONEDIAMETER_SHREDDERGUN;
var config float RAINMAKER_CONELENGTH_SHREDSTORM, RAINMAKER_CONEDIAMETER_SHREDSTORM;
var config float RAINMAKER_CONELENGTH_FLAMETHROWER, RAINMAKER_CONEDIAMETER_FLAMETHROWER;
var config float RAINMAKER_CONELENGTH_FLAMETHROWER2, RAINMAKER_CONEDIAMETER_FLAMETHROWER2;
var config int RAINMAKER_WIDTH_PLASMABLASTER;
var config string AbsorptionFieldProjectile;

var privatewrite name SparkSelfDestructEffectName;
var privatewrite name NovaAbilityName;

var const private int BOMBARD_HEIGHT;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem(Rainmaker());
	Templates.AddItem(Overdrive());
	Templates.AddItem(Bulwark());
	Templates.AddItem(AdaptiveAim());
	Templates.AddItem(Arsenal());
	Templates.AddItem(Strike());
	Templates.AddItem(Intimidate());
	Templates.AddItem(IntimidateTrigger());
	Templates.AddItem(WreckingBall());
	Templates.AddItem(Repair());
	Templates.AddItem(Bombard());
	Templates.AddItem(AbsorptionField());
	Templates.AddItem(HunterProtocol());
	Templates.AddItem(HunterProtocolShot());
	Templates.AddItem(HunterProtocolTrigger());
	Templates.AddItem(Sacrifice());
	Templates.AddItem(NovaInit());
	Templates.AddItem(Nova());
	Templates.AddItem(EngageSelfDestruct());
	Templates.AddItem(TriggerSelfDestruct());
	Templates.AddItem(ExplodingSparkInit());
	Templates.AddItem(SparkDeathExplosion());
	Templates.AddItem(ActiveCamo());

	// HeavyWeapon spark abilities to allow the bit to visualize correctly
	Templates.AddItem(SparkRocketLauncher());
	Templates.AddItem(SparkShredderGun());
	Templates.AddItem(SparkShredstormCannon());
	Templates.AddItem(SparkFlamethrower());
	Templates.AddItem(SparkFlamethrowerMk2());
	Templates.AddItem(SparkBlasterLauncher());
	Templates.AddItem(SparkPlasmaBlaster());
	
	return Templates;
}

static function X2AbilityTemplate Rainmaker()
{
	local X2AbilityTemplate             Template;
	local X2Effect_Persistent           PersistentEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Rainmaker');
	Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer);

	Template.IconImage = "img:///UILibrary_DLC3Images.UIPerk_spark_rainmaker";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.bIsPassive = true;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	PersistentEffect = new class'X2Effect_DLC_3Rainmaker';
	PersistentEffect.BuildPersistentEffect(1, true, false);
	PersistentEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.LocLongDescription, Template.IconImage, true, ,Template.AbilitySourceName);
	Template.AddTargetEffect(PersistentEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	// Note: no visualization on purpose!

	return Template;
}

static function X2AbilityTemplate Overdrive()
{
	local X2AbilityTemplate						Template;
	local X2AbilityCooldown                     Cooldown;
	local X2Effect_GrantActionPoints            PointEffect;
	local X2Effect_Persistent			        ActionPointPersistEffect;
	local X2Effect_DLC_3Overdrive               OverdriveEffect;
	local X2Condition_AbilityProperty           AbilityCondition;
	local X2Effect_PersistentTraversalChange    WallbreakEffect;
	local X2Effect_PerkAttachForFX              PerkAttachEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Overdrive');
	Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.OVERDRIVE_COOLDOWN;
	Template.AbilityCooldown = Cooldown;

	Template.AbilityCosts.AddItem(default.FreeActionCost);

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_DLC3Images.UIPerk_spark_overdrive";

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger); 

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	PointEffect = new class'X2Effect_GrantActionPoints';
	PointEffect.NumActionPoints = 1;
	PointEffect.PointType = class'X2CharacterTemplateManager'.default.StandardActionPoint;
	Template.AddTargetEffect(PointEffect);

	// A persistent effect for the effects code to attach a duration to
	ActionPointPersistEffect = new class'X2Effect_Persistent';
	ActionPointPersistEffect.EffectName = 'OverdrivePerk';
	ActionPointPersistEffect.BuildPersistentEffect( 1, false, true, false, eGameRule_PlayerTurnEnd );
	Template.AddTargetEffect(ActionPointPersistEffect);

	OverdriveEffect = new class'X2Effect_DLC_3Overdrive';
	OverdriveEffect.BuildPersistentEffect(1, false, true, false, eGameRule_PlayerTurnBegin);
	OverdriveEffect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, , , Template.AbilitySourceName);
	Template.AddTargetEffect(OverdriveEffect);

	// A persistent effect for the effects code to attach a duration to
	PerkAttachEffect = new class'X2Effect_PerkAttachForFX';
	PerkAttachEffect.EffectName = 'AdaptiveAimPerk';
	PerkAttachEffect.BuildPersistentEffect( 1, false, true, false, eGameRule_PlayerTurnEnd );
	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('AdaptiveAim');
	PerkAttachEffect.TargetConditions.AddItem(AbilityCondition);
	Template.AddTargetEffect(PerkAttachEffect);

	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('WreckingBall');
	WallbreakEffect = new class'X2Effect_PersistentTraversalChange';
	WallbreakEffect.AddTraversalChange(eTraversal_BreakWall, true);
	WallbreakEffect.EffectName = 'WreckingBallTraversal';
	WallbreakEffect.DuplicateResponse = eDupe_Ignore;
	WallbreakEffect.BuildPersistentEffect(1, false, true, false, eGameRule_PlayerTurnEnd);
	WallbreakEffect.TargetConditions.AddItem(AbilityCondition);
	Template.AddTargetEffect(WallbreakEffect);

	Template.CustomFireAnim = 'FF_Overdrive';
	Template.bShowActivation = true;
	Template.bSkipExitCoverWhenFiring = true;

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	Template.PostActivationEvents.AddItem('OverdriveActivated');
	
	return Template;
}

static function X2AbilityTemplate Bulwark()
{
	local X2AbilityTemplate						Template;
	local X2Effect_GenerateCover                CoverEffect;
	local X2Effect_BonusArmor		            ArmorEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Bulwark');
	Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer);

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_DLC3Images.UIPerk_spark_bulwark";

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	CoverEffect = new class'X2Effect_GenerateCover';
	CoverEffect.bRemoveWhenMoved = false;
	CoverEffect.bRemoveOnOtherActivation = false;
	CoverEffect.BuildPersistentEffect(1, true, false, false, eGameRule_PlayerTurnBegin);
	CoverEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, true, , Template.AbilitySourceName);
	CoverEffect.CoverType = CoverForce_High;
	Template.AddTargetEffect(CoverEffect);

	ArmorEffect = new class'X2Effect_BonusArmor';
	ArmorEffect.BuildPersistentEffect(1, true, false, false);
	ArmorEffect.ArmorMitigationAmount = default.BULWARK_ARMOR;
	Template.AddTargetEffect(ArmorEffect);

	Template.bSkipFireAction = true;
	Template.bShowActivation = false;

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	Template.SetUIStatMarkup(class'XLocalizedData'.default.ArmorLabel, eStat_ArmorMitigation, ArmorEffect.ArmorMitigationAmount);

	return Template;
}

static function X2AbilityTemplate AdaptiveAim()
{
	local X2AbilityTemplate						Template;

	Template = PurePassive('AdaptiveAim', "img:///UILibrary_DLC3Images.UIPerk_spark_adaptiveaim", false, 'eAbilitySource_Perk', true);
	Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer);

	return Template;
}

static function X2AbilityTemplate Arsenal()
{
	local X2AbilityTemplate						Template;

	Template = PurePassive('Arsenal', "img:///UILibrary_DLC3Images.UIPerk_spark_arsenal", false, 'eAbilitySource_Perk', true);
	Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer);
	Template.SoldierAbilityPurchasedFn = ArsenalPurchased;

	return Template;
}

function ArsenalPurchased(XComGameState NewGameState, XComGameState_Unit UnitState)
{
	local X2ItemTemplate FreeItem;
	local XComGameState_Item ItemState;

	if (UnitState.IsMPCharacter())
		return;
	
	if (!UnitState.HasHeavyWeapon())
	{
		`RedScreen("ArsenalPurchased called but the unit doesn't have a heavy weapon slot? -jbouscher / @gameplay" @ UnitState.ToString());		
		return;
	}
	FreeItem = class'X2ItemTemplateManager'.static.GetItemTemplateManager().FindItemTemplate(class'X2Item_HeavyWeapons'.default.FreeHeavyWeaponToEquip);
	if (FreeItem == none)
	{
		`RedScreen("Free heavy weapon '" $ class'X2Item_HeavyWeapons'.default.FreeHeavyWeaponToEquip $ "' is not a valid item template.");
		return;
	}
	ItemState = FreeItem.CreateInstanceFromTemplate(NewGameState);
	if (!UnitState.AddItemToInventory(ItemState, eInvSlot_HeavyWeapon, NewGameState))
	{
		`RedScreen("Unable to add free heavy weapon to unit's inventory. Sadness." @ UnitState.ToString());
		return;
	}
}

static function X2AbilityTemplate Strike()
{
	local X2AbilityTemplate					Template;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityToHitCalc_StandardMelee  StandardMelee;
	local X2Effect_DLC_3StrikeDamage        WeaponDamageEffect;
	local array<name>                       SkipExclusions;
	local X2AbilityCooldown                 Cooldown;
	local X2Effect_Knockback				KnockbackEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Strike');
	Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer);

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;		
	Template.IconImage = "img:///UILibrary_DLC3Images.UIPerk_spark_strike";
	Template.bHideOnClassUnlock = false;
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_SERGEANT_PRIORITY;
	Template.AbilityConfirmSound = "TacticalUI_SwordConfirm";
	Template.MeleePuckMeshPath = "Materials_DLC3.MovePuck_Strike";

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.STRIKE_COOLDOWN;
	Template.AbilityCooldown = Cooldown;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.bMoveCost = true;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	StandardMelee = new class'X2AbilityToHitCalc_StandardMelee';
	StandardMelee.BuiltInHitMod = default.STRIKE_HITMOD;
	Template.AbilityToHitCalc = StandardMelee;

	Template.AbilityTargetStyle = new class'X2AbilityTarget_MovingMelee';
	Template.TargetingMethod = class'X2TargetingMethod_MeleePath';

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.AbilityTriggers.AddItem(new class'X2AbilityTrigger_EndOfMove');

	// Target Conditions
	//
	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);
	Template.AbilityTargetConditions.AddItem(default.MeleeVisibilityCondition);

	// Shooter Conditions
	//
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	SkipExclusions.AddItem(class'X2StatusEffects'.default.BurningName);
	Template.AddShooterEffectExclusions(SkipExclusions);

	// Damage Effect
	//
	WeaponDamageEffect = new class'X2Effect_DLC_3StrikeDamage';
	Template.AddTargetEffect(WeaponDamageEffect);

	Template.bAllowBonusWeaponEffects = true;
	Template.bSkipMoveStop = true;
	Template.CustomFireAnim = 'FF_Melee';
	Template.CustomMovingFireAnim = 'MV_Melee';	

	KnockbackEffect = new class'X2Effect_Knockback';
	KnockbackEffect.KnockbackDistance = 2;
	Template.AddTargetEffect(KnockbackEffect);
	Template.bOverrideMeleeDeath = true;

	// Voice events
	//
	Template.SourceMissSpeech = 'SwordMiss';

	Template.BuildNewGameStateFn = TypicalMoveEndAbility_BuildGameState;
	Template.BuildInterruptGameStateFn = TypicalMoveEndAbility_BuildInterruptGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.CinescriptCameraType = "Spark_Strike";

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.MeleeLostSpawnIncreasePerUse;
//BEGIN AUTOGENERATED CODE: Template Overrides 'Strike'
	Template.bFrameEvenWhenUnitIsHidden = true;
//END AUTOGENERATED CODE: Template Overrides 'Strike'

	return Template;
}

static function X2AbilityTemplate Intimidate()
{
	local X2AbilityTemplate						Template;
	local X2Effect_CoveringFire                 CoveringEffect;

	Template = PurePassive('Intimidate', "img:///UILibrary_DLC3Images.UIPerk_spark_intimidate", false, 'eAbilitySource_Perk', true);
	Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer);

	CoveringEffect = new class'X2Effect_CoveringFire';
	CoveringEffect.BuildPersistentEffect(1, true, false, false);
	CoveringEffect.AbilityToActivate = 'IntimidateTrigger';
	CoveringEffect.GrantActionPoint = 'intimidate';
	CoveringEffect.bPreEmptiveFire = false;
	CoveringEffect.bDirectAttackOnly = true;
	CoveringEffect.bOnlyDuringEnemyTurn = true;
	CoveringEffect.bUseMultiTargets = false;
	CoveringEffect.EffectName = 'IntimidateWatchEffect';
	Template.AddTargetEffect(CoveringEffect);

	Template.AdditionalAbilities.AddItem('IntimidateTrigger');

	return Template;
}

static function X2AbilityTemplate IntimidateTrigger()
{
	local X2AbilityTemplate						Template;
	local X2Effect_Panicked						PanicEffect;
	local X2AbilityCost_ReserveActionPoints     ActionPointCost;
	local X2Condition_UnitEffects               UnitEffects;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'IntimidateTrigger');
	Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer);

	Template.IconImage = "img:///UILibrary_DLC3Images.UIPerk_spark_intimidate";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Offensive;

	ActionPointCost = new class'X2AbilityCost_ReserveActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.AllowedTypes.Length = 0;
	ActionPointCost.AllowedTypes.AddItem('intimidate');
	Template.AbilityCosts.AddItem(ActionPointCost);

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	UnitEffects = new class'X2Condition_UnitEffects';
	UnitEffects.AddExcludeEffect(class'X2AbilityTemplateManager'.default.StunnedName, 'AA_UnitIsStunned');
	Template.AbilityShooterConditions.AddItem(UnitEffects);

	Template.AbilityToHitCalc = default.DeadEye;                //  the real roll is in the effect apply chance
	Template.AbilityTargetStyle = default.SelfTarget;

	Template.AbilityTriggers.AddItem(new class'X2AbilityTrigger_Placeholder');

	Template.AbilityTargetConditions.AddItem(default.LivingHostileUnitDisallowMindControlProperty);

	PanicEffect = class'X2StatusEffects'.static.CreatePanickedStatusEffect();
	PanicEffect.ApplyChanceFn = IntimidationApplyChance;
	PanicEffect.VisualizationFn = Intimidate_Visualization;
	Template.AddTargetEffect(PanicEffect);

	Template.CustomFireAnim = 'NO_Intimidate';
	Template.bShowActivation = true;
	Template.CinescriptCameraType = "Spark_Intimidate";

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

//BEGIN AUTOGENERATED CODE: Template Overrides 'IntimidateTrigger'
	Template.bFrameEvenWhenUnitIsHidden = true;
//END AUTOGENERATED CODE: Template Overrides 'IntimidateTrigger'

	return Template;
}

function name IntimidationApplyChance(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState)
{
	//  this mimics the panic hit roll without actually BEING the panic hit roll
	local XComGameState_Unit TargetUnit, SourceUnit;
	local name ImmuneName;
	local int AttackVal, DefendVal, TargetRoll, RandRoll;
	local X2SparkArmorTemplate_DLC_3 SparkArmorTemplate;
	local XComGameState_Item ArmorState;

	SourceUnit = XComGameState_Unit(NewGameState.GetGameStateForObjectID(ApplyEffectParameters.SourceStateObjectRef.ObjectID));
	if (SourceUnit == none)
		SourceUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(ApplyEffectParameters.SourceStateObjectRef.ObjectID));
	if (SourceUnit != none)
	{
		ArmorState = SourceUnit.GetItemInSlot(eInvSlot_Armor, NewGameState);
		`assert(ArmorState != none);
		SparkArmorTemplate = X2SparkArmorTemplate_DLC_3(ArmorState.GetMyTemplate());
	}

	TargetUnit = XComGameState_Unit(kNewTargetState);
	if (TargetUnit != none && SparkArmorTemplate != none)
	{
		foreach class'X2AbilityToHitCalc_PanicCheck'.default.PanicImmunityAbilities(ImmuneName)
		{
			if (TargetUnit.FindAbility(ImmuneName).ObjectID != 0)
			{
				return 'AA_UnitIsImmune';
			}
		}
		AttackVal = SparkArmorTemplate.IntimidateStrength;
		DefendVal = TargetUnit.GetCurrentStat(eStat_Will);
		TargetRoll = class'X2AbilityToHitCalc_PanicCheck'.default.BaseValue + AttackVal - DefendVal;
		RandRoll = `SYNC_RAND(100);
		if (RandRoll < TargetRoll)
			return 'AA_Success';
	}

	return 'AA_EffectChanceFailed';
}

static function Intimidate_Visualization(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, const name EffectApplyResult)
{
	local XComGameState_Unit UnitState;
	local XComGameStateContext_Ability Context;
	local X2AbilityTemplate	AbilityTemplate;

	if( EffectApplyResult != 'AA_Success' )
	{
		// pan to the not panicking unit (but only if it isn't a civilian)
		Context = XComGameStateContext_Ability(VisualizeGameState.GetContext());
		UnitState = XComGameState_Unit(ActionMetadata.StateObject_NewState);
		if( (UnitState == none) || (Context == none) )
		{
			return;
		}

		AbilityTemplate = class'XComGameState_Ability'.static.GetMyTemplateManager().FindAbilityTemplate(Context.InputContext.AbilityTemplateName);

		class'X2StatusEffects'.static.AddEffectCameraPanToAffectedUnitToTrack(ActionMetadata, VisualizeGameState.GetContext());
		class'X2StatusEffects'.static.AddEffectSoundAndFlyOverToTrack(ActionMetadata, VisualizeGameState.GetContext(), AbilityTemplate.LocMissMessage, '' , eColor_Good, class'UIUtilities_Image'.const.UnitStatus_Panicked);
	}
}

static function X2AbilityTemplate WreckingBall()
{
	local X2AbilityTemplate						Template;

	Template = PurePassive('WreckingBall', "img:///UILibrary_DLC3Images.UIPerk_spark_wreckingball", false, 'eAbilitySource_Perk', true);
	Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer);

	return Template;
}

static function X2AbilityTemplate Repair()
{
	local X2AbilityTemplate						Template;
	local X2AbilityCharges                      Charges;
	local X2AbilityCost_Charges                 ChargeCost;
	local X2AbilityCost_ActionPoints            ActionPointCost;
	local X2Effect_ApplyMedikitHeal             HealEffect;
	local X2Condition_UnitProperty              UnitCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Repair');
	Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer);

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_DLC3Images.UIPerk_spark_repair";

	Charges = new class'X2AbilityCharges';
	Charges.InitialCharges = default.REPAIR_CHARGES;
	Template.AbilityCharges = Charges;

	ChargeCost = new class'X2AbilityCost_Charges';
	ChargeCost.NumCharges = 1;
	Template.AbilityCosts.AddItem(ChargeCost);

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	Template.AbilityCosts.AddItem(ActionPointCost);

	HealEffect = new class'X2Effect_ApplyMedikitHeal';
	HealEffect.PerUseHP = default.REPAIR_HP;
	Template.AddTargetEffect(HealEffect);

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	UnitCondition = new class'X2Condition_UnitProperty';
	UnitCondition.ExcludeDead = true;
	UnitCondition.ExcludeHostileToSource = true;
	UnitCondition.ExcludeFriendlyToSource = false;
	UnitCondition.ExcludeFullHealth = true;
	UnitCondition.ExcludeOrganic = true;
	Template.AbilityTargetConditions.AddItem(UnitCondition);

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SingleTargetWithSelf;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	Template.bStationaryWeapon = true;
	Template.PostActivationEvents.AddItem('ItemRecalled');
	Template.CustomSelfFireAnim = 'NO_Repair';
	Template.bSkipPerkActivationActions = true;

	Template.BuildNewGameStateFn = class'X2Ability_SpecialistAbilitySet'.static.AttachGremlinToTarget_BuildGameState;
	Template.BuildVisualizationFn = class'X2Ability_SpecialistAbilitySet'.static.GremlinSingleTarget_BuildVisualization;
	
	Template.CinescriptCameraType = "Spark_SendBit";

	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.NonAggressiveChosenActivationIncreasePerUse;
	
	return Template;
}

static function X2AbilityTemplate Bombard()
{
	local X2AbilityTemplate             Template;
	local X2AbilityTarget_Cursor        CursorTarget;
	local X2AbilityMultiTarget_Radius   RadiusMultiTarget;
	local X2AbilityCost_Charges         ChargeCost;
	local X2AbilityCharges              Charges;
	local X2AbilityCooldown             Cooldown;
	local X2Effect_ApplyWeaponDamage    DamageEffect;
	local X2Effect_PerkAttachForFX      PerkEffect;
	local X2AbilityCost_ActionPoints    ActionPointCost;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Bombard');
	Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer);

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;
	Template.IconImage = "img:///UILibrary_DLC3Images.UIPerk_spark_bombard";

	Template.AbilityCosts.AddItem(default.FreeActionCost);

	ChargeCost = new class'X2AbilityCost_Charges';
	ChargeCost.NumCharges = 1;
	Template.AbilityCosts.AddItem(ChargeCost);

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Charges = new class'X2AbilityCharges';
	Charges.InitialCharges = default.BOMBARD_CHARGES;
	Template.AbilityCharges = Charges;
	
	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.BOMBARD_NUM_COOLDOWN_TURNS;
	Template.AbilityCooldown = Cooldown;

	Template.TargetingMethod = class'X2TargetingMethod_VoidRift';

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.AbilityToHitCalc = default.DeadEye;

	CursorTarget = new class'X2AbilityTarget_Cursor';
	CursorTarget.bRestrictToSquadsightRange = true;
	Template.AbilityTargetStyle = CursorTarget;

	RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
	RadiusMultiTarget.fTargetRadius = default.BOMBARD_DAMAGE_RADIUS_METERS;
	RadiusMultiTarget.bIgnoreBlockingCover = true;
	Template.AbilityMultiTargetStyle = RadiusMultiTarget;

	// Shooter Conditions
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	PerkEffect = new class'X2Effect_PerkAttachForFX';
	PerkEffect.EffectAddedFn = Bombard_EffectAdded;
	Template.AddShooterEffect(PerkEffect);

	Template.AbilityMultiTargetConditions.AddItem(default.LivingTargetOnlyProperty);

	// Everything in the blast radius receives physical damage
	DamageEffect = new class'X2Effect_ApplyWeaponDamage';
	DamageEffect.bIgnoreBaseDamage = true;
	DamageEffect.DamageTag = 'Bombard';
	DamageEffect.EnvironmentalDamageAmount = default.BOMBARD_ENV_DMG;
	Template.AddMultiTargetEffect(DamageEffect);

	Template.PostActivationEvents.AddItem('ItemRecalled');

	Template.BuildNewGameStateFn = class'X2Ability_SpecialistAbilitySet'.static.SendGremlinToLocation_BuildGameState;//TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = Bombard_BuildVisualization;

	Template.CinescriptCameraType = "Spark_Bombard";

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.GrenadeLostSpawnIncreasePerUse;
	Template.bFrameEvenWhenUnitIsHidden = true;

	return Template;
}

static function Bombard_EffectAdded(X2Effect_Persistent PersistentEffect, const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState)
{
	local XComGameState_Unit UnitState;
	local TTile Tile, StartTileLocation, EndTileLocation;
	local XComGameState_EnvironmentDamage WorldDamage;
	local XComWorldData World;
	local vector StartLoc;
	local array<TTile> StartTileLocations, EndTileLocations;
	local int i;

	World = `XWORLD;

	UnitState = XComGameState_Unit(kNewTargetState);
	`assert(UnitState != none);

	// Need to find an open tile in the sky
	// solve the path to get him to the fire location
	StartTileLocations.AddItem(UnitState.TileLocation);
	
	EndTileLocation = UnitState.TileLocation;
	EndTileLocation.Z = World.NumZ;
	EndTileLocations.AddItem(EndTileLocation);

	// Damage to floors for the downward flight
	if( ApplyEffectParameters.AbilityInputContext.TargetLocations.Length == 0 )
	{
		return;
	}

	StartLoc = ApplyEffectParameters.AbilityInputContext.TargetLocations[0];
	StartTileLocation = World.GetTileCoordinatesFromPosition(StartLoc);
	StartTileLocations.AddItem(StartTileLocation);
	
	EndTileLocation = StartTileLocation;
	EndTileLocation.Z = World.NumZ;
	EndTileLocations.AddItem(EndTileLocation);

	for( i = 0; i < StartTileLocations.Length; ++i )
	{
		Tile = StartTileLocations[i];
		while(Tile != EndTileLocations[i])
		{
			++Tile.Z;

			WorldDamage = XComGameState_EnvironmentDamage(NewGameState.CreateNewStateObject(class'XComGameState_EnvironmentDamage'));

			WorldDamage.DamageTypeTemplateName = 'NoFireExplosion';
			WorldDamage.DamageCause = UnitState.GetReference();
			WorldDamage.DamageSource = WorldDamage.DamageCause;
			WorldDamage.bRadialDamage = false;
			WorldDamage.HitLocationTile = Tile;
			WorldDamage.DamageTiles.AddItem(WorldDamage.HitLocationTile);

			WorldDamage.DamageDirection.X = 0.0f;
			WorldDamage.DamageDirection.Y = 0.0f;
			WorldDamage.DamageDirection.Z = -1.0f;

			WorldDamage.DamageAmount = 30;
			WorldDamage.PhysImpulse = 10;
		}
	}
}

static simulated function Bombard_BuildVisualization(XComGameState VisualizeGameState)
{
	local XComGameStateHistory History;
	local XComGameStateContext_Ability Context;
	local StateObjectReference InteractingUnitRef;
	local XComGameState_Item BitItem;
	local XComGameState_Unit BitUnitState;
	local VisualizationActionMetadata EmptyTrack;
	local VisualizationActionMetadata ActionMetadata;	
	local X2Action_PlayAnimation PlayAnimation;
	local X2VisualizerInterface TargetVisualizerInterface;
	local int i, j;
	local XComGameState_EnvironmentDamage DamageEventStateObject;
	local X2Action_DLC_3_BitBombard BitBombardAction;
	local XComGameState_Unit SparkUnitState;
	local X2Action_MoveTurn MoveTurnAction;
	local XComGameStateVisualizationMgr VisMgr;
	local X2Action_MarkerNamed JoinActions;
	local Array<X2Action> FoundActions;

	History = `XCOMHISTORY;
	VisMgr = `XCOMVISUALIZATIONMGR;

	Context = XComGameStateContext_Ability(VisualizeGameState.GetContext());

	BitItem = XComGameState_Item(History.GetGameStateForObjectID( Context.InputContext.ItemObject.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1));
	BitUnitState = XComGameState_Unit(History.GetGameStateForObjectID( BitItem.CosmeticUnitRef.ObjectID));

	if( BitUnitState == none )
	{
		`RedScreen("Attempting Bombard_BuildVisualization with a BitUnitState of none");
		return;
	}
	
	//Configure the visualization track for the shooter
	//****************************************************************************************

	//****************************************************************************************
	InteractingUnitRef = Context.InputContext.SourceObject;
	ActionMetadata = EmptyTrack;
	ActionMetadata.StateObject_OldState = History.GetGameStateForObjectID(InteractingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
	ActionMetadata.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(InteractingUnitRef.ObjectID);
	ActionMetadata.VisualizeActor = History.GetVisualizer(InteractingUnitRef.ObjectID);

	SparkUnitState = XComGameState_Unit(ActionMetadata.StateObject_NewState);

	// Turn to face the target action. The target location is the center of the ability's radius, stored in the 0 index of the TargetLocations
	MoveTurnAction = X2Action_MoveTurn(class'X2Action_MoveTurn'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded));
	MoveTurnAction.m_vFacePoint = Context.InputContext.TargetLocations[0];

	PlayAnimation = X2Action_PlayAnimation(class'X2Action_PlayAnimation'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded));
	PlayAnimation.Params.AnimName = 'FF_Bombard';

	//Configure the visualization track for the Bit
	//****************************************************************************************

	InteractingUnitRef = BitUnitState.GetReference();

	ActionMetadata = EmptyTrack;
	History.GetCurrentAndPreviousGameStatesForObjectID(BitUnitState.ObjectID, ActionMetadata.StateObject_OldState, ActionMetadata.StateObject_NewState, , VisualizeGameState.HistoryIndex);
	ActionMetadata.VisualizeActor = BitUnitState.GetVisualizer();

	// Jwats: Start at the same time as the Spark's PlayAnimation
	BitBombardAction = X2Action_DLC_3_BitBombard(class'X2Action_DLC_3_BitBombard'.static.AddToVisualizationTree(ActionMetadata, Context, false, MoveTurnAction));
	BitBombardAction.OwnerUnitState = SparkUnitState;
	BitBombardAction.WaitSecsPerTile = default.WAIT_SECS_PER_TILE;

	//****************************************************************************************

	//****************************************************************************************
	//Configure the visualization track for the targets
	//****************************************************************************************
	for( i = 0; i < Context.InputContext.MultiTargets.Length; ++i )
	{
		InteractingUnitRef = Context.InputContext.MultiTargets[i];
		ActionMetadata = EmptyTrack;
		ActionMetadata.StateObject_OldState = History.GetGameStateForObjectID(InteractingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
		ActionMetadata.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(InteractingUnitRef.ObjectID);
		ActionMetadata.VisualizeActor = History.GetVisualizer(InteractingUnitRef.ObjectID);

		ActionMetadata.LastActionAdded = BitBombardAction; //We want these applied effects to trigger off of the bombard action
		for( j = 0; j < Context.ResultContext.MultiTargetEffectResults[i].Effects.Length; ++j )
		{
			Context.ResultContext.MultiTargetEffectResults[i].Effects[j].AddX2ActionsForVisualization(VisualizeGameState, ActionMetadata, Context.ResultContext.MultiTargetEffectResults[i].ApplyResults[j]);
		}

		TargetVisualizerInterface = X2VisualizerInterface(ActionMetadata.VisualizeActor);
		if( TargetVisualizerInterface != none )
		{
			//Allow the visualizer to do any custom processing based on the new game state. For example, units will create a death action when they reach 0 HP.
			TargetVisualizerInterface.BuildAbilityEffectsVisualization(VisualizeGameState, ActionMetadata);
		}
	}
	//****************************************************************************************

	//****************************************************************************************
	//Configure the visualization track for the targets
	//****************************************************************************************
	// add visualization of environment damage
	foreach VisualizeGameState.IterateByClassType( class'XComGameState_EnvironmentDamage', DamageEventStateObject )
	{
		ActionMetadata = EmptyTrack;
		ActionMetadata.StateObject_OldState = DamageEventStateObject;
		ActionMetadata.StateObject_NewState = DamageEventStateObject;
		ActionMetadata.VisualizeActor = `XCOMHISTORY.GetVisualizer(DamageEventStateObject.ObjectID);
		class'X2Action_ApplyWeaponDamageToTerrain'.static.AddToVisualizationTree(ActionMetadata, Context, false, BitBombardAction);
	}
	//****************************************************************************************

	// Jwats: Reparent all the apply weapon damage actions to the bit bombard action. Auto placement wouldn't have placed them correctly.
	VisMgr.GetNodesOfType(VisMgr.BuildVisTree, class'X2Action_ApplyWeaponDamageToUnit', FoundActions);
	for( i = 0; i < FoundActions.Length; ++i )
	{
		VisMgr.DisconnectAction(FoundActions[i]);
		VisMgr.ConnectAction(FoundActions[i], VisMgr.BuildVisTree, false, BitBombardAction);
	}

	VisMgr.GetAllLeafNodes(VisMgr.BuildVisTree, FoundActions);

	if( VisMgr.BuildVisTree.ChildActions.Length > 0 )
	{
		JoinActions = X2Action_MarkerNamed(class'X2Action_MarkerNamed'.static.AddToVisualizationTree(ActionMetadata, Context, false, none, FoundActions));
		JoinActions.SetName("Join");
	}
}

static function X2AbilityTemplate AbsorptionField()
{
	local X2AbilityTemplate						Template;
	local X2Effect_DLC_3AbsorptionField         FieldEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'AbsorptionField');
	Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer);

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_DLC3Images.UIPerk_spark_absorptionfield";

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	FieldEffect = new class 'X2Effect_DLC_3AbsorptionField';
	FieldEffect.BuildPersistentEffect(1, true, false);
	FieldEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, true, , Template.AbilitySourceName);
	Template.AddTargetEffect(FieldEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: no visualization on purpose!

	return Template;
}

static function X2AbilityTemplate HunterProtocol()
{
	local X2AbilityTemplate						Template;

	Template = PurePassive('HunterProtocol', "img:///UILibrary_DLC3Images.UIPerk_spark_hunterprotocol", false, 'eAbilitySource_Perk', true);
	Template.AdditionalAbilities.AddItem('HunterProtocolShot');
	Template.AdditionalAbilities.AddItem('HunterProtocolTrigger');

	return Template;
}

static function X2AbilityTemplate HunterProtocolTrigger()
{
	local X2AbilityTemplate                 Template;	
	local X2AbilityToHitCalc_PercentChance  PercentChance;
	local X2AbilityTarget_Single            SingleTarget;
	local X2AbilityTrigger_EventListener	Trigger;
	local X2Condition_Visibility			TargetVisibilityCondition;
	local X2Condition_UnitProperty          TargetCondition;
	local array<name>                       SkipExclusions;
	local X2Condition_UnitEffectsWithAbilitySource  EffectCondition;
	local X2Effect_Persistent               TargetEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'HunterProtocolTrigger');
	Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer);

	TargetCondition = new class'X2Condition_UnitProperty';
	TargetCondition.ExcludeAlive=false;
	TargetCondition.ExcludeDead=true;
	TargetCondition.ExcludeFriendlyToSource=true;
	TargetCondition.ExcludeHostileToSource=false;
	TargetCondition.TreatMindControlledSquadmateAsHostile=false;
	TargetCondition.FailOnNonUnits=true;
	TargetCondition.IsScampering=true;
	Template.AbilityTargetConditions.AddItem(TargetCondition);
	
	TargetVisibilityCondition = new class'X2Condition_Visibility';
	TargetVisibilityCondition.bRequireGameplayVisible = true;
	TargetVisibilityCondition.bRequireBasicVisibility = true;
	TargetVisibilityCondition.bDisablePeeksOnMovement = true; //Don't use peek tiles for over watch shots	
	Template.AbilityTargetConditions.AddItem(TargetVisibilityCondition);

	Template.AbilityTargetConditions.AddItem(new class'X2Condition_EverVigilant');
	Template.AbilityTargetConditions.AddItem(class'X2Ability_DefaultAbilitySet'.static.OverwatchTargetEffectsCondition());

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);	

	PercentChance = new class'X2AbilityToHitCalc_PercentChance';
	PercentChance.PercentToHit = default.HUNTERPROTOCOL_CHANCE;
	Template.AbilityToHitCalc = PercentChance;

	SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
	Template.AddShooterEffectExclusions(SkipExclusions);

	//  Do not shoot targets that were already hit by this unit this turn with this ability
	EffectCondition = new class'X2Condition_UnitEffectsWithAbilitySource';
	EffectCondition.AddExcludeEffect('HunterProtocolTarget', 'AA_UnitIsImmune');
	Template.AbilityTargetConditions.AddItem(EffectCondition);
	//  Mark the target as rolled against already so it cannot be targeted again
	TargetEffect = new class'X2Effect_Persistent';
	TargetEffect.EffectName = 'HunterProtocolTarget';
	TargetEffect.BuildPersistentEffect(1, false, false, false, eGameRule_PlayerTurnBegin);
	//  mark them regardless of taking the shot or not (otherwise each tile would trigger a chance to hit)
	TargetEffect.SetupEffectOnShotContextResult(true, true);      
	Template.AddTargetEffect(TargetEffect);
	
	SingleTarget = new class'X2AbilityTarget_Single';
	SingleTarget.OnlyIncludeTargetsInsideWeaponRange = true;
	Template.AbilityTargetStyle = SingleTarget;

	//Trigger on movement - interrupt the move
	Trigger = new class'X2AbilityTrigger_EventListener';
	Trigger.ListenerData.EventID = 'ObjectMoved';
	Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
	Trigger.ListenerData.Filter = eFilter_None;
	Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.TypicalOverwatchListener;
	Template.AbilityTriggers.AddItem(Trigger);
	
	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.IconImage = "img:///UILibrary_DLC3Images.UIPerk_spark_hunterprotocol";
	Template.bDisplayInUITooltip = false;
	Template.bDisplayInUITacticalText = false;
	Template.DisplayTargetHitChance = false;

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = none;       //  NOTE: no visualization on purpose!

//BEGIN AUTOGENERATED CODE: Template Overrides 'HunterProtocolTrigger'
	Template.bFrameEvenWhenUnitIsHidden = true;
//END AUTOGENERATED CODE: Template Overrides 'HunterProtocolTrigger'

	Template.PostActivationEvents.AddItem('HunterProtocolActivated');
		
	return Template;	
}

static function X2AbilityTemplate HunterProtocolShot()
{
	local X2AbilityTemplate                 Template;	
	local X2AbilityCost_Ammo                AmmoCost;
	local X2AbilityToHitCalc_StandardAim    StandardAim;
	local X2AbilityTarget_Single            SingleTarget;
	local X2AbilityTrigger_EventListener    EventTrigger;
	local X2Effect_Knockback				KnockbackEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'HunterProtocolShot');
	Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer);

	Template.bDontDisplayInAbilitySummary = true;
	AmmoCost = new class'X2AbilityCost_Ammo';
	AmmoCost.iAmmo = 1;	
	Template.AbilityCosts.AddItem(AmmoCost);
	
	StandardAim = new class'X2AbilityToHitCalc_StandardAim';
	StandardAim.bReactionFire = true;
	Template.AbilityToHitCalc = StandardAim;
	Template.AbilityToHitOwnerOnMissCalc = StandardAim;

	//  in theory we don't need any conditions because HunterProtocolTrigger already validated, but just in case...
	Template.AbilityTargetConditions.AddItem(default.LivingHostileUnitDisallowMindControlProperty);
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);	
	
	SingleTarget = new class'X2AbilityTarget_Single';
	SingleTarget.OnlyIncludeTargetsInsideWeaponRange = true;
	Template.AbilityTargetStyle = SingleTarget;

	EventTrigger = new class'X2AbilityTrigger_EventListener';
	EventTrigger.ListenerData.Deferral = ELD_OnStateSubmitted;
	EventTrigger.ListenerData.EventID = 'HunterProtocolActivated';
	EventTrigger.ListenerData.EventFn = class'XComGameState_Ability'.static.ChainShotListener; //  activates against the event's context's primary target if the roll succeeded
	EventTrigger.ListenerData.Filter = eFilter_Unit;
	Template.AbilityTriggers.AddItem(EventTrigger);
	
	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.IconImage = "img:///UILibrary_DLC3Images.UIPerk_spark_hunterprotocol";
	Template.bDisplayInUITooltip = false;
	Template.bDisplayInUITacticalText = false;
	Template.DisplayTargetHitChance = false;

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = OverwatchShot_BuildVisualization;
	Template.bAllowFreeFireWeaponUpgrade = false;	
	Template.bAllowAmmoEffects = true;
	Template.AssociatedPassives.AddItem('HoloTargeting');

	//  Put holo target effect first because if the target dies from this shot, it will be too late to notify the effect.
	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());
	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.ShredderDamageEffect());
	Template.bAllowBonusWeaponEffects = true;

	// Damage Effect
	//
	Template.AddTargetEffect(default.WeaponUpgradeMissDamage);

	KnockbackEffect = new class'X2Effect_Knockback';
	KnockbackEffect.KnockbackDistance = 2;
	Template.AddTargetEffect(KnockbackEffect);

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;
	
//BEGIN AUTOGENERATED CODE: Template Overrides 'HunterProtocolShot'	
	Template.bFrameEvenWhenUnitIsHidden = true;	
//END AUTOGENERATED CODE: Template Overrides 'HunterProtocolShot'

	return Template;	
}

static function X2AbilityTemplate Sacrifice()
{
	local X2AbilityTemplate						Template;
	local X2AbilityCooldown                     Cooldown;
	local X2AbilityCost_ActionPoints            ActionPointCost;
	local X2Effect_DLC_3SacrificeShield         ShieldEffect;
	local X2Effect_PersistentStatChange         StatChange;
	local X2Effect_BonusArmor                   ArmorEffect;
	local X2AbilityMultiTarget_AllAllies        AllAlliesMultiTarget;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Sacrifice');
	Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer);

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_DLC3Images.UIPerk_spark_sacrifice";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = new class'X2AbilityTarget_Cursor';
	Template.TargetingMethod = class'X2TargetingMethod_DLC_3_SparkSacrifice';

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	AllAlliesMultiTarget = new class'X2AbilityMultiTarget_AllAllies';
	AllAlliesMultiTarget.bUseAbilitySourceAsPrimaryTarget = true;
	Template.AbilityMultiTargetStyle  = AllAlliesMultiTarget;

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.SACRIFICE_COOLDOWN;
	Template.AbilityCooldown = Cooldown;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	ShieldEffect = new class'X2Effect_DLC_3SacrificeShield';
	ShieldEffect.BuildPersistentEffect(1, false, true, false, eGameRule_PlayerTurnBegin);
	ShieldEffect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage);
	Template.AddMultiTargetEffect(ShieldEffect);

	StatChange = new class'X2Effect_PersistentStatChange';
	StatChange.EffectName = 'SacrificeStats';
	StatChange.AddPersistentStatChange(eStat_Defense, default.SACRIFICE_DEFENSE);
	StatChange.BuildPersistentEffect(1, false, true, false, eGameRule_PlayerTurnBegin);
	StatChange.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage);
	Template.AddShooterEffect(StatChange);

	ArmorEffect = new class'X2Effect_BonusArmor';
	ArmorEffect.EffectName = 'SacrificeArmor';
	ArmorEffect.ArmorMitigationAmount = default.SACRIFICE_ARMOR;
	ArmorEffect.BuildPersistentEffect(1, false, true, false, eGameRule_PlayerTurnBegin);
	//  do not enable display info as the stat effect will cover the display
	Template.AddShooterEffect(ArmorEffect);

	Template.CustomFireAnim = 'FF_Sacrifice';
	Template.BuildNewGameStateFn = TypicalMoveEndAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.BuildInterruptGameStateFn = TypicalMoveEndAbility_BuildInterruptGameState;

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;

	return Template;
}

static function X2AbilityTemplate NovaInit()
{
	local X2AbilityTemplate						Template;
	local X2Effect_DLC_3_Nova                   NovaEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'NovaInit');
	Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer);

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_DLC3Images.UIPerk_spark_nova";

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	// Attach the Nova Effect so damage can scale
	NovaEffect = new class'X2Effect_DLC_3_Nova';
	NovaEffect.DuplicateResponse = eDupe_Ignore;
	Template.AddShooterEffect(NovaEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	
	return Template;
}

static function X2AbilityTemplate Nova()
{
	local X2AbilityTemplate						Template;
	local X2AbilityCooldown                     Cooldown;
	local X2Effect_IncrementUnitValue           SetUnitValueEffect;
	local X2AbilityMultiTarget_Radius           MultiTargetRadius;
	local X2Effect_ApplyWeaponDamage            DamageEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, default.NovaAbilityName);
	Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer);

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.Hostility = eHostility_Offensive;
	Template.IconImage = "img:///UILibrary_DLC3Images.UIPerk_spark_nova";

	Template.AbilityCosts.AddItem(default.FreeActionCost);

	Template.AdditionalAbilities.AddItem('NovaInit');

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.NOVA_COOLDOWN;
	Template.AbilityCooldown = Cooldown;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.TargetingMethod = class'X2TargetingMethod_Nova';

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	SetUnitValueEffect = new class'X2Effect_IncrementUnitValue';
	SetUnitValueEffect.UnitName = 'NovaUsedAmount';
	SetUnitValueEffect.NewValueToSet = 1;
	SetUnitValueEffect.CleanupType = eCleanup_BeginTactical;
	Template.AddTargetEffect(SetUnitValueEffect);

	// Deals damage to itself
	DamageEffect = new class'X2Effect_ApplyWeaponDamage';
	DamageEffect.EffectDamageValue = class'X2Item_DLC_Day90Weapons'.default.SPARK_NOVA_SELF_BASEDAMAGE;
	DamageEffect.bIgnoreArmor = true;
	DamageEffect.bIgnoreBaseDamage = true;
	Template.AddShooterEffect(DamageEffect);

	// Target everything in this blast radius
	MultiTargetRadius = new class'X2AbilityMultiTarget_Radius';
	MultiTargetRadius.fTargetRadius = default.NOVA_RADIUS_METERS;
	Template.AbilityMultiTargetStyle = MultiTargetRadius;

	Template.AbilityMultiTargetConditions.AddItem(default.LivingTargetOnlyProperty);

	// Everything in the blast radius receives physical damage
	DamageEffect = new class'X2Effect_ApplyWeaponDamage';
	DamageEffect.EffectDamageValue = class'X2Item_DLC_Day90Weapons'.default.SPARK_NOVA_MULTITARGET_BASEDAMAGE;
	DamageEffect.bIgnoreArmor = true;
	DamageEffect.bIgnoreBaseDamage = true;
	DamageEffect.EnvironmentalDamageAmount = default.NOVA_ENV_DMG;
	Template.AddMultiTargetEffect(DamageEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = Nova_BuildVisualization;
	
	Template.bSkipExitCoverWhenFiring = true;
	Template.CustomFireAnim = 'FF_Nova';
	Template.DamagePreviewFn = NovaDamagePreview;

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
//BEGIN AUTOGENERATED CODE: Template Overrides 'Nova'
	Template.bFrameEvenWhenUnitIsHidden = true;
//END AUTOGENERATED CODE: Template Overrides 'Nova'

	return Template;
}

function bool NovaDamagePreview(XComGameState_Ability AbilityState, StateObjectReference TargetRef, out WeaponDamageValue MinDamagePreview, out WeaponDamageValue MaxDamagePreview, out int AllowsShield)
{
	local XComGameState_Unit AbilityOwner;
	local UnitValue NovaUses;

	if (TargetRef.ObjectID == AbilityState.OwnerStateObject.ObjectID)
		MinDamagePreview = class'X2Item_DLC_Day90Weapons'.default.SPARK_NOVA_SELF_BASEDAMAGE;
	else
		MinDamagePreview = class'X2Item_DLC_Day90Weapons'.default.SPARK_NOVA_MULTITARGET_BASEDAMAGE;

	AbilityOwner = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(AbilityState.OwnerStateObject.ObjectID));

	if (AbilityOwner != none)
	{
		if (AbilityOwner.GetUnitValue('NovaUsedAmount', NovaUses))
		{
			if (TargetRef.ObjectID == AbilityOwner.ObjectID)
			{
				MinDamagePreview.Damage += class'X2Effect_DLC_3_Nova'.default.SourcePerTickIncrease * NovaUses.fValue;
			}
			else
			{
				MinDamagePreview.Damage += class'X2Effect_DLC_3_Nova'.default.MultiTargetPerTickIncrease * NovaUses.fValue;
			}
		}
	}
	
	MaxDamagePreview = MinDamagePreview;
	return true;
}

simulated function Nova_BuildVisualization(XComGameState VisualizeGameState)
{
	local XComGameStateContext_Ability  Context;
	local XComGameStateHistory			History;
	local XComGameState_Unit			UnitState;
	local UnitValue						UnitVal;

	TypicalAbility_BuildVisualization(VisualizeGameState);

	// Jwats: Nova shouldn't interrupt itself on the first use.
	History = `XCOMHISTORY;

	Context = XComGameStateContext_Ability(VisualizeGameState.GetContext());
	UnitState = XComGameState_Unit(History.GetGameStateForObjectID(Context.InputContext.SourceObject.ObjectID, , VisualizeGameState.HistoryIndex - 1));
	UnitState.GetUnitValue('NovaUsedAmount', UnitVal);
	
	if( UnitVal.fValue == 0.0f )
	{
		/* VISUALIZATION REWRITE
		for( ScanTracks = 0; ScanTracks < OutVisualizationActionMetadatas.Length; ++ScanTracks )
		{
			CurrentTrack = OutVisualizationActionMetadatas[ScanTracks];
			UnitVisualizer = XGUnit(CurrentTrack.VisualizeActor);
			if( UnitVisualizer != None && UnitVisualizer.ObjectID == UnitState.ObjectID )
			{
				for( ScanActions = 0; ScanActions < CurrentTrack.TrackActions.Length; ++ScanActions )
				{
					FireAction = X2Action_Fire(CurrentTrack.TrackActions[ScanActions]);
					if( FireAction != None )
					{
						FireAction.AllowInterrupt = false;
						OutVisualizationActionMetadatas[ScanTracks] = CurrentTrack;
						return;
					}
				}
			}
		}*/
	}
}

static function X2AbilityTemplate EngageSelfDestruct()
{
	local X2AbilityTemplate						Template;
	local X2Effect_Persistent                   SelfDestructEffect;
	local X2Effect_DamageImmunity               DamageImmunity;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'EngageSelfDestruct');
	Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer);

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_DLC3Images.UIPerk_spark_kamikaze";
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_HideIfOtherAvailable;
	Template.HideIfAvailable.AddItem('TriggerSelfDestruct');

	Template.AdditionalAbilities.AddItem('TriggerSelfDestruct');
	Template.AdditionalAbilities.AddItem('SparkDeathExplosion');
	Template.AdditionalAbilities.AddItem('ExplodingSparkInitialState');

	Template.AbilityCosts.AddItem(default.FreeActionCost);

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	SelfDestructEffect = new class'X2Effect_Persistent';
	SelfDestructEffect.BuildPersistentEffect(1, true, false, true);
	SelfDestructEffect.EffectName = default.SparkSelfDestructEffectName;
	SelfDestructEffect.VisualizationFn = EngageSelfDestruct_Visualization;
	Template.AddShooterEffect(SelfDestructEffect);

	// Build the immunities
	DamageImmunity = new class'X2Effect_DamageImmunity';
	DamageImmunity.BuildPersistentEffect(1, true, true, true);
	DamageImmunity.ImmuneTypes.AddItem(class'X2Item_DefaultDamageTypes'.default.KnockbackDamageType);
	DamageImmunity.EffectName = 'SelfDestructEngagedImmunities';
	Template.AddShooterEffect(DamageImmunity);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.BuildAppliedVisualizationSyncFn = EngageSelfDestruct_BuildVisualizationSync;

	Template.bShowActivation = true;
	Template.CustomFireAnim = 'FF_Self_Destruct_Start';

	Template.TwoTurnAttackAbility = 'TriggerSelfDestruct'; // AI using this ability triggers more AI overwatchers.
	return Template;
}

static function EngageSelfDestruct_Visualization(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, const name EffectApplyResult)
{
	local X2Action_SetRagdoll SetRagdollAction;

	if( EffectApplyResult != 'AA_Success' )
	{
		return;
	}

	SetRagdollAction = X2Action_SetRagdoll(class'X2Action_SetRagdoll'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext(), false, ActionMetadata.LastActionAdded));
	SetRagdollAction.RagdollFlag = ERagdoll_Never;
}

simulated function EngageSelfDestruct_BuildVisualizationSync( name EffectName, XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata )
{
	local XComGameStateContext_Ability  Context;
	local X2AbilityTemplate AbilityTemplate;
	local int EffectIndex;

	if( EffectName == default.SparkSelfDestructEffectName )
	{
		Context = XComGameStateContext_Ability(VisualizeGameState.GetContext());

		AbilityTemplate = class'XComGameState_Ability'.static.GetMyTemplateManager().FindAbilityTemplate( Context.InputContext.AbilityTemplateName);

		for( EffectIndex = 0; EffectIndex < AbilityTemplate.AbilityShooterEffects.Length; ++EffectIndex )
		{
			AbilityTemplate.AbilityShooterEffects[EffectIndex].AddX2ActionsForVisualization(VisualizeGameState, ActionMetadata, Context.ResultContext.ShooterEffectResults.ApplyResults[EffectIndex]);
		}
	}
}

static function X2AbilityTemplate TriggerSelfDestruct()
{
	local X2AbilityTemplate					Template;
	local X2Condition_UnitEffects           EffectConditions;
	local X2Effect_KillUnit                 KillUnitEffect;
	local X2AbilityTarget_Cursor			CursorTarget;
	local X2AbilityMultiTarget_Radius		RadiusMultiTarget;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'TriggerSelfDestruct');
	Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer);

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_ShowIfAvailable;
	Template.Hostility = eHostility_Offensive;
	Template.IconImage = "img:///UILibrary_DLC3Images.UIPerk_spark_kamikaze";

	Template.AbilityCosts.AddItem(default.FreeActionCost);

	Template.AbilityToHitCalc = default.DeadEye;
//	Template.AbilityTargetStyle = default.SelfTarget; // Update - APC- changed to MultiTarget_Radius for use with AI AoEs
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	EffectConditions = new class'X2Condition_UnitEffects';
	EffectConditions.AddRequireEffect(default.SparkSelfDestructEffectName, 'AA_MissingRequiredEffect');
	Template.AbilityShooterConditions.AddItem(EffectConditions);

	KillUnitEffect = new class'X2Effect_KillUnit';
	KillUnitEffect.BuildPersistentEffect(1, false, false, false, eGameRule_PlayerTurnEnd);
	KillUnitEffect.EffectName = 'TriggerSelfDestruct';
	Template.AddShooterEffect(KillUnitEffect);

	// APC- Added cursor targeting to enable run & self-destruct combo.
	CursorTarget = new class'X2AbilityTarget_Cursor';
	Template.AbilityTargetStyle = CursorTarget;

	RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
	RadiusMultiTarget.bUseWeaponRadius = false;
	RadiusMultiTarget.fTargetRadius = default.SPARK_DEATH_EXPLOSION_RADIUS_METERS;
	Template.AbilityMultiTargetStyle = RadiusMultiTarget;

	Template.TargetingMethod = class'X2TargetingMethod_PathTarget';
	Template.bSkipFireAction = true;
	Template.bShowActivation = true;

//	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;  // APC- Updated to use Movement.  Allow Dash + Overload for AI.
	Template.BuildNewGameStateFn = TypicalMoveEndAbility_BuildGameState;
	Template.BuildInterruptGameStateFn = TypicalMoveEndAbility_BuildInterruptGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	Template.DamagePreviewFn = TriggerSelfDestruct_DamagePreview;
	
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.GrenadeLostSpawnIncreasePerUse;
//BEGIN AUTOGENERATED CODE: Template Overrides 'TriggerSelfDestruct'
	Template.bFrameEvenWhenUnitIsHidden = true;
//END AUTOGENERATED CODE: Template Overrides 'TriggerSelfDestruct'

	return Template;
}

function bool TriggerSelfDestruct_DamagePreview(XComGameState_Ability AbilityState, StateObjectReference TargetRef, out WeaponDamageValue MinDamagePreview, out WeaponDamageValue MaxDamagePreview, out int AllowsShield)
{
	MinDamagePreview = class'X2Item_DLC_Day90Weapons'.default.SPARK_DEATH_EXPLOSION_BASEDAMAGE;
	MaxDamagePreview = MinDamagePreview;
	return true;
}

simulated function TriggerSelfDestruct_BuildVisualization(XComGameState VisualizeGameState)
{
	local XComGameStateContext_Ability  Context;
	local StateObjectReference          UnitRef;
	local X2VisualizerInterface			SparkVisualizerInterface;
	local VisualizationActionMetadata			EmptyTrack;
	local VisualizationActionMetadata			ActionMetadata;
	local XComGameStateHistory			History;
	local X2AbilityTemplate             AbilityTemplate;
	local X2Action_PlaySoundAndFlyOver  SoundAndFlyover;
	//local int TrackActionIndex, NumActions;

	// Added for move option.
	TypicalAbility_BuildVisualization(VisualizeGameState);

	Context = XComGameStateContext_Ability(VisualizeGameState.GetContext());

	History = `XCOMHISTORY;	
	UnitRef = Context.InputContext.SourceObject;
	AbilityTemplate = class'XComGameState_Ability'.static.GetMyTemplateManager().FindAbilityTemplate(Context.InputContext.AbilityTemplateName);

	//Configure the visualization track for the shooter
	//****************************************************************************************
	ActionMetadata = EmptyTrack;
	ActionMetadata.StateObject_OldState = History.GetGameStateForObjectID(UnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
	ActionMetadata.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(UnitRef.ObjectID);
	ActionMetadata.VisualizeActor = History.GetVisualizer(UnitRef.ObjectID);

	SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyover'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded));
	SoundAndFlyOver.SetSoundAndFlyOverParameters(None, AbilityTemplate.LocFriendlyName, AbilityTemplate.ActivationSpeech, eColor_Bad, AbilityTemplate.IconImage);

	SparkVisualizerInterface = X2VisualizerInterface(ActionMetadata.VisualizeActor);
	SparkVisualizerInterface.BuildAbilityEffectsVisualization(VisualizeGameState, ActionMetadata);

	}

static function X2AbilityTemplate ExplodingSparkInit()
{
	local X2AbilityTemplate					Template;
	local X2Effect_OverrideDeathAction      DeathActionEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'ExplodingSparkInitialState');

	Template.bDontDisplayInAbilitySummary = true;
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	DeathActionEffect = new class'X2Effect_OverrideDeathAction';
	DeathActionEffect.DeathActionClass = class'X2Action_DLC_3_ExplodingSparkDeathAction';
	DeathActionEffect.EffectName = 'ExplodingSparkDeathActionEffect';
	Template.AddTargetEffect(DeathActionEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

static function X2AbilityTemplate SparkDeathExplosion()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityTrigger_EventListener    EventListener;
	local X2AbilityMultiTarget_Radius       MultiTarget;
	local X2Condition_UnitProperty          UnitPropertyCondition;
	local X2Condition_UnitEffects           EffectConditions;
	local X2Effect_ApplyWeaponDamage        DamageEffect;
	local X2Effect_OverrideDeathAnimOnLoad  OverrideDeathAnimEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'SparkDeathExplosion');
	Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer);
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_deathexplosion";

	Template.bDontDisplayInAbilitySummary = true;
	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Offensive;

	EffectConditions = new class'X2Condition_UnitEffects';
	EffectConditions.AddRequireEffect(default.SparkSelfDestructEffectName, 'AA_MissingRequiredEffect');
	Template.AbilityShooterConditions.AddItem(EffectConditions);

	// This ability is only valid if there has not been another death explosion on the unit
	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeDead = false;
	UnitPropertyCondition.ExcludeDeadFromSpecialDeath = true;
	Template.AbilityShooterConditions.AddItem(UnitPropertyCondition);

	EventListener = new class'X2AbilityTrigger_EventListener';
	EventListener.ListenerData.Deferral = ELD_OnStateSubmitted;
	EventListener.ListenerData.EventID = 'UnitDied';
	EventListener.ListenerData.Filter = eFilter_Unit;
	EventListener.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self_VisualizeInGameState;
	Template.AbilityTriggers.AddItem(EventListener);

	// Targets the unit so the blast center is its dead body
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityToHitCalc = default.DeadEye;

	// Target everything in this blast radius
	MultiTarget = new class'X2AbilityMultiTarget_Radius';
	MultiTarget.fTargetRadius = default.SPARK_DEATH_EXPLOSION_RADIUS_METERS;
	Template.AbilityMultiTargetStyle = MultiTarget;

	Template.AddTargetEffect(new class'X2Effect_SetSpecialDeath');

	OverrideDeathAnimEffect = new class'X2Effect_OverrideDeathAnimOnLoad';
	OverrideDeathAnimEffect.EffectName = 'SparkDeathAnimOnLoad';
	OverrideDeathAnimEffect.OverrideAnimNameOnLoad = 'FF_Self_Destruct_Boom';
	OverrideDeathAnimEffect.BuildPersistentEffect(1, true, false, true);
	OverrideDeathAnimEffect.EffectRank = 10;
	Template.AddTargetEffect(OverrideDeathAnimEffect);

	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeDead = true;
	UnitPropertyCondition.ExcludeFriendlyToSource = false;
	UnitPropertyCondition.ExcludeHostileToSource = false;
	UnitPropertyCondition.FailOnNonUnits = false; //The grenade can affect interactive objects, others
	Template.AbilityMultiTargetConditions.AddItem(UnitPropertyCondition);

	// Everything in the blast radius receives physical damage
	DamageEffect = new class'X2Effect_ApplyWeaponDamage';
	DamageEffect.EffectDamageValue = class'X2Item_DLC_Day90Weapons'.default.SPARK_DEATH_EXPLOSION_BASEDAMAGE;
	DamageEffect.EnvironmentalDamageAmount = default.SPARK_PSI_EXPLOSION_ENV_DMG;
	Template.AddMultiTargetEffect(DamageEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = class'X2Ability_Death'.static.DeathExplosion_BuildVisualization;
	Template.MergeVisualizationFn = class'X2Ability_Death'.static.DeathExplostion_MergeVisualization;
	//Template.MergeVisualizationFn = class'X2Ability_Gatekeeper'.DeathExplosion_VisualizationTrackInsert;

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.GrenadeLostSpawnIncreasePerUse;
//BEGIN AUTOGENERATED CODE: Template Overrides 'SparkDeathExplosion'
	Template.bFrameEvenWhenUnitIsHidden = true;
//END AUTOGENERATED CODE: Template Overrides 'SparkDeathExplosion'
	
	return Template;
}

//  NOTE: This ability is purely for visualization of start of match concealment, it does nothing else.
static function X2AbilityTemplate ActiveCamo()
{
	local X2AbilityTemplate                 Template;
	local X2Effect_Persistent               CamoEffect;
	local X2Condition_UnitProperty          ConcealedCondition;
	local X2AbilityTrigger_EventListener    Trigger;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'ActiveCamo');
	Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer);
	Template.bDontDisplayInAbilitySummary = true;

	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	
	Trigger = new class'X2AbilityTrigger_EventListener';
	Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
	Trigger.ListenerData.EventID = 'StartOfMatchConcealment';
	Trigger.ListenerData.Filter = eFilter_Player;
	Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self_VisualizeInGameState;
	Template.AbilityTriggers.AddItem(Trigger);

	ConcealedCondition = new class'X2Condition_UnitProperty';
	ConcealedCondition.ExcludeFriendlyToSource = false;
	ConcealedCondition.IsConcealed = true;

	CamoEffect = new class'X2Effect_Persistent';
	CamoEffect.BuildPersistentEffect(1, true, false);
	CamoEffect.TargetConditions.AddItem(ConcealedCondition);
	CamoEffect.bRemoveWhenTargetConcealmentBroken = true;
	Template.AddTargetEffect(CamoEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.CustomFireAnim = 'NO_Camouflage';

	return Template;
}

static function X2AbilityTemplate SparkRocketLauncher()
{
	local X2AbilityTemplate AbilityTemplate;
	local X2Condition_UnitProperty ShooterPropertyCondition;

	AbilityTemplate = class'X2Ability_HeavyWeapons'.static.RocketLauncherAbility('SparkRocketLauncher');
	AbilityTemplate.RemoveTemplateAvailablility(AbilityTemplate.BITFIELD_GAMEAREA_Multiplayer);

	X2AbilityMultiTarget_Radius(AbilityTemplate.AbilityMultiTargetStyle).AddAbilityBonusRadius('Rainmaker', default.RAINMAKER_RADIUS_ROCKETLAUNCHER);

	ShooterPropertyCondition = new class'X2Condition_UnitProperty';
	ShooterPropertyCondition.RequireSoldierClasses.AddItem('Spark');
	AbilityTemplate.AbilityShooterConditions.AddItem(ShooterPropertyCondition);
	AbilityTemplate.BuildVisualizationFn = SparkHeavyWeaponVisualization;

	AbilityTemplate.bDisplayInUITacticalText = false;
//BEGIN AUTOGENERATED CODE: Template Overrides 'SparkRocketLauncher'
	AbilityTemplate.bFrameEvenWhenUnitIsHidden = true;
//END AUTOGENERATED CODE: Template Overrides 'SparkRocketLauncher'

	return AbilityTemplate;
}

static function X2AbilityTemplate SparkShredderGun()
{
	local X2AbilityTemplate AbilityTemplate;
	local X2Condition_UnitProperty ShooterPropertyCondition;

	AbilityTemplate = class'X2Ability_HeavyWeapons'.static.ShredderGunAbility('SparkShredderGun');
	AbilityTemplate.RemoveTemplateAvailablility(AbilityTemplate.BITFIELD_GAMEAREA_Multiplayer);

	X2AbilityMultiTarget_Cone(AbilityTemplate.AbilityMultiTargetStyle).AddBonusConeSize('Rainmaker', default.RAINMAKER_CONEDIAMETER_SHREDDERGUN, default.RAINMAKER_CONELENGTH_SHREDDERGUN);

	ShooterPropertyCondition = new class'X2Condition_UnitProperty';
	ShooterPropertyCondition.RequireSoldierClasses.AddItem('Spark');
	AbilityTemplate.AbilityShooterConditions.AddItem(ShooterPropertyCondition);
	AbilityTemplate.BuildVisualizationFn = SparkHeavyWeaponVisualization;

	AbilityTemplate.bDisplayInUITacticalText = false;
//BEGIN AUTOGENERATED CODE: Template Overrides 'SparkShredderGun'
	AbilityTemplate.bFrameEvenWhenUnitIsHidden = true;
//END AUTOGENERATED CODE: Template Overrides 'SparkShredderGun'

	return AbilityTemplate;
}

static function X2AbilityTemplate SparkShredstormCannon()
{
	local X2AbilityTemplate AbilityTemplate;
	local X2Condition_UnitProperty ShooterPropertyCondition;

	AbilityTemplate = class'X2Ability_HeavyWeapons'.static.ShredstormCannonAbility('SparkShredstormCannon');
	AbilityTemplate.RemoveTemplateAvailablility(AbilityTemplate.BITFIELD_GAMEAREA_Multiplayer);

	X2AbilityMultiTarget_Cone(AbilityTemplate.AbilityMultiTargetStyle).AddBonusConeSize('Rainmaker', default.RAINMAKER_CONEDIAMETER_SHREDSTORM, default.RAINMAKER_CONELENGTH_SHREDSTORM);

	ShooterPropertyCondition = new class'X2Condition_UnitProperty';
	ShooterPropertyCondition.RequireSoldierClasses.AddItem('Spark');
	AbilityTemplate.AbilityShooterConditions.AddItem(ShooterPropertyCondition);
	AbilityTemplate.BuildVisualizationFn = SparkHeavyWeaponVisualization;

	AbilityTemplate.bDisplayInUITacticalText = false;
//BEGIN AUTOGENERATED CODE: Template Overrides 'SparkShredstormCannon'
	AbilityTemplate.bFrameEvenWhenUnitIsHidden = true;
//END AUTOGENERATED CODE: Template Overrides 'SparkShredstormCannon'

	return AbilityTemplate;
}

static function X2AbilityTemplate SparkFlamethrower()
{
	local X2AbilityTemplate AbilityTemplate;
	local X2Condition_UnitProperty ShooterPropertyCondition;

	AbilityTemplate = class'X2Ability_HeavyWeapons'.static.Flamethrower('SparkFlamethrower');
	AbilityTemplate.RemoveTemplateAvailablility(AbilityTemplate.BITFIELD_GAMEAREA_Multiplayer);

	X2AbilityMultiTarget_Cone(AbilityTemplate.AbilityMultiTargetStyle).AddBonusConeSize('Rainmaker', default.RAINMAKER_CONEDIAMETER_FLAMETHROWER, default.RAINMAKER_CONELENGTH_FLAMETHROWER);

	ShooterPropertyCondition = new class'X2Condition_UnitProperty';
	ShooterPropertyCondition.RequireSoldierClasses.AddItem('Spark');
	AbilityTemplate.AbilityShooterConditions.AddItem(ShooterPropertyCondition);
	AbilityTemplate.BuildVisualizationFn = SparkHeavyWeaponVisualization;

	AbilityTemplate.bDisplayInUITacticalText = false;
//BEGIN AUTOGENERATED CODE: Template Overrides 'SparkFlamethrower'
	AbilityTemplate.bFrameEvenWhenUnitIsHidden = true;
//END AUTOGENERATED CODE: Template Overrides 'SparkFlamethrower'

	return AbilityTemplate;
}

static function X2AbilityTemplate SparkFlamethrowerMk2()
{
	local X2AbilityTemplate AbilityTemplate;
	local X2Condition_UnitProperty ShooterPropertyCondition;

	AbilityTemplate = class'X2Ability_HeavyWeapons'.static.Flamethrower('SparkFlamethrowerMk2');
	AbilityTemplate.RemoveTemplateAvailablility(AbilityTemplate.BITFIELD_GAMEAREA_Multiplayer);

	X2AbilityMultiTarget_Cone(AbilityTemplate.AbilityMultiTargetStyle).AddBonusConeSize('Rainmaker', default.RAINMAKER_CONEDIAMETER_FLAMETHROWER2, default.RAINMAKER_CONELENGTH_FLAMETHROWER2);

	ShooterPropertyCondition = new class'X2Condition_UnitProperty';
	ShooterPropertyCondition.RequireSoldierClasses.AddItem('Spark');
	AbilityTemplate.AbilityShooterConditions.AddItem(ShooterPropertyCondition);
	AbilityTemplate.BuildVisualizationFn = SparkHeavyWeaponVisualization;

	AbilityTemplate.bDisplayInUITacticalText = false;
//BEGIN AUTOGENERATED CODE: Template Overrides 'SparkFlamethrowerMk2'
	AbilityTemplate.bFrameEvenWhenUnitIsHidden = true;
//END AUTOGENERATED CODE: Template Overrides 'SparkFlamethrowerMk2'

	return AbilityTemplate;
}

static function X2AbilityTemplate SparkBlasterLauncher()
{
	local X2AbilityTemplate AbilityTemplate;
	local X2Condition_UnitProperty ShooterPropertyCondition;

	AbilityTemplate = class'X2Ability_HeavyWeapons'.static.BlasterLauncherAbility('SparkBlasterLauncher');
	AbilityTemplate.RemoveTemplateAvailablility(AbilityTemplate.BITFIELD_GAMEAREA_Multiplayer);

	X2AbilityMultiTarget_Radius(AbilityTemplate.AbilityMultiTargetStyle).AddAbilityBonusRadius('Rainmaker', default.RAINMAKER_RADIUS_BLASTERLAUNCHER);

	ShooterPropertyCondition = new class'X2Condition_UnitProperty';
	ShooterPropertyCondition.RequireSoldierClasses.AddItem('Spark');
	AbilityTemplate.AbilityShooterConditions.AddItem(ShooterPropertyCondition);
	AbilityTemplate.BuildVisualizationFn = SparkHeavyWeaponVisualization;

	AbilityTemplate.bDisplayInUITacticalText = false;
//BEGIN AUTOGENERATED CODE: Template Overrides 'SparkBlasterLauncher'
	AbilityTemplate.bFrameEvenWhenUnitIsHidden = true;
//END AUTOGENERATED CODE: Template Overrides 'SparkBlasterLauncher'

	return AbilityTemplate;
}

static function X2AbilityTemplate SparkPlasmaBlaster()
{
	local X2AbilityTemplate AbilityTemplate;
	local X2Condition_UnitProperty ShooterPropertyCondition;

	AbilityTemplate = class'X2Ability_HeavyWeapons'.static.PlasmaBlaster('SparkPlasmaBlaster');
	AbilityTemplate.RemoveTemplateAvailablility(AbilityTemplate.BITFIELD_GAMEAREA_Multiplayer);

	X2AbilityMultiTarget_Line(AbilityTemplate.AbilityMultiTargetStyle).AddAbilityBonusWidth('Rainmaker', default.RAINMAKER_WIDTH_PLASMABLASTER);

	ShooterPropertyCondition = new class'X2Condition_UnitProperty';
	ShooterPropertyCondition.RequireSoldierClasses.AddItem('Spark');
	AbilityTemplate.AbilityShooterConditions.AddItem(ShooterPropertyCondition);
	AbilityTemplate.BuildVisualizationFn = SparkHeavyWeaponVisualization;

	AbilityTemplate.bDisplayInUITacticalText = false;
//BEGIN AUTOGENERATED CODE: Template Overrides 'SparkPlasmaBlaster'
	AbilityTemplate.bFrameEvenWhenUnitIsHidden = true;
//END AUTOGENERATED CODE: Template Overrides 'SparkPlasmaBlaster'

	return AbilityTemplate;
}

function SparkHeavyWeaponVisualization(XComGameState VisualizeGameState)
{
	local XComGameStateHistory				History;
	local XComGameStateContext_Ability		Context;
	local XComGameState_Unit				SourceUnitState;
	local array<XComGameState_Unit>			AttachedUnitStates;
	local XComGameState_Unit				CosmeticUnit;
	local VisualizationActionMetadata		EmptyMetadata;
	local VisualizationActionMetadata		ActionMetadata;
	local X2AbilityTemplate					AbilityTemplate;
	local XComGameState_Item				CosmeticHeavyWeapon;
	local X2Action_ExitCover				ExitCoverAction;
	local X2Action_ExitCover				SourceExitCoverAction;
	local X2Action_EnterCover				EnterCoverAction;
	local X2Action_Fire						FireAction;
	local X2Action_Fire						NewFireAction;
	local XComGameStateVisualizationMgr		VisMgr;
	local Actor								SourceVisualizer;
	local Array<X2Action>					ParentArray;
	local Array<X2Action>					TempDamageNodes;
	local Array<X2Action>					DamageNodes;
	local int								ScanNodes;

	VisMgr = `XCOMVISUALIZATIONMGR;
	// Jwats: Build the standard visualization
	TypicalAbility_BuildVisualization(VisualizeGameState);

	// Jwats: Now handle the cosmetic unit
	History = `XCOMHISTORY;
	Context = XComGameStateContext_Ability(VisualizeGameState.GetContext());
	AbilityTemplate = class'XComGameState_Ability'.static.GetMyTemplateManager().FindAbilityTemplate(Context.InputContext.AbilityTemplateName);

	SourceUnitState = XComGameState_Unit(History.GetGameStateForObjectID(Context.InputContext.SourceObject.ObjectID));
	SourceVisualizer = History.GetVisualizer(SourceUnitState.ObjectID);
	SourceUnitState.GetAttachedUnits(AttachedUnitStates, VisualizeGameState);
	`assert(AttachedUnitStates.Length > 0);
	CosmeticUnit = AttachedUnitStates[0];

	CosmeticHeavyWeapon = CosmeticUnit.GetItemInSlot(eInvSlot_HeavyWeapon);

	// Jwats: Because the shooter might be using a unique fire action we'll replace it with the standard fire action to just
	//			command the cosmetic unit
	SourceExitCoverAction = X2Action_ExitCover(VisMgr.GetNodeOfType(VisMgr.BuildVisTree, class'X2Action_ExitCover', SourceVisualizer));
	FireAction = X2Action_Fire(VisMgr.GetNodeOfType(VisMgr.BuildVisTree, AbilityTemplate.ActionFireClass, SourceVisualizer));

	// Jwats: Replace the current fire action with this fire action
	NewFireAction = X2Action_Fire(class'X2Action_Fire'.static.CreateVisualizationAction(Context, SourceVisualizer));
	NewFireAction.SetFireParameters(Context.IsResultContextHit());
	VisMgr.ReplaceNode(NewFireAction, FireAction);

	// Jwats: Have the bit do an exit cover/fire/enter cover
	ActionMetadata = EmptyMetadata;
	ActionMetadata.StateObject_OldState = History.GetGameStateForObjectID(CosmeticUnit.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
	ActionMetadata.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(CosmeticUnit.ObjectID);
	if( ActionMetadata.StateObject_NewState == none )
		ActionMetadata.StateObject_NewState = ActionMetadata.StateObject_OldState;
	ActionMetadata.VisualizeActor = History.GetVisualizer(CosmeticUnit.ObjectID);

	// Jwats: Wait to exit cover until the main guy is ready
	ExitCoverAction = X2Action_ExitCover(class'X2Action_ExitCover'.static.AddToVisualizationTree(ActionMetadata, Context, false, , SourceExitCoverAction.ParentActions));
	FireAction = X2Action_Fire(AbilityTemplate.ActionFireClass.static.AddToVisualizationTree(ActionMetadata, Context, false));
	EnterCoverAction = X2Action_EnterCover(class'X2Action_EnterCover'.static.AddToVisualizationTree(ActionMetadata, Context, false, FireAction));
	ExitCoverAction.UseWeapon = XGWeapon(History.GetVisualizer(CosmeticHeavyWeapon.ObjectID));
	FireAction.SetFireParameters(Context.IsResultContextHit());
	
	// Jwats: Make sure that the fire actions are in sync! Wait until both have completed their exit cover
	ParentArray.Length = 0;
	ParentArray.AddItem(ExitCoverAction);
	ParentArray.AddItem(SourceExitCoverAction);
	VisMgr.ConnectAction(FireAction, VisMgr.BuildVisTree, false, , ParentArray);
	VisMgr.ConnectAction(NewFireAction, VisMgr.BuildVisTree, false, , ParentArray);

	// Jwats: Update the apply weapon damage nodes to have the bit's fire flamethrower as their parent instead of the spark's fire node
	VisMgr.GetNodesOfType(VisMgr.BuildVisTree, class'X2Action_ApplyWeaponDamageToUnit', TempDamageNodes);
	DamageNodes = TempDamageNodes;
	VisMgr.GetNodesOfType(VisMgr.BuildVisTree, class'X2Action_ApplyWeaponDamageToTerrain', TempDamageNodes);

	for( ScanNodes = 0; ScanNodes < TempDamageNodes.Length; ++ScanNodes )
	{
		DamageNodes.AddItem(TempDamageNodes[ScanNodes]);
	}
	
	for( ScanNodes = 0; ScanNodes < DamageNodes.Length; ++ScanNodes )
	{
		if( DamageNodes[ScanNodes].ParentActions[0] == NewFireAction )
		{
			VisMgr.DisconnectAction(DamageNodes[ScanNodes]);
			VisMgr.ConnectAction(DamageNodes[ScanNodes], VisMgr.BuildVisTree, false, FireAction);
		}
	}

	// Jwats: Now make sure the enter cover of the bit is a child of all the apply weapon damage nodes
	VisMgr.ConnectAction(EnterCoverAction, VisMgr.BuildVisTree, false, , DamageNodes);
}

defaultproperties
{
	SparkSelfDestructEffectName="SparkSelfDestructEffect" // Any name changes need to be duplicated in the behavior tree.
	NovaAbilityName="Nova"
	BOMBARD_HEIGHT=1024
}
