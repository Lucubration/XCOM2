class X2Ability_Lucu_Garage_UtilityItemAbilitySet extends X2Ability
	config(Lucu_Garage_DefaultConfig);

var localized string ShieldedFriendlyName;
var localized string ShieldedLongDescription;
var localized string WallBreakingFriendlyName;
var localized string WallBreakingFriendlyDesc;
var localized string WallBreakingEffectAcquiredString;
var localized string WallBreakingEffectLostString;

var config int MunitionsStorageBonusAmmoReserve;
var config float MunitionsStorageBonusAmmoSecondary;
var config int ExtraCapacitorsBonusPowerMax;
var config int AuxiliaryGeneratorBonusPowerRegen;
var config int AdaptiveCamoPowerCost;
var config int AdaptiveCamoCooldown;
var config int HardenedArmorCritModifier;
var config int LaserTargeterCritBaseModifier;
var config int AdvancedOpticsAimModifier;
var config int RedundantSystemsHealthModifier;
var config int SmokescreenBonusRadius;
var config int SmokescreenDuration;
var config int SmokescreenHitMod;
var config int AbsorptionFieldPowerCost;
var config int AbsorptionFieldCooldown;
var config float AbsorptionFieldDamageModifier;
var config int AbsorptionFieldDuration;
var config int ShieldGeneratorActionPoints;
var config int ShieldGeneratorPowerCost;
var config int ShieldGeneratorCooldown;
var config int ShieldGeneratorDuration;
var config int ShieldGeneratorShieldBase;
var config int ShieldGeneratorShield;
	
static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;
	
	Templates.AddItem(WallBreakingOff());
	Templates.AddItem(WallBreakingOn());
	Templates.AddItem(MunitionsStorage());
	Templates.AddItem(ExtraCapacitors());
	Templates.AddItem(AuxiliaryGenerator());
	Templates.AddItem(AdaptiveCamoPhantom());
	Templates.AddItem(AdaptiveCamoStealth());
	Templates.AddItem(HardenedArmor());
	Templates.AddItem(LaserTargeter());
	Templates.AddItem(AdvancedOptics());
	Templates.AddItem(RedundantSystems());
	Templates.AddItem(SmokescreenItem());
	Templates.AddItem(SmokescreenWeapon());
	Templates.AddItem(AbsorptionField());
	Templates.AddItem(ShieldGenerator());

	return Templates;
}


//---------------------------------------------------------------------------------------------------
// Wall-Breaking (Off)
//---------------------------------------------------------------------------------------------------


static function X2AbilityTemplate WallBreakingOff()
{
	local X2AbilityTemplate					Template;
	local X2AbilityTrigger_PlayerInput		InputTrigger;
	local X2Effect_RemoveEffects			RemoveEffects;
	local X2Condition_UnitEffects			EffectsCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Lucu_Garage_WallBreakingOff');

	Template.AbilitySourceName = 'eAbilitySource_Item';
	Template.bDontDisplayInAbilitySummary = true;
	Template.Hostility = eHostility_Neutral;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_ShowIfAvailable;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_muton_punch";
	
	Template.AbilityCosts.AddItem(default.FreeActionCost);
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	
	InputTrigger = new class'X2AbilityTrigger_PlayerInput';
	Template.AbilityTriggers.AddItem(InputTrigger);

	RemoveEffects = new class'X2Effect_RemoveEffects';
	RemoveEffects.EffectNamesToRemove.AddItem(class'X2Effect_WallBreaking'.default.WallBreakingEffectName);
	Template.AddTargetEffect(RemoveEffects);

	EffectsCondition = new class'X2Condition_UnitEffects';
	EffectsCondition.AddRequireEffect(class'X2Effect_WallBreaking'.default.WallBreakingEffectName, 'AA_UnitIsImmune');
	Template.AbilityTargetConditions.AddItem(EffectsCondition);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.bSkipFireAction = true;
	Template.FrameAbilityCameraType = eCameraFraming_Never;

	return Template;
}


//---------------------------------------------------------------------------------------------------
// Wall-Breaking (On)
//---------------------------------------------------------------------------------------------------


static function X2AbilityTemplate WallBreakingOn()
{
	local X2AbilityTemplate					Template;
	local X2AbilityTrigger_PlayerInput		InputTrigger;
	local X2Effect_WallBreaking				WallBreakEffect;
	local X2Condition_UnitEffects			EffectsCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Lucu_Garage_WallBreakingOn');

	Template.AbilitySourceName = 'eAbilitySource_Item';
	Template.bDontDisplayInAbilitySummary = true;
	Template.Hostility = eHostility_Neutral;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_ShowIfAvailable;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_muton_punch";
	
	Template.AbilityCosts.AddItem(default.FreeActionCost);
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	
	InputTrigger = new class'X2AbilityTrigger_PlayerInput';
	Template.AbilityTriggers.AddItem(InputTrigger);

	WallBreakEffect = new class'X2Effect_WallBreaking';
	WallBreakEffect.BuildPersistentEffect(1, true, false);
	WallBreakEffect.SetDisplayInfo(ePerkBuff_Bonus, default.WallBreakingFriendlyName, default.WallBreakingFriendlyDesc, Template.IconImage, true);
	WallBreakEffect.AddTraversalChange(eTraversal_BreakWall, true);
	WallBreakEffect.EffectName = class'X2Effect_WallBreaking'.default.WallBreakingEffectName;
	WallBreakEffect.VisualizationFn = WallBreakVisualization;
	WallBreakEffect.CleansedVisualizationFn = WallBreakCleansedVisualization;
	WallBreakEffect.EffectRemovedVisualizationFn = WallBreakVisualizationRemoved;
	Template.AddTargetEffect(WallBreakEffect);

	EffectsCondition = new class'X2Condition_UnitEffects';
	EffectsCondition.AddExcludeEffect(class'X2Effect_WallBreaking'.default.WallBreakingEffectName, 'AA_UnitIsImmune');
	Template.AbilityTargetConditions.AddItem(EffectsCondition);
	
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.bSkipFireAction = true;
	Template.FrameAbilityCameraType = eCameraFraming_Never;

	Template.AdditionalAbilities.AddItem('Lucu_Garage_WallBreakingOff');

	return Template;
}

static function WallBreakVisualization(XComGameState VisualizeGameState, out VisualizationTrack BuildTrack, const name EffectApplyResult)
{
	local XComGameStateContext_Ability Context;
	local X2Action_PlaySoundAndFlyOver SoundAndFlyOver;
	
	Context = XComGameStateContext_Ability(VisualizeGameState.GetContext());

	if (EffectApplyResult != 'AA_Success')
		return;
	if (!BuildTrack.StateObject_NewState.IsA('XComGameState_Unit'))
		return;

	SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTrack(BuildTrack, Context));
	SoundAndFlyOver.SetSoundAndFlyOverParameters(none, default.WallBreakingEffectAcquiredString, '', eColor_Good, "", 0);
}

static function WallBreakCleansedVisualization(XComGameState VisualizeGameState, out VisualizationTrack BuildTrack, const name EffectApplyResult)
{
	local XComGameStateContext_Ability Context;
	local X2Action_PlaySoundAndFlyOver SoundAndFlyOver;

	Context = XComGameStateContext_Ability(VisualizeGameState.GetContext());

	SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTrack(BuildTrack, Context));
	SoundAndFlyOver.SetSoundAndFlyOverParameters(none, default.WallBreakingEffectLostString, '', eColor_Bad, "", 0);
}

static function WallBreakVisualizationRemoved(XComGameState VisualizeGameState, out VisualizationTrack BuildTrack, const name EffectApplyResult)
{
	local XComGameStateContext_Ability Context;
	local XComGameState_Unit UnitState;
	local X2Action_PlaySoundAndFlyOver SoundAndFlyOver;
	
	Context = XComGameStateContext_Ability(VisualizeGameState.GetContext());
	UnitState = XComGameState_Unit(BuildTrack.StateObject_NewState);

	// Dead units should not be reported
	if (UnitState == None || UnitState.IsDead())
		return;
		
	SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTrack(BuildTrack, Context));
	SoundAndFlyOver.SetSoundAndFlyOverParameters(none, default.WallBreakingEffectLostString, '', eColor_Bad, "", 0);
}


//---------------------------------------------------------------------------------------------------
// Munitions Storage
//---------------------------------------------------------------------------------------------------


static function X2AbilityTemplate MunitionsStorage()
{
	local X2AbilityTemplate							Template;
	local X2Effect_Lucu_Garage_AmmoReserveModify	AmmoReserveEffect;
	local X2Effect_Lucu_Garage_AmmoModify			AmmoSecondaryEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Lucu_Garage_MunitionsStorage');

	Template.AbilitySourceName = 'eAbilitySource_Item';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_phantom";

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	AmmoReserveEffect = new class'X2Effect_Lucu_Garage_AmmoReserveModify';
	AmmoReserveEffect.Amount = default.MunitionsStorageBonusAmmoReserve;
	AmmoReserveEffect.PerArmorTier = true;
	Template.AddTargetEffect(AmmoReserveEffect);

	AmmoSecondaryEffect = new class'X2Effect_Lucu_Garage_AmmoModify';
	AmmoSecondaryEffect.Amount = default.MunitionsStorageBonusAmmoSecondary;
	AmmoSecondaryEffect.ModOp = MODOP_Multiplication;
	AmmoSecondaryEffect.ItemSlot = eInvSlot_SecondaryWeapon;
	AmmoSecondaryEffect.PerArmorTier = true;
	Template.AddTargetEffect(AmmoSecondaryEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!

	return Template;
}


//---------------------------------------------------------------------------------------------------
// Extra Capacitors
//---------------------------------------------------------------------------------------------------


static function X2AbilityTemplate ExtraCapacitors()
{
	local X2AbilityTemplate					Template;
	local X2Effect_Lucu_Garage_PowerMax		Effect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Lucu_Garage_ExtraCapacitors');

	Template.AbilitySourceName = 'eAbilitySource_Item';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_phantom";

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	Effect = new class'X2Effect_Lucu_Garage_PowerMax';
	Effect.EffectName = 'Lucu_Garage_ExtraCapacitors';
	Effect.BuildPersistentEffect(1, true, false);
	Effect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, false,,Template.AbilitySourceName);
	Effect.Amount = default.ExtraCapacitorsBonusPowerMax;
	Effect.PerArmorTier = true;
	Effect.DuplicateResponse = eDupe_Allow;
	Template.AddTargetEffect(Effect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!

	return Template;
}


//---------------------------------------------------------------------------------------------------
// Auxiliary Generator
//---------------------------------------------------------------------------------------------------


static function X2AbilityTemplate AuxiliaryGenerator()
{
	local X2AbilityTemplate					Template;
	local X2Effect_Lucu_Garage_PowerRegen	Effect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Lucu_Garage_AuxiliaryGenerator');
	
	Template.AbilitySourceName = 'eAbilitySource_Item';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_phantom";

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	Effect = new class'X2Effect_Lucu_Garage_PowerRegen';
	Effect.EffectName = 'Lucu_Garage_AuxiliaryGenerator';
	Effect.BuildPersistentEffect(1, true, false, , eGameRule_PlayerTurnBegin);
	Effect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, false,,Template.AbilitySourceName);
	Effect.Amount = default.AuxiliaryGeneratorBonusPowerRegen;
	Effect.DuplicateResponse = eDupe_Allow;
	Template.AddTargetEffect(Effect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!

	return Template;
}


//---------------------------------------------------------------------------------------------------
// Adaptive Camo (Stealth)
//---------------------------------------------------------------------------------------------------


static function X2AbilityTemplate AdaptiveCamoStealth()
{
	local X2AbilityTemplate						Template;
	local X2Effect_RangerStealth                StealthEffect;
	local X2AbilityCost_Lucu_Garage_Power       PowerCost;
	local X2AbilityCooldown						Cooldown;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Lucu_Garage_AdaptiveCamoStealth');

	Template.AbilitySourceName = 'eAbilitySource_Item';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_stealth";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.AbilityCosts.AddItem(new class'X2AbilityCost_Charges');
	Template.AbilityCosts.AddItem(default.FreeActionCost);

	PowerCost = new class'X2AbilityCost_Lucu_Garage_Power';
	PowerCost.Amount = default.AdaptiveCamoPowerCost;
	Template.AbilityCosts.AddItem(PowerCost);
	
	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.AdaptiveCamoCooldown;
	Template.AbilityCooldown = Cooldown;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AbilityShooterConditions.AddItem(new class'X2Condition_Stealth');

	StealthEffect = new class'X2Effect_RangerStealth';
	StealthEffect.EffectName = 'Lucu_Garage_AdaptiveCamoStealth';
	StealthEffect.BuildPersistentEffect(1, true, true, false, eGameRule_PlayerTurnEnd);
	StealthEffect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, true);
	StealthEffect.bRemoveWhenTargetConcealmentBroken = true;
	StealthEffect.DuplicateResponse = eDupe_Ignore;
	Template.AddTargetEffect(StealthEffect);

	Template.AddTargetEffect(class'X2Effect_Spotted'.static.CreateUnspottedEffect());

	Template.ActivationSpeech = 'ActivateConcealment';
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.bSkipFireAction = true;

	return Template;
}


//---------------------------------------------------------------------------------------------------
// Adaptive Camo (Phantom)
//---------------------------------------------------------------------------------------------------


static function X2AbilityTemplate AdaptiveCamoPhantom()
{
	local X2AbilityTemplate						Template;
	local X2Effect_Persistent                   Effect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Lucu_Garage_AdaptiveCamoPhantom');

	Template.AbilitySourceName = 'eAbilitySource_Item';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_phantom";

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	Effect = new class'X2Effect_StayConcealed';
	Effect.EffectName = 'Lucu_Garage_AdaptiveCamoPhantom';
	Effect.BuildPersistentEffect(1, true, false);
	Effect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage,,,Template.AbilitySourceName);
	Effect.DuplicateResponse = eDupe_Ignore;
	Template.AddTargetEffect(Effect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!

	return Template;
}


//---------------------------------------------------------------------------------------------------
// Hardened Armor
//---------------------------------------------------------------------------------------------------


static function X2AbilityTemplate HardenedArmor()
{
	local X2AbilityTemplate						Template;
	local X2Effect_Lucu_Garage_HardenedArmor	Effect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Lucu_Garage_HardenedArmor');

	Template.AbilitySourceName = 'eAbilitySource_Item';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_phantom";

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	Effect = new class'X2Effect_Lucu_Garage_HardenedArmor';
	Effect.EffectName = 'Lucu_Garage_HardenedArmor';
	Effect.BuildPersistentEffect(1, true, false);
	Effect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage,,,Template.AbilitySourceName);
	Effect.CritModifier = default.HardenedArmorCritModifier;
	Effect.DuplicateResponse = eDupe_Ignore;
	Template.AddTargetEffect(Effect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!

	return Template;
}


//---------------------------------------------------------------------------------------------------
// Laser Targeter
//---------------------------------------------------------------------------------------------------


static function X2AbilityTemplate LaserTargeter()
{
	local X2AbilityTemplate						Template;
	local X2Effect_Lucu_Garage_LaserTargeter	Effect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Lucu_Garage_LaserTargeter');

	Template.AbilitySourceName = 'eAbilitySource_Item';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_hunter";

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	Effect = new class'X2Effect_Lucu_Garage_LaserTargeter';
	Effect.EffectName = 'Lucu_Garage_LaserTargeter';
	Effect.BuildPersistentEffect(1, true, false, false);
	Effect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, false);
	Effect.CritBonus = default.LaserTargeterCritBaseModifier;
	Effect.DuplicateResponse = eDupe_Ignore;
	Template.AddTargetEffect(Effect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!

	return Template;
}


//---------------------------------------------------------------------------------------------------
// Advanced Optics
//---------------------------------------------------------------------------------------------------


static function X2AbilityTemplate AdvancedOptics()
{
	local X2AbilityTemplate								Template;
	local X2Effect_Lucu_Garage_PersistentStatChange		Effect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Lucu_Garage_AdvancedOptics');

	Template.AbilitySourceName = 'eAbilitySource_Item';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_hunter";

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	Effect = new class'X2Effect_Lucu_Garage_PersistentStatChange';
	Effect.EffectName = 'Lucu_Garage_AdvancedOptics';
	Effect.BuildPersistentEffect(1, true, false, false);
	Effect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, false);
	Effect.AddPersistentStatChange(eStat_Offense, default.AdvancedOpticsAimModifier, true);
	Effect.DuplicateResponse = eDupe_Allow;
	Template.AddTargetEffect(Effect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!

	return Template;
}


//---------------------------------------------------------------------------------------------------
// Redundant Systems
//---------------------------------------------------------------------------------------------------


static function X2AbilityTemplate RedundantSystems()
{
	local X2AbilityTemplate								Template;
	local X2Effect_Lucu_Garage_PersistentStatChange		Effect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Lucu_Garage_RedundantSystems');

	Template.AbilitySourceName = 'eAbilitySource_Item';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_hunter";

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	
	Effect = new class'X2Effect_Lucu_Garage_PersistentStatChange';
	Effect.EffectName = 'Lucu_Garage_RedundantSystems';
	Effect.BuildPersistentEffect(1, true, false, false);
	Effect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage);
	Effect.AddPersistentStatChange(eStat_HP, default.RedundantSystemsHealthModifier, true);
	Effect.DuplicateResponse = eDupe_Allow;
	Template.AddTargetEffect(Effect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!

	return Template;
}


//---------------------------------------------------------------------------------------------------
// Smokescreen
//---------------------------------------------------------------------------------------------------


static function X2AbilityTemplate SmokescreenItem()
{
	local X2AbilityTemplate						Template;
	local X2Effect_Lucu_Garage_TransientWeapon	Effect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Lucu_Garage_SmokescreenItem');

	Template.AbilitySourceName = 'eAbilitySource_Item';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_hunter";

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	
	Effect = new class'X2Effect_Lucu_Garage_TransientWeapon';
	Effect.EffectName = 'Lucu_Garage_SmokescreenItem';
	Effect.BuildPersistentEffect(1, true, false, false);
	Effect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, false);
	Effect.AbilityTemplateName = 'Lucu_Garage_SmokescreenWeapon';
	Effect.ItemTemplateName = 'Lucu_Garage_SmokescreenWeapon';
	Effect.ClipSize = class'X2Item_Lucu_Garage_Utility'.default.Smokescreen_ClipSize;
	Effect.DuplicateResponse = eDupe_Allow;
	Template.AddTargetEffect(Effect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!

	return Template;
}

static function X2DataTemplate SmokescreenWeapon()
{
	local X2AbilityTemplate Template;
	local X2AbilityCost_Ammo AmmoCost;
	local X2AbilityCost_ActionPoints ActionPointCost;
	local X2AbilityMultiTarget_SoldierBonusRadius RadiusMultiTarget;
	local X2Condition_UnitProperty UnitPropertyCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Lucu_Garage_SmokescreenWeapon');
	
	AmmoCost = new class'X2AbilityCost_Ammo';
	AmmoCost.iAmmo = 1;
	Template.AbilityCosts.AddItem(AmmoCost);
	
	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	Template.AbilityCosts.AddItem(ActionPointCost);
	
	Template.AbilitySourceName = 'eAbilitySource_Item';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_HideSpecificErrors;
	Template.HideErrors.AddItem('AA_WeaponIncompatible');
	Template.HideErrors.AddItem('AA_CannotAfford_AmmoCost');
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_grenade_smoke";
	Template.bUseAmmoAsChargesForHUD = true;
	Template.bUseThrownGrenadeEffects = true;
	Template.bDisplayInUITooltip = false;
	Template.bDisplayInUITacticalText = false;
	Template.bRecordValidTiles = true;
	
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	
	RadiusMultiTarget = new class'X2AbilityMultiTarget_SoldierBonusRadius';
	RadiusMultiTarget.bUseWeaponRadius = true;
	RadiusMultiTarget.BonusRadius = default.SmokescreenBonusRadius;
	Template.AbilityMultiTargetStyle = RadiusMultiTarget;
	
	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeDead = true;
	Template.AbilityShooterConditions.AddItem(UnitPropertyCondition);
	
	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeDead = false;
	UnitPropertyCondition.ExcludeFriendlyToSource = false;
	UnitPropertyCondition.ExcludeHostileToSource = false;
	UnitPropertyCondition.FailOnNonUnits = false;
	Template.AbilityMultiTargetConditions.AddItem(UnitPropertyCondition);

	Template.AddShooterEffectExclusions();

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;
	Template.bShowActivation = true;
	Template.bSkipFireAction = false;
	Template.bSkipExitCoverWhenFiring = true;
	Template.CustomFireAnim = 'NO_UtilityItemA';
	Template.CinescriptCameraType = "Sectopod_LightningField";

	return Template;
}


//---------------------------------------------------------------------------------------------------
// Absorption Field
//---------------------------------------------------------------------------------------------------


static function X2DataTemplate AbsorptionField()
{
	local X2AbilityTemplate Template;
	local X2AbilityCost_ActionPoints ActionPointCost;
	local X2AbilityCost_Lucu_Garage_Power PowerCost;
	local X2AbilityCooldown Cooldown;
	local X2AbilityTrigger_PlayerInput InputTrigger;
	local X2Effect_Lucu_Garage_AbsorptionField Effect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Lucu_Garage_AbsorptionField');
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_adventshieldbearer_energyshield";

	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.AbilitySourceName = 'eAbilitySource_Item';
	Template.Hostility = eHostility_Defensive;
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.ARMOR_ACTIVE_PRIORITY;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bFreeCost = true;
	Template.AbilityCosts.AddItem(ActionPointCost);
	
	PowerCost = new class'X2AbilityCost_Lucu_Garage_Power';
	PowerCost.Amount = default.AbsorptionFieldPowerCost;
	Template.AbilityCosts.AddItem(PowerCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.AbsorptionFieldCooldown;
	Template.AbilityCooldown = Cooldown;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;

	InputTrigger = new class'X2AbilityTrigger_PlayerInput';
	Template.AbilityTriggers.AddItem(InputTrigger);

	Effect = new class'X2Effect_Lucu_Garage_AbsorptionField';
	Effect.EffectName = 'Lucu_Garage_AbsorptionField';
	Effect.BuildPersistentEffect(default.AbsorptionFieldDuration, false, true, , eGameRule_PlayerTurnBegin);
	Effect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage);
	Effect.DamageModifier = default.AbsorptionFieldDamageModifier;
	Effect.DuplicateResponse = eDupe_Ignore;
	Template.AddShooterEffect(Effect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.CustomFireAnim = 'NO_UtilityItemA';
	Template.CinescriptCameraType = "Sectopod_LightningField";
	
	return Template;
}


//---------------------------------------------------------------------------------------------------
// Shield Generator
//---------------------------------------------------------------------------------------------------


static function X2DataTemplate ShieldGenerator()
{
	local X2AbilityTemplate Template;
	local X2AbilityCost_ActionPoints ActionPointCost;
	local X2AbilityCost_Lucu_Garage_Power PowerCost;
	local X2AbilityCooldown Cooldown;
	local X2AbilityTrigger_PlayerInput InputTrigger;
	local X2Effect_Lucu_Garage_PersistentStatChange ShieldedEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Lucu_Garage_ShieldGenerator');
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_adventshieldbearer_energyshield";

	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.AbilitySourceName = 'eAbilitySource_Item';
	Template.Hostility = eHostility_Defensive;
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.ARMOR_ACTIVE_PRIORITY;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = default.ShieldGeneratorActionPoints;
	Template.AbilityCosts.AddItem(ActionPointCost);
	
	PowerCost = new class'X2AbilityCost_Lucu_Garage_Power';
	PowerCost.Amount = default.ShieldGeneratorPowerCost;
	Template.AbilityCosts.AddItem(PowerCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.ShieldGeneratorCooldown;
	Template.AbilityCooldown = Cooldown;

	// Can't use while dead
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	// Add dead eye to guarantee
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;

	InputTrigger = new class'X2AbilityTrigger_PlayerInput';
	Template.AbilityTriggers.AddItem(InputTrigger);

	ShieldedEffect = new class'X2Effect_Lucu_Garage_PersistentStatChange';
	ShieldedEffect.EffectName = 'Lucu_Garage_ShieldGenerator';
	ShieldedEffect.BuildPersistentEffect(default.ShieldGeneratorDuration, false, true, , eGameRule_PlayerTurnBegin);
	ShieldedEffect.SetDisplayInfo(ePerkBuff_Bonus, default.ShieldedFriendlyName, default.ShieldedLongDescription, "img:///UILibrary_PerkIcons.UIPerk_adventshieldbearer_energyshield", true);
	ShieldedEffect.AddPersistentStatChange(eStat_ShieldHP, default.ShieldGeneratorShieldBase, false);
	ShieldedEffect.AddPersistentStatChange(eStat_ShieldHP, default.ShieldGeneratorShield, true);
	ShieldedEffect.DuplicateResponse = eDupe_Ignore;
	ShieldedEffect.EffectRemovedVisualizationFn = OnShieldRemoved_BuildVisualization;
	Template.AddShooterEffect(ShieldedEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.CustomFireAnim = 'NO_UtilityItemA';
	Template.CinescriptCameraType = "Sectopod_LightningField";
	
	return Template;
}

simulated function OnShieldRemoved_BuildVisualization(XComGameState VisualizeGameState, out VisualizationTrack BuildTrack, const name EffectApplyResult)
{
	local X2Action_PlaySoundAndFlyOver SoundAndFlyOver;

	if (XGUnit(BuildTrack.TrackActor).IsAlive())
	{
		SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTrack(BuildTrack, VisualizeGameState.GetContext()));
		SoundAndFlyOver.SetSoundAndFlyOverParameters(None, class'XLocalizedData'.default.ShieldRemovedMsg, '', eColor_Bad, , 0.75, true);
	}
}

simulated function Shielded_BuildVisualization(XComGameState VisualizeGameState, out array<VisualizationTrack> OutVisualizationTracks)
{
	local XComGameStateHistory History;
	local XComGameStateContext_Ability  Context;
	local StateObjectReference InteractingUnitRef;
	local VisualizationTrack EmptyTrack;
	local VisualizationTrack BuildTrack;
	local X2Action_PlayAnimation PlayAnimationAction;

	History = `XCOMHISTORY;

	Context = XComGameStateContext_Ability(VisualizeGameState.GetContext());
	InteractingUnitRef = Context.InputContext.SourceObject;

	//Configure the visualization track for the shooter
	//****************************************************************************************
	BuildTrack = EmptyTrack;
	BuildTrack.StateObject_OldState = History.GetGameStateForObjectID(InteractingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
	BuildTrack.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(InteractingUnitRef.ObjectID);
	BuildTrack.TrackActor = History.GetVisualizer(InteractingUnitRef.ObjectID);

	PlayAnimationAction = X2Action_PlayAnimation(class'X2Action_PlayAnimation'.static.AddToVisualizationTrack(BuildTrack, Context));
	PlayAnimationAction.Params.AnimName = 'HL_EnergyShield';

	OutVisualizationTracks.AddItem(BuildTrack);
}
