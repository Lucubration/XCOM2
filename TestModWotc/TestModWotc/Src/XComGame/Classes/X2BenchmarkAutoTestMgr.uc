//---------------------------------------------------------------------------------------
//  FILE:    X2BenchmarkAutoTestMgr.uc
//  AUTHOR:  Russell Aasland  --  08/26/2016
//  PURPOSE: Benchmark various perf stresses of tactical and strategy sessions
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class X2BenchmarkAutoTestMgr extends AutoTestManager
	config(Benchmark)
	native(Core);

var XComGameState StartState;
var XComGameState_BenchmarkConfig ActiveBenchmarkState;
var X2BenchmarkConfigClass BenchmarkConfig;

var XComParcelManager ParcelManager;
var X2ChallengeTemplateManager ChallengeTemplateManager;

var StateObjectReference HumanPlayerRef;
var StateObjectReference XComGroupRef;

var XComGameState_Unit LastUnitStateToExecute;
var float UnitExecutingStartTime;

// delegate of the current update function to run in the tick. Since we can't do full latent
// execution we can emulate it here 
delegate CurrentUpdateFunction();

event PostBeginPlay()
{
	Super.PostBeginPlay();

	SetTimer(0.25, true); // base autotest is 1 second, let's go a little faster
}

event Timer()
{
	if(CurrentUpdateFunction != none)
	{
		CurrentUpdateFunction();
	}
}


function InitializeOptions(string Options)
{
	local XComGameStateHistory History;
	local XComGameState_BattleData BattleData;

	History = `XCOMHISTORY;

	BattleData = XComGameState_BattleData( History.GetSingleGameStateObjectForClass( class'XComGameState_BattleData', true ) );

	ReadCommandlineParameters();	

	if (`ONLINEEVENTMGR.bAutoTestLoad)
	{
		CurrentUpdateFunction = WaitOnPlotLoad;
	}
	else if (BattleData == none || BattleData.m_strDesc != "BenchmarkTest" || BattleData.TacticalTurnCount > 0)
	{
		CurrentUpdateFunction = WaitForMainMenu;
	}
	else
	{
		CurrentUpdateFunction = LoadPlotLayout;

		ParcelManager = `PARCELMGR;
		ChallengeTemplateManager = class'X2ChallengeTemplateManager'.static.GetChallengeTemplateManager( );
		StartState = History.GetStartState( );
	}

	`XENGINE.TemporarilyDisableRedscreens();
}

function WaitForMainMenu()
{
	local string AutoTestSaveName;
	local XComOnlineEventMgr OnlineEventManager;

	OnlineEventManager = `ONLINEEVENTMGR;

	if (OnlineEventManager.MCP == none) // wait for the online event manager to init, this seems like an easy check as there is no real flag for it being done
	{
		return;
	}

	ParcelManager = `PARCELMGR;
	ChallengeTemplateManager = class'X2ChallengeTemplateManager'.static.GetChallengeTemplateManager( );

	AutoTestSaveName = `XENGINE.AutoTestSaveName;

	if (AutoTestSaveName == "")
	{
		BuildBattleStartState( );

		CurrentUpdateFunction = LoadPlot;
	}
	else
	{
		OnlineEventManager.LoadSaveFromFile( AutoTestSaveName, ReadSaveGameComplete );
		OnlineEventManager.bAutoTestLoad = true;

		CurrentUpdateFunction = none;
	}
}

function ReadSaveGameComplete(bool bWasSuccessful)
{
	local XComGameStateHistory History;
	local XComGameState_BattleData BattleData;

	if (bWasSuccessful)
	{
		History = `XCOMHISTORY;

		BattleData = XComGameState_BattleData( History.GetSingleGameStateObjectForClass( class'XComGameState_BattleData', true ) );

		ConsoleCommand( "open " $ BattleData.MapData.PlotMapName );
	}
}

function LoadPlot( )
{
	//General locals
	local MissionDefinition Mission;
	local array<PlotDefinition> CandidatePlots;
	local PlotDefinition SelectedPlotDef;
	local int Index;
	local Vector ZeroVector;
	local Rotator ZeroRotator;
	local LevelStreaming PlotLevel;
	local XComGameState_BattleData BattleDataState;
	local XComGameState_MissionSite MissionSite;

	foreach StartState.IterateByClassType( class'XComGameState_BattleData', BattleDataState )
	{
		break;
	}

	if (ActiveBenchmarkState.ActiveScenario.PlotName != "")
	{
		BattleDataState.PlotSelectionType = ePlotSelection_Specify;
		BattleDataState.MapData.PlotMapName = ActiveBenchmarkState.ActiveScenario.PlotName;
	}

	// get the pool of possible plots
	switch(BattleDataState.PlotSelectionType)
	{
		case ePlotSelection_Random:
			// any plot will do
			CandidatePlots = ParcelManager.arrPlots;
			break;

		case ePlotSelection_Type:
			// all plots of the desired type
			ParcelManager.GetPlotDefinitionsForPlotType(BattleDataState.PlotType, BattleDataState.MapData.Biome, CandidatePlots);
			break;

		case ePlotSelection_Specify:
			// the specified plot map
			if( BattleDataState.MapData.PlotMapName != "" )
			{
				CandidatePlots.AddItem(ParcelManager.GetPlotDefinition(BattleDataState.MapData.PlotMapName, BattleDataState.MapData.Biome));
			}
			break;
	}

	// Now filter the candidate list by mission type (some plots only support certain mission types)
	if(BattleDataState.m_iMissionType >= 0)
	{
		Mission = `TACTICALMISSIONMGR.arrMissions[BattleDataState.m_iMissionType];
		ParcelManager.RemovePlotDefinitionsThatAreInvalidForMission(CandidatePlots, Mission);
		if( CandidatePlots.Length == 0 )
		{
			// none of the candidates were valid for the mission, so fall back to using any plot
			CandidatePlots = ParcelManager.arrPlots;
			ParcelManager.RemovePlotDefinitionsThatAreInvalidForMission(CandidatePlots, Mission);
			`Redscreen("Selected parcel or parcel type does not support the selected mission, falling back to to using any valid plot.");
		}
	}

	// if we aren't in specifying an exact map, remove all maps that are marked as exclude from strategy
	if(BattleDataState.PlotSelectionType != ePlotSelection_Specify)
	{
		for(Index = CandidatePlots.Length - 1; Index >= 0; Index--)
		{
			if(CandidatePlots[Index].ExcludeFromStrategy)
			{
				CandidatePlots.Remove(Index, 1);
			}
			else if	(InStr( CandidatePlots[Index].MapName, "Plot_CSH_Stronghold_Sarcophagus") != INDEX_NONE)
			{
				CandidatePlots.Remove(Index, 1);
			}


		}
	}

	if (CandidatePlots.Length == 0)
	{
		//No valid plots for this mission type, try again
		WaitForMainMenu();
		return;
	}

	// and pick one
	Index = `SYNC_RAND_TYPED(CandidatePlots.Length);
	SelectedPlotDef = CandidatePlots[Index];

	ActiveBenchmarkState.ActiveScenario.PlotName = SelectedPlotDef.MapName;

	// notify the deck manager that we have used this plot
	class'X2CardManager'.static.GetCardManager().MarkCardUsed('Plots', SelectedPlotDef.MapName);

	// need to add the plot type to make sure it's in the deck
	class'X2CardManager'.static.GetCardManager().AddCardToDeck('PlotTypes', ParcelManager.GetPlotDefinition(SelectedPlotDef.MapName).strType);
	class'X2CardManager'.static.GetCardManager().MarkCardUsed('PlotTypes', ParcelManager.GetPlotDefinition(SelectedPlotDef.MapName).strType);

	// load the selected plot
	BattleDataState.MapData.PlotMapName = SelectedPlotDef.MapName;
	PlotLevel = `MAPS.AddStreamingMap(BattleDataState.MapData.PlotMapName, ZeroVector, ZeroRotator, false, true);
	PlotLevel.bForceNoDupe = true;

	// make sure our biome is sane for the plot we selected
	if(BattleDataState.MapData.Biome == "" 
		|| (SelectedPlotDef.ValidBiomes.Length > 0 && SelectedPlotDef.ValidBiomes.Find(BattleDataState.MapData.Biome) == INDEX_NONE))
	{
		if(SelectedPlotDef.ValidBiomes.Length > 0)
		{
			Index = `SYNC_RAND(SelectedPlotDef.ValidBiomes.Length);
			BattleDataState.MapData.Biome = SelectedPlotDef.ValidBiomes[Index];
		}
		else
		{
			BattleDataState.MapData.Biome = "";
		}
	}

	foreach StartState.IterateByClassType( class'XComGameState_MissionSite', MissionSite )
	{
		break;
	}

	MissionSite.GeneratedMission.Plot = SelectedPlotDef;
	if (BattleDataState.MapData.Biome != "")
		MissionSite.GeneratedMission.Biome = `PARCELMGR.GetBiomeDefinition( BattleDataState.MapData.Biome );

	CurrentUpdateFunction = LoadPlotLayout;

	ConsoleCommand( "open " $ SelectedPlotDef.MapName );
}

function LoadPlotLayout( )
{
	local XComGameState_BattleData BattleDataState;
	local int ProcLevelSeed;

	//Wait for the plot to load
	if (!`MAPS.IsStreamingComplete())
	{
		return;
	}

	foreach StartState.IterateByClassType( class'XComGameState_BattleData', BattleDataState )
	{
		break;
	}

	if (ActiveBenchmarkState.ActiveScenario.LevelSeed < 0)
	{
		ProcLevelSeed = class'Engine'.static.GetEngine().GetARandomSeed();
		BattleDataState.iLevelSeed = ProcLevelSeed;
		ActiveBenchmarkState.ActiveScenario.LevelSeed = ProcLevelSeed;
	}
	else
	{
		BattleDataState.iLevelSeed = ActiveBenchmarkState.ActiveScenario.LevelSeed;
	}

	`MAPS.LoadTimer_Start();

	ParcelManager.bBlockingLoadParcels = false; //Set the ParcelManager to operate in async mode
	ParcelManager.GenerateMap(ProcLevelSeed);

	CurrentUpdateFunction = BeginMatch;
}

function WaitOnPlotLoad( )
{
	//Wait for the plot to load
	if (!`MAPS.IsStreamingComplete())
	{
		return;
	}

	// start the battle
	`TACTICALGRI.InitBattle();

	CurrentUpdateFunction = WaitingForMatchToFinishInitializing;
}

function BeginMatch( )
{
	// wait for the map to finish generating
	if(ParcelManager.IsGeneratingMap())
	{
		return;
	}

	// make sure pathing is up to date before we transition to the game
	ParcelManager.RebuildWorldData();

	// start the battle
	`TACTICALGRI.InitBattle();

	CurrentUpdateFunction = WaitingForMatchToFinishInitializing;
}

function WaitingForMatchToFinishInitializing( )
{
	local Object ThisObj;
	local XComGameStateHistory History;
	local XComGameState_Unit UnitState;

	if( (`TACTICALRULES.GetStateName() == 'CreateTacticalGame') || (`TACTICALRULES.GetStateName() == 'LoadTacticalGame'))
	{
		return;
	}

	ThisObj = self;
	`XEVENTMGR.RegisterForEvent( ThisObj, 'UnitDied', OnUnitDied, ELD_OnVisualizationBlockCompleted );

	History = `XCOMHISTORY;
	foreach History.IterateByClassType(class'XComGameState_Unit', UnitState)
	{
		if (UnitState.GetTeam() == eTeam_XCom)
		{
			HumanPlayerRef = UnitState.ControllingPlayer;
			XComGroupRef.ObjectID = UnitState.GroupMembershipID;

			break;
		}
	}

	CurrentUpdateFunction = WaitOnVisualizer;
}

function GiveTurnOrders( )
{
	local XComGameStateHistory History;
	local X2TacticalGameRuleset TacticalRules;
	local XComGameState_Unit UnitState;
	local name AutoRunBT;
	local XComGameState_TimerData TimerState;

	local XComGameState_Player PlayerState;
	local XGPlayer Player;


	TacticalRules = `TACTICALRULES;

	if (TacticalRules.GetCachedUnitActionPlayerRef() != HumanPlayerRef ||
		TacticalRules.CachedUnitActionInitiativeRef != XComGroupRef)
	{
		return;
	}

	History = `XCOMHISTORY;
	TimerState = XComGameState_TimerData(History.GetSingleGameStateObjectForClass(class'XComGameState_TimerData'));

	foreach History.IterateByClassType(class'XComGameState_Unit', UnitState)
	{
		if (UnitState.ControllingPlayerIsAI()) // only the human teams
			continue;

		if (UnitState.GetTeam() != eTeam_XCom) // only the xcom team
			continue;

		if ( !TacticalRules.UnitHasActionsAvailable(UnitState) ) // do they have actions?
			continue;

		if (!UnitState.IsAbleToAct()) // can they use their actions?
			continue;

		// are they bound by a viper (not included in AbleToAct)
		if (UnitState.AffectedByEffectNames.Find( 'BindSustainedEffect' ) != INDEX_NONE)
			continue;

		// do they have a behavior tree
		AutoRunBT = Name(UnitState.GetMyTemplate().strAutoRunNonAIBT);
		if (AutoRunBT == '')
		{
			AutoRunBT = Name(UnitState.GetMyTemplate().strBehaviorTree);
		}

		UnitState.AutoRunBehaviorTree(AutoRunBT, UnitState.NumActionPoints());

		if (UnitState != LastUnitStateToExecute)
		{
			UnitExecutingStartTime = TimerState.GetAppSeconds();
			LastUnitStateToExecute = UnitState;
		}

/*
		if( TimerState.GetAppSeconds() - UnitExecutingStartTime  > 25.0f)
		{
			PlayerState = XComGameState_Player(History.GetGameStateForObjectID(UnitState.GetAssociatedPlayerID())); 
			Player = XGPlayer(PlayerState.GetVisualizer());

			`LogAIActions("X2BenchmarkManager::Exceeded WaitingForNewStates TimeLimit!  Calling Player.EndTurn()");
			class'XGAIPlayer'.static.DumpAILog();
			Player.EndTurn(ePlayerEndTurnType_AllUnitsDone);
		}
*/

		CurrentUpdateFunction = WaitOnVisualizer;
		break;
	}

	if (TimerState.GetAppSeconds() - UnitExecutingStartTime > 25.0f)
	{
		PlayerState = XComGameState_Player(History.GetGameStateForObjectID(LastUnitStateToExecute.GetAssociatedPlayerID()));
		Player = XGPlayer(PlayerState.GetVisualizer());

		`LogAIActions("X2BenchmarkManager::Exceeded WaitingForNewStates TimeLimit!  Calling Player.EndTurn()");
		class'XGAIPlayer'.static.DumpAILog();
		Player.EndTurn(ePlayerEndTurnType_AllUnitsDone);

		UnitExecutingStartTime = TimerState.GetAppSeconds();
	}

}

function WaitOnVisualizer( )
{
	local XComPresentationLayer PresLayer;
	local X2TacticalGameRuleset TacticalRules;

	PresLayer = `PRES;
	TacticalRules = `TACTICALRULES;

	// clear any pending loot dialogs
	if (PresLayer.m_kInventoryTactical != none)
	{
		PresLayer.m_kInventoryTactical.m_kButton_OK.Click();
	}

	// Run another behavior tree
	if (!TacticalRules.WaitingForVisualizer())
	{
		CurrentUpdateFunction = GiveTurnOrders;
		UnitExecutingStartTime = class'XComGameState_TimerData'.static.GetAppSeconds();
	}
}

function EventListenerReturn OnUnitDied(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local XComGameState_Unit DeadUnit;
	local XComGameState_Player ControllingPlayer;
	local XGPlayer Player;
	local array<XComGameState_Unit> Units;

	DeadUnit = XComGameState_Unit(EventData);
	ControllingPlayer = XComGameState_Player( `XCOMHISTORY.GetGameStateForObjectID( DeadUnit.ControllingPlayer.ObjectID ) );
	Player = XGPlayer(ControllingPlayer.GetVisualizer());

	Player.GetAliveUnits( Units, , true );

	if (Units.Length == 0)
	{
		ConsoleCommand( "disconnect" );

		//WaitForMainMenu( );
	}

	return ELR_NoInterrupt;
}

private function BuildBattleStartState( )
{
	local XComGameStateHistory History;
	local XComGameStateContext_TacticalGameRule TacticalStartContext;
	local XComGameState_BattleData BattleDataState;
	local XComGameState_Player XComPlayerState;
	local XComGameState_Player EnemyPlayerState;
	local XComGameState_Player CivilianPlayerState;
	local XComGameState_Player TheLostPlayerState;
	local XComGameState_Player ResistancePlayerState;
	local XComGameState_Analytics Analytics;
	local XComGameState_CampaignSettings CampaignSettings;
	local XComGameState_HeadquartersXCom HeadquartersStateObject;
	local XComGameState_TimerData Timer;
	local int AlertLevel, ForceLevel;
	local X2ChallengeAlertForce AlertForceSelector;
	local X2ChallengeEnemyForces EnemyForcesSelector;
	local XComGameState_MissionSite MissionSite;
	local X2DataTemplate DataTemplate;
	local X2QuestItemTemplate QuestItemTemplate;
	local XComGameState_BenchmarkConfig PrevBenchmarkState;
	local bool bHasScenario;

	History = `XCOMHISTORY;

	PrevBenchmarkState = XComGameState_BenchmarkConfig( History.GetSingleGameStateObjectForClass(class'XComGameState_BenchmarkConfig', true) );

	History.ResetHistory(, false);

	TacticalStartContext = XComGameStateContext_TacticalGameRule( class'XComGameStateContext_TacticalGameRule'.static.CreateXComGameStateContext( ) );
	TacticalStartContext.GameRuleType = eGameRule_TacticalGameStart;
	StartState = History.CreateNewGameState( false, TacticalStartContext );

	ActiveBenchmarkState = XComGameState_BenchmarkConfig(StartState.CreateNewStateObject( class'XComGameState_BenchmarkConfig', BenchmarkConfig) );

	if (PrevBenchmarkState != none)
	{
		ActiveBenchmarkState.ActiveScenarioIdx = PrevBenchmarkState.ActiveScenarioIdx + 1;
	}
	else
	{
		ActiveBenchmarkState.ActiveScenarioIdx = 0;
	}

	bHasScenario = BenchmarkConfig.GetNextScenario(ActiveBenchmarkState.ActiveScenario, ActiveBenchmarkState.ActiveScenarioIdx);
	if (!bHasScenario)
	{
		ConsoleCommand( "EXIT" );
		return;
	}

	BattleDataState = XComGameState_BattleData( StartState.CreateNewStateObject( class'XComGameState_BattleData' ) );

	foreach class'X2ItemTemplateManager'.static.GetItemTemplateManager().IterateTemplates(DataTemplate, none)
	{
		QuestItemTemplate = X2QuestItemTemplate(DataTemplate);
		if(QuestItemTemplate != none)
		{
			BattleDataState.m_nQuestItem = QuestItemTemplate.DataName;
		}
	}

	/*
	BattleDataState.MapData = OldBattleData.MapData;
	BattleDataState.PlotData = OldBattleData.PlotData;
	BattleDataState.iLevelSeed = OldBattleData.iLevelSeed;
	BattleDataState.m_iMissionType = OldBattleData.m_iMissionType;
	BattleDataState.m_nQuestItem = OldBattleData.m_nQuestItem;
	BattleDataState.PlotType = OldBattleData.PlotType;
	*/

	// Civilians are always pro-advent
	BattleDataState.SetPopularSupport( 0 );
	BattleDataState.SetMaxPopularSupport( 1 );

	BattleDataState.m_strDesc = "BenchmarkTest"; //If you change this, be aware that this is how the ruleset knows the battle is an autotest
	BattleDataState.m_strOpName = class'XGMission'.static.GenerateOpName( false );
	BattleDataState.m_strMapCommand = "open" @ BattleDataState.MapData.PlotMapName $ "?game=XComGame.XComTacticalGame";

	XComPlayerState = class'XComGameState_Player'.static.CreatePlayer( StartState, eTeam_XCom );
	XComPlayerState.bPlayerReady = true; // Single Player game, this will be synchronized out of the gate!
	BattleDataState.PlayerTurnOrder.AddItem( XComPlayerState.GetReference( ) );

	EnemyPlayerState = class'XComGameState_Player'.static.CreatePlayer( StartState, eTeam_Alien );
	EnemyPlayerState.bPlayerReady = true; // Single Player game, this will be synchronized out of the gate!
	BattleDataState.PlayerTurnOrder.AddItem( EnemyPlayerState.GetReference( ) );

	CivilianPlayerState = class'XComGameState_Player'.static.CreatePlayer( StartState, eTeam_Neutral );
	CivilianPlayerState.bPlayerReady = true; // Single Player game, this will be synchronized out of the gate!
	BattleDataState.CivilianPlayerRef = CivilianPlayerState.GetReference( );

	TheLostPlayerState = class'XComGameState_Player'.static.CreatePlayer(StartState, eTeam_TheLost);
	TheLostPlayerState.bPlayerReady = true; // Single Player game, this will be synchronized out of the gate!
	BattleDataState.PlayerTurnOrder.AddItem(TheLostPlayerState.GetReference());

	ResistancePlayerState = class'XComGameState_Player'.static.CreatePlayer(StartState, eTeam_Resistance);
	ResistancePlayerState.bPlayerReady = true; // Single Player game, this will be synchronized out of the gate!
	BattleDataState.PlayerTurnOrder.AddItem(ResistancePlayerState.GetReference());

	// create a default cheats object
	StartState.CreateNewStateObject( class'XComGameState_Cheats' );

	Analytics = XComGameState_Analytics( StartState.CreateNewStateObject( class'XComGameState_Analytics' ) );
	Analytics.SubmitToFiraxisLive = false;

	CampaignSettings = XComGameState_CampaignSettings( StartState.CreateNewStateObject( class'XComGameState_CampaignSettings' ) );
	CampaignSettings.SetDifficulty( 1 ); // Force benchmark to 'Vetern' difficulty
	//CampaignSettings.SetIronmanEnabled( true );
	CampaignSettings.SetSuppressFirstTimeNarrativeEnabled( true );
	CampaignSettings.SetTutorialEnabled( false );

	HeadquartersStateObject = XComGameState_HeadquartersXCom( StartState.CreateNewStateObject( class'XComGameState_HeadquartersXCom' ) );
	HeadquartersStateObject.AdventLootWeight = class'XComGameState_HeadquartersXCom'.default.StartingAdventLootWeight;
	HeadquartersStateObject.AlienLootWeight = class'XComGameState_HeadquartersXCom'.default.StartingAlienLootWeight;
	HeadquartersStateObject.bHasPlayedAmbushTutorial = true;
	HeadquartersStateObject.bHasPlayedMeleeTutorial = true;
	HeadquartersStateObject.bHasPlayedNeutralizeTargetTutorial = true;
	HeadquartersStateObject.SetGenericKeyValue( "NeutralizeTargetTutorial", 1 );

	class'XComGameState_HeadquartersResistance'.static.SetUpHeadquarters(StartState, false);

	StartState.CreateNewStateObject( class'XComGameState_HeadquartersAlien' );

	StartState.CreateNewStateObject( class'XComGameState_ObjectivesList' );

	Timer = XComGameState_TimerData( StartState.CreateNewStateObject( class'XComGameState_TimerData' ) );
	Timer.bIsChallengeModeTimer = true;
	Timer.SetTimerData( EGSTT_AppRelativeTime, EGSTDT_Down, EGSTRT_None );
	Timer.SetRealTimeTimer( 30 * 60 );
	Timer.bStopTime = true;

	class'XComGameState_GameTime'.static.CreateGameStartTime( StartState );

	AddRandomSoldiers( XComPlayerState, HeadquartersStateObject );

	MissionSite = SetupMissionSite( BattleDataState );

	BattleDataState.SetGlobalAbilityEnabled( 'PlaceEvacZone', false, StartState );

	AlertForceSelector = X2ChallengeAlertForce( GetChallengeTemplate( ActiveBenchmarkState.ActiveScenario.AlertForceLevelSelectorName, class'X2ChallengeAlertForce' ) );
	class'X2ChallengeAlertForce'.static.SelectAlertAndForceLevels( AlertForceSelector, StartState, HeadquartersStateObject, AlertLevel, ForceLevel );

	BattleDataState.SetAlertLevel( AlertLevel );
	BattleDataState.SetForceLevel( ForceLevel );

	EnemyForcesSelector = X2ChallengeEnemyForces( GetChallengeTemplate( ActiveBenchmarkState.ActiveScenario.EnemyForcesSelectorName, class'X2ChallengeEnemyForces' ) );
	class'X2ChallengeEnemyForces'.static.SelectEnemyForces( EnemyForcesSelector, MissionSite, BattleDataState, StartState );

	History.AddGameStateToHistory( StartState );

	`XENGINE.RegisterForAutoTestEvents();

}

private function AddRandomSoldiers( XComGameState_Player XComPlayerState, XComGameState_HeadquartersXCom HeadquartersStateObject )
{
	local XGCharacterGenerator CharacterGenerator;
	local int SoldierCount, AlienCount;
	local int SoldierIndex;
	local X2ChallengeSquadSize SquadSizeSelector;
	local X2ChallengeSoldierClass ClassSelector;
	local X2ChallengeSoldierRank RankSelector;
	local X2ChallengeArmor ArmorSelector;
	local X2ChallengePrimaryWeapon PrimaryWeaponSelector;
	local X2ChallengeSecondaryWeapon SecondaryWeaponSelector;
	local X2ChallengeUtility UtilityItemSelector;
	local array<name> ClassNames;
	local XComGameState_Unit BuildUnit;
	local TSoldier Soldier;
	local X2CharacterTemplate CharTemplate;
	local X2SoldierClassTemplate ClassTemplate;
	local array<XComGameState_Unit> XComUnits;
	local name RequiredLoadout;

	SquadSizeSelector = X2ChallengeSquadSize( GetChallengeTemplate( ActiveBenchmarkState.ActiveScenario.SquadSizeSelectorName, class'X2ChallengeSquadSize' ) );
	class'X2ChallengeSquadSize'.static.SelectSquadSize( SquadSizeSelector, SoldierCount, AlienCount );
	SoldierCount += AlienCount;

	ClassSelector = X2ChallengeSoldierClass( GetChallengeTemplate( ActiveBenchmarkState.ActiveScenario.ClassSelectorName, class'X2ChallengeSoldierClass' ) );
	ClassNames = class'X2ChallengeSoldierClass'.static.SelectSoldierClasses( ClassSelector, SoldierCount );

	CharTemplate = class'X2CharacterTemplateManager'.static.GetCharacterTemplateManager( ).FindCharacterTemplate( 'Soldier' );
	`assert(CharTemplate != none);
	CharacterGenerator = `XCOMGRI.Spawn( CharTemplate.CharacterGeneratorClass );
	`assert(CharacterGenerator != None);

	for (SoldierIndex = 0; SoldierIndex < SoldierCount; ++SoldierIndex)
	{
		ClassTemplate = class'X2SoldierClassTemplateManager'.static.GetSoldierClassTemplateManager( ).FindSoldierClassTemplate( ClassNames[SoldierIndex] );
		`assert(ClassTemplate != none);

		BuildUnit = CharTemplate.CreateInstanceFromTemplate( StartState );
		BuildUnit.SetSoldierClassTemplate( ClassTemplate.DataName );
		BuildUnit.SetControllingPlayer( XComPlayerState.GetReference( ) );

		// Randomly roll what the character looks like
		Soldier = CharacterGenerator.CreateTSoldier( );
		BuildUnit.SetTAppearance( Soldier.kAppearance );
		BuildUnit.SetCharacterName( Soldier.strFirstName, Soldier.strLastName, Soldier.strNickName );
		BuildUnit.SetCountry( Soldier.nmCountry );
		if (!BuildUnit.HasBackground( ))
			BuildUnit.GenerateBackground( , CharacterGenerator.BioCountryName);

		HeadquartersStateObject.Squad.AddItem( BuildUnit.GetReference( ) );
		XComUnits.AddItem( BuildUnit );
	}

	RankSelector = X2ChallengeSoldierRank( GetChallengeTemplate( ActiveBenchmarkState.ActiveScenario.RankSelectorName, class'X2ChallengeSoldierRank' ) );
	class'X2ChallengeSoldierRank'.static.SelectSoldierRanks( RankSelector, XComUnits, StartState );

	ArmorSelector = X2ChallengeArmor( GetChallengeTemplate( ActiveBenchmarkState.ActiveScenario.ArmorSelectorName, class'X2ChallengeArmor' ) );
	class'X2ChallengeArmor'.static.SelectSoldierArmor( ArmorSelector, XComUnits, StartState );

	PrimaryWeaponSelector = X2ChallengePrimaryWeapon( GetChallengeTemplate( ActiveBenchmarkState.ActiveScenario.PrimaryWeaponSelectorName, class'X2ChallengePrimaryWeapon' ) );
	class'X2ChallengePrimaryWeapon'.static.SelectSoldierPrimaryWeapon( PrimaryWeaponSelector, XComUnits, StartState );

	SecondaryWeaponSelector = X2ChallengeSecondaryWeapon( GetChallengeTemplate( ActiveBenchmarkState.ActiveScenario.SecondaryWeaponSelectorName, class'X2ChallengeSecondaryWeapon' ) );
	class'X2ChallengeSecondaryWeapon'.static.SelectSoldierSecondaryWeapon( SecondaryWeaponSelector, XComUnits, StartState );

	UtilityItemSelector = X2ChallengeUtility( GetChallengeTemplate( ActiveBenchmarkState.ActiveScenario.UtilityItemSelectorName, class'X2ChallengeUtility' ) );
	class'X2ChallengeUtility'.static.SelectSoldierUtilityItems( UtilityItemSelector, XComUnits, StartState );

	//  Always apply the template's required loadout. XPad's and whatnot
	for (SoldierIndex = 0; SoldierIndex < SoldierCount; ++SoldierIndex)
	{
		RequiredLoadout = CharTemplate.RequiredLoadout;
		if (RequiredLoadout != '')
			XComUnits[SoldierIndex].ApplyInventoryLoadout( StartState, RequiredLoadout );
	}

	CharacterGenerator.Destroy( );
}

private function XComGameState_MissionSite SetupMissionSite( XComGameState_BattleData BattleDataState )
{
	local XComGameState_Continent Continent;
	local XComGameState_WorldRegion Region;

	local X2StrategyElementTemplateManager StratMgr;
	local array<X2StrategyElementTemplate> ContinentDefinitions;
	local X2ContinentTemplate RandContinentTemplate;
	local X2WorldRegionTemplate RandRegionTemplate;
	local XComGameState_MissionSite MissionSite;

	local int RandContinent, RandRegion;
	local Vector CenterLoc, RegionExtents;

	if (ActiveBenchmarkState.ActiveScenario.MissionType == "")
	{
		ActiveBenchmarkState.ActiveScenario.MissionType = class'X2AutoPlayManager'.static.GetRandomValidMissionTypeForAutoRun( );	
	}
	BattleDataState.m_iMissionType = `TACTICALMISSIONMGR.arrMissions.Find( 'sType', ActiveBenchmarkState.ActiveScenario.MissionType );

	StratMgr = class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager( );
	ContinentDefinitions = StratMgr.GetAllTemplatesOfClass( class'X2ContinentTemplate' );

	RandContinent = `SYNC_RAND(ContinentDefinitions.Length);
	RandContinentTemplate = X2ContinentTemplate( ContinentDefinitions[ RandContinent ] );

	RandRegion = `SYNC_RAND( RandContinentTemplate.Regions.Length );
	RandRegionTemplate = X2WorldRegionTemplate( StratMgr.FindStrategyElementTemplate( RandContinentTemplate.Regions[ RandRegion ] ) );

	Continent = XComGameState_Continent( StartState.CreateNewStateObject( class'XComGameState_Continent', RandContinentTemplate ) );

	Region = XComGameState_WorldRegion( StartState.CreateNewStateObject( class'XComGameState_WorldRegion', RandRegionTemplate ) );

	Continent.AssignRegions( StartState );

	// Choose random location from the region
	RegionExtents.X = (RandRegionTemplate.Bounds[ 0 ].fRight - RandRegionTemplate.Bounds[ 0 ].fLeft) / 2.0f;
	RegionExtents.Y = (RandRegionTemplate.Bounds[ 0 ].fBottom - RandRegionTemplate.Bounds[ 0 ].fTop) / 2.0f;
	CenterLoc.x = RandRegionTemplate.Bounds[ 0 ].fLeft + RegionExtents.X;
	CenterLoc.y = RandRegionTemplate.Bounds[ 0 ].fTop + RegionExtents.Y;

	MissionSite = XComGameState_MissionSite( StartState.CreateNewStateObject( class'XComGameState_MissionSite' ) );
	MissionSite.Location = CenterLoc + (`SYNC_VRAND() * RegionExtents);
	MissionSite.Continent.ObjectID = Continent.ObjectID;
	MissionSite.Region.ObjectID = Region.ObjectID;

	MissionSite.GeneratedMission.MissionID = MissionSite.ObjectID;
	MissionSite.GeneratedMission.Mission = `TACTICALMISSIONMGR.arrMissions[ BattleDataState.m_iMissionType ];
	MissionSite.GeneratedMission.LevelSeed = BattleDataState.iLevelSeed;
	MissionSite.GeneratedMission.BattleOpName = BattleDataState.m_strOpName;
	MissionSite.GeneratedMission.BattleDesc = "BenchmarkTestManager";
	MissionSite.GeneratedMission.MissionQuestItemTemplate = BattleDataState.m_nQuestItem;

	BattleDataState.m_iMissionID = MissionSite.ObjectID;

	return MissionSite;
}

private simulated function X2ChallengeTemplate GetChallengeTemplate( out name TemplateName, class<X2ChallengeTemplate> TemplateType )
{
	local X2ChallengeTemplate Template;

	if (TemplateName == '') // no specified template, randomize
	{
		Template = ChallengeTemplateManager.GetRandomChallengeTemplateOfClass( TemplateType );
		TemplateName = Template.DataName;
		return Template;
	}

	Template = ChallengeTemplateManager.FindChallengeTemplate( TemplateName );
	if (Template != none)
		return Template;

	// Be more fault tolerant by returning a random one if we can't find the specified one.
	Template = ChallengeTemplateManager.GetRandomChallengeTemplateOfClass( TemplateType );
	TemplateName = Template.DataName;
	return Template;
}

native function ReadCommandlineParameters();