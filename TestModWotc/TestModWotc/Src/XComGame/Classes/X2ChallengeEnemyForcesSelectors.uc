//---------------------------------------------------------------------------------------
//  FILE:    X2ChallengeEnemyForcesSelectors.uc
//  AUTHOR:  Russell Aasland
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class X2ChallengeEnemyForcesSelectors extends X2ChallengeElement;

struct ScheduleBreakdown
{
	var array<PrePlacedEncounterPair> WeakSpawns;
	var array<PrePlacedEncounterPair> StandardSpawns;
	var array<PrePlacedEncounterPair> BossSpawns;
};

static function array<X2DataTemplate> CreateTemplates( )
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem( CreateStandardScheduleSelector( ) );
	Templates.AddItem( CreateMechanizedArmySelector( ) );
	Templates.AddItem( CreatePsionicEnemiesSelector( ) );
	Templates.AddItem( CreateChryssalidInfestationSelector() );
	Templates.AddItem( CreateCodexInvasionSelector() );
	Templates.AddItem( CreateRiotControlSelector() );
	Templates.AddItem( CreateMutonAssaultSelector() );
	Templates.AddItem( CreatePurgeSelector() );
	Templates.AddItem( CreateBrutalLeadersSelector() );
	Templates.AddItem( CreateNightmaresSelector() );
	Templates.AddItem( CreateBeautyDestructionSelector() );
	Templates.AddItem( CreatePuppeteersSelector() );
	Templates.AddItem( CreateMonstersSelector() );

	return Templates;
}

// -------------------------------------------------------
// Standard Schedule
// -------------------------------------------------------

static function X2ChallengeEnemyForces CreateStandardScheduleSelector( )
{
	local X2ChallengeEnemyForces	Template;

	`CREATE_X2TEMPLATE(class'X2ChallengeEnemyForces', Template, 'ChallengeStandardSchedule');

	Template.Weight = 10;
	Template.SelectEnemyForcesFn = StandardScheduleSelector;

	return Template;
}

static function StandardScheduleSelector( X2ChallengeEnemyForces Selector, XComGameState_MissionSite MissionSite, XComGameState_BattleData BattleData, XComGameState StartState )
{
	MissionSite.CacheSelectedMissionData( BattleData.GetForceLevel(), BattleData.GetAlertLevel() );
}

// -------------------------------------------------------
// Psionic Enemies
// -------------------------------------------------------

static function X2ChallengeEnemyForces CreatePsionicEnemiesSelector( )
{
	local X2ChallengeEnemyForces	Template;

	`CREATE_X2TEMPLATE(class'X2ChallengeEnemyForces', Template, 'ChallengePsionicSquad');

	Template.Weight = 1;
	Template.SelectEnemyForcesFn = PsionicSquadSelector;
	Template.AdditionalTacticalGameplayTags.AddItem('DisableBossEncounters');

	return Template;
}

static function PsionicSquadSelector( X2ChallengeEnemyForces Selector, XComGameState_MissionSite MissionSite, XComGameState_BattleData BattleData, XComGameState StartState )
{
	local XComGameState_ChallengeData ChallengeData;

	foreach StartState.IterateByClassType( class'XComGameState_ChallengeData', ChallengeData )
	{
		break;
	}

	if (ChallengeData == none) // we're in PerRunner mode. Use regular enemies.
		return;

	ChallengeData.DefaultLeaderListOverride = 'CM_PsionicLeaders';
	ChallengeData.DefaultFollowerListOverride = 'CM_PsionicFollowers';
}

// -------------------------------------------------------
// Mechanized Army
// -------------------------------------------------------

static function X2ChallengeEnemyForces CreateMechanizedArmySelector( )
{
	local X2ChallengeEnemyForces	Template;

	`CREATE_X2TEMPLATE(class'X2ChallengeEnemyForces', Template, 'ChallengeMechanizedArmy');

	Template.Weight = 1;
	Template.SelectEnemyForcesFn = MechanizedArmySelector;
	Template.AdditionalTacticalGameplayTags.AddItem('DisableBossEncounters');

	return Template;
}

static function MechanizedArmySelector( X2ChallengeEnemyForces Selector, XComGameState_MissionSite MissionSite, XComGameState_BattleData BattleData, XComGameState StartState )
{
	local XComGameState_ChallengeData ChallengeData;

	foreach StartState.IterateByClassType( class'XComGameState_ChallengeData', ChallengeData )
	{
		break;
	}

	if (ChallengeData == none) // we're in PerRunner mode. Use regular enemies.
		return;

	ChallengeData.DefaultLeaderListOverride = 'CM_MechanizedArmyLeaders';
	ChallengeData.DefaultFollowerListOverride = 'CM_MechanizedArmyFollowers';
}

// -------------------------------------------------------
// Chryssalid Infestation
// -------------------------------------------------------

static function X2ChallengeEnemyForces CreateChryssalidInfestationSelector()
{
	local X2ChallengeEnemyForces	Template;

	`CREATE_X2TEMPLATE(class'X2ChallengeEnemyForces', Template, 'ChallengeChryssalidInfestation');

	Template.Weight = 1;
	Template.SelectEnemyForcesFn = ChryssalidInfestationSelector;
	Template.AdditionalTacticalGameplayTags.AddItem('DisableBossEncounters');

	return Template;
}

static function ChryssalidInfestationSelector( X2ChallengeEnemyForces Selector, XComGameState_MissionSite MissionSite, XComGameState_BattleData BattleData, XComGameState StartState )
{
	local XComGameState_ChallengeData ChallengeData;

	foreach StartState.IterateByClassType( class'XComGameState_ChallengeData', ChallengeData )
	{
		break;
	}

	if (ChallengeData == none) // we're in PerRunner mode. Use regular enemies.
		return;

	ChallengeData.DefaultLeaderListOverride = 'CM_ChryssalidInfestation';
	ChallengeData.DefaultFollowerListOverride = 'CM_ChryssalidInfestation';
}

// -------------------------------------------------------
// Codex Invasion
// -------------------------------------------------------

static function X2ChallengeEnemyForces CreateCodexInvasionSelector()
{
	local X2ChallengeEnemyForces	Template;

	`CREATE_X2TEMPLATE(class'X2ChallengeEnemyForces', Template, 'ChallengeCodexInvasion');

	Template.Weight = 1;
	Template.SelectEnemyForcesFn = CodexInvasionSelector;
	Template.AdditionalTacticalGameplayTags.AddItem('DisableBossEncounters');

	return Template;
}

static function CodexInvasionSelector( X2ChallengeEnemyForces Selector, XComGameState_MissionSite MissionSite, XComGameState_BattleData BattleData, XComGameState StartState )
{
	local XComGameState_ChallengeData ChallengeData;

	foreach StartState.IterateByClassType( class'XComGameState_ChallengeData', ChallengeData )
	{
		break;
	}

	if (ChallengeData == none) // we're in PerRunner mode. Use regular enemies.
		return;

	ChallengeData.DefaultLeaderListOverride = 'CM_CodexInvasion';
	ChallengeData.DefaultFollowerListOverride = 'CM_CodexInvasion';
}

// -------------------------------------------------------
// Riot Control
// -------------------------------------------------------

static function X2ChallengeEnemyForces CreateRiotControlSelector()
{
	local X2ChallengeEnemyForces	Template;

	`CREATE_X2TEMPLATE(class'X2ChallengeEnemyForces', Template, 'ChallengeRiotControl');

	Template.Weight = 1;
	Template.SelectEnemyForcesFn = RiotControlSelector;
	Template.AdditionalTacticalGameplayTags.AddItem('DisableBossEncounters');

	return Template;
}

static function RiotControlSelector( X2ChallengeEnemyForces Selector, XComGameState_MissionSite MissionSite, XComGameState_BattleData BattleData, XComGameState StartState )
{
	local XComGameState_ChallengeData ChallengeData;

	foreach StartState.IterateByClassType( class'XComGameState_ChallengeData', ChallengeData )
	{
		break;
	}

	if (ChallengeData == none) // we're in PerRunner mode. Use regular enemies.
		return;

	ChallengeData.DefaultLeaderListOverride = 'CM_RiotControlLeaders';
	ChallengeData.DefaultFollowerListOverride = 'CM_RiotControlFollowers';
}

// -------------------------------------------------------
// Muton Assault
// -------------------------------------------------------

static function X2ChallengeEnemyForces CreateMutonAssaultSelector()
{
	local X2ChallengeEnemyForces	Template;

	`CREATE_X2TEMPLATE(class'X2ChallengeEnemyForces', Template, 'ChallengeMutonAssault');

	Template.Weight = 1;
	Template.SelectEnemyForcesFn = MutonAssaultSelector;
	Template.AdditionalTacticalGameplayTags.AddItem('DisableBossEncounters');

	return Template;
}

static function MutonAssaultSelector( X2ChallengeEnemyForces Selector, XComGameState_MissionSite MissionSite, XComGameState_BattleData BattleData, XComGameState StartState )
{
	local XComGameState_ChallengeData ChallengeData;

	foreach StartState.IterateByClassType( class'XComGameState_ChallengeData', ChallengeData )
	{
		break;
	}

	if (ChallengeData == none) // we're in PerRunner mode. Use regular enemies.
		return;

	ChallengeData.DefaultLeaderListOverride = 'CM_MutonAssaultLeaders';
	ChallengeData.DefaultFollowerListOverride = 'CM_MutonAssaultFollowers';
}

// -------------------------------------------------------
// Purge
// -------------------------------------------------------

static function X2ChallengeEnemyForces CreatePurgeSelector()
{
	local X2ChallengeEnemyForces	Template;

	`CREATE_X2TEMPLATE(class'X2ChallengeEnemyForces', Template, 'ChallengePurge');

	Template.Weight = 1;
	Template.SelectEnemyForcesFn = PurgeSelector;
	Template.AdditionalTacticalGameplayTags.AddItem('DisableBossEncounters');

	return Template;
}

static function PurgeSelector( X2ChallengeEnemyForces Selector, XComGameState_MissionSite MissionSite, XComGameState_BattleData BattleData, XComGameState StartState )
{
	local XComGameState_ChallengeData ChallengeData;

	foreach StartState.IterateByClassType( class'XComGameState_ChallengeData', ChallengeData )
	{
		break;
	}

	if (ChallengeData == none) // we're in PerRunner mode. Use regular enemies.
		return;

	ChallengeData.DefaultLeaderListOverride = 'CM_PurgeLeaders';
	ChallengeData.DefaultFollowerListOverride = 'CM_PurgeFollowers';
}

// -------------------------------------------------------
// Brutal Leaders
// -------------------------------------------------------

static function X2ChallengeEnemyForces CreateBrutalLeadersSelector()
{
	local X2ChallengeEnemyForces	Template;

	`CREATE_X2TEMPLATE(class'X2ChallengeEnemyForces', Template, 'ChallengeBrutalLeaders');

	Template.Weight = 1;
	Template.SelectEnemyForcesFn = BrutalLeadersSelector;
	Template.AdditionalTacticalGameplayTags.AddItem('DisableBossEncounters');

	return Template;
}

static function BrutalLeadersSelector( X2ChallengeEnemyForces Selector, XComGameState_MissionSite MissionSite, XComGameState_BattleData BattleData, XComGameState StartState )
{
	local XComGameState_ChallengeData ChallengeData;

	foreach StartState.IterateByClassType( class'XComGameState_ChallengeData', ChallengeData )
	{
		break;
	}

	if (ChallengeData == none) // we're in PerRunner mode. Use regular enemies.
		return;

	ChallengeData.DefaultLeaderListOverride = 'CM_BrutalLeaders';
}

// -------------------------------------------------------
// Nightmares
// -------------------------------------------------------

static function X2ChallengeEnemyForces CreateNightmaresSelector()
{
	local X2ChallengeEnemyForces	Template;

	`CREATE_X2TEMPLATE(class'X2ChallengeEnemyForces', Template, 'ChallengeNightmares');

	Template.Weight = 1;
	Template.SelectEnemyForcesFn = NightmaresSelector;
	Template.AdditionalTacticalGameplayTags.AddItem('DisableBossEncounters');

	return Template;
}

static function NightmaresSelector( X2ChallengeEnemyForces Selector, XComGameState_MissionSite MissionSite, XComGameState_BattleData BattleData, XComGameState StartState )
{
	local XComGameState_ChallengeData ChallengeData;

	foreach StartState.IterateByClassType( class'XComGameState_ChallengeData', ChallengeData )
	{
		break;
	}

	if (ChallengeData == none) // we're in PerRunner mode. Use regular enemies.
		return;

	ChallengeData.DefaultLeaderListOverride = 'CM_NightmaresLeaders';
	ChallengeData.DefaultFollowerListOverride = 'CM_NightmaresFollowers';
}

// -------------------------------------------------------
// Beauty and Destruction
// -------------------------------------------------------

static function X2ChallengeEnemyForces CreateBeautyDestructionSelector()
{
	local X2ChallengeEnemyForces	Template;

	`CREATE_X2TEMPLATE(class'X2ChallengeEnemyForces', Template, 'ChallengeBeautyDestruction');

	Template.Weight = 1;
	Template.SelectEnemyForcesFn = BeautyDestructionSelector;
	Template.AdditionalTacticalGameplayTags.AddItem('DisableBossEncounters');

	return Template;
}

static function BeautyDestructionSelector( X2ChallengeEnemyForces Selector, XComGameState_MissionSite MissionSite, XComGameState_BattleData BattleData, XComGameState StartState )
{
	local XComGameState_ChallengeData ChallengeData;

	foreach StartState.IterateByClassType( class'XComGameState_ChallengeData', ChallengeData )
	{
		break;
	}

	if (ChallengeData == none) // we're in PerRunner mode. Use regular enemies.
		return;

	ChallengeData.DefaultLeaderListOverride = 'CM_BeautyDestructionLeaders';
	ChallengeData.DefaultFollowerListOverride = 'CM_BeautyDestructionFollowers';
}

// -------------------------------------------------------
// Puppeteers
// -------------------------------------------------------

static function X2ChallengeEnemyForces CreatePuppeteersSelector()
{
	local X2ChallengeEnemyForces	Template;

	`CREATE_X2TEMPLATE(class'X2ChallengeEnemyForces', Template, 'ChallengePuppeteers');

	Template.Weight = 1;
	Template.SelectEnemyForcesFn = PuppeteersSelector;
	Template.AdditionalTacticalGameplayTags.AddItem('DisableBossEncounters');

	return Template;
}

static function PuppeteersSelector( X2ChallengeEnemyForces Selector, XComGameState_MissionSite MissionSite, XComGameState_BattleData BattleData, XComGameState StartState )
{
	local XComGameState_ChallengeData ChallengeData;

	foreach StartState.IterateByClassType( class'XComGameState_ChallengeData', ChallengeData )
	{
		break;
	}

	if (ChallengeData == none) // we're in PerRunner mode. Use regular enemies.
		return;

	ChallengeData.DefaultLeaderListOverride = 'CM_PuppeteersLeaders';
	ChallengeData.DefaultFollowerListOverride = 'CM_PuppeteersFollowers';
}

// -------------------------------------------------------
// Monsters
// -------------------------------------------------------

static function X2ChallengeEnemyForces CreateMonstersSelector()
{
	local X2ChallengeEnemyForces	Template;

	`CREATE_X2TEMPLATE(class'X2ChallengeEnemyForces', Template, 'ChallengeMonsters');

	Template.Weight = 1;
	Template.SelectEnemyForcesFn = MonstersSelector;
	Template.AdditionalTacticalGameplayTags.AddItem('DisableBossEncounters');

	return Template;
}

static function MonstersSelector( X2ChallengeEnemyForces Selector, XComGameState_MissionSite MissionSite, XComGameState_BattleData BattleData, XComGameState StartState )
{
	local XComGameState_ChallengeData ChallengeData;

	foreach StartState.IterateByClassType( class'XComGameState_ChallengeData', ChallengeData )
	{
		break;
	}

	if (ChallengeData == none) // we're in PerRunner mode. Use regular enemies.
		return;

	ChallengeData.DefaultLeaderListOverride = 'CM_MonstersLeaders';
	ChallengeData.DefaultFollowerListOverride = 'CM_MonstersFollowers';
}

// This isn't being used, but I've left it in place for reference in case this is needed
static function RoboSquadSelector( X2ChallengeEnemyForces Selector, XComGameState_MissionSite MissionSite, XComGameState_BattleData BattleData, XComGameState StartState )
{
	local X2SelectedEncounterData NewEncounter, EmptyEncounter;
	local ScheduleBreakdown Breakdown;
	local PrePlacedEncounterPair Encounter;
	local int SpawnCount;

	MissionSite.SelectedMissionData.ForceLevel = BattleData.GetForceLevel( );
	MissionSite.SelectedMissionData.AlertLevel = BattleData.GetAlertLevel( );

	Breakdown = GetAScheduleBreakdownForMission( MissionSite );

	MissionSite.SelectedMissionData.SelectedMissionScheduleName = 'ChallengeRoboSquad';

	EmptyEncounter.EncounterSpawnInfo.Team = eTeam_Alien;
	EmptyEncounter.EncounterSpawnInfo.SkipSoldierVO = true;

	SpawnCount = 1;

	foreach Breakdown.StandardSpawns( Encounter )
	{
		NewEncounter = EmptyEncounter;

		NewEncounter.EncounterSpawnInfo.EncounterZoneDepth = Encounter.EncounterZoneDepthOverride;
		NewEncounter.EncounterSpawnInfo.EncounterZoneWidth = Encounter.EncounterZoneWidth;
		NewEncounter.EncounterSpawnInfo.EncounterZoneOffsetFromLOP = Encounter.EncounterZoneOffsetFromLOP;
		NewEncounter.EncounterSpawnInfo.EncounterZoneOffsetAlongLOP = Encounter.EncounterZoneOffsetAlongLOP;
		NewEncounter.EncounterSpawnInfo.SpawnLocationActorTag = Encounter.SpawnLocationActorTag;

		if (SpawnCount % 2 == 0)
		{
			NewEncounter.EncounterSpawnInfo.SelectedCharacterTemplateNames.AddItem( 'AdvMEC_M2' );
			NewEncounter.EncounterSpawnInfo.SelectedCharacterTemplateNames.AddItem( 'AdvMEC_M1' );
			NewEncounter.EncounterSpawnInfo.SelectedCharacterTemplateNames.AddItem( 'AdvMEC_M1' );
		}
		else
		{
			NewEncounter.EncounterSpawnInfo.SelectedCharacterTemplateNames.AddItem( 'AdvMEC_M1' );
			NewEncounter.EncounterSpawnInfo.SelectedCharacterTemplateNames.AddItem( 'AdvMEC_M1' );
			NewEncounter.EncounterSpawnInfo.SelectedCharacterTemplateNames.AddItem( 'AdvMEC_M1' );
		}

		NewEncounter.SelectedEncounterName = name( "Robo" $ SpawnCount++ );

		MissionSite.SelectedMissionData.SelectedEncounters.AddItem( NewEncounter );
	}

	foreach Breakdown.BossSpawns( Encounter )
	{
		NewEncounter = EmptyEncounter;

		NewEncounter.EncounterSpawnInfo.EncounterZoneDepth = Encounter.EncounterZoneDepthOverride;
		NewEncounter.EncounterSpawnInfo.EncounterZoneWidth = Encounter.EncounterZoneWidth;
		NewEncounter.EncounterSpawnInfo.EncounterZoneOffsetFromLOP = Encounter.EncounterZoneOffsetFromLOP;
		NewEncounter.EncounterSpawnInfo.EncounterZoneOffsetAlongLOP = Encounter.EncounterZoneOffsetAlongLOP;
		NewEncounter.EncounterSpawnInfo.SpawnLocationActorTag = Encounter.SpawnLocationActorTag;

		NewEncounter.EncounterSpawnInfo.SelectedCharacterTemplateNames.AddItem( 'Sectopod' );
		NewEncounter.EncounterSpawnInfo.SelectedCharacterTemplateNames.AddItem( 'AdvMEC_M2' );
		NewEncounter.EncounterSpawnInfo.SelectedCharacterTemplateNames.AddItem( 'AdvMEC_M2' );

		NewEncounter.SelectedEncounterName = name( "Robo" $ SpawnCount++ );

		MissionSite.SelectedMissionData.SelectedEncounters.AddItem( NewEncounter );
	}

	foreach Breakdown.WeakSpawns( Encounter )
	{
		NewEncounter = EmptyEncounter;

		NewEncounter.EncounterSpawnInfo.EncounterZoneDepth = Encounter.EncounterZoneDepthOverride;
		NewEncounter.EncounterSpawnInfo.EncounterZoneWidth = Encounter.EncounterZoneWidth;
		NewEncounter.EncounterSpawnInfo.EncounterZoneOffsetFromLOP = Encounter.EncounterZoneOffsetFromLOP;
		NewEncounter.EncounterSpawnInfo.EncounterZoneOffsetAlongLOP = Encounter.EncounterZoneOffsetAlongLOP;
		NewEncounter.EncounterSpawnInfo.SpawnLocationActorTag = Encounter.SpawnLocationActorTag;

		NewEncounter.EncounterSpawnInfo.SelectedCharacterTemplateNames.AddItem( 'AdvMEC_M1' );
		NewEncounter.EncounterSpawnInfo.SelectedCharacterTemplateNames.AddItem( 'AdvMEC_M1' );

		NewEncounter.SelectedEncounterName = name( "Robo" $ SpawnCount++ );

		MissionSite.SelectedMissionData.SelectedEncounters.AddItem( NewEncounter );
	}
}

static function ScheduleBreakdown GetAScheduleBreakdownForMission( XComGameState_MissionSite MissionSite )
{
	local XComTacticalMissionManager TacticalMissionManager;
	local name ScheduleName;
	local MissionSchedule SelectedMissionSchedule;
	local PrePlacedEncounterPair Encounter;
	local string EncounterID;
	local ScheduleBreakdown Breakdown;
	local ConfigurableEncounter ConfigEncounter;

	TacticalMissionManager = `TACTICALMISSIONMGR;

	ScheduleName = TacticalMissionManager.ChooseMissionSchedule( MissionSite );
	TacticalMissionManager.GetMissionSchedule( ScheduleName, SelectedMissionSchedule );

	foreach SelectedMissionSchedule.PrePlacedEncounters( Encounter )
	{
		TacticalMissionManager.GetConfigurableEncounter( Encounter.EncounterID, ConfigEncounter );
		if (ConfigEncounter.TeamToSpawnInto != eTeam_Alien)
		{
			continue;
		}

		if (Encounter.EncounterZoneDepthOverride < 0)
		{
			Encounter.EncounterZoneDepthOverride = SelectedMissionSchedule.EncounterZonePatrolDepth;
		}

		EncounterID = string( Encounter.EncounterID );
		if (InStr( EncounterID, "_BOSS" ) != -1)
		{
			Breakdown.BossSpawns.AddItem( Encounter );
		}
		else if (InStr( EncounterID, "_Standard" ) != -1)
		{
			Breakdown.StandardSpawns.AddItem( Encounter );
		}
		else if (InStr( EncounterID, "_Weak" ) != -1)
		{
			Breakdown.WeakSpawns.AddItem( Encounter );
		}
	}

	return Breakdown;
}

defaultproperties
{
	bShouldCreateDifficultyVariants = false
}