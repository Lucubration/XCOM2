//---------------------------------------------------------------------------------------
//  FILE:    X2SitRep_DefaultSitRepEffects.uc
//  AUTHOR:  Joe Weinhoffer  --  9/7/2016
//  PURPOSE: Defines the default set of sitrep effect templates.
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class X2SitRep_DefaultSitRepEffects extends X2SitRepEffect;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	// Intro VO Effects
	Templates.AddItem(CreateIntroVOEffectTemplate());
	
	// Squad Size Effects
	Templates.AddItem(CreateSquadSizeLimit1EffectTemplate());
	Templates.AddItem(CreateSquadSizeLimit2EffectTemplate());
	Templates.AddItem(CreateSquadSizeLimit3EffectTemplate());

	// Timer Effects
	Templates.AddItem(CreateIncreaseTimer2EffectTemplate());
	Templates.AddItem(CreateTimerDisableEffectTemplate());
	Templates.AddItem(CreateTimerEngagesAfterConcealmentLostEffectTemplate());

	// Spawned Object Effects
	Templates.AddItem(CreateExtraLootChestsEffectTemplate());
	Templates.AddItem(CreateHighExplosivesEffectTemplate());
	
	// Alert Level Delta Effects
	Templates.AddItem(CreateAlertLevelReduceByOneEffectTemplate());
	Templates.AddItem(CreateAlertLevelReduceByTwoEffectTemplate());
	Templates.AddItem(CreateAlertLevelIncreaseByOneEffectTemplate());
	Templates.AddItem(CreateAlertLevelIncreaseByTwoEffectTemplate());

	// Alert Level Clamping Effects
	Templates.AddItem(CreateAlertLevelMaxAtOneEffectTemplate());
	Templates.AddItem(CreateAlertLevelMaxAtTwoEffectTemplate());
	Templates.AddItem(CreateAlertLevelMaxAtThreeEffectTemplate());
	Templates.AddItem(CreateAlertLevelMaxAtFourEffectTemplate());
	Templates.AddItem(CreateAlertLevelMaxAtFiveEffectTemplate());

	// Force Level Delta Effects
	Templates.AddItem(CreateForceLevelIncreaseBySixEffectTemplate());

	// Enemy Pod Size Effects
	Templates.AddItem(CreatePodSizeDecreaseToOneEffectTemplate());
	Templates.AddItem(CreatePodSizeDecreaseToTwoEffectTemplate());
	Templates.AddItem(CreatePodSizeDecreaseByOneEffectTemplate());
	Templates.AddItem(CreatePodSizeIncreaseByTwoEffectTemplate());

	// Reinforcements Effects
	Templates.AddItem(CreateAmbushEffectTemplate());
	Templates.AddItem(CreateReinforcementsDisableEffectTemplate());
	Templates.AddItem(CreateDisableStandardReinforcementsEffectTemplate());

	// Rank Limit Effects
	Templates.AddItem(CreateLowProfileRankLimitTemplate());

	// Ability Granting Effects
	Templates.AddItem(CreateLowVisibilityEffectTemplate());
	Templates.AddItem(CreateIndividualConcealmentEffectTemplate());
	//Templates.AddItem(CreateJuggernautEffectTemplate());
	Templates.AddItem(CreateBlackOpsEffectTemplate());

	// Alien Squad Effects
	Templates.AddItem(CreateShowOfForceEffectTemplate());
	Templates.AddItem(CreatePsionicStormEffectTemplate());
	Templates.AddItem(CreateSavageEffectTemplate());
	Templates.AddItem(CreateAutomatedDefensesEffectTemplate());
	Templates.AddItem(CreatePhalanxEffectTemplate());
	Templates.AddItem(CreateWavesEffectTemplate());

	// Miscellaneous effects
	Templates.AddItem(CreatePerfectVisibilityEffectTemplate());
	Templates.AddItem(CreateChemicalLeakEffectTemplate());
	Templates.AddItem(CreateNoCiviliansEffectTemplate());
	Templates.AddItem(CreateIncreaseMaxTurretsEffectTemplate());
	Templates.AddItem(CreateResistanceContactsEffectTemplate());
	Templates.AddItem(CreateFirstReconEffectTemplate());
	
	// Resistance Policies support
	Templates.AddItem(CreateInformationWarEffectTemplate());
	Templates.AddItem(CreateMentalFortitudeEffectTemplate());

	// Dark Events support
	Templates.AddItem(CreateDarkEventBarrierEffectTemplate());
	Templates.AddItem(CreateDarkEventDarkTowerEffectTemplate());
	
	return Templates;
}

// ----------------------------------------------------------------------------------------------------------
// Intro VO Related Effects
// ----------------------------------------------------------------------------------------------------------

static function X2SitRepEffectTemplate CreateIntroVOEffectTemplate()
{
	local X2SitRepEffect_ModifyMissionMaps Template;

	`CREATE_X2TEMPLATE(class'X2SitRepEffect_ModifyMissionMaps', Template, 'IntroVOEffect');
	Template.AdditionalMissionMaps.AddItem("SitRep_IntroVO");

	return Template;
}

// ----------------------------------------------------------------------------------------------------------
// Squad Size Related Effects
// ----------------------------------------------------------------------------------------------------------

static function X2SitRepEffectTemplate CreateSquadSizeLimit1EffectTemplate()
{
	local X2SitRepEffect_SquadSize Template;

	`CREATE_X2TEMPLATE(class'X2SitRepEffect_SquadSize', Template, 'SquadSizeLimit1Effect');

	Template.MaxSquadSize = 1;
	Template.DifficultyModifier = 15;

	return Template;
}

static function X2SitRepEffectTemplate CreateSquadSizeLimit2EffectTemplate()
{
	local X2SitRepEffect_SquadSize Template;

	`CREATE_X2TEMPLATE(class'X2SitRepEffect_SquadSize', Template, 'SquadSizeLimit2Effect');

	Template.MaxSquadSize = 2;
	Template.DifficultyModifier = 15;

	return Template;
}

static function X2SitRepEffectTemplate CreateSquadSizeLimit3EffectTemplate()
{
	local X2SitRepEffect_SquadSize Template;

	`CREATE_X2TEMPLATE(class'X2SitRepEffect_SquadSize', Template, 'SquadSizeLimit3Effect');

	Template.MaxSquadSize = 3;
	Template.DifficultyModifier = 10;

	return Template;
}

// ----------------------------------------------------------------------------------------------------------
// Timer Related Effects
// ----------------------------------------------------------------------------------------------------------

static function X2SitRepEffectTemplate CreateIncreaseTimer2EffectTemplate()
{
	local X2SitRepEffect_ModifyKismetVariable Template;

	`CREATE_X2TEMPLATE(class'X2SitRepEffect_ModifyKismetVariable', Template, 'IncreaseTimer2Effect');

	Template.VariableNames.AddItem("Timer.DefaultTurns");
	Template.VariableNames.AddItem("Timer.LengthDelta");
	Template.VariableNames.AddItem("Mission.TimerLengthDelta"); // Refactoring mission timers, here for forward compatability
	Template.ValueAdjustment = 2; // make the timer two turns longer
	Template.DifficultyModifier = -5;

	return Template;
}

// This effect won't operate if the mission kismet isn't properly rigged to support it
static function X2SitRepEffectTemplate CreateTimerDisableEffectTemplate()
{
	local X2SitRepEffect_ModifyKismetVariable Template;

	`CREATE_X2TEMPLATE(class'X2SitRepEffect_ModifyKismetVariable', Template, 'TimerDisableEffect');

	Template.VariableNames.AddItem("SitRep.HardDisableTimer");
	Template.ForceTrue = true; // overrides all attempts to engage timer
	Template.DifficultyModifier = -5;

	return Template;
}

// This effect won't operate if the mission kismet isn't properly rigged to support it
static function X2SitRepEffectTemplate CreateTimerEngagesAfterConcealmentLostEffectTemplate()
{
	local X2SitRepEffect_ModifyKismetVariable Template;

	`CREATE_X2TEMPLATE(class'X2SitRepEffect_ModifyKismetVariable', Template, 'TimerEngagesAfterConcealmentLostEffect');

	Template.VariableNames.AddItem("SitRep.EngageTimerWhenConcealmentLost");
	Template.VariableNames.AddItem("SitRep.DoNotEngageTimerAtMissionStart");
	Template.ForceTrue = true;
	Template.DifficultyModifier = -5;

	return Template;
}

// ----------------------------------------------------------------------------------------------------------
// Spawned Object Related Effects
// ----------------------------------------------------------------------------------------------------------

static function X2SitRepEffectTemplate CreateExtraLootChestsEffectTemplate()
{
	local X2SitRepEffect_ModifyMissionMaps Template;

	`CREATE_X2TEMPLATE(class'X2SitRepEffect_ModifyMissionMaps', Template, 'ExtraLootChestsEffect');
		
	Template.AdditionalMissionMaps.AddItem("Sitrep_ExtraLootChests");
	Template.DifficultyModifier = 5;

	return Template;
}

static function X2SitRepEffectTemplate CreateHighExplosivesEffectTemplate()
{
	local X2SitRepEffect_ModifyMissionMaps Template;

	`CREATE_X2TEMPLATE(class'X2SitRepEffect_ModifyMissionMaps', Template, 'HighExplosivesEffect');

	Template.AdditionalMissionMaps.AddItem("Sitrep_HighExplosives");

	return Template;
}

// ----------------------------------------------------------------------------------------------------------
// Alert Level Delta Effects
// ----------------------------------------------------------------------------------------------------------

static function X2SitRepEffectTemplate CreateAlertLevelReduceByOneEffectTemplate()
{
	local X2SitRepEffect_ModifyAlertLevel Template;

	`CREATE_X2TEMPLATE(class'X2SitRepEffect_ModifyAlertLevel', Template, 'AlertLevelReduceByOneEffect');

	Template.AlertLevelModification = -1;
	Template.MaxAlertLevel = 7;

	return Template;
}

static function X2SitRepEffectTemplate CreateAlertLevelReduceByTwoEffectTemplate()
{
	local X2SitRepEffect_ModifyAlertLevel Template;

	`CREATE_X2TEMPLATE(class'X2SitRepEffect_ModifyAlertLevel', Template, 'AlertLevelReduceByTwoEffect');

	Template.AlertLevelModification = -2;
	Template.MaxAlertLevel = 7;

	return Template;
}

static function X2SitRepEffectTemplate CreateAlertLevelIncreaseByOneEffectTemplate()
{
	local X2SitRepEffect_ModifyAlertLevel Template;

	`CREATE_X2TEMPLATE(class'X2SitRepEffect_ModifyAlertLevel', Template, 'AlertLevelIncreaseByOneEffect');

	Template.AlertLevelModification = 1;
	Template.MaxAlertLevel = 7;

	return Template;
}

static function X2SitRepEffectTemplate CreateAlertLevelIncreaseByTwoEffectTemplate()
{
	local X2SitRepEffect_ModifyAlertLevel Template;

	`CREATE_X2TEMPLATE(class'X2SitRepEffect_ModifyAlertLevel', Template, 'AlertLevelIncreaseByTwoEffect');

	Template.AlertLevelModification = 2;
	Template.MaxAlertLevel = 7;

	return Template;
}

// ----------------------------------------------------------------------------------------------------------
// Alert Level Ceiling Effects
// ----------------------------------------------------------------------------------------------------------

static function X2SitRepEffectTemplate CreateAlertLevelMaxAtOneEffectTemplate()
{
	local X2SitRepEffect_ModifyAlertLevel Template;

	`CREATE_X2TEMPLATE(class'X2SitRepEffect_ModifyAlertLevel', Template, 'AlertLevelMaxAtOneEffect');

	Template.AlertLevelModification = 0;
	Template.MaxAlertLevel = 1;

	return Template;
}

static function X2SitRepEffectTemplate CreateAlertLevelMaxAtTwoEffectTemplate()
{
	local X2SitRepEffect_ModifyAlertLevel Template;

	`CREATE_X2TEMPLATE(class'X2SitRepEffect_ModifyAlertLevel', Template, 'AlertLevelMaxAtTwoEffect');

	Template.AlertLevelModification = 0;
	Template.MaxAlertLevel = 2;

	return Template;
}

static function X2SitRepEffectTemplate CreateAlertLevelMaxAtThreeEffectTemplate()
{
	local X2SitRepEffect_ModifyAlertLevel Template;

	`CREATE_X2TEMPLATE(class'X2SitRepEffect_ModifyAlertLevel', Template, 'AlertLevelMaxAtThreeEffect');

	Template.AlertLevelModification = 0;
	Template.MaxAlertLevel = 3;

	return Template;
}

static function X2SitRepEffectTemplate CreateAlertLevelMaxAtFourEffectTemplate()
{
	local X2SitRepEffect_ModifyAlertLevel Template;

	`CREATE_X2TEMPLATE(class'X2SitRepEffect_ModifyAlertLevel', Template, 'AlertLevelMaxAtFourEffect');

	Template.AlertLevelModification = 0;
	Template.MaxAlertLevel = 4;

	return Template;
}

static function X2SitRepEffectTemplate CreateAlertLevelMaxAtFiveEffectTemplate()
{
	local X2SitRepEffect_ModifyAlertLevel Template;

	`CREATE_X2TEMPLATE(class'X2SitRepEffect_ModifyAlertLevel', Template, 'AlertLevelMaxAtFiveEffect');

	Template.AlertLevelModification = 0;
	Template.MaxAlertLevel = 5;

	return Template;
}

// ----------------------------------------------------------------------------------------------------------
// Force Level Delta Effects
// ----------------------------------------------------------------------------------------------------------

static function X2SitRepEffectTemplate CreateForceLevelIncreaseBySixEffectTemplate()
{
	local X2SitRepEffect_ModifyForceLevel Template;

	`CREATE_X2TEMPLATE(class'X2SitRepEffect_ModifyForceLevel', Template, 'ForceLevelIncreaseBySixEffect');

	Template.ForceLevelModification = 6;
	Template.MaxForceLevel = 20;

	return Template;
}

// ----------------------------------------------------------------------------------------------------------
// Enemy Pod Size Effects
// ----------------------------------------------------------------------------------------------------------

static function X2SitRepEffectTemplate CreatePodSizeDecreaseToOneEffectTemplate()
{
	local X2SitRepEffect_ModifyPodSize Template;

	`CREATE_X2TEMPLATE(class'X2SitRepEffect_ModifyPodSize', Template, 'PodSizeDecreaseToOneEffect');

	Template.MaxPodSize = 1;
	
	return Template;
}

static function X2SitRepEffectTemplate CreatePodSizeDecreaseToTwoEffectTemplate()
{
	local X2SitRepEffect_ModifyPodSize Template;

	`CREATE_X2TEMPLATE(class'X2SitRepEffect_ModifyPodSize', Template, 'PodSizeDecreaseToTwoEffect');

	Template.MaxPodSize = 2;

	return Template;
}

static function X2SitRepEffectTemplate CreatePodSizeDecreaseByOneEffectTemplate()
{
	local X2SitRepEffect_ModifyPodSize Template;

	`CREATE_X2TEMPLATE(class'X2SitRepEffect_ModifyPodSize', Template, 'PodSizeDecreaseByOneEffect');

	Template.PodSizeDelta = -1;

	return Template;
}

static function X2SitRepEffectTemplate CreatePodSizeIncreaseByTwoEffectTemplate()
{
	local X2SitRepEffect_ModifyPodSize Template;

	`CREATE_X2TEMPLATE(class'X2SitRepEffect_ModifyPodSize', Template, 'PodSizeIncreaseByTwoEffect');

	Template.PodSizeDelta = 2;

	return Template;
}

static function X2SitRepEffectTemplate CreateFirstReconEffectTemplate()
{
	local X2SitRepEffect_ModifyXComSpawn Template;

	`CREATE_X2TEMPLATE(class'X2SitRepEffect_ModifyXComSpawn', Template, 'FirstReconEffect');

	Template.ModifyLocationsFN = SquadStartModifyPOC;
	
	return Template;
}

static function SquadStartModifyPOC(out int IdealSpawnDistance, out int MinSpawnDistance)
{
	IdealSpawnDistance = 32;
	MinSpawnDistance = 24;
}

// ----------------------------------------------------------------------------------------------------------
// Reinforcements Related Effects
// ----------------------------------------------------------------------------------------------------------

// This effect won't operate if the mission kismet isn't properly rigged to support it
static function X2SitRepEffectTemplate CreateReinforcementsDisableEffectTemplate()
{
	local X2SitRepEffect_ModifyKismetVariable Template;

	`CREATE_X2TEMPLATE(class'X2SitRepEffect_ModifyKismetVariable', Template, 'ReinforcementsDisableEffect');

	Template.VariableNames.AddItem("SitRep.HardDisableReinforcements");
	Template.ForceTrue = true; // Blocks all attempts to key reinforcements
	Template.DifficultyModifier = -5;

	return Template;
}

static function X2SitRepEffectTemplate CreateAmbushEffectTemplate()
{
	local X2SitRepEffect_ModifyMissionMaps Template;

	`CREATE_X2TEMPLATE(class'X2SitRepEffect_ModifyMissionMaps', Template, 'AmbushEffect');

	Template.AdditionalMissionMaps.AddItem("Sitrep_Ambush");
	Template.DifficultyModifier = 10;

	return Template;
}

// ----------------------------------------------------------------------------------------------------------
// Rank Limit Related Effects
// ----------------------------------------------------------------------------------------------------------

static function X2SitRepEffectTemplate CreateLowProfileRankLimitTemplate()
{
	local X2SitRepEffect_RankLimit Template;

	`CREATE_X2TEMPLATE(class'X2SitRepEffect_RankLimit', Template, 'LowProfileRankLimitEffect');

	Template.MaxSoldierRank = 3;

	return Template;
}

// ----------------------------------------------------------------------------------------------------------
// Ability Granting Related Effects
// ----------------------------------------------------------------------------------------------------------

static function X2SitRepEffectTemplate CreateLowVisibilityEffectTemplate()
{
	local X2SitRepEffect_GrantAbilities Template;

	`CREATE_X2TEMPLATE(class'X2SitRepEffect_GrantAbilities', Template, 'LowVisibilityEffect');

	Template.AbilityTemplateNames.AddItem('LowVisibility');

	return Template;
}

static function X2SitRepEffectTemplate CreateIndividualConcealmentEffectTemplate()
{
	local X2SitRepEffect_GrantAbilities Template;

	`CREATE_X2TEMPLATE(class'X2SitRepEffect_GrantAbilities', Template, 'IndividualConcealmentEffect');

	Template.AbilityTemplateNames.AddItem('SitRepStealth');
	Template.GrantToSoldiers = true;

	return Template;
}

static function X2SitRepEffectTemplate CreateJuggernautEffectTemplate()
{
	local X2SitRepEffect_GrantAbilities Template;

	`CREATE_X2TEMPLATE(class'X2SitRepEffect_GrantAbilities', Template, 'JuggernautEffect');

	Template.AbilityTemplateNames.AddItem('Juggernaut');
	Template.GrantToSoldiers = true;

	return Template;
}

static function X2SitRepEffectTemplate CreateBlackOpsEffectTemplate()
{
	local X2SitRepEffect_GrantAbilities Template;

	`CREATE_X2TEMPLATE(class'X2SitRepEffect_GrantAbilities', Template, 'BlackOpsEffect');

	Template.AbilityTemplateNames.AddItem('BlackOps');
	Template.GrantToSoldiers = true;

	return Template;
}

static function X2SitRepEffectTemplate CreateShowOfForceEffectTemplate()
{
	local X2SitRepEffect_ModifyDefaultEncounterLists Template;

	`CREATE_X2TEMPLATE(class'X2SitRepEffect_ModifyDefaultEncounterLists', Template, 'ShowOfForceEffect');
	Template.DefaultLeaderListOverride = 'AdventLeaders';
	Template.DefaultFollowerListOverride = 'TroopersOnly';
		
	return Template;
}

static function X2SitRepEffectTemplate CreatePsionicStormEffectTemplate()
{
	local X2SitRepEffect_ModifyDefaultEncounterLists Template;

	`CREATE_X2TEMPLATE(class'X2SitRepEffect_ModifyDefaultEncounterLists', Template, 'PsionicStormEffect');
	Template.DefaultLeaderListOverride = 'PsionicLeaders';
	Template.DefaultFollowerListOverride = 'PsionicFollowers';

	return Template;
}

static function X2SitRepEffectTemplate CreateSavageEffectTemplate()
{
	local X2SitRepEffect_ModifyDefaultEncounterLists Template;

	`CREATE_X2TEMPLATE(class'X2SitRepEffect_ModifyDefaultEncounterLists', Template, 'SavageEffect');
	Template.DefaultLeaderListOverride = 'SavageLeaders';
	Template.DefaultFollowerListOverride = 'SavageFollowers';

	return Template;
}

static function X2SitRepEffectTemplate CreateAutomatedDefensesEffectTemplate()
{
	local X2SitRepEffect_ModifyDefaultEncounterLists Template;

	`CREATE_X2TEMPLATE(class'X2SitRepEffect_ModifyDefaultEncounterLists', Template, 'AutomatedDefensesEffect');
	Template.DefaultLeaderListOverride = 'AutomatedDefensesLeaders';
	Template.DefaultFollowerListOverride = 'AutomatedDefensesFollowers';

	return Template;
}

static function X2SitRepEffectTemplate CreatePerfectVisibilityEffectTemplate()
{
	local X2SitRepEffect_PerfectVisibility Template;

	`CREATE_X2TEMPLATE(class'X2SitRepEffect_PerfectVisibility', Template, 'PerfectVisibilityEffect');

	return Template;
}

static function X2SitRepEffectTemplate CreateChemicalLeakEffectTemplate()
{
	local X2SitRepEffect_ModifyMissionMaps Template;

	`CREATE_X2TEMPLATE(class'X2SitRepEffect_ModifyMissionMaps', Template, 'ChemicalLeakEffect');
	Template.AdditionalMissionMaps.AddItem("SitRep_ChemicalLeak");

	return Template;
}

static function X2SitRepEffectTemplate CreateResistanceContactsEffectTemplate()
{
	local X2SitRepEffect_ModifyMissionMaps Template;

	`CREATE_X2TEMPLATE(class'X2SitRepEffect_ModifyMissionMaps', Template, 'ResistanceContactsEffect');
	Template.AdditionalMissionMaps.AddItem("SitRep_ResistanceContacts");

	return Template;
}

static function X2SitRepEffectTemplate CreateNoCiviliansEffectTemplate()
{
	local X2SitRepEffect_DisableCivilians Template;

	`CREATE_X2TEMPLATE(class'X2SitRepEffect_DisableCivilians', Template, 'DisableCivilianSpawning');

	return Template;
}

static function X2SitRepEffectTemplate CreateIncreaseMaxTurretsEffectTemplate()
{
	local X2SitRepEffect_ModifyTurretCount Template;

	`CREATE_X2TEMPLATE(class'X2SitRepEffect_ModifyTurretCount', Template, 'IncreaseMaxTurretsEffect');
	Template.MaxCount = 4;
	Template.CountDelta = 4;
	Template.ZoneWidthDelta = 16;
	Template.ZoneOffsetDelta = -16;

	return Template;
}

static function X2SitRepEffectTemplate CreatePhalanxEffectTemplate()
{
	local X2SitRepEffect_ModifyPodLocations Template;

	`CREATE_X2TEMPLATE(class'X2SitRepEffect_ModifyPodLocations', Template, 'PhalanxEffect');
	
	Template.ModifyLocationsFN = PodLocationModifyPOC;

	return Template;
}

static function PodLocationModifyPOC(out float ZoneOffsetFromLOP, out float ZoneOffsetAlongLOP)
{
	ZoneOffsetAlongLOP /= 5.0;
	ZoneOffsetFromLOP /= 2.0;
}

static function X2SitRepEffectTemplate CreateWavesEffectTemplate()
{
	local X2SitRepEffect_ModifyMissionMaps Template;
	local MissionMapSwap NoCBRNF;
	local MissionMapSwap NoTrigRNF;

	`CREATE_X2TEMPLATE(class'X2SitRepEffect_ModifyMissionMaps', Template, 'WavesEffect');

	NoCBRNF.ToReplace = "UMS_ChanceBasedReinforcements";
	NoCBRNF.ReplaceWith = "UMS_NoReinforcements";
	NoTrigRNF.ToReplace = "UMS_TriggeredReinforcements";
	NoTrigRNF.ReplaceWith = "UMS_NoReinforcements";
	
	Template.AdditionalMissionMaps.AddItem("Sitrep_Waves");
	Template.ReplacementMissionMaps.AddItem(NoCBRNF);
	Template.ReplacementMissionMaps.AddItem(NoTrigRNF);

	return Template;
}

static function X2SitRepEffectTemplate  CreateInformationWarEffectTemplate()
{
	local X2SitRepEffect_ModifyHackDefenses Template;

	`CREATE_X2TEMPLATE(class'X2SitRepEffect_ModifyHackDefenses', Template, 'InformationWarEffect');
	Template.DefenseDeltaFn = InformationWarModFunction;

	return Template;
}

static function InformationWarModFunction( out int ModValue )
{
	ModValue += class'X2StrategyElement_XpackResistanceActions'.static.GetValueInformationWar( );
}

static  function X2SitRepEffectTemplate CreateMentalFortitudeEffectTemplate()
{
	local X2SitRepEffect_ModifyEffectDuration Template;

	`CREATE_X2TEMPLATE(class'X2SitRepEffect_ModifyEffectDuration', Template, 'MentalFortitudeEffect');

	Template.DurationMin = 1;
	Template.DurationMax = 1;

	Template.TeamFilter = eTeam_XCom;

	Template.EffectNames.AddItem( class'X2AbilityTemplateManager'.default.PanickedName );
	Template.EffectNames.AddItem( class'X2AbilityTemplateManager'.default.BerserkName );
	Template.EffectNames.AddItem( class'X2AbilityTemplateManager'.default.ObsessedName );
	Template.EffectNames.AddItem( class'X2AbilityTemplateManager'.default.ShatteredName );

	return Template;
}

static function X2SitRepEffectTemplate CreateDisableStandardReinforcementsEffectTemplate()
{
	local X2SitRepEffect_ModifyMissionMaps Template;
	local MissionMapSwap NoCBRNF;
	local MissionMapSwap NoTrigRNF;

	`CREATE_X2TEMPLATE(class'X2SitRepEffect_ModifyMissionMaps', Template, 'DisableStandardReinforcements');

	NoCBRNF.ToReplace = "UMS_ChanceBasedReinforcements";
	NoCBRNF.ReplaceWith = "UMS_NoReinforcements";
	NoTrigRNF.ToReplace = "UMS_TriggeredReinforcements";
	NoTrigRNF.ReplaceWith = "UMS_NoReinforcements";
	
	Template.ReplacementMissionMaps.AddItem(NoCBRNF);
	Template.ReplacementMissionMaps.AddItem(NoTrigRNF);

	return Template;
}

static function X2SitRepEffectTemplate CreateDarkEventBarrierEffectTemplate()
{
	local X2SitRepEffect_ModifyHackDefenses Template;

	`CREATE_X2TEMPLATE(class'X2SitRepEffect_ModifyHackDefenses', Template, 'DarkEventBarrierEffect');
	Template.DefenseDeltaFn = BarrierModFunction;

	return Template;
}

static function BarrierModFunction( out int ModValue )
{
	ModValue *= class'X2Ability_DarkEvents'.default.DARK_EVENT_BARRIER_BONUS_SCALAR;
}

static function X2SitRepEffectTemplate CreateDarkEventDarkTowerEffectTemplate()
{
	local X2SitRepEffect_ModifyWillPenalties Template;

	`CREATE_X2TEMPLATE(class'X2SitRepEffect_ModifyWillPenalties', Template, 'DarkEventDarkTowerEffect');

	Template.WillEventNames.AddItem( 'EnemyGroupSighted' );
	Template.ModifyScalar = 2.0f;

	return Template;
}