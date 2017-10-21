class X2Character_DLC_Day90Characters extends X2Character config(GameData_CharacterStats);
const FERAL_MEC_GROUP_NAME = 'FeralMEC';

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem(CreateTemplate_SparkSoldier());
	
	// Lost Towers SPARK
	Templates.AddItem(CreateTemplate_LostTowersSpark());

	// Feral MECs
	Templates.AddItem(CreateTemplate_FeralMEC_M1());

	// Markov's Sectopod
	Templates.AddItem(CreateTemplate_MarkovSectopod());

	// Lost Towers Turret
	Templates.AddItem(CreateTemplate_LostTowersTurretMk1());

	// Shen for Lost Towers Mission
	Templates.AddItem(CreateTemplate_LostTowersShen());
	Templates.AddItem(CreateRovRTemplate());

	//  Spark BITs (cosmetic units like the gremlin)
	Templates.AddItem(CreateSparkBitMk1Template());
	Templates.AddItem(CreateSparkBitMk2Template());
	Templates.AddItem(CreateSparkBitMk3Template());

	// Speaker templates for DLC3
	Templates.AddItem(CreateDLC3SpeakerTemplate('JulianUnknown', "Intercom", "img:///UILibrary_Common.Head_Empty"));
	Templates.AddItem(CreateDLC3SpeakerTemplate('Julian', "Julian", "img:///UILibrary_DLC3Images.Head_Julian"));
	Templates.AddItem(CreateDLC3SpeakerTemplate('JulianSectopod', "Julian", "img:///UILibrary_DLC3Images.Head_Julian2"));
	Templates.AddItem(CreateDLC3SpeakerTemplate('SPARK', "SPARK", "img:///UILibrary_DLC3Images.Head_Spark"));
	
	return Templates;
}

static function X2SparkCharacterTemplate_DLC_3 CreateTemplate_SparkSoldier()
{
	local X2SparkCharacterTemplate_DLC_3 CharTemplate;

	`CREATE_X2TEMPLATE(class'X2SparkCharacterTemplate_DLC_3', CharTemplate, 'SparkSoldier');
	CharTemplate.UnitSize = 1;
	CharTemplate.UnitHeight = 3;
	CharTemplate.BehaviorClass = class'XGAIBehavior';
	CharTemplate.bCanUse_eTraversal_Normal = true;
	CharTemplate.bCanUse_eTraversal_ClimbOver = true;
	CharTemplate.bCanUse_eTraversal_ClimbOnto = true;
	CharTemplate.bCanUse_eTraversal_ClimbLadder = false;
	CharTemplate.bCanUse_eTraversal_DropDown = true;
	CharTemplate.bCanUse_eTraversal_Grapple = false;
	CharTemplate.bCanUse_eTraversal_Landing = true;
	CharTemplate.bCanUse_eTraversal_BreakWindow = true;
	CharTemplate.bCanUse_eTraversal_KickDoor = true;
	CharTemplate.bCanUse_eTraversal_JumpUp = true;
	CharTemplate.bCanUse_eTraversal_WallClimb = false;
	CharTemplate.bCanUse_eTraversal_BreakWall = false;
	CharTemplate.bCanBeCriticallyWounded = false;
	CharTemplate.bCanBeTerrorist = false;
	CharTemplate.bDiesWhenCaptured = true;
	CharTemplate.bAppearanceDefinesPawn = true;
	CharTemplate.bIsAfraidOfFire = true;
	CharTemplate.bIsAlien = false;
	CharTemplate.bIsCivilian = false;
	CharTemplate.bIsPsionic = false;
	CharTemplate.bIsRobotic = true;
	CharTemplate.bIsSoldier = true;
	CharTemplate.bCanTakeCover = false;
	CharTemplate.bCanBeCarried = false;
	CharTemplate.bCanBeRevived = false;
	CharTemplate.bUsePoolSoldiers = true;
	CharTemplate.bIsTooBigForArmory = true;
	CharTemplate.bStaffingAllowed = true;
	CharTemplate.bAppearInBase = false; // Do not appear as filler crew or in any regular staff slots throughout the base
	CharTemplate.bWearArmorInBase = true;
	CharTemplate.AppearInStaffSlots.AddItem('SparkStaffSlot'); // But are allowed to appear in the spark repair slot
	CharTemplate.bIgnoreEndTacticalHealthMod = true;
	CharTemplate.bAllowRushCam = false;

	CharTemplate.strMatineePackages.AddItem("CIN_Spark");
	CharTemplate.strMatineePackages.AddItem("CIN_AdventMEC");
	CharTemplate.strTargetingMatineePrefix = "CIN_AdventMEC_FF_StartPos";
	CharTemplate.strIntroMatineeSlotPrefix = "Spark";
	CharTemplate.strLoadingMatineeSlotPrefix = "SparkSoldier";
	
	CharTemplate.DefaultSoldierClass = 'Spark';
	CharTemplate.DefaultLoadout = 'SquaddieSpark';
	CharTemplate.RequiredLoadout = 'RequiredSoldier';
	CharTemplate.Abilities.AddItem('Loot');
	CharTemplate.Abilities.AddItem('Evac');
	CharTemplate.Abilities.AddItem('PlaceEvacZone');
	CharTemplate.Abilities.AddItem('LiftOffAvenger');
	CharTemplate.Abilities.AddItem('Interact_PlantBomb');
	CharTemplate.Abilities.AddItem('Interact_TakeVial');
	CharTemplate.Abilities.AddItem('Interact_AtmosphereComputer');
	CharTemplate.Abilities.AddItem('Interact_UseElevator');
	CharTemplate.Abilities.AddItem('Interact_MarkSupplyCrate');
	CharTemplate.Abilities.AddItem('Interact_ActivateAscensionGate');
	CharTemplate.Abilities.AddItem('ActiveCamo');

	CharTemplate.AddTemplateAvailablility(CharTemplate.BITFIELD_GAMEAREA_Multiplayer); // Allow in MP!
	CharTemplate.MPPointValue = CharTemplate.XpKillscore * 10;

	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_XCom;

	CharTemplate.CustomizationManagerClass = class'XComCharacterCustomization_Spark';
	CharTemplate.UICustomizationMenuClass = class'UICustomize_SparkMenu';
	CharTemplate.UICustomizationInfoClass = class'UICustomize_SparkInfo';
	CharTemplate.UICustomizationPropsClass = class'UICustomize_SparkProps';
	CharTemplate.UICustomizationHeadClass = class'UICustomize_SparkHead';
	CharTemplate.UICustomizationBodyClass = class'UICustomize_SparkBody';
	CharTemplate.UICustomizationWeaponClass = class'UICustomize_SparkWeapon';

	CharTemplate.ImmuneTypes.AddItem(class'X2Item_DefaultDamageTypes'.default.KnockbackDamageType);

	CharTemplate.CharacterGeneratorClass = class'XGCharacterGenerator_SPARK';
	
	// Ensure only Spark heads are available for customization
	CharTemplate.bHasCharacterExclusiveAppearance = true;
	
	CharTemplate.PhotoboothPersonality = 'Personality_Normal';

	CharTemplate.OnEndTacticalPlayFn = SparkEndTacticalPlay;
	CharTemplate.GetPawnNameFn = GetSparkPawnName;

	return CharTemplate;
}

function SparkEndTacticalPlay(XComGameState_Unit UnitState)
{
	local float SWHeal;
	local int HealthLost, AdjustedHealth, InventoryHealth, NewMissingHP;
	
	HealthLost = UnitState.HighestHP - UnitState.LowestHP;

	if (UnitState.LowestHP > 0 && `SecondWaveEnabled('BetaStrike'))  // Immediately Heal 1/2 Damage
	{
		SWHeal = FFloor(HealthLost / 2);
		UnitState.LowestHP += SWHeal;
		HealthLost -= SWHeal;
	}

	// If Dead or never injured, return
	if (UnitState.LowestHP <= 0 || (HealthLost <= 0 && UnitState.MissingHP == 0))
	{
		return;
	}

	// Determine how much HP was added by inventory items for this mission
	// If InventoryHealth would be < 0, the unit began the mission already injured
	InventoryHealth = max(0, UnitState.HighestHP - UnitState.GetMaxStat(eStat_HP));
	if (UnitState.LowestHP <= (InventoryHealth + 1))
	{
		AdjustedHealth = 1; // The Spark will get this health back when their inventory is re-equipped before the next mission
	}
	else
	{
		AdjustedHealth = UnitState.LowestHP - InventoryHealth;
	}

	// Ensure that any HP which was missing for this unit at the start of the mission is still missing now even though armor has been removed
	// This guarnatees we have consistent health values if the unit entered the mission wounded and did not get injured further
	NewMissingHP = UnitState.GetMaxStat(eStat_HP) - AdjustedHealth;
	if (NewMissingHP < UnitState.MissingHP)
	{
		AdjustedHealth -= (UnitState.MissingHP - NewMissingHP);
	}
	
	UnitState.SetCurrentStat(eStat_HP, AdjustedHealth);
}

function name GetSparkPawnName(optional EGender Gender)
{
	return 'XCom_Soldier_Spark';
}

static function name GetDefaultSparkVoiceByLanguage(optional string strLanguage = "")
{
	if (len(strLanguage) == 0)
		strLanguage = GetLanguage();

	switch (strLanguage)
	{
	case "DEU":
		return 'SparkCalmVoice1_German';
	case "ESN":
		return 'SparkCalmVoice1_Spanish';
	case "FRA":
		return 'SparkCalmVoice1_French';
	case "ITA":
		return 'SparkCalmVoice1_Italian';
	}

	return 'SparkCalmVoice1_English';
}

static function X2SparkCharacterTemplate_DLC_3 CreateTemplate_LostTowersSpark()
{
	local X2SparkCharacterTemplate_DLC_3 CharTemplate;

	`CREATE_X2TEMPLATE(class'X2SparkCharacterTemplate_DLC_3', CharTemplate, 'LostTowersSpark');
	CharTemplate.UnitSize = 1;
	CharTemplate.UnitHeight = 3;
	CharTemplate.BehaviorClass = class'XGAIBehavior';
	CharTemplate.bCanUse_eTraversal_Normal = true;
	CharTemplate.bCanUse_eTraversal_ClimbOver = true;
	CharTemplate.bCanUse_eTraversal_ClimbOnto = true;
	CharTemplate.bCanUse_eTraversal_ClimbLadder = false;
	CharTemplate.bCanUse_eTraversal_DropDown = true;
	CharTemplate.bCanUse_eTraversal_Grapple = false;
	CharTemplate.bCanUse_eTraversal_Landing = true;
	CharTemplate.bCanUse_eTraversal_BreakWindow = true;
	CharTemplate.bCanUse_eTraversal_KickDoor = true;
	CharTemplate.bCanUse_eTraversal_JumpUp = true;
	CharTemplate.bCanUse_eTraversal_WallClimb = false;
	CharTemplate.bCanUse_eTraversal_BreakWall = false;
	CharTemplate.bCanBeCriticallyWounded = false;
	CharTemplate.bCanBeTerrorist = false;
	CharTemplate.bDiesWhenCaptured = true;
	CharTemplate.bAppearanceDefinesPawn = true;
	CharTemplate.bIsAfraidOfFire = true;
	CharTemplate.bIsAlien = false;
	CharTemplate.bIsCivilian = false;
	CharTemplate.bIsPsionic = false;
	CharTemplate.bIsRobotic = true;
	CharTemplate.bIsSoldier = true;
	CharTemplate.bCanTakeCover = false;
	CharTemplate.bCanBeCarried = false;
	CharTemplate.bCanBeRevived = false;
	CharTemplate.bUsePoolSoldiers = true;
	CharTemplate.bIsTooBigForArmory = true;
	CharTemplate.bStaffingAllowed = false;
	CharTemplate.bIgnoreEndTacticalHealthMod = true;
	CharTemplate.bAllowRushCam = false;

	CharTemplate.strMatineePackages.AddItem("CIN_AdventMEC");
	CharTemplate.strTargetingMatineePrefix = "CIN_AdventMEC_FF_StartPos";
	CharTemplate.strIntroMatineeSlotPrefix = "Spark";
	CharTemplate.strLoadingMatineeSlotPrefix = "SparkSoldier";

	CharTemplate.DefaultSoldierClass = 'Spark';
	CharTemplate.DefaultLoadout = 'SquaddieSpark';
	CharTemplate.RequiredLoadout = 'RequiredSoldier';
	CharTemplate.Abilities.AddItem('Loot');
	CharTemplate.Abilities.AddItem('Evac');
	CharTemplate.Abilities.AddItem('PlaceEvacZone');
	CharTemplate.Abilities.AddItem('LiftOffAvenger');
	CharTemplate.Abilities.AddItem('Interact_PlantBomb');
	CharTemplate.Abilities.AddItem('Interact_TakeVial');
	CharTemplate.Abilities.AddItem('Interact_AtmosphereComputer');
	CharTemplate.Abilities.AddItem('Interact_UseElevator');
	CharTemplate.Abilities.AddItem('Interact_PlantBomb');
	CharTemplate.Abilities.AddItem('Interact_TakeVial');
	CharTemplate.Abilities.AddItem('ActiveCamo');

	CharTemplate.AddTemplateAvailablility(CharTemplate.BITFIELD_GAMEAREA_Multiplayer); // Allow in MP!
	CharTemplate.MPPointValue = CharTemplate.XpKillscore * 10;

	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_XCom;

	CharTemplate.CustomizationManagerClass = class'XComCharacterCustomization_Spark';
	CharTemplate.UICustomizationMenuClass = class'UICustomize_SparkMenu';
	CharTemplate.UICustomizationInfoClass = class'UICustomize_SparkInfo';
	CharTemplate.UICustomizationPropsClass = class'UICustomize_SparkProps';
	CharTemplate.UICustomizationHeadClass = class'UICustomize_SparkHead';
	CharTemplate.UICustomizationBodyClass = class'UICustomize_SparkBody';
	CharTemplate.UICustomizationWeaponClass = class'UICustomize_SparkWeapon';
	CharTemplate.CharacterGeneratorClass = class'XGCharacterGenerator_SPARK';

	CharTemplate.OnEndTacticalPlayFn = SparkEndTacticalPlay;
	CharTemplate.GetPawnNameFn = GetSparkPawnName;

	CharTemplate.bForceAppearance = true;
	CharTemplate.ForceAppearance.iArmorTint = 3;
	CharTemplate.ForceAppearance.iArmorTintSecondary = 5;
	CharTemplate.ForceAppearance.iAttitude = 2;
	CharTemplate.ForceAppearance.iWeaponTint = 4;
	CharTemplate.ForceAppearance.nmArms = 'Spark_A';
	CharTemplate.ForceAppearance.nmFlag = 'Country_Spark';
	CharTemplate.ForceAppearance.nmHead = 'Spark_Head_A';
	CharTemplate.ForceAppearance.nmLegs = 'Spark_A';
	CharTemplate.ForceAppearance.nmPawn = 'XCom_Soldier_Spark';
	CharTemplate.ForceAppearance.nmTorso = 'Spark_A';
	CharTemplate.ForceAppearance.nmVoice = GetDefaultSparkVoiceByLanguage();
	CharTemplate.ForceAppearance.nmWeaponPattern = 'Pat_Nothing';
	
	// Ensure only Spark heads are available for customization
	CharTemplate.bHasCharacterExclusiveAppearance = true;

	return CharTemplate;
}

// Lost Towers Turret
static function X2CharacterTemplate CreateTemplate_LostTowersTurretMk1()
{
	local X2CharacterTemplate CharTemplate;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, 'LostTowersTurretM1');
	CharTemplate.CharacterGroupName = 'AdventTurret';
	CharTemplate.DefaultLoadout='LostTowersTurretM1_Loadout';

	CharTemplate.BehaviorClass = class'XGAIBehavior';
	CharTemplate.strMatineePackages.AddItem("CIN_LostTowersTurret");
	CharTemplate.strTargetingMatineePrefix = "CIN_LostTowersTurret_FF_StartPos";
	CharTemplate.RevealMatineePrefix = "CIN_LostTowersTurret_Tall";
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_LostTowersTurret.ARC_GameUnit_LostTowersTurretM1");

	// Traversal Rules
	CharTemplate.bCanUse_eTraversal_Normal = true;
	CharTemplate.bCanUse_eTraversal_ClimbOver = true;
	CharTemplate.bCanUse_eTraversal_ClimbOnto = true;
	CharTemplate.bCanUse_eTraversal_ClimbLadder = true;
	CharTemplate.bCanUse_eTraversal_DropDown = true;
	CharTemplate.bCanUse_eTraversal_Grapple = false;
	CharTemplate.bCanUse_eTraversal_Landing = true;
	CharTemplate.bCanUse_eTraversal_BreakWindow = true;
	CharTemplate.bCanUse_eTraversal_KickDoor = true;
	CharTemplate.bCanUse_eTraversal_JumpUp = false;
	CharTemplate.bCanUse_eTraversal_WallClimb = false;
	CharTemplate.bCanUse_eTraversal_BreakWall = false;
	CharTemplate.bAppearanceDefinesPawn = false;
	CharTemplate.bCanTakeCover = false;

	CharTemplate.bIsAlien = false;
	CharTemplate.bIsAdvent = true;
	CharTemplate.bIsCivilian = false;
	CharTemplate.bIsPsionic = false;
	CharTemplate.bIsRobotic = true;
	CharTemplate.bIsSoldier = false;
	CharTemplate.bIsTurret = true;

	CharTemplate.UnitSize = 1;
	CharTemplate.VisionArcDegrees = 360;

	CharTemplate.bCanBeTerrorist = false;
	CharTemplate.bCanBeCriticallyWounded = false;
	CharTemplate.bIsAfraidOfFire = false;

	CharTemplate.bAllowSpawnFromATT = false;
	CharTemplate.bSkipDefaultAbilities = true;

	CharTemplate.bBlocksPathingWhenDead = true;

	CharTemplate.ImmuneTypes.AddItem('Fire');
	CharTemplate.ImmuneTypes.AddItem('Poison');
	CharTemplate.ImmuneTypes.AddItem(class'X2Item_DefaultDamageTypes'.default.ParthenogenicPoisonType);
	CharTemplate.ImmuneTypes.AddItem('Panic');

	CharTemplate.strHackIconImage = "UILibrary_Common.TargetIcons.Hack_turret_icon";
	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_Turret;

	CharTemplate.bDisablePodRevealMovementChecks = true;

	//CharTemplate.SightedNarrativeMoments.AddItem(XComNarrativeMoment'X2NarrativeMoments.TACTICAL.T_Shen_AlienSightings_Turret');
	CharTemplate.strBehaviorTree = "LostTowersTurretRoot";

	return CharTemplate;
}

// Feral MEC definitions
static function X2CharacterTemplate CreateTemplate_FeralMEC_M1()
{
	local X2CharacterTemplate CharTemplate;
	//local LootReference Loot;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, 'FeralMEC_M1');
	CharTemplate.CharacterGroupName = FERAL_MEC_GROUP_NAME;
	CharTemplate.DefaultLoadout='FeralMEC_M1_Loadout';
	CharTemplate.BehaviorClass=class'XGAIBehavior';
	CharTemplate.strPawnArchetypes.AddItem("DLC_90_ProxyUnits.Units.ARC_GameUnit_FeralMEC");
	//Loot.ForceLevel=0;
	//Loot.LootTableName='AdvMEC_M1_BaseLoot';
	//CharTemplate.Loot.LootReferences.AddItem(Loot);

	// Timed Loot
	//Loot.ForceLevel = 0;
	//Loot.LootTableName = 'AdvMEC_M1_TimedLoot';
	//CharTemplate.TimedLoot.LootReferences.AddItem(Loot);
	//Loot.LootTableName = 'AdvMEC_M1_VultureLoot';
	//CharTemplate.VultureLoot.LootReferences.AddItem(Loot);

	CharTemplate.strMatineePackages.AddItem("CIN_AdventMEC");
	CharTemplate.strMatineePackages.AddItem("CIN_FeralMEC");
	CharTemplate.strTargetingMatineePrefix = "CIN_AdventMEC_FF_StartPos";
	CharTemplate.RevealMatineePrefix = "CIN_FeralMEC";

	CharTemplate.SightedNarrativeMoments.AddItem(XComNarrativeMoment'DLC_90_NarrativeMoments.DLC3_T_First_Feral_Mec');

	CharTemplate.UnitSize = 1;

	// Traversal Rules
	CharTemplate.bCanUse_eTraversal_Normal = true;
	CharTemplate.bCanUse_eTraversal_ClimbOver = true;
	CharTemplate.bCanUse_eTraversal_ClimbOnto = true;
	CharTemplate.bCanUse_eTraversal_ClimbLadder = false;
	CharTemplate.bCanUse_eTraversal_DropDown = true;
	CharTemplate.bCanUse_eTraversal_Grapple = false;
	CharTemplate.bCanUse_eTraversal_Landing = true;
	CharTemplate.bCanUse_eTraversal_BreakWindow = true;
	CharTemplate.bCanUse_eTraversal_KickDoor = true;
	CharTemplate.bCanUse_eTraversal_JumpUp = true;
	CharTemplate.bCanUse_eTraversal_WallClimb = false;
	CharTemplate.bCanUse_eTraversal_BreakWall = false;
	CharTemplate.bAppearanceDefinesPawn = false;    
	CharTemplate.bCanTakeCover = false;

	CharTemplate.bIsAlien = false;
	CharTemplate.bIsAdvent = true;
	CharTemplate.bIsCivilian = false;
	CharTemplate.bIsPsionic = false;
	CharTemplate.bIsRobotic = true;
	CharTemplate.bIsSoldier = false;

	CharTemplate.bCanBeTerrorist = false;
	CharTemplate.bCanBeCriticallyWounded = false;
	CharTemplate.bIsAfraidOfFire = true;
	CharTemplate.bFacesAwayFromPod = true;
	CharTemplate.bLockdownPodIdleUntilReveal = true;

	CharTemplate.strScamperBT = "ScamperRoot_Flanker";

	CharTemplate.Abilities.AddItem('RobotImmunities');
	CharTemplate.Abilities.AddItem('EngageSelfDestruct');
	
	CharTemplate.strHackIconImage = "UILibrary_Common.TargetIcons.Hack_robot_icon";
	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_Advent;

	return CharTemplate;
}

// Temp definition for Markov's Sectopod
static function X2CharacterTemplate CreateTemplate_MarkovSectopod()
{
	local X2CharacterTemplate CharTemplate;
	//local LootReference Loot;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, 'Sectopod_Markov');
	CharTemplate.CharacterGroupName = 'Sectopod';
	CharTemplate.DefaultLoadout='Sectopod_Markov_Loadout';
	CharTemplate.BehaviorClass=class'XGAIBehavior';
	CharTemplate.strPawnArchetypes.AddItem("DLC_90_ProxyUnits.ARC_GameUnit_MarkovSectopod");
	//Loot.ForceLevel=0;
	//Loot.LootTableName='Sectopod_BaseLoot';
	//CharTemplate.Loot.LootReferences.AddItem(Loot);

	// Timed Loot
	//Loot.ForceLevel = 0;
	//Loot.LootTableName = 'Sectopod_TimedLoot';
	//CharTemplate.TimedLoot.LootReferences.AddItem(Loot);
	//Loot.LootTableName = 'Sectopod_VultureLoot';
	//CharTemplate.VultureLoot.LootReferences.AddItem(Loot);

	CharTemplate.strMatineePackages.AddItem("CIN_Sectopod");
	CharTemplate.strTargetingMatineePrefix = "CIN_Sectopod_FF_StartPos";

	CharTemplate.UnitSize = 2;
	CharTemplate.UnitHeight = 4;

	CharTemplate.KillContribution = 2.0;

	// Traversal Rules
	CharTemplate.bCanUse_eTraversal_Normal = true;
	CharTemplate.bCanUse_eTraversal_ClimbOver = false;
	CharTemplate.bCanUse_eTraversal_ClimbOnto = true;
	CharTemplate.bCanUse_eTraversal_ClimbLadder = false;
	CharTemplate.bCanUse_eTraversal_DropDown = true;
	CharTemplate.bCanUse_eTraversal_Grapple = false;
	CharTemplate.bCanUse_eTraversal_Landing = true;
	CharTemplate.bCanUse_eTraversal_BreakWindow = false;
	CharTemplate.bCanUse_eTraversal_KickDoor = false;
	CharTemplate.bCanUse_eTraversal_JumpUp = false;
	CharTemplate.bCanUse_eTraversal_WallClimb = false;
	CharTemplate.bCanUse_eTraversal_BreakWall = false;
	CharTemplate.bAppearanceDefinesPawn = false;    
	CharTemplate.bCanTakeCover = false;
	CharTemplate.bSkipDefaultAbilities = true;

	CharTemplate.bIsAlien = true;
	CharTemplate.bIsAdvent = false;
	CharTemplate.bIsCivilian = false;
	CharTemplate.bIsPsionic = false;
	CharTemplate.bIsRobotic = true;
	CharTemplate.bIsSoldier = false;
	CharTemplate.bAllowRushCam = false;

	CharTemplate.bCanBeTerrorist = false;
	CharTemplate.bCanBeCriticallyWounded = false;
	CharTemplate.bIsAfraidOfFire = false;

	CharTemplate.bAllowSpawnFromATT = false;

	CharTemplate.AddTemplateAvailablility(CharTemplate.BITFIELD_GAMEAREA_Multiplayer); // Allow in MP!
	CharTemplate.MPPointValue = CharTemplate.XpKillscore * 10;

	CharTemplate.strScamperBT = "ScamperRoot_NoCover";

	//CharTemplate.SightedNarrativeMoments.AddItem(XComNarrativeMoment'X2NarrativeMoments.TACTICAL.AlienSitings.T_Shen_AlienSightings_Sectopod');

	CharTemplate.ImmuneTypes.AddItem('Fire');

	CharTemplate.Abilities.AddItem('StandardMove');
	CharTemplate.Abilities.AddItem('SectopodHigh');
	CharTemplate.Abilities.AddItem('SectopodLow');
	//CharTemplate.Abilities.AddItem('SectopodLightningField');
	//CharTemplate.Abilities.AddItem('DeathExplosion');
	CharTemplate.Abilities.AddItem('SectopodInitialState');
	CharTemplate.Abilities.AddItem('SectopodNewTeamState');

	CharTemplate.strHackIconImage = "UILibrary_Common.TargetIcons.Hack_robot_icon";
	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_Alien;

	CharTemplate.strBehaviorTree = "JulianSectopodRoot";
	return CharTemplate;
}

static function X2CharacterTemplate CreateTemplate_LostTowersShen()
{
	local X2CharacterTemplate CharTemplate;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, 'LostTowersShen');
	CharTemplate.UnitSize = 1;
	CharTemplate.BehaviorClass = class'XGAIBehavior';
	CharTemplate.bCanUse_eTraversal_Normal = true;
	CharTemplate.bCanUse_eTraversal_ClimbOver = true;
	CharTemplate.bCanUse_eTraversal_ClimbOnto = true;
	CharTemplate.bCanUse_eTraversal_ClimbLadder = true;
	CharTemplate.bCanUse_eTraversal_DropDown = true;
	CharTemplate.bCanUse_eTraversal_Grapple = false;
	CharTemplate.bCanUse_eTraversal_Landing = true;
	CharTemplate.bCanUse_eTraversal_BreakWindow = true;
	CharTemplate.bCanUse_eTraversal_KickDoor = true;
	CharTemplate.bCanUse_eTraversal_JumpUp = false;
	CharTemplate.bCanUse_eTraversal_WallClimb = false;
	CharTemplate.bCanUse_eTraversal_BreakWall = false;
	CharTemplate.bCanBeCriticallyWounded = false;
	CharTemplate.bCanBeTerrorist = false;
	CharTemplate.bAppearanceDefinesPawn = true;
	CharTemplate.bIsAfraidOfFire = true;
	CharTemplate.bIsAlien = false;
	CharTemplate.bIsCivilian = false;
	CharTemplate.bIsPsionic = false;
	CharTemplate.bIsRobotic = false;
	CharTemplate.bIsSoldier = true;
	CharTemplate.bCanTakeCover = true;
	CharTemplate.bCanBeCarried = true;
	CharTemplate.bCanBeRevived = true;
	CharTemplate.strMatineePackages.AddItem("CIN_Soldier");
	CharTemplate.strIntroMatineeSlotPrefix = "Char";
	CharTemplate.strLoadingMatineeSlotPrefix = "Soldier";

	CharTemplate.DefaultLoadout = 'LostTowersShen_Loadout';
	CharTemplate.RequiredLoadout = 'RequiredSoldier';
	CharTemplate.Abilities.AddItem('Loot');
	CharTemplate.Abilities.AddItem('CarryUnit');
	CharTemplate.Abilities.AddItem('PutDownUnit');
	CharTemplate.Abilities.AddItem('Evac');
	CharTemplate.Abilities.AddItem('PlaceEvacZone');
	CharTemplate.Abilities.AddItem('LiftOffAvenger');
	CharTemplate.Abilities.AddItem('Knockout');
	CharTemplate.Abilities.AddItem('Panicked');
	CharTemplate.Abilities.AddItem('DisableConsumeAllPoints');
	CharTemplate.Abilities.AddItem('HunkerDown');
	CharTemplate.Abilities.AddItem('Interact_ActivateSpark');
	CharTemplate.Abilities.AddItem('Interact_AtmosphereComputer');
	CharTemplate.Abilities.AddItem('Interact_UseElevator');
	
	CharTemplate.bShouldCreateDifficultyVariants = false;

	CharTemplate.bForceAppearance = true;
	CharTemplate.ForceAppearance.nmPawn = 'XCom_Soldier_F';
	CharTemplate.ForceAppearance.nmHead = 'Shen_Head';
	CharTemplate.ForceAppearance.nmHaircut = 'Shen_Hair';
	CharTemplate.ForceAppearance.nmBeard = '';
	CharTemplate.ForceAppearance.iArmorTint = 97;
	CharTemplate.ForceAppearance.iArmorTintSecondary = 3;
	CharTemplate.ForceAppearance.iGender = 2;
	CharTemplate.ForceAppearance.iAttitude = 3;
	CharTemplate.ForceAppearance.nmArms = 'Shen_Arms';
	CharTemplate.ForceAppearance.nmArms_Underlay = 'CnvMed_Underlay_A_F';
	CharTemplate.ForceAppearance.nmEye = 'DefaultEyes_2';
	CharTemplate.ForceAppearance.nmFacePropLower = 'Prop_FaceLower_Blank';
	CharTemplate.ForceAppearance.nmFacePropUpper = 'Prop_FaceUpper_Blank';
	CharTemplate.ForceAppearance.nmFlag = 'Country_USA'; // Taiwanese-American -acheng
	CharTemplate.ForceAppearance.nmHelmet = 'Helmet_0_NoHelmet_F';
	CharTemplate.ForceAppearance.nmLegs = 'CnvMed_Std_A_F';
	CharTemplate.ForceAppearance.nmLegs_Underlay = 'CnvUnderlay_Std_A_F';
	CharTemplate.ForceAppearance.nmPatterns = 'Pat_Nothing';
	CharTemplate.ForceAppearance.nmTattoo_LeftArm = 'Tattoo_Arms_BLANK';
	CharTemplate.ForceAppearance.nmTattoo_RightArm = 'DLC_3_Tattoo_Arms_01';
	CharTemplate.ForceAppearance.nmTeeth = 'DefaultTeeth';
	CharTemplate.ForceAppearance.nmTorso = 'CnvMed_Std_A_F';
	CharTemplate.ForceAppearance.nmTorso_Underlay = 'CnvUnderlay_Std_A_F';
	CharTemplate.ForceAppearance.nmWeaponPattern = 'Pat_Nothing';
	CharTemplate.ForceAppearance.iWeaponTint = 3;
	CharTemplate.ForceAppearance.nmVoice = 'ShenVoice1_Localized';

	CharTemplate.DefaultSoldierClass = 'ChiefEngineer';
	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_XCom;
	CharTemplate.CharacterGeneratorClass = class'XGCharacterGenerator';

	return CharTemplate;
}

static function X2CharacterTemplate CreateRovRTemplate()
{
	local X2CharacterTemplate CharTemplate;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, 'RovR');
	CharTemplate.CharacterBaseStats[eStat_HP] = 1;
	CharTemplate.CharacterBaseStats[eStat_Offense] = 0;
	CharTemplate.CharacterBaseStats[eStat_Defense] = 0;
	CharTemplate.CharacterBaseStats[eStat_Mobility] = 12;
	CharTemplate.CharacterBaseStats[eStat_SightRadius] = 1;
	CharTemplate.CharacterBaseStats[eStat_Will] = 50;
	CharTemplate.CharacterBaseStats[eStat_FlightFuel] = 0;
	CharTemplate.CharacterBaseStats[eStat_UtilityItems] = 1;
	CharTemplate.CharacterBaseStats[eStat_AlertLevel] = 2;
	CharTemplate.UnitSize = 1;
	CharTemplate.AvengerOffset.X = 45;
	CharTemplate.AvengerOffset.Y = 90;
	CharTemplate.AvengerOffset.Z = -20;
	CharTemplate.BehaviorClass = class'XGAIBehavior_Civilian';
	CharTemplate.bCanUse_eTraversal_Normal = true;
	CharTemplate.bCanUse_eTraversal_ClimbOver = false;
	CharTemplate.bCanUse_eTraversal_ClimbOnto = false;
	CharTemplate.bCanUse_eTraversal_ClimbLadder = false;
	CharTemplate.bCanUse_eTraversal_DropDown = false;
	CharTemplate.bCanUse_eTraversal_Grapple = false;
	CharTemplate.bCanUse_eTraversal_Landing = true;
	CharTemplate.bCanUse_eTraversal_BreakWindow = true;
	CharTemplate.bCanUse_eTraversal_KickDoor = true;
	CharTemplate.bCanUse_eTraversal_JumpUp = false;
	CharTemplate.bCanUse_eTraversal_WallClimb = false;
	CharTemplate.bCanUse_eTraversal_BreakWall = false;
	CharTemplate.bCanUse_eTraversal_Launch = true;
	CharTemplate.bCanUse_eTraversal_Flying = true;
	CharTemplate.bCanUse_eTraversal_Land = true;
	CharTemplate.bCanBeCriticallyWounded = false;
	CharTemplate.bCanBeTerrorist = false;
	CharTemplate.bAppearanceDefinesPawn = false;
	CharTemplate.bIsAfraidOfFire = false;
	CharTemplate.bIsAlien = false;
	CharTemplate.bIsCivilian = false;
	CharTemplate.bIsPsionic = false;
	CharTemplate.bIsRobotic = false;
	CharTemplate.bIsSoldier = false;
	CharTemplate.bCanTakeCover = false;
	CharTemplate.bIsCosmetic = true;
	CharTemplate.bDisplayUIUnitFlag = false;
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_GremlinShen.ARC_GameUnit_GremlinShen");
	CharTemplate.bAllowRushCam = false;
	CharTemplate.SoloMoveSpeedModifier = 2.0f;

	CharTemplate.HQIdleAnim = "HL_Idle";
	CharTemplate.HQOffscreenAnim = "HL_FlyUpStart";
	CharTemplate.HQOnscreenAnimPrefix = "HL_FlyDwn";
	CharTemplate.HQOnscreenOffset.X = 0;
	CharTemplate.HQOnscreenOffset.Y = 0;
	CharTemplate.HQOnscreenOffset.Z = 96.0f;

	CharTemplate.Abilities.AddItem('Panicked');

	return CharTemplate;
}

static function X2CharacterTemplate CreateSparkBitMk1Template()
{
	local X2CharacterTemplate CharTemplate;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, 'SparkBitMk1');
	CharTemplate.CharacterBaseStats[eStat_HP] = 1;
	CharTemplate.CharacterBaseStats[eStat_Offense] = 0;
	CharTemplate.CharacterBaseStats[eStat_Defense] = 0;
	CharTemplate.CharacterBaseStats[eStat_Mobility] = 12;
	CharTemplate.CharacterBaseStats[eStat_SightRadius] = 1;
	CharTemplate.CharacterBaseStats[eStat_Will] = 50;
	CharTemplate.CharacterBaseStats[eStat_FlightFuel] = 0;
	CharTemplate.CharacterBaseStats[eStat_UtilityItems] = 1;
	CharTemplate.CharacterBaseStats[eStat_AlertLevel] = 2;
	CharTemplate.UnitSize = 1;
	CharTemplate.AvengerOffset.X = 45;
	CharTemplate.AvengerOffset.Y = 90;
	CharTemplate.AvengerOffset.Z = -20;
	CharTemplate.BehaviorClass = class'XGAIBehavior_Civilian';
	CharTemplate.bCanUse_eTraversal_Normal = true;
	CharTemplate.bCanUse_eTraversal_ClimbOver = false;
	CharTemplate.bCanUse_eTraversal_ClimbOnto = false;
	CharTemplate.bCanUse_eTraversal_ClimbLadder = false;
	CharTemplate.bCanUse_eTraversal_DropDown = false;
	CharTemplate.bCanUse_eTraversal_Grapple = false;
	CharTemplate.bCanUse_eTraversal_Landing = true;
	CharTemplate.bCanUse_eTraversal_BreakWindow = true;
	CharTemplate.bCanUse_eTraversal_KickDoor = true;
	CharTemplate.bCanUse_eTraversal_JumpUp = false;
	CharTemplate.bCanUse_eTraversal_WallClimb = false;
	CharTemplate.bCanUse_eTraversal_BreakWall = false;
	CharTemplate.bCanUse_eTraversal_Launch = true;
	CharTemplate.bCanUse_eTraversal_Flying = true;
	CharTemplate.bCanUse_eTraversal_Land = true;
	CharTemplate.bCanBeCriticallyWounded = false;
	CharTemplate.bCanBeTerrorist = false;
	CharTemplate.bAppearanceDefinesPawn = false;
	CharTemplate.bIsAfraidOfFire = false;
	CharTemplate.bIsAlien = false;
	CharTemplate.bIsCivilian = false;
	CharTemplate.bIsPsionic = false;
	CharTemplate.bIsRobotic = false;
	CharTemplate.bIsSoldier = false;
	CharTemplate.bCanTakeCover = false;
	CharTemplate.bIsCosmetic = true;
	CharTemplate.bDisplayUIUnitFlag=false;
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_Bit.ARC_GameUnit_ConvBit");
	CharTemplate.bAllowRushCam = false;
	CharTemplate.SoloMoveSpeedModifier = 2.0f;

	CharTemplate.HQIdleAnim = "HL_Idle";
	CharTemplate.HQOffscreenAnim = "HL_FlyUpStart";
	CharTemplate.HQOnscreenAnimPrefix = "HL_FlyDwn";
	CharTemplate.HQOnscreenOffset.X = 0;
	CharTemplate.HQOnscreenOffset.Y = 0;
	CharTemplate.HQOnscreenOffset.Z = 96.0f;

	CharTemplate.Abilities.AddItem('Panicked');

	return CharTemplate;
}

static function X2CharacterTemplate CreateSparkBitMk2Template()
{
	local X2CharacterTemplate CharTemplate;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, 'SparkBitMk2');
	CharTemplate.CharacterBaseStats[eStat_HP] = 1;
	CharTemplate.CharacterBaseStats[eStat_Offense] = 0;
	CharTemplate.CharacterBaseStats[eStat_Defense] = 0;
	CharTemplate.CharacterBaseStats[eStat_Mobility] = 12;
	CharTemplate.CharacterBaseStats[eStat_SightRadius] = 1;
	CharTemplate.CharacterBaseStats[eStat_Will] = 50;
	CharTemplate.CharacterBaseStats[eStat_FlightFuel] = 0;
	CharTemplate.CharacterBaseStats[eStat_UtilityItems] = 1;
	CharTemplate.CharacterBaseStats[eStat_AlertLevel] = 2;
	CharTemplate.UnitSize = 1;
	CharTemplate.AvengerOffset.X = 45;
	CharTemplate.AvengerOffset.Y = 90;
	CharTemplate.AvengerOffset.Z = -20;
	CharTemplate.BehaviorClass = class'XGAIBehavior_Civilian';
	CharTemplate.bCanUse_eTraversal_Normal = true;
	CharTemplate.bCanUse_eTraversal_ClimbOver = false;
	CharTemplate.bCanUse_eTraversal_ClimbOnto = false;
	CharTemplate.bCanUse_eTraversal_ClimbLadder = false;
	CharTemplate.bCanUse_eTraversal_DropDown = false;
	CharTemplate.bCanUse_eTraversal_Grapple = false;
	CharTemplate.bCanUse_eTraversal_Landing = true;
	CharTemplate.bCanUse_eTraversal_BreakWindow = true;
	CharTemplate.bCanUse_eTraversal_KickDoor = true;
	CharTemplate.bCanUse_eTraversal_JumpUp = false;
	CharTemplate.bCanUse_eTraversal_WallClimb = false;
	CharTemplate.bCanUse_eTraversal_BreakWall = false;
	CharTemplate.bCanUse_eTraversal_Launch = true;
	CharTemplate.bCanUse_eTraversal_Flying = true;
	CharTemplate.bCanUse_eTraversal_Land = true;
	CharTemplate.bCanBeCriticallyWounded = false;
	CharTemplate.bCanBeTerrorist = false;
	CharTemplate.bAppearanceDefinesPawn = false;
	CharTemplate.bIsAfraidOfFire = false;
	CharTemplate.bIsAlien = false;
	CharTemplate.bIsCivilian = false;
	CharTemplate.bIsPsionic = false;
	CharTemplate.bIsRobotic = false;
	CharTemplate.bIsSoldier = false;
	CharTemplate.bCanTakeCover = false;
	CharTemplate.bIsCosmetic = true;
	CharTemplate.bDisplayUIUnitFlag=false;
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_Bit.ARC_GameUnit_MagBit");
	CharTemplate.bAllowRushCam = false;
	CharTemplate.SoloMoveSpeedModifier = 2.0f;

	CharTemplate.HQIdleAnim = "HL_Idle";
	CharTemplate.HQOffscreenAnim = "HL_FlyUpStart";
	CharTemplate.HQOnscreenAnimPrefix = "HL_FlyDwn";
	CharTemplate.HQOnscreenOffset.X = 0;
	CharTemplate.HQOnscreenOffset.Y = 0;
	CharTemplate.HQOnscreenOffset.Z = 96.0f;

	CharTemplate.Abilities.AddItem('Panicked');

	return CharTemplate;
}

static function X2CharacterTemplate CreateSparkBitMk3Template()
{
	local X2CharacterTemplate CharTemplate;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, 'SparkBitMk3');
	CharTemplate.CharacterBaseStats[eStat_HP] = 1;
	CharTemplate.CharacterBaseStats[eStat_Offense] = 0;
	CharTemplate.CharacterBaseStats[eStat_Defense] = 0;
	CharTemplate.CharacterBaseStats[eStat_Mobility] = 12;
	CharTemplate.CharacterBaseStats[eStat_SightRadius] = 1;
	CharTemplate.CharacterBaseStats[eStat_Will] = 50;
	CharTemplate.CharacterBaseStats[eStat_FlightFuel] = 0;
	CharTemplate.CharacterBaseStats[eStat_UtilityItems] = 1;
	CharTemplate.CharacterBaseStats[eStat_AlertLevel] = 2;
	CharTemplate.UnitSize = 1;
	CharTemplate.AvengerOffset.X = 45;
	CharTemplate.AvengerOffset.Y = 90;
	CharTemplate.AvengerOffset.Z = -20;
	CharTemplate.BehaviorClass = class'XGAIBehavior_Civilian';
	CharTemplate.bCanUse_eTraversal_Normal = true;
	CharTemplate.bCanUse_eTraversal_ClimbOver = false;
	CharTemplate.bCanUse_eTraversal_ClimbOnto = false;
	CharTemplate.bCanUse_eTraversal_ClimbLadder = false;
	CharTemplate.bCanUse_eTraversal_DropDown = false;
	CharTemplate.bCanUse_eTraversal_Grapple = false;
	CharTemplate.bCanUse_eTraversal_Landing = true;
	CharTemplate.bCanUse_eTraversal_BreakWindow = true;
	CharTemplate.bCanUse_eTraversal_KickDoor = true;
	CharTemplate.bCanUse_eTraversal_JumpUp = false;
	CharTemplate.bCanUse_eTraversal_WallClimb = false;
	CharTemplate.bCanUse_eTraversal_BreakWall = false;
	CharTemplate.bCanUse_eTraversal_Launch = true;
	CharTemplate.bCanUse_eTraversal_Flying = true;
	CharTemplate.bCanUse_eTraversal_Land = true;
	CharTemplate.bCanBeCriticallyWounded = false;
	CharTemplate.bCanBeTerrorist = false;
	CharTemplate.bAppearanceDefinesPawn = false;
	CharTemplate.bIsAfraidOfFire = false;
	CharTemplate.bIsAlien = false;
	CharTemplate.bIsCivilian = false;
	CharTemplate.bIsPsionic = false;
	CharTemplate.bIsRobotic = false;
	CharTemplate.bIsSoldier = false;
	CharTemplate.bCanTakeCover = false;
	CharTemplate.bIsCosmetic = true;
	CharTemplate.bDisplayUIUnitFlag=false;
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_Bit.ARC_GameUnit_BeamBit");
	CharTemplate.bAllowRushCam = false;
	CharTemplate.SoloMoveSpeedModifier = 2.0f;

	CharTemplate.HQIdleAnim = "HL_Idle";
	CharTemplate.HQOffscreenAnim = "HL_FlyUpStart";
	CharTemplate.HQOnscreenAnimPrefix = "HL_FlyDwn";
	CharTemplate.HQOnscreenOffset.X = 0;
	CharTemplate.HQOnscreenOffset.Y = 0;
	CharTemplate.HQOnscreenOffset.Z = 96.0f;

	CharTemplate.Abilities.AddItem('Panicked');

	return CharTemplate;
}

static function X2CharacterTemplate CreateDLC3SpeakerTemplate(Name CharacterName, optional string CharacterSpeakerName = "", optional string CharacterSpeakerPortrait = "")
{
	local X2CharacterTemplate CharTemplate;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, CharacterName);
	CharTemplate.CharacterGroupName = 'Speaker';
	if( CharTemplate.strCharacterName == "" )
	{
		CharTemplate.strCharacterName = CharacterSpeakerName;
	}
	CharTemplate.SpeakerPortrait = CharacterSpeakerPortrait;

	CharTemplate.bShouldCreateDifficultyVariants = false;

	return CharTemplate;
}