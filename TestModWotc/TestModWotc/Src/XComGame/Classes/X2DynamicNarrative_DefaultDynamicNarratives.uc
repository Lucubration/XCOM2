//---------------------------------------------------------------------------------------
//  FILE:    X2DynamicNarrative_DefaultDynamicNarratives.uc
//  AUTHOR:  Joe Weinhoffer --  8/11/2016
//  PURPOSE: Defines the default set of dynamic narrative condition templates.
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class X2DynamicNarrative_DefaultDynamicNarratives extends X2DynamicNarrative
	config(GameData);

var const config int ChosenAbilityRoll;
var const config int TurnStartRoll;
var const config int XComAttacksRoll;
var const config int XComAttackedRoll;
var const config int ChosenAttackedRoll;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;
	
	// CONDITIONS
	Templates.AddItem(CreateIsEventSourcePlayerCondition('NarrativeCondition_IsEventSourceXComPlayer', eTeam_XCom));
	Templates.AddItem(CreateIsEventSourcePlayerCondition('NarrativeCondition_IsEventSourceAlienPlayer', eTeam_Alien));
	Templates.AddItem(CreateIsEventSourcePlayerCondition('NarrativeCondition_IsEventSourceLostPlayer', eTeam_TheLost));
	Templates.AddItem(CreateIsEventSourcePlayerCondition('NarrativeCondition_IsEventSourceResistancePlayer', eTeam_Resistance));

	Templates.AddItem(CreateIsAbilityCondition('NarrativeCondition_IsAbilityStandardMove', 'StandardMove'));
	Templates.AddItem(CreateIsAbilityCondition('NarrativeCondition_IsAbilitySwordSlice', 'SwordSlice'));
	Templates.AddItem(CreateIsAbilityCondition('NarrativeCondition_IsAbilityThrowGrenade', 'ThrowGrenade'));
	Templates.AddItem(CreateIsAbilityCondition('NarrativeCondition_IsAbilityRevive', 'Revive'));
	Templates.AddItem(CreateIsAbilityCondition('NarrativeCondition_IsAbilityChosenKidnapMove', 'ChosenKidnapMove'));
	Templates.AddItem(CreateIsAbilityCondition('NarrativeCondition_IsAbilityChosenKidnap', 'ChosenKidnap'));
	Templates.AddItem(CreateIsAbilityCondition('NarrativeCondition_IsAbilityChosenExtractKnowledgeMove', 'ChosenExtractKnowledgeMove'));
	Templates.AddItem(CreateIsAbilityCondition('NarrativeCondition_IsAbilityChosenExtractKnowledge', 'ChosenExtractKnowledge'));
	Templates.AddItem(CreateIsAbilityCondition('NarrativeCondition_IsAbilityChosenReveal', 'ChosenReveal'));
	Templates.AddItem(CreateIsAbilityCondition('NarrativeCondition_IsAbilityChosenDisengage', 'ChosenDisengage'));
	Templates.AddItem(CreateIsAbilityCondition('NarrativeCondition_IsAbilityChosenDefeatedSustain', 'ChosenDefeatedSustain'));
	Templates.AddItem(CreateIsAbilityCondition('NarrativeCondition_IsAbilityChosenDefeatedEscape', 'ChosenDefeatedEscape'));
	Templates.AddItem(CreateIsAbilityCondition('NarrativeCondition_IsAbilityChosenEngaged', 'ChosenEngaged'));
	Templates.AddItem(CreateIsAbilityCondition('NarrativeCondition_IsAbilityChosenSummonFollowers', 'ChosenSummonFollowers'));
	Templates.AddItem(CreateIsAbilityStandardShotCondition());
	Templates.AddItem(CreateIsAbilityStandardMeleeCondition());
	Templates.AddItem(CreateIsAbilityStandardGrenadeCondition());
	Templates.AddItem(CreateIsNotAbilityCondition('NarrativeCondition_IsAbilityNotSolaceCleanse', 'SolaceCleanse'));
	Templates.AddItem(CreateIsAbilityHostileCondition());

	Templates.AddItem(CreateIsAbilityWeaponMagneticCondition());
	Templates.AddItem(CreateIsAbilityWeaponBeamCondition());
	
	Templates.AddItem(CreateIsAbilityWeaponAlienHunterCondition());
	Templates.AddItem(CreateIsAbilityWeaponChosenCondition());

	Templates.AddItem(CreateIsAnyChosenEngagedCondition());
	Templates.AddItem(CreateAreTheLostActiveCondition());

	Templates.AddItem(CreateIsMissionCondition('NarrativeCondition_IsMissionBlacksite', 'AdventFacilityBLACKSITE'));
	Templates.AddItem(CreateIsMissionCondition('NarrativeCondition_IsMissionForge', 'AdventFacilityFORGE'));
	Templates.AddItem(CreateIsMissionCondition('NarrativeCondition_IsMissionPsiGate', 'AdventFacilityPSIGATE'));
	Templates.AddItem(CreateIsMissionCondition('NarrativeCondition_IsMissionBroadcast', 'CentralNetworkBroadcast'));
	Templates.AddItem(CreateIsMissionCondition('NarrativeCondition_IsMissionAvengerAssault', 'ChosenAvengerDefense'));
	Templates.AddItem(CreateIsMissionCondition('NarrativeCondition_IsMissionAlienFortress', 'AssaultFortressLeadup'));
	Templates.AddItem(CreateIsMissionCondition('NarrativeCondition_IsMissionAlienFortressShowdown', 'DestroyAvatarProject'));
	Templates.AddItem(CreateIsNotLostAndAbandonedMissionCondition());
	Templates.AddItem(CreateIsNotChosenShowdownMissionCondition());

	Templates.AddItem(CreateIsXComSufferingHeavyLossesCondition());
	Templates.AddItem(CreateIsXComSoldierDazedCondition());
	Templates.AddItem(CreateIsCurrentPlayerTurnCondition('NarrativeCondition_IsXComPlayerTurn', eTeam_XCom));
	Templates.AddItem(CreateIsCurrentPlayerTurnCondition('NarrativeCondition_IsAlienPlayerTurn', eTeam_Alien));
	Templates.AddItem(CreateIsCurrentPlayerTurnCondition('NarrativeCondition_IsLostPlayerTurn', eTeam_TheLost));
	Templates.AddItem(CreateIsCurrentPlayerTurnCondition('NarrativeCondition_IsResistancePlayerTurn', eTeam_Resistance));
	
	Templates.AddItem(CreateIsEventDataSoldierCondition());
	Templates.AddItem(CreateIsEventDataCivilianCondition());
	Templates.AddItem(CreateIsEventDataUnitAliveCondition());

	Templates.AddItem(CreateIsEventSourceSoldierCondition());
	Templates.AddItem(CreateIsEventSourceXComTeamCondition());
	Templates.AddItem(CreateIsEventSourceEnemyTeamCondition());
	Templates.AddItem(CreateIsEventSourceAlienTeamCondition());
	Templates.AddItem(CreateIsEventSourceLostTeamCondition());
	Templates.AddItem(CreateIsEventSourceChosenCondition());
	Templates.AddItem(CreateIsEventSourceUnitHealthyCondition());
	Templates.AddItem(CreateIsEventSourceUnitWoundedCondition());
	Templates.AddItem(CreateIsEventSourceUnitNotConcealedCondition());
	Templates.AddItem(CreateIsEventSourceChosenHasCaptiveSoldierCondition());
	Templates.AddItem(CreateIsEventSourceOtherChosenHaveCaptiveSoldiersCondition());
	Templates.AddItem(CreateIsEventSourceChosenXComRescuedSoldiersCondition());
	Templates.AddItem(CreateIsEventSourceChosenKnowledgeLevelCondition('NarrativeCondition_IsEventSourceChosenKnowledgeHuntingAvenger', eChosenKnowledge_Raider));
	Templates.AddItem(CreateIsEventSourceNumChosenRemainingCondition('NarrativeCondition_IsEventSourceLastChosen', 1));
	Templates.AddItem(CreateIsEventSourceNumChosenRemainingCondition('NarrativeCondition_IsEventSourceLastTwoChosen', 2));
	Templates.AddItem(CreateIsEventSourceChosenLastEncounterKilledCondition());	
	Templates.AddItem(CreateIsEventSourceChosenLastEncounterCapturedSoldierCondition());
	Templates.AddItem(CreateIsEventSourceChosenLastEncounterGainedKnowledgeCondition());
	Templates.AddItem(CreateIsEventSourceChosenLastEncounterHeavyXComLossesCondition());
	Templates.AddItem(CreateIsEventSourceOtherChosenLastEncounterKilledCondition());
	Templates.AddItem(CreateIsEventSourceOtherChosenLastEncounterDefeatedCondition());
	Templates.AddItem(CreateIsEventSourceOtherChosenLastEncounterBeatXComCondition());
	Templates.AddItem(CreateIsEventSourceOtherChosenLastEncounterBeatXComHeavyLossesCondition());
	
	Templates.AddItem(CreateIsEventSourceSoldierClassCondition('NarrativeCondition_IsEventSourceRanger', 'Ranger'));
	Templates.AddItem(CreateIsEventSourceSoldierClassCondition('NarrativeCondition_IsEventSourceSharpshooter', 'Sharpshooter'));
	Templates.AddItem(CreateIsEventSourceSoldierClassCondition('NarrativeCondition_IsEventSourceGrenadier', 'Grenadier'));
	Templates.AddItem(CreateIsEventSourceSoldierClassCondition('NarrativeCondition_IsEventSourceSpecialist', 'Specialist'));
	Templates.AddItem(CreateIsEventSourceSoldierClassCondition('NarrativeCondition_IsEventSourcePsiOperative', 'PsiOperative'));
	
	Templates.AddItem(CreateIsEventSourceCharacterCondition('NarrativeCondition_IsEventSourceSparkSoldier', 'SparkSoldier'));
	Templates.AddItem(CreateIsEventSourceCharacterCondition('NarrativeCondition_IsEventSourceReaperSoldier', 'ReaperSoldier'));
	Templates.AddItem(CreateIsEventSourceCharacterCondition('NarrativeCondition_IsEventSourceSkirmisherSoldier', 'SkirmisherSoldier'));
	Templates.AddItem(CreateIsEventSourceCharacterCondition('NarrativeCondition_IsEventSourceTemplarSoldier', 'TemplarSoldier'));
	Templates.AddItem(CreateIsEventSourceAdventPriestCondition());
	
	Templates.AddItem(CreateIsAbilityTargetSoldierCondition());
	Templates.AddItem(CreateIsAbilityTargetSoldierClassCondition('NarrativeCondition_IsAbilityTargetPsiOperative', 'PsiOperative'));
	Templates.AddItem(CreateIsAbilityTargetCharacterCondition('NarrativeCondition_IsAbilityTargetReaperSoldier', 'ReaperSoldier'));
	Templates.AddItem(CreateIsAbilityTargetCharacterCondition('NarrativeCondition_IsAbilityTargetSkirmisherSoldier', 'SkirmisherSoldier'));
	Templates.AddItem(CreateIsAbilityTargetCharacterCondition('NarrativeCondition_IsAbilityTargetTemplarSoldier', 'TemplarSoldier'));
	Templates.AddItem(CreateIsAbilityTargetUnitNameCondition('NarrativeCondition_IsAbilityTargetJaneKelly', "Jane Kelly"));
	Templates.AddItem(CreateIsAbilityTargetUnitNameCondition('NarrativeCondition_IsAbilityTargetElenaDragunova', "Elena Dragunova"));
	Templates.AddItem(CreateIsAbilityTargetUnitRankCondition('NarrativeCondition_IsAbilityTargetHighRankSoldier', class'X2StrategyGameRulesetDataStructures'.default.VeteranSoldierRank));
	Templates.AddItem(CreateIsAbilityTargetXComTeamCondition());
	Templates.AddItem(CreateIsAbilityTargetEnemyTeamCondition());
	Templates.AddItem(CreateIsAbilityTargetFromSquadsightCondition());
	Templates.AddItem(CreateIsAbilityTargetLastVisibleEnemyCondition());
	Templates.AddItem(CreateIsAbilityTargetIncapacitatedCondition());
	Templates.AddItem(CreateIsAbilityTargetAliveCondition());
	
	Templates.AddItem(CreateIsAbilitySourceXComTeamCondition());
	Templates.AddItem(CreateIsAbilitySourceEnemyTeamCondition());
	Templates.AddItem(CreateIsAbilitySourceNotTargetCondition());

	Templates.AddItem(CreateIsAbilityHitCondition());
	Templates.AddItem(CreateIsAbilityMissCondition());

	Templates.AddItem(CreateIsRollValueMetCondition('NarrativeCondition_IsChosenAbilityRollMet', default.ChosenAbilityRoll));
	Templates.AddItem(CreateIsRollValueMetCondition('NarrativeCondition_IsTurnStartRollMet', default.TurnStartRoll));
	Templates.AddItem(CreateIsRollValueMetCondition('NarrativeCondition_IsXComAttacksRollMet', default.XComAttacksRoll));
	Templates.AddItem(CreateIsRollValueMetCondition('NarrativeCondition_IsXComAttackedRollMet', default.XComAttackedRoll));
	Templates.AddItem(CreateIsRollValueMetCondition('NarrativeCondition_IsChosenAttackedRollMet', default.ChosenAttackedRoll));
			
	return Templates;
}

// #######################################################################################
// ----------------------- CONDITIONS ----------------------------------------------------
// #######################################################################################

static function X2DataTemplate CreateIsEventSourcePlayerCondition(name TemplateName, int TeamValue)
{
	local X2DynamicNarrativeConditionTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeConditionTemplate', Template, TemplateName);
	Template.IsConditionMetFn = CheckEventSourcePlayerTurn;
	Template.ConditionValue = TeamValue;

	return Template;
}

static function X2DataTemplate CreateIsAbilityCondition(name TemplateName, name AbilityName)
{
	local X2DynamicNarrativeConditionTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeConditionTemplate', Template, TemplateName);
	Template.IsConditionMetFn = CheckEventDataAbilityName;
	Template.ConditionNames.AddItem(AbilityName);

	return Template;
}

static function X2DataTemplate CreateIsNotAbilityCondition(name TemplateName, name AbilityName)
{
	local X2DynamicNarrativeConditionTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeConditionTemplate', Template, TemplateName);
	Template.IsConditionMetFn = CheckEventDataNotAbilityName;
	Template.ConditionNames.AddItem(AbilityName);

	return Template;
}

static function X2DataTemplate CreateIsAbilityHostileCondition()
{
	local X2DynamicNarrativeConditionTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeConditionTemplate', Template, 'NarrativeCondition_IsAbilityHostile');
	Template.IsConditionMetFn = CheckEventDataAbilityHostile;

	return Template;
}

static function X2DataTemplate CreateIsAbilityStandardShotCondition()
{
	local X2DynamicNarrativeConditionTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeConditionTemplate', Template, 'NarrativeCondition_IsAbilityStandardShot');
	Template.IsConditionMetFn = CheckEventDataAbilityName;
	Template.ConditionNames.AddItem('StandardShot');
	Template.ConditionNames.AddItem('StandardShot_NoEnd');
	Template.ConditionNames.AddItem('PistolStandardShot');
	Template.ConditionNames.AddItem('SniperStandardFire');

	return Template;
}

static function X2DataTemplate CreateIsAbilityStandardMeleeCondition()
{
	local X2DynamicNarrativeConditionTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeConditionTemplate', Template, 'NarrativeCondition_IsAbilityStandardMelee');
	Template.IsConditionMetFn = CheckEventDataAbilityName;
	Template.ConditionNames.AddItem('StandardMelee');
	Template.ConditionNames.AddItem('StandardMovingMelee');

	return Template;
}

static function X2DataTemplate CreateIsAbilityStandardGrenadeCondition()
{
	local X2DynamicNarrativeConditionTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeConditionTemplate', Template, 'NarrativeCondition_IsAbilityStandardGrenade');
	Template.IsConditionMetFn = CheckEventDataAbilityName;
	Template.ConditionNames.AddItem('ThrowGrenade');
	Template.ConditionNames.AddItem('LaunchGrenade');

	return Template;
}

static function X2DataTemplate CreateIsAbilityWeaponMagneticCondition()
{
	local X2DynamicNarrativeConditionTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeConditionTemplate', Template, 'NarrativeCondition_IsAbilityWeaponMagnetic');
	Template.IsConditionMetFn = CheckEventDataAbilityWeaponTech;
	Template.ConditionNames.AddItem('Magnetic');

	return Template;
}

static function X2DataTemplate CreateIsAbilityWeaponBeamCondition()
{
	local X2DynamicNarrativeConditionTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeConditionTemplate', Template, 'NarrativeCondition_IsAbilityWeaponBeam');
	Template.IsConditionMetFn = CheckEventDataAbilityWeaponTech;
	Template.ConditionNames.AddItem('Beam');

	return Template;
}

static function X2DataTemplate CreateIsAbilityWeaponNameCondition(name TemplateName, name WeaponName)
{
	local X2DynamicNarrativeConditionTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeConditionTemplate', Template, TemplateName);
	Template.IsConditionMetFn = CheckEventDataAbilityWeaponName;
	Template.ConditionNames.AddItem(WeaponName);

	return Template;
}

static function X2DataTemplate CreateIsAbilityWeaponAlienHunterCondition()
{
	local X2DynamicNarrativeConditionTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeConditionTemplate', Template, 'NarrativeCondition_IsAbilityWeaponAlienHunter');
	Template.IsConditionMetFn = CheckEventDataAbilityWeaponName;
	Template.ConditionNames.AddItem('AlienHunterRifle_CV');
	Template.ConditionNames.AddItem('AlienHunterRifle_MG');
	Template.ConditionNames.AddItem('AlienHunterRifle_BM');
	Template.ConditionNames.AddItem('AlienHunterPistol_CV');
	Template.ConditionNames.AddItem('AlienHunterPistol_MG');
	Template.ConditionNames.AddItem('AlienHunterPistol_BM');
	Template.ConditionNames.AddItem('AlienHunterAxe_CV');
	Template.ConditionNames.AddItem('AlienHunterAxe_MG');
	Template.ConditionNames.AddItem('AlienHunterAxe_BM');
	Template.ConditionNames.AddItem('AlienHunterAxeThrown_CV');
	Template.ConditionNames.AddItem('AlienHunterAxeThrown_MG');
	Template.ConditionNames.AddItem('AlienHunterAxeThrown_BM');

	return Template;
}

static function X2DataTemplate CreateIsAbilityWeaponChosenCondition()
{
	local X2DynamicNarrativeConditionTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeConditionTemplate', Template, 'NarrativeCondition_IsAbilityWeaponChosen');
	Template.IsConditionMetFn = CheckEventDataAbilityWeaponName;
	Template.ConditionNames.AddItem('ChosenRifle_XCOM');
	Template.ConditionNames.AddItem('ChosenShotgun_XCOM');
	Template.ConditionNames.AddItem('ChosenSword_XCOM');
	Template.ConditionNames.AddItem('ChosenSniperRifle_XCOM');
	Template.ConditionNames.AddItem('ChosenSniperPistol_XCOM');

	return Template;
}

static function X2DataTemplate CreateIsCharacterActiveCondition(name TemplateName, name ChosenName)
{
	local X2DynamicNarrativeConditionTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeConditionTemplate', Template, TemplateName);
	Template.IsConditionMetFn = CheckUnitActive;
	Template.ConditionNames.AddItem(ChosenName);

	return Template;
}

static function X2DataTemplate CreateIsChosenActiveCondition(name TemplateName, name ChosenName)
{
	local X2DynamicNarrativeConditionTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeConditionTemplate', Template, TemplateName);
	Template.IsConditionMetFn = CheckChosenActive;
	Template.ConditionNames.AddItem(ChosenName);

	return Template;
}

static function X2DataTemplate CreateIsChosenEngagedCondition(name TemplateName, name ChosenName)
{
	local X2DynamicNarrativeConditionTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeConditionTemplate', Template, TemplateName);
	Template.IsConditionMetFn = CheckChosenEngaged;
	Template.ConditionNames.AddItem(ChosenName);

	return Template;
}

static function X2DataTemplate CreateIsAnyChosenEngagedCondition()
{
	local X2DynamicNarrativeConditionTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeConditionTemplate', Template, 'NarrativeCondition_IsAnyChosenEngaged');
	Template.IsConditionMetFn = CheckAnyChosenEngaged;

	return Template;
}

static function X2DataTemplate CreateIsAlienActiveExcludeCharacterCondition(name TemplateName, name CharacterName)
{
	local X2DynamicNarrativeConditionTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeConditionTemplate', Template, TemplateName);
	Template.IsConditionMetFn = CheckAlienActiveExcludeCharacter;
	Template.ConditionNames.AddItem(CharacterName);

	return Template;
}

static function X2DataTemplate CreateAreTheLostActiveCondition()
{
	local X2DynamicNarrativeConditionTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeConditionTemplate', Template, 'NarrativeCondition_AreLostActive');
	Template.IsConditionMetFn = CheckUnitActive;
	Template.ConditionNames.AddItem('TheLost');
	Template.ConditionNames.AddItem('TheLostDasher');
	Template.ConditionNames.AddItem('TheLostHowler');

	return Template;
}

static function X2DataTemplate CreateIsMissionCondition(name TemplateName, name MissionName)
{
	local X2DynamicNarrativeConditionTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeConditionTemplate', Template, TemplateName);
	Template.IsConditionMetFn = CheckMissionName;
	Template.ConditionNames.AddItem(MissionName);

	return Template;
}

static function X2DataTemplate CreateIsNotMissionCondition(name TemplateName, name MissionName)
{
	local X2DynamicNarrativeConditionTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeConditionTemplate', Template, TemplateName);
	Template.IsConditionMetFn = CheckNotMissionName;
	Template.ConditionNames.AddItem(MissionName);

	return Template;
}

static function X2DataTemplate CreateIsNotLostAndAbandonedMissionCondition()
{
	local X2DynamicNarrativeConditionTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeConditionTemplate', Template, 'NarrativeCondition_IsMissionNotLostAndAbandoned');
	Template.IsConditionMetFn = CheckNotMissionName;
	Template.ConditionNames.AddItem('LostAndAbandonedA');
	Template.ConditionNames.AddItem('LostAndAbandonedB');
	Template.ConditionNames.AddItem('LostAndAbandonedC');

	return Template;
}

static function X2DataTemplate CreateIsNotChosenShowdownMissionCondition()
{
	local X2DynamicNarrativeConditionTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeConditionTemplate', Template, 'NarrativeCondition_IsNotChosenShowdownMission');
	Template.IsConditionMetFn = CheckNotMissionName;
	Template.ConditionNames.AddItem('ChosenShowdown_Assassin');
	Template.ConditionNames.AddItem('ChosenShowdown_Hunter');
	Template.ConditionNames.AddItem('ChosenShowdown_Warlock');

	return Template;
}

static function X2DataTemplate CreateIsXComSufferingHeavyLossesCondition()
{
	local X2DynamicNarrativeConditionTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeConditionTemplate', Template, 'NarrativeCondition_IsXComSufferingHeavyLosses');
	Template.IsConditionMetFn = CheckXComHasHeavyLosses;

	return Template;
}

static function X2DataTemplate CreateIsXComSoldierDazedCondition()
{
	local X2DynamicNarrativeConditionTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeConditionTemplate', Template, 'NarrativeCondition_IsXComSoldierDazedCondition');
	Template.IsConditionMetFn = CheckXComSoldierDazed;

	return Template;
}

static function X2DataTemplate CreateIsCurrentPlayerTurnCondition(name TemplateName, int TeamValue)
{
	local X2DynamicNarrativeConditionTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeConditionTemplate', Template, TemplateName);
	Template.IsConditionMetFn = CheckCurrentPlayerTurn;
	Template.ConditionValue = TeamValue;

	return Template;
}

static function X2DataTemplate CreateIsEventDataSoldierCondition()
{
	local X2DynamicNarrativeConditionTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeConditionTemplate', Template, 'NarrativeCondition_IsEventDataSoldier');
	Template.IsConditionMetFn = CheckEventDataSoldier;

	return Template;
}

static function X2DataTemplate CreateIsEventDataCivilianCondition()
{
	local X2DynamicNarrativeConditionTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeConditionTemplate', Template, 'NarrativeCondition_IsEventDataCivilian');
	Template.IsConditionMetFn = CheckEventDataCivilian;

	return Template;
}

static function X2DataTemplate CreateIsEventDataUnitAliveCondition()
{
	local X2DynamicNarrativeConditionTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeConditionTemplate', Template, 'NarrativeCondition_IsEventDataUnitAlive');
	Template.IsConditionMetFn = CheckEventDataUnitAlive;

	return Template;
}

static function X2DataTemplate CreateIsEventSourceSoldierCondition()
{
	local X2DynamicNarrativeConditionTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeConditionTemplate', Template, 'NarrativeCondition_IsEventSourceSoldier');
	Template.IsConditionMetFn = CheckEventSourceSoldier;

	return Template;
}

static function X2DataTemplate CreateIsEventSourceSoldierClassCondition(name TemplateName, name ClassName)
{
	local X2DynamicNarrativeConditionTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeConditionTemplate', Template, TemplateName);
	Template.IsConditionMetFn = CheckEventSourceSoldierClassName;
	Template.ConditionNames.AddItem(ClassName);

	return Template;
}

static function X2DataTemplate CreateIsEventSourceCharacterCondition(name TemplateName, name CharacterName)
{
	local X2DynamicNarrativeConditionTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeConditionTemplate', Template, TemplateName);
	Template.IsConditionMetFn = CheckEventSourceCharacterTemplateName;
	Template.ConditionNames.AddItem(CharacterName);

	return Template;
}

static function X2DataTemplate CreateIsEventSourceAdventPriestCondition()
{
	local X2DynamicNarrativeConditionTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeConditionTemplate', Template, 'NarrativeCondition_IsEventSourceAdventPriest');
	Template.IsConditionMetFn = CheckEventSourceCharacterTemplateName;
	Template.ConditionNames.AddItem('AdvPriestM1');
	Template.ConditionNames.AddItem('AdvPriestM2');
	Template.ConditionNames.AddItem('AdvPriestM3');
	Template.ConditionNames.AddItem('AdventPriest');

	return Template;
}

static function X2DataTemplate CreateIsEventSourceNotCharacterCondition(name TemplateName, name ChosenName)
{
	local X2DynamicNarrativeConditionTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeConditionTemplate', Template, TemplateName);
	Template.IsConditionMetFn = CheckEventSourceNotCharacterTemplateName;
	Template.ConditionNames.AddItem(ChosenName);

	return Template;
}

static function X2DataTemplate CreateIsEventSourceXComTeamCondition()
{
	local X2DynamicNarrativeConditionTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeConditionTemplate', Template, 'NarrativeCondition_IsEventSourceXComTeam');
	Template.IsConditionMetFn = CheckEventSourceXComTeam;

	return Template;
}

static function X2DataTemplate CreateIsEventSourceEnemyTeamCondition()
{
	local X2DynamicNarrativeConditionTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeConditionTemplate', Template, 'NarrativeCondition_IsEventSourceEnemyTeam');
	Template.IsConditionMetFn = CheckEventSourceEnemyTeam;

	return Template;
}

static function X2DataTemplate CreateIsEventSourceAlienTeamCondition()
{
	local X2DynamicNarrativeConditionTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeConditionTemplate', Template, 'NarrativeCondition_IsEventSourceAlienTeam');
	Template.IsConditionMetFn = CheckEventSourceAlienTeam;

	return Template;
}

static function X2DataTemplate CreateIsEventSourceLostTeamCondition()
{
	local X2DynamicNarrativeConditionTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeConditionTemplate', Template, 'NarrativeCondition_IsEventSourceLostTeam');
	Template.IsConditionMetFn = CheckEventSourceLostTeam;

	return Template;
}

static function X2DataTemplate CreateIsEventSourceChosenCondition()
{
	local X2DynamicNarrativeConditionTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeConditionTemplate', Template, 'NarrativeCondition_IsEventSourceChosen');
	Template.IsConditionMetFn = CheckEventSourceChosen;

	return Template;
}

static function X2DataTemplate CreateIsEventSourceUnitHealthyCondition()
{
	local X2DynamicNarrativeConditionTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeConditionTemplate', Template, 'NarrativeCondition_IsEventSourceUnitHealthy');
	Template.IsConditionMetFn = CheckEventSourceUnitHealthy;

	return Template;
}

static function X2DataTemplate CreateIsEventSourceUnitWoundedCondition()
{
	local X2DynamicNarrativeConditionTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeConditionTemplate', Template, 'NarrativeCondition_IsEventSourceUnitWounded');
	Template.IsConditionMetFn = CheckEventSourceUnitWounded;

	return Template;
}

static function X2DataTemplate CreateIsEventSourceUnitNotConcealedCondition()
{
	local X2DynamicNarrativeConditionTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeConditionTemplate', Template, 'NarrativeCondition_IsEventSourceUnitNotConcealed');
	Template.IsConditionMetFn = CheckEventSourceUnitNotConcealed;

	return Template;
}

static function X2DataTemplate CreateIsEventSourceChosenHasCaptiveSoldierCondition()
{
	local X2DynamicNarrativeConditionTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeConditionTemplate', Template, 'NarrativeCondition_IsEventSourceChosenHasCaptiveSoldier');
	Template.IsConditionMetFn = CheckEventSourceChosenHasCaptiveSoldier;

	return Template;
}

static function X2DataTemplate CreateIsEventSourceOtherChosenHaveCaptiveSoldiersCondition()
{
	local X2DynamicNarrativeConditionTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeConditionTemplate', Template, 'NarrativeCondition_IsEventSourceOtherChosenHaveCaptiveSoldiers');
	Template.IsConditionMetFn = CheckEventSourceOtherChosenHaveCaptiveSoldiers;

	return Template;
}

static function X2DataTemplate CreateIsEventSourceChosenXComRescuedSoldiersCondition()
{
	local X2DynamicNarrativeConditionTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeConditionTemplate', Template, 'NarrativeCondition_IsEventSourceChosenXComRescuedSoldiers');
	Template.IsConditionMetFn = CheckEventSourceChosenXComRescuedSoldiers;

	return Template;
}

static function X2DataTemplate CreateIsEventSourceChosenKnowledgeLevelCondition(name TemplateName, int KnowledgeLevel)
{
	local X2DynamicNarrativeConditionTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeConditionTemplate', Template, TemplateName);
	Template.IsConditionMetFn = CheckEventSourceChosenKnowledgeLevel;
	Template.ConditionValue = KnowledgeLevel;

	return Template;
}

static function X2DataTemplate CreateIsEventSourceNumChosenRemainingCondition(name TemplateName, int NumChosen)
{
	local X2DynamicNarrativeConditionTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeConditionTemplate', Template, TemplateName);
	Template.IsConditionMetFn = CheckEventSourceNumChosenRemaining;
	Template.ConditionValue = NumChosen;

	return Template;
}

static function X2DataTemplate CreateIsEventSourceChosenLastEncounterKilledCondition()
{
	local X2DynamicNarrativeConditionTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeConditionTemplate', Template, 'NarrativeCondition_IsEventSourceChosenLastEncounterKilled');
	Template.IsConditionMetFn = CheckEventSourceChosenLastEncounterKilled;

	return Template;
}

static function X2DataTemplate CreateIsEventSourceChosenLastEncounterCapturedSoldierCondition()
{
	local X2DynamicNarrativeConditionTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeConditionTemplate', Template, 'NarrativeCondition_IsEventSourceChosenLastEncounterCapturedSoldier');
	Template.IsConditionMetFn = CheckEventSourceChosenLastEncounterCapturedSoldier;

	return Template;
}

static function X2DataTemplate CreateIsEventSourceChosenLastEncounterGainedKnowledgeCondition()
{
	local X2DynamicNarrativeConditionTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeConditionTemplate', Template, 'NarrativeCondition_IsEventSourceChosenLastEncounterGainedKnowledge');
	Template.IsConditionMetFn = CheckEventSourceChosenLastEncounterGainedKnowledge;

	return Template;
}

static function X2DataTemplate CreateIsEventSourceChosenLastEncounterHeavyXComLossesCondition()
{
	local X2DynamicNarrativeConditionTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeConditionTemplate', Template, 'NarrativeCondition_IsEventSourceChosenLastEncounterHeavyXComLosses');
	Template.IsConditionMetFn = CheckEventSourceChosenLastEncounterHeavyXComLosses;

	return Template;
}

static function X2DataTemplate CreateIsEventSourceOtherChosenLastEncounterKilledCondition()
{
	local X2DynamicNarrativeConditionTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeConditionTemplate', Template, 'NarrativeCondition_IsEventSourceOtherChosenLastEncounterKilled');
	Template.IsConditionMetFn = CheckEventSourceOtherChosenLastEncounterKilled;

	return Template;
}

static function X2DataTemplate CreateIsEventSourceOtherChosenLastEncounterDefeatedCondition()
{
	local X2DynamicNarrativeConditionTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeConditionTemplate', Template, 'NarrativeCondition_IsEventSourceOtherChosenLastEncounterDefeated');
	Template.IsConditionMetFn = CheckEventSourceOtherChosenLastEncounterDefeated;

	return Template;
}

static function X2DataTemplate CreateIsEventSourceOtherChosenLastEncounterBeatXComCondition()
{
	local X2DynamicNarrativeConditionTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeConditionTemplate', Template, 'NarrativeCondition_IsEventSourceOtherChosenLastEncounterBeatXCom');
	Template.IsConditionMetFn = CheckEventSourceOtherChosenLastEncounterBeatXCom;

	return Template;
}

static function X2DataTemplate CreateIsEventSourceOtherChosenLastEncounterBeatXComHeavyLossesCondition()
{
	local X2DynamicNarrativeConditionTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeConditionTemplate', Template, 'NarrativeCondition_IsEventSourceOtherChosenLastEncounterBeatXComHeavyLosses');
	Template.IsConditionMetFn = CheckEventSourceOtherChosenLastEncounterBeatXComHeavyLosses;

	return Template;
}

static function X2DataTemplate CreateIsAbilityTargetSoldierCondition()
{
	local X2DynamicNarrativeConditionTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeConditionTemplate', Template, 'NarrativeCondition_IsAbilityTargetSoldier');
	Template.IsConditionMetFn = CheckAbilityContextTargetSoldier;

	return Template;
}

static function X2DataTemplate CreateIsAbilityTargetSoldierClassCondition(name TemplateName, name ClassName)
{
	local X2DynamicNarrativeConditionTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeConditionTemplate', Template, TemplateName);
	Template.IsConditionMetFn = CheckAbilityContextTargetSoldierClassName;
	Template.ConditionNames.AddItem(ClassName);

	return Template;
}

static function X2DataTemplate CreateIsAbilityTargetCharacterCondition(name TemplateName, name CharacterName)
{
	local X2DynamicNarrativeConditionTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeConditionTemplate', Template, TemplateName);
	Template.IsConditionMetFn = CheckAbilityContextTargetCharacterTemplateName;
	Template.ConditionNames.AddItem(CharacterName);

	return Template;
}

static function X2DataTemplate CreateIsAbilityTargetNotCharacterCondition(name TemplateName, name CharacterName)
{
	local X2DynamicNarrativeConditionTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeConditionTemplate', Template, TemplateName);
	Template.IsConditionMetFn = CheckAbilityContextTargetNotCharacterTemplateName;
	Template.ConditionNames.AddItem(CharacterName);

	return Template;
}

static function X2DataTemplate CreateIsAbilityTargetUnitNameCondition(name TemplateName, string CharacterName)
{
	local X2DynamicNarrativeConditionTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeConditionTemplate', Template, TemplateName);
	Template.IsConditionMetFn = CheckAbilityContextTargetUnitName;
	Template.ConditionStrings.AddItem(CharacterName);

	return Template;
}

static function X2DataTemplate CreateIsAbilityTargetUnitRankCondition(name TemplateName, int UnitRank)
{
	local X2DynamicNarrativeConditionTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeConditionTemplate', Template, TemplateName);
	Template.IsConditionMetFn = CheckAbilityContextTargetUnitRank;
	Template.ConditionValue = UnitRank;

	return Template;
}

static function X2DataTemplate CreateIsAbilityTargetXComTeamCondition()
{
	local X2DynamicNarrativeConditionTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeConditionTemplate', Template, 'NarrativeCondition_IsAbilityTargetXComTeam');
	Template.IsConditionMetFn = CheckAbilityContextTargetXComTeam;

	return Template;
}

static function X2DataTemplate CreateIsAbilityTargetEnemyTeamCondition()
{
	local X2DynamicNarrativeConditionTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeConditionTemplate', Template, 'NarrativeCondition_IsAbilityTargetEnemyTeam');
	Template.IsConditionMetFn = CheckAbilityContextTargetEnemyTeam;

	return Template;
}

static function X2DataTemplate CreateIsAbilityTargetFromSquadsightCondition()
{
	local X2DynamicNarrativeConditionTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeConditionTemplate', Template, 'NarrativeCondition_IsAbilityTargetFromSquadsight');
	Template.IsConditionMetFn = CheckAbilityContextTargetSquadsight;

	return Template;
}

static function X2DataTemplate CreateIsAbilityTargetLastVisibleEnemyCondition()
{
	local X2DynamicNarrativeConditionTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeConditionTemplate', Template, 'NarrativeCondition_IsAbilityTargetLastVisibleEnemy');
	Template.IsConditionMetFn = CheckAbilityContextTargetLastVisibleEnemy;

	return Template;
}

static function X2DataTemplate CreateIsAbilityTargetIncapacitatedCondition()
{
	local X2DynamicNarrativeConditionTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeConditionTemplate', Template, 'NarrativeCondition_IsAbilityTargetIncapacitated');
	Template.IsConditionMetFn = CheckAbilityContextTargetIncapacitated;

	return Template;
}

static function X2DataTemplate CreateIsAbilityTargetAliveCondition()
{
	local X2DynamicNarrativeConditionTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeConditionTemplate', Template, 'NarrativeCondition_IsAbilityTargetAlive');
	Template.IsConditionMetFn = CheckAbilityContextTargetAlive;

	return Template;
}

static function X2DataTemplate CreateIsAbilitySourceCharacterCondition(name TemplateName, name CharacterName)
{
	local X2DynamicNarrativeConditionTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeConditionTemplate', Template, TemplateName);
	Template.IsConditionMetFn = CheckAbilityContextSourceCharacterTemplateName;
	Template.ConditionNames.AddItem(CharacterName);

	return Template;
}

static function X2DataTemplate CreateIsAbilitySourceNotCharacterCondition(name TemplateName, name CharacterName)
{
	local X2DynamicNarrativeConditionTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeConditionTemplate', Template, TemplateName);
	Template.IsConditionMetFn = CheckAbilityContextSourceNotCharacterTemplateName;
	Template.ConditionNames.AddItem(CharacterName);

	return Template;
}

static function X2DataTemplate CreateIsAbilitySourceXComTeamCondition()
{
	local X2DynamicNarrativeConditionTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeConditionTemplate', Template, 'NarrativeCondition_IsAbilitySourceXComTeam');
	Template.IsConditionMetFn = CheckAbilityContextSourceXComTeam;

	return Template;
}

static function X2DataTemplate CreateIsAbilitySourceEnemyTeamCondition()
{
	local X2DynamicNarrativeConditionTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeConditionTemplate', Template, 'NarrativeCondition_IsAbilitySourceEnemyTeam');
	Template.IsConditionMetFn = CheckAbilityContextSourceEnemyTeam;

	return Template;
}

static function X2DataTemplate CreateIsAbilitySourceNotTargetCondition()
{
	local X2DynamicNarrativeConditionTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeConditionTemplate', Template, 'NarrativeCondition_IsAbilitySourceNotTarget');
	Template.IsConditionMetFn = CheckAbilityContextSourceNotTarget;

	return Template;
}

static function X2DataTemplate CreateIsAbilityHitCondition()
{
	local X2DynamicNarrativeConditionTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeConditionTemplate', Template, 'NarrativeCondition_IsAbilityHit');
	Template.IsConditionMetFn = CheckAbilityContextHit;

	return Template;
}

static function X2DataTemplate CreateIsAbilityMissCondition()
{
	local X2DynamicNarrativeConditionTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeConditionTemplate', Template, 'NarrativeCondition_IsAbilityMiss');
	Template.IsConditionMetFn = CheckAbilityContextMiss;

	return Template;
}

static function X2DataTemplate CreateIsRollValueMetCondition(name TemplateName, int RollValue)
{
	local X2DynamicNarrativeConditionTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DynamicNarrativeConditionTemplate', Template, TemplateName);
	Template.IsConditionMetFn = CheckRollValue;
	Template.ConditionValue = RollValue;

	return Template;
}

// #######################################################################################
// ----------------------- CONDITION FUNCTIONS -------------------------------------------
// #######################################################################################

static function bool CheckUnitActive(X2DynamicNarrativeConditionTemplate Template, Object EventData, Object EventSource, XComGameState GameState)
{
	local XComGameStateHistory History;
	local XComGameState_Unit UnitState;

	History = `XCOMHISTORY;

	foreach History.IterateByClassType(class'XComGameState_Unit', UnitState)
	{
		if (!UnitState.bRemovedFromPlay && UnitState.IsAlive() && UnitState.GetCurrentStat(eStat_AlertLevel) >= `ALERT_LEVEL_YELLOW && Template.ConditionNames.Find(UnitState.GetMyTemplateGroupName()) != INDEX_NONE)
		{
			return true;
		}
	}

	return false;
}

static function bool CheckChosenActive(X2DynamicNarrativeConditionTemplate Template, Object EventData, Object EventSource, XComGameState GameState)
{
	local XComGameStateHistory History;
	local XComGameState_Unit UnitState;
	local UnitValue ActivationValue;

	History = `XCOMHISTORY;

	foreach History.IterateByClassType(class'XComGameState_Unit', UnitState)
	{
		UnitState.GetUnitValue(class'XComGameState_AdventChosen'.default.ChosenActivatedStateUnitValue, ActivationValue);
		if (!UnitState.bRemovedFromPlay && UnitState.IsAlive() && ActivationValue.fValue >= class'XComGameState_AdventChosen'.const.CHOSEN_STATE_ACTIVATED && Template.ConditionNames.Find(UnitState.GetMyTemplateGroupName()) != INDEX_NONE)
		{
			return true;
		}
	}

	return false;
}

static function bool CheckChosenEngaged(X2DynamicNarrativeConditionTemplate Template, Object EventData, Object EventSource, XComGameState GameState)
{
	local XComGameStateHistory History;
	local XComGameState_Unit UnitState;
	local UnitValue ActivationValue;

	History = `XCOMHISTORY;

	foreach History.IterateByClassType(class'XComGameState_Unit', UnitState)
	{
		UnitState.GetUnitValue(class'XComGameState_AdventChosen'.default.ChosenActivatedStateUnitValue, ActivationValue);
		if (!UnitState.bRemovedFromPlay && UnitState.IsAlive() && ActivationValue.fValue >= class'XComGameState_AdventChosen'.const.CHOSEN_STATE_ENGAGED && Template.ConditionNames.Find(UnitState.GetMyTemplateGroupName()) != INDEX_NONE)
		{
			return true;
		}
	}

	return false;
}

static function bool CheckAnyChosenEngaged(X2DynamicNarrativeConditionTemplate Template, Object EventData, Object EventSource, XComGameState GameState)
{
	local XComGameStateHistory History;
	local XComGameState_Unit UnitState;

	History = `XCOMHISTORY;

	foreach History.IterateByClassType(class'XComGameState_Unit', UnitState)
	{
		if (UnitState.IsEngagedChosen())
		{
			return true;
		}
	}

	return false;
}

static function bool CheckAlienActiveExcludeCharacter(X2DynamicNarrativeConditionTemplate Template, Object EventData, Object EventSource, XComGameState GameState)
{
	local XComGameStateHistory History;
	local XComGameState_Unit UnitState;

	History = `XCOMHISTORY;

	foreach History.IterateByClassType(class'XComGameState_Unit', UnitState)
	{
		if (UnitState.GetTeam() == eTeam_Alien && !UnitState.bRemovedFromPlay && UnitState.IsAlive() && UnitState.GetCurrentStat(eStat_AlertLevel) >= `ALERT_LEVEL_YELLOW && 
			Template.ConditionNames.Find(UnitState.GetMyTemplateGroupName()) == INDEX_NONE)
		{
			return true;
		}
	}

	return false;
}

static function bool CheckMissionName(X2DynamicNarrativeConditionTemplate Template, Object EventData, Object EventSource, XComGameState GameState)
{
	if (Template.ConditionNames.Find(`TACTICALMISSIONMGR.ActiveMission.MissionName) != INDEX_NONE)
	{
		return true;
	}
	
	return false;
}

static function bool CheckNotMissionName(X2DynamicNarrativeConditionTemplate Template, Object EventData, Object EventSource, XComGameState GameState)
{
	if (Template.ConditionNames.Find(`TACTICALMISSIONMGR.ActiveMission.MissionName) == INDEX_NONE)
	{
		return true;
	}

	return false;
}

static function bool CheckXComHasHeavyLosses(X2DynamicNarrativeConditionTemplate Template, Object EventData, Object EventSource, XComGameState GameState)
{
	local XComGameStateHistory History;
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_Unit UnitState;
	local StateObjectReference UnitRef;
	local int NumSquad, NumDead;

	History = `XCOMHISTORY;
	XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom', true));
	if (XComHQ != none)
	{
		foreach XComHQ.Squad(UnitRef)
		{
			UnitState = XComGameState_Unit(History.GetGameStateForObjectID(UnitRef.ObjectID));
			if (UnitState != none)
			{
				NumSquad++;
				if (UnitState.IsDead())
				{
					NumDead++;
				}
			}
		}
		
		if (NumDead > (NumSquad / 2))
		{
			return true;
		}
	}

	return false;
}

static function bool CheckXComSoldierDazed(X2DynamicNarrativeConditionTemplate Template, Object EventData, Object EventSource, XComGameState GameState)
{
	local XComGameStateHistory History;
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_Unit UnitState;
	local StateObjectReference UnitRef;

	History = `XCOMHISTORY;
	XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom', true));
	if (XComHQ != none)
	{
		foreach XComHQ.Squad(UnitRef)
		{
			UnitState = XComGameState_Unit(History.GetGameStateForObjectID(UnitRef.ObjectID));
			if (UnitState != none && UnitState.IsDazed())
			{
				return true;
			}
		}
	}

	return false;
}

static function bool CheckCurrentPlayerTurn(X2DynamicNarrativeConditionTemplate Template, Object EventData, Object EventSource, XComGameState GameState)
{
	local XComGameState_Player PlayerState;
	local StateObjectReference PlayerRef;
	
	PlayerRef = `TACTICALRULES.GetCachedUnitActionPlayerRef();
	PlayerState = XComGameState_Player(`XCOMHISTORY.GetGameStateForObjectID(PlayerRef.ObjectID));
	if (PlayerState != none && PlayerState.GetTeam() == Template.ConditionValue)
	{
		return true;
	}

	return false;
}

//---------------------------------------------------------------------------------------
// EVENT DATA
//---------------------------------------------------------------------------------------
static function bool CheckEventDataSoldier(X2DynamicNarrativeConditionTemplate Template, Object EventData, Object EventSource, XComGameState GameState)
{
	local XComGameState_Unit UnitState;

	UnitState = XComGameState_Unit(EventData);
	if (UnitState != none && UnitState.IsSoldier())
	{
		return true;
	}

	return false;
}

static function bool CheckEventDataCivilian(X2DynamicNarrativeConditionTemplate Template, Object EventData, Object EventSource, XComGameState GameState)
{
	local XComGameState_Unit UnitState;

	UnitState = XComGameState_Unit(EventData);
	if (UnitState != none && UnitState.IsCivilian())
	{
		return true;
	}

	return false;
}

static function bool CheckEventDataUnitAlive(X2DynamicNarrativeConditionTemplate Template, Object EventData, Object EventSource, XComGameState GameState)
{
	local XComGameState_Unit UnitState;

	UnitState = XComGameState_Unit(EventData);
	if (UnitState != none && UnitState.IsAlive())
	{
		return true;
	}

	return false;
}

static function bool CheckEventDataAbilityName(X2DynamicNarrativeConditionTemplate Template, Object EventData, Object EventSource, XComGameState GameState)
{
	local XComGameState_Ability AbilityState;

	AbilityState = XComGameState_Ability(EventData);
	if (AbilityState != none && Template.ConditionNames.Find(AbilityState.GetMyTemplateName()) != INDEX_NONE)
	{
		return true;
	}

	return false;
}

static function bool CheckEventDataNotAbilityName(X2DynamicNarrativeConditionTemplate Template, Object EventData, Object EventSource, XComGameState GameState)
{
	local XComGameState_Ability AbilityState;

	AbilityState = XComGameState_Ability(EventData);
	if (AbilityState != none && Template.ConditionNames.Find(AbilityState.GetMyTemplateName()) == INDEX_NONE)
	{
		return true;
	}

	return false;
}

static function bool CheckEventDataAbilityHostile(X2DynamicNarrativeConditionTemplate Template, Object EventData, Object EventSource, XComGameState GameState)
{
	local XComGameState_Ability AbilityState;

	AbilityState = XComGameState_Ability(EventData);
	if (AbilityState != none && AbilityState.GetMyTemplate().Hostility == eHostility_Offensive)
	{
		return true;
	}

	return false;
}

static function bool CheckEventDataAbilityWeaponName(X2DynamicNarrativeConditionTemplate Template, Object EventData, Object EventSource, XComGameState GameState)
{
	local XComGameState_Ability AbilityState;
	local XComGameState_Item WeaponState;

	AbilityState = XComGameState_Ability(EventData);
	if (AbilityState != none)
	{
		WeaponState = XComGameState_Item(`XCOMHISTORY.GetGameStateForObjectID(AbilityState.SourceWeapon.ObjectID));
		if (WeaponState != none && Template.ConditionNames.Find(WeaponState.GetMyTemplateName()) != INDEX_NONE)
		{
			return true;
		}
	}

	return false;
}

static function bool CheckEventDataAbilityWeaponTech(X2DynamicNarrativeConditionTemplate Template, Object EventData, Object EventSource, XComGameState GameState)
{
	local XComGameState_Ability AbilityState;

	AbilityState = XComGameState_Ability(EventData);
	if (AbilityState != none && Template.ConditionNames.Find(AbilityState.GetWeaponTech()) != INDEX_NONE)
	{
		return true;
	}

	return false;
}

//---------------------------------------------------------------------------------------
// EVENT SOURCE
//---------------------------------------------------------------------------------------
static function bool CheckEventSourcePlayerTurn(X2DynamicNarrativeConditionTemplate Template, Object EventData, Object EventSource, XComGameState GameState)
{
	local XComGameState_Player PlayerState;

	PlayerState = XComGameState_Player(EventSource);
	if (PlayerState != none && PlayerState.TeamFlag == Template.ConditionValue)
	{
		return true;
	}

	return false;
}

static function bool CheckEventSourceSoldier(X2DynamicNarrativeConditionTemplate Template, Object EventData, Object EventSource, XComGameState GameState)
{
	local XComGameState_Unit UnitState;

	UnitState = GetEventSourceUnitState(EventSource);
	if (UnitState != none && UnitState.IsSoldier())
	{
		return true;
	}

	return false;
}

static function bool CheckEventSourceCharacterTemplateName(X2DynamicNarrativeConditionTemplate Template, Object EventData, Object EventSource, XComGameState GameState)
{
	local XComGameState_Unit UnitState;
	
	UnitState = GetEventSourceUnitState(EventSource);
	if (UnitState != none && Template.ConditionNames.Find(UnitState.GetMyTemplateGroupName()) != INDEX_NONE)
	{
		return true;
	}

	return false;
}

static function bool CheckEventSourceNotCharacterTemplateName(X2DynamicNarrativeConditionTemplate Template, Object EventData, Object EventSource, XComGameState GameState)
{
	return !CheckEventSourceCharacterTemplateName(Template, EventData, EventSource, GameState);
}

static function bool CheckEventSourceSoldierClassName(X2DynamicNarrativeConditionTemplate Template, Object EventData, Object EventSource, XComGameState GameState)
{
	local XComGameState_Unit UnitState;

	UnitState = GetEventSourceUnitState(EventSource);
	if (UnitState != none && UnitState.IsSoldier() && Template.ConditionNames.Find(UnitState.GetSoldierClassTemplateName()) != INDEX_NONE)
	{
		return true;
	}

	return false;
}

static function bool CheckEventSourceXComTeam(X2DynamicNarrativeConditionTemplate Template, Object EventData, Object EventSource, XComGameState GameState)
{
	local XComGameState_Unit UnitState;

	UnitState = GetEventSourceUnitState(EventSource);
	if (UnitState != none && UnitState.GetTeam() == eTeam_XCom)
	{
		return true;
	}

	return false;
}

static function bool CheckEventSourceEnemyTeam(X2DynamicNarrativeConditionTemplate Template, Object EventData, Object EventSource, XComGameState GameState)
{
	local XComGameState_Unit UnitState;

	UnitState = GetEventSourceUnitState(EventSource);
	if (UnitState != none && (UnitState.GetTeam() == eTeam_Alien || UnitState.GetTeam() == eTeam_TheLost))
	{
		return true;
	}

	return false;
}

static function bool CheckEventSourceAlienTeam(X2DynamicNarrativeConditionTemplate Template, Object EventData, Object EventSource, XComGameState GameState)
{
	local XComGameState_Unit UnitState;

	UnitState = GetEventSourceUnitState(EventSource);
	if (UnitState != none && UnitState.GetTeam() == eTeam_Alien)
	{
		return true;
	}

	return false;
}

static function bool CheckEventSourceLostTeam(X2DynamicNarrativeConditionTemplate Template, Object EventData, Object EventSource, XComGameState GameState)
{
	local XComGameState_Unit UnitState;

	UnitState = GetEventSourceUnitState(EventSource);
	if (UnitState != none && UnitState.GetTeam() == eTeam_TheLost)
	{
		return true;
	}

	return false;
}

static function bool CheckEventSourceChosen(X2DynamicNarrativeConditionTemplate Template, Object EventData, Object EventSource, XComGameState GameState)
{
	local XComGameState_Unit UnitState;

	UnitState = GetEventSourceUnitState(EventSource);
	if (UnitState != none && UnitState.IsChosen())
	{
		return true;
	}

	return false;
}

static function bool CheckEventSourceUnitHealthy(X2DynamicNarrativeConditionTemplate Template, Object EventData, Object EventSource, XComGameState GameState)
{
	local XComGameState_Unit UnitState;

	UnitState = GetEventSourceUnitState(EventSource);
	if (UnitState != none && !UnitState.IsInjured())
	{
		return true;
	}

	return false;
}

static function bool CheckEventSourceUnitWounded(X2DynamicNarrativeConditionTemplate Template, Object EventData, Object EventSource, XComGameState GameState)
{
	local XComGameState_Unit UnitState;

	UnitState = GetEventSourceUnitState(EventSource);
	if (UnitState != none && UnitState.IsInjured())
	{
		return true;
	}

	return false;
}

static function bool CheckEventSourceUnitNotConcealed(X2DynamicNarrativeConditionTemplate Template, Object EventData, Object EventSource, XComGameState GameState)
{
	local XComGameState_Unit UnitState;

	UnitState = GetEventSourceUnitState(EventSource);
	if (UnitState != none && !UnitState.IsConcealed())
	{
		return true;
	}

	return false;
}

static function bool CheckEventSourceChosenHasCaptiveSoldier(X2DynamicNarrativeConditionTemplate Template, Object EventData, Object EventSource, XComGameState GameState)
{
	local XComGameState_AdventChosen ChosenState;

	ChosenState = GetEventSourceChosen(EventSource);
	if (ChosenState != none && ChosenState.GetNumSoldiersCaptured() > 0)
	{
		return true;
	}

	return false;
}

static function bool CheckEventSourceOtherChosenHaveCaptiveSoldiers(X2DynamicNarrativeConditionTemplate Template, Object EventData, Object EventSource, XComGameState GameState)
{
	local XComGameState_HeadquartersAlien AlienHQ;
	local XComGameState_AdventChosen ChosenState, OtherChosen;
	local array<XComGameState_AdventChosen> AllChosen;

	AlienHQ = XComGameState_HeadquartersAlien(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersAlien', true));
	if (AlienHQ != none)
	{
		ChosenState = AlienHQ.GetChosenOfTemplate(XComGameState_Unit(EventSource).GetMyTemplateGroupName());
		if (ChosenState != none && ChosenState.GetNumSoldiersCaptured() == 0) // Ensure that the unit triggering this event is one of the Chosen who has no captured soldiers
		{
			AllChosen = AlienHQ.GetAllChosen();
			foreach AllChosen(OtherChosen) // Then check all of the other Chosen to see if they have captured soldiers
			{
				if (OtherChosen.ObjectID != ChosenState.ObjectID && OtherChosen.GetNumSoldiersCaptured() > 0)
				{
					return true;
				}
			}
		}
	}

	return false;
}

static function bool CheckEventSourceChosenXComRescuedSoldiers(X2DynamicNarrativeConditionTemplate Template, Object EventData, Object EventSource, XComGameState GameState)
{
	local XComGameState_AdventChosen ChosenState;

	ChosenState = GetEventSourceChosen(EventSource);
	if (ChosenState != none && ChosenState.TotalCapturedSoldiers > ChosenState.GetNumSoldiersCaptured())
	{
		return true;
	}

	return false;
}

static function bool CheckEventSourceChosenKnowledgeLevel(X2DynamicNarrativeConditionTemplate Template, Object EventData, Object EventSource, XComGameState GameState)
{
	local XComGameState_AdventChosen ChosenState;

	ChosenState = GetEventSourceChosen(EventSource);
	if (ChosenState != none && ChosenState.GetKnowledgeLevel() >= Template.ConditionValue)
	{
		return true;
	}

	return false;
}

static function bool CheckEventSourceNumChosenRemaining(X2DynamicNarrativeConditionTemplate Template, Object EventData, Object EventSource, XComGameState GameState)
{
	local XComGameState_HeadquartersAlien AlienHQ;
	
	AlienHQ = XComGameState_HeadquartersAlien(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersAlien', true));
	if(AlienHQ != none && AlienHQ.GetNumLivingChosen() == Template.ConditionValue)
	{
		return true;
	}

	return false;
}

static function bool CheckEventSourceChosenLastEncounterKilled(X2DynamicNarrativeConditionTemplate Template, Object EventData, Object EventSource, XComGameState GameState)
{
	local XComGameState_AdventChosen ChosenState;

	ChosenState = GetEventSourceChosen(EventSource);
	if (ChosenState != none && ChosenState.LastEncounter.bKilled)
	{
		return true;
	}

	return false;
}

static function bool CheckEventSourceChosenLastEncounterCapturedSoldier(X2DynamicNarrativeConditionTemplate Template, Object EventData, Object EventSource, XComGameState GameState)
{
	local XComGameState_AdventChosen ChosenState;

	ChosenState = GetEventSourceChosen(EventSource);
	if (ChosenState != none && ChosenState.LastEncounter.bCapturedSoldier)
	{
		return true;
	}

	return false;
}

static function bool CheckEventSourceChosenLastEncounterGainedKnowledge(X2DynamicNarrativeConditionTemplate Template, Object EventData, Object EventSource, XComGameState GameState)
{
	local XComGameState_AdventChosen ChosenState;

	ChosenState = GetEventSourceChosen(EventSource);
	if (ChosenState != none && ChosenState.LastEncounter.bGainedKnowledge)
	{
		return true;
	}

	return false;
}

static function bool CheckEventSourceChosenLastEncounterHeavyXComLosses(X2DynamicNarrativeConditionTemplate Template, Object EventData, Object EventSource, XComGameState GameState)
{
	local XComGameState_AdventChosen ChosenState;

	ChosenState = GetEventSourceChosen(EventSource);
	if (ChosenState != none && ChosenState.LastEncounter.bHeavyLosses)
	{
		return true;
	}

	return false;
}

static function bool CheckEventSourceOtherChosenLastEncounterKilled(X2DynamicNarrativeConditionTemplate Template, Object EventData, Object EventSource, XComGameState GameState)
{
	local XComGameState_HeadquartersAlien AlienHQ;
	local XComGameState_AdventChosen ChosenState;
	
	AlienHQ = XComGameState_HeadquartersAlien(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersAlien', true));
	if (AlienHQ != none)
	{
		ChosenState = AlienHQ.GetChosenOfTemplate(XComGameState_Unit(EventSource).GetMyTemplateGroupName());
		if (ChosenState != none && AlienHQ.LastAttackingChosen.ObjectID != ChosenState.ObjectID && AlienHQ.LastChosenEncounter.bKilled)
		{
			return true;
		}
	}

	return false;
}

static function bool CheckEventSourceOtherChosenLastEncounterDefeated(X2DynamicNarrativeConditionTemplate Template, Object EventData, Object EventSource, XComGameState GameState)
{
	local XComGameState_HeadquartersAlien AlienHQ;
	local XComGameState_AdventChosen ChosenState;

	AlienHQ = XComGameState_HeadquartersAlien(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersAlien', true));
	if (AlienHQ != none)
	{
		ChosenState = AlienHQ.GetChosenOfTemplate(XComGameState_Unit(EventSource).GetMyTemplateGroupName());
		if (ChosenState != none && AlienHQ.LastAttackingChosen.ObjectID != ChosenState.ObjectID && AlienHQ.LastChosenEncounter.bDefeated)
		{
			return true;
		}
	}

	return false;
}

static function bool CheckEventSourceOtherChosenLastEncounterBeatXCom(X2DynamicNarrativeConditionTemplate Template, Object EventData, Object EventSource, XComGameState GameState)
{
	local XComGameState_HeadquartersAlien AlienHQ;
	local XComGameState_AdventChosen ChosenState;

	AlienHQ = XComGameState_HeadquartersAlien(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersAlien', true));
	if (AlienHQ != none)
	{
		ChosenState = AlienHQ.GetChosenOfTemplate(XComGameState_Unit(EventSource).GetMyTemplateGroupName());
		if (ChosenState != none && AlienHQ.LastAttackingChosen.ObjectID != ChosenState.ObjectID && (AlienHQ.LastChosenEncounter.bCapturedSoldier || AlienHQ.LastChosenEncounter.bGainedKnowledge))
		{
			return true;
		}
	}

	return false;
}

static function bool CheckEventSourceOtherChosenLastEncounterBeatXComHeavyLosses(X2DynamicNarrativeConditionTemplate Template, Object EventData, Object EventSource, XComGameState GameState)
{
	local XComGameState_HeadquartersAlien AlienHQ;
	local XComGameState_AdventChosen ChosenState;

	AlienHQ = XComGameState_HeadquartersAlien(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersAlien', true));
	if (AlienHQ != none)
	{
		ChosenState = AlienHQ.GetChosenOfTemplate(XComGameState_Unit(EventSource).GetMyTemplateGroupName());
		if (ChosenState != none && AlienHQ.LastAttackingChosen.ObjectID != ChosenState.ObjectID && 
			(AlienHQ.LastChosenEncounter.bCapturedSoldier || AlienHQ.LastChosenEncounter.bGainedKnowledge) && AlienHQ.LastChosenEncounter.bHeavyLosses)
		{
			return true;
		}
	}

	return false;
}

//---------------------------------------------------------------------------------------
// ABILITY CONTEXT
//---------------------------------------------------------------------------------------
static function bool CheckAbilityContextTargetSoldier(X2DynamicNarrativeConditionTemplate Template, Object EventData, Object EventSource, XComGameState GameState)
{
	local XComGameState_Unit UnitState;

	UnitState = GetAbilityContextTargetUnit(GameState);
	if (UnitState != none && UnitState.IsSoldier())
	{
		return true;
	}

	return false;
}

static function bool CheckAbilityContextTargetSoldierClassName(X2DynamicNarrativeConditionTemplate Template, Object EventData, Object EventSource, XComGameState GameState)
{
	local XComGameState_Unit UnitState;

	UnitState = GetAbilityContextTargetUnit(GameState);
	if (UnitState != none && UnitState.IsSoldier() && Template.ConditionNames.Find(UnitState.GetSoldierClassTemplateName()) != INDEX_NONE)
	{
		return true;
	}

	return false;
}

static function bool CheckAbilityContextTargetCharacterTemplateName(X2DynamicNarrativeConditionTemplate Template, Object EventData, Object EventSource, XComGameState GameState)
{
	local XComGameState_Unit UnitState;

	UnitState = GetAbilityContextTargetUnit(GameState);
	if (UnitState != none && Template.ConditionNames.Find(UnitState.GetMyTemplateGroupName()) != INDEX_NONE)
	{
		return true;
	}

	return false;
}

static function bool CheckAbilityContextTargetNotCharacterTemplateName(X2DynamicNarrativeConditionTemplate Template, Object EventData, Object EventSource, XComGameState GameState)
{
	local XComGameState_Unit UnitState;

	UnitState = GetAbilityContextTargetUnit(GameState);
	if (UnitState != none && Template.ConditionNames.Find(UnitState.GetMyTemplateGroupName()) == INDEX_NONE)
	{
		return true;
	}

	return false;
}

static function bool CheckAbilityContextTargetUnitName(X2DynamicNarrativeConditionTemplate Template, Object EventData, Object EventSource, XComGameState GameState)
{
	local XComGameState_Unit UnitState;

	UnitState = GetAbilityContextTargetUnit(GameState);
	if (UnitState != none && Template.ConditionStrings.Find(UnitState.GetFullName()) != INDEX_NONE)
	{
		return true;
	}

	return false;
}

static function bool CheckAbilityContextTargetUnitRank(X2DynamicNarrativeConditionTemplate Template, Object EventData, Object EventSource, XComGameState GameState)
{
	local XComGameState_Unit UnitState;

	UnitState = GetAbilityContextTargetUnit(GameState);
	if (UnitState != none && UnitState.IsSoldier() && UnitState.GetRank() >= Template.ConditionValue)
	{
		return true;
	}

	return false;
}

static function bool CheckAbilityContextTargetXComTeam(X2DynamicNarrativeConditionTemplate Template, Object EventData, Object EventSource, XComGameState GameState)
{
	local XComGameState_Unit UnitState;

	UnitState = GetAbilityContextTargetUnit(GameState);
	if (UnitState != none && UnitState.GetTeam() == eTeam_XCom)
	{
		return true;
	}

	return false;
}

static function bool CheckAbilityContextTargetEnemyTeam(X2DynamicNarrativeConditionTemplate Template, Object EventData, Object EventSource, XComGameState GameState)
{
	local XComGameState_Unit UnitState;

	UnitState = GetAbilityContextTargetUnit(GameState);
	if (UnitState != none && (UnitState.GetTeam() == eTeam_Alien || UnitState.GetTeam() == eTeam_TheLost))
	{
		return true;
	}

	return false;
}

static function bool CheckAbilityContextTargetSquadsight(X2DynamicNarrativeConditionTemplate Template, Object EventData, Object EventSource, XComGameState GameState)
{
	local array<StateObjectReference> SquadsightUnitRefs;
	local StateObjectReference UnitRef;
	local XComGameState_Unit SourceUnitState, TargetUnitState;
	local int HistoryIndex;

	SourceUnitState = GetAbilityContextSourceUnit(GameState);
	if (SourceUnitState != none) // Ensure ability source is a unit
	{
		HistoryIndex = GameState.HistoryIndex - 1; // Check the previous history index in case the ability changes where units are positioned
		class'X2TacticalVisibilityHelpers'.static.GetAllSquadsightEnemiesForUnit(SourceUnitState.ObjectID, SquadsightUnitRefs, HistoryIndex);

		TargetUnitState = GetAbilityContextTargetUnit(GameState);
		if (TargetUnitState != none) // Ensure ability target is a unit
		{
			foreach SquadsightUnitRefs(UnitRef)
			{
				// Return true if the targeted unit was attacked from squadsight by the source
				if (UnitRef.ObjectID == TargetUnitState.ObjectID)
				{
					return true;
				}
			}
		}
	}

	return false;
}

static function bool CheckAbilityContextTargetLastVisibleEnemy(X2DynamicNarrativeConditionTemplate Template, Object EventData, Object EventSource, XComGameState GameState)
{
	local array<StateObjectReference> VisibleUnitRefs;
	local XComGameState_Unit SourceUnitState;

	SourceUnitState = GetAbilityContextSourceUnit(GameState);
	if (SourceUnitState != none) // Ensure ability source is a unit
	{
		class'X2TacticalVisibilityHelpers'.static.GetAllVisibleEnemiesForPlayer(SourceUnitState.ControllingPlayer.ObjectID, VisibleUnitRefs, GameState.HistoryIndex);

		if (VisibleUnitRefs.Length == 0)
		{
			return true;
		}
	}

	return false;
}

static function bool CheckAbilityContextTargetIncapacitated(X2DynamicNarrativeConditionTemplate Template, Object EventData, Object EventSource, XComGameState GameState)
{
	local XComGameState_Unit TargetUnitState;

	TargetUnitState = GetAbilityContextTargetUnit(GameState);
	if (TargetUnitState != none) // Ensure ability target is a unit
	{
		if(TargetUnitState.IsIncapacitated() || TargetUnitState.IsStunned())
		{
			return true;
		}
	}

	return false;
}

static function bool CheckAbilityContextTargetAlive(X2DynamicNarrativeConditionTemplate Template, Object EventData, Object EventSource, XComGameState GameState)
{
	local XComGameState_Unit UnitState;

	UnitState = GetAbilityContextTargetUnit(GameState);
	if (UnitState != none && UnitState.IsAlive())
	{
		return true;
	}

	return false;
}

static function bool CheckAbilityContextSourceCharacterTemplateName(X2DynamicNarrativeConditionTemplate Template, Object EventData, Object EventSource, XComGameState GameState)
{
	local XComGameState_Unit UnitState;

	UnitState = GetAbilityContextSourceUnit(GameState);
	if (UnitState != none && Template.ConditionNames.Find(UnitState.GetMyTemplateGroupName()) != INDEX_NONE)
	{
		return true;
	}

	return false;
}

static function bool CheckAbilityContextSourceNotCharacterTemplateName(X2DynamicNarrativeConditionTemplate Template, Object EventData, Object EventSource, XComGameState GameState)
{
	local XComGameState_Unit UnitState;

	UnitState = GetAbilityContextSourceUnit(GameState);
	if (UnitState != none && Template.ConditionNames.Find(UnitState.GetMyTemplateGroupName()) == INDEX_NONE)
	{
		return true;
	}

	return false;
}

static function bool CheckAbilityContextSourceXComTeam(X2DynamicNarrativeConditionTemplate Template, Object EventData, Object EventSource, XComGameState GameState)
{
	local XComGameState_Unit UnitState;

	UnitState = GetAbilityContextSourceUnit(GameState);
	if (UnitState != none && UnitState.GetTeam() == eTeam_XCom)
	{
		return true;
	}
	
	return false;
}

static function bool CheckAbilityContextSourceEnemyTeam(X2DynamicNarrativeConditionTemplate Template, Object EventData, Object EventSource, XComGameState GameState)
{
	local XComGameState_Unit UnitState;
	
	UnitState = GetAbilityContextSourceUnit(GameState);
	if (UnitState != none && (UnitState.GetTeam() == eTeam_Alien || UnitState.GetTeam() == eTeam_TheLost))
	{
		return true;
	}

	return false;
}

static function bool CheckAbilityContextSourceNotTarget(X2DynamicNarrativeConditionTemplate Template, Object EventData, Object EventSource, XComGameState GameState)
{
	local XComGameState_Unit SourceUnitState, TargetUnitState;

	SourceUnitState = GetAbilityContextSourceUnit(GameState);
	TargetUnitState = GetAbilityContextTargetUnit(GameState);
	if (SourceUnitState != none && TargetUnitState != none && SourceUnitState.ObjectID != TargetUnitState.ObjectID)
	{
		return true;
	}

	return false;
}

static function bool CheckAbilityContextHit(X2DynamicNarrativeConditionTemplate Template, Object EventData, Object EventSource, XComGameState GameState)
{
	local XComGameStateContext_Ability AbilityContext;

	AbilityContext = XComGameStateContext_Ability(GameState.GetContext());
	if (AbilityContext != none)
	{
		if (AbilityContext.IsHitResultHit(AbilityContext.ResultContext.HitResult))
		{
			return true;
		}
	}

	return false;
}

static function bool CheckAbilityContextMiss(X2DynamicNarrativeConditionTemplate Template, Object EventData, Object EventSource, XComGameState GameState)
{
	local XComGameStateContext_Ability AbilityContext;

	AbilityContext = XComGameStateContext_Ability(GameState.GetContext());
	if (AbilityContext != none)
	{
		if (AbilityContext.IsHitResultMiss(AbilityContext.ResultContext.HitResult))
		{
			return true;
		}
	}

	return false;
}

static function bool CheckRollValue(X2DynamicNarrativeConditionTemplate Template, Object EventData, Object EventSource, XComGameState GameState)
{
	return class'X2StrategyGameRulesetDataStructures'.static.Roll(Template.ConditionValue);
}

// #######################################################################################
// -------------------------- HELPER FUNCTIONS -------------------------------------------
// #######################################################################################

static function XComGameState_Unit GetEventSourceUnitState(Object EventSource)
{
	local XComGameState_Unit UnitState; 
	local XComGameState_AIGroup GroupState;

	UnitState = XComGameState_Unit(EventSource);

	// if the event specifies a group instead of a unit, use the group leader as the unit
	if (UnitState == None)
	{
		GroupState = XComGameState_AIGroup(EventSource);
		if (GroupState != None)
		{
			UnitState = GroupState.GetGroupLeader();
		}
	}

	return UnitState;
}

static function XComGameState_AdventChosen GetEventSourceChosen(Object EventSource)
{
	local XComGameState_HeadquartersAlien AlienHQ;
	local XComGameState_Unit UnitState;
	local XComGameState_AdventChosen ChosenState;

	AlienHQ = XComGameState_HeadquartersAlien(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersAlien', true));
	if (AlienHQ != none)
	{
		UnitState = XComGameState_Unit(EventSource);
		ChosenState = AlienHQ.GetChosenOfTemplate(UnitState.GetMyTemplateGroupName());
	}

	return ChosenState;
}

static function XComGameState_Unit GetAbilityContextTargetUnit(XComGameState GameState)
{
	local XComGameStateContext_Ability AbilityContext;

	AbilityContext = XComGameStateContext_Ability(GameState.GetContext());
	if (AbilityContext != none)
	{
		if (AbilityContext.InputContext.PrimaryTarget.ObjectID != 0)
		{
			return XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(AbilityContext.InputContext.PrimaryTarget.ObjectID));
		}
	}

	return none;
}

static function XComGameState_Unit GetAbilityContextSourceUnit(XComGameState GameState)
{
	local XComGameStateContext_Ability AbilityContext;

	AbilityContext = XComGameStateContext_Ability(GameState.GetContext());
	if (AbilityContext != none)
	{
		if (AbilityContext.InputContext.SourceObject.ObjectID != 0)
		{
			return XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(AbilityContext.InputContext.SourceObject.ObjectID));
		}
	}

	return none;
}