class X2Ability_Beags_Escalation_RocketeerAbilitySet extends X2Ability
	config(Beags_Escalation_Ability);

var config int RocketMobilityPenalty;
var config array<int> HEATWarheadsArmorPierce;
var config int FireInTheHoleAimBonus;
var config float FireInTheHoleRangeBonus;
var config float JavelinRocketsRangeModifier;
var config float SnapshotRangeBonus;
var config float WeaponsTeamRange;
var config float WeaponsTeamRangeBonus;

var name RocketMobilityPenaltyAbilityName;
var name RocketMobilityPenaltyEffectName;
var name RocketLauncherMovementPenaltyAbilityName;
var name RocketLauncherMovementPenaltyEffectName;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;
	
	Templates.Length = 0;
	Templates.AddItem(LaunchRocket());
	Templates.AddItem(RocketMobilityPenaltyAbility());
	Templates.AddItem(RocketLauncherMovementPenaltyAbility());
	Templates.AddItem(ExtraHERocket());
	Templates.AddItem(HEATWarheads());
	Templates.AddItem(FireInTheHole());
	Templates.AddItem(ExtraShredderRocket());
	Templates.AddItem(JavelinRockets());
	Templates.AddItem(LaunchBunkerBuster());
	Templates.AddItem(ExtraBunkerBuster());
	Templates.AddItem(RocketSnapshot());
	Templates.AddItem(WeaponsTeam());

	return Templates;
}


//---------------------------------------------------------------------------------------------------
// Launch Rocket
//---------------------------------------------------------------------------------------------------


static function X2DataTemplate LaunchRocket()
{
	local X2AbilityTemplate									Template;
	local X2AbilityCost_Ammo								AmmoCost;
	local X2AbilityCost_ActionPoints						ActionPointCost;
	local X2AbilityToHitCalc_Beags_Escalation_Rocket		RocketAim;
	local X2AbilityTarget_Beags_Escalation_Rocket			RocketTarget;
	local X2AbilityMultiTarget_Beags_Escalation_ItemRadius	RadiusMultiTarget;
	local X2Condition_Beags_Escalation_AbilitySourceWeapon	RocketCondition;
	local X2Condition_UnitProperty							UnitPropertyCondition;
	local X2Condition_AbilitySourceWeapon					GrenadeCondition;
	local X2Effect_Beags_Escalation_RemoveEffect			RemoveEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Beags_Escalation_LaunchRocket');

	AmmoCost = new class'X2AbilityCost_Ammo';	
	AmmoCost.iAmmo = 1;
	AmmoCost.UseLoadedAmmo = true;
	Template.AbilityCosts.AddItem(AmmoCost);
	
	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	ActionPointCost.DoNotConsumeAllSoldierAbilities.AddItem('Salvo');
	Template.AbilityCosts.AddItem(ActionPointCost);
	
	RocketAim = new class'X2AbilityToHitCalc_Beags_Escalation_Rocket';
	Template.AbilityToHitCalc = RocketAim;
	
	Template.bUseLaunchedGrenadeEffects = true;
	Template.bHideAmmoWeaponDuringFire = true; // Hide the rocket
	
	RocketTarget = new class'X2AbilityTarget_Beags_Escalation_Rocket';
	RocketTarget.bRestrictToWeaponRange = true;
	Template.AbilityTargetStyle = RocketTarget;

	RadiusMultiTarget = new class'X2AbilityMultiTarget_Beags_Escalation_ItemRadius';
	RadiusMultiTarget.bUseWeaponRadius = true;
	RadiusMultiTarget.SoldierAbilityNames.AddItem('VolatileMix');
	RadiusMultiTarget.SoldierAbilityNames.AddItem(class'X2Ability_Beags_Escalation_CommonAbilitySet'.default.DangerZoneAbilityName);
	RadiusMultiTarget.BonusRadii.AddItem(class'X2Ability_GrenadierAbilitySet'.default.VOLATILE_RADIUS);
	RadiusMultiTarget.BonusRadii.AddItem(`UNITSTOTILES(class'X2Ability_Beags_Escalation_CommonAbilitySet'.default.DangerZoneExplosiveRadiusBonus));
	Template.AbilityMultiTargetStyle = RadiusMultiTarget;

	RocketCondition = new class'X2Condition_Beags_Escalation_AbilitySourceWeapon';
	RocketCondition.MatchWeaponCat = 'beags_escalation_rocket';
	Template.AbilityShooterConditions.AddItem(RocketCondition);

	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeDead = true;
	Template.AbilityShooterConditions.AddItem(UnitPropertyCondition);

	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeDead = false;
	UnitPropertyCondition.ExcludeFriendlyToSource = false;
	UnitPropertyCondition.ExcludeHostileToSource = false;
	Template.AbilityMultiTargetConditions.AddItem(UnitPropertyCondition);

	GrenadeCondition = new class'X2Condition_AbilitySourceWeapon';
	GrenadeCondition.CheckGrenadeFriendlyFire = true;
	Template.AbilityMultiTargetConditions.AddItem(GrenadeCondition);

	// Cleanse one instance of the mobility penalty for each rocket fired
	RemoveEffect = new class'X2Effect_Beags_Escalation_RemoveEffect';
	RemoveEffect.EffectNameToRemove = default.RocketMobilityPenaltyEffectName;
	RemoveEffect.bMatchTargetToTarget = true;
	Template.AddShooterEffect(RemoveEffect);

	Template.AddShooterEffectExclusions();

	Template.bRecordValidTiles = true;

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_HideSpecificErrors;
	Template.HideErrors.AddItem('AA_CannotAfford_AmmoCost');
	Template.HideErrors.AddItem('AA_WeaponIncompatible');
	Template.IconImage = "img:///UILibrary_Beags_Escalation_Icons.UIPerk_firerocket";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.STANDARD_GRENADE_PRIORITY;
	Template.bUseAmmoAsChargesForHUD = true;
	Template.bDisplayInUITooltip = false;
	Template.bDisplayInUITacticalText = false;

	// Scott W says a Launcher VO cue doesn't exist, so I should use this one.  mdomowicz 2015_08_24
	Template.ActivationSpeech = 'ThrowGrenade';

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.DamagePreviewFn = class'X2Ability_Grenades'.static.GrenadeDamagePreview;
	Template.TargetingMethod = class'X2TargetingMethod_Beags_Escalation_Rocket';
	Template.CinescriptCameraType = "Grenadier_GrenadeLauncher";

	// This action is considered 'hostile' and can be interrupted!
	Template.Hostility = eHostility_Offensive;
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;	

	return Template;
}


//---------------------------------------------------------------------------------------------------
// Rocket Launcher Movement Penalty
//---------------------------------------------------------------------------------------------------


static function X2AbilityTemplate RocketLauncherMovementPenaltyAbility()
{
	local X2AbilityTemplate										Template;
	local X2Effect_Beags_Escalation_RocketRangeModifySnapshot	SnapshotEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, default.RocketLauncherMovementPenaltyAbilityName);

	Template.AbilitySourceName = 'eAbilitySource_Item';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.bDisplayInUITacticalText = false;
	
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	
	// The standard, weapon-based movement penalty for rocket launchers
	SnapshotEffect = new class'X2Effect_Beags_Escalation_RocketRangeModifySnapshot';
	SnapshotEffect.EffectName = default.RocketLauncherMovementPenaltyEffectName;
	SnapshotEffect.BuildPersistentEffect(1, true, false);
	SnapshotEffect.DuplicateResponse = eDupe_Ignore;
	SnapshotEffect.UseWeaponRangeModifier = true;
	Template.AddTargetEffect(SnapshotEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;	
}


//---------------------------------------------------------------------------------------------------
// Rocket Mobility Penalty
//---------------------------------------------------------------------------------------------------


static function X2AbilityTemplate RocketMobilityPenaltyAbility()
{
	local X2AbilityTemplate                 Template;	
	local X2Effect_PersistentStatChange		StatChangeEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, default.RocketMobilityPenaltyAbilityName);

	Template.AbilitySourceName = 'eAbilitySource_Item';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.bDisplayInUITacticalText = false;
	
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	
	StatChangeEffect = new class'X2Effect_PersistentStatChange';
	StatChangeEffect.EffectName = default.RocketMobilityPenaltyEffectName;
	StatChangeEffect.BuildPersistentEffect(1, true, false);
	StatChangeEffect.AddPersistentStatChange(eStat_Mobility, -1*default.RocketMobilityPenalty);
	StatChangeEffect.DuplicateResponse = eDupe_Allow;
	Template.AddTargetEffect(StatChangeEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;	
}


//---------------------------------------------------------------------------------------------------
// Extra Rocket
//---------------------------------------------------------------------------------------------------


static function X2AbilityTemplate ExtraHERocket()
{
	local X2AbilityTemplate									Template;
	local X2Effect_PersistentStatChange						StatChangeEffect;
	local X2Effect_Beags_Escalation_TransientUtilityItem	TransientItemEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Beags_Escalation_ExtraHERocket');

	Template.AdditionalAbilities.AddItem('Beags_Escalation_LaunchRocket');

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_Beags_Escalation_Icons.UIPerk_firerocket";

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	// Expand the unit's utility items to allow the transient item. This goes before the transient item effect
	StatChangeEffect = new class'X2Effect_PersistentStatChange';
	StatChangeEffect.EffectName = 'Beags_Escalation_TransientExtraHERocketUtilitySlot';
	StatChangeEffect.BuildPersistentEffect(1, true, false);
	StatChangeEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, false,,Template.AbilitySourceName);
	StatChangeEffect.DuplicateResponse = eDupe_Allow;
	StatChangeEffect.AddPersistentStatChange(eStat_UtilityItems, 1); // Can't think of any clever way to make this value based on the item template, so I'll just hardcode the item size for now
	Template.AddTargetEffect(StatChangeEffect);

	TransientItemEffect = new class'X2Effect_Beags_Escalation_TransientUtilityItem';
	TransientItemEffect.EffectName = 'Beags_Escalation_TransientExtraHERocket';
	TransientItemEffect.BuildPersistentEffect(1, true, false);
	TransientItemEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, false,,Template.AbilitySourceName);
	TransientItemEffect.DuplicateResponse = eDupe_Allow;
	TransientItemEffect.AbilityTemplateName = 'Beags_Escalation_LaunchRocket';
	TransientItemEffect.ItemTemplateName = 'Beags_Escalation_Rocket_HighExplosive';
	TransientItemEffect.UseItemAsAmmo = true;
	Template.AddTargetEffect(TransientItemEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!
	
	return Template;
}


//---------------------------------------------------------------------------------------------------
// HEAT Warheads
//---------------------------------------------------------------------------------------------------


static function X2DataTemplate HEATWarheads()
{
	local X2AbilityTemplate							Template;
	local X2Effect_Beags_Escalation_HEATAmmo		HEATEffect;
	local int										i;

	for (i = 0; i < default.HEATWarheadsArmorPierce.Length; i++)
		`LOG("Beags Escalation: HEAT Warheads tech level " @ string(i) @ " armor pierce=" @ string(default.HEATWarheadsArmorPierce[i]));
	
	`CREATE_X2ABILITY_TEMPLATE(Template, 'Beags_Escalation_HEATWarheads');
	
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_Beags_Escalation_Icons.UIPerk_heatammo";

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	HEATEffect = new class'X2Effect_Beags_Escalation_HEATAmmo';
	HEATEffect.BuildPersistentEffect(1, true, false);
	HEATEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage,,,Template.AbilitySourceName);
	HEATEffect.MatchWeaponCat = 'beags_escalation_rocket';
	Template.AddTargetEffect(HEATEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!

	return Template;
}


//---------------------------------------------------------------------------------------------------
// Fire in the Hole
//---------------------------------------------------------------------------------------------------


static function X2DataTemplate FireInTheHole()
{
	local X2AbilityTemplate										Template;
	local X2Condition_UnitValue									NoMoveCondition;
	local X2Condition_Beags_Escalation_SourceUnitValue			NoMoveSourceCondition;
	local X2Condition_Beags_Escalation_AbilitySourceWeapon		RocketLauncherCondition;
	local X2Effect_Beags_Escalation_RocketRangeModifyFlat		RangeEffect;
	local X2Effect_ToHitModifier								ToHitEffect;
	
	`LOG("Beags Escalation: Fire in the Hole bonus aim=" @ string(default.FireInTheHoleAimBonus));
	`LOG("Beags Escalation: Fire in the Hole bonus range=" @ string(default.FireInTheHoleRangeBonus));

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Beags_Escalation_FireInTheHole');
	
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_Beags_Escalation_Icons.UIPerk_fireinthehole";

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;

	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	RangeEffect = new class'X2Effect_Beags_Escalation_RocketRangeModifyFlat';
	RangeEffect.EffectName = 'Beags_Escalation_FireInTheHoleRange';
	RangeEffect.DuplicateResponse = eDupe_Ignore;
	RangeEffect.BuildPersistentEffect(1, true, false);
	RangeEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage,,,Template.AbilitySourceName);
	RangeEffect.RangeModifier = `UNITSTOTILES(default.FireInTheHoleRangeBonus);
	NoMoveCondition = new class'X2Condition_UnitValue';
	NoMoveCondition.AddCheckValue('MovesThisTurn', 0, eCheck_Exact);
	RangeEffect.ApplyRangeModifierConditions.AddItem(NoMoveCondition);
	Template.AddTargetEffect(RangeEffect);

	ToHitEffect = new class'X2Effect_ToHitModifier';
	ToHitEffect.EffectName = 'Beags_Escalation_FireInTheHoleAim';
	ToHitEffect.DuplicateResponse = eDupe_Ignore;
	ToHitEffect.BuildPersistentEffect(1, true, false);
	ToHitEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, false,,Template.AbilitySourceName);
	ToHitEffect.AddEffectHitModifier(eHit_Success, default.FireInTheHoleAimBonus, Template.LocFriendlyName);
	NoMoveSourceCondition = new class'X2Condition_Beags_Escalation_SourceUnitValue';
	NoMoveSourceCondition.AddCheckValue('MovesThisTurn', 0, eCheck_Exact);
	ToHitEffect.ToHitConditions.AddItem(NoMoveSourceCondition);
	RocketLauncherCondition = new class'X2Condition_Beags_Escalation_AbilitySourceWeapon';
	RocketLauncherCondition.MatchWeaponCat = 'beags_escalation_rocket';
	ToHitEffect.ToHitConditions.AddItem(RocketLauncherCondition);
	Template.AddTargetEffect(ToHitEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!

	return Template;
}


//---------------------------------------------------------------------------------------------------
// Shredder Rocket
//---------------------------------------------------------------------------------------------------


static function X2AbilityTemplate ExtraShredderRocket()
{
	local X2AbilityTemplate									Template;
	local X2AbilityTargetStyle								TargetStyle;
	local X2AbilityTrigger									Trigger;
	local X2Effect_PersistentStatChange						StatChangeEffect;
	local X2Effect_Beags_Escalation_TransientUtilityItem	TransientItemEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Beags_Escalation_ExtraShredderRocket');

	Template.AdditionalAbilities.AddItem('Beags_Escalation_LaunchRocket');

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_Beags_Escalation_Icons.UIPerk_shredderrocket";

	Template.AbilityToHitCalc = default.DeadEye;

	TargetStyle = new class'X2AbilityTarget_Self';
	Template.AbilityTargetStyle = TargetStyle;

	Trigger = new class'X2AbilityTrigger_UnitPostBeginPlay';
	Template.AbilityTriggers.AddItem(Trigger);

	// Expand the unit's utility items to allow the transient item. This goes before the transient item effect
	StatChangeEffect = new class'X2Effect_PersistentStatChange';
	StatChangeEffect.EffectName = 'Beags_Escalation_TransientExtraShredderRocketUtilitySlot';
	StatChangeEffect.BuildPersistentEffect(1, true, false);
	StatChangeEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, false,,Template.AbilitySourceName);
	StatChangeEffect.DuplicateResponse = eDupe_Allow;
	StatChangeEffect.AddPersistentStatChange(eStat_UtilityItems, 1); // Can't think of any clever way to make this value based on the item template, so I'll just hardcode the item size for now
	Template.AddTargetEffect(StatChangeEffect);

	TransientItemEffect = new class'X2Effect_Beags_Escalation_TransientUtilityItem';
	TransientItemEffect.EffectName = 'Beags_Escalation_TransientExtraShredderRocket';
	TransientItemEffect.BuildPersistentEffect(1, true, false);
	TransientItemEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, false,,Template.AbilitySourceName);
	TransientItemEffect.DuplicateResponse = eDupe_Allow;
	TransientItemEffect.AbilityTemplateName = 'Beags_Escalation_LaunchRocket';
	TransientItemEffect.ItemTemplateName = 'Beags_Escalation_Rocket_Shredder';
	TransientItemEffect.UseItemAsAmmo = true;
	Template.AddTargetEffect(TransientItemEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!
	
	return Template;
}


//---------------------------------------------------------------------------------------------------
// Javelin Rockets
//---------------------------------------------------------------------------------------------------


static function X2DataTemplate JavelinRockets()
{
	local X2AbilityTemplate										Template;
	local X2Effect_Beags_Escalation_RocketRangeModifyPercent	RangeEffect;

	`LOG("Beags Escalation: Javelin Rockets range modifier=" @ string(default.JavelinRocketsRangeModifier));
	
	`CREATE_X2ABILITY_TEMPLATE(Template, 'Beags_Escalation_JavelinRockets');
	
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_Beags_Escalation_Icons.UIPerk_javelinrockets";

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	
	RangeEffect = new class'X2Effect_Beags_Escalation_RocketRangeModifyPercent';
	RangeEffect.EffectName = 'Beags_Escalation_JavelinRocketsRange';
	RangeEffect.DuplicateResponse = eDupe_Ignore;
	RangeEffect.BuildPersistentEffect(1, true, false);
	RangeEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage,,,Template.AbilitySourceName);
	RangeEffect.RangeModifier = default.JavelinRocketsRangeModifier;
	Template.AddTargetEffect(RangeEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!

	return Template;
}


//---------------------------------------------------------------------------------------------------
// Launch Bunker Buster
//---------------------------------------------------------------------------------------------------


static function X2DataTemplate LaunchBunkerBuster()
{
	local X2AbilityTemplate										Template;
	local X2AbilityCost_Ammo									AmmoCost;
	local X2AbilityCost_ActionPoints							ActionPointCost;
	local X2AbilityToHitCalc_Beags_Escalation_Rocket			RocketAim;
	local X2AbilityTarget_Beags_Escalation_Rocket				RocketTarget;
	local X2AbilityMultiTarget_Beags_Escalation_ItemRadius		RocketMultiTarget;
	local X2Condition_Beags_Escalation_AbilitySourceWeapon		RocketCondition;
	local X2Condition_UnitProperty								UnitPropertyCondition;
	local X2Condition_AbilitySourceWeapon						GrenadeCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Beags_Escalation_LaunchBunkerBuster');
	
	Template.AdditionalAbilities.AddItem('Beags_Escalation_ExtraBunkerBuster');

	AmmoCost = new class'X2AbilityCost_Ammo';	
	AmmoCost.iAmmo = 1;
	AmmoCost.UseLoadedAmmo = true;
	Template.AbilityCosts.AddItem(AmmoCost);
	
	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	ActionPointCost.DoNotConsumeAllSoldierAbilities.AddItem('Salvo');
	Template.AbilityCosts.AddItem(ActionPointCost);
	
	RocketAim = new class'X2AbilityToHitCalc_Beags_Escalation_Rocket';
	Template.AbilityToHitCalc = RocketAim;
	
	Template.bUseLaunchedGrenadeEffects = true;
	Template.bHideAmmoWeaponDuringFire = true; // Hide the rocket
	
	RocketTarget = new class'X2AbilityTarget_Beags_Escalation_Rocket';
	RocketTarget.bRestrictToWeaponRange = true;
	Template.AbilityTargetStyle = RocketTarget;

	RocketMultiTarget = new class'X2AbilityMultiTarget_Beags_Escalation_ItemRadius';
	RocketMultiTarget.bIgnoreBlockingCover = true;
	RocketMultiTarget.bUseWeaponRadius = true;
	RocketMultiTarget.SoldierAbilityNames.AddItem('VolatileMix');
	RocketMultiTarget.SoldierAbilityNames.AddItem(class'X2Ability_Beags_Escalation_CommonAbilitySet'.default.DangerZoneAbilityName);
	RocketMultiTarget.BonusRadii.AddItem(class'X2Ability_GrenadierAbilitySet'.default.VOLATILE_RADIUS);
	RocketMultiTarget.BonusRadii.AddItem(`UNITSTOTILES(class'X2Ability_Beags_Escalation_CommonAbilitySet'.default.DangerZoneExplosiveRadiusBonus));
	Template.AbilityMultiTargetStyle = RocketMultiTarget;

	RocketCondition = new class'X2Condition_Beags_Escalation_AbilitySourceWeapon';
	RocketCondition.MatchWeaponCat = 'beags_escalation_bunkerbuster';
	Template.AbilityShooterConditions.AddItem(RocketCondition);

	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeDead = true;
	Template.AbilityShooterConditions.AddItem(UnitPropertyCondition);

	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeDead = false;
	UnitPropertyCondition.ExcludeFriendlyToSource = false;
	UnitPropertyCondition.ExcludeHostileToSource = false;
	Template.AbilityMultiTargetConditions.AddItem(UnitPropertyCondition);

	GrenadeCondition = new class'X2Condition_AbilitySourceWeapon';
	GrenadeCondition.CheckGrenadeFriendlyFire = true;
	Template.AbilityMultiTargetConditions.AddItem(GrenadeCondition);

	Template.AddShooterEffectExclusions();

	Template.bRecordValidTiles = true;

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_HideSpecificErrors;
	Template.HideErrors.AddItem('AA_CannotAfford_AmmoCost');
	Template.HideErrors.AddItem('AA_WeaponIncompatible');
	Template.IconImage = "img:///UILibrary_Beags_Escalation_Icons.UIPerk_bunkerbuster";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.STANDARD_GRENADE_PRIORITY;
	Template.bUseAmmoAsChargesForHUD = true;
	Template.bDisplayInUITooltip = false;
	Template.bDisplayInUITacticalText = false;

	// Scott W says a Launcher VO cue doesn't exist, so I should use this one.  mdomowicz 2015_08_24
	Template.ActivationSpeech = 'ThrowGrenade';

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.DamagePreviewFn = class'X2Ability_Grenades'.static.GrenadeDamagePreview;
	Template.TargetingMethod = class'X2TargetingMethod_Beags_Escalation_BunkerBuster';
	Template.CinescriptCameraType = "Grenadier_GrenadeLauncher";

	// This action is considered 'hostile' and can be interrupted!
	Template.Hostility = eHostility_Offensive;
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;	

	return Template;
}


//---------------------------------------------------------------------------------------------------
// Extra Bunker Buster
//---------------------------------------------------------------------------------------------------


static function X2AbilityTemplate ExtraBunkerBuster()
{
	local X2AbilityTemplate									Template;
	local X2AbilityTargetStyle								TargetStyle;
	local X2AbilityTrigger									Trigger;
	local X2Effect_PersistentStatChange						StatChangeEffect;
	local X2Effect_Beags_Escalation_TransientUtilityItem	TransientItemEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Beags_Escalation_ExtraBunkerBuster');

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_Beags_Escalation_Icons.UIPerk_bunkerbuster";

	Template.AbilityToHitCalc = default.DeadEye;

	TargetStyle = new class'X2AbilityTarget_Self';
	Template.AbilityTargetStyle = TargetStyle;

	Trigger = new class'X2AbilityTrigger_UnitPostBeginPlay';
	Template.AbilityTriggers.AddItem(Trigger);

	// Expand the unit's utility items to allow the transient item. This goes before the transient item effect
	StatChangeEffect = new class'X2Effect_PersistentStatChange';
	StatChangeEffect.EffectName = 'Beags_Escalation_TransientExtraBunkerBusterUtilitySlot';
	StatChangeEffect.BuildPersistentEffect(1, true, false);
	StatChangeEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, false,,Template.AbilitySourceName);
	StatChangeEffect.DuplicateResponse = eDupe_Allow;
	StatChangeEffect.AddPersistentStatChange(eStat_UtilityItems, 1); // Can't think of any clever way to make this value based on the item template, so I'll just hardcode the item size for now
	Template.AddTargetEffect(StatChangeEffect);

	TransientItemEffect = new class'X2Effect_Beags_Escalation_TransientUtilityItem';
	TransientItemEffect.EffectName = 'Beags_Escalation_TransientExtraBunkerBuster';
	TransientItemEffect.BuildPersistentEffect(1, true, false);
	TransientItemEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, false,,Template.AbilitySourceName);
	TransientItemEffect.DuplicateResponse = eDupe_Allow;
	TransientItemEffect.AbilityTemplateName = 'Beags_Escalation_LaunchBunkerBuster';
	TransientItemEffect.ItemTemplateName = 'Beags_Escalation_Rocket_BunkerBuster';
	TransientItemEffect.UseItemAsAmmo = true;
	Template.AddTargetEffect(TransientItemEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!
	
	return Template;
}


//---------------------------------------------------------------------------------------------------
// Snapshot (Rocketeer)
//---------------------------------------------------------------------------------------------------


static function X2AbilityTemplate RocketSnapshot()
{
	local X2AbilityTemplate										Template;
	local X2AbilityTargetStyle									TargetStyle;
	local X2AbilityTrigger										Trigger;
	local X2Effect_Beags_Escalation_RocketRangeModifySnapshot	RangeEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Beags_Escalation_RocketSnapshot');
	
	`LOG("Beags Escalation: Snapshot (Rocketeer) range bonus=" @ string(default.SnapshotRangeBonus));
	
	Template.bDontDisplayInAbilitySummary = true;
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_Beags_Escalation_Icons.UIPerk_snapshot";

	Template.AbilityToHitCalc = default.DeadEye;

	TargetStyle = new class'X2AbilityTarget_Self';
	Template.AbilityTargetStyle = TargetStyle;

	Trigger = new class'X2AbilityTrigger_UnitPostBeginPlay';
	Template.AbilityTriggers.AddItem(Trigger);
	
	RangeEffect = new class'X2Effect_Beags_Escalation_RocketRangeModifySnapshot';
	RangeEffect.EffectName = 'Beags_Escalation_RocketSnapshotRange';
	RangeEffect.DuplicateResponse = eDupe_Ignore;
	RangeEffect.BuildPersistentEffect(1, true, false);
	RangeEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage,,,Template.AbilitySourceName);
	RangeEffect.DuplicateResponse = eDupe_Ignore;
	RangeEffect.RangeModifier = `UNITSTOTILES(default.SnapshotRangeBonus);
	Template.AddTargetEffect(RangeEffect);
	
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!

	return Template;
}


//---------------------------------------------------------------------------------------------------
// Weapons Team
//---------------------------------------------------------------------------------------------------


static function X2AbilityTemplate WeaponsTeam()
{
	local X2AbilityTemplate										Template;
	local X2AbilityCost_ActionPoints							ActionPointCost;
	local array<name>											SkipExclusions;
	local EffectReason											ExcludeEffectReason;
	local X2Condition_UnitEffects								ExcludeEffectsCondition;
	local X2Condition_Beags_Escalation_TargetAbilityProperty	AbilityPropertyCondition;
	local X2Condition_UnitProperty								UnitPropertyCondition;
	local X2Condition_Beags_Escalation_CostlyAction				CostlyActionCondition;
	local X2Effect_Beags_Escalation_WeaponsTeam					RangeEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Beags_Escalation_WeaponsTeam');
	
	`LOG("Beags Escalation: Weapons Team range=" @ string(default.WeaponsTeamRange));
	`LOG("Beags Escalation: Weapons Team range bonus=" @ string(default.WeaponsTeamRangeBonus));
	
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.STANDARD_GRENADE_PRIORITY;
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_Beags_Escalation_Icons.UIPerk_weaponsteam";
	
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

	ExcludeEffectsCondition = new class'X2Condition_UnitEffects';
	ExcludeEffectReason.EffectName = 'Beags_Escalation_WeaponsTeam';
	ExcludeEffectReason.Reason = 'AA_UnitIsImmune';
	ExcludeEffectsCondition.ExcludeEffects.AddItem(ExcludeEffectReason);
	Template.AbilityTargetConditions.AddItem(ExcludeEffectsCondition);

	AbilityPropertyCondition = new class'X2Condition_Beags_Escalation_TargetAbilityProperty';
	AbilityPropertyCondition.TargetHasSoldierAbilities.AddItem('Beags_Escalation_LaunchRocket');
	Template.AbilityTargetConditions.AddItem(AbilityPropertyCondition);
	
	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeDead = true;
	UnitPropertyCondition.ExcludeAlive = false;
	UnitPropertyCondition.ExcludeHostileToSource = true;
	UnitPropertyCondition.ExcludeFriendlyToSource = false;
	UnitPropertyCondition.RequireSquadmates = true;
	UnitPropertyCondition.RequireWithinRange = true;
	UnitPropertyCondition.WithinRange = default.WeaponsTeamRange;
	Template.AbilityTargetConditions.AddItem(UnitPropertyCondition);

	CostlyActionCondition = new class'X2Condition_Beags_Escalation_CostlyAction';
	CostlyActionCondition.UnitTookCostlyAction = true;
	Template.AbilityTargetConditions.AddItem(CostlyActionCondition);

	RangeEffect = new class'X2Effect_Beags_Escalation_WeaponsTeam';
	RangeEffect.EffectName = 'Beags_Escalation_WeaponsTeam';
	RangeEffect.DuplicateResponse = eDupe_Ignore;
	RangeEffect.BuildPersistentEffect(1, true, false);
	RangeEffect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage,,,Template.AbilitySourceName);
	RangeEffect.DuplicateResponse = eDupe_Ignore;
	RangeEffect.RangeModifier = `UNITSTOTILES(default.WeaponsTeamRangeBonus);
	Template.AddTargetEffect(RangeEffect);
	
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_ShowIfAvailable;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = class'X2Ability_DefaultAbilitySet'.static.InteractAbility_BuildVisualization;

	return Template;
}

DefaultProperties
{
	RocketMobilityPenaltyAbilityName="Beags_Escalation_RocketMobilityPenalty"
	RocketMobilityPenaltyEffectName="Beags_Escalation_RocketMobilityPenalty"
	RocketLauncherMovementPenaltyAbilityName="Beags_Escalation_RocketLauncherMovementPenalty"
	RocketLauncherMovementPenaltyEffectName="Beags_Escalation_RocketLauncherMovementPenalty"
}