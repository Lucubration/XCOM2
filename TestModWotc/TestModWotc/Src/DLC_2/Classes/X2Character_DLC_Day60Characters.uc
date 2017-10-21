class X2Character_DLC_Day60Characters extends X2Character config(GameData_CharacterStats);

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	// Alien Rulers
	Templates.AddItem(CreateTemplate_BerserkerQueen());
	Templates.AddItem(CreateTemplate_ArchonKing());
	Templates.AddItem(CreateTemplate_ViperKing());
	
	// Neonate Viper template
	Templates.AddItem(CreateTemplate_ViperNeonate());

	// Central for Nest Mission
	Templates.AddItem(CreateNestCentralTemplate());

	// Dr. Vahlen Speaker Template
	Templates.AddItem(CreateDLC2SpeakerTemplate('DrVahlen', "Dr. Vahlen", "img:///UILibrary_Common.Head_Empty"));
	
	return Templates;
}

// Alien Rulers
static function X2CharacterTemplate CreateTemplate_BerserkerQueen()
{
	local X2CharacterTemplate CharTemplate;
	local LootReference Loot;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, 'BerserkerQueen');
	CharTemplate.CharacterGroupName = 'BerserkerQueen';
	CharTemplate.DefaultLoadout='Berserker_Loadout';
	CharTemplate.BehaviorClass=class'XGAIBehavior';
	CharTemplate.strBehaviorTree = "RulerBehavior";
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_BerserkerQueen.ARC_GameUnit_BerserkerQueen");
	Loot.ForceLevel=0;
	Loot.LootTableName='BerserkerQueen_BaseLoot';
	CharTemplate.Loot.LootReferences.AddItem(Loot);

	CharTemplate.strMatineePackages.AddItem("CIN_Berserker");
	CharTemplate.strMatineePackages.AddItem("CIN_BerserkerQueen");
	CharTemplate.strMatineePackages.AddItem("CIN_AlienRulers");
	CharTemplate.RevealMatineePrefix = "CIN_Hunter-BerserkerQueen";

	CharTemplate.UnitSize = 1;
	CharTemplate.UnitHeight = 3; //One unit taller than normal
	
	CharTemplate.KillContribution = 3.0;

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

	CharTemplate.bIsAlien = true;
	CharTemplate.bIsAdvent = false;
	CharTemplate.bIsCivilian = false;
	CharTemplate.bIsPsionic = false;
	CharTemplate.bIsRobotic = false;
	CharTemplate.bIsSoldier = false;
	CharTemplate.bIsMeleeOnly = true;

	CharTemplate.bCanBeTerrorist = false;
	CharTemplate.bCanBeCriticallyWounded = false;
	CharTemplate.bIsAfraidOfFire = true;

	CharTemplate.bAllowSpawnFromATT = false;
	CharTemplate.bAllowRushCam = false;
	CharTemplate.bCanTickEffectsEveryAction = true;
	CharTemplate.bManualCooldownTick = true;

	CharTemplate.ImmuneTypes.AddItem('Mental');

	CharTemplate.strScamperBT = "ScamperRoot_MeleeNoCover";

	CharTemplate.SightedNarrativeMoments.AddItem(XComNarrativeMoment'DLC_60_NarrativeMoments.DLC2_T_Berserker_Queen_Reveal');
	CharTemplate.SightedEvents.AddItem('BerserkerQueenSighted');
	CharTemplate.DeathEvent = 'KilledBerserkerQueen';
	CharTemplate.OnRevealEventFn = InitializeAlienRulerValues;

	CharTemplate.Abilities.AddItem('AlienRulerPassive');
	CharTemplate.Abilities.AddItem('AlienRulerCallForEscape');
	CharTemplate.Abilities.AddItem('AlienRulerActionSystem');
	CharTemplate.Abilities.AddItem('AlienRulerInitialState');
	CharTemplate.Abilities.AddItem('Quake');
	CharTemplate.Abilities.AddItem('Faithbreaker');
	CharTemplate.Abilities.AddItem('QueenDevastatingPunch');

	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_Alien;

	CharTemplate.OnStatAssignmentCompleteFn = SetAlienRulerHealthAndArmor;
	CharTemplate.bIgnoreEndTacticalHealthMod = true;
	CharTemplate.bIgnoreEndTacticalRestoreArmor = true;
	CharTemplate.bHideInShadowChamber = true;
	CharTemplate.bDontClearRemovedFromPlay = true;

	return CharTemplate;
}

static function X2CharacterTemplate CreateTemplate_ArchonKing()
{
	local X2CharacterTemplate CharTemplate;
	local LootReference Loot;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, 'ArchonKing');
	CharTemplate.CharacterGroupName = 'ArchonKing';
	CharTemplate.DefaultLoadout='ArchonKing_Loadout';
	CharTemplate.BehaviorClass=class'XGAIBehavior';
	CharTemplate.strBehaviorTree = "RulerBehavior";
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_ArchonKing.ARC_GameUnit_ArchonKing");
	Loot.ForceLevel=0;
	Loot.LootTableName='ArchonKing_BaseLoot';
	CharTemplate.Loot.LootReferences.AddItem(Loot);

	// Timed Loot
	Loot.ForceLevel = 0;
	Loot.LootTableName = 'Archon_TimedLoot';
	CharTemplate.TimedLoot.LootReferences.AddItem(Loot);
	Loot.LootTableName = 'Archon_VultureLoot';
	CharTemplate.VultureLoot.LootReferences.AddItem(Loot);

	CharTemplate.strMatineePackages.AddItem("CIN_Archon");
	CharTemplate.strMatineePackages.AddItem("CIN_AdventMEC");
	CharTemplate.strMatineePackages.AddItem("CIN_ArchonKing");
	CharTemplate.strMatineePackages.AddItem("CIN_AlienRulers");
	CharTemplate.RevealMatineePrefix ="CIN_Hunter-ArchonKing";
	CharTemplate.strTargetingMatineePrefix = "CIN_AdventMEC_FF_StartPos";

	CharTemplate.UnitSize = 1;

	CharTemplate.KillContribution = 3.0;

	// Traversal Rules
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
	CharTemplate.bAppearanceDefinesPawn = false;    
	CharTemplate.bCanTakeCover = false;

	CharTemplate.bIsAlien = true;
	CharTemplate.bIsAdvent = false;
	CharTemplate.bIsCivilian = false;
	CharTemplate.bIsPsionic = false;
	CharTemplate.bIsRobotic = false;
	CharTemplate.bIsSoldier = false;

	CharTemplate.ImmuneTypes.AddItem('Mental');

	CharTemplate.bAllowSpawnFromATT = false;
	CharTemplate.bImmueToFalling = true;

	CharTemplate.bCanBeTerrorist = false;
	CharTemplate.bCanBeCriticallyWounded = false;
	CharTemplate.bIsAfraidOfFire = true;
	CharTemplate.bCanTickEffectsEveryAction = true;
	CharTemplate.bManualCooldownTick = true;

	CharTemplate.strScamperBT = "ScamperRoot_NoCover";

	CharTemplate.SightedNarrativeMoments.AddItem(XComNarrativeMoment'DLC_60_NarrativeMoments.DLC2_T_Archon_King_Reveal');
	CharTemplate.SightedEvents.AddItem('ArchonKingSighted');
	CharTemplate.DeathEvent = 'KilledArchonKing';
	CharTemplate.OnRevealEventFn = InitializeAlienRulerValues;

	CharTemplate.Abilities.AddItem('AlienRulerPassive');
	CharTemplate.Abilities.AddItem('AlienRulerCallForEscape');
	CharTemplate.Abilities.AddItem('AlienRulerActionSystem');
	CharTemplate.Abilities.AddItem('AlienRulerInitialState');

	CharTemplate.Abilities.AddItem('ArchonKingBlazingPinionsStage1');
	CharTemplate.Abilities.AddItem('IcarusDropGrab');

	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_Alien;

	CharTemplate.OnStatAssignmentCompleteFn = SetAlienRulerHealthAndArmor;
	CharTemplate.bIgnoreEndTacticalHealthMod = true;
	CharTemplate.bIgnoreEndTacticalRestoreArmor = true;
	CharTemplate.bHideInShadowChamber = true;
	CharTemplate.bDontClearRemovedFromPlay = true;

	return CharTemplate;
}

static function X2CharacterTemplate CreateTemplate_ViperKing()
{
	local X2CharacterTemplate CharTemplate;
	local LootReference Loot;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, 'ViperKing');
	CharTemplate.CharacterGroupName = 'ViperKing';
	CharTemplate.DefaultLoadout='ViperKing_Loadout';
	CharTemplate.BehaviorClass=class'XGAIBehavior';
	CharTemplate.strBehaviorTree = "RulerBehavior";
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_ViperKing.ARC_GameUnit_ViperKing");
	Loot.ForceLevel=0;
	Loot.LootTableName='ViperKing_BaseLoot';
	CharTemplate.Loot.LootReferences.AddItem(Loot);

	// Timed Loot
	Loot.ForceLevel = 0;
	Loot.LootTableName = 'Viper_TimedLoot';
	CharTemplate.TimedLoot.LootReferences.AddItem(Loot);
	Loot.LootTableName = 'Viper_VultureLoot';
	CharTemplate.VultureLoot.LootReferences.AddItem(Loot);

	CharTemplate.strMatineePackages.AddItem("CIN_Viper");
	CharTemplate.strMatineePackages.AddItem("CIN_AdventMEC");
	CharTemplate.strMatineePackages.AddItem("CIN_ViperKing");
	CharTemplate.strMatineePackages.AddItem("CIN_AlienRulers");
	CharTemplate.RevealMatineePrefix = "CIN_Hunter-ViperKing";
	CharTemplate.strTargetingMatineePrefix = "CIN_AdventMEC_FF_StartPos";

	CharTemplate.UnitSize = 1;

	CharTemplate.KillContribution = 3.0;

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
	CharTemplate.bCanTakeCover = true;

	CharTemplate.bIsAlien = true;
	CharTemplate.bIsAdvent = false;
	CharTemplate.bIsCivilian = false;
	CharTemplate.bIsPsionic = false;
	CharTemplate.bIsRobotic = false;
	CharTemplate.bIsSoldier = false;

	CharTemplate.bCanBeTerrorist = false;
	CharTemplate.bCanBeCriticallyWounded = false;
	CharTemplate.bIsAfraidOfFire = true;
	CharTemplate.bCanTickEffectsEveryAction = true;
	CharTemplate.bManualCooldownTick = true;

	CharTemplate.ImmuneTypes.AddItem('Poison');
	CharTemplate.ImmuneTypes.AddItem('Mental');

	CharTemplate.bAllowSpawnFromATT = false;

	CharTemplate.Abilities.AddItem('AlienRulerPassive');
	CharTemplate.Abilities.AddItem('AlienRulerCallForEscape');
	CharTemplate.Abilities.AddItem('AlienRulerActionSystem');
	CharTemplate.Abilities.AddItem('AlienRulerInitialState');

	CharTemplate.Abilities.AddItem('ViperKingInitialState');
	CharTemplate.Abilities.AddItem('KingBind');
	
	CharTemplate.SightedEvents.AddItem('ViperKingSighted');
	CharTemplate.DeathEvent = 'KilledViperKing';
	CharTemplate.OnRevealEventFn = InitializeAlienRulerValues;

	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_Alien;

	CharTemplate.OnStatAssignmentCompleteFn = SetAlienRulerHealthAndArmor;
	CharTemplate.bIgnoreEndTacticalHealthMod = true;
	CharTemplate.bIgnoreEndTacticalRestoreArmor = true;
	CharTemplate.bHideInShadowChamber = true;
	CharTemplate.bDontClearRemovedFromPlay = true;

	return CharTemplate;
}

static function SetAlienRulerHealthAndArmor(XComGameState_Unit UnitState)
{
	local XComGameStateHistory History;
	local XComGameState_AlienRulerManager RulerMgr;
	local XComGameState_Unit RulerState;
	local StateObjectReference RulerRef;

	History = `XCOMHISTORY;
	RulerMgr = XComGameState_AlienRulerManager(History.GetSingleGameStateObjectForClass(class'XComGameState_AlienRulerManager'));
	RulerRef = RulerMgr.GetAlienRulerReference(UnitState.GetMyTemplateName());

	if (RulerRef.ObjectID != 0 && RulerRef.ObjectID != UnitState.ObjectID)
	{
		RulerState = XComGameState_Unit(History.GetGameStateForObjectID(RulerRef.ObjectID));
		UnitState.SetCurrentStat(eStat_HP, RulerState.GetCurrentStat(eStat_HP));
		UnitState.SetCurrentStat(eStat_ArmorMitigation, RulerState.GetCurrentStat(eStat_ArmorMitigation));
		UnitState.bIsSpecial = RulerState.bIsSpecial;
	}
}

static function InitializeAlienRulerValues(XComGameState_Unit UnitState)
{
	local int StartingDisabledCount;
	
	StartingDisabledCount = class'X2Helpers_DLC_Day60'.static.GetCurrentDisabledCount();
	UnitState.SetUnitFloatValue('StartingDisabledCount', StartingDisabledCount, eCleanup_Never);
	UnitState.SetUnitFloatValue('RulerActionsCount', 0, eCleanup_Never);
}


// Neonate Viper 
static function X2CharacterTemplate CreateTemplate_ViperNeonate()
{
	local X2CharacterTemplate CharTemplate;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, 'ViperNeonate');
	CharTemplate.CharacterGroupName = 'ViperNeonate';
	CharTemplate.DefaultLoadout='ViperNeonate_Loadout';
	CharTemplate.BehaviorClass=class'XGAIBehavior';
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_ViperNeonate.ARC_GameUnit_ViperNeonate");

	CharTemplate.strMatineePackages.AddItem("CIN_Viper");
	CharTemplate.strMatineePackages.AddItem("CIN_AdventMEC");
	CharTemplate.strTargetingMatineePrefix = "CIN_AdventMEC_FF_StartPos";

	CharTemplate.UnitSize = 1;
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
	CharTemplate.bCanTakeCover = true;

	CharTemplate.bIsAlien = true;
	CharTemplate.bIsAdvent = false;
	CharTemplate.bIsCivilian = false;
	CharTemplate.bIsPsionic = false;
	CharTemplate.bIsRobotic = false;
	CharTemplate.bIsSoldier = false;

	CharTemplate.bCanBeTerrorist = false;
	CharTemplate.bCanBeCriticallyWounded = false;
	CharTemplate.bIsAfraidOfFire = true;

	CharTemplate.ImmuneTypes.AddItem('Poison');

	CharTemplate.bAllowSpawnFromATT = false;

	CharTemplate.Abilities.AddItem(class'X2Ability_DLC_Day60AlienRulers'.default.ViperNeonateBindAbilityName);
	
	CharTemplate.AddTemplateAvailablility(CharTemplate.BITFIELD_GAMEAREA_Multiplayer); // Allow in MP!
	CharTemplate.MPPointValue = CharTemplate.XpKillscore * 10;

	CharTemplate.SightedNarrativeMoments.AddItem(XComNarrativeMoment'DLC_60_NarrativeMoments.DLC2_T_Neophytes_Spotted');

	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_Alien;

	return CharTemplate;
}

static function X2CharacterTemplate CreateNestCentralTemplate()
{
	local X2CharacterTemplate CharTemplate;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, 'NestCentral');
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

	CharTemplate.DefaultLoadout = 'NestCentral_Loadout';
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

	CharTemplate.AddTemplateAvailablility(CharTemplate.BITFIELD_GAMEAREA_Multiplayer); // Allow in MP!
	CharTemplate.MPPointValue = CharTemplate.XpKillscore * 10;

	CharTemplate.bShouldCreateDifficultyVariants = false;

	CharTemplate.bHasFullDefaultAppearance = true;
	CharTemplate.DefaultAppearance.nmPawn = 'XCom_Soldier_M';
	CharTemplate.DefaultAppearance.nmHead = 'Central';
	CharTemplate.DefaultAppearance.nmHaircut = 'Central_Hair';
	CharTemplate.DefaultAppearance.nmBeard = 'Central_Beard';
	CharTemplate.DefaultAppearance.iArmorTint = 0;
	CharTemplate.DefaultAppearance.iArmorTintSecondary = 2;
	CharTemplate.DefaultAppearance.iGender = 1;
	CharTemplate.DefaultAppearance.nmArms = 'CnvMed_std_B_M';
	CharTemplate.DefaultAppearance.nmArms_Underlay = 'CnvUnderlay_Std_Arms_A_M';
	CharTemplate.DefaultAppearance.nmEye = 'DefaultEyes_2';
	CharTemplate.DefaultAppearance.nmFacePropLower = 'Prop_FaceLower_Blank';
	CharTemplate.DefaultAppearance.nmFacePropUpper = 'Prop_FaceUpper_Blank';
	CharTemplate.DefaultAppearance.nmFlag = 'Country_USA';
	CharTemplate.DefaultAppearance.nmHelmet = 'Helmet_0_NoHelmet_M';
	CharTemplate.DefaultAppearance.nmLegs = 'CnvMed_Std_D_M';
	CharTemplate.DefaultAppearance.nmLegs_Underlay = 'CnvUnderlay_Std_Legs_A_M';
	CharTemplate.DefaultAppearance.nmPatterns = 'Pat_Nothing';
	CharTemplate.DefaultAppearance.nmTattoo_LeftArm = 'Tattoo_Arms_BLANK';
	CharTemplate.DefaultAppearance.nmTattoo_RightArm = 'Tattoo_Arms_BLANK';
	CharTemplate.DefaultAppearance.nmTeeth = 'DefaultTeeth';
	CharTemplate.DefaultAppearance.nmTorso = 'CnvMed_Std_C_M';
	CharTemplate.DefaultAppearance.nmTorso_Underlay = 'CnvUnderlay_Std_Torsos_A_M';
	CharTemplate.DefaultAppearance.nmWeaponPattern = 'Pat_Nothing';
	CharTemplate.DefaultAppearance.nmVoice = 'CentralVoice1_Localized';
	
	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_XCom;
	CharTemplate.CharacterGeneratorClass = class'XGCharacterGenerator';

	return CharTemplate;
}

static function X2CharacterTemplate CreateDLC2SpeakerTemplate(Name CharacterName, optional string CharacterSpeakerName = "", optional string CharacterSpeakerPortrait = "")
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
