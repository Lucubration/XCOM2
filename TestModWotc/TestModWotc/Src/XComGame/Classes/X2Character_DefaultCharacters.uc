class X2Character_DefaultCharacters extends X2Character config(GameData_CharacterStats);

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem(CreateSoldierTemplate());

	Templates.AddItem(CreateTutorialCentralTemplate());
	Templates.AddItem(CreateStrategyCentralTemplate());

	Templates.AddItem(CreateCivilianTemplate());
	Templates.AddItem(CreateFacelessCivilianTemplate());
	Templates.AddItem(CreateHostileCivilianTemplate());
	Templates.AddItem(CreateFriendlyVIPCivilianTemplate());
	Templates.AddItem(CreateFriendlyVIPCivilianTemplate('Soldier_VIP'));
	Templates.AddItem(CreateFriendlyVIPCivilianTemplate('Scientist_VIP'));
	Templates.AddItem(CreateFriendlyVIPCivilianTemplate('Engineer_VIP'));
	Templates.AddItem(CreateHostileVIPCivilianTemplate());
	Templates.AddItem(CreateScientistTemplate());
	Templates.AddItem(CreateHeadScientistTemplate());
	Templates.AddItem(CreateEngineerTemplate());
	Templates.AddItem(CreateHeadEngineerTemplate());
	Templates.AddItem(CreateHeadquartersClerkTemplate());

	Templates.AddItem(CreateCommanderVIPTemplate());
	Templates.AddItem(CreateStasisSuitVIPTemplate());

	Templates.AddItem(CreateGremlinMk1Template());
	Templates.AddItem(CreateGremlinMk2Template());
	Templates.AddItem(CreateGremlinMk3Template());

	Templates.AddItem(CreateTemplate_XComTurretMk1());
	Templates.AddItem(CreateTemplate_XComTurretMk2());

	Templates.AddItem(CreateTemplate_AdvCaptainM1());
	Templates.AddItem(CreateTemplate_AdvCaptainM2());
	Templates.AddItem(CreateTemplate_AdvCaptainM3());
	Templates.AddItem(CreateTemplate_AdvMEC_M1());
	Templates.AddItem(CreateTemplate_AdvMEC_M2());
	Templates.AddItem(CreateTemplate_AdvPsiWitchM2());
	Templates.AddItem(CreateTemplate_AdvPsiWitchM3());
	Templates.AddItem(CreateTemplate_AdvShieldBearerM2());
	Templates.AddItem(CreateTemplate_AdvShieldBearerM3());
	Templates.AddItem(CreateTemplate_AdvStunLancerM1());
	Templates.AddItem(CreateTemplate_AdvStunLancerM2());
	Templates.AddItem(CreateTemplate_AdvStunLancerM3());
	Templates.AddItem(CreateTemplate_AdvTrooperM1());
	Templates.AddItem(CreateTemplate_AdvTrooperM2());
	Templates.AddItem(CreateTemplate_AdvTrooperM3());
	Templates.AddItem(CreateTemplate_AdvTurretMk1());
	Templates.AddItem(CreateTemplate_AdvTurretMk2());
	Templates.AddItem(CreateTemplate_AdvTurretMk3());
	Templates.AddItem(CreateTemplate_AdvShortTurretM1());
	Templates.AddItem(CreateTemplate_AdvShortTurretM2());
	Templates.AddItem(CreateTemplate_AdvShortTurretM3());
	Templates.AddItem(CreateTemplate_AdvShortTurret());
	Templates.AddItem(CreateTemplate_Andromedon());
	Templates.AddItem(CreateTemplate_AndromedonRobot());
	Templates.AddItem(CreateTemplate_Archon());
	Templates.AddItem(CreateTemplate_Berserker());
	Templates.AddItem(CreateTemplate_Chryssalid());
	Templates.AddItem(CreateTemplate_Cyberus());
	Templates.AddItem(CreateTemplate_Faceless());
	Templates.AddItem(CreateTemplate_Gatekeeper());
	Templates.AddItem(CreateTemplate_Muton());
	Templates.AddItem(CreateTemplate_Sectoid());
	Templates.AddItem(CreateTemplate_Sectopod());
	Templates.AddItem(CreateTemplate_PrototypeSectopod());
	Templates.AddItem(CreateTemplate_Viper());
	Templates.AddItem(CreateTemplate_PsiZombie());
	Templates.AddItem(CreateTemplate_PsiZombieHuman());	
	Templates.AddItem(CreateTemplate_TheLost('TheLost', 'TheLostTier1_Loadout'));
	Templates.AddItem(CreateTemplate_TheLostDasher('TheLostDasher', 'TheLostTier1_Loadout'));
	Templates.AddItem(CreateTemplate_TheLostHowler('TheLostHowler', 'TheLostHowlerTier1_MeleeAttack'));
	Templates.AddItem(CreateTemplate_AdventTroopTransport());
	Templates.AddItem(CreateTemplate_ChryssalidCocoon());
	Templates.AddItem(CreateTemplate_ChryssalidCocoonHuman());

	Templates.AddItem(CreateTemplate_AdvCounterOpM1());
	Templates.AddItem(CreateTemplate_AdvCounterOpM2());
	Templates.AddItem(CreateTemplate_AdvCounterOpM3());

	Templates.AddItem(CreateTemplate_AdvCounterOpCommanderM1());
	Templates.AddItem(CreateTemplate_AdvCounterOpCommanderM2());
	Templates.AddItem(CreateTemplate_AdvCounterOpCommanderM3());

	Templates.AddItem(CreateTemplate_AdvGeneralM1());
	Templates.AddItem(CreateTemplate_AdvGeneralM2());
	Templates.AddItem(CreateTemplate_AdvGeneralM3());

	Templates.AddItem(CreateTemplate_MimicBeacon());

	Templates.AddItem(CreateTemplate_TestDummyPanic());

	// characters that only exist to serve as speakers for conversations (template name, speaker name, speaker portrait image path)
	Templates.AddItem(CreateSpeakerTemplate('Council', "Council", "img:///UILibrary_Common.Head_Council"));
	Templates.AddItem(CreateSpeakerTemplate('Denmother', "Denmother", "img:///UILibrary_Common.Head_Denmother"));
	Templates.AddItem(CreateSpeakerTemplate('ShipAI', "Ship AI", "img:///UILibrary_Common.Head_ShipAI", eGender_Female));
	Templates.AddItem(CreateSpeakerTemplate('AdventSpokesman', "Spokesman", "img:///UILibrary_Common.Head_Speaker"));
	Templates.AddItem(CreateSpeakerTemplate('Firebrand', "Firebrand", "img:///UILibrary_Common.Head_Firebrand", eGender_Female));
	Templates.AddItem(CreateSpeakerTemplate('Ethereal', "Ethereal", "img:///UILibrary_Common.Head_Ethereal"));
	Templates.AddItem(CreateSpeakerTemplate('TutorialOsei', "Osei", "img:///UILibrary_Common.Head_Osei"));
	Templates.AddItem(CreateSpeakerTemplate('TutorialRamirez', "Ramirez",  "img:///UILibrary_Common.Head_Ramirez", eGender_Female));
	Templates.AddItem(CreateSpeakerTemplate('TutorialKelly', "Kelly", "img:///UILibrary_Common.Head_Kelly", eGender_Female));
	Templates.AddItem(CreateSpeakerTemplate('Speaker', "Speaker", "img:///UILibrary_Common.Head_Speaker"));
	Templates.AddItem(CreateSpeakerTemplate('PropagandaAnnouncer', "Propaganda Announcer", "img:///UILibrary_Common.Head_Propaganda"));
	Templates.AddItem(CreateSpeakerTemplate('AngelisEthereal', "Angelis Ethereal", "img:///UILibrary_Common.Head_AngelisEthereal"));
	Templates.AddItem(CreateSpeakerTemplate('ShadowShen', "Avenger", "img:///UILibrary_Common.Head_ShadowShen", eGender_Female));
	Templates.AddItem(CreateSpeakerTemplate('EmptyHead', "Empty Head", "img:///UILibrary_Common.Head_Empty"));

	///////////FOR XPAC/////////////
	Templates.AddItem(CreateTemplate_ReaperSoldier());
	Templates.AddItem(CreateTemplate_SkirmisherSoldier());
	Templates.AddItem(CreateTemplate_TemplarSoldier());

	Templates.AddItem(CreateTemplate_LostAndAbandonedElena());
	Templates.AddItem(CreateTemplate_LostAndAbandonedMox());

	Templates.AddItem(CreateTemplate_ChosenAssassin());
	Templates.AddItem(CreateTemplate_ChosenAssassinM2());
	Templates.AddItem(CreateTemplate_ChosenAssassinM3());
	Templates.AddItem(CreateTemplate_ChosenAssassinM4());
	
	Templates.AddItem(CreateTemplate_ChosenWarlock());
	Templates.AddItem(CreateTemplate_ChosenWarlockM2());
	Templates.AddItem(CreateTemplate_ChosenWarlockM3());
	Templates.AddItem(CreateTemplate_ChosenWarlockM4());
	
	Templates.AddItem(CreateTemplate_ChosenSniper());
	Templates.AddItem(CreateTemplate_ChosenSniperM2());
	Templates.AddItem(CreateTemplate_ChosenSniperM3());
	Templates.AddItem(CreateTemplate_ChosenSniperM4());

	Templates.AddItem(CreateCivilianMilitiaTemplate('CivilianMilitia'));
	Templates.AddItem(CreateCivilianMilitiaM2Template());
	Templates.AddItem(CreateCivilianMilitiaM3Template());
	Templates.AddItem(CreateVolunteerArmyMilitiaTemplate('VolunteerArmyMilitia'));
	Templates.AddItem(CreateVolunteerArmyMilitiaM2Template());
	Templates.AddItem(CreateVolunteerArmyMilitiaM3Template());

	Templates.AddItem(CreateTemplate_TheLost('TheLostHP2', 'TheLostTier1_Loadout'));
	Templates.AddItem(CreateTemplate_TheLost('TheLostHP3', 'TheLostTier1_Loadout'));
	Templates.AddItem(CreateTemplate_TheLost('TheLostHP4', 'TheLostTier1_Loadout'));
	Templates.AddItem(CreateTemplate_TheLost('TheLostHP5', 'TheLostTier1_Loadout'));
	Templates.AddItem(CreateTemplate_TheLost('TheLostHP6', 'TheLostTier2_Loadout'));
	Templates.AddItem(CreateTemplate_TheLost('TheLostHP7', 'TheLostTier2_Loadout'));
	Templates.AddItem(CreateTemplate_TheLost('TheLostHP8', 'TheLostTier3_Loadout'));
	Templates.AddItem(CreateTemplate_TheLost('TheLostHP9', 'TheLostTier3_Loadout'));
	Templates.AddItem(CreateTemplate_TheLost('TheLostHP10', 'TheLostTier3_Loadout'));
	Templates.AddItem(CreateTemplate_TheLost('TheLostHP11', 'TheLostTier3_Loadout'));
	Templates.AddItem(CreateTemplate_TheLost('TheLostHP12', 'TheLostTier3_Loadout'));

	Templates.AddItem(CreateTemplate_TheLostDasher('TheLostDasherHP2', 'TheLostTier1_Loadout'));
	Templates.AddItem(CreateTemplate_TheLostDasher('TheLostDasherHP3', 'TheLostTier1_Loadout'));
	Templates.AddItem(CreateTemplate_TheLostDasher('TheLostDasherHP4', 'TheLostTier1_Loadout'));
	Templates.AddItem(CreateTemplate_TheLostDasher('TheLostDasherHP5', 'TheLostTier1_Loadout'));
	Templates.AddItem(CreateTemplate_TheLostDasher('TheLostDasherHP6', 'TheLostTier2_Loadout'));
	Templates.AddItem(CreateTemplate_TheLostDasher('TheLostDasherHP7', 'TheLostTier2_Loadout'));
	Templates.AddItem(CreateTemplate_TheLostDasher('TheLostDasherHP8', 'TheLostTier3_Loadout'));
	Templates.AddItem(CreateTemplate_TheLostDasher('TheLostDasherHP9', 'TheLostTier3_Loadout'));
	Templates.AddItem(CreateTemplate_TheLostDasher('TheLostDasherHP10', 'TheLostTier3_Loadout'));
	Templates.AddItem(CreateTemplate_TheLostDasher('TheLostDasherHP11', 'TheLostTier3_Loadout'));
	Templates.AddItem(CreateTemplate_TheLostDasher('TheLostDasherHP12', 'TheLostTier3_Loadout'));
	Templates.AddItem(CreateTemplate_TheLostDasher('TheLostDasherHP13', 'TheLostTier3_Loadout'));
	Templates.AddItem(CreateTemplate_TheLostDasher('TheLostDasherHP14', 'TheLostTier3_Loadout'));
	Templates.AddItem(CreateTemplate_TheLostDasher('TheLostDasherHP15', 'TheLostTier3_Loadout'));
	Templates.AddItem(CreateTemplate_TheLostDasher('TheLostDasherHP16', 'TheLostTier3_Loadout'));
	Templates.AddItem(CreateTemplate_TheLostDasher('TheLostDasherHP17', 'TheLostTier3_Loadout'));
	Templates.AddItem(CreateTemplate_TheLostDasher('TheLostDasherHP18', 'TheLostTier3_Loadout'));
	Templates.AddItem(CreateTemplate_TheLostDasher('TheLostDasherHP19', 'TheLostTier3_Loadout'));
	Templates.AddItem(CreateTemplate_TheLostDasher('TheLostDasherHP20', 'TheLostTier3_Loadout'));
	Templates.AddItem(CreateTemplate_TheLostDasher('TheLostDasherHP21', 'TheLostTier3_Loadout'));
	Templates.AddItem(CreateTemplate_TheLostDasher('TheLostDasherHP22', 'TheLostTier3_Loadout'));

	Templates.AddItem(CreateTemplate_TheLostHowler('TheLostHowlerHP4', 'TheLostHowlerTier1_Loadout'));
	Templates.AddItem(CreateTemplate_TheLostHowler('TheLostHowlerHP5', 'TheLostHowlerTier1_Loadout'));
	Templates.AddItem(CreateTemplate_TheLostHowler('TheLostHowlerHP6', 'TheLostHowlerTier1_Loadout'));
	Templates.AddItem(CreateTemplate_TheLostHowler('TheLostHowlerHP7', 'TheLostHowlerTier1_Loadout'));
	Templates.AddItem(CreateTemplate_TheLostHowler('TheLostHowlerHP8', 'TheLostHowlerTier2_Loadout'));
	Templates.AddItem(CreateTemplate_TheLostHowler('TheLostHowlerHP9', 'TheLostHowlerTier2_Loadout'));
	Templates.AddItem(CreateTemplate_TheLostHowler('TheLostHowlerHP10', 'TheLostHowlerTier2_Loadout'));
	Templates.AddItem(CreateTemplate_TheLostHowler('TheLostHowlerHP11', 'TheLostHowlerTier2_Loadout'));
	Templates.AddItem(CreateTemplate_TheLostHowler('TheLostHowlerHP12', 'TheLostHowlerTier2_Loadout'));
	Templates.AddItem(CreateTemplate_TheLostHowler('TheLostHowlerHP13', 'TheLostHowlerTier3_Loadout'));
	Templates.AddItem(CreateTemplate_TheLostHowler('TheLostHowlerHP14', 'TheLostHowlerTier3_Loadout'));
	Templates.AddItem(CreateTemplate_TheLostHowler('TheLostHowlerHP15', 'TheLostHowlerTier3_Loadout'));
	Templates.AddItem(CreateTemplate_TheLostHowler('TheLostHowlerHP16', 'TheLostHowlerTier3_Loadout'));
	Templates.AddItem(CreateTemplate_TheLostHowler('TheLostHowlerHP17', 'TheLostHowlerTier3_Loadout'));
	Templates.AddItem(CreateTemplate_TheLostHowler('TheLostHowlerHP18', 'TheLostHowlerTier3_Loadout'));
	Templates.AddItem(CreateTemplate_TheLostHowler('TheLostHowlerHP19', 'TheLostHowlerTier3_Loadout'));
	Templates.AddItem(CreateTemplate_TheLostHowler('TheLostHowlerHP20', 'TheLostHowlerTier3_Loadout'));
	Templates.AddItem(CreateTemplate_TheLostHowler('TheLostHowlerHP21', 'TheLostHowlerTier3_Loadout'));
	Templates.AddItem(CreateTemplate_TheLostHowler('TheLostHowlerHP22', 'TheLostHowlerTier3_Loadout'));

	Templates.AddItem(CreateTemplate_SpectreM1());
	Templates.AddItem(CreateTemplate_SpectreM2());

	Templates.AddItem(CreateTemplate_ShadowbindUnit('ShadowbindUnit'));
	Templates.AddItem(CreateTemplate_ShadowbindUnit('ShadowbindUnitM2'));

	Templates.AddItem(CreateTemplate_AdvPurifierM1());
	Templates.AddItem(CreateTemplate_AdvPurifierM2());
	Templates.AddItem(CreateTemplate_AdvPurifierM3());

	Templates.AddItem(CreateTemplate_AdvPriestM1());
	Templates.AddItem(CreateTemplate_AdvPriestM2());
	Templates.AddItem(CreateTemplate_AdvPriestM3());

	Templates.AddItem(CreateTemplate_SpectralStunLancer('SpectralStunLancerM1', 'SpectralStunLancerM1_Loadout'));
	Templates.AddItem(CreateTemplate_SpectralStunLancer('SpectralStunLancerM3', 'SpectralStunLancerM2_Loadout'));
	Templates.AddItem(CreateTemplate_SpectralStunLancer('SpectralStunLancerM2', 'SpectralStunLancerM3_Loadout'));
	Templates.AddItem(CreateTemplate_SpectralStunLancer('SpectralStunLancerM4', 'SpectralStunLancerM4_Loadout'));

	Templates.AddItem(CreateTemplate_SpectralZombie('SpectralZombieM1', 'SpectralZombieM1_Loadout'));
	Templates.AddItem(CreateTemplate_SpectralZombie('SpectralZombieM2', 'SpectralZombieM2_Loadout'));
	Templates.AddItem(CreateTemplate_SpectralZombie('SpectralZombieM3', 'SpectralZombieM3_Loadout'));
	Templates.AddItem(CreateTemplate_SpectralZombie('SpectralZombieM4', 'SpectralZombieM4_Loadout'));

	// XPack Speaker Templates
	Templates.AddItem(CreateSpeakerTemplate('ReaperLeader', "Volk", "img:///UILibrary_XPACK_Common.Head_Hero_Volk_Reaper"));
	Templates.AddItem(CreateSpeakerTemplate('SkirmisherLeader', "Betos", "img:///UILibrary_XPACK_Common.Head_Hero_Betos_Skirmisher", eGender_Female));
	Templates.AddItem(CreateSpeakerTemplate('TemplarLeader', "Kalu", "img:///UILibrary_XPACK_Common.Head_Hero_Kalu_Templar"));

	Templates.AddItem(CreateSpeakerTemplate('ReaperElena', "Elena", "img:///UILibrary_XPACK_Common.Head_Hero_Elena_Reaper", eGender_Female));
	Templates.AddItem(CreateSpeakerTemplate('SkirmisherMox', "Mox", "img:///UILibrary_XPACK_Common.Head_Hero_Mox_Skirmisher"));
	Templates.AddItem(CreateSpeakerTemplate('TemplarJeriah', "Jeriah", "img:///UILibrary_XPACK_Common.Head_Hero_Jariah_Templar"));

	Templates.AddItem(CreateSpeakerTemplate('ResistanceDJ', "Resistance Radio", "img:///UILibrary_XPACK_Common.Head_Radio"));
	Templates.AddItem(CreateSpeakerTemplate('Singer', "Resistance Radio", "img:///UILibrary_XPACK_Common.Head_Radio"));

	return Templates;
}

// **************************************************************************
// ***                         XCom Templates                             ***
// **************************************************************************

static function X2CharacterTemplate CreateSoldierTemplate(optional name TemplateName = 'Soldier')
{
	local X2CharacterTemplate CharTemplate;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, TemplateName);	
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
	CharTemplate.bCanBeCriticallyWounded = true;
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
	CharTemplate.bUsePoolSoldiers = true;
	CharTemplate.bStaffingAllowed = true;
	CharTemplate.bAppearInBase = true;
	CharTemplate.strMatineePackages.AddItem("CIN_Soldier");
	CharTemplate.strIntroMatineeSlotPrefix = "Char";
	CharTemplate.strLoadingMatineeSlotPrefix = "Soldier";
	CharTemplate.bUsesWillSystem = true;

	CharTemplate.DefaultSoldierClass = 'Rookie';
	CharTemplate.DefaultLoadout = 'RookieSoldier';
	CharTemplate.RequiredLoadout = 'RequiredSoldier';
	CharTemplate.Abilities.AddItem('Loot');
	CharTemplate.Abilities.AddItem('Interact_PlantBomb');
	CharTemplate.Abilities.AddItem('Interact_TakeVial');
	CharTemplate.Abilities.AddItem('Interact_StasisTube');
	CharTemplate.Abilities.AddItem('Interact_MarkSupplyCrate');
	CharTemplate.Abilities.AddItem('Interact_ActivateAscensionGate');
	CharTemplate.Abilities.AddItem('CarryUnit');
	CharTemplate.Abilities.AddItem('PutDownUnit');
	CharTemplate.Abilities.AddItem('Evac');
	CharTemplate.Abilities.AddItem('PlaceEvacZone');
	CharTemplate.Abilities.AddItem('LiftOffAvenger');
	CharTemplate.Abilities.AddItem('Knockout');
	CharTemplate.Abilities.AddItem('KnockoutSelf');
	CharTemplate.Abilities.AddItem('Panicked');
	CharTemplate.Abilities.AddItem('Berserk');
	CharTemplate.Abilities.AddItem('Obsessed');
	CharTemplate.Abilities.AddItem('Shattered');
	CharTemplate.Abilities.AddItem('HunkerDown');
	CharTemplate.Abilities.AddItem('DisableConsumeAllPoints');
	CharTemplate.Abilities.AddItem('Revive');

	// bondmate abilities
	//CharTemplate.Abilities.AddItem('BondmateResistantWill');
	CharTemplate.Abilities.AddItem('BondmateSolaceCleanse');
	CharTemplate.Abilities.AddItem('BondmateSolacePassive');
	CharTemplate.Abilities.AddItem('BondmateTeamwork');
	CharTemplate.Abilities.AddItem('BondmateTeamwork_Improved');
	CharTemplate.Abilities.AddItem('BondmateSpotter_Aim');
	CharTemplate.Abilities.AddItem('BondmateSpotter_Aim_Adjacency');
	//CharTemplate.Abilities.AddItem('BondmateSpotter_Crit');
	//CharTemplate.Abilities.AddItem('BondmateSpotter_Crit_Adjacency');
	//CharTemplate.Abilities.AddItem('BondmateReturnFire_Passive');
	//CharTemplate.Abilities.AddItem('BondmateReturnFire');
	//CharTemplate.Abilities.AddItem('BondmateReturnFire_Adjacency');
	//CharTemplate.Abilities.AddItem('BondmateReturnFire_Improved_Passive');
	//CharTemplate.Abilities.AddItem('BondmateReturnFire_Improved');
	//CharTemplate.Abilities.AddItem('BondmateReturnFire_Improved_Adjacency');
	CharTemplate.Abilities.AddItem('BondmateDualStrike');

	CharTemplate.AddTemplateAvailablility(CharTemplate.BITFIELD_GAMEAREA_Multiplayer); // Allow in MP!
	CharTemplate.MPPointValue = CharTemplate.XpKillscore * 10;
	
	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_XCom;
	CharTemplate.strAutoRunNonAIBT = "SoldierAutoRunTree";
	CharTemplate.CharacterGeneratorClass = class'XGCharacterGenerator';

	return CharTemplate;
}

static function X2CharacterTemplate CreateTutorialCentralTemplate()
{
	local X2CharacterTemplate CharTemplate;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, 'TutorialCentral');
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
	CharTemplate.bCanBeCriticallyWounded = true;
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


	CharTemplate.DefaultLoadout = 'RookieSoldier';
	CharTemplate.RequiredLoadout = 'RequiredSoldier';
	CharTemplate.Abilities.AddItem('Loot');
	CharTemplate.Abilities.AddItem('CarryUnit');
	CharTemplate.Abilities.AddItem('PutDownUnit');
	CharTemplate.Abilities.AddItem('Evac');
	CharTemplate.Abilities.AddItem('PlaceEvacZone');
	CharTemplate.Abilities.AddItem('LiftOffAvenger');
	CharTemplate.Abilities.AddItem('Knockout');
	CharTemplate.Abilities.AddItem('Panicked');

	CharTemplate.AddTemplateAvailablility(CharTemplate.BITFIELD_GAMEAREA_Multiplayer); // Allow in MP!
	CharTemplate.MPPointValue = CharTemplate.XpKillscore * 10;
	
	CharTemplate.bForceAppearance = true;
	CharTemplate.ForceAppearance.nmPawn		= 'XCom_Central';
	CharTemplate.ForceAppearance.nmTorso	= 'Central_Torso_A';
	CharTemplate.ForceAppearance.nmArms		= 'Central_Arms_A';
	CharTemplate.ForceAppearance.nmLegs		= 'Central_Legs_A';
	CharTemplate.ForceAppearance.nmHead		= 'Central';
	CharTemplate.ForceAppearance.nmHaircut	= 'Central_Hair';
	CharTemplate.ForceAppearance.nmBeard	= 'Central_Beard';

	CharTemplate.bShouldCreateDifficultyVariants = false;

	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_XCom;
	CharTemplate.CharacterGeneratorClass = class'XGCharacterGenerator';

	return CharTemplate;
}

static function X2CharacterTemplate CreateStrategyCentralTemplate()
{
	local X2CharacterTemplate CharTemplate;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, 'StrategyCentral');
	CharTemplate.CharacterBaseStats[eStat_HP] = 1;
	CharTemplate.CharacterBaseStats[eStat_Offense] = 0;
	CharTemplate.CharacterBaseStats[eStat_Defense] = 0;
	CharTemplate.CharacterBaseStats[eStat_Mobility] = 12;
	CharTemplate.CharacterBaseStats[eStat_SightRadius] = 27;
	CharTemplate.CharacterBaseStats[eStat_Will] = 50;
	CharTemplate.CharacterBaseStats[eStat_FlightFuel] = 0;
	CharTemplate.CharacterBaseStats[eStat_UtilityItems] = 1;
	CharTemplate.CharacterBaseStats[eStat_AlertLevel] = 2;
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
	CharTemplate.bCanBeCriticallyWounded = true;
	CharTemplate.bCanBeTerrorist = false;
	CharTemplate.bAppearanceDefinesPawn = true;
	CharTemplate.bIsAfraidOfFire = true;
	CharTemplate.bIsAlien = false;
	CharTemplate.bIsCivilian = true;
	CharTemplate.bIsPsionic = false;
	CharTemplate.bIsRobotic = false;
	CharTemplate.bIsSoldier = false;
	CharTemplate.bCanTakeCover = true;
	CharTemplate.bCanBeCarried = true;
	CharTemplate.bCanBeRevived = true;
	CharTemplate.bAppearInBase = true;
	CharTemplate.strMatineePackages.AddItem("CIN_Soldier");

	CharTemplate.DefaultLoadout = 'RookieSoldier';
	CharTemplate.RequiredLoadout = 'RequiredSoldier';
	CharTemplate.Abilities.AddItem('Loot');
	CharTemplate.Abilities.AddItem('CarryUnit');
	CharTemplate.Abilities.AddItem('PutDownUnit');
	CharTemplate.Abilities.AddItem('Evac');
	CharTemplate.Abilities.AddItem('PlaceEvacZone');
	CharTemplate.Abilities.AddItem('LiftOffAvenger');
	CharTemplate.Abilities.AddItem('Knockout');
	CharTemplate.Abilities.AddItem('Panicked');

	CharTemplate.AddTemplateAvailablility(CharTemplate.BITFIELD_GAMEAREA_Multiplayer); // Allow in MP!
	CharTemplate.MPPointValue = CharTemplate.XpKillscore * 10;
	
	CharTemplate.bForceAppearance = true;
	CharTemplate.ForceAppearance.nmPawn		= 'XCom_StratCentral';
	CharTemplate.ForceAppearance.nmTorso	= 'Central_Torso_B';
	CharTemplate.ForceAppearance.nmArms	= 'Central_Arms_B';
	CharTemplate.ForceAppearance.nmLegs	= 'Central_Legs_B';
	CharTemplate.ForceAppearance.nmHead	= 'Central';
	CharTemplate.ForceAppearance.nmHaircut= 'Central_Hair';

	CharTemplate.SpeakerPortrait = "img:///UILibrary_Common.Head_Central";
	
	CharTemplate.bShouldCreateDifficultyVariants = false;

	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_XCom;
	CharTemplate.CharacterGeneratorClass = class'XGCharacterGenerator';

	return CharTemplate;
}

static function X2CharacterTemplate CreateCivilianTemplate(optional name TemplateName = 'Civilian')
{
	local X2CharacterTemplate CharTemplate;
	
	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, TemplateName);
	CharTemplate.UnitSize = 1;
	CharTemplate.CanFlankUnits = false;
	CharTemplate.BehaviorClass = class'XGAIBehavior_Civilian';
	CharTemplate.bCanUse_eTraversal_Normal = true;
	CharTemplate.bCanUse_eTraversal_ClimbOver = true;
	CharTemplate.bCanUse_eTraversal_ClimbOnto = true;
	CharTemplate.bCanUse_eTraversal_ClimbLadder = true;
	CharTemplate.bCanUse_eTraversal_DropDown = false;
	CharTemplate.bCanUse_eTraversal_Grapple = false;
	CharTemplate.bCanUse_eTraversal_Landing = true;
	CharTemplate.bCanUse_eTraversal_BreakWindow = false;
	CharTemplate.bCanUse_eTraversal_KickDoor = true;
	CharTemplate.bCanUse_eTraversal_JumpUp = false;
	CharTemplate.bCanUse_eTraversal_WallClimb = false;
	CharTemplate.bCanUse_eTraversal_BreakWall = false;
	CharTemplate.bCanBeCriticallyWounded = false;
	CharTemplate.bCanBeTerrorist = false;
	CharTemplate.bAppearanceDefinesPawn = true;
	CharTemplate.bIsAfraidOfFire = true;
	CharTemplate.bIsAlien = false;
	CharTemplate.bIsCivilian = true;
	CharTemplate.bIsPsionic = false;
	CharTemplate.bIsRobotic = false;
	CharTemplate.bIsSoldier = false;
	CharTemplate.bCanTakeCover = true;
	CharTemplate.bDisplayUIUnitFlag=false;
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_XComCivilians.ARC_Unit_XComCivilianUnisex");

	CharTemplate.Abilities.AddItem('Evac');
	CharTemplate.Abilities.AddItem('HunkerDown');
	CharTemplate.Abilities.AddItem('CivilianPanicked');
	CharTemplate.Abilities.AddItem('CivilianInitialState');
	CharTemplate.Abilities.AddItem('CivilianEasyToHit');
	CharTemplate.Abilities.AddItem('CivilianRescuedState');
	CharTemplate.strBehaviorTree="CivRoot";

	CharTemplate.DefaultAppearance.nmVoice = 'CivilianUnisexVoice1_Localized';

	CharTemplate.bShouldCreateDifficultyVariants = false;

	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_Civilian;
	CharTemplate.CharacterGeneratorClass = class'XGCharacterGenerator';

	return CharTemplate;
}

static function X2CharacterTemplate CreateFacelessCivilianTemplate(optional name TemplateName = 'FacelessCivilian')
{
	local X2CharacterTemplate CharTemplate;
	
	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, TemplateName);
	CharTemplate.UnitSize = 1;
	CharTemplate.CanFlankUnits = false;
	CharTemplate.BehaviorClass = class'XGAIBehavior_Civilian';
	CharTemplate.bCanUse_eTraversal_Normal = true;
	CharTemplate.bCanUse_eTraversal_ClimbOver = true;
	CharTemplate.bCanUse_eTraversal_ClimbOnto = true;
	CharTemplate.bCanUse_eTraversal_ClimbLadder = true;
	CharTemplate.bCanUse_eTraversal_DropDown = false;
	CharTemplate.bCanUse_eTraversal_Grapple = false;
	CharTemplate.bCanUse_eTraversal_Landing = true;
	CharTemplate.bCanUse_eTraversal_BreakWindow = false;
	CharTemplate.bCanUse_eTraversal_KickDoor = true;
	CharTemplate.bCanUse_eTraversal_JumpUp = false;
	CharTemplate.bCanUse_eTraversal_WallClimb = false;
	CharTemplate.bCanUse_eTraversal_BreakWall = false;
	CharTemplate.bCanBeCriticallyWounded = false;
	CharTemplate.bCanBeTerrorist = false;
	CharTemplate.bAppearanceDefinesPawn = true;
	CharTemplate.bIsAfraidOfFire = true;
	CharTemplate.bIsAlien = true;
	CharTemplate.bIsCivilian = true;
	//CharTemplate.bIsCivilian = false;
	CharTemplate.bIsPsionic = false;
	CharTemplate.bIsRobotic = false;
	CharTemplate.bIsSoldier = false;
	CharTemplate.bCanTakeCover = true;
	CharTemplate.bDisplayUIUnitFlag=false;
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_XComCivilians.ARC_Unit_XComCivilianUnisex");

	//CharTemplate.Abilities.AddItem('Evac');
	CharTemplate.Abilities.AddItem('ChangeForm');
	CharTemplate.Abilities.AddItem('HunkerDown');
	//CharTemplate.Abilities.AddItem('CivilianPanicked');
	CharTemplate.Abilities.AddItem('CivilianInitialState');

	CharTemplate.strBehaviorTree="FacelessCivRoot";
	CharTemplate.strPanicBT = "";

	CharTemplate.bShouldCreateDifficultyVariants = false;

	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_Civilian;
	CharTemplate.CharacterGeneratorClass = class'XGCharacterGenerator';

	return CharTemplate;
}

static function X2CharacterTemplate CreateHostileCivilianTemplate( )
{
	local X2CharacterTemplate CharTemplate;

	CharTemplate = CreateCivilianTemplate( 'HostileCivilian' );
	
	CharTemplate.bIsHostileCivilian = true;
	CharTemplate.strBehaviorTree = "HostileCivRoot";

	CharTemplate.bShouldCreateDifficultyVariants = false;

	return CharTemplate;
}

static function X2CharacterTemplate CreateFriendlyVIPCivilianTemplate(optional name TemplateName = 'FriendlyVIPCivilian')
{
	local X2CharacterTemplate CharTemplate;
	
	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, TemplateName);
	CharTemplate.CharacterBaseStats[eStat_HP] = 5;
	CharTemplate.CharacterBaseStats[eStat_Offense] = 0;
	CharTemplate.CharacterBaseStats[eStat_Defense] = 0;
	CharTemplate.CharacterBaseStats[eStat_Mobility] = 12;
	CharTemplate.CharacterBaseStats[eStat_SightRadius] = 14;
	CharTemplate.CharacterBaseStats[eStat_Will] = 50;
	CharTemplate.CharacterBaseStats[eStat_FlightFuel] = 0;
	CharTemplate.CharacterBaseStats[eStat_UtilityItems] = 1;
	CharTemplate.CharacterBaseStats[eStat_AlertLevel] = 2;
	CharTemplate.UnitSize = 1;
	CharTemplate.CanFlankUnits = false;
	CharTemplate.BehaviorClass = class'XGAIBehavior_Civilian';
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
	CharTemplate.bCanBeCarried = true;
	CharTemplate.bCanBeRevived = false;
	CharTemplate.bCanBeCriticallyWounded = false;
	CharTemplate.bCanBeTerrorist = false;
	CharTemplate.bAppearanceDefinesPawn = true;
	CharTemplate.bIsAfraidOfFire = true;
	CharTemplate.bIsAlien = false;
	CharTemplate.bIsCivilian = true;
	CharTemplate.bIsPsionic = false;
	CharTemplate.bIsRobotic = false;
	CharTemplate.bIsSoldier = false;
	CharTemplate.bCanTakeCover = true;
	CharTemplate.bUsePoolVIPs = true;

	CharTemplate.Abilities.AddItem('Evac');
	CharTemplate.Abilities.AddItem('HunkerDown');
	CharTemplate.Abilities.AddItem('KnockoutSelf');
	//CharTemplate.Abilities.AddItem('Panicked');
	CharTemplate.strBehaviorTree="VIPCowardRoot";

	CharTemplate.strPanicBT="";

	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_VIP;
	CharTemplate.CharacterGeneratorClass = class'XGCharacterGenerator';

	return CharTemplate;

}

static function X2CharacterTemplate CreateCommanderVIPTemplate(optional name TemplateName = 'CommanderVIP')
{
	local X2CharacterTemplate CharTemplate;
	
	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, TemplateName);

	CharTemplate.strPawnArchetypes.AddItem("GameUnit_StasisSuit.ARC_StasisSuitVIP");
	
	CharTemplate.CharacterBaseStats[eStat_HP] = 5;
	CharTemplate.CharacterBaseStats[eStat_Offense] = 0;
	CharTemplate.CharacterBaseStats[eStat_Defense] = 0;
	CharTemplate.CharacterBaseStats[eStat_Mobility] = 6;
	CharTemplate.CharacterBaseStats[eStat_SightRadius] = 14;
	CharTemplate.CharacterBaseStats[eStat_Will] = 50;
	CharTemplate.CharacterBaseStats[eStat_FlightFuel] = 0;
	CharTemplate.CharacterBaseStats[eStat_UtilityItems] = 1;
	CharTemplate.CharacterBaseStats[eStat_AlertLevel] = 2;

	CharTemplate.UnitSize = 1;
	CharTemplate.BehaviorClass = class'XGAIBehavior_Civilian';
	CharTemplate.strIntroMatineeSlotPrefix = "Char";

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

	CharTemplate.bCanBeCarried = true;
	CharTemplate.bCanBeCriticallyWounded = false;
	CharTemplate.bCanBeTerrorist = false;
	CharTemplate.bAppearanceDefinesPawn = false;
	CharTemplate.bIsAfraidOfFire = true;
	CharTemplate.bIsAlien = false;
	CharTemplate.bIsCivilian = true;
	CharTemplate.bIsPsionic = false;
	CharTemplate.bIsRobotic = false;
	CharTemplate.bIsSoldier = false;
	CharTemplate.bCanTakeCover = true;

	CharTemplate.bDisplayUIUnitFlag=false;

	CharTemplate.Abilities.AddItem('Evac');
	CharTemplate.Abilities.AddItem('HunkerDown');
	CharTemplate.Abilities.AddItem('KnockoutSelf');
	CharTemplate.strBehaviorTree="VIPRoot";

	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_VIP;
	CharTemplate.CharacterGeneratorClass = class'XGCharacterGenerator';

	return CharTemplate;
}

static function X2CharacterTemplate CreateStasisSuitVIPTemplate(optional name TemplateName = 'StasisSuitVIP')
{
	local X2CharacterTemplate CharTemplate;
	
	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, TemplateName);

	CharTemplate.strPawnArchetypes.AddItem("GameUnit_StasisSuit.ARC_StasisSuitVIP_Silver");
	
	CharTemplate.CharacterBaseStats[eStat_HP] = 5;
	CharTemplate.CharacterBaseStats[eStat_Offense] = 0;
	CharTemplate.CharacterBaseStats[eStat_Defense] = 0;
	CharTemplate.CharacterBaseStats[eStat_Mobility] = 6;
	CharTemplate.CharacterBaseStats[eStat_SightRadius] = 14;
	CharTemplate.CharacterBaseStats[eStat_Will] = 50;
	CharTemplate.CharacterBaseStats[eStat_FlightFuel] = 0;
	CharTemplate.CharacterBaseStats[eStat_UtilityItems] = 1;
	CharTemplate.CharacterBaseStats[eStat_AlertLevel] = 2;

	CharTemplate.UnitSize = 1;
	CharTemplate.BehaviorClass = class'XGAIBehavior_Civilian';

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

	CharTemplate.bCanBeCarried = true;
	CharTemplate.bCanBeCriticallyWounded = false;
	CharTemplate.bCanBeTerrorist = false;
	CharTemplate.bAppearanceDefinesPawn = false;
	CharTemplate.bIsAfraidOfFire = true;
	CharTemplate.bIsAlien = false;
	CharTemplate.bIsCivilian = true;
	CharTemplate.bIsPsionic = false;
	CharTemplate.bIsRobotic = false;
	CharTemplate.bIsSoldier = false;
	CharTemplate.bCanTakeCover = true;

	CharTemplate.Abilities.AddItem('Evac');
	CharTemplate.Abilities.AddItem('HunkerDown');
	CharTemplate.Abilities.AddItem('KnockoutSelf');
	CharTemplate.strBehaviorTree="VIPRoot";

	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_VIP;
	CharTemplate.CharacterGeneratorClass = class'XGCharacterGenerator';

	return CharTemplate;
}

static function X2CharacterTemplate CreateHostileVIPCivilianTemplate()
{
	local X2CharacterTemplate CharTemplate;

	CharTemplate = CreateCivilianTemplate('HostileVIPCivilian');
	CharTemplate.CharacterBaseStats[eStat_HP] = 5;
	CharTemplate.CharacterBaseStats[eStat_Offense] = 0;
	CharTemplate.CharacterBaseStats[eStat_Defense] = 0;
	CharTemplate.CharacterBaseStats[eStat_Mobility] = 12;
	CharTemplate.CharacterBaseStats[eStat_SightRadius] = 14;
	CharTemplate.CharacterBaseStats[eStat_Will] = 50;
	CharTemplate.CharacterBaseStats[eStat_FlightFuel] = 0;
	CharTemplate.CharacterBaseStats[eStat_UtilityItems] = 1;
	CharTemplate.CharacterBaseStats[eStat_AlertLevel] = 2;
	CharTemplate.CharacterBaseStats[eStat_DetectionRadius] = 6;
	CharTemplate.UnitSize = 1;
	CharTemplate.CanFlankUnits = false;
	CharTemplate.BehaviorClass = class'XGAIBehavior_Civilian';
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
	CharTemplate.bIsHostileCivilian = true;
	CharTemplate.bCanBeCarried = true;
	CharTemplate.bCanBeCriticallyWounded = false;
	CharTemplate.bCanBeTerrorist = false;
	CharTemplate.bAppearanceDefinesPawn = true;
	CharTemplate.bIsAfraidOfFire = true;
	CharTemplate.bIsAlien = false;
	CharTemplate.bIsCivilian = true;
	CharTemplate.bIsPsionic = false;
	CharTemplate.bIsRobotic = false;
	CharTemplate.bIsSoldier = false;
	CharTemplate.bCanTakeCover = true;

	CharTemplate.bUsePoolDarkVIPs = true;

	// TODO: Set behavior tree here
	CharTemplate.strBehaviorTree = "VIPCowardRoot";
	CharTemplate.strPanicBT = "";

	//CharTemplate.Abilities.AddItem('Panicked');

	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_VIP;

	return CharTemplate;
}

static function X2CharacterTemplate CreateScientistTemplate()
{
	local X2CharacterTemplate CharTemplate;
	
	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, 'Scientist');
	CharTemplate.CharacterBaseStats[eStat_HP] = 4;
	CharTemplate.CharacterBaseStats[eStat_Offense] = 0;
	CharTemplate.CharacterBaseStats[eStat_Defense] = 0;
	CharTemplate.CharacterBaseStats[eStat_Mobility] = 12;
	CharTemplate.CharacterBaseStats[eStat_SightRadius] = 27;
	CharTemplate.CharacterBaseStats[eStat_Will] = 50;
	CharTemplate.CharacterBaseStats[eStat_FlightFuel] = 0;
	CharTemplate.CharacterBaseStats[eStat_UtilityItems] = 1;
	CharTemplate.CharacterBaseStats[eStat_AlertLevel] = 2;
	CharTemplate.UnitSize = 1;
	CharTemplate.BehaviorClass = class'XGAIBehavior_Civilian';
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
	CharTemplate.bCanBeCriticallyWounded = true;
	CharTemplate.bCanBeTerrorist = false;
	CharTemplate.bAppearanceDefinesPawn = true;
	CharTemplate.bIsAfraidOfFire = true;
	CharTemplate.bIsAlien = false;
	CharTemplate.bIsCivilian = true;
	CharTemplate.bIsPsionic = false;
	CharTemplate.bIsRobotic = false;
	CharTemplate.bIsSoldier = false;
	CharTemplate.bIsScientist = true;
	CharTemplate.bCanTakeCover = true;	
	CharTemplate.bUsePoolVIPs = true;
	CharTemplate.bStaffingAllowed = true;
	CharTemplate.bAppearInBase = true;

	CharTemplate.Abilities.AddItem('Evac');
	CharTemplate.Abilities.AddItem('HunkerDown');
	CharTemplate.strBehaviorTree="VIPCowardRoot";

	// Level-up Thresholds
	CharTemplate.SkillLevelThresholds[0] = 0;
	CharTemplate.SkillLevelThresholds[1] = 0;
	CharTemplate.SkillLevelThresholds[2] = 0;
	CharTemplate.SkillLevelThresholds[3] = 0;
	CharTemplate.SkillLevelThresholds[4] = 0;
	CharTemplate.SkillLevelThresholds[5] = 0;
	CharTemplate.SkillLevelThresholds[6] = 600;
	CharTemplate.SkillLevelThresholds[7] = 1500;
	CharTemplate.SkillLevelThresholds[8] = 2500;
	CharTemplate.SkillLevelThresholds[9] = 4000;
	CharTemplate.SkillLevelThresholds[10] = 6000;
		
	//Give this character type a specific palette selection
	CharTemplate.DefaultAppearance.iArmorTint = class'XComContentManager'.default.DefaultScientistArmorTint;
	CharTemplate.DefaultAppearance.iArmorTintSecondary = class'XComContentManager'.default.DefaultScientistArmorTintSecondary;

	CharTemplate.bShouldCreateDifficultyVariants = false;

	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_Civilian;
	CharTemplate.CharacterGeneratorClass = class'XGCharacterGenerator';
	CharTemplate.strAutoRunNonAIBT = "SoldierAutoRunTree"; // TODO - make a specialized VIP AutoRunTree.

	return CharTemplate;
}

static function X2CharacterTemplate CreateHeadScientistTemplate()
{
	local X2CharacterTemplate CharTemplate;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, 'HeadScientist');
	CharTemplate.CharacterBaseStats[eStat_HP] = 1;
	CharTemplate.CharacterBaseStats[eStat_Offense] = 0;
	CharTemplate.CharacterBaseStats[eStat_Defense] = 0;
	CharTemplate.CharacterBaseStats[eStat_Mobility] = 12;
	CharTemplate.CharacterBaseStats[eStat_SightRadius] = 27;
	CharTemplate.CharacterBaseStats[eStat_Will] = 50;
	CharTemplate.CharacterBaseStats[eStat_FlightFuel] = 0;
	CharTemplate.CharacterBaseStats[eStat_UtilityItems] = 1;
	CharTemplate.CharacterBaseStats[eStat_AlertLevel] = 2;
	CharTemplate.UnitSize = 1;
	CharTemplate.BehaviorClass = class'XGAIBehavior_Civilian';
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
	CharTemplate.bCanBeCriticallyWounded = true;
	CharTemplate.bCanBeTerrorist = false;
	CharTemplate.bAppearanceDefinesPawn = false;
	CharTemplate.bIsAfraidOfFire = true;
	CharTemplate.bIsAlien = false;
	CharTemplate.bIsCivilian = true;
	CharTemplate.bIsPsionic = false;
	CharTemplate.bIsRobotic = false;
	CharTemplate.bIsSoldier = false;
	CharTemplate.bIsScientist = true;
	CharTemplate.bCanTakeCover = true;
	CharTemplate.bStaffingAllowed = false;
	CharTemplate.bAppearInBase = true;
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_HeadScientist.ARC_Unit_HeadScientist");

	CharTemplate.Abilities.AddItem('Evac');
	CharTemplate.Abilities.AddItem('HunkerDown');
	CharTemplate.strBehaviorTree = "CivRoot";

	// Level-up Thresholds
	CharTemplate.SkillLevelThresholds[0] = 0;
	CharTemplate.SkillLevelThresholds[1] = 0;
	CharTemplate.SkillLevelThresholds[2] = 0;
	CharTemplate.SkillLevelThresholds[3] = 0;
	CharTemplate.SkillLevelThresholds[4] = 0;
	CharTemplate.SkillLevelThresholds[5] = 0;
	CharTemplate.SkillLevelThresholds[6] = 0;
	CharTemplate.SkillLevelThresholds[7] = 0;
	CharTemplate.SkillLevelThresholds[8] = 0;
	CharTemplate.SkillLevelThresholds[9] = 0;
	CharTemplate.SkillLevelThresholds[10] = 0;
	
	CharTemplate.SpeakerPortrait = "img:///UILibrary_Common.Head_Tygan";
	
	CharTemplate.bShouldCreateDifficultyVariants = false;

	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_Civilian;
	CharTemplate.CharacterGeneratorClass = class'XGCharacterGenerator';
	CharTemplate.strAutoRunNonAIBT = "SoldierAutoRunTree"; // TODO - make a specialized VIP AutoRunTree.

	return CharTemplate;
}

static function X2CharacterTemplate CreateEngineerTemplate()
{
	local X2CharacterTemplate CharTemplate;
	
	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, 'Engineer');
	CharTemplate.CharacterBaseStats[eStat_HP] = 4;
	CharTemplate.CharacterBaseStats[eStat_Offense] = 0;
	CharTemplate.CharacterBaseStats[eStat_Defense] = 0;
	CharTemplate.CharacterBaseStats[eStat_Mobility] = 12;
	CharTemplate.CharacterBaseStats[eStat_SightRadius] = 27;
	CharTemplate.CharacterBaseStats[eStat_Will] = 50;
	CharTemplate.CharacterBaseStats[eStat_FlightFuel] = 0;
	CharTemplate.CharacterBaseStats[eStat_UtilityItems] = 1;
	CharTemplate.CharacterBaseStats[eStat_AlertLevel] = 2;
	CharTemplate.UnitSize = 1;
	CharTemplate.BehaviorClass = class'XGAIBehavior_Civilian';
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
	CharTemplate.bCanBeCriticallyWounded = true;
	CharTemplate.bCanBeTerrorist = false;
	CharTemplate.bAppearanceDefinesPawn = true;
	CharTemplate.bIsAfraidOfFire = true;
	CharTemplate.bIsAlien = false;
	CharTemplate.bIsCivilian = true;
	CharTemplate.bIsPsionic = false;
	CharTemplate.bIsRobotic = false;
	CharTemplate.bIsSoldier = false;
	CharTemplate.bIsEngineer = true;
	CharTemplate.bCanTakeCover = true;	
	CharTemplate.bUsePoolVIPs = true;
	CharTemplate.bStaffingAllowed = true;
	CharTemplate.bAppearInBase = true;

	CharTemplate.Abilities.AddItem('Evac');
	CharTemplate.Abilities.AddItem('HunkerDown');
	CharTemplate.strBehaviorTree="VIPCowardRoot";

	// Level-up Thresholds
	CharTemplate.SkillLevelThresholds[0] = 0;
	CharTemplate.SkillLevelThresholds[1] = 0;
	CharTemplate.SkillLevelThresholds[2] = 0;
	CharTemplate.SkillLevelThresholds[3] = 0;
	CharTemplate.SkillLevelThresholds[4] = 0;
	CharTemplate.SkillLevelThresholds[5] = 0;
	CharTemplate.SkillLevelThresholds[6] = 600;
	CharTemplate.SkillLevelThresholds[7] = 1500;
	CharTemplate.SkillLevelThresholds[8] = 2500;
	CharTemplate.SkillLevelThresholds[9] = 4000;
	CharTemplate.SkillLevelThresholds[10] = 6000;

	//Give this character type a specific palette selection
	CharTemplate.DefaultAppearance.iArmorTint = class'XComContentManager'.default.DefaultEngineerArmorTint;
	CharTemplate.DefaultAppearance.iArmorTintSecondary = class'XComContentManager'.default.DefaultEngineerArmorTintSecondary;

	CharTemplate.bShouldCreateDifficultyVariants = false;

	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_Civilian;
	CharTemplate.CharacterGeneratorClass = class'XGCharacterGenerator';
	CharTemplate.strAutoRunNonAIBT = "SoldierAutoRunTree"; // TODO - make a specialized VIP AutoRunTree.

	return CharTemplate;
}

static function X2CharacterTemplate CreateHeadEngineerTemplate()
{
	local X2CharacterTemplate CharTemplate;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, 'HeadEngineer');
	CharTemplate.CharacterBaseStats[eStat_HP] = 1;
	CharTemplate.CharacterBaseStats[eStat_Offense] = 0;
	CharTemplate.CharacterBaseStats[eStat_Defense] = 0;
	CharTemplate.CharacterBaseStats[eStat_Mobility] = 12;
	CharTemplate.CharacterBaseStats[eStat_SightRadius] = 27;
	CharTemplate.CharacterBaseStats[eStat_Will] = 50;
	CharTemplate.CharacterBaseStats[eStat_FlightFuel] = 0;
	CharTemplate.CharacterBaseStats[eStat_UtilityItems] = 1;
	CharTemplate.CharacterBaseStats[eStat_AlertLevel] = 2;
	CharTemplate.UnitSize = 1;
	CharTemplate.BehaviorClass = class'XGAIBehavior_Civilian';
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
	CharTemplate.bCanBeCriticallyWounded = true;
	CharTemplate.bCanBeTerrorist = false;
	CharTemplate.bAppearanceDefinesPawn = false;
	CharTemplate.bIsAfraidOfFire = true;
	CharTemplate.bIsAlien = false;
	CharTemplate.bIsCivilian = true;
	CharTemplate.bIsPsionic = false;
	CharTemplate.bIsRobotic = false;
	CharTemplate.bIsSoldier = false;
	CharTemplate.bIsEngineer = true;
	CharTemplate.bCanTakeCover = true;
	CharTemplate.bStaffingAllowed = false;
	CharTemplate.bAppearInBase = true;
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_HeadEngineer.ARC_Unit_HeadEngineer");	

	CharTemplate.Abilities.AddItem('Evac');
	CharTemplate.Abilities.AddItem('HunkerDown');
	CharTemplate.strBehaviorTree = "CivRoot";

	// Level-up Thresholds
	CharTemplate.SkillLevelThresholds[0] = 0;
	CharTemplate.SkillLevelThresholds[1] = 0;
	CharTemplate.SkillLevelThresholds[2] = 0;
	CharTemplate.SkillLevelThresholds[3] = 0;
	CharTemplate.SkillLevelThresholds[4] = 0;
	CharTemplate.SkillLevelThresholds[5] = 0;
	CharTemplate.SkillLevelThresholds[6] = 600;
	CharTemplate.SkillLevelThresholds[7] = 1500;
	CharTemplate.SkillLevelThresholds[8] = 2500;
	CharTemplate.SkillLevelThresholds[9] = 4000;
	CharTemplate.SkillLevelThresholds[10] = 6000;
	
	CharTemplate.SpeakerPortrait = "img:///UILibrary_Common.Head_Shen";

	CharTemplate.bShouldCreateDifficultyVariants = false;

	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_Civilian;
	CharTemplate.CharacterGeneratorClass = class'XGCharacterGenerator';
	CharTemplate.strAutoRunNonAIBT = "SoldierAutoRunTree"; // TODO - make a specialized VIP AutoRunTree.

	return CharTemplate;
}

static function X2CharacterTemplate CreateHeadquartersClerkTemplate()
{
	local X2CharacterTemplate CharTemplate;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, 'Clerk');
	CharTemplate.CharacterBaseStats[eStat_HP] = 1;
	CharTemplate.CharacterBaseStats[eStat_Offense] = 0;
	CharTemplate.CharacterBaseStats[eStat_Defense] = 0;
	CharTemplate.CharacterBaseStats[eStat_Mobility] = 12;
	CharTemplate.CharacterBaseStats[eStat_SightRadius] = 27;
	CharTemplate.CharacterBaseStats[eStat_Will] = 50;
	CharTemplate.CharacterBaseStats[eStat_FlightFuel] = 0;
	CharTemplate.CharacterBaseStats[eStat_UtilityItems] = 1;
	CharTemplate.CharacterBaseStats[eStat_AlertLevel] = 2;
	CharTemplate.UnitSize = 1;
	CharTemplate.BehaviorClass = class'XGAIBehavior_Civilian';
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
	CharTemplate.bCanBeCriticallyWounded = true;
	CharTemplate.bCanBeTerrorist = false;
	CharTemplate.bAppearanceDefinesPawn = true;
	CharTemplate.bIsAfraidOfFire = true;
	CharTemplate.bIsAlien = false;
	CharTemplate.bIsCivilian = true;
	CharTemplate.bIsPsionic = false;
	CharTemplate.bIsRobotic = false;
	CharTemplate.bIsSoldier = false;
	CharTemplate.bIsEngineer = false;
	CharTemplate.bCanTakeCover = true;
	CharTemplate.bUsePoolVIPs = false;
	CharTemplate.bStaffingAllowed = false;
	CharTemplate.bAppearInBase = true;

	CharTemplate.Abilities.AddItem('Evac');
	CharTemplate.Abilities.AddItem('HunkerDown');
	CharTemplate.strBehaviorTree = "VIPCowardRoot";

	//Give this character type a specific palette selection
	CharTemplate.DefaultAppearance.iArmorTint = -1;
	CharTemplate.DefaultAppearance.iArmorTintSecondary = -1;

	CharTemplate.bShouldCreateDifficultyVariants = false;

	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_Civilian;
	CharTemplate.CharacterGeneratorClass = class'XGCharacterGenerator';

	return CharTemplate;
}

static function X2CharacterTemplate CreateGremlinMk1Template()
{
	local X2CharacterTemplate CharTemplate;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, 'GremlinMk1');
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
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_GremlinMk1.ARC_GameUnit_GremlinMk1");
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

static function X2CharacterTemplate CreateGremlinMk2Template()
{
	local X2CharacterTemplate CharTemplate;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, 'GremlinMk2');
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
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_GremlinMk2.ARC_GameUnit_GremlinMk2");
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

static function X2CharacterTemplate CreateGremlinMk3Template()
{
	local X2CharacterTemplate CharTemplate;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, 'GremlinMk3');
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
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_GremlinMk3.ARC_GameUnit_GremlinMk3");
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

static function CreateDefaultTurretTemplate(out X2CharacterTemplate CharTemplate, Name TemplateName, bool bShort=false)
{
	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, TemplateName);
	CharTemplate.BehaviorClass = class'XGAIBehavior';
	CharTemplate.strMatineePackages.AddItem("CIN_Turret");
	CharTemplate.strTargetingMatineePrefix = "CIN_Turret_FF_StartPos";
	if( bShort )
	{
		CharTemplate.RevealMatineePrefix = "CIN_Turret_Short";
		CharTemplate.strPawnArchetypes.AddItem("GameUnit_AdvTurret.ARC_GameUnit_AdvTurretVan");
	}
	else
	{
		CharTemplate.RevealMatineePrefix = "CIN_Turret_Tall";
		CharTemplate.strPawnArchetypes.AddItem("GameUnit_AdvTurret.ARC_GameUnit_AdvTurretM1");
	}

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
	CharTemplate.bIsAdvent = false;
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
}

static function X2CharacterTemplate CreateTemplate_XComTurretMk1(optional name TemplateName = 'XComTurretM1')
{
	local X2CharacterTemplate CharTemplate;

	CreateDefaultTurretTemplate(CharTemplate, TemplateName);
	CharTemplate.DefaultLoadout = 'XComTurretM1_Loadout';
	return CharTemplate;
}

static function X2CharacterTemplate CreateTemplate_XComTurretMk2(optional name TemplateName = 'XComTurretM2')
{
	local X2CharacterTemplate CharTemplate;

	CreateDefaultTurretTemplate(CharTemplate, TemplateName);
	CharTemplate.DefaultLoadout = 'XComTurretM2_Loadout';
	return CharTemplate;
}

// **************************************************************************
// ***                         Enemy Templates                            ***
// **************************************************************************

// **************************************************************************

static function X2CharacterTemplate CreateTemplate_AdventTroopTransport( )
{
	local X2CharacterTemplate CharTemplate;
	local LootReference Loot;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, 'AdventTroopTransport');
	CharTemplate.DefaultLoadout = 'AdvCaptainM1_Loadout';
	CharTemplate.BehaviorClass = class'XGAIBehavior_AdventTroopTransport';
	CharTemplate.strPawnArchetypes.AddItem( "GameUnit_AdventTroopTransport.ARC_GameUnit_AdventTroopTransport" );

	CharTemplate.UnitSize = 4;
	CharTemplate.bCanUse_eTraversal_Normal = false;
	CharTemplate.bCanUse_eTraversal_ClimbOver = false;
	CharTemplate.bCanUse_eTraversal_ClimbOnto = false;
	CharTemplate.bCanUse_eTraversal_ClimbLadder = false;
	CharTemplate.bCanUse_eTraversal_DropDown = false;
	CharTemplate.bCanUse_eTraversal_Grapple = false;
	CharTemplate.bCanUse_eTraversal_Landing = false;
	CharTemplate.bCanUse_eTraversal_BreakWindow = false;
	CharTemplate.bCanUse_eTraversal_KickDoor = false;
	CharTemplate.bCanUse_eTraversal_JumpUp = false;
	CharTemplate.bCanUse_eTraversal_WallClimb = false;
	CharTemplate.bCanUse_eTraversal_BreakWall = false;
	CharTemplate.bCanBeCriticallyWounded = false;
	CharTemplate.bCanBeTerrorist = false;
	CharTemplate.bAppearanceDefinesPawn = false;
	CharTemplate.bIsAfraidOfFire = false;
	CharTemplate.bIsAlien = true;
	CharTemplate.bIsAdvent = true;
	CharTemplate.bIsCivilian = false;
	CharTemplate.bIsPsionic = false;
	CharTemplate.bIsRobotic = false;
	CharTemplate.bIsSoldier = false;
	CharTemplate.bCanTakeCover = false;
	CharTemplate.bSkipDefaultAbilities = true;
	CharTemplate.bDoesAlwaysFly = true;
	CharTemplate.strMatineePackages.AddItem("CIN_Advent");

	Loot.ForceLevel = 0;
	CharTemplate.Loot.LootReferences.AddItem( Loot );
	Loot.LootTableName = 'SectoidMidGameLoot';
	Loot.ForceLevel = 2;
	CharTemplate.Loot.LootReferences.AddItem( Loot );

	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_Advent;

	return CharTemplate;
}

static function X2CharacterTemplate CreateTemplate_AdvCaptainM1()
{
	local X2CharacterTemplate CharTemplate;
	local LootReference Loot;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, 'AdvCaptainM1');
	CharTemplate.CharacterGroupName = 'AdventCaptain';
	CharTemplate.DefaultLoadout='AdvCaptainM1_Loadout';
	CharTemplate.BehaviorClass=class'XGAIBehavior';
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_AdvCaptain.ARC_GameUnit_AdvCaptainM1_M");
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_AdvCaptain.ARC_GameUnit_AdvCaptainM1_F");
	Loot.ForceLevel = 0;
	Loot.LootTableName='AdvCaptainM1_BaseLoot';
	CharTemplate.Loot.LootReferences.AddItem(Loot);

	// Timed Loot
	Loot.ForceLevel = 0;
	Loot.LootTableName = 'AdvCaptainM1_TimedLoot';
	CharTemplate.TimedLoot.LootReferences.AddItem(Loot);
	Loot.LootTableName = 'AdvCaptainM1_VultureLoot';
	CharTemplate.VultureLoot.LootReferences.AddItem(Loot);

	CharTemplate.strMatineePackages.AddItem("CIN_Advent");
	CharTemplate.RevealMatineePrefix = "CIN_Advent_Captain";
	CharTemplate.GetRevealMatineePrefixFn = GetAdventMatineePrefix;

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
	CharTemplate.bSetGenderAlways = true;
	CharTemplate.bCanTakeCover = true;

	CharTemplate.bIsAlien = false;
	CharTemplate.bIsAdvent = true;
	CharTemplate.bIsCivilian = false;
	CharTemplate.bIsPsionic = false;
	CharTemplate.bIsRobotic = false;
	CharTemplate.bIsSoldier = false;

	CharTemplate.bCanBeTerrorist = false;
	CharTemplate.bCanBeCriticallyWounded = false;
	CharTemplate.bIsAfraidOfFire = true;

	CharTemplate.Abilities.AddItem('AdventStilettoRounds');
	CharTemplate.Abilities.AddItem('MarkTarget');
	CharTemplate.Abilities.AddItem('DarkEventAbility_ReturnFire');
	CharTemplate.Abilities.AddItem('DarkEventAbility_SealedArmor');
	CharTemplate.Abilities.AddItem('DarkEventAbility_UndyingLoyalty');
	CharTemplate.Abilities.AddItem('DarkEventAbility_Barrier');
	CharTemplate.Abilities.AddItem('DarkEventAbility_Counterattack');

	CharTemplate.SightedNarrativeMoments.AddItem(XComNarrativeMoment'X2NarrativeMoments.TACTICAL.AlienSitings.T_Central_AlienSightings_AdvCaptainM1');
	CharTemplate.SightedEvents.AddItem('AdventCaptainSighted');

	CharTemplate.AddTemplateAvailablility(CharTemplate.BITFIELD_GAMEAREA_Multiplayer); // Allow in MP!
	CharTemplate.MPPointValue = CharTemplate.XpKillscore * 10;

	CharTemplate.strHackIconImage = "UILibrary_Common.TargetIcons.Hack_captain_icon";
	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_Advent;

	return CharTemplate;
}

static function X2CharacterTemplate CreateTemplate_AdvCaptainM2()
{
	local X2CharacterTemplate CharTemplate;
	local LootReference Loot;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, 'AdvCaptainM2');
	CharTemplate.CharacterGroupName = 'AdventCaptain';
	CharTemplate.DefaultLoadout='AdvCaptainM2_Loadout';
	CharTemplate.BehaviorClass=class'XGAIBehavior';
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_AdvCaptain.ARC_GameUnit_AdvCaptainM2_M");
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_AdvCaptain.ARC_GameUnit_AdvCaptainM2_F");
	Loot.ForceLevel=0;
	Loot.LootTableName='AdvCaptainM2_BaseLoot';
	CharTemplate.Loot.LootReferences.AddItem(Loot);

	// Timed Loot
	Loot.ForceLevel = 0;
	Loot.LootTableName = 'AdvCaptainM2_TimedLoot';
	CharTemplate.TimedLoot.LootReferences.AddItem(Loot);
	Loot.LootTableName = 'AdvCaptainM2_VultureLoot';
	CharTemplate.VultureLoot.LootReferences.AddItem(Loot);

	CharTemplate.strMatineePackages.AddItem("CIN_Advent");
	CharTemplate.RevealMatineePrefix = "CIN_Advent_Captain";
	CharTemplate.GetRevealMatineePrefixFn = GetAdventMatineePrefix;

	CharTemplate.SightedNarrativeMoments.AddItem(XComNarrativeMoment'X2NarrativeMoments.TACTICAL.AlienSitings.T_Central_AlienSightings_AdvCaptainM2');
	CharTemplate.SightedEvents.AddItem('AdventCaptainSighted');

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
	CharTemplate.bSetGenderAlways = true;
	CharTemplate.bCanTakeCover = true;
	CharTemplate.bIsAlien = false;
	CharTemplate.bIsAdvent = true;
	CharTemplate.bIsCivilian = false;
	CharTemplate.bIsPsionic = false;
	CharTemplate.bIsRobotic = false;
	CharTemplate.bIsSoldier = false;

	CharTemplate.bCanBeTerrorist = false;
	CharTemplate.bCanBeCriticallyWounded = false;
	CharTemplate.bIsAfraidOfFire = true;

	CharTemplate.Abilities.AddItem('MarkTarget');
	CharTemplate.Abilities.AddItem('AdventStilettoRounds');
	CharTemplate.Abilities.AddItem('DarkEventAbility_ReturnFire');
	CharTemplate.Abilities.AddItem('DarkEventAbility_SealedArmor');
	CharTemplate.Abilities.AddItem('DarkEventAbility_UndyingLoyalty');
	CharTemplate.Abilities.AddItem('DarkEventAbility_Barrier');
	CharTemplate.Abilities.AddItem('DarkEventAbility_Counterattack');

	CharTemplate.AddTemplateAvailablility(CharTemplate.BITFIELD_GAMEAREA_Multiplayer); // Allow in MP!
	CharTemplate.MPPointValue = CharTemplate.XpKillscore * 10;

	CharTemplate.strHackIconImage = "UILibrary_Common.TargetIcons.Hack_captain_icon";
	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_Advent;

	return CharTemplate;
}

static function X2CharacterTemplate CreateTemplate_AdvCaptainM3()
{
	local X2CharacterTemplate CharTemplate;
	local LootReference Loot;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, 'AdvCaptainM3');
	CharTemplate.CharacterGroupName = 'AdventCaptain';
	CharTemplate.DefaultLoadout='AdvCaptainM3_Loadout';
	CharTemplate.BehaviorClass=class'XGAIBehavior';
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_AdvCaptain.ARC_GameUnit_AdvCaptainM3_M");
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_AdvCaptain.ARC_GameUnit_AdvCaptainM3_F");
	Loot.ForceLevel=0;
	Loot.LootTableName='AdvCaptainM3_BaseLoot';
	CharTemplate.Loot.LootReferences.AddItem(Loot);

	// Timed Loot
	Loot.ForceLevel = 0;
	Loot.LootTableName = 'AdvCaptainM3_TimedLoot';
	CharTemplate.TimedLoot.LootReferences.AddItem(Loot);
	Loot.LootTableName = 'AdvCaptainM3_VultureLoot';
	CharTemplate.VultureLoot.LootReferences.AddItem(Loot);

	CharTemplate.strMatineePackages.AddItem("CIN_Advent");
	CharTemplate.RevealMatineePrefix = "CIN_Advent_Captain";
	CharTemplate.GetRevealMatineePrefixFn = GetAdventMatineePrefix;

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
	CharTemplate.bSetGenderAlways = true;
	CharTemplate.bCanTakeCover = true;

	CharTemplate.bIsAlien = false;
	CharTemplate.bIsAdvent = true;
	CharTemplate.bIsCivilian = false;
	CharTemplate.bIsPsionic = false;
	CharTemplate.bIsRobotic = false;
	CharTemplate.bIsSoldier = false;

	CharTemplate.bCanBeTerrorist = false;
	CharTemplate.bCanBeCriticallyWounded = false;
	CharTemplate.bIsAfraidOfFire = true;

	CharTemplate.Abilities.AddItem('MarkTarget');
	CharTemplate.Abilities.AddItem('AdventStilettoRounds');
	CharTemplate.Abilities.AddItem('DarkEventAbility_ReturnFire');
	CharTemplate.Abilities.AddItem('DarkEventAbility_SealedArmor');
	CharTemplate.Abilities.AddItem('DarkEventAbility_UndyingLoyalty');
	CharTemplate.Abilities.AddItem('DarkEventAbility_Barrier');
	CharTemplate.Abilities.AddItem('DarkEventAbility_Counterattack');

	CharTemplate.SightedNarrativeMoments.AddItem(XComNarrativeMoment'X2NarrativeMoments.TACTICAL.AlienSitings.T_Central_AlienSightings_AdvCaptainM3');
	CharTemplate.SightedEvents.AddItem('AdventCaptainSighted');

	CharTemplate.AddTemplateAvailablility(CharTemplate.BITFIELD_GAMEAREA_Multiplayer); // Allow in MP!
	CharTemplate.MPPointValue = CharTemplate.XpKillscore * 10;

	CharTemplate.strHackIconImage = "UILibrary_Common.TargetIcons.Hack_captain_icon";
	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_Advent;

	return CharTemplate;
}

static function X2CharacterTemplate CreateTemplate_AdvMEC_M1()
{
	local X2CharacterTemplate CharTemplate;
	local LootReference Loot;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, 'AdvMEC_M1');
	CharTemplate.CharacterGroupName = 'AdventMEC';
	CharTemplate.DefaultLoadout='AdvMEC_M1_Loadout';
	CharTemplate.BehaviorClass=class'XGAIBehavior';
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_AdvMEC_M3.ARC_GameUnit_AdvMEC_M3");
	Loot.ForceLevel=0;
	Loot.LootTableName='AdvMEC_M1_BaseLoot';
	CharTemplate.Loot.LootReferences.AddItem(Loot);

	// Timed Loot
	Loot.ForceLevel = 0;
	Loot.LootTableName = 'AdvMEC_M1_TimedLoot';
	CharTemplate.TimedLoot.LootReferences.AddItem(Loot);
	Loot.LootTableName = 'AdvMEC_M1_VultureLoot';
	CharTemplate.VultureLoot.LootReferences.AddItem(Loot);

	CharTemplate.strMatineePackages.AddItem("CIN_AdventMEC");
	CharTemplate.strTargetingMatineePrefix = "CIN_AdventMEC_FF_StartPos";

	CharTemplate.SightedNarrativeMoments.AddItem(XComNarrativeMoment'X2NarrativeMoments.TACTICAL.AlienSitings.Enemy_Sighted_ADVENTmec');

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
	CharTemplate.bAllowRushCam = false;

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
	CharTemplate.AcquiredPhobiaTemplate = 'FearOfMecs';

	CharTemplate.strScamperBT = "ScamperRoot_Flanker";

	CharTemplate.Abilities.AddItem('RobotImmunities');
	CharTemplate.Abilities.AddItem('DarkEventAbility_Barrier');

	CharTemplate.strHackIconImage = "UILibrary_Common.TargetIcons.Hack_robot_icon";
	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_Advent;

	return CharTemplate;
}

static function X2CharacterTemplate CreateTemplate_AdvMEC_M2()
{
	local X2CharacterTemplate CharTemplate;
	local LootReference Loot;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, 'AdvMEC_M2');
	CharTemplate.CharacterGroupName = 'AdventMEC';
	CharTemplate.DefaultLoadout='AdvMEC_M2_Loadout';
	CharTemplate.BehaviorClass=class'XGAIBehavior';
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_AdvMEC_M2.ARC_GameUnit_AdvMEC_M2");
	Loot.ForceLevel=0;
	Loot.LootTableName='AdvMEC_M2_BaseLoot';
	CharTemplate.Loot.LootReferences.AddItem(Loot);

	// Timed Loot
	Loot.ForceLevel = 0;
	Loot.LootTableName = 'AdvMEC_M2_TimedLoot';
	CharTemplate.TimedLoot.LootReferences.AddItem(Loot);
	Loot.LootTableName = 'AdvMEC_M2_VultureLoot';
	CharTemplate.VultureLoot.LootReferences.AddItem(Loot);

	CharTemplate.strMatineePackages.AddItem("CIN_AdventMEC");
	CharTemplate.strTargetingMatineePrefix = "CIN_AdventMEC_FF_StartPos";

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
	CharTemplate.bAllowRushCam = false;

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
	CharTemplate.AcquiredPhobiaTemplate = 'FearOfMecs';

	//CharTemplate.strScamperBT = "ScamperRoot_NoCover";
	CharTemplate.strScamperBT = "ScamperRoot_Overwatch";

	CharTemplate.Abilities.AddItem('RobotImmunities');
	CharTemplate.Abilities.AddItem('DarkEventAbility_Barrier');

	CharTemplate.strHackIconImage = "UILibrary_Common.TargetIcons.Hack_robot_icon";
	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_Advent;

	return CharTemplate;
}

static function X2CharacterTemplate CreateTemplate_AdvPsiWitchM2()
{
	local X2CharacterTemplate CharTemplate;
	local LootReference Loot;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, 'AdvPsiWitchM2');
	CharTemplate.CharacterGroupName = 'AdventPsiWitch';
	CharTemplate.DefaultLoadout='AdvPsiWitchM2_Loadout';
	CharTemplate.BehaviorClass=class'XGAIBehavior';
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_AdvPsiWitch.ARC_GameUnit_AdvPsiWitchM2_M");
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_AdvPsiWitch.ARC_GameUnit_AdvPsiWitchM2_F");
	Loot.ForceLevel=0;
	Loot.LootTableName='AdvPsiWitchM2_BaseLoot';
	CharTemplate.Loot.LootReferences.AddItem(Loot);

	// Timed Loot
	Loot.ForceLevel = 0;
	Loot.LootTableName = 'AdvPsiWitchM2_TimedLoot';
	CharTemplate.TimedLoot.LootReferences.AddItem(Loot);
	Loot.LootTableName = 'AdvPsiWitchM2_VultureLoot';
	CharTemplate.VultureLoot.LootReferences.AddItem(Loot);

	CharTemplate.strMatineePackages.AddItem("CIN_Advent");
	CharTemplate.RevealMatineePrefix = "CIN_Advent_Avatar";
	CharTemplate.GetRevealMatineePrefixFn = GetAdventMatineePrefix;

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
	CharTemplate.bSetGenderAlways = true;
	CharTemplate.bCanTakeCover = true;

	CharTemplate.bIsAlien = false;
	CharTemplate.bIsAdvent = false;
	CharTemplate.bIsCivilian = false;
	CharTemplate.bIsPsionic = true;
	CharTemplate.bIsRobotic = false;
	CharTemplate.bIsSoldier = false;

	CharTemplate.bCanBeTerrorist = false;
	CharTemplate.bCanBeCriticallyWounded = false;
	CharTemplate.bIsAfraidOfFire = true;

	CharTemplate.Abilities.AddItem('AvatarInitialization');
	CharTemplate.Abilities.AddItem('Revive');

	CharTemplate.ImmuneTypes.AddItem('Mental');
	
	CharTemplate.bAllowSpawnFromATT = false;

	CharTemplate.AddTemplateAvailablility(CharTemplate.BITFIELD_GAMEAREA_Multiplayer); // Allow in MP!
	CharTemplate.MPPointValue = CharTemplate.XpKillscore * 10;
	return CharTemplate;
}

static function X2CharacterTemplate CreateTemplate_AdvPsiWitchM3()
{
	local X2CharacterTemplate CharTemplate;
	local LootReference Loot;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, 'AdvPsiWitchM3');
	CharTemplate.CharacterGroupName = 'AdventPsiWitch';
	CharTemplate.DefaultLoadout='AdvPsiWitchM3_Loadout';
	CharTemplate.BehaviorClass=class'XGAIBehavior';
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_AdvPsiWitch.ARC_GameUnit_AdvPsiWitchM3_M");
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_AdvPsiWitch.ARC_GameUnit_AdvPsiWitchM3_F");
	Loot.ForceLevel=0;
	Loot.LootTableName='AdvPsiWitchM3_BaseLoot';
	CharTemplate.Loot.LootReferences.AddItem(Loot);

	// Timed Loot
	Loot.ForceLevel = 0;
	Loot.LootTableName = 'AdvPsiWitchM3_TimedLoot';
	CharTemplate.TimedLoot.LootReferences.AddItem(Loot);
	Loot.LootTableName = 'AdvPsiWitchM3_VultureLoot';
	CharTemplate.VultureLoot.LootReferences.AddItem(Loot);

	CharTemplate.strMatineePackages.AddItem("CIN_Advent");
	CharTemplate.RevealMatineePrefix = "CIN_Advent_Avatar";
	CharTemplate.GetRevealMatineePrefixFn = GetAdventMatineePrefix;

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
	CharTemplate.bSetGenderAlways = true;
	CharTemplate.bCanTakeCover = true;

	CharTemplate.bIsAlien = false;
	CharTemplate.bIsAdvent = true;
	CharTemplate.bIsCivilian = false;
	CharTemplate.bIsPsionic = true;
	CharTemplate.bIsRobotic = false;
	CharTemplate.bIsSoldier = false;

	CharTemplate.bCanBeTerrorist = false;
	CharTemplate.bCanBeCriticallyWounded = false;
	CharTemplate.bIsAfraidOfFire = true;

	CharTemplate.Abilities.AddItem('AvatarInitialization');
	CharTemplate.Abilities.AddItem('TriggerDamagedTeleportListener');
	CharTemplate.Abilities.AddItem('AvatarDamagedTeleport');
	CharTemplate.Abilities.AddItem('DarkEventAbility_SealedArmor');
	CharTemplate.Abilities.AddItem('DarkEventAbility_UndyingLoyalty');
	CharTemplate.Abilities.AddItem('DarkEventAbility_Barrier');

	CharTemplate.ImmuneTypes.AddItem('Mental');

	CharTemplate.SightedNarrativeMoments.AddItem(XComNarrativeMoment'X2NarrativeMoments.T_Incomplete_Avatar_Sighted_Tygan');
	CharTemplate.DeathEvent = 'KilledAnAvatar';

	CharTemplate.bAllowSpawnFromATT = false;

	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_Advent;

	CharTemplate.OnStatAssignmentCompleteFn = OnPsiWitchStatAssignmentComplete;

	return CharTemplate;
}

function OnPsiWitchStatAssignmentComplete(XComGameState_Unit UnitState)
{
	if ((class'XComGameState_HeadquartersXCom'.static.GetObjectiveStatus('T1_M5_SKULLJACKCodex') == eObjectiveState_InProgress || 
		class'XComGameState_HeadquartersXCom'.static.GetObjectiveStatus('T1_M6_KillAvatar') == eObjectiveState_InProgress))
	{
		UnitState.SetCurrentStat(eStat_HP, UnitState.GetMaxStat(eStat_HP) * class'X2TacticalGameRuleset'.default.DepletedAvatarHealthMod);
	}
}

static function X2CharacterTemplate CreateTemplate_AdvShieldBearerM2()
{
	local X2CharacterTemplate CharTemplate;
	local LootReference Loot;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, 'AdvShieldBearerM2');
	CharTemplate.CharacterGroupName = 'AdventShieldBearer';
	CharTemplate.DefaultLoadout='AdvShieldBearerM2_Loadout';
	CharTemplate.BehaviorClass=class'XGAIBehavior';
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_AdvShieldBearer.ARC_GameUnit_AdvShieldBearerM2_M");
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_AdvShieldBearer.ARC_GameUnit_AdvShieldBearerM2_F");
	Loot.ForceLevel=0;
	Loot.LootTableName='AdvShieldBearerM2_BaseLoot';
	CharTemplate.Loot.LootReferences.AddItem(Loot);

	// Timed Loot
	Loot.ForceLevel = 0;
	Loot.LootTableName = 'AdvShieldBearerM2_TimedLoot';
	CharTemplate.TimedLoot.LootReferences.AddItem(Loot);
	Loot.LootTableName = 'AdvShieldBearerM2_VultureLoot';
	CharTemplate.VultureLoot.LootReferences.AddItem(Loot);

	CharTemplate.strMatineePackages.AddItem("CIN_Advent");
	CharTemplate.RevealMatineePrefix = "CIN_Advent_ShieldBearer";
	CharTemplate.GetRevealMatineePrefixFn = GetAdventMatineePrefix;

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
	CharTemplate.bSetGenderAlways = true;
	CharTemplate.bCanTakeCover = true;

	CharTemplate.bIsAlien = false;
	CharTemplate.bIsAdvent = true;
	CharTemplate.bIsCivilian = false;
	CharTemplate.bIsPsionic = false;
	CharTemplate.bIsRobotic = false;
	CharTemplate.bIsSoldier = false;

	CharTemplate.bCanBeTerrorist = false;
	CharTemplate.bCanBeCriticallyWounded = false;
	CharTemplate.bIsAfraidOfFire = true;

	CharTemplate.Abilities.AddItem('EnergyShield');
	CharTemplate.Abilities.AddItem('AdventStilettoRounds');
	CharTemplate.Abilities.AddItem('DarkEventAbility_SealedArmor');
	CharTemplate.Abilities.AddItem('DarkEventAbility_UndyingLoyalty');
	CharTemplate.Abilities.AddItem('DarkEventAbility_Barrier');
	CharTemplate.Abilities.AddItem('DarkEventAbility_Counterattack');

	CharTemplate.SightedNarrativeMoments.AddItem(XComNarrativeMoment'X2NarrativeMoments.TACTICAL.AlienSitings.T_Central_AlienSightings_AdvShieldBearerM2');

	CharTemplate.AddTemplateAvailablility(CharTemplate.BITFIELD_GAMEAREA_Multiplayer); // Allow in MP!
	CharTemplate.MPPointValue = CharTemplate.XpKillscore * 10;

	CharTemplate.strHackIconImage = "UILibrary_Common.TargetIcons.Hack_captain_icon";
	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_Advent;

	return CharTemplate;
}

static function X2CharacterTemplate CreateTemplate_AdvShieldBearerM3()
{
	local X2CharacterTemplate CharTemplate;
	local LootReference Loot;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, 'AdvShieldBearerM3');
	CharTemplate.CharacterGroupName = 'AdventShieldBearer';
	CharTemplate.DefaultLoadout='AdvShieldBearerM3_Loadout';
	CharTemplate.BehaviorClass=class'XGAIBehavior';
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_AdvShieldBearer.ARC_GameUnit_AdvShieldBearerM3_M");
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_AdvShieldBearer.ARC_GameUnit_AdvShieldBearerM3_F");
	Loot.ForceLevel=0;
	Loot.LootTableName='AdvShieldBearerM3_BaseLoot';
	CharTemplate.Loot.LootReferences.AddItem(Loot);

	// Timed Loot
	Loot.ForceLevel = 0;
	Loot.LootTableName = 'AdvShieldBearerM3_TimedLoot';
	CharTemplate.TimedLoot.LootReferences.AddItem(Loot);
	Loot.LootTableName = 'AdvShieldBearerM3_VultureLoot';
	CharTemplate.VultureLoot.LootReferences.AddItem(Loot);

	CharTemplate.strMatineePackages.AddItem("CIN_Advent");
	CharTemplate.RevealMatineePrefix = "CIN_Advent_ShieldBearer";
	CharTemplate.GetRevealMatineePrefixFn = GetAdventMatineePrefix;

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
	CharTemplate.bSetGenderAlways = true;
	CharTemplate.bCanTakeCover = true;

	CharTemplate.bIsAlien = false;
	CharTemplate.bIsAdvent = true;
	CharTemplate.bIsCivilian = false;
	CharTemplate.bIsPsionic = false;
	CharTemplate.bIsRobotic = false;
	CharTemplate.bIsSoldier = false;

	CharTemplate.bCanBeTerrorist = false;
	CharTemplate.bCanBeCriticallyWounded = false;
	CharTemplate.bIsAfraidOfFire = true;

	CharTemplate.Abilities.AddItem('EnergyShieldMk3');
	CharTemplate.Abilities.AddItem('AdventStilettoRounds');
	CharTemplate.Abilities.AddItem('DarkEventAbility_SealedArmor');
	CharTemplate.Abilities.AddItem('DarkEventAbility_UndyingLoyalty');
	CharTemplate.Abilities.AddItem('DarkEventAbility_Barrier');
	CharTemplate.Abilities.AddItem('DarkEventAbility_Counterattack');

	CharTemplate.SightedNarrativeMoments.AddItem(XComNarrativeMoment'X2NarrativeMoments.TACTICAL.T_Central_AlienSightings_AdvShieldBearerM3');

	CharTemplate.AddTemplateAvailablility(CharTemplate.BITFIELD_GAMEAREA_Multiplayer); // Allow in MP!
	CharTemplate.MPPointValue = CharTemplate.XpKillscore * 10;

	CharTemplate.strHackIconImage = "UILibrary_Common.TargetIcons.Hack_captain_icon";
	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_Advent;

	return CharTemplate;
}

static function X2CharacterTemplate CreateTemplate_AdvStunLancerM1()
{
	local X2CharacterTemplate CharTemplate;
	local LootReference Loot;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, 'AdvStunLancerM1');
	CharTemplate.CharacterGroupName = 'AdventStunLancer';
	CharTemplate.DefaultLoadout='AdvStunLancerM1_Loadout';
	CharTemplate.BehaviorClass=class'XGAIBehavior';
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_AdvStunLancer.ARC_GameUnit_AdvStunLancerM1_M");
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_AdvStunLancer.ARC_GameUnit_AdvStunLancerM1_F");
	Loot.ForceLevel=0;
	Loot.LootTableName='AdvStunLancerM1_BaseLoot';
	CharTemplate.Loot.LootReferences.AddItem(Loot);

	// Timed Loot
	Loot.ForceLevel = 0;
	Loot.LootTableName = 'AdvStunLancerM1_TimedLoot';
	CharTemplate.TimedLoot.LootReferences.AddItem(Loot);
	Loot.LootTableName = 'AdvStunLancerM1_VultureLoot';
	CharTemplate.VultureLoot.LootReferences.AddItem(Loot);

	CharTemplate.strMatineePackages.AddItem("CIN_Advent");
	CharTemplate.RevealMatineePrefix = "CIN_Advent_StunLancer";
	CharTemplate.GetRevealMatineePrefixFn = GetAdventMatineePrefix;

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
	CharTemplate.bSetGenderAlways = true;
	CharTemplate.bCanTakeCover = true;

	CharTemplate.bIsAlien = false;
	CharTemplate.bIsAdvent = true;
	CharTemplate.bIsCivilian = false;
	CharTemplate.bIsPsionic = false;
	CharTemplate.bIsRobotic = false;
	CharTemplate.bIsSoldier = false;

	CharTemplate.bCanBeTerrorist = false;
	CharTemplate.bCanBeCriticallyWounded = false;
	CharTemplate.bIsAfraidOfFire = true;
	CharTemplate.AcquiredPhobiaTemplate = 'FearOfStunLancers';

	CharTemplate.SightedNarrativeMoments.AddItem(XComNarrativeMoment'X2NarrativeMoments.TACTICAL.AlienSitings.T_Central_AlienSightings_AdvStunLancerM1');

	CharTemplate.AddTemplateAvailablility(CharTemplate.BITFIELD_GAMEAREA_Multiplayer); // Allow in MP!
	CharTemplate.MPPointValue = CharTemplate.XpKillscore * 10;

	CharTemplate.strHackIconImage = "UILibrary_Common.TargetIcons.Hack_captain_icon";
	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_Advent;

	CharTemplate.Abilities.AddItem('AdventStilettoRounds');
	CharTemplate.Abilities.AddItem('DarkEventAbility_BendingReed');
	CharTemplate.Abilities.AddItem('DarkEventAbility_SealedArmor');
	CharTemplate.Abilities.AddItem('DarkEventAbility_UndyingLoyalty');
	CharTemplate.Abilities.AddItem('DarkEventAbility_Barrier');
	CharTemplate.Abilities.AddItem('DarkEventAbility_Counterattack');

	return CharTemplate;
}

static function X2CharacterTemplate CreateTemplate_AdvStunLancerM2()
{
	local X2CharacterTemplate CharTemplate;
	local LootReference Loot;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, 'AdvStunLancerM2');
	CharTemplate.CharacterGroupName = 'AdventStunLancer';
	CharTemplate.DefaultLoadout='AdvStunLancerM2_Loadout';
	CharTemplate.BehaviorClass=class'XGAIBehavior';
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_AdvStunLancer.ARC_GameUnit_AdvStunLancerM2_M");
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_AdvStunLancer.ARC_GameUnit_AdvStunLancerM2_F");
	Loot.ForceLevel=0;
	Loot.LootTableName='AdvStunLancerM2_BaseLoot';
	CharTemplate.Loot.LootReferences.AddItem(Loot);

	// Timed Loot
	Loot.ForceLevel = 0;
	Loot.LootTableName = 'AdvStunLancerM2_TimedLoot';
	CharTemplate.TimedLoot.LootReferences.AddItem(Loot);
	Loot.LootTableName = 'AdvStunLancerM2_VultureLoot';
	CharTemplate.VultureLoot.LootReferences.AddItem(Loot);

	CharTemplate.strMatineePackages.AddItem("CIN_Advent");
	CharTemplate.RevealMatineePrefix = "CIN_Advent_StunLancer";
	CharTemplate.GetRevealMatineePrefixFn = GetAdventMatineePrefix;

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
	CharTemplate.bSetGenderAlways = true;
	CharTemplate.bCanTakeCover = true;

	CharTemplate.bIsAlien = false;
	CharTemplate.bIsAdvent = true;
	CharTemplate.bIsCivilian = false;
	CharTemplate.bIsPsionic = false;
	CharTemplate.bIsRobotic = false;
	CharTemplate.bIsSoldier = false;

	CharTemplate.bCanBeTerrorist = false;
	CharTemplate.bCanBeCriticallyWounded = false;
	CharTemplate.bIsAfraidOfFire = true;
	CharTemplate.AcquiredPhobiaTemplate = 'FearOfStunLancers';

	CharTemplate.SightedNarrativeMoments.AddItem(XComNarrativeMoment'X2NarrativeMoments.TACTICAL.AlienSitings.T_Central_AlienSightings_AdvStunLancerM2');

	CharTemplate.AddTemplateAvailablility(CharTemplate.BITFIELD_GAMEAREA_Multiplayer); // Allow in MP!
	CharTemplate.MPPointValue = CharTemplate.XpKillscore * 10;

	CharTemplate.strHackIconImage = "UILibrary_Common.TargetIcons.Hack_captain_icon";
	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_Advent;

	CharTemplate.Abilities.AddItem('AdventStilettoRounds');
	CharTemplate.Abilities.AddItem('DarkEventAbility_BendingReed');
	CharTemplate.Abilities.AddItem('DarkEventAbility_SealedArmor');
	CharTemplate.Abilities.AddItem('DarkEventAbility_UndyingLoyalty');
	CharTemplate.Abilities.AddItem('DarkEventAbility_Barrier');
	CharTemplate.Abilities.AddItem('DarkEventAbility_Counterattack');

	return CharTemplate;
}

static function X2CharacterTemplate CreateTemplate_AdvStunLancerM3()
{
	local X2CharacterTemplate CharTemplate;
	local LootReference Loot;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, 'AdvStunLancerM3');
	CharTemplate.CharacterGroupName = 'AdventStunLancer';
	CharTemplate.DefaultLoadout='AdvStunLancerM3_Loadout';
	CharTemplate.BehaviorClass=class'XGAIBehavior';
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_AdvStunLancer.ARC_GameUnit_AdvStunLancerM3_M");
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_AdvStunLancer.ARC_GameUnit_AdvStunLancerM3_F");
	Loot.ForceLevel=0;
	Loot.LootTableName='AdvStunLancerM3_BaseLoot';
	CharTemplate.Loot.LootReferences.AddItem(Loot);

	// Timed Loot
	Loot.ForceLevel = 0;
	Loot.LootTableName = 'AdvStunLancerM3_TimedLoot';
	CharTemplate.TimedLoot.LootReferences.AddItem(Loot);
	Loot.LootTableName = 'AdvStunLancerM3_VultureLoot';
	CharTemplate.VultureLoot.LootReferences.AddItem(Loot);

	CharTemplate.strMatineePackages.AddItem("CIN_Advent");
	CharTemplate.RevealMatineePrefix = "CIN_Advent_StunLancer";
	CharTemplate.GetRevealMatineePrefixFn = GetAdventMatineePrefix;

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
	CharTemplate.bSetGenderAlways = true;
	CharTemplate.bCanTakeCover = true;

	CharTemplate.bIsAlien = false;
	CharTemplate.bIsAdvent = true;
	CharTemplate.bIsCivilian = false;
	CharTemplate.bIsPsionic = false;
	CharTemplate.bIsRobotic = false;
	CharTemplate.bIsSoldier = false;

	CharTemplate.bCanBeTerrorist = false;
	CharTemplate.bCanBeCriticallyWounded = false;
	CharTemplate.bIsAfraidOfFire = true;
	CharTemplate.AcquiredPhobiaTemplate = 'FearOfStunLancers';

	CharTemplate.SightedNarrativeMoments.AddItem(XComNarrativeMoment'X2NarrativeMoments.TACTICAL.T_Central_AlienSightings_AdvStunLancerM3');

	CharTemplate.AddTemplateAvailablility(CharTemplate.BITFIELD_GAMEAREA_Multiplayer); // Allow in MP!
	CharTemplate.MPPointValue = CharTemplate.XpKillscore * 10;

	CharTemplate.strHackIconImage = "UILibrary_Common.TargetIcons.Hack_captain_icon";
	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_Advent;

	CharTemplate.Abilities.AddItem('AdventStilettoRounds');
	CharTemplate.Abilities.AddItem('DarkEventAbility_BendingReed');
	CharTemplate.Abilities.AddItem('DarkEventAbility_SealedArmor');
	CharTemplate.Abilities.AddItem('DarkEventAbility_UndyingLoyalty');
	CharTemplate.Abilities.AddItem('DarkEventAbility_Barrier');
	CharTemplate.Abilities.AddItem('DarkEventAbility_Counterattack');

	return CharTemplate;
}

static function X2CharacterTemplate CreateTemplate_AdvTrooperM1()
{
	local X2CharacterTemplate CharTemplate;
	local LootReference Loot;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, 'AdvTrooperM1');
	CharTemplate.CharacterGroupName = 'AdventTrooper';
	CharTemplate.DefaultLoadout='AdvTrooperM1_Loadout';
	CharTemplate.BehaviorClass=class'XGAIBehavior';
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_AdvTrooper.ARC_GameUnit_AdvTrooperM1_M");
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_AdvTrooper.ARC_GameUnit_AdvTrooperM1_F");

	// Auto-Loot
	Loot.ForceLevel = 0;
	Loot.LootTableName = 'AdvTrooperM1_BaseLoot';
	CharTemplate.Loot.LootReferences.AddItem(Loot);

	// Timed Loot
	Loot.ForceLevel = 0;
	Loot.LootTableName = 'AdvTrooperM1_TimedLoot';
	CharTemplate.TimedLoot.LootReferences.AddItem(Loot);
	Loot.LootTableName = 'AdvTrooperM1_VultureLoot';
	CharTemplate.VultureLoot.LootReferences.AddItem(Loot);

	CharTemplate.strMatineePackages.AddItem("CIN_Advent");
	CharTemplate.RevealMatineePrefix = "CIN_Advent_Trooper";
	CharTemplate.GetRevealMatineePrefixFn = GetAdventMatineePrefix;

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
	CharTemplate.bSetGenderAlways = true;
	CharTemplate.bCanTakeCover = true;

	CharTemplate.bIsAlien = false;
	CharTemplate.bIsAdvent = true;
	CharTemplate.bIsCivilian = false;
	CharTemplate.bIsPsionic = false;
	CharTemplate.bIsRobotic = false;
	CharTemplate.bIsSoldier = false;

	CharTemplate.bCanBeTerrorist = false;
	CharTemplate.bCanBeCriticallyWounded = false;
	CharTemplate.bIsAfraidOfFire = true;
	
	CharTemplate.SightedNarrativeMoments.AddItem(XComNarrativeMoment'X2NarrativeMoments.TACTICAL.AlienSitings.T_Central_AlienSightings_AdvTrooperM1');

	CharTemplate.AddTemplateAvailablility(CharTemplate.BITFIELD_GAMEAREA_Multiplayer); // Allow in MP!
	CharTemplate.MPPointValue = CharTemplate.XpKillscore * 10;

	CharTemplate.strHackIconImage = "UILibrary_Common.TargetIcons.Hack_captain_icon";
	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_Advent;

	CharTemplate.Abilities.AddItem('AdventStilettoRounds');
	CharTemplate.Abilities.AddItem('DarkEventAbility_LightningReflexes');
	CharTemplate.Abilities.AddItem('DarkEventAbility_SealedArmor');
	CharTemplate.Abilities.AddItem('DarkEventAbility_UndyingLoyalty');
	CharTemplate.Abilities.AddItem('DarkEventAbility_Barrier');
	CharTemplate.Abilities.AddItem('DarkEventAbility_Counterattack');

	return CharTemplate;
}

static function X2CharacterTemplate CreateTemplate_AdvTrooperM2()
{
	local X2CharacterTemplate CharTemplate;
	local LootReference Loot;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, 'AdvTrooperM2');
	CharTemplate.CharacterGroupName = 'AdventTrooper';
	CharTemplate.DefaultLoadout='AdvTrooperM2_Loadout';
	CharTemplate.BehaviorClass=class'XGAIBehavior';
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_AdvTrooper.ARC_GameUnit_AdvTrooperM2_M");
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_AdvTrooper.ARC_GameUnit_AdvTrooperM2_F");
	Loot.ForceLevel=0;
	Loot.LootTableName='AdvTrooperM2_BaseLoot';
	CharTemplate.Loot.LootReferences.AddItem(Loot);

	// Timed Loot
	Loot.ForceLevel = 0;
	Loot.LootTableName = 'AdvTrooperM2_TimedLoot';
	CharTemplate.TimedLoot.LootReferences.AddItem(Loot);
	Loot.LootTableName = 'AdvTrooperM2_VultureLoot';
	CharTemplate.VultureLoot.LootReferences.AddItem(Loot);

	CharTemplate.strMatineePackages.AddItem("CIN_Advent");
	CharTemplate.RevealMatineePrefix = "CIN_Advent_Trooper";
	CharTemplate.GetRevealMatineePrefixFn = GetAdventMatineePrefix;

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
	CharTemplate.bSetGenderAlways = true;
	CharTemplate.bCanTakeCover = true;

	CharTemplate.bIsAlien = false;
	CharTemplate.bIsAdvent = true;
	CharTemplate.bIsCivilian = false;
	CharTemplate.bIsPsionic = false;
	CharTemplate.bIsRobotic = false;
	CharTemplate.bIsSoldier = false;

	CharTemplate.bCanBeTerrorist = false;
	CharTemplate.bCanBeCriticallyWounded = false;
	CharTemplate.bIsAfraidOfFire = true;

	CharTemplate.SightedNarrativeMoments.AddItem(XComNarrativeMoment'X2NarrativeMoments.TACTICAL.AlienSitings.T_Central_AlienSightings_AdvTrooperM2');

	CharTemplate.AddTemplateAvailablility(CharTemplate.BITFIELD_GAMEAREA_Multiplayer); // Allow in MP!
	CharTemplate.MPPointValue = CharTemplate.XpKillscore * 10;

	CharTemplate.strHackIconImage = "UILibrary_Common.TargetIcons.Hack_captain_icon";
	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_Advent;

	CharTemplate.Abilities.AddItem('AdventStilettoRounds');
	CharTemplate.Abilities.AddItem('DarkEventAbility_LightningReflexes');
	CharTemplate.Abilities.AddItem('DarkEventAbility_SealedArmor');
	CharTemplate.Abilities.AddItem('DarkEventAbility_UndyingLoyalty');
	CharTemplate.Abilities.AddItem('DarkEventAbility_Barrier');
	CharTemplate.Abilities.AddItem('DarkEventAbility_Counterattack');

	return CharTemplate;
}

static function X2CharacterTemplate CreateTemplate_AdvTrooperM3()
{
	local X2CharacterTemplate CharTemplate;
	local LootReference Loot;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, 'AdvTrooperM3');
	CharTemplate.CharacterGroupName = 'AdventTrooper';
	CharTemplate.DefaultLoadout='AdvTrooperM3_Loadout';
	CharTemplate.BehaviorClass=class'XGAIBehavior';
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_AdvTrooper.ARC_GameUnit_AdvTrooperM3_M");
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_AdvTrooper.ARC_GameUnit_AdvTrooperM3_F");
	Loot.ForceLevel=0;
	Loot.LootTableName='AdvTrooperM3_BaseLoot';
	CharTemplate.Loot.LootReferences.AddItem(Loot);

	// Timed Loot
	Loot.ForceLevel = 0;
	Loot.LootTableName = 'AdvTrooperM3_TimedLoot';
	CharTemplate.TimedLoot.LootReferences.AddItem(Loot);
	Loot.LootTableName = 'AdvTrooperM3_VultureLoot';
	CharTemplate.VultureLoot.LootReferences.AddItem(Loot);

	CharTemplate.strMatineePackages.AddItem("CIN_Advent");
	CharTemplate.RevealMatineePrefix = "CIN_Advent_Trooper";
	CharTemplate.GetRevealMatineePrefixFn = GetAdventMatineePrefix;

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
	CharTemplate.bSetGenderAlways = true;
	CharTemplate.bCanTakeCover = true;

	CharTemplate.bIsAlien = false;
	CharTemplate.bIsAdvent = true;
	CharTemplate.bIsCivilian = false;
	CharTemplate.bIsPsionic = false;
	CharTemplate.bIsRobotic = false;
	CharTemplate.bIsSoldier = false;

	CharTemplate.bCanBeTerrorist = false;
	CharTemplate.bCanBeCriticallyWounded = false;
	CharTemplate.bIsAfraidOfFire = true;

	CharTemplate.SightedNarrativeMoments.AddItem(XComNarrativeMoment'X2NarrativeMoments.TACTICAL.AlienSitings.T_Central_AlienSightings_AdvTrooperM3');
	
	CharTemplate.AddTemplateAvailablility(CharTemplate.BITFIELD_GAMEAREA_Multiplayer); // Allow in MP!
	CharTemplate.MPPointValue = CharTemplate.XpKillscore * 10;

	CharTemplate.strHackIconImage = "UILibrary_Common.TargetIcons.Hack_captain_icon";
	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_Advent;

	CharTemplate.Abilities.AddItem('AdventStilettoRounds');
	CharTemplate.Abilities.AddItem('DarkEventAbility_LightningReflexes');
	CharTemplate.Abilities.AddItem('DarkEventAbility_SealedArmor');
	CharTemplate.Abilities.AddItem('DarkEventAbility_UndyingLoyalty');
	CharTemplate.Abilities.AddItem('DarkEventAbility_Barrier');
	CharTemplate.Abilities.AddItem('DarkEventAbility_Counterattack');

	return CharTemplate;
}

static function X2CharacterTemplate CreateTemplate_AdvTurretMk1(optional name TemplateName = 'AdvTurretM1', optional bool bShort=false)
{
	local X2CharacterTemplate CharTemplate;
	local LootReference Loot;

	CreateDefaultTurretTemplate(CharTemplate, TemplateName, bShort);

	CharTemplate.CharacterGroupName = 'AdventTurret';
	CharTemplate.DefaultLoadout='AdvTurretM1_Loadout';

	Loot.ForceLevel=0;
	Loot.LootTableName='AdvTurretM1_BaseLoot';
	CharTemplate.Loot.LootReferences.AddItem(Loot);

	CharTemplate.bIsAdvent = true;
	CharTemplate.SightedNarrativeMoments.AddItem(XComNarrativeMoment'X2NarrativeMoments.TACTICAL.T_Shen_AlienSightings_Turret');

	CharTemplate.Abilities.AddItem('DarkEventAbility_Barrier');

	return CharTemplate;
}

static function X2CharacterTemplate CreateTemplate_AdvTurretMk2(optional name TemplateName = 'AdvTurretM2', optional bool bShort=false)
{
	local X2CharacterTemplate CharTemplate;
	local LootReference Loot;

	CreateDefaultTurretTemplate(CharTemplate, TemplateName, bShort);

	CharTemplate.CharacterGroupName = 'AdventTurret';
	CharTemplate.DefaultLoadout='AdvTurretM2_Loadout';
	
	Loot.ForceLevel=0;
	Loot.LootTableName='AdvTurretM2_BaseLoot';
	CharTemplate.Loot.LootReferences.AddItem(Loot);

	CharTemplate.bIsAdvent = true;
	CharTemplate.SightedNarrativeMoments.AddItem(XComNarrativeMoment'X2NarrativeMoments.TACTICAL.AlienSitings.T_Shen_AlienSightings_Turret_MK2');

	CharTemplate.Abilities.AddItem('DarkEventAbility_Barrier');

	return CharTemplate;
}

static function X2CharacterTemplate CreateTemplate_AdvTurretMk3(optional name TemplateName = 'AdvTurretM3', optional bool bShort=false)
{
	local X2CharacterTemplate CharTemplate;
	local LootReference Loot;

	CreateDefaultTurretTemplate(CharTemplate, TemplateName, bShort);

	CharTemplate.CharacterGroupName = 'AdventTurret';
	CharTemplate.DefaultLoadout='AdvTurretM3_Loadout';

	Loot.ForceLevel=0;
	Loot.LootTableName='AdvTurretM3_BaseLoot';
	CharTemplate.Loot.LootReferences.AddItem(Loot);

	CharTemplate.bIsAdvent = true;

	CharTemplate.Abilities.AddItem('DarkEventAbility_Barrier');

	return CharTemplate;
}

static function X2CharacterTemplate CreateTemplate_AdvShortTurret()
{
	local X2CharacterTemplate CharTemplate;
	local LootReference Loot;

	CreateDefaultTurretTemplate(CharTemplate, 'AdvShortTurret', true);

	CharTemplate.CharacterGroupName = 'AdventTurret';
	CharTemplate.DefaultLoadout = 'AdvShortTurretM1_Loadout';

	Loot.ForceLevel = 0;
	Loot.LootTableName = 'AdvTurretM1_BaseLoot';
	CharTemplate.Loot.LootReferences.AddItem(Loot);
	
	CharTemplate.bIsAdvent = true;

	CharTemplate.Abilities.AddItem('DarkEventAbility_Barrier');

	return CharTemplate;
}

static function X2CharacterTemplate CreateTemplate_AdvShortTurretM1()
{
	local X2CharacterTemplate CharTemplate;

	CharTemplate = CreateTemplate_AdvTurretMk1( 'AdvShortTurretM1', true );
	CharTemplate.SightedNarrativeMoments.AddItem(XComNarrativeMoment'X2NarrativeMoments.TACTICAL.T_Shen_AlienSightings_Turret');

	CharTemplate.Abilities.AddItem('DarkEventAbility_Barrier');

	return CharTemplate;
}

static function X2CharacterTemplate CreateTemplate_AdvShortTurretM2()
{
	local X2CharacterTemplate CharTemplate;

	CharTemplate = CreateTemplate_AdvTurretMk2( 'AdvShortTurretM2', true );
	CharTemplate.SightedNarrativeMoments.AddItem(XComNarrativeMoment'X2NarrativeMoments.TACTICAL.AlienSitings.T_Shen_AlienSightings_Turret_MK2');

	CharTemplate.Abilities.AddItem('DarkEventAbility_Barrier');

	return CharTemplate;
}

static function X2CharacterTemplate CreateTemplate_AdvShortTurretM3()
{
	local X2CharacterTemplate CharTemplate;

	CharTemplate = CreateTemplate_AdvTurretMk3('AdvShortTurretM3', true);
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_AdvTurret.ARC_GameUnit_AdvTurretVan");

	CharTemplate.Abilities.AddItem('DarkEventAbility_Barrier');

	return CharTemplate;
}

static function X2CharacterTemplate CreateTemplate_Andromedon()
{
	local X2CharacterTemplate CharTemplate;
	local LootReference Loot;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, 'Andromedon');
	CharTemplate.CharacterGroupName = 'Andromedon';
	CharTemplate.DefaultLoadout='Andromedon_Loadout';
	CharTemplate.BehaviorClass=class'XGAIBehavior';
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_Andromedon.ARC_GameUnit_Andromedon");
	//Loot.ForceLevel=0;
	//Loot.LootTableName='Andromedon_BaseLoot';
	//CharTemplate.Loot.LootReferences.AddItem(Loot);

	// Timed Loot
	Loot.ForceLevel = 0;
	Loot.LootTableName = 'Andromedon_TimedLoot';
	CharTemplate.TimedLoot.LootReferences.AddItem(Loot);
	Loot.LootTableName = 'Andromedon_VultureLoot';
	CharTemplate.VultureLoot.LootReferences.AddItem(Loot);

	CharTemplate.strMatineePackages.AddItem("CIN_Andromedon");
	CharTemplate.strMatineePackages.AddItem("CIN_Muton");
	CharTemplate.strTargetingMatineePrefix = "CIN_Muton_FF_StartPos";

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
	CharTemplate.bIsAfraidOfFire = false;

	CharTemplate.bAllowSpawnFromATT = false;

	CharTemplate.AddTemplateAvailablility(CharTemplate.BITFIELD_GAMEAREA_Multiplayer); // Allow in MP!
	CharTemplate.MPPointValue = CharTemplate.XpKillscore * 10;

	CharTemplate.Abilities.AddItem('SwitchToRobot');
	CharTemplate.Abilities.AddItem('AndromedonImmunities');
	CharTemplate.Abilities.AddItem('BigDamnPunch');
	CharTemplate.Abilities.AddItem('WallBreaking');
	CharTemplate.Abilities.AddItem('WallSmash');
	CharTemplate.Abilities.AddItem('RobotBattlesuit');
	//CharTemplate.Abilities.AddItem('ShellLauncher');
	CharTemplate.Abilities.AddItem('DarkEventAbility_Barrier');

	CharTemplate.SightedNarrativeMoments.AddItem(XComNarrativeMoment'X2NarrativeMoments.TACTICAL.AlienSitings.T_Central_AlienSightings_Andromedon');

	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_Alien;

	return CharTemplate;
}

static function X2CharacterTemplate CreateTemplate_AndromedonRobot()
{
	local X2CharacterTemplate CharTemplate;
	local LootReference Loot;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, 'AndromedonRobot');
	CharTemplate.CharacterGroupName = 'AndromedonRobot';
	CharTemplate.DefaultLoadout='AndromedonRobot_Loadout';
	CharTemplate.BehaviorClass=class'XGAIBehavior';
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_Andromedon.ARC_GameUnit_Andromedon_Robot_Suit");
	Loot.ForceLevel=0;
	Loot.LootTableName='AndromedonRobot_BaseLoot';
	CharTemplate.Loot.LootReferences.AddItem(Loot);

	// Timed Loot
	//Loot.ForceLevel = 0;
	//Loot.LootTableName = 'AndromedonRobot_TimedLoot';
	//CharTemplate.TimedLoot.LootReferences.AddItem(Loot);
	//Loot.LootTableName = 'AndromedonRobot_VultureLoot';
	//CharTemplate.VultureLoot.LootReferences.AddItem(Loot);

	CharTemplate.strMatineePackages.AddItem("CIN_Andromedon");
	CharTemplate.strMatineePackages.AddItem("CIN_Muton");
	CharTemplate.strTargetingMatineePrefix = "CIN_Muton_FF_StartPos";

	CharTemplate.UnitSize = 1;
	// Traversal Rules
	CharTemplate.bCanUse_eTraversal_Normal = true;
	CharTemplate.bCanUse_eTraversal_ClimbOver = true;
	CharTemplate.bCanUse_eTraversal_ClimbOnto = true;
	CharTemplate.bCanUse_eTraversal_ClimbLadder = true;
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

	CharTemplate.bIsAlien = true;
	CharTemplate.bIsAdvent = false;
	CharTemplate.bIsCivilian = false;
	CharTemplate.bIsPsionic = false;
	CharTemplate.bIsRobotic = true;
	CharTemplate.bIsSoldier = false;

	CharTemplate.bAllowSpawnFromATT = false;

	CharTemplate.bCanBeTerrorist = false;
	CharTemplate.bCanBeCriticallyWounded = false;
	CharTemplate.bIsAfraidOfFire = false;
	
	CharTemplate.MPPointValue = CharTemplate.XpKillscore * 10;

	CharTemplate.Abilities.AddItem('AndromedonRobotImmunities');
	CharTemplate.Abilities.AddItem('BigDamnPunch');
	CharTemplate.Abilities.AddItem('AndromedonRobotAcidTrail');
	CharTemplate.Abilities.AddItem('WallBreaking');
	CharTemplate.Abilities.AddItem('WallSmash');
	CharTemplate.Abilities.AddItem('RobotReboot');
	CharTemplate.Abilities.AddItem('DarkEventAbility_Barrier');

	CharTemplate.strScamperBT = "ScamperRoot_NoCover";

	CharTemplate.SightedNarrativeMoments.AddItem(XComNarrativeMoment'X2NarrativeMoments.TACTICAL.AlienSitings.T_Central_AlienSightings_First_Andromedon_Battlesuit');
	CharTemplate.strHackIconImage = "UILibrary_Common.TargetIcons.Hack_robot_icon";
	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_Alien;

	return CharTemplate;
}

static function X2CharacterTemplate CreateTemplate_Archon()
{
	local X2CharacterTemplate CharTemplate;
	local LootReference Loot;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, 'Archon');
	CharTemplate.CharacterGroupName = 'Archon';
	CharTemplate.DefaultLoadout='Archon_Loadout';
	CharTemplate.BehaviorClass=class'XGAIBehavior';
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_Archon.ARC_GameUnit_Archon");
	Loot.ForceLevel=0;
	Loot.LootTableName='Archon_BaseLoot';
	CharTemplate.Loot.LootReferences.AddItem(Loot);

	// Timed Loot
	Loot.ForceLevel = 0;
	Loot.LootTableName = 'Archon_TimedLoot';
	CharTemplate.TimedLoot.LootReferences.AddItem(Loot);
	Loot.LootTableName = 'Archon_VultureLoot';
	CharTemplate.VultureLoot.LootReferences.AddItem(Loot);

	CharTemplate.strMatineePackages.AddItem("CIN_Archon");
	CharTemplate.strMatineePackages.AddItem("CIN_AdventMEC");
	CharTemplate.strTargetingMatineePrefix = "CIN_AdventMEC_FF_StartPos";

	CharTemplate.UnitSize = 1;
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

	CharTemplate.bAllowSpawnFromATT = false;

	CharTemplate.bImmueToFalling = true;

	CharTemplate.bCanBeTerrorist = false;
	CharTemplate.bCanBeCriticallyWounded = false;
	CharTemplate.bIsAfraidOfFire = true;
	CharTemplate.AcquiredPhobiaTemplate = 'FearOfArchons';

	CharTemplate.AddTemplateAvailablility(CharTemplate.BITFIELD_GAMEAREA_Multiplayer); // Allow in MP!
	CharTemplate.MPPointValue = CharTemplate.XpKillscore * 10;
	
	CharTemplate.strScamperBT = "ScamperRoot_NoCover";

	CharTemplate.Abilities.AddItem('FrenzyDamageListener');
	CharTemplate.Abilities.AddItem('BlazingPinionsStage1');
	CharTemplate.Abilities.AddItem('DarkEventAbility_Barrier');

	CharTemplate.SightedNarrativeMoments.AddItem(XComNarrativeMoment'X2NarrativeMoments.TACTICAL.AlienSitings.Enemy_Sighted_Archon');

	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_Alien;

	return CharTemplate;
}

static function X2CharacterTemplate CreateTemplate_Berserker()
{
	local X2CharacterTemplate CharTemplate;
	local LootReference Loot;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, 'Berserker');
	CharTemplate.CharacterGroupName = 'Berserker';
	CharTemplate.DefaultLoadout='Berserker_Loadout';
	CharTemplate.BehaviorClass=class'XGAIBehavior';
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_Berserker.ARC_GameUnit_Berserker");
	Loot.ForceLevel=0;
	Loot.LootTableName='Berserker_BaseLoot';
	CharTemplate.Loot.LootReferences.AddItem(Loot);

	// Timed Loot
	//Loot.ForceLevel = 0;
	//Loot.LootTableName = 'Berserker_TimedLoot';
	//CharTemplate.TimedLoot.LootReferences.AddItem(Loot);
	//Loot.LootTableName = 'Berserker_VultureLoot';
	//CharTemplate.VultureLoot.LootReferences.AddItem(Loot);

	CharTemplate.strMatineePackages.AddItem("CIN_Berserker");

	CharTemplate.UnitSize = 1;
	CharTemplate.UnitHeight = 3; //One unit taller than normal
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
	CharTemplate.AcquiredPhobiaTemplate = 'FearOfMutons';

	CharTemplate.bAllowSpawnFromATT = false;
	CharTemplate.bAllowRushCam = false;

	CharTemplate.AddTemplateAvailablility(CharTemplate.BITFIELD_GAMEAREA_Multiplayer); // Allow in MP!
	CharTemplate.MPPointValue = CharTemplate.XpKillscore * 10;
	CharTemplate.strScamperBT = "ScamperRoot_MeleeNoCover";

	CharTemplate.Abilities.AddItem('TriggerRageDamageListener');
	CharTemplate.Abilities.AddItem('DevastatingPunch');
	CharTemplate.Abilities.AddItem('DarkEventAbility_Barrier');

	CharTemplate.SightedNarrativeMoments.AddItem(XComNarrativeMoment'X2NarrativeMoments.TACTICAL.AlienSitings.T_Central_AlienSightings_Berserker');

	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_Alien;

	return CharTemplate;
}

static function X2CharacterTemplate CreateTemplate_Chryssalid()
{
	local X2CharacterTemplate CharTemplate;
	local LootReference Loot;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, 'Chryssalid');
	CharTemplate.CharacterGroupName = 'Chryssalid';
	CharTemplate.DefaultLoadout='Chryssalid_Loadout';
	CharTemplate.BehaviorClass=class'XGAIBehavior';
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_Chryssalid.ARC_GameUnit_Chryssalid");
	Loot.ForceLevel=0;
	Loot.LootTableName='Chryssalid_BaseLoot';
	CharTemplate.Loot.LootReferences.AddItem(Loot);

	// Timed Loot
	//Loot.ForceLevel = 0;
	//Loot.LootTableName = 'Chryssalid_TimedLoot';
	//CharTemplate.TimedLoot.LootReferences.AddItem(Loot);
	//Loot.LootTableName = 'Chryssalid_VultureLoot';
	//CharTemplate.VultureLoot.LootReferences.AddItem(Loot);

	CharTemplate.strMatineePackages.AddItem("CIN_Chryssalid");

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

	CharTemplate.AddTemplateAvailablility(CharTemplate.BITFIELD_GAMEAREA_Multiplayer); // Allow in MP!
	CharTemplate.MPPointValue = CharTemplate.XpKillscore * 10;
	CharTemplate.strScamperBT = "ChryssalidScamperRoot";

	CharTemplate.Abilities.AddItem('ChryssalidSlash');
	CharTemplate.Abilities.AddItem('ChryssalidBurrow');
	CharTemplate.Abilities.AddItem('ChyssalidPoison');
	CharTemplate.Abilities.AddItem('ChryssalidImmunities');
	CharTemplate.Abilities.AddItem('DarkEventAbility_Barrier');

	CharTemplate.SightedNarrativeMoments.AddItem(XComNarrativeMoment'X2NarrativeMoments.TACTICAL.AlienSitings.T_Central_AlienSightings_Cryssalid');

	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_Alien;

	return CharTemplate;
}

static function X2CharacterTemplate CreateTemplate_Cyberus()
{
	local X2CharacterTemplate CharTemplate;
	local LootReference Loot;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, 'Cyberus');
	CharTemplate.CharacterGroupName = 'Cyberus';
	CharTemplate.DefaultLoadout='Cyberus_Loadout';
	CharTemplate.BehaviorClass=class'XGAIBehavior';
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_Cyberus.ARC_GameUnit_Cyberus");
	Loot.ForceLevel=0;
	Loot.LootTableName='Cyberus_BaseLoot';
	CharTemplate.Loot.LootReferences.AddItem(Loot);

	// Timed Loot
	Loot.ForceLevel = 0;
	Loot.LootTableName = 'Cyberus_TimedLoot';
	CharTemplate.TimedLoot.LootReferences.AddItem(Loot);
	Loot.LootTableName = 'Cyberus_VultureLoot';
	CharTemplate.VultureLoot.LootReferences.AddItem(Loot);

	CharTemplate.strMatineePackages.AddItem("CIN_Cyberus");

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
	CharTemplate.bIsHumanoid = true;
	CharTemplate.bIsAdvent = false;
	CharTemplate.bIsCivilian = false;
	CharTemplate.bIsPsionic = true;
	CharTemplate.bIsRobotic = false;
	CharTemplate.bIsSoldier = false;
	CharTemplate.bWeakAgainstTechLikeRobot = true;

	CharTemplate.bCanBeTerrorist = false;
	CharTemplate.bCanBeCriticallyWounded = false;
	CharTemplate.bIsAfraidOfFire = true;

	CharTemplate.bAllowSpawnFromATT = false;

	CharTemplate.AddTemplateAvailablility(CharTemplate.BITFIELD_GAMEAREA_Multiplayer); // Allow in MP!
	CharTemplate.MPPointValue = CharTemplate.XpKillscore * 10;

	CharTemplate.Abilities.AddItem('Teleport');
//  CharTemplate.Abilities.AddItem('Malfunction');
	CharTemplate.Abilities.AddItem('PsiBombStage1');
	CharTemplate.Abilities.AddItem('TriggerSuperpositionDamageListener');
//	CharTemplate.Abilities.AddItem('StunnedDeath');
	CharTemplate.Abilities.AddItem('Superposition');
//	CharTemplate.Abilities.AddItem('TechVulnerability');
	CharTemplate.Abilities.AddItem('CodexImmunities');
	CharTemplate.Abilities.AddItem('DarkEventAbility_Barrier');
	
	CharTemplate.SightedNarrativeMoments.AddItem(XComNarrativeMoment'X2NarrativeMoments.TACTICAL.goldenpath.GP_FirstCodexAppears');
	CharTemplate.SightedEvents.AddItem('CyberusSighted');
	CharTemplate.DeathEvent = 'KilledACodex';

	CharTemplate.SpawnRequirements.RequiredObjectives.AddItem('T1_M2_HackACaptain');

	CharTemplate.strHackIconImage = "UILibrary_Common.TargetIcons.Hack_codex_icon";
	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_Alien;

	CharTemplate.ReactionFireDeathAnim = 'HL_DeathDefaultA'; //This has the anim notify for hiding the character mesh.

	return CharTemplate;
}

static function X2CharacterTemplate CreateTemplate_Faceless()
{
	local X2CharacterTemplate CharTemplate;
	local LootReference Loot;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, 'Faceless');
	CharTemplate.CharacterGroupName = 'Faceless';
	CharTemplate.DefaultLoadout='Faceless_Loadout';
	CharTemplate.BehaviorClass=class'XGAIBehavior';
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_Faceless.ARC_GameUnit_Faceless");
	Loot.ForceLevel=0;
	Loot.LootTableName='Faceless_BaseLoot';
	CharTemplate.Loot.LootReferences.AddItem(Loot);

	// Timed Loot
	Loot.ForceLevel = 0;
	Loot.LootTableName = 'Faceless_TimedLoot';
	CharTemplate.TimedLoot.LootReferences.AddItem(Loot);
	Loot.LootTableName = 'Faceless_VultureLoot';
	CharTemplate.VultureLoot.LootReferences.AddItem(Loot);

	CharTemplate.strMatineePackages.AddItem("CIN_Faceless");

	CharTemplate.UnitSize = 1;
	CharTemplate.UnitHeight = 4; //Faceless is tall

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
	CharTemplate.AcquiredPhobiaTemplate = 'FearOfFaceless';

	CharTemplate.bAllowSpawnFromATT = false;

	CharTemplate.AddTemplateAvailablility(CharTemplate.BITFIELD_GAMEAREA_Multiplayer); // Allow in MP!
	CharTemplate.MPPointValue = CharTemplate.XpKillscore * 10;
	CharTemplate.strScamperBT = "ScamperRoot_NoCover";

	CharTemplate.Abilities.AddItem('FacelessInit');
	CharTemplate.Abilities.AddItem('ScythingClaws');
	CharTemplate.Abilities.AddItem('DarkEventAbility_Barrier');

	CharTemplate.SightedNarrativeMoments.AddItem(XComNarrativeMoment'X2NarrativeMoments.TACTICAL.AlienSitings.T_Central_AlienSightings_Faceless');
	CharTemplate.SightedNarrativeMoments.AddItem(XComNarrativeMoment'X2NarrativeMoments.TACTICAL.AlienSitings.T_Tygan_AlienSightings_Faceless');
	CharTemplate.SightedNarrativeMoments.AddItem(XComNarrativeMoment'X2NarrativeMoments.TACTICAL.AlienSitings.T_Shen_AlienSightings_Faceless');

	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_Alien;

	return CharTemplate;
}

static function X2CharacterTemplate CreateTemplate_Gatekeeper()
{
	local X2CharacterTemplate CharTemplate;
	local LootReference Loot;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, 'Gatekeeper');
	CharTemplate.CharacterGroupName = 'Gatekeeper';
	CharTemplate.DefaultLoadout='Gatekeeper_Loadout';
	CharTemplate.BehaviorClass=class'XGAIBehavior';
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_Gatekeeper.ARC_GameUnit_Gatekeeper");
	Loot.ForceLevel=0;
	Loot.LootTableName='Gatekeeper_BaseLoot';
	CharTemplate.Loot.LootReferences.AddItem(Loot);

	// Timed Loot
	Loot.ForceLevel = 0;
	Loot.LootTableName = 'Gatekeeper_TimedLoot';
	CharTemplate.TimedLoot.LootReferences.AddItem(Loot);
	Loot.LootTableName = 'Gatekeeper_VultureLoot';
	CharTemplate.VultureLoot.LootReferences.AddItem(Loot);

	CharTemplate.strMatineePackages.AddItem("CIN_Gatekeeper");
	CharTemplate.GetRevealMatineePrefixFn = GetGateKeeperRevealMatineePrefix;
	CharTemplate.strTargetingMatineePrefix = "CIN_Gatekeeper_FF_StartPos";	

	CharTemplate.UnitSize = 2;

	CharTemplate.KillContribution = 2.0;

	// Traversal Rules
	CharTemplate.bCanUse_eTraversal_Normal = true;
	CharTemplate.bCanUse_eTraversal_ClimbOver = false;
	CharTemplate.bCanUse_eTraversal_ClimbOnto = false;
	CharTemplate.bCanUse_eTraversal_ClimbLadder = false;
	CharTemplate.bCanUse_eTraversal_DropDown = false;
	CharTemplate.bCanUse_eTraversal_Grapple = false;
	CharTemplate.bCanUse_eTraversal_Landing = true;
	CharTemplate.bCanUse_eTraversal_BreakWindow = false;
	CharTemplate.bCanUse_eTraversal_KickDoor = false;
	CharTemplate.bCanUse_eTraversal_JumpUp = false;
	CharTemplate.bCanUse_eTraversal_WallClimb = false;
	CharTemplate.bCanUse_eTraversal_BreakWall = false;
	CharTemplate.bCanUse_eTraversal_Launch = true;
	CharTemplate.bCanUse_eTraversal_Flying = true;
	CharTemplate.bCanUse_eTraversal_Land = true;
	CharTemplate.MaxFlightPitchDegrees = 0;
	CharTemplate.bAppearanceDefinesPawn = false;    
	CharTemplate.bCanTakeCover = false;

	CharTemplate.bIsAlien = true;
	CharTemplate.bIsAdvent = false;
	CharTemplate.bIsCivilian = false;
	CharTemplate.bIsPsionic = true;
	CharTemplate.bIsRobotic = false;
	CharTemplate.bIsSoldier = false;
	CharTemplate.bAllowRushCam = false;
	CharTemplate.bWeakAgainstTechLikeRobot = true;

	CharTemplate.bCanBeTerrorist = false;
	CharTemplate.bCanBeCriticallyWounded = false;
	CharTemplate.bIsAfraidOfFire = true;

	CharTemplate.bAllowSpawnFromATT = false;
	CharTemplate.bImmueToFalling = true;

	CharTemplate.AddTemplateAvailablility(CharTemplate.BITFIELD_GAMEAREA_Multiplayer); // Allow in MP!
	CharTemplate.MPPointValue = CharTemplate.XpKillscore * 10;

	CharTemplate.strScamperBT = "ScamperRoot_NoCover";

	CharTemplate.Abilities.AddItem('GatekeeperInitialState');  // Sets initial closed effect on Gatekeeper.
	CharTemplate.Abilities.AddItem('Retract');
	CharTemplate.Abilities.AddItem('AnimaInversion');
	CharTemplate.Abilities.AddItem('AnimaConsume');
	CharTemplate.Abilities.AddItem('AnimaGate');
	CharTemplate.Abilities.AddItem('DeathExplosion');
	CharTemplate.Abilities.AddItem('KillSiredZombies');
	CharTemplate.Abilities.AddItem('DarkEventAbility_Barrier');

	CharTemplate.SightedNarrativeMoments.AddItem(XComNarrativeMoment'X2NarrativeMoments.TACTICAL.AlienSitings.T_Shen_AlienSightings_Gatekeeper');

	CharTemplate.strHackIconImage = "UILibrary_Common.TargetIcons.Hack_robot_icon";
	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_Alien;

	return CharTemplate;
}

static function string GetGateKeeperRevealMatineePrefix(XComGameState_Unit UnitState)
{
	if(UnitState.IsUnitAffectedByEffectName(class'X2Ability_Gatekeeper'.default.ClosedEffectName))
	{
		return "CIN_Gatekeeper_Closed";
	}
	else
	{
		return "CIN_Gatekeeper_Open";
	}
}

static function string GetAdventMatineePrefix(XComGameState_Unit UnitState)
{
	if(UnitState.kAppearance.iGender == eGender_Male)
	{
		return UnitState.GetMyTemplate().RevealMatineePrefix $ "_Male";
	}
	else
	{
		return UnitState.GetMyTemplate().RevealMatineePrefix $ "_Female";
	}
}

static function X2CharacterTemplate CreateTemplate_Muton()
{
	local X2CharacterTemplate CharTemplate;
	local LootReference Loot;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, 'Muton');
	CharTemplate.CharacterGroupName = 'Muton';
	CharTemplate.DefaultLoadout='Muton_Loadout';
	CharTemplate.BehaviorClass=class'XGAIBehavior';
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_Muton.ARC_GameUnit_Muton");
	Loot.ForceLevel=0;
	Loot.LootTableName='Muton_BaseLoot';
	CharTemplate.Loot.LootReferences.AddItem(Loot);

	// Timed Loot
	Loot.ForceLevel = 0;
	Loot.LootTableName = 'Muton_TimedLoot';
	CharTemplate.TimedLoot.LootReferences.AddItem(Loot);
	Loot.LootTableName = 'Muton_VultureLoot';
	CharTemplate.VultureLoot.LootReferences.AddItem(Loot);

	CharTemplate.strMatineePackages.AddItem("CIN_Muton");
	CharTemplate.strTargetingMatineePrefix = "CIN_Muton_FF_StartPos";

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
	CharTemplate.bAllowRushCam = false;

	CharTemplate.bCanBeTerrorist = false;
	CharTemplate.bCanBeCriticallyWounded = false;
	CharTemplate.bIsAfraidOfFire = true;
	CharTemplate.AcquiredPhobiaTemplate = 'FearOfMutons';

	CharTemplate.bAllowSpawnFromATT = false;

	CharTemplate.Abilities.AddItem('CounterattackPreparation');
	CharTemplate.Abilities.AddItem('CounterattackDescription');
	CharTemplate.Abilities.AddItem('DarkEventAbility_Barrier');

	CharTemplate.AddTemplateAvailablility(CharTemplate.BITFIELD_GAMEAREA_Multiplayer); // Allow in MP!
	CharTemplate.MPPointValue = CharTemplate.XpKillscore * 10;

	CharTemplate.SightedNarrativeMoments.AddItem(XComNarrativeMoment'X2NarrativeMoments.TACTICAL.AlienSitings.T_Central_AlienSightings_Muton');

	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_Alien;

	return CharTemplate;
}

static function X2CharacterTemplate CreateTemplate_Sectoid()
{
	local X2CharacterTemplate CharTemplate;
	local LootReference Loot;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, 'Sectoid');
	CharTemplate.CharacterGroupName = 'Sectoid';
	CharTemplate.DefaultLoadout='Sectoid_Loadout';
	CharTemplate.BehaviorClass=class'XGAIBehavior';
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_Sectoid.ARC_GameUnit_Sectoid");
	Loot.ForceLevel=0;
	Loot.LootTableName='Sectoid_BaseLoot';
	CharTemplate.Loot.LootReferences.AddItem(Loot);

	// Timed Loot
	Loot.ForceLevel = 0;
	Loot.LootTableName = 'Sectoid_TimedLoot';
	CharTemplate.TimedLoot.LootReferences.AddItem(Loot);
	Loot.LootTableName = 'Sectoid_VultureLoot';
	CharTemplate.VultureLoot.LootReferences.AddItem(Loot);

	CharTemplate.strMatineePackages.AddItem("CIN_Sectoid");

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
	CharTemplate.bIsPsionic = true;
	CharTemplate.bIsRobotic = false;
	CharTemplate.bIsSoldier = false;

	CharTemplate.bCanBeTerrorist = false;
	CharTemplate.bCanBeCriticallyWounded = false;
	CharTemplate.bIsAfraidOfFire = true;

	CharTemplate.bAllowSpawnFromATT = false;

	CharTemplate.Abilities.AddItem('VulnerabilityMelee');
	CharTemplate.Abilities.AddItem('Mindspin');
	//CharTemplate.Abilities.AddItem('DelayedPsiExplosion');
	CharTemplate.Abilities.AddItem('PsiReanimation');
	CharTemplate.Abilities.AddItem('KillSiredZombies');
	//CharTemplate.Abilities.AddItem('SectoidDeathOverride');
	CharTemplate.Abilities.AddItem('DarkEventAbility_Barrier');

	CharTemplate.AddTemplateAvailablility(CharTemplate.BITFIELD_GAMEAREA_Multiplayer); // Allow in MP!
	CharTemplate.MPPointValue = CharTemplate.XpKillscore * 10;

	CharTemplate.SightedNarrativeMoments.AddItem(XComNarrativeMoment'X2NarrativeMoments.TACTICAL.AlienSitings.T_Tygan_AlienSightings_Sectoid');

	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_Alien;
	CharTemplate.AcquiredPhobiaTemplate = 'FearOfSectoids';

	return CharTemplate;
}

static function X2CharacterTemplate CreateTemplate_Sectopod()
{
	local X2CharacterTemplate CharTemplate;
	local LootReference Loot;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, 'Sectopod');
	CharTemplate.CharacterGroupName = 'Sectopod';
	CharTemplate.DefaultLoadout='Sectopod_Loadout';
	CharTemplate.BehaviorClass=class'XGAIBehavior';
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_Sectopod.ARC_GameUnit_Sectopod");
	Loot.ForceLevel=0;
	Loot.LootTableName='Sectopod_BaseLoot';
	CharTemplate.Loot.LootReferences.AddItem(Loot);

	// Timed Loot
	Loot.ForceLevel = 0;
	Loot.LootTableName = 'Sectopod_TimedLoot';
	CharTemplate.TimedLoot.LootReferences.AddItem(Loot);
	Loot.LootTableName = 'Sectopod_VultureLoot';
	CharTemplate.VultureLoot.LootReferences.AddItem(Loot);

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
	//CharTemplate.AcquiredPhobiaTemplate = 'FearOfMecs';

	CharTemplate.bAllowSpawnFromATT = false;

	CharTemplate.AddTemplateAvailablility(CharTemplate.BITFIELD_GAMEAREA_Multiplayer); // Allow in MP!
	CharTemplate.MPPointValue = CharTemplate.XpKillscore * 10;

	CharTemplate.strScamperBT = "ScamperRoot_NoCover";

	CharTemplate.SightedNarrativeMoments.AddItem(XComNarrativeMoment'X2NarrativeMoments.TACTICAL.AlienSitings.T_Shen_AlienSightings_Sectopod');

	CharTemplate.ImmuneTypes.AddItem('Fire');

	CharTemplate.Abilities.AddItem('StandardMove');
	CharTemplate.Abilities.AddItem('SectopodHigh');
	CharTemplate.Abilities.AddItem('SectopodLow');
	CharTemplate.Abilities.AddItem('SectopodLightningField');
	CharTemplate.Abilities.AddItem('DeathExplosion');
	CharTemplate.Abilities.AddItem('SectopodInitialState');
	CharTemplate.Abilities.AddItem('SectopodNewTeamState');

	CharTemplate.strHackIconImage = "UILibrary_Common.TargetIcons.Hack_robot_icon";
	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_Alien;

	CharTemplate.Abilities.AddItem('DarkEventAbility_Barrier');

	return CharTemplate;
}

static function X2CharacterTemplate CreateTemplate_PrototypeSectopod()
{
	local X2CharacterTemplate CharTemplate;
	local LootReference Loot;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, 'PrototypeSectopod');
	CharTemplate.CharacterGroupName = 'Sectopod';
	CharTemplate.DefaultLoadout='PrototypeSectopod_Loadout';
	CharTemplate.BehaviorClass=class'XGAIBehavior';
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_Sectopod.ARC_GameUnit_Sectopod");
	Loot.ForceLevel=0;
	Loot.LootTableName='Sectopod_BaseLoot';
	CharTemplate.Loot.LootReferences.AddItem(Loot);

	// Timed Loot
	Loot.ForceLevel = 0;
	Loot.LootTableName = 'Sectopod_TimedLoot';
	CharTemplate.TimedLoot.LootReferences.AddItem(Loot);
	Loot.LootTableName = 'Sectopod_VultureLoot';
	CharTemplate.VultureLoot.LootReferences.AddItem(Loot);

	CharTemplate.strMatineePackages.AddItem("CIN_Sectopod");
	CharTemplate.strTargetingMatineePrefix = "CIN_Sectopod_FF_StartPos";

	CharTemplate.UnitSize = 3;
	// Traversal Rules
	CharTemplate.bCanUse_eTraversal_Normal = true;
	CharTemplate.bCanUse_eTraversal_ClimbOver = false;
	CharTemplate.bCanUse_eTraversal_ClimbOnto = false;
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

	CharTemplate.SightedNarrativeMoments.AddItem(XComNarrativeMoment'X2NarrativeMoments.TACTICAL.AlienSitings.T_Shen_AlienSightings_Sectopod');

	CharTemplate.ImmuneTypes.AddItem('Fire');

	CharTemplate.Abilities.AddItem('StandardMove');
	CharTemplate.Abilities.AddItem('SectopodHigh');
	CharTemplate.Abilities.AddItem('SectopodLow');
	CharTemplate.Abilities.AddItem('SectopodLightningField');
	CharTemplate.Abilities.AddItem('DeathExplosion');
	CharTemplate.Abilities.AddItem('SectopodInitialState');
	CharTemplate.Abilities.AddItem('SectopodNewTeamState');
	CharTemplate.Abilities.AddItem('DarkEventAbility_Barrier');

	CharTemplate.strHackIconImage = "UILibrary_Common.TargetIcons.Hack_robot_icon";
	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_Alien;

	return CharTemplate;
}

static function X2CharacterTemplate CreateTemplate_Viper()
{
	local X2CharacterTemplate CharTemplate;
	local LootReference Loot;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, 'Viper');
	CharTemplate.CharacterGroupName = 'Viper';
	CharTemplate.DefaultLoadout='Viper_Loadout';
	CharTemplate.BehaviorClass=class'XGAIBehavior';
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_Viper.ARC_GameUnit_Viper");
	Loot.ForceLevel=0;
	Loot.LootTableName='Viper_BaseLoot';
	CharTemplate.Loot.LootReferences.AddItem(Loot);

	// Timed Loot
	Loot.ForceLevel = 0;
	Loot.LootTableName = 'Viper_TimedLoot';
	CharTemplate.TimedLoot.LootReferences.AddItem(Loot);
	Loot.LootTableName = 'Viper_VultureLoot';
	CharTemplate.VultureLoot.LootReferences.AddItem(Loot);

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
	CharTemplate.AcquiredPhobiaTemplate = 'FearOfVipers';

	CharTemplate.ImmuneTypes.AddItem('Poison');

	CharTemplate.bAllowSpawnFromATT = false;

	CharTemplate.Abilities.AddItem('Bind');
	CharTemplate.Abilities.AddItem('DarkEventAbility_Barrier');

	CharTemplate.AddTemplateAvailablility(CharTemplate.BITFIELD_GAMEAREA_Multiplayer); // Allow in MP!
	CharTemplate.MPPointValue = CharTemplate.XpKillscore * 10;

	CharTemplate.SightedNarrativeMoments.AddItem(XComNarrativeMoment'X2NarrativeMoments.TACTICAL.AlienSitings.T_Tygan_AlienSightings_Viper');
	CharTemplate.SightedNarrativeMoments.AddItem(XComNarrativeMoment'X2NarrativeMoments.TACTICAL.AlienSitings.T_Central_AlienSightings_Viper');

	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_Alien;

	return CharTemplate;
}

static function X2CharacterTemplate CreateTemplate_PsiZombie(Name TemplateName = 'PsiZombie')
{
	local X2CharacterTemplate CharTemplate;
	//local LootReference Loot;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, TemplateName);
	CharTemplate.CharacterGroupName = 'PsiZombie';
	CharTemplate.DefaultLoadout='PsiZombie_Loadout';
	CharTemplate.BehaviorClass=class'XGAIBehavior';
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_Zombie.ARC_GameUnit_Zombie");
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_Zombie.ARC_GameUnit_Zombie_F");
	//Loot.ForceLevel=0;
	//Loot.LootTableName='PsiZombie_BaseLoot';
	//CharTemplate.Loot.LootReferences.AddItem(Loot);

	// Timed Loot
	//Loot.ForceLevel = 0;
	//Loot.LootTableName = 'PsiZombie_TimedLoot';
	//CharTemplate.TimedLoot.LootReferences.AddItem(Loot);
	//Loot.LootTableName = 'PsiZombie_VultureLoot';
	//CharTemplate.VultureLoot.LootReferences.AddItem(Loot);

	CharTemplate.strMatineePackages.AddItem("CIN_Zombie");

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
	CharTemplate.bCanTakeCover = false;

	CharTemplate.bSkipDefaultAbilities = true;

	CharTemplate.bIsAlien = false;
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

	CharTemplate.strScamperBT = "ScamperRoot_NoCover";

	CharTemplate.ImmuneTypes.AddItem('Mental');
	CharTemplate.ImmuneTypes.AddItem('Poison');
	CharTemplate.ImmuneTypes.AddItem(class'X2Item_DefaultDamageTypes'.default.ParthenogenicPoisonType);

	CharTemplate.Abilities.AddItem('StandardMove');
	CharTemplate.Abilities.AddItem('ZombieInitialization');
	CharTemplate.Abilities.AddItem('DarkEventAbility_Barrier');

	CharTemplate.SightedNarrativeMoments.AddItem(XComNarrativeMoment'X2NarrativeMoments.TACTICAL.AlienSitings.T_Central_AlienSightings_PsiZombie');
	
	CharTemplate.MPPointValue = CharTemplate.XpKillscore * 10;

	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_Alien;

	return CharTemplate;
}

static function X2CharacterTemplate CreateTemplate_PsiZombieHuman()
{
	local X2CharacterTemplate CharTemplate;
	CharTemplate = CreateTemplate_PsiZombie('PsiZombieHuman');
	CharTemplate.strPawnArchetypes.Length = 0;
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_Zombie.ARC_GameUnit_Zombie_Human_M");
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_Zombie.ARC_GameUnit_Zombie_Human_F");

	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_Alien;

	return CharTemplate;
}

static function X2CharacterTemplate CreateTemplate_TheLost(name LostName, name LoadoutName)
{
	local X2CharacterTemplate CharTemplate;
	local LootReference Loot;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, LostName);
	CharTemplate.CharacterGroupName = 'TheLost';
	CharTemplate.BehaviorClass = class'XGAIBehavior';
	Loot.ForceLevel = 0;
	Loot.LootTableName = 'TheLost_BaseLoot';
	CharTemplate.Loot.LootReferences.AddItem(Loot);
	CharTemplate.DefaultLoadout = LoadoutName;
	
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_TheLost.ARC_GameUnit_TheLost_A");
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_TheLost.ARC_GameUnit_TheLost_B");
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_TheLost.ARC_GameUnit_TheLost_C");
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_TheLost.ARC_GameUnit_TheLost_D");

	CharTemplate.strMatineePackages.AddItem("CIN_XP_Lost");

	CharTemplate.UnitSize = 1;

	CharTemplate.KillContribution = 0.25;

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

	CharTemplate.bSkipDefaultAbilities = true;

	CharTemplate.bIsAlien = false;
	CharTemplate.bIsAdvent = false;
	CharTemplate.bIsCivilian = false;
	CharTemplate.bIsPsionic = false;
	CharTemplate.bIsRobotic = false;
	CharTemplate.bIsSoldier = false;
	CharTemplate.bIsMeleeOnly = true;

	CharTemplate.bCanBeTerrorist = false;
	CharTemplate.bCanBeCriticallyWounded = false;
	CharTemplate.bIsAfraidOfFire = true;

	CharTemplate.bDisplayUIUnitFlag = true;
	
	CharTemplate.bAllowSpawnFromATT = false;

	CharTemplate.strScamperBT = "TheLostScamperRoot";

	CharTemplate.ImmuneTypes.AddItem('Mental');
	CharTemplate.ImmuneTypes.AddItem('Poison');
	CharTemplate.ImmuneTypes.AddItem(class'X2Item_DefaultDamageTypes'.default.ParthenogenicPoisonType);

	CharTemplate.Abilities.AddItem('StandardMove');
	CharTemplate.Abilities.AddItem('ZombieInitialization');
	CharTemplate.Abilities.AddItem('LostHeadshotInit');

	CharTemplate.SightedNarrativeMoments.AddItem(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_CEN_T_First_Seen_Lost');
	CharTemplate.SightedNarrativeMoments.AddItem(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_CEN_T_First_Lost_Seen_A');
	CharTemplate.SightedNarrativeMoments.AddItem(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_CEN_T_First_Lost_Seen_B');
	
	CharTemplate.MPPointValue = CharTemplate.XpKillscore * 10;

	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_TheLost;

	CharTemplate.bDontUseOTSTargetingCamera = true;

	CharTemplate.AcquiredPhobiaTemplate = 'FearOfTheLost';

	return CharTemplate;
}

static function X2CharacterTemplate CreateTemplate_TheLostDasher(name LostName, name LoadoutName)
{
	local X2CharacterTemplate CharTemplate;

	CharTemplate = CreateTemplate_TheLost(LostName, LoadoutName);

	CharTemplate.strPawnArchetypes.Length = 0;
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_TheLost.ARC_GameUnit_TheLost_Wolf");

	CharTemplate.SightedNarrativeMoments.Length = 0;
	CharTemplate.SightedNarrativeMoments.AddItem(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_CEN_T_First_Dasher_A');
	CharTemplate.SightedNarrativeMoments.AddItem(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_CEN_T_First_Dasher_B');

	return CharTemplate;
}

static function X2CharacterTemplate CreateTemplate_TheLostHowler(name LostName, name LoadoutName)
{
	local X2CharacterTemplate CharTemplate;

	CharTemplate = CreateTemplate_TheLost(LostName, LoadoutName);
	
	CharTemplate.strPawnArchetypes.Length = 0;
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_TheLost.ARC_GameUnit_TheLost_Howler");

	CharTemplate.AIOrderPriority = 100;

	return CharTemplate;
}

static function X2CharacterTemplate CreateTemplate_ChryssalidCocoon(Name TemplateName = 'ChryssalidCocoon')
{
	local X2CharacterTemplate CharTemplate;
	//local LootReference Loot;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, TemplateName);
	CharTemplate.CharacterGroupName = 'Chryssalid';
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_ChryssalidCocoon.ARC_GameUnit_ChryssalidCocoon_New");

	CharTemplate.strMatineePackages.AddItem("CIN_Advent");

	CharTemplate.UnitSize = 1;

	// Traversal Rules
	CharTemplate.bCanUse_eTraversal_Normal = false;
	CharTemplate.bCanUse_eTraversal_ClimbOver = false;
	CharTemplate.bCanUse_eTraversal_ClimbOnto = false;
	CharTemplate.bCanUse_eTraversal_ClimbLadder = false;
	CharTemplate.bCanUse_eTraversal_DropDown = false;
	CharTemplate.bCanUse_eTraversal_Grapple = false;
	CharTemplate.bCanUse_eTraversal_Landing = false;
	CharTemplate.bCanUse_eTraversal_BreakWindow = false;
	CharTemplate.bCanUse_eTraversal_KickDoor = false;
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

	CharTemplate.bCanBeTerrorist = false;
	CharTemplate.bCanBeCriticallyWounded = false;
	CharTemplate.bIsAfraidOfFire = false;
	CharTemplate.bAllowSpawnFromATT = false;
	CharTemplate.bSkipDefaultAbilities = true;

	CharTemplate.Abilities.AddItem('CocoonGestationTimeStage1');

	CharTemplate.ImmuneTypes.AddItem('Mental');
	
	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_Alien;

	return CharTemplate;
}

static function X2CharacterTemplate CreateTemplate_ChryssalidCocoonHuman()
{
	local X2CharacterTemplate CharTemplate;
	CharTemplate = CreateTemplate_ChryssalidCocoon('ChryssalidCocoonHuman');
	CharTemplate.strPawnArchetypes.Length = 0;
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_ChryssalidCocoon.ARC_GameUnit_ChryssalidCocoonHuman_New");

	return CharTemplate;
}

static function X2CharacterTemplate CreateTemplate_MimicBeacon()
{
	local X2CharacterTemplate CharTemplate;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, 'MimicBeacon');

	CharTemplate.strPawnArchetypes.AddItem("GameUnit_MimicBeacon.ARC_MimicBeacon_M");
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_MimicBeacon.ARC_MimicBeacon_F");

	CharTemplate.UnitSize = 1;

	// Traversal Rules
	CharTemplate.bCanUse_eTraversal_Normal = true;
	CharTemplate.bCanUse_eTraversal_ClimbOver = true;
	CharTemplate.bCanUse_eTraversal_ClimbOnto = true;
	CharTemplate.bCanUse_eTraversal_ClimbLadder = true;
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

	CharTemplate.bIsAlien = false;
	CharTemplate.bIsAdvent = false;
	CharTemplate.bIsCivilian = false;
	CharTemplate.bIsPsionic = false;
	CharTemplate.bIsRobotic = false;
	CharTemplate.bIsSoldier = false;
	CharTemplate.bIsMeleeOnly = false;

	CharTemplate.bCanBeTerrorist = false;
	CharTemplate.bCanBeCriticallyWounded = false;
	CharTemplate.bIsAfraidOfFire = false;
	
	CharTemplate.bAllowSpawnFromATT = false;

	CharTemplate.bDisplayUIUnitFlag = false;
	CharTemplate.bNeverSelectable = true;

	CharTemplate.Abilities.AddItem('MimicBeaconInitialize');
	CharTemplate.Abilities.AddItem('GuaranteedToHit');

	return CharTemplate;
}

static function X2CharacterTemplate CreateTemplate_TestDummyPanic()
{
	local X2CharacterTemplate CharTemplate;
	local LootReference Loot;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, 'TestDummyPanic');
	CharTemplate.CharacterGroupName = 'AdventTrooper';
	CharTemplate.DefaultLoadout='AdvCaptainM1_Loadout';
	CharTemplate.BehaviorClass=class'XGAIBehavior';
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_AdvTrooper.ARC_GameUnit_AdvTrooperM1_M");

	// Auto-Loot
	Loot.ForceLevel = 0;
	Loot.LootTableName = 'AdvTrooperM1_BaseLoot';
	CharTemplate.Loot.LootReferences.AddItem(Loot);

	// Timed Loot
	Loot.ForceLevel = 0;
	Loot.LootTableName = 'AdvTrooperM1_TimedLoot';
	CharTemplate.TimedLoot.LootReferences.AddItem(Loot);
	Loot.LootTableName = 'AdvTrooperM1_VultureLoot';
	CharTemplate.VultureLoot.LootReferences.AddItem(Loot);

	CharTemplate.strMatineePackages.AddItem("CIN_Advent");

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

	CharTemplate.bIsAlien = false;
	CharTemplate.bIsAdvent = true;
	CharTemplate.bIsCivilian = false;
	CharTemplate.bIsPsionic = false;
	CharTemplate.bIsRobotic = false;
	CharTemplate.bIsSoldier = false;

	CharTemplate.bCanBeTerrorist = false;
	CharTemplate.bCanBeCriticallyWounded = false;
	CharTemplate.bIsAfraidOfFire = true;
	
	CharTemplate.strBehaviorTree = "PanickedRoot";

	CharTemplate.SightedNarrativeMoments.AddItem(XComNarrativeMoment'X2NarrativeMoments.TACTICAL.AlienSitings.T_Central_AlienSightings_AdvTrooperM1');

	//CharTemplate.AddTemplateAvailablility(CharTemplate.BITFIELD_GAMEAREA_Multiplayer); // Allow in MP!
	CharTemplate.MPPointValue = CharTemplate.XpKillscore * 10;

	CharTemplate.bShouldCreateDifficultyVariants = false;

	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_Advent;

	return CharTemplate;
}

static function X2CharacterTemplate CreateSpeakerTemplate(Name CharacterName, optional string CharacterSpeakerName = "", optional string CharacterSpeakerPortrait = "", optional EGender Gender = eGender_Female)
{
	local X2CharacterTemplate CharTemplate;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, CharacterName);
	CharTemplate.CharacterGroupName = 'Speaker';
	if( CharTemplate.strCharacterName == "" )
	{
		CharTemplate.strCharacterName = CharacterSpeakerName;
	}
	CharTemplate.SpeakerPortrait = CharacterSpeakerPortrait;
	CharTemplate.DefaultAppearance.iGender = int(Gender);

	CharTemplate.bShouldCreateDifficultyVariants = false;

	return CharTemplate;
}

///////////FOR XPAC/////////////
static function X2CharacterTemplate CreateTemplate_ReaperSoldier()
{
	local X2CharacterTemplate CharTemplate;

	CharTemplate = CreateSoldierTemplate('ReaperSoldier');

	CharTemplate.bIsResistanceHero = true;
	CharTemplate.DefaultSoldierClass = 'Reaper';
	CharTemplate.DefaultLoadout = 'SquaddieReaper';

	CharTemplate.CharacterGeneratorClass = class'XGCharacterGenerator_Reaper';
	CharTemplate.CustomizationManagerClass = class'XComCharacterCustomization_FactionHero';
	CharTemplate.GetPawnNameFn = GetReaperPawnName;

	return CharTemplate;
}

function name GetReaperPawnName(optional EGender Gender)
{
	if (Gender == eGender_Male)
		return 'XCom_Soldier_Reaper_M';
	else
		return 'XCom_Soldier_Reaper_F';
}

static function X2CharacterTemplate CreateTemplate_SkirmisherSoldier()
{
	local X2CharacterTemplate CharTemplate;

	CharTemplate = CreateSoldierTemplate('SkirmisherSoldier');

	CharTemplate.bIsResistanceHero = true;
	CharTemplate.DefaultSoldierClass = 'Skirmisher';
	CharTemplate.DefaultLoadout = 'SquaddieSkirmisher';
	
	// Ensure only Skirmisher heads are available for customization
	CharTemplate.bHasCharacterExclusiveAppearance = true;

	CharTemplate.CharacterGeneratorClass = class'XGCharacterGenerator_Skirmisher';
	CharTemplate.CustomizationManagerClass = class'XComCharacterCustomization_FactionHero';
	CharTemplate.UICustomizationHeadClass = class'UICustomize_SkirmisherHead';
	CharTemplate.GetPawnNameFn = GetSkirmisherPawnName;

	return CharTemplate;
}

function name GetSkirmisherPawnName(optional EGender Gender)
{
	if (Gender == eGender_Male)
		return 'XCom_Soldier_Skirmisher_M';
	else
		return 'XCom_Soldier_Skirmisher_F';
}

static function X2CharacterTemplate CreateTemplate_TemplarSoldier()
{
	local X2CharacterTemplate CharTemplate;

	CharTemplate = CreateSoldierTemplate('TemplarSoldier');

	CharTemplate.bIsResistanceHero = true;
	CharTemplate.DefaultSoldierClass = 'Templar';
	CharTemplate.DefaultLoadout = 'SquaddieTemplar';

	CharTemplate.strIntroMatineeSlotPrefix = "Templar";

	CharTemplate.CharacterGeneratorClass = class'XGCharacterGenerator_Templar';
	CharTemplate.CustomizationManagerClass = class'XComCharacterCustomization_FactionHero';
	CharTemplate.UICustomizationInfoClass = class'UICustomize_TemplarInfo';
	CharTemplate.GetPawnNameFn = GetTemplarPawnName;

	CharTemplate.strMatineePackages.AddItem("CIN_XP_Heroes");

	return CharTemplate;
}

function name GetTemplarPawnName(optional EGender Gender)
{
	if (Gender == eGender_Male)
		return 'XCom_Soldier_Templar_M';
	else
		return 'XCom_Soldier_Templar_F';
}

static function X2CharacterTemplate CreateTemplate_LostAndAbandonedElena()
{
	local X2CharacterTemplate CharTemplate;

	CharTemplate = CreateSoldierTemplate('LostAndAbandonedElena');

	CharTemplate.bIsResistanceHero = true;
	CharTemplate.DefaultSoldierClass = 'Reaper';
	CharTemplate.DefaultLoadout = 'SquaddieReaper';

	CharTemplate.CharacterGeneratorClass = class'XGCharacterGenerator_Reaper';
	CharTemplate.GetPawnNameFn = GetReaperPawnName;

	CharTemplate.bForceAppearance = true;
	CharTemplate.ForceAppearance.iGender = eGender_Female;
	CharTemplate.ForceAppearance.iRace = 0;
	CharTemplate.ForceAppearance.iArmorTint = 5;
	CharTemplate.ForceAppearance.iSkinColor = 4;
	CharTemplate.ForceAppearance.iArmorTintSecondary = 87;
	CharTemplate.ForceAppearance.iAttitude = 2;
	CharTemplate.ForceAppearance.iWeaponTint = 50;
	CharTemplate.ForceAppearance.nmLeftArm = 'Reaper_Arms_Left_A_F';
	CharTemplate.ForceAppearance.nmLeftForearm = 'Reaper_Forearm_Left_Bare_F';
	CharTemplate.ForceAppearance.nmRightArm = 'Reaper_Arms_Right_A_F';
	CharTemplate.ForceAppearance.nmRightForearm = 'Reaper_Forearm_Right_Bare_F';
	CharTemplate.ForceAppearance.nmFlag = 'Country_Reaper';
	CharTemplate.ForceAppearance.nmHead = 'ReaperFem_A'; 
	CharTemplate.ForceAppearance.nmHaircut = 'FemHairShort';
	CharTemplate.ForceAppearance.nmHelmet = 'Reaper_Hood_B_F';
	CharTemplate.ForceAppearance.nmLegs = 'Reaper_Std_A_F';
	CharTemplate.ForceAppearance.nmPawn = 'XCom_Soldier_Reaper_F';
	CharTemplate.ForceAppearance.nmTorso = 'PltReaper_Std_A_F';
	CharTemplate.ForceAppearance.nmTorsoDeco = 'Reaper_TorsoDeco_C_F';
	CharTemplate.ForceAppearance.nmShins = 'PltReaper_Shins_A_F';
	CharTemplate.ForceAppearance.nmThighs = 'Reaper_Thighs_A_F';
	CharTemplate.ForceAppearance.nmVoice = 'ReaperFemaleVoice1_Localized';
	CharTemplate.ForceAppearance.nmWeaponPattern = 'Pat_Nothing';

	// Don't allow this mission specific template to bleed out
	CharTemplate.bCanBeCriticallyWounded = false;

	return CharTemplate;
}

static function X2CharacterTemplate CreateTemplate_LostAndAbandonedMox()
{
	local X2CharacterTemplate CharTemplate;

	CharTemplate = CreateSoldierTemplate('LostAndAbandonedMox');

	CharTemplate.bIsResistanceHero = true;
	CharTemplate.DefaultSoldierClass = 'Skirmisher';
	CharTemplate.DefaultLoadout = 'SquaddieSkirmisher';

	CharTemplate.CharacterGeneratorClass = class'XGCharacterGenerator_Skirmisher';
	CharTemplate.GetPawnNameFn = GetSkirmisherPawnName;

	CharTemplate.bForceAppearance = true;
	CharTemplate.ForceAppearance.iGender = eGender_Male;
	CharTemplate.ForceAppearance.iRace = 0;
	CharTemplate.ForceAppearance.iArmorTint = 91;
	CharTemplate.ForceAppearance.iSkinColor = 4;
	CharTemplate.ForceAppearance.iArmorTintSecondary = 79;
	CharTemplate.ForceAppearance.iAttitude = 2;
	CharTemplate.ForceAppearance.iWeaponTint = 8;
	CharTemplate.ForceAppearance.iHairColor = 8;
	CharTemplate.ForceAppearance.nmLeftArm = 'Skirmisher_Arms_Left_A_T1_M';
	CharTemplate.ForceAppearance.nmLeftArmDeco = 'Skirmisher_Shoulder_Left_E_M';
	CharTemplate.ForceAppearance.nmLeftForearm = 'Skirmisher_Forearm_Left_B_M';
	CharTemplate.ForceAppearance.nmRightArm = 'Skirmisher_Arms_Right_A_T1_M';
	CharTemplate.ForceAppearance.nmRightArmDeco = 'Skirmisher_Shoulder_Right_D_M';
	CharTemplate.ForceAppearance.nmRightForearm = 'Skirmisher_Forearm_Right_A_M';
	CharTemplate.ForceAppearance.nmFlag = 'Country_Skirmisher';
	CharTemplate.ForceAppearance.nmHead = 'SkirmisherMale_A_Cauc';
	CharTemplate.ForceAppearance.nmHaircut = 'MaleHair_Blank';
	CharTemplate.ForceAppearance.nmHelmet = 'Skirmisher_Helmet_A_M';
	CharTemplate.ForceAppearance.nmLegs = 'Skirmisher_Legs_B_M';
	CharTemplate.ForceAppearance.nmPawn = 'XCom_Soldier_Skirmisher_M';
	CharTemplate.ForceAppearance.nmTorso = 'CnvSkirmisher_Std_A_M';
	CharTemplate.ForceAppearance.nmTorsoDeco = 'Skirmisher_TorsoDeco_C_M';
	CharTemplate.ForceAppearance.nmThighs = 'CnvSkirmisher_Thighs_A_M';
	CharTemplate.ForceAppearance.nmVoice = 'SkirmisherMaleVoice1_Localized';
	CharTemplate.ForceAppearance.nmWeaponPattern = 'Pat_Nothing';
	CharTemplate.ForceAppearance.nmScars = 'Skirmisher_Scar_A';

	// Don't allow this mission specific template to bleed out
	CharTemplate.bCanBeCriticallyWounded = false;

	return CharTemplate;
}

static function X2CharacterTemplate CreateChosenAssassinTemplate(name TemplateName)
{
	local X2CharacterTemplate CharTemplate;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, TemplateName);
	CharTemplate.CharacterGroupName = 'ChosenAssassin';
	CharTemplate.BehaviorClass = class'XGAIBehavior';
	
	CharTemplate.strMatineePackages.AddItem("CIN_XP_ChosenAssassin");
	CharTemplate.RevealMatineePrefix = "CIN_ChosenAssassin";
	CharTemplate.bRevealMatineeAlwaysValid = true;
	CharTemplate.bDisableRevealLookAtCamera = false;
	CharTemplate.bNeverShowFirstSighted = true;

	CharTemplate.UnitSize = 1;
	CharTemplate.InitiativePriority = 100;

	CharTemplate.KillContribution = 2.0;

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
	CharTemplate.bSetGenderAlways = true;
	CharTemplate.bCanTakeCover = true;

	CharTemplate.bIsAlien = true;
	CharTemplate.bIsAdvent = false;
	CharTemplate.bIsCivilian = false;
	CharTemplate.bIsPsionic = false;
	CharTemplate.bIsRobotic = false;
	CharTemplate.bIsSoldier = false;
	CharTemplate.bIsChosen = true;

	CharTemplate.bCanBeTerrorist = false;
	CharTemplate.bCanBeCriticallyWounded = false;
	CharTemplate.bIsAfraidOfFire = true;
	CharTemplate.bHideInShadowChamber = true;

	CharTemplate.Abilities.AddItem('ChosenImmunities');
	CharTemplate.Abilities.AddItem('ChosenKidnapMove');
	CharTemplate.Abilities.AddItem('ChosenExtractKnowledgeMove');
	CharTemplate.Abilities.AddItem('ChosenActivation');
	CharTemplate.Abilities.AddItem('ChosenKeen');

	CharTemplate.Abilities.AddItem('VanishingWind');
	CharTemplate.Abilities.AddItem('BendingReed');
	CharTemplate.Abilities.AddItem('HarborWave');
	CharTemplate.Abilities.AddItem('DarkEventAbility_Barrier');

	CharTemplate.ImmuneTypes.AddItem('Mental');

	CharTemplate.SpeakerPortrait = "img:///UILibrary_XPACK_Common.Head_Chosen_Assassin";

	//CharTemplate.SightedNarrativeMoments.AddItem(XComNarrativeMoment'X2NarrativeMoments.TACTICAL.AlienSitings.T_Central_AlienSightings_AdvCaptainM1');

	CharTemplate.strHackIconImage = "UILibrary_Common.TargetIcons.Hack_captain_icon";
	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_Chosen;

	CharTemplate.strScamperBT = "ScamperRoot_ChosenAssassin";
	CharTemplate.ScamperActionPoints = 2; // Assassin must use 2 action points to be able to vanish and scamper.

	CharTemplate.AcquiredPhobiaTemplate = 'FearOfChosen';

	return CharTemplate;
}

static function X2CharacterTemplate CreateTemplate_ChosenAssassin()
{
	local X2CharacterTemplate CharTemplate;

	CharTemplate = CreateChosenAssassinTemplate('ChosenAssassin');
	CharTemplate.DefaultLoadout = 'ChosenAssassinM1_Loadout';
	CharTemplate.RevealMatineePrefix = "CIN_ChosenAssassinM1";
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_ChosenAssassin.ARC_GameUnit_ChosenAssassin");
//BEGIN AUTOGENERATED CODE: Template Overrides 'ChosenAssassin'
	CharTemplate.bCanUse_eTraversal_ClimbLadder = false;
	CharTemplate.bCanUse_eTraversal_JumpUp = true;
	CharTemplate.bDisableRevealForceVisible = true;
//END AUTOGENERATED CODE: Template Overrides 'ChosenAssassin'

	return CharTemplate;
}

static function X2CharacterTemplate CreateTemplate_ChosenAssassinM2()
{
	local X2CharacterTemplate CharTemplate;

	CharTemplate = CreateChosenAssassinTemplate('ChosenAssassinM2');
	CharTemplate.DefaultLoadout = 'ChosenAssassinM2_Loadout';
	CharTemplate.RevealMatineePrefix = "CIN_ChosenAssassinM2";
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_ChosenAssassin.ARC_GameUnit_ChosenAssassin_M2");
//BEGIN AUTOGENERATED CODE: Template Overrides 'ChosenAssassinM2'
	CharTemplate.bCanUse_eTraversal_ClimbLadder = false;
	CharTemplate.bCanUse_eTraversal_JumpUp = true;
	CharTemplate.bDisableRevealForceVisible = true;
//END AUTOGENERATED CODE: Template Overrides 'ChosenAssassinM2'
	
	return CharTemplate;
}

static function X2CharacterTemplate CreateTemplate_ChosenAssassinM3()
{
	local X2CharacterTemplate CharTemplate;

	CharTemplate = CreateChosenAssassinTemplate('ChosenAssassinM3');
	CharTemplate.DefaultLoadout = 'ChosenAssassinM3_Loadout';
	CharTemplate.RevealMatineePrefix = "CIN_ChosenAssassinM3";
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_ChosenAssassin.ARC_GameUnit_ChosenAssassin_M3");
//BEGIN AUTOGENERATED CODE: Template Overrides 'ChosenAssassinM3'
	CharTemplate.bCanUse_eTraversal_ClimbLadder = false;
	CharTemplate.bCanUse_eTraversal_JumpUp = true;
	CharTemplate.bDisableRevealForceVisible = true;
//END AUTOGENERATED CODE: Template Overrides 'ChosenAssassinM3'
	
	return CharTemplate;
}

static function X2CharacterTemplate CreateTemplate_ChosenAssassinM4()
{
	local X2CharacterTemplate CharTemplate;

	CharTemplate = CreateChosenAssassinTemplate('ChosenAssassinM4');
	CharTemplate.DefaultLoadout = 'ChosenAssassinM4_Loadout';
	CharTemplate.RevealMatineePrefix = "CIN_ChosenAssassinM4";
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_ChosenAssassin.ARC_GameUnit_ChosenAssassin_M4");
//BEGIN AUTOGENERATED CODE: Template Overrides 'ChosenAssassinM4'
	CharTemplate.bCanUse_eTraversal_ClimbLadder = false;
	CharTemplate.bCanUse_eTraversal_JumpUp = true;
	CharTemplate.bDisableRevealForceVisible = true;
//END AUTOGENERATED CODE: Template Overrides 'ChosenAssassinM4'
	
	return CharTemplate;
}

static function X2CharacterTemplate CreateChosenWarlockTemplate(name TemplateName)
{
	local X2CharacterTemplate CharTemplate;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, TemplateName);
	CharTemplate.CharacterGroupName = 'ChosenWarlock';
	CharTemplate.BehaviorClass = class'XGAIBehavior';

	CharTemplate.strMatineePackages.AddItem("CIN_XP_ChosenAssassin");
	CharTemplate.strMatineePackages.AddItem("CIN_XP_ChosenWarlock");
	CharTemplate.strTargetingMatineePrefix = "CIN_XP_ChosenWarlock";
	CharTemplate.RevealMatineePrefix = "CIN_ChosenWarlock";
	CharTemplate.bRevealMatineeAlwaysValid = true;
	CharTemplate.bDisableRevealLookAtCamera = false;
	CharTemplate.bNeverShowFirstSighted = true;

	CharTemplate.UnitSize = 1;
	CharTemplate.InitiativePriority = 100;

	CharTemplate.KillContribution = 2.0;

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
	CharTemplate.bSetGenderAlways = true;
	CharTemplate.bCanTakeCover = true;

	CharTemplate.bIsAlien = true;
	CharTemplate.bIsAdvent = false;
	CharTemplate.bIsCivilian = false;
	CharTemplate.bIsPsionic = false;
	CharTemplate.bIsRobotic = false;
	CharTemplate.bIsSoldier = false;
	CharTemplate.bIsChosen = true;

	CharTemplate.bCanBeTerrorist = false;
	CharTemplate.bCanBeCriticallyWounded = false;
	CharTemplate.bIsAfraidOfFire = true;
	CharTemplate.bHideInShadowChamber = true;
	
	CharTemplate.Abilities.AddItem('ChosenImmunities');
	CharTemplate.Abilities.AddItem('ChosenKidnapMove');
	CharTemplate.Abilities.AddItem('ChosenExtractKnowledgeMove');
	CharTemplate.Abilities.AddItem('ChosenActivation');
	CharTemplate.Abilities.AddItem('ChosenKeen');
	CharTemplate.Abilities.AddItem('DarkEventAbility_Barrier');

	CharTemplate.ImmuneTypes.AddItem('Mental');
	
	CharTemplate.SpeakerPortrait = "img:///UILibrary_XPACK_Common.Head_Chosen_Warlock";

	//CharTemplate.SightedNarrativeMoments.AddItem(XComNarrativeMoment'X2NarrativeMoments.TACTICAL.AlienSitings.T_Central_AlienSightings_AdvCaptainM1');

	CharTemplate.strHackIconImage = "UILibrary_Common.TargetIcons.Hack_captain_icon";
	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_Chosen;

	CharTemplate.AcquiredPhobiaTemplate = 'FearOfChosen';

	return CharTemplate;
}

static function X2CharacterTemplate CreateTemplate_ChosenWarlock()
{
	local X2CharacterTemplate CharTemplate;

	CharTemplate = CreateChosenWarlockTemplate('ChosenWarlock');
	CharTemplate.DefaultLoadout = 'ChosenWarlockM1_Loadout';
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_ChosenWarlock.ARC_GameUnit_ChosenWarlock");
	
	CharTemplate.Abilities.AddItem('WarlockLevelM1');
//BEGIN AUTOGENERATED CODE: Template Overrides 'ChosenWarlock'
	CharTemplate.bCanUse_eTraversal_ClimbLadder = false;
	CharTemplate.bCanUse_eTraversal_JumpUp = true;
	CharTemplate.bDisableRevealForceVisible = true;
//END AUTOGENERATED CODE: Template Overrides 'ChosenWarlock'

	return CharTemplate;
}

static function X2CharacterTemplate CreateTemplate_ChosenWarlockM2()
{
	local X2CharacterTemplate CharTemplate;

	CharTemplate = CreateChosenWarlockTemplate('ChosenWarlockM2');
	CharTemplate.DefaultLoadout = 'ChosenWarlockM2_Loadout';
//BEGIN AUTOGENERATED CODE: Template Overrides 'ChosenWarlockM2'
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_ChosenWarlock.ARC_GameUnit_ChosenWarlockM2");
	CharTemplate.bCanUse_eTraversal_ClimbLadder = false;
	CharTemplate.bCanUse_eTraversal_JumpUp = true;
	CharTemplate.bDisableRevealForceVisible = true;
//END AUTOGENERATED CODE: Template Overrides 'ChosenWarlockM2'
	
	CharTemplate.Abilities.AddItem('WarlockLevelM2');

	return CharTemplate;
}

static function X2CharacterTemplate CreateTemplate_ChosenWarlockM3()
{
	local X2CharacterTemplate CharTemplate;

	CharTemplate = CreateChosenWarlockTemplate('ChosenWarlockM3');
	CharTemplate.DefaultLoadout = 'ChosenWarlockM3_Loadout';
//BEGIN AUTOGENERATED CODE: Template Overrides 'ChosenWarlockM3'
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_ChosenWarlock.ARC_GameUnit_ChosenWarlockM3");
	CharTemplate.bCanUse_eTraversal_ClimbLadder = false;
	CharTemplate.bCanUse_eTraversal_JumpUp = true;
	CharTemplate.bDisableRevealForceVisible = true;
//END AUTOGENERATED CODE: Template Overrides 'ChosenWarlockM3'
	
	CharTemplate.Abilities.AddItem('WarlockLevelM3');

	return CharTemplate;
}

static function X2CharacterTemplate CreateTemplate_ChosenWarlockM4()
{
	local X2CharacterTemplate CharTemplate;

	CharTemplate = CreateChosenWarlockTemplate('ChosenWarlockM4');
	CharTemplate.DefaultLoadout = 'ChosenWarlockM4_Loadout';
//BEGIN AUTOGENERATED CODE: Template Overrides 'ChosenWarlockM4'
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_ChosenWarlock.ARC_GameUnit_ChosenWarlockM4");
	CharTemplate.bCanUse_eTraversal_ClimbLadder = false;
	CharTemplate.bCanUse_eTraversal_JumpUp = true;
	CharTemplate.bDisableRevealForceVisible = true;
//END AUTOGENERATED CODE: Template Overrides 'ChosenWarlockM4'
	
	CharTemplate.Abilities.AddItem('WarlockLevelM4');
	CharTemplate.Abilities.AddItem('WarlockFocusM4');

	return CharTemplate;
}

static function X2CharacterTemplate CreateChosenSniperTemplate(name TemplateName)
{
	local X2CharacterTemplate CharTemplate;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, TemplateName);
	CharTemplate.CharacterGroupName = 'ChosenSniper';
	CharTemplate.BehaviorClass = class'XGAIBehavior';

	CharTemplate.strMatineePackages.AddItem("CIN_XP_ChosenAssassin");
	CharTemplate.strMatineePackages.AddItem("CIN_XP_ChosenHunter");
	CharTemplate.RevealMatineePrefix = "CIN_ChosenHunter";
	CharTemplate.bRevealMatineeAlwaysValid = true;
	CharTemplate.bDisableRevealLookAtCamera = false;
	CharTemplate.bNeverShowFirstSighted = true;

	CharTemplate.UnitSize = 1;
	CharTemplate.InitiativePriority = 100;

	CharTemplate.KillContribution = 2.0;

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
	CharTemplate.bSetGenderAlways = true;
	CharTemplate.bCanTakeCover = true;

	CharTemplate.bIsAlien = true;
	CharTemplate.bIsAdvent = false;
	CharTemplate.bIsCivilian = false;
	CharTemplate.bIsPsionic = false;
	CharTemplate.bIsRobotic = false;
	CharTemplate.bIsSoldier = false;
	CharTemplate.bIsChosen = true;

	CharTemplate.bCanBeTerrorist = false;
	CharTemplate.bCanBeCriticallyWounded = false;
	CharTemplate.bIsAfraidOfFire = true;
	CharTemplate.bHideInShadowChamber = true;

	CharTemplate.ImmuneTypes.AddItem('Mental');
	
	CharTemplate.Abilities.AddItem('ChosenImmunities');
	CharTemplate.Abilities.AddItem('ChosenKidnapMove');
	CharTemplate.Abilities.AddItem('ChosenExtractKnowledgeMove');
	CharTemplate.Abilities.AddItem('ChosenActivation');
	CharTemplate.Abilities.AddItem('ChosenKeen');

	CharTemplate.Abilities.AddItem('HunterGrapple');
	CharTemplate.Abilities.AddItem('Farsight');
	CharTemplate.Abilities.AddItem('DarkEventAbility_Barrier');
	
	CharTemplate.SpeakerPortrait = "img:///UILibrary_XPACK_Common.Head_Chosen_Hunter";

	//CharTemplate.SightedNarrativeMoments.AddItem(XComNarrativeMoment'X2NarrativeMoments.TACTICAL.AlienSitings.T_Central_AlienSightings_AdvCaptainM1');
	
	CharTemplate.strHackIconImage = "UILibrary_Common.TargetIcons.Hack_captain_icon";
	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_Chosen;
	CharTemplate.strScamperBT = "ScamperRoot_ChosenSniper";

	CharTemplate.AcquiredPhobiaTemplate = 'FearOfChosen';

	return CharTemplate;
}

static function X2CharacterTemplate CreateTemplate_ChosenSniper()
{
	local X2CharacterTemplate CharTemplate;

	CharTemplate = CreateChosenSniperTemplate('ChosenSniper');
	CharTemplate.DefaultLoadout = 'ChosenSniperM1_Loadout';
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_ChosenHunter.ARC_GameUnit_ChosenHunter");
//BEGIN AUTOGENERATED CODE: Template Overrides 'ChosenSniper'
	CharTemplate.bCanUse_eTraversal_ClimbLadder = false;
	CharTemplate.bCanUse_eTraversal_JumpUp = true;
	CharTemplate.bDisableRevealForceVisible = true;
//END AUTOGENERATED CODE: Template Overrides 'ChosenSniper'
	
	return CharTemplate;
}

static function X2CharacterTemplate CreateTemplate_ChosenSniperM2()
{
	local X2CharacterTemplate CharTemplate;

	CharTemplate = CreateChosenSniperTemplate('ChosenSniperM2');
	CharTemplate.DefaultLoadout = 'ChosenSniperM2_Loadout';
//BEGIN AUTOGENERATED CODE: Template Overrides 'ChosenSniperM2'
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_ChosenHunter.ARC_GameUnit_ChosenHunter_M2");
	CharTemplate.bCanUse_eTraversal_ClimbLadder = false;
	CharTemplate.bCanUse_eTraversal_JumpUp = true;
	CharTemplate.bDisableRevealForceVisible = true;
//END AUTOGENERATED CODE: Template Overrides 'ChosenSniperM2'
	
	return CharTemplate;
}

static function X2CharacterTemplate CreateTemplate_ChosenSniperM3()
{
	local X2CharacterTemplate CharTemplate;

	CharTemplate = CreateChosenSniperTemplate('ChosenSniperM3');
	CharTemplate.DefaultLoadout = 'ChosenSniperM3_Loadout';
//BEGIN AUTOGENERATED CODE: Template Overrides 'ChosenSniperM3'
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_ChosenHunter.ARC_GameUnit_ChosenHunter_M3");
	CharTemplate.bCanUse_eTraversal_ClimbLadder = false;
	CharTemplate.bCanUse_eTraversal_JumpUp = true;
	CharTemplate.bDisableRevealForceVisible = true;
//END AUTOGENERATED CODE: Template Overrides 'ChosenSniperM3'
	
	return CharTemplate;
}

static function X2CharacterTemplate CreateTemplate_ChosenSniperM4()
{
	local X2CharacterTemplate CharTemplate;

	CharTemplate = CreateChosenSniperTemplate('ChosenSniperM4');
	CharTemplate.DefaultLoadout = 'ChosenSniperM4_Loadout';
//BEGIN AUTOGENERATED CODE: Template Overrides 'ChosenSniperM4'
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_ChosenHunter.ARC_GameUnit_ChosenHunter_M4");
	CharTemplate.bCanUse_eTraversal_ClimbLadder = false;
	CharTemplate.bCanUse_eTraversal_JumpUp = true;
	CharTemplate.bDisableRevealForceVisible = true;
//END AUTOGENERATED CODE: Template Overrides 'ChosenSniperM4'
	
	return CharTemplate;
}


// These are intended to be temporary character definitions
static function X2CharacterTemplate CreateTemplate_AdvCounterOpM1()
{
	local X2CharacterTemplate CharTemplate;
	local LootReference Loot;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, 'AdvCounterOpM1');
	CharTemplate.CharacterGroupName = 'AdventCounterOp';
	CharTemplate.DefaultLoadout='AdvCounterOpM1_Loadout';
	CharTemplate.BehaviorClass=class'XGAIBehavior';
	CharTemplate.strPawnArchetypes.AddItem("CovertEscape_TempAssets.ARC_GameUnit_AdvCounterOpM3_M");
	CharTemplate.strPawnArchetypes.AddItem("CovertEscape_TempAssets.ARC_GameUnit_AdvCounterOpM3_F");
	Loot.ForceLevel=0;
	Loot.LootTableName='AdvStunLancerM1_BaseLoot';
	CharTemplate.Loot.LootReferences.AddItem(Loot);

	// Timed Loot
	Loot.ForceLevel = 0;
	Loot.LootTableName = 'AdvStunLancerM1_TimedLoot';
	CharTemplate.TimedLoot.LootReferences.AddItem(Loot);
	Loot.LootTableName = 'AdvStunLancerM1_VultureLoot';
	CharTemplate.VultureLoot.LootReferences.AddItem(Loot);

	CharTemplate.strMatineePackages.AddItem("CIN_Advent");
	CharTemplate.RevealMatineePrefix = "CIN_Advent_StunLancer";
	CharTemplate.GetRevealMatineePrefixFn = GetAdventMatineePrefix;

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
	CharTemplate.bSetGenderAlways = true;
	CharTemplate.bCanTakeCover = true;

	CharTemplate.bIsAlien = false;
	CharTemplate.bIsAdvent = true;
	CharTemplate.bIsCivilian = false;
	CharTemplate.bIsPsionic = false;
	CharTemplate.bIsRobotic = false;
	CharTemplate.bIsSoldier = false;

	CharTemplate.bCanBeTerrorist = false;
	CharTemplate.bCanBeCriticallyWounded = false;
	CharTemplate.bIsAfraidOfFire = true;

	// CharTemplate.SightedNarrativeMoments.AddItem(XComNarrativeMoment'X2NarrativeMoments.TACTICAL.AlienSitings.T_Central_AlienSightings_AdvStunLancerM1');

	// CharTemplate.AddTemplateAvailablility(CharTemplate.BITFIELD_GAMEAREA_Multiplayer); // Allow in MP!
	CharTemplate.MPPointValue = CharTemplate.XpKillscore * 10;

	CharTemplate.strHackIconImage = "UILibrary_Common.TargetIcons.Hack_captain_icon";
	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_Advent;

	return CharTemplate;
}

static function X2CharacterTemplate CreateTemplate_AdvCounterOpM2()
{
	local X2CharacterTemplate CharTemplate;
	local LootReference Loot;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, 'AdvCounterOpM2');
	CharTemplate.CharacterGroupName = 'AdventCounterOp';
	CharTemplate.DefaultLoadout='AdvCounterOpM2_Loadout';
	CharTemplate.BehaviorClass=class'XGAIBehavior';
	CharTemplate.strPawnArchetypes.AddItem("CovertEscape_TempAssets.ARC_GameUnit_AdvCounterOpM3_M");
	CharTemplate.strPawnArchetypes.AddItem("CovertEscape_TempAssets.ARC_GameUnit_AdvCounterOpM3_F");
	Loot.ForceLevel=0;
	Loot.LootTableName='AdvStunLancerM2_BaseLoot';
	CharTemplate.Loot.LootReferences.AddItem(Loot);

	// Timed Loot
	Loot.ForceLevel = 0;
	Loot.LootTableName = 'AdvStunLancerM2_TimedLoot';
	CharTemplate.TimedLoot.LootReferences.AddItem(Loot);
	Loot.LootTableName = 'AdvStunLancerM2_VultureLoot';
	CharTemplate.VultureLoot.LootReferences.AddItem(Loot);

	CharTemplate.strMatineePackages.AddItem("CIN_Advent");
	CharTemplate.RevealMatineePrefix = "CIN_Advent_StunLancer";
	CharTemplate.GetRevealMatineePrefixFn = GetAdventMatineePrefix;

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
	CharTemplate.bSetGenderAlways = true;
	CharTemplate.bCanTakeCover = true;

	CharTemplate.bIsAlien = false;
	CharTemplate.bIsAdvent = true;
	CharTemplate.bIsCivilian = false;
	CharTemplate.bIsPsionic = false;
	CharTemplate.bIsRobotic = false;
	CharTemplate.bIsSoldier = false;

	CharTemplate.bCanBeTerrorist = false;
	CharTemplate.bCanBeCriticallyWounded = false;
	CharTemplate.bIsAfraidOfFire = true;

	// CharTemplate.SightedNarrativeMoments.AddItem(XComNarrativeMoment'X2NarrativeMoments.TACTICAL.AlienSitings.T_Central_AlienSightings_AdvStunLancerM2');

	// CharTemplate.AddTemplateAvailablility(CharTemplate.BITFIELD_GAMEAREA_Multiplayer); // Allow in MP!
	CharTemplate.MPPointValue = CharTemplate.XpKillscore * 10;

	CharTemplate.strHackIconImage = "UILibrary_Common.TargetIcons.Hack_captain_icon";
	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_Advent;

	return CharTemplate;
}

static function X2CharacterTemplate CreateTemplate_AdvCounterOpM3()
{
	local X2CharacterTemplate CharTemplate;
	local LootReference Loot;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, 'AdvCounterOpM3');
	CharTemplate.CharacterGroupName = 'AdventCounterOp';
	CharTemplate.DefaultLoadout='AdvCounterOpM3_Loadout';
	CharTemplate.BehaviorClass=class'XGAIBehavior';
	CharTemplate.strPawnArchetypes.AddItem("CovertEscape_TempAssets.ARC_GameUnit_AdvCounterOpM3_M");
	CharTemplate.strPawnArchetypes.AddItem("CovertEscape_TempAssets.ARC_GameUnit_AdvCounterOpM3_F");
	Loot.ForceLevel=0;
	Loot.LootTableName='AdvStunLancerM3_BaseLoot';
	CharTemplate.Loot.LootReferences.AddItem(Loot);

	// Timed Loot
	Loot.ForceLevel = 0;
	Loot.LootTableName = 'AdvStunLancerM3_TimedLoot';
	CharTemplate.TimedLoot.LootReferences.AddItem(Loot);
	Loot.LootTableName = 'AdvStunLancerM3_VultureLoot';
	CharTemplate.VultureLoot.LootReferences.AddItem(Loot);

	CharTemplate.strMatineePackages.AddItem("CIN_Advent");
	CharTemplate.RevealMatineePrefix = "CIN_Advent_StunLancer";
	CharTemplate.GetRevealMatineePrefixFn = GetAdventMatineePrefix;

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
	CharTemplate.bSetGenderAlways = true;
	CharTemplate.bCanTakeCover = true;

	CharTemplate.bIsAlien = false;
	CharTemplate.bIsAdvent = true;
	CharTemplate.bIsCivilian = false;
	CharTemplate.bIsPsionic = false;
	CharTemplate.bIsRobotic = false;
	CharTemplate.bIsSoldier = false;

	CharTemplate.bCanBeTerrorist = false;
	CharTemplate.bCanBeCriticallyWounded = false;
	CharTemplate.bIsAfraidOfFire = true;

	// CharTemplate.SightedNarrativeMoments.AddItem(XComNarrativeMoment'X2NarrativeMoments.TACTICAL.T_Central_AlienSightings_AdvStunLancerM3');

	// CharTemplate.AddTemplateAvailablility(CharTemplate.BITFIELD_GAMEAREA_Multiplayer); // Allow in MP!
	CharTemplate.MPPointValue = CharTemplate.XpKillscore * 10;

	CharTemplate.strHackIconImage = "UILibrary_Common.TargetIcons.Hack_captain_icon";
	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_Advent;

	return CharTemplate;
}

static function X2CharacterTemplate CreateTemplate_AdvCounterOpCommanderM1()
{
	local X2CharacterTemplate CharTemplate;
	local LootReference Loot;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, 'AdvCounterOpCommanderM1');
	CharTemplate.CharacterGroupName = 'AdventCaptain';
	CharTemplate.DefaultLoadout='AdvCaptainM1_Loadout';
	CharTemplate.BehaviorClass=class'XGAIBehavior';
	CharTemplate.strPawnArchetypes.AddItem("CovertEscape_TempAssets.ARC_GameUnit_AdvCounterOpCommander_M");
	CharTemplate.strPawnArchetypes.AddItem("CovertEscape_TempAssets.ARC_GameUnit_AdvCounterOpCommander_F");
	Loot.ForceLevel = 0;
	Loot.LootTableName='AdvCaptainM1_BaseLoot';
	CharTemplate.Loot.LootReferences.AddItem(Loot);

	// Timed Loot
	Loot.ForceLevel = 0;
	Loot.LootTableName = 'AdvCaptainM1_TimedLoot';
	CharTemplate.TimedLoot.LootReferences.AddItem(Loot);
	Loot.LootTableName = 'AdvCaptainM1_VultureLoot';
	CharTemplate.VultureLoot.LootReferences.AddItem(Loot);

	CharTemplate.strMatineePackages.AddItem("CIN_Advent");
	CharTemplate.RevealMatineePrefix = "CIN_Advent_Captain";
	CharTemplate.GetRevealMatineePrefixFn = GetAdventMatineePrefix;

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
	CharTemplate.bSetGenderAlways = true;
	CharTemplate.bCanTakeCover = true;

	CharTemplate.bIsAlien = false;
	CharTemplate.bIsAdvent = true;
	CharTemplate.bIsCivilian = false;
	CharTemplate.bIsPsionic = false;
	CharTemplate.bIsRobotic = false;
	CharTemplate.bIsSoldier = false;

	CharTemplate.bCanBeTerrorist = false;
	CharTemplate.bCanBeCriticallyWounded = false;
	CharTemplate.bIsAfraidOfFire = true;

	CharTemplate.Abilities.AddItem('MarkTarget');

	// CharTemplate.SightedNarrativeMoments.AddItem(XComNarrativeMoment'X2NarrativeMoments.TACTICAL.AlienSitings.T_Central_AlienSightings_AdvCaptainM1');
	// CharTemplate.SightedEvents.AddItem('AdventCaptainSighted');

	// CharTemplate.AddTemplateAvailablility(CharTemplate.BITFIELD_GAMEAREA_Multiplayer); // Allow in MP!
	CharTemplate.MPPointValue = CharTemplate.XpKillscore * 10;

	CharTemplate.strHackIconImage = "UILibrary_Common.TargetIcons.Hack_captain_icon";
	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_Advent;

	return CharTemplate;
}

static function X2CharacterTemplate CreateTemplate_AdvCounterOpCommanderM2()
{
	local X2CharacterTemplate CharTemplate;
	local LootReference Loot;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, 'AdvCounterOpCommanderM2');
	CharTemplate.CharacterGroupName = 'AdventCaptain';
	CharTemplate.DefaultLoadout='AdvCaptainM2_Loadout';
	CharTemplate.BehaviorClass=class'XGAIBehavior';
	CharTemplate.strPawnArchetypes.AddItem("CovertEscape_TempAssets.ARC_GameUnit_AdvCounterOpCommander_M");
	CharTemplate.strPawnArchetypes.AddItem("CovertEscape_TempAssets.ARC_GameUnit_AdvCounterOpCommander_F");
	Loot.ForceLevel=0;
	Loot.LootTableName='AdvCaptainM2_BaseLoot';
	CharTemplate.Loot.LootReferences.AddItem(Loot);

	// Timed Loot
	Loot.ForceLevel = 0;
	Loot.LootTableName = 'AdvCaptainM2_TimedLoot';
	CharTemplate.TimedLoot.LootReferences.AddItem(Loot);
	Loot.LootTableName = 'AdvCaptainM2_VultureLoot';
	CharTemplate.VultureLoot.LootReferences.AddItem(Loot);

	CharTemplate.strMatineePackages.AddItem("CIN_Advent");
	CharTemplate.RevealMatineePrefix = "CIN_Advent_Captain";
	CharTemplate.GetRevealMatineePrefixFn = GetAdventMatineePrefix;

	// CharTemplate.SightedNarrativeMoments.AddItem(XComNarrativeMoment'X2NarrativeMoments.TACTICAL.AlienSitings.T_Central_AlienSightings_AdvCaptainM2');
	// CharTemplate.SightedEvents.AddItem('AdventCaptainSighted');

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
	CharTemplate.bSetGenderAlways = true;
	CharTemplate.bCanTakeCover = true;
	CharTemplate.bIsAlien = false;
	CharTemplate.bIsAdvent = true;
	CharTemplate.bIsCivilian = false;
	CharTemplate.bIsPsionic = false;
	CharTemplate.bIsRobotic = false;
	CharTemplate.bIsSoldier = false;

	CharTemplate.bCanBeTerrorist = false;
	CharTemplate.bCanBeCriticallyWounded = false;
	CharTemplate.bIsAfraidOfFire = true;

	CharTemplate.Abilities.AddItem('MarkTarget');

	// CharTemplate.AddTemplateAvailablility(CharTemplate.BITFIELD_GAMEAREA_Multiplayer); // Allow in MP!
	CharTemplate.MPPointValue = CharTemplate.XpKillscore * 10;

	CharTemplate.strHackIconImage = "UILibrary_Common.TargetIcons.Hack_captain_icon";
	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_Advent;

	return CharTemplate;
}

static function X2CharacterTemplate CreateTemplate_AdvCounterOpCommanderM3()
{
	local X2CharacterTemplate CharTemplate;
	local LootReference Loot;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, 'AdvCounterOpCommanderM3');
	CharTemplate.CharacterGroupName = 'AdventCaptain';
	CharTemplate.DefaultLoadout='AdvCaptainM3_Loadout';
	CharTemplate.BehaviorClass=class'XGAIBehavior';
	CharTemplate.strPawnArchetypes.AddItem("CovertEscape_TempAssets.ARC_GameUnit_AdvCounterOpCommander_M");
	CharTemplate.strPawnArchetypes.AddItem("CovertEscape_TempAssets.ARC_GameUnit_AdvCounterOpCommander_F");
	Loot.ForceLevel=0;
	Loot.LootTableName='AdvCaptainM3_BaseLoot';
	CharTemplate.Loot.LootReferences.AddItem(Loot);

	// Timed Loot
	Loot.ForceLevel = 0;
	Loot.LootTableName = 'AdvCaptainM3_TimedLoot';
	CharTemplate.TimedLoot.LootReferences.AddItem(Loot);
	Loot.LootTableName = 'AdvCaptainM3_VultureLoot';
	CharTemplate.VultureLoot.LootReferences.AddItem(Loot);

	CharTemplate.strMatineePackages.AddItem("CIN_Advent");
	CharTemplate.RevealMatineePrefix = "CIN_Advent_Captain";
	CharTemplate.GetRevealMatineePrefixFn = GetAdventMatineePrefix;

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
	CharTemplate.bSetGenderAlways = true;
	CharTemplate.bCanTakeCover = true;

	CharTemplate.bIsAlien = false;
	CharTemplate.bIsAdvent = true;
	CharTemplate.bIsCivilian = false;
	CharTemplate.bIsPsionic = false;
	CharTemplate.bIsRobotic = false;
	CharTemplate.bIsSoldier = false;

	CharTemplate.bCanBeTerrorist = false;
	CharTemplate.bCanBeCriticallyWounded = false;
	CharTemplate.bIsAfraidOfFire = true;

	CharTemplate.Abilities.AddItem('MarkTarget');

	// CharTemplate.SightedNarrativeMoments.AddItem(XComNarrativeMoment'X2NarrativeMoments.TACTICAL.AlienSitings.T_Central_AlienSightings_AdvCaptainM3');
	// CharTemplate.SightedEvents.AddItem('AdventCaptainSighted');

	// CharTemplate.AddTemplateAvailablility(CharTemplate.BITFIELD_GAMEAREA_Multiplayer); // Allow in MP!
	CharTemplate.MPPointValue = CharTemplate.XpKillscore * 10;

	CharTemplate.strHackIconImage = "UILibrary_Common.TargetIcons.Hack_captain_icon";
	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_Advent;

	return CharTemplate;
}

static function X2CharacterTemplate CreateTemplate_AdvGeneralM1()
{
	local X2CharacterTemplate CharTemplate;
	local LootReference Loot;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, 'AdvGeneralM1');
	CharTemplate.CharacterGroupName = 'AdventCaptain';
	CharTemplate.DefaultLoadout='AdvGeneralM1_Loadout';
	CharTemplate.BehaviorClass=class'XGAIBehavior';
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_AdvGeneral.ARC_GameUnit_AdvGeneral_M");
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_AdvGeneral.ARC_GameUnit_AdvGeneral_F");
	Loot.ForceLevel = 0;
	Loot.LootTableName='AdvCaptainM1_BaseLoot';
	CharTemplate.Loot.LootReferences.AddItem(Loot);

	// Timed Loot
	Loot.ForceLevel = 0;
	Loot.LootTableName = 'AdvCaptainM1_TimedLoot';
	CharTemplate.TimedLoot.LootReferences.AddItem(Loot);
	Loot.LootTableName = 'AdvCaptainM1_VultureLoot';
	CharTemplate.VultureLoot.LootReferences.AddItem(Loot);

	CharTemplate.strMatineePackages.AddItem("CIN_Advent");
	CharTemplate.RevealMatineePrefix = "CIN_Advent_Captain";
	CharTemplate.GetRevealMatineePrefixFn = GetAdventMatineePrefix;

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
	CharTemplate.bSetGenderAlways = true;
	CharTemplate.bCanTakeCover = true;

	CharTemplate.bIsAlien = false;
	CharTemplate.bIsAdvent = true;
	CharTemplate.bIsCivilian = false;
	CharTemplate.bIsPsionic = false;
	CharTemplate.bIsRobotic = false;
	CharTemplate.bIsSoldier = false;

	CharTemplate.bCanBeTerrorist = false;
	CharTemplate.bCanBeCriticallyWounded = false;
	CharTemplate.bIsAfraidOfFire = true;

	// CharTemplate.Abilities.AddItem('MarkTarget');
	CharTemplate.Abilities.AddItem('Evac');
	CharTemplate.Abilities.AddItem('DarkEventAbility_SealedArmor');
	CharTemplate.Abilities.AddItem('DarkEventAbility_UndyingLoyalty');
	CharTemplate.Abilities.AddItem('DarkEventAbility_Barrier');
	CharTemplate.Abilities.AddItem('DarkEventAbility_Counterattack');

	CharTemplate.ImmuneTypes.AddItem('Mental');

	// CharTemplate.SightedNarrativeMoments.AddItem(XComNarrativeMoment'X2NarrativeMoments.TACTICAL.AlienSitings.T_Central_AlienSightings_AdvCaptainM1');
	// CharTemplate.SightedEvents.AddItem('AdventCaptainSighted');

	// CharTemplate.AddTemplateAvailablility(CharTemplate.BITFIELD_GAMEAREA_Multiplayer); // Allow in MP!
	CharTemplate.MPPointValue = CharTemplate.XpKillscore * 10;

	CharTemplate.strHackIconImage = "UILibrary_Common.TargetIcons.Hack_captain_icon";
	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_Advent;

	return CharTemplate;
}

static function X2CharacterTemplate CreateTemplate_AdvGeneralM2()
{
	local X2CharacterTemplate CharTemplate;
	local LootReference Loot;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, 'AdvGeneralM2');
	CharTemplate.CharacterGroupName = 'AdventCaptain';
	CharTemplate.DefaultLoadout='AdvGeneralM2_Loadout';
	CharTemplate.BehaviorClass=class'XGAIBehavior';
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_AdvGeneral.ARC_GameUnit_AdvGeneral_M");
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_AdvGeneral.ARC_GameUnit_AdvGeneral_F");
	Loot.ForceLevel=0;
	Loot.LootTableName='AdvCaptainM2_BaseLoot';
	CharTemplate.Loot.LootReferences.AddItem(Loot);

	// Timed Loot
	Loot.ForceLevel = 0;
	Loot.LootTableName = 'AdvCaptainM2_TimedLoot';
	CharTemplate.TimedLoot.LootReferences.AddItem(Loot);
	Loot.LootTableName = 'AdvCaptainM2_VultureLoot';
	CharTemplate.VultureLoot.LootReferences.AddItem(Loot);

	CharTemplate.strMatineePackages.AddItem("CIN_Advent");
	CharTemplate.RevealMatineePrefix = "CIN_Advent_Captain";
	CharTemplate.GetRevealMatineePrefixFn = GetAdventMatineePrefix;

	// CharTemplate.SightedNarrativeMoments.AddItem(XComNarrativeMoment'X2NarrativeMoments.TACTICAL.AlienSitings.T_Central_AlienSightings_AdvCaptainM2');
	// CharTemplate.SightedEvents.AddItem('AdventCaptainSighted');

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
	CharTemplate.bSetGenderAlways = true;
	CharTemplate.bCanTakeCover = true;
	CharTemplate.bIsAlien = false;
	CharTemplate.bIsAdvent = true;
	CharTemplate.bIsCivilian = false;
	CharTemplate.bIsPsionic = false;
	CharTemplate.bIsRobotic = false;
	CharTemplate.bIsSoldier = false;

	CharTemplate.bCanBeTerrorist = false;
	CharTemplate.bCanBeCriticallyWounded = false;
	CharTemplate.bIsAfraidOfFire = true;

	// CharTemplate.Abilities.AddItem('MarkTarget');
	CharTemplate.Abilities.AddItem('Evac');
	CharTemplate.Abilities.AddItem('DarkEventAbility_SealedArmor');
	CharTemplate.Abilities.AddItem('DarkEventAbility_UndyingLoyalty');
	CharTemplate.Abilities.AddItem('DarkEventAbility_Barrier');
	CharTemplate.Abilities.AddItem('DarkEventAbility_Counterattack');

	CharTemplate.ImmuneTypes.AddItem('Mental');

	// CharTemplate.AddTemplateAvailablility(CharTemplate.BITFIELD_GAMEAREA_Multiplayer); // Allow in MP!
	CharTemplate.MPPointValue = CharTemplate.XpKillscore * 10;

	CharTemplate.strHackIconImage = "UILibrary_Common.TargetIcons.Hack_captain_icon";
	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_Advent;

	return CharTemplate;
}

static function X2CharacterTemplate CreateTemplate_AdvGeneralM3()
{
	local X2CharacterTemplate CharTemplate;
	local LootReference Loot;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, 'AdvGeneralM3');
	CharTemplate.CharacterGroupName = 'AdventCaptain';
	CharTemplate.DefaultLoadout='AdvGeneralM3_Loadout';
	CharTemplate.BehaviorClass=class'XGAIBehavior';
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_AdvGeneral.ARC_GameUnit_AdvGeneral_M");
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_AdvGeneral.ARC_GameUnit_AdvGeneral_F");
	Loot.ForceLevel=0;
	Loot.LootTableName='AdvCaptainM3_BaseLoot';
	CharTemplate.Loot.LootReferences.AddItem(Loot);

	// Timed Loot
	Loot.ForceLevel = 0;
	Loot.LootTableName = 'AdvCaptainM3_TimedLoot';
	CharTemplate.TimedLoot.LootReferences.AddItem(Loot);
	Loot.LootTableName = 'AdvCaptainM3_VultureLoot';
	CharTemplate.VultureLoot.LootReferences.AddItem(Loot);

	CharTemplate.strMatineePackages.AddItem("CIN_Advent");
	CharTemplate.RevealMatineePrefix = "CIN_Advent_Captain";
	CharTemplate.GetRevealMatineePrefixFn = GetAdventMatineePrefix;

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
	CharTemplate.bSetGenderAlways = true;
	CharTemplate.bCanTakeCover = true;

	CharTemplate.bIsAlien = false;
	CharTemplate.bIsAdvent = true;
	CharTemplate.bIsCivilian = false;
	CharTemplate.bIsPsionic = false;
	CharTemplate.bIsRobotic = false;
	CharTemplate.bIsSoldier = false;

	CharTemplate.bCanBeTerrorist = false;
	CharTemplate.bCanBeCriticallyWounded = false;
	CharTemplate.bIsAfraidOfFire = true;

	// CharTemplate.Abilities.AddItem('MarkTarget');
	CharTemplate.Abilities.AddItem('Evac');
	CharTemplate.Abilities.AddItem('DarkEventAbility_SealedArmor');
	CharTemplate.Abilities.AddItem('DarkEventAbility_UndyingLoyalty');
	CharTemplate.Abilities.AddItem('DarkEventAbility_Barrier');
	CharTemplate.Abilities.AddItem('DarkEventAbility_Counterattack');

	CharTemplate.ImmuneTypes.AddItem('Mental');

	// CharTemplate.SightedNarrativeMoments.AddItem(XComNarrativeMoment'X2NarrativeMoments.TACTICAL.AlienSitings.T_Central_AlienSightings_AdvCaptainM3');
	// CharTemplate.SightedEvents.AddItem('AdventCaptainSighted');

	// CharTemplate.AddTemplateAvailablility(CharTemplate.BITFIELD_GAMEAREA_Multiplayer); // Allow in MP!
	CharTemplate.MPPointValue = CharTemplate.XpKillscore * 10;

	CharTemplate.strHackIconImage = "UILibrary_Common.TargetIcons.Hack_captain_icon";
	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_Advent;

	return CharTemplate;
}

// Militia civilians for Chosen Retaliation

static function X2CharacterTemplate CreateCivilianMilitiaTemplate(name TemplateName)
{
	local X2CharacterTemplate CharTemplate;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, TemplateName);	
	CharTemplate.CharacterGroupName = 'CivilianMilitia';
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
	CharTemplate.bCanBeTerrorist = false;
	CharTemplate.bAppearanceDefinesPawn = true;
	CharTemplate.bIsAfraidOfFire = true;
	CharTemplate.bIsAlien = false;
	CharTemplate.bIsCivilian = true;
	CharTemplate.bIsPsionic = false;
	CharTemplate.bIsRobotic = false;
	CharTemplate.bIsSoldier = false;
	CharTemplate.bCanTakeCover = true;
	CharTemplate.bDisplayUIUnitFlag=false;
//	CharTemplate.strMatineePackages.AddItem("CIN_Soldier");
//	CharTemplate.strIntroMatineeSlotPrefix = "Char";
//	CharTemplate.strLoadingMatineeSlotPrefix = "Soldier";

	CharTemplate.DefaultLoadout = 'CivilianMilitiaLoadout';
	CharTemplate.Abilities.AddItem('KnockoutSelf');
//	CharTemplate.Abilities.AddItem('Panicked');
	CharTemplate.Abilities.AddItem('HunkerDown');
	CharTemplate.Abilities.AddItem('CivilianEasyToHit');

	CharTemplate.MPPointValue = CharTemplate.XpKillscore * 10;

	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_Civilian;
	CharTemplate.CharacterGeneratorClass = class'XGCharacterGenerator';

	CharTemplate.bShouldCreateDifficultyVariants = false;

//	CharTemplate.strBehaviorTree="CivRoot";
	CharTemplate.strScamperBT = "SkipMove";

	return CharTemplate;
}

static function X2CharacterTemplate CreateCivilianMilitiaM2Template()
{
	local X2CharacterTemplate CharTemplate;

	CharTemplate = CreateCivilianMilitiaTemplate('CivilianMilitiaM2');
	CharTemplate.DefaultLoadout = 'CivilianMilitiaLoadoutM2';

	return CharTemplate;
}

static function X2CharacterTemplate CreateCivilianMilitiaM3Template()
{
	local X2CharacterTemplate CharTemplate;

	CharTemplate = CreateCivilianMilitiaTemplate('CivilianMilitiaM3');
	CharTemplate.DefaultLoadout = 'CivilianMilitiaLoadoutM3';

	return CharTemplate;
}

static function X2CharacterTemplate CreateVolunteerArmyMilitiaTemplate(name TemplateName)
{
	local X2CharacterTemplate CharTemplate;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, TemplateName);	
	CharTemplate.CharacterGroupName = 'CivilianMilitia';
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
	CharTemplate.bCanBeTerrorist = false;
	CharTemplate.bAppearanceDefinesPawn = true;
	CharTemplate.bIsAfraidOfFire = true;
	CharTemplate.bIsAlien = false;
	CharTemplate.bIsCivilian = true;
	CharTemplate.bIsPsionic = false;
	CharTemplate.bIsRobotic = false;
	CharTemplate.bIsSoldier = false;
	CharTemplate.bCanTakeCover = true;
	CharTemplate.bDisplayUIUnitFlag = true;
	//	CharTemplate.strMatineePackages.AddItem("CIN_Soldier");
	//	CharTemplate.strIntroMatineeSlotPrefix = "Char";
	//	CharTemplate.strLoadingMatineeSlotPrefix = "Soldier";

	CharTemplate.DefaultLoadout = 'RookieSoldier';
	CharTemplate.RequiredLoadout = 'RequiredSoldier';

	CharTemplate.Abilities.AddItem('Loot');
	CharTemplate.Abilities.AddItem('Interact_PlantBomb');
	CharTemplate.Abilities.AddItem('Interact_TakeVial');
	CharTemplate.Abilities.AddItem('Interact_StasisTube');
	CharTemplate.Abilities.AddItem('Interact_MarkSupplyCrate');
	CharTemplate.Abilities.AddItem('Interact_ActivateAscensionGate');
	CharTemplate.Abilities.AddItem('CarryUnit');
	CharTemplate.Abilities.AddItem('PutDownUnit');
	CharTemplate.Abilities.AddItem('Evac');
	CharTemplate.Abilities.AddItem('PlaceEvacZone');
	CharTemplate.Abilities.AddItem('LiftOffAvenger');
	CharTemplate.Abilities.AddItem('Knockout');
	CharTemplate.Abilities.AddItem('KnockoutSelf');
	CharTemplate.Abilities.AddItem('Panicked');
	CharTemplate.Abilities.AddItem('Berserk');
	CharTemplate.Abilities.AddItem('Obsessed');
	CharTemplate.Abilities.AddItem('Shattered');
	CharTemplate.Abilities.AddItem('HunkerDown');
	CharTemplate.Abilities.AddItem('DisableConsumeAllPoints');
	CharTemplate.Abilities.AddItem('Revive');

	CharTemplate.MPPointValue = CharTemplate.XpKillscore * 10;

	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_XCom;
	CharTemplate.CharacterGeneratorClass = class'XGCharacterGenerator';

	CharTemplate.bShouldCreateDifficultyVariants = false;

	//	CharTemplate.strBehaviorTree="CivRoot";
	CharTemplate.strScamperBT = "SkipMove";

	return CharTemplate;
}

static function X2CharacterTemplate CreateVolunteerArmyMilitiaM2Template()
{
	local X2CharacterTemplate CharTemplate;

	CharTemplate = CreateVolunteerArmyMilitiaTemplate('VolunteerArmyMilitiaM2');
	CharTemplate.DefaultLoadout = 'RookieSoldierM2';

	return CharTemplate;
}

static function X2CharacterTemplate CreateVolunteerArmyMilitiaM3Template()
{
	local X2CharacterTemplate CharTemplate;

	CharTemplate = CreateVolunteerArmyMilitiaTemplate('VolunteerArmyMilitiaM3');
	CharTemplate.DefaultLoadout = 'RookieSoldierM3';

	return CharTemplate;
}

static function X2CharacterTemplate CreateTemplate_SpectreM1()
{
	local X2CharacterTemplate CharTemplate;
	local LootReference Loot;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, 'SpectreM1');
	CharTemplate.CharacterGroupName = 'Spectre';
	CharTemplate.DefaultLoadout = 'SpectreM1_Loadout';
	CharTemplate.BehaviorClass = class'XGAIBehavior';
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_Spectre.ARC_GameUnit_Spectre");

	// Auto-Loot
	Loot.ForceLevel = 0;
	Loot.LootTableName = 'Spectre_BaseLoot';
	CharTemplate.Loot.LootReferences.AddItem(Loot);

	// Timed Loot
	Loot.ForceLevel = 0;
	Loot.LootTableName = 'Spectre_TimedLoot';
	CharTemplate.TimedLoot.LootReferences.AddItem(Loot);
	Loot.LootTableName = 'Spectre_VultureLoot';
	CharTemplate.VultureLoot.LootReferences.AddItem(Loot);

	CharTemplate.UnitSize = 1;

	// Traversal Rules
	CharTemplate.bCanUse_eTraversal_Normal = true;
//BEGIN AUTOGENERATED CODE: Template Overrides 'SpectreM1'
	CharTemplate.bCanUse_eTraversal_ClimbOver = false;
	CharTemplate.bCanUse_eTraversal_ClimbOnto = false;
	CharTemplate.bCanUse_eTraversal_ClimbLadder = false;
	CharTemplate.bCanUse_eTraversal_DropDown = false;
	CharTemplate.bCanUse_eTraversal_Launch = true;
	CharTemplate.bCanUse_eTraversal_Flying = true;
	CharTemplate.bCanUse_eTraversal_Land = true;
	CharTemplate.bCanUse_eTraversal_Landing = true;
	CharTemplate.strMatineePackages[0] = "CIN_XP_Spectre";
	CharTemplate.strIntroMatineeSlotPrefix = "CIN_Spectre_Reveal";
//END AUTOGENERATED CODE: Template Overrides 'SpectreM1'
	CharTemplate.bCanUse_eTraversal_Grapple = false;
	CharTemplate.bCanUse_eTraversal_BreakWindow = true;
	CharTemplate.bCanUse_eTraversal_KickDoor = true;
	CharTemplate.bCanUse_eTraversal_JumpUp = false;
	CharTemplate.bCanUse_eTraversal_WallClimb = false;
	CharTemplate.bCanUse_eTraversal_BreakWall = false;
	CharTemplate.bAppearanceDefinesPawn = false;
	CharTemplate.bSetGenderAlways = true;
	CharTemplate.bCanTakeCover = true;
	CharTemplate.MaxFlightPitchDegrees = 0;

	CharTemplate.bIsAlien = true;
	CharTemplate.bIsHumanoid = true;
	CharTemplate.bIsAdvent = false;
	CharTemplate.bIsCivilian = false;
	CharTemplate.bIsPsionic = false;
	CharTemplate.bIsRobotic = false;
	CharTemplate.bIsSoldier = false;
	CharTemplate.bWeakAgainstTechLikeRobot = true;

	CharTemplate.bCanBeTerrorist = false;
	CharTemplate.bCanBeCriticallyWounded = false;
	CharTemplate.bIsAfraidOfFire = true;

	CharTemplate.Abilities.AddItem('SpectreMoveBegin');
	CharTemplate.Abilities.AddItem('Vanish');
	CharTemplate.Abilities.AddItem('LightningReflexes');
	CharTemplate.Abilities.AddItem('Shadowbind');
	//CharTemplate.Abilities.AddItem('ShadowboundLink');
	CharTemplate.Abilities.AddItem('KillShadowboundLinkedUnits');
	CharTemplate.Abilities.AddItem('DarkEventAbility_Barrier');

	CharTemplate.ImmuneTypes.AddItem('Mental');
	CharTemplate.ImmuneTypes.AddItem('Fire');
	CharTemplate.ImmuneTypes.AddItem('Poison');
	CharTemplate.ImmuneTypes.AddItem(class'X2Item_DefaultDamageTypes'.default.ParthenogenicPoisonType);
	CharTemplate.ImmuneTypes.AddItem('Acid');

	CharTemplate.SightedNarrativeMoments.AddItem(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_TYG_T_First_Seen_Spectre_M1');
	CharTemplate.SightedNarrativeMoments.AddItem(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_TYG_T_First_Spectre_Sighted');

	CharTemplate.strHackIconImage = "UILibrary_Common.TargetIcons.Hack_captain_icon";
	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_Alien;

	return CharTemplate;
}

static function X2CharacterTemplate CreateTemplate_SpectreM2()
{
	local X2CharacterTemplate CharTemplate;
	local LootReference Loot;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, 'SpectreM2');
	CharTemplate.CharacterGroupName = 'Spectre';
	CharTemplate.DefaultLoadout = 'SpectreM2_Loadout';
	CharTemplate.BehaviorClass = class'XGAIBehavior';	

	// Auto-Loot
	Loot.ForceLevel = 0;
	Loot.LootTableName = 'Spectre_BaseLoot';
	CharTemplate.Loot.LootReferences.AddItem(Loot);

	// Timed Loot
	Loot.ForceLevel = 0;
	Loot.LootTableName = 'Spectre_TimedLoot';
	CharTemplate.TimedLoot.LootReferences.AddItem(Loot);
	Loot.LootTableName = 'Spectre_VultureLoot';
	CharTemplate.VultureLoot.LootReferences.AddItem(Loot);

	CharTemplate.UnitSize = 1;

	// Traversal Rules
	CharTemplate.bCanUse_eTraversal_Normal = true;

//BEGIN AUTOGENERATED CODE: Template Overrides 'SpectreM2'
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_Spectre.ARC_GameUnit_SpectreM2");
	CharTemplate.bCanUse_eTraversal_ClimbOver = false;
	CharTemplate.bCanUse_eTraversal_ClimbOnto = false;
	CharTemplate.bCanUse_eTraversal_ClimbLadder = false;
	CharTemplate.bCanUse_eTraversal_DropDown = false;
	CharTemplate.bCanUse_eTraversal_Launch = true;
	CharTemplate.bCanUse_eTraversal_Flying = true;
	CharTemplate.bCanUse_eTraversal_Land = true;
	CharTemplate.bCanUse_eTraversal_Landing = true;
	CharTemplate.strMatineePackages[0] = "CIN_XP_Spectre";
	CharTemplate.strIntroMatineeSlotPrefix = "CIN_Spectre_Reveal";
//END AUTOGENERATED CODE: Template Overrides 'SpectreM2'

	CharTemplate.bCanUse_eTraversal_Grapple = false;
	CharTemplate.bCanUse_eTraversal_Landing = true;
	CharTemplate.bCanUse_eTraversal_BreakWindow = true;
	CharTemplate.bCanUse_eTraversal_KickDoor = true;
	CharTemplate.bCanUse_eTraversal_JumpUp = false;
	CharTemplate.bCanUse_eTraversal_WallClimb = false;
	CharTemplate.bCanUse_eTraversal_BreakWall = false;
	CharTemplate.bAppearanceDefinesPawn = false;
	CharTemplate.bSetGenderAlways = true;
	CharTemplate.bCanTakeCover = true;
	CharTemplate.MaxFlightPitchDegrees = 0;

	CharTemplate.bIsAlien = true;
	CharTemplate.bIsHumanoid = true;
	CharTemplate.bIsAdvent = false;
	CharTemplate.bIsCivilian = false;
	CharTemplate.bIsPsionic = false;
	CharTemplate.bIsRobotic = false;
	CharTemplate.bIsSoldier = false;
	CharTemplate.bWeakAgainstTechLikeRobot = true;

	CharTemplate.bCanBeTerrorist = false;
	CharTemplate.bCanBeCriticallyWounded = false;
	CharTemplate.bIsAfraidOfFire = true;

	CharTemplate.Abilities.AddItem('SpectreMoveBegin');
	CharTemplate.Abilities.AddItem('Vanish');
	CharTemplate.Abilities.AddItem('LightningReflexes');
	CharTemplate.Abilities.AddItem('ShadowbindM2');
	//CharTemplate.Abilities.AddItem('ShadowboundLink');
	CharTemplate.Abilities.AddItem('KillShadowboundLinkedUnits');
	
	CharTemplate.ImmuneTypes.AddItem('Mental');
	CharTemplate.ImmuneTypes.AddItem('Fire');
	CharTemplate.ImmuneTypes.AddItem('Poison');
	CharTemplate.ImmuneTypes.AddItem(class'X2Item_DefaultDamageTypes'.default.ParthenogenicPoisonType);
	CharTemplate.ImmuneTypes.AddItem('Acid');

	CharTemplate.SightedNarrativeMoments.AddItem(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_TYG_T_First_Seen_Spectre_M1');

	CharTemplate.strHackIconImage = "UILibrary_Common.TargetIcons.Hack_captain_icon";
	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_Alien;

	return CharTemplate;
}

static function X2CharacterTemplate CreateTemplate_ShadowbindUnit(name CharTemplateName)
{
	local X2CharacterTemplate CharTemplate;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, CharTemplateName);

	CharTemplate.CharacterGroupName = 'Shadowbind';
//	CharTemplate.DefaultLoadout = 'AdvTrooperM1_Loadout';
	CharTemplate.BehaviorClass = class'XGAIBehavior';
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_ShadowBind.ARC_ShadowBindUnit_M");
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_ShadowBind.ARC_ShadowBindUnit_F");
	CharTemplate.bNeverShowFirstSighted = true;

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
	CharTemplate.bSetGenderAlways = true;
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

	CharTemplate.strScamperBT = "ScamperRoot_NoShotChance";

	CharTemplate.Abilities.AddItem('DarkEventAbility_Barrier');
	CharTemplate.Abilities.AddItem('ShadowUnitInitialize');
	
	CharTemplate.ImmuneTypes.AddItem('Mental');

	return CharTemplate;
}

static function X2CharacterTemplate CreateTemplate_AdvPurifierM1()
{
	local X2CharacterTemplate CharTemplate;
	local LootReference Loot;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, 'AdvPurifierM1');
	CharTemplate.CharacterGroupName = 'AdventPurifier';
	CharTemplate.DefaultLoadout = 'AdvPurifierM1_Loadout';
	CharTemplate.BehaviorClass = class'XGAIBehavior';
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_AdvPurifier.ARC_GameUnit_AdvPurifierM1_M");
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_AdvPurifier.ARC_GameUnit_AdvPurifierM1_F");

	// Auto-Loot
	Loot.ForceLevel = 0;
	Loot.LootTableName = 'AdvPurifierM1_BaseLoot';
	CharTemplate.Loot.LootReferences.AddItem(Loot);

	// Timed Loot
	Loot.ForceLevel = 0;
	Loot.LootTableName = 'AdvPurifierM1_TimedLoot';
	CharTemplate.TimedLoot.LootReferences.AddItem(Loot);
	Loot.LootTableName = 'AdvPurifierM1_VultureLoot';
	CharTemplate.VultureLoot.LootReferences.AddItem(Loot);

	CharTemplate.strMatineePackages.AddItem("CIN_Advent");
	CharTemplate.strMatineePackages.AddItem("CIN_XP_Advent");
	CharTemplate.RevealMatineePrefix = "CIN_Advent_Purifier";
	CharTemplate.GetRevealMatineePrefixFn = GetAdventMatineePrefix;

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
	CharTemplate.bSetGenderAlways = true;
	CharTemplate.bCanTakeCover = true;

	CharTemplate.bIsAlien = false;
	CharTemplate.bIsAdvent = true;
	CharTemplate.bIsCivilian = false;
	CharTemplate.bIsPsionic = false;
	CharTemplate.bIsRobotic = false;
	CharTemplate.bIsSoldier = false;

	CharTemplate.bCanBeTerrorist = false;
	CharTemplate.bCanBeCriticallyWounded = false;
	CharTemplate.bIsAfraidOfFire = false;

	CharTemplate.Abilities.AddItem('PurifierInit');
	CharTemplate.Abilities.AddItem('DarkEventAbility_SealedArmor');
	CharTemplate.Abilities.AddItem('DarkEventAbility_UndyingLoyalty');
	CharTemplate.Abilities.AddItem('DarkEventAbility_Barrier');

	CharTemplate.SightedNarrativeMoments.AddItem(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_CEN_T_First_Seen_Adv_Purifier_M1');
	CharTemplate.SightedNarrativeMoments.AddItem(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_CEN_T_First_Purifier');

	CharTemplate.strHackIconImage = "UILibrary_Common.TargetIcons.Hack_captain_icon";
	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_Advent;

	return CharTemplate;
}

static function X2CharacterTemplate CreateTemplate_AdvPurifierM2()
{
	local X2CharacterTemplate CharTemplate;
	local LootReference Loot;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, 'AdvPurifierM2');
	CharTemplate.CharacterGroupName = 'AdventPurifier';
	CharTemplate.DefaultLoadout = 'AdvPurifierM2_Loadout';
	CharTemplate.BehaviorClass = class'XGAIBehavior';
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_AdvPurifier.ARC_GameUnit_AdvPurifierM2_M");
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_AdvPurifier.ARC_GameUnit_AdvPurifierM2_F");

	// Auto-Loot
	Loot.ForceLevel = 0;
	Loot.LootTableName = 'AdvPurifierM2_BaseLoot';
	CharTemplate.Loot.LootReferences.AddItem(Loot);

	// Timed Loot
	Loot.ForceLevel = 0;
	Loot.LootTableName = 'AdvPurifierM2_TimedLoot';
	CharTemplate.TimedLoot.LootReferences.AddItem(Loot);
	Loot.LootTableName = 'AdvPurifierM2_VultureLoot';
	CharTemplate.VultureLoot.LootReferences.AddItem(Loot);

	CharTemplate.strMatineePackages.AddItem("CIN_Advent");
	CharTemplate.strMatineePackages.AddItem("CIN_XP_Advent");
	CharTemplate.RevealMatineePrefix = "CIN_Advent_Purifier";
	CharTemplate.GetRevealMatineePrefixFn = GetAdventMatineePrefix;

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
	CharTemplate.bSetGenderAlways = true;
	CharTemplate.bCanTakeCover = true;

	CharTemplate.bIsAlien = false;
	CharTemplate.bIsAdvent = true;
	CharTemplate.bIsCivilian = false;
	CharTemplate.bIsPsionic = false;
	CharTemplate.bIsRobotic = false;
	CharTemplate.bIsSoldier = false;

	CharTemplate.bCanBeTerrorist = false;
	CharTemplate.bCanBeCriticallyWounded = false;
	CharTemplate.bIsAfraidOfFire = false;

	CharTemplate.Abilities.AddItem('PurifierInit');
	CharTemplate.Abilities.AddItem('DarkEventAbility_SealedArmor');
	CharTemplate.Abilities.AddItem('DarkEventAbility_UndyingLoyalty');
	CharTemplate.Abilities.AddItem('DarkEventAbility_Barrier');

	CharTemplate.SightedNarrativeMoments.AddItem(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_CEN_T_First_Seen_Adv_Purifier_M1');
	CharTemplate.SightedNarrativeMoments.AddItem(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_CEN_T_First_Purifier');

	CharTemplate.strHackIconImage = "UILibrary_Common.TargetIcons.Hack_captain_icon";
	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_Advent;

	return CharTemplate;
}

static function X2CharacterTemplate CreateTemplate_AdvPurifierM3()
{
	local X2CharacterTemplate CharTemplate;
	local LootReference Loot;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, 'AdvPurifierM3');
	CharTemplate.CharacterGroupName = 'AdventPurifier';
	CharTemplate.DefaultLoadout = 'AdvPurifierM3_Loadout';
	CharTemplate.BehaviorClass = class'XGAIBehavior';
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_AdvPurifier.ARC_GameUnit_AdvPurifierM3_M");
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_AdvPurifier.ARC_GameUnit_AdvPurifierM3_F");

	// Auto-Loot
	Loot.ForceLevel = 0;
	Loot.LootTableName = 'AdvPurifierM3_BaseLoot';
	CharTemplate.Loot.LootReferences.AddItem(Loot);

	// Timed Loot
	Loot.ForceLevel = 0;
	Loot.LootTableName = 'AdvPurifierM3_TimedLoot';
	CharTemplate.TimedLoot.LootReferences.AddItem(Loot);
	Loot.LootTableName = 'AdvPurifierM3_VultureLoot';
	CharTemplate.VultureLoot.LootReferences.AddItem(Loot);

	CharTemplate.strMatineePackages.AddItem("CIN_Advent");
	CharTemplate.strMatineePackages.AddItem("CIN_XP_Advent");
	CharTemplate.RevealMatineePrefix = "CIN_Advent_Purifier";
	CharTemplate.GetRevealMatineePrefixFn = GetAdventMatineePrefix;

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
	CharTemplate.bSetGenderAlways = true;
	CharTemplate.bCanTakeCover = true;

	CharTemplate.bIsAlien = false;
	CharTemplate.bIsAdvent = true;
	CharTemplate.bIsCivilian = false;
	CharTemplate.bIsPsionic = false;
	CharTemplate.bIsRobotic = false;
	CharTemplate.bIsSoldier = false;

	CharTemplate.bCanBeTerrorist = false;
	CharTemplate.bCanBeCriticallyWounded = false;
	CharTemplate.bIsAfraidOfFire = false;

	CharTemplate.Abilities.AddItem('PurifierInit');
	CharTemplate.Abilities.AddItem('DarkEventAbility_SealedArmor');
	CharTemplate.Abilities.AddItem('DarkEventAbility_UndyingLoyalty');
	CharTemplate.Abilities.AddItem('DarkEventAbility_Barrier');

	CharTemplate.SightedNarrativeMoments.AddItem(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_CEN_T_First_Seen_Adv_Purifier_M1');
	CharTemplate.SightedNarrativeMoments.AddItem(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_CEN_T_First_Purifier');

	CharTemplate.strHackIconImage = "UILibrary_Common.TargetIcons.Hack_captain_icon";
	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_Advent;

	return CharTemplate;
}

static function X2CharacterTemplate CreateTemplate_AdvPriestM1()
{
	local X2CharacterTemplate CharTemplate;
	local LootReference Loot;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, 'AdvPriestM1');
	CharTemplate.CharacterGroupName = 'AdventPriest';
	CharTemplate.DefaultLoadout = 'AdvPriestM1_Loadout';
	CharTemplate.BehaviorClass = class'XGAIBehavior';
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_AdvPriest.ARC_GameUnit_AdvPriestM1_M");
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_AdvPriest.ARC_GameUnit_AdvPriestM1_F");

	// Auto-Loot
	Loot.ForceLevel = 0;
	Loot.LootTableName = 'AdvPriestM1_BaseLoot';
	CharTemplate.Loot.LootReferences.AddItem(Loot);

	// Timed Loot
	Loot.ForceLevel = 0;
	Loot.LootTableName = 'AdvPriestM1_TimedLoot';
	CharTemplate.TimedLoot.LootReferences.AddItem(Loot);
	Loot.LootTableName = 'AdvPriestM1_VultureLoot';
	CharTemplate.VultureLoot.LootReferences.AddItem(Loot);

	CharTemplate.strMatineePackages.AddItem("CIN_Advent");
	CharTemplate.strMatineePackages.AddItem("CIN_Soldier");	
	CharTemplate.RevealMatineePrefix = "CIN_Advent_Priest";
	CharTemplate.GetRevealMatineePrefixFn = GetAdventMatineePrefix;

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
	CharTemplate.bSetGenderAlways = true;
	CharTemplate.bCanTakeCover = true;

	CharTemplate.bIsAlien = false;
	CharTemplate.bIsAdvent = true;
	CharTemplate.bIsCivilian = false;
	CharTemplate.bIsPsionic = true;
	CharTemplate.bIsRobotic = false;
	CharTemplate.bIsSoldier = false;

	CharTemplate.bCanBeTerrorist = false;
	CharTemplate.bCanBeCriticallyWounded = false;
	CharTemplate.bIsAfraidOfFire = false;
	
	CharTemplate.Abilities.AddItem('Sustain');
	CharTemplate.Abilities.AddItem('AdventStilettoRounds');
	CharTemplate.Abilities.AddItem('DarkEventAbility_ReturnFire');
	CharTemplate.Abilities.AddItem('DarkEventAbility_SealedArmor');
	CharTemplate.Abilities.AddItem('DarkEventAbility_UndyingLoyalty');
	CharTemplate.Abilities.AddItem('DarkEventAbility_Barrier');
	CharTemplate.Abilities.AddItem('DarkEventAbility_Counterattack');

	CharTemplate.SightedNarrativeMoments.AddItem(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_TYG_T_First_Seen_Adv_Priest_M1');
	CharTemplate.SightedNarrativeMoments.AddItem(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_CEN_T_First_Priest');

	CharTemplate.strHackIconImage = "UILibrary_Common.TargetIcons.Hack_captain_icon";
	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_Advent;

	return CharTemplate;
}

static function X2CharacterTemplate CreateTemplate_AdvPriestM2()
{
	local X2CharacterTemplate CharTemplate;
	local LootReference Loot;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, 'AdvPriestM2');
	CharTemplate.CharacterGroupName = 'AdventPriest';
	CharTemplate.DefaultLoadout = 'AdvPriestM2_Loadout';
	CharTemplate.BehaviorClass = class'XGAIBehavior';
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_AdvPriest.ARC_GameUnit_AdvPriestM2_M");
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_AdvPriest.ARC_GameUnit_AdvPriestM2_F");

	// Auto-Loot
	Loot.ForceLevel = 0;
	Loot.LootTableName = 'AdvPriestM2_BaseLoot';
	CharTemplate.Loot.LootReferences.AddItem(Loot);

	// Timed Loot
	Loot.ForceLevel = 0;
	Loot.LootTableName = 'AdvPriestM2_TimedLoot';
	CharTemplate.TimedLoot.LootReferences.AddItem(Loot);
	Loot.LootTableName = 'AdvPriestM2_VultureLoot';
	CharTemplate.VultureLoot.LootReferences.AddItem(Loot);

	CharTemplate.strMatineePackages.AddItem("CIN_Advent");
	CharTemplate.strMatineePackages.AddItem("CIN_Soldier");
	CharTemplate.RevealMatineePrefix = "CIN_Advent_Priest";
	CharTemplate.GetRevealMatineePrefixFn = GetAdventMatineePrefix;

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
	CharTemplate.bSetGenderAlways = true;
	CharTemplate.bCanTakeCover = true;

	CharTemplate.bIsAlien = false;
	CharTemplate.bIsAdvent = true;
	CharTemplate.bIsCivilian = false;
	CharTemplate.bIsPsionic = true;
	CharTemplate.bIsRobotic = false;
	CharTemplate.bIsSoldier = false;

	CharTemplate.bCanBeTerrorist = false;
	CharTemplate.bCanBeCriticallyWounded = false;
	CharTemplate.bIsAfraidOfFire = false;
	
	CharTemplate.Abilities.AddItem('Sustain');
	CharTemplate.Abilities.AddItem('AdventStilettoRounds');
	CharTemplate.Abilities.AddItem('DarkEventAbility_ReturnFire');
	CharTemplate.Abilities.AddItem('DarkEventAbility_SealedArmor');
	CharTemplate.Abilities.AddItem('DarkEventAbility_UndyingLoyalty');
	CharTemplate.Abilities.AddItem('DarkEventAbility_Barrier');
	CharTemplate.Abilities.AddItem('DarkEventAbility_Counterattack');

	CharTemplate.SightedNarrativeMoments.AddItem(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_TYG_T_First_Seen_Adv_Priest_M1');
	CharTemplate.SightedNarrativeMoments.AddItem(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_CEN_T_First_Priest');

	CharTemplate.strHackIconImage = "UILibrary_Common.TargetIcons.Hack_captain_icon";
	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_Advent;

	return CharTemplate;
}

static function X2CharacterTemplate CreateTemplate_AdvPriestM3()
{
	local X2CharacterTemplate CharTemplate;
	local LootReference Loot;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, 'AdvPriestM3');
	CharTemplate.CharacterGroupName = 'AdventPriest';
	CharTemplate.DefaultLoadout = 'AdvPriestM3_Loadout';
	CharTemplate.BehaviorClass = class'XGAIBehavior';
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_AdvPriest.ARC_GameUnit_AdvPriestM3_M");
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_AdvPriest.ARC_GameUnit_AdvPriestM3_F");

	// Auto-Loot
	Loot.ForceLevel = 0;
	Loot.LootTableName = 'AdvPriestM3_BaseLoot';
	CharTemplate.Loot.LootReferences.AddItem(Loot);

	// Timed Loot
	Loot.ForceLevel = 0;
	Loot.LootTableName = 'AdvPriestM3_TimedLoot';
	CharTemplate.TimedLoot.LootReferences.AddItem(Loot);
	Loot.LootTableName = 'AdvPriestM3_VultureLoot';
	CharTemplate.VultureLoot.LootReferences.AddItem(Loot);

	CharTemplate.strMatineePackages.AddItem("CIN_Advent");
	CharTemplate.strMatineePackages.AddItem("CIN_Soldier");
	CharTemplate.RevealMatineePrefix = "CIN_Advent_Priest";
	CharTemplate.GetRevealMatineePrefixFn = GetAdventMatineePrefix;

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
	CharTemplate.bSetGenderAlways = true;
	CharTemplate.bCanTakeCover = true;

	CharTemplate.bIsAlien = false;
	CharTemplate.bIsAdvent = true;
	CharTemplate.bIsCivilian = false;
	CharTemplate.bIsPsionic = true;
	CharTemplate.bIsRobotic = false;
	CharTemplate.bIsSoldier = false;

	CharTemplate.bCanBeTerrorist = false;
	CharTemplate.bCanBeCriticallyWounded = false;
	CharTemplate.bIsAfraidOfFire = false;
	
	CharTemplate.Abilities.AddItem('Sustain');
	CharTemplate.Abilities.AddItem('AdventStilettoRounds');
	CharTemplate.Abilities.AddItem('DarkEventAbility_ReturnFire');
	CharTemplate.Abilities.AddItem('DarkEventAbility_SealedArmor');
	CharTemplate.Abilities.AddItem('DarkEventAbility_UndyingLoyalty');
	CharTemplate.Abilities.AddItem('DarkEventAbility_Barrier');
	CharTemplate.Abilities.AddItem('DarkEventAbility_Counterattack');

	CharTemplate.SightedNarrativeMoments.AddItem(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_TYG_T_First_Seen_Adv_Priest_M1');
	CharTemplate.SightedNarrativeMoments.AddItem(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_CEN_T_First_Priest');

	CharTemplate.strHackIconImage = "UILibrary_Common.TargetIcons.Hack_captain_icon";
	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_Advent;

	return CharTemplate;
}

static function X2CharacterTemplate CreateTemplate_SpectralStunLancer(name CharTemplateName, name LoadoutName)
{
	local X2CharacterTemplate CharTemplate;
	local LootReference Loot;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, CharTemplateName);
	CharTemplate.CharacterGroupName = 'SpectralStunLancer';
	CharTemplate.DefaultLoadout = LoadoutName;
	CharTemplate.BehaviorClass = class'XGAIBehavior';
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_SpectralUnits.ARC_GameUnit_SpectralStunLancerM1_M");
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_SpectralUnits.ARC_GameUnit_SpectralStunLancerM1_F");
	Loot.ForceLevel = 0;
	Loot.LootTableName = 'AdvStunLancerM1_BaseLoot';
	CharTemplate.Loot.LootReferences.AddItem(Loot);

	// Timed Loot
	Loot.ForceLevel = 0;
	Loot.LootTableName = 'AdvStunLancerM1_TimedLoot';
	CharTemplate.TimedLoot.LootReferences.AddItem(Loot);
	Loot.LootTableName = 'AdvStunLancerM1_VultureLoot';
	CharTemplate.VultureLoot.LootReferences.AddItem(Loot);

	CharTemplate.strMatineePackages.AddItem("CIN_Advent");
	CharTemplate.RevealMatineePrefix = "CIN_Advent_StunLancer";
	CharTemplate.GetRevealMatineePrefixFn = GetAdventMatineePrefix;

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
	CharTemplate.bSetGenderAlways = true;
	CharTemplate.bCanTakeCover = true;

	CharTemplate.bIsAlien = false;
	CharTemplate.bIsAdvent = true;
	CharTemplate.bIsCivilian = false;
	CharTemplate.bIsPsionic = false;
	CharTemplate.bIsRobotic = false;
	CharTemplate.bIsSoldier = false;

	CharTemplate.bCanBeTerrorist = false;
	CharTemplate.bCanBeCriticallyWounded = false;
	CharTemplate.bIsAfraidOfFire = true;

	CharTemplate.Abilities.AddItem('SpectralArmyUnitInitialize');
	CharTemplate.Abilities.AddItem('DarkEventAbility_Barrier');

	CharTemplate.ImmuneTypes.AddItem('Mental');
	CharTemplate.ImmuneTypes.AddItem('Fire');
	CharTemplate.ImmuneTypes.AddItem('Poison');
	CharTemplate.ImmuneTypes.AddItem(class'X2Item_DefaultDamageTypes'.default.ParthenogenicPoisonType);
	CharTemplate.ImmuneTypes.AddItem('Acid');

	CharTemplate.strHackIconImage = "UILibrary_Common.TargetIcons.Hack_captain_icon";
	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_Advent;

	return CharTemplate;
}

static function X2CharacterTemplate CreateTemplate_SpectralZombie(name CharTemplateName, name LoadoutName)
{
	local X2CharacterTemplate CharTemplate;

	CharTemplate = CreateTemplate_PsiZombie(CharTemplateName);
	CharTemplate.CharacterGroupName = 'SpectralZombie';

	CharTemplate.DefaultLoadout = LoadoutName;

	CharTemplate.strPawnArchetypes.Length = 0;
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_SpectralUnits.ARC_GameUnit_SpectralZombie_M");
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_SpectralUnits.ARC_GameUnit_SpectralZombie_F");

	CharTemplate.Abilities.AddItem('SpectralZombieInitialize');

	CharTemplate.ImmuneTypes.Length = 0;
	CharTemplate.ImmuneTypes.AddItem('Mental');
	CharTemplate.ImmuneTypes.AddItem('Fire');
	CharTemplate.ImmuneTypes.AddItem('Poison');
	CharTemplate.ImmuneTypes.AddItem(class'X2Item_DefaultDamageTypes'.default.ParthenogenicPoisonType);
	CharTemplate.ImmuneTypes.AddItem('Acid');

	return CharTemplate;
}
