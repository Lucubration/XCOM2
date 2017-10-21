//---------------------------------------------------------------------------------------
//  FILE:    XComGameState_Analytics.uc
//  AUTHOR:  Scott Ramsay  --  4/1/2015
//  PURPOSE: State object that handles collection of all metrics at a "Game History level"
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class XComGameState_Analytics extends XComGameState_BaseObject
	native(Core)
	config(GameData);

struct UnitAnalyticEntry
{
	var int ObjectID;
	var float Value;
};

struct native AnalyticEntry
{
	var string Key;
	var float Value;

	structcpptext
	{
		/** Constructors */
		FAnalyticEntry() { appMemzero(this, sizeof(FAnalyticEntry)); }
		FAnalyticEntry(EEventParm)
		{
			appMemzero(this, sizeof(FAnalyticEntry));
		}
	}
};

var private native Map_Mirror AnalyticMap{ TMap<FString, double> };
var private native Map_Mirror TacticalAnalyticMap{ TMap<FString, double> };
var private native array<int> TacticalAnalyticUnits;

var private int CampaignDifficulty;

var bool SubmitToFiraxisLive;

var privatewrite bool HasChanged;

native function bool Validate(XComGameState HistoryGameState, INT GameStateIndex) const;
native function bool MetricPassesFilter( string Metric );

protected native function AddValueImpl(string Metric, float Value);
protected native function SetValueImpl(string Metric, float Value);

native function string GetValueAsString(string metric, string Default = "0") const;
native function double GetValue(string metric) const;
native function float GetFloatValue(string metric) const; // Unrealscript has trouble converting from double to float.  This works around the compiler issue.
native function DumpValues() const;

protected native function AddTacticalValueImpl( string Metric, float Value );
protected native function AddTacticalTrackedUnit( int NewID );
protected native function ClearTacticalValues( );

native function string GetTacticalValueAsString( string metric, string Default = "0" ) const;
native function double GetTacticalValue( string metric ) const;
native function float GetTacticalFloatValue( string metric ) const; // Unrealscript has trouble converting from double to float.  This works around the compiler issue.
native function DumpTacticalValues( ) const;

native final iterator function IterateGlobalAnalytics( out AnalyticEntry outEntry, optional bool IncludeUnits = true );
native final iterator function IterateTacticalAnalytics( out AnalyticEntry outEntry, optional bool IncludeUnits = true );

native function SingletonCopyForHistoryDiffDuplicate( XComGameState_BaseObject NewState );

event OnStateSubmitted( )
{
	HasChanged = false;
}

private function string BuildUnitMetric( int UnitID, string Metric )
{
	return "UNIT_"$UnitID$"_"$Metric;
}

static function string BuildEndGameMetric( string Metric )
{
	return "ENDGAME_"$Metric;
}

private function MaybeAddFirstColonel( XComGameState_Analytics NewAnalytics, XComGameState_Unit NewColonel )
{
	local TDateTime GameStartDate, CurrentDate;
	local float TimeDiffHours;
	local int TimeToDays;

	if (GetFloatValue( "FIRST_COLONEL_DAYS" ) == 0.0f)
	{
		class'X2StrategyGameRulesetDataStructures'.static.SetTime( GameStartDate, 0, 0, 0,
		class'X2StrategyGameRulesetDataStructures'.default.START_MONTH,
		class'X2StrategyGameRulesetDataStructures'.default.START_DAY,
		class'X2StrategyGameRulesetDataStructures'.default.START_YEAR );
		CurrentDate = `STRATEGYRULES.GameTime;

		TimeDiffHours = class'X2StrategyGameRulesetDataStructures'.static.DifferenceInHours( CurrentDate, GameStartDate );

		TimeToDays = Round( TimeDiffHours / 24.0f );

		NewAnalytics.SetValue( "FIRST_COLONEL_DAYS", TimeToDays );
	}
}

private function MaybeAddFirstChosenDefeat( XComGameState_Analytics NewAnalytics, XComGameState_Unit DefeatedUnit )
{
	local TDateTime GameStartDate, CurrentDate;
	local float TimeDiffHours;
	local int TimeToDays;
	local XComGameState_GameTime TimeState;

	if (GetFloatValue( "FIRST_CHOSEN_DEFEAT_DAYS" ) == 0.0f)
	{
		class'X2StrategyGameRulesetDataStructures'.static.SetTime( GameStartDate, 0, 0, 0,
			class'X2StrategyGameRulesetDataStructures'.default.START_MONTH,
			class'X2StrategyGameRulesetDataStructures'.default.START_DAY,
			class'X2StrategyGameRulesetDataStructures'.default.START_YEAR );


		foreach `XCOMHISTORY.IterateByClassType(class'XComGameState_GameTime', TimeState)
		{
			break;
		}
		CurrentDate = TimeState.CurrentTime;

		TimeDiffHours = class'X2StrategyGameRulesetDataStructures'.static.DifferenceInHours( CurrentDate, GameStartDate );

		TimeToDays = Round( TimeDiffHours / 24.0f );

		NewAnalytics.SetValue( "FIRST_CHOSEN_DEFEAT_DAYS", TimeToDays );
	}
}

function string GetUnitValueAsString( string Metric, StateObjectReference UnitRef )
{
	`assert( UnitRef.ObjectID > 0 );

	return GetValueAsString( BuildUnitMetric( UnitRef.ObjectID, Metric ) );
}

function double GetUnitValue( string Metric, StateObjectReference UnitRef )
{
	`assert( UnitRef.ObjectID > 0 );

	return GetValue( BuildUnitMetric( UnitRef.ObjectID, Metric ) );
}

function float GetUnitFloatValue( string Metric, StateObjectReference UnitRef )
{
	`assert( UnitRef.ObjectID > 0 );

	return GetFloatValue( BuildUnitMetric( UnitRef.ObjectID, Metric ) );
}

function AddValue(string Metric, float Value, optional StateObjectReference UnitRef)
{
	local string UnitMetric;

	AddValueImpl(Metric, Value);

	// soldier specific tracking
	if (UnitRef.ObjectID > 0)
	{
		UnitMetric = BuildUnitMetric( UnitRef.ObjectID, Metric );
		AddValueImpl(UnitMetric, Value);
	}

	// send to server stats
	if (SubmitToFiraxisLive && MetricPassesFilter(Metric))
	{
		`FXSLIVE.StatAddValue( name(Metric$"_"$CampaignDifficulty), Value, eKVPSCOPE_GLOBAL);
	}

	HasChanged = true;
}

function SetValue(string Metric, float Value)
{
	SetValueImpl(Metric, Value);

	// send to server stats
	if (SubmitToFiraxisLive && MetricPassesFilter(Metric))
	{
		`FXSLIVE.StatSetValue(name(Metric$"_"$CampaignDifficulty), Value, eKVPSCOPE_GLOBAL);
	}


	HasChanged = true;
}

function AddTacticalValue( string Metric, int Value, optional StateObjectReference UnitRef )
{
	local string UnitMetric;

	AddTacticalValueImpl( Metric, Value );
	AddValueImpl( Metric, Value );
	
	// soldier specific tracking
	if (UnitRef.ObjectID > 0)
	{
		UnitMetric = BuildUnitMetric( UnitRef.ObjectID, Metric );
		AddTacticalValueImpl( UnitMetric, Value );
		AddTacticalTrackedUnit( UnitRef.ObjectID );

		AddValueImpl( UnitMetric, Value );
	}

	// send to server stats
	if (SubmitToFiraxisLive && MetricPassesFilter(Metric))
	{
		`FXSLIVE.StatAddValue( name(Metric$"_"$CampaignDifficulty), Value, eKVPSCOPE_GLOBAL );
	}

	HasChanged = true;
}

function UnitAnalyticEntry GetLargestTacticalAnalyticForMetric( string Metric )
{
	local UnitAnalyticEntry Entry;
	local int UnitID;
	local float Value;

	Entry.ObjectID = 0;
	Entry.Value = 0.0f;

	foreach TacticalAnalyticUnits( UnitID )
	{
		Value = GetTacticalFloatValue( BuildUnitMetric(UnitID, Metric) );

		if (Value > Entry.Value)
		{
			Entry.ObjectID = UnitID;
			Entry.Value = Value;
		}
	}

	return Entry;
}

static function CreateAnalytics(XComGameState StartState, int SelectedDifficulty)
{
	local XComGameState_Analytics AnalyticsObject;

	// create the analytics object
	AnalyticsObject = XComGameState_Analytics(StartState.CreateNewStateObject(class'XComGameState_Analytics'));
	AnalyticsObject.CampaignDifficulty = SelectedDifficulty;
}

function SubmitGameState(XComGameState NewGameState, XComGameState_Analytics UpdatedAnalytics)
{
	if (UpdatedAnalytics.HasChanged && `XANALYTICS.ShouldSubmitGameState())
	{
		`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);
	}
	else
	{
		`XCOMHISTORY.CleanupPendingGameState(NewGameState);
	}
}

event bool SingletonTypeCanCleanupPending( )
{
	return !HasChanged;
}

function AddTacticalGameStart()
{
	local XComGameState NewGameState;
	local XComGameState_Analytics AnalyticsObject;
	local float TurnCount, UnitKills, TotalShots, TotalHits, TotalDamage, TotalAttacks, CoverCount, CoverTotal;
	local float ShotPercent, AvgDamage, AvgKills, AvgCover, MissionLost;
	local float RecordShotPercent, RecordAvgDamage, RecordAvgKills, RecordAvgCover;
	local XGBattle_SP Battle;
	local array<XComGameState_Unit> MissionUnits;
	local XComGameState_Unit Unit;

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState( "Analytics Mission Start" );

	AnalyticsObject = XComGameState_Analytics( NewGameState.ModifyStateObject( class'XComGameState_Analytics', self.ObjectID ) );
	MissionLost = GetTacticalFloatValue( "BATTLES_LOST" );

	if ((TacticalAnalyticUnits.Length > 0) && (MissionLost == 0.0f))
	{
		TotalShots = GetTacticalFloatValue( "ACC_UNIT_SHOTS_TAKEN" );
		TotalHits = GetTacticalFloatValue( "ACC_UNIT_SUCCESS_SHOTS" );
		if (TotalShots > 0)
			ShotPercent = TotalHits / TotalShots;

		TotalDamage = GetTacticalFloatValue( "ACC_UNIT_DEALT_DAMAGE" );
		TotalAttacks = GetTacticalFloatValue( "ACC_UNIT_SUCCESSFUL_ATTACKS" );
		if (TotalAttacks > 0)
			AvgDamage = TotalDamage / TotalAttacks;

		TurnCount = GetTacticalFloatValue( "TURN_COUNT" );
		UnitKills = GetTacticalFloatValue( "ACC_UNIT_KILLS" );
		if (TurnCount > 0)
			AvgKills = UnitKills / TurnCount;

		CoverCount = GetTacticalFloatValue( "ACC_UNIT_COVER_COUNT" );
		CoverTotal = GetTacticalFloatValue( "ACC_UNIT_COVER_TOTAL" );
		if (CoverCount > 0)
			AvgCover = CoverTotal / CoverCount;

		RecordShotPercent = GetFloatValue( "RECORD_SHOTS" );
		RecordAvgDamage = GetFloatValue( "RECORD_AVERAGE_DAMAGE" );
		RecordAvgKills = GetFloatValue( "RECORD_AVERAGE_KILLS" );
		RecordAvgCover = GetFloatValue( "RECORD_AVERAGE_COVER" );

		if (ShotPercent > RecordShotPercent)
			AnalyticsObject.SetValue( "RECORD_SHOTS", ShotPercent );
		if (AvgDamage > RecordAvgDamage)
			AnalyticsObject.SetValue( "RECORD_AVERAGE_DAMAGE", AvgDamage );
		if (AvgKills > RecordAvgKills)
			AnalyticsObject.SetValue( "RECORD_AVERAGE_KILLS", AvgKills );
		if (AvgCover > RecordAvgCover)
			AnalyticsObject.SetValue( "RECORD_AVERAGE_COVER", AvgCover );
	}
	AnalyticsObject.ClearTacticalValues( );

	Battle = XGBattle_SP( `BATTLE);
	Battle.GetHumanPlayer( ).GetOriginalUnits( MissionUnits, true );

	foreach MissionUnits( Unit )
	{
		if (GetUnitFloatValue( "SAW_ACTION", Unit.GetReference() ) == 0.0f)
		{
			AnalyticsObject.AddValue( "SAW_ACTION", 1, Unit.GetReference() );
		}
	}

	SubmitGameState( NewGameState, AnalyticsObject );
}

function AddTacticalGameEnd()
{
	local XComGameState_BattleData BattleData;
	local XComGameState NewGameState;
	local XComGameState_Analytics AnalyticsObject;
	local XComGameState_UITimer TimerState;
	local bool bMissionSuccess, bFlawless;
	local XComGameState_Unit Unit;
	local array<XComGameState_Unit> MissionUnits;
	local XGBattle_SP Battle;
	local StateObjectReference UnitRef;

	Battle = XGBattle_SP( `BATTLE);
	BattleData = XComGameState_BattleData(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_BattleData'));
	bMissionSuccess = BattleData.bLocalPlayerWon && !BattleData.bMissionAborted;

	`ANALYTICSLOG("STAT_END_MISSION:"@bMissionSuccess);

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Analytics Alive Soldiers");

	AnalyticsObject = XComGameState_Analytics(NewGameState.ModifyStateObject(class'XComGameState_Analytics', self.ObjectID));

	if (bMissionSuccess)
	{
		AnalyticsObject.AddValue("BATTLES_WON", 1);

		if (BattleData.MapData.ActiveMission.sType == "Sabotage")
		{
			AnalyticsObject.AddValue( "NUM_SABOTAGED_FACILITIES", 1 );
		}
		else if (BattleData.MapData.ActiveMission.sType == "CompoundRescueOperative")
		{
			AnalyticsObject.AddValue( "NUM_RESCUED_SOLDIERS", 1 );
		}
	}
	else
	{
		AnalyticsObject.AddTacticalValue( "BATTLES_LOST", 1 );
	}

	Battle.GetHumanPlayer( ).GetOriginalUnits( MissionUnits, true );

	bFlawless = true;
	foreach MissionUnits( Unit )
	{
		UnitRef.ObjectID = Unit.ObjectID;

		if (Unit.kAppearance.bGhostPawn)
			continue;

		AnalyticsObject.AddValue( "ACC_UNIT_MISSIONS", 1, UnitRef );

		if (Unit.IsDead( ))
		{
			bFlawless = false;
			AnalyticsObject.AddValue( "UNITS_LOST", 1 );
		}
		else if (Unit.IsBleedingOut() && !BattleData.AllTacticalObjectivesCompleted())
		{
			bFlawless = false;
			AnalyticsObject.AddValue( "UNITS_LOST", 1 );
		}

		if (Unit.WasInjuredOnMission( ))
		{
			bFlawless = false;
		}
	}

	if (bFlawless)
	{
		AnalyticsObject.AddValue( "FLAWLESS_MISSIONS", 1 );
	}

	TimerState = XComGameState_UITimer(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_UITimer', true));
	if ((TimerState != none) && TimerState.IsTimer)
	{
		while ((TimerState != none) && !TimerState.ShouldShow)
		{
			TimerState = XComGameState_UITimer(`XCOMHISTORY.GetPreviousGameStateForObject(TimerState));
		}

		if (TimerState != none)
		{
			AnalyticsObject.AddValue( "NUM_TIMED_MISSIONS", 1 );
			AnalyticsObject.AddValue( "REMAINING_TIMED_MISSION_TURNS", TimerState.TimerValue );
		}
	}

	SubmitGameState(NewGameState, AnalyticsObject);
}

function AddPlayerTurnEnd( )
{
	local XComGameState NewGameState;
	local XComGameState_Analytics AnalyticsObject;
	local XComGameState_Unit Unit;
	local StateObjectReference UnitRef;
	local XComGameStateHistory History;

	History = `XCOMHISTORY;

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState( "Analytics Player Turn End" );

	AnalyticsObject = XComGameState_Analytics( NewGameState.ModifyStateObject( class'XComGameState_Analytics', self.ObjectID ) );

	AnalyticsObject.AddTacticalValue( "TURN_COUNT", 1 );

	foreach History.IterateByClassType( class'XComGameState_Unit', Unit )
	{
		if ((Unit.GetTeam() == eTeam_XCom) && (!Unit.IsDead()) && Unit.GetMyTemplate().bCanTakeCover)
		{
			UnitRef.ObjectID = Unit.ObjectID;
			AnalyticsObject.AddTacticalValue( "ACC_UNIT_COVER_COUNT", 1, UnitRef );
			AnalyticsObject.AddTacticalValue( "ACC_UNIT_COVER_TOTAL", Unit.GetCoverTypeFromLocation( ), UnitRef );
		}
	}

	SubmitGameState( NewGameState, AnalyticsObject );
}

function AddSoldierTacticalToStrategy(XComGameState_Unit SourceUnit, XComGameState NewGameState)
{
	local XComGameState_Analytics AnalyticsObject;

	if (SourceUnit != none && SourceUnit.IsSoldier())
	{
		AnalyticsObject = XComGameState_Analytics(NewGameState.ModifyStateObject(class'XComGameState_Analytics', self.ObjectID));

		if (SourceUnit.IsDead())
		{
			if (!SourceUnit.bBodyRecovered)
			{
				AnalyticsObject.AddValue("SOLDIERS_LEFT_BEHIND", 1);
			}
			else
			{
				AnalyticsObject.AddValue("NUMBER_OF_SOLDIERS_CARRIED_TO_EXTRACTION", 1);
			}
		}
	}
}


function AddWeaponKill(XComGameState_Unit SourceUnit, XComGameState_Ability Ability)
{
	local XComGameState NewGameState;
	local XComGameState_Analytics AnalyticsObject;

	// we only care about player solders
	if (SourceUnit != none && SourceUnit.IsPlayerControlled() && SourceUnit.IsSoldier())
	{
		NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Analytics Weapon Kill");

		AnalyticsObject = XComGameState_Analytics(NewGameState.ModifyStateObject(class'XComGameState_Analytics', self.ObjectID));
		AnalyticsObject.HandleWeaponKill(SourceUnit, Ability);

		SubmitGameState(NewGameState, AnalyticsObject);
	}
}


function AddBreakDoor(XComGameState_Unit SourceUnit, XComGameStateContext_Ability AbilityContext)
{
	local XComGameState NewGameState;
	local XComGameState_Analytics AnalyticsObject;

	// we only care about players kicking down doors taking names
	if (SourceUnit != none && SourceUnit.IsPlayerControlled())
	{
		NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Analytics Break Door");

		AnalyticsObject = XComGameState_Analytics(NewGameState.ModifyStateObject(class'XComGameState_Analytics', self.ObjectID));
		AnalyticsObject.AddValue("DOORS_KICKED", 1);

		SubmitGameState(NewGameState, AnalyticsObject);
	}
}


function AddBreakWindow(XComGameState_Unit SourceUnit, XComGameStateContext_Ability AbilityContext)
{
	local XComGameState NewGameState;
	local XComGameState_Analytics AnalyticsObject;

	// we only care about players breaking windows
	if (SourceUnit != none && SourceUnit.IsPlayerControlled())
	{
		NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Analytics Break Window");

		AnalyticsObject = XComGameState_Analytics(NewGameState.ModifyStateObject(class'XComGameState_Analytics', self.ObjectID));
		AnalyticsObject.AddValue("WINDOWS_JUMPED_THROUGH", 1);

		SubmitGameState(NewGameState, AnalyticsObject);
	}
}

function AddUnitMoved( XComGameState_Unit MovedUnit, XComGameState MovementGameState )
{
	local XComGameState NewGameState;
	local XComGameState_Analytics AnalyticsObject;
	local PathingResultData PathingData;
	local int TravelDistanceSq;
	local int x, dx, dy;
	local GameplayTileData Curr, Prev;
	local StateObjectReference UnitRef;
	local XComGameStateContext_Ability AbilityContext;

	if ((MovedUnit.GetTeam() != eTeam_XCom) || MovedUnit.GetMyTemplate().bIsCosmetic)
	{
		return;
	}

	AbilityContext = XComGameStateContext_Ability( MovementGameState.GetContext() );
	if ((AbilityContext == none))
	{
		return;
	}

	UnitRef.ObjectID = MovedUnit.ObjectID;

	x = AbilityContext.GetMovePathIndex( MovedUnit.ObjectID );
	if ((x < 0) || (AbilityContext.ResultContext.PathResults[x].PathTileData.Length < 2))
	{
		return;
	}

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState( "Analytics Unit Moved" );

	AnalyticsObject = XComGameState_Analytics( NewGameState.ModifyStateObject( class'XComGameState_Analytics', self.ObjectID ) );

	TravelDistanceSq = 0;
	PathingData = AbilityContext.ResultContext.PathResults[x];
	for (x = 1; x < PathingData.PathTileData.Length; ++x)
	{
		Prev = PathingData.PathTileData[x - 1];
		Curr = PathingData.PathTileData[x];

		dx = Prev.EventTile.X - Curr.EventTile.X;
		dy = Prev.EventTile.Y - Curr.EventTile.Y;
		TravelDistanceSq += dx*dx + dy*dy;
	}
	
	AnalyticsObject.AddTacticalValue( "ACC_UNIT_MOVEMENT", TravelDistanceSq, UnitRef );

	SubmitGameState( NewGameState, AnalyticsObject );
}

function AddKillMail(XComGameState_Unit SourceUnit, XComGameState_Unit KilledUnit)
{
	local XComGameState NewGameState;
	local XComGameState_Analytics AnalyticsObject;

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Analytics Killed Enemy");
	AnalyticsObject = XComGameState_Analytics(NewGameState.ModifyStateObject(class'XComGameState_Analytics', self.ObjectID));
	AnalyticsObject.HandleKillMail(SourceUnit, KilledUnit, NewGameState);

	SubmitGameState(NewGameState, AnalyticsObject);
}

function AddMissionObjectiveComplete()
{
	//local XComGameState NewGameState;
	//local XComGameState_Analytics AnalyticsObject;

	//NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Analytics Completed Objective");
	//AnalyticsObject = XComGameState_Analytics(NewGameState.ModifyStateObject(class'XComGameState_Analytics', self.ObjectID));

	//SubmitGameState(NewGameState, AnalyticsObject);
}

function AddCivilianRescued(XComGameState_Unit SourceUnit, XComGameState_Unit RescuedUnit)
{
	local XComGameState NewGameState;
	local XComGameState_Analytics AnalyticsObject;

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Analytics Civilians Saved");
	AnalyticsObject = XComGameState_Analytics(NewGameState.ModifyStateObject(class'XComGameState_Analytics', self.ObjectID));
	AnalyticsObject.AddValue( "CIVILIANS_RESCUED", 1 );

	SubmitGameState(NewGameState, AnalyticsObject);
}

function AddUnitDamage( XComGameState_Unit Target, XComGameState_Unit Source, XComGameStateContext Context )
{
	local DamageResult DmgResult;
	local int DamageAmount;
	local XComGameState NewGameState;
	local XComGameState_Analytics AnalyticsObject;
	local StateObjectReference UnitRef;

	if ((Target.GetTeam() != eTeam_XCom) && (Source != none) && (Source.GetTeam() != eTeam_XCom))
	{
		return; // no xcom units involved.  no tactical stats required
	}

	DamageAmount = 0;
	foreach Target.DamageResults( DmgResult )
	{
		if (DmgResult.Context == Context)
		{
			DamageAmount = DmgResult.DamageAmount;
			break;
		}
	}

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState( "Analytics Unit Damage" );
	AnalyticsObject = XComGameState_Analytics( NewGameState.ModifyStateObject( class'XComGameState_Analytics', self.ObjectID ) );

	if (Target.GetTeam() == eTeam_XCom)
	{
		UnitRef.ObjectID = Target.ObjectID;
		AnalyticsObject.AddTacticalValue( "ACC_UNIT_TAKEN_DAMAGE", DamageAmount, UnitRef );
	}

	if ((Source != none) && (Source.GetTeam() == eTeam_XCom))
	{
		UnitRef.ObjectID = Source.ObjectID;
		AnalyticsObject.AddTacticalValue( "ACC_UNIT_DEALT_DAMAGE", DamageAmount, UnitRef );
	}

	SubmitGameState( NewGameState, AnalyticsObject );
}

function AddUnitTakenShot( XComGameState_Unit Shooter, XComGameState_Unit Target, XComGameState_Item Tool, 
							XComGameStateContext_Ability AbilityContext, XComGameState_Ability Ability )
{
	local XComGameState NewGameState;
	local XComGameState_Analytics AnalyticsObject;
	local StateObjectReference UnitRef;
	local X2AbilityTemplate AbilityTemplate;
	local XComGameState_InteractiveObject HackTarget;
	local bool ShooterIsXCom, TargetIsXCom;

	ShooterIsXCom = Shooter.GetTeam() == eTeam_XCom;
	TargetIsXCom = (Target != none) && (Target.GetTeam() == eTeam_XCom);

	if (!ShooterIsXCom && !TargetIsXCom)
	{
		return; // no xcom units involved.  no tactical stats required
	}

	AbilityTemplate = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager( ).FindAbilityTemplate( AbilityContext.InputContext.AbilityTemplateName );

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState( "Analytics Unit Taken Shot" );
	AnalyticsObject = XComGameState_Analytics( NewGameState.ModifyStateObject( class'XComGameState_Analytics', self.ObjectID ) );

	if (Shooter.GetTeam() == eTeam_XCom)
	{
		if (AbilityTemplate.TargetEffectsDealDamage(Tool, Ability))
		{
			if ((AbilityTemplate.DataName == 'StandardShot') || (AbilityTemplate.DataName == 'PistolStandardShot') || (AbilityTemplate.DataName == 'SniperStandardFire'))
			{
				UnitRef.ObjectID = Shooter.ObjectID;
				AnalyticsObject.AddTacticalValue( "ACC_UNIT_SHOTS_TAKEN", 1, UnitRef );

				if (!AbilityContext.IsResultContextMiss( ))
				{
					AnalyticsObject.AddTacticalValue( "ACC_UNIT_SUCCESS_SHOTS", 1, UnitRef );
				}
			}

			if (!AbilityContext.IsResultContextMiss( ))
			{
				AnalyticsObject.AddTacticalValue( "ACC_UNIT_SUCCESSFUL_ATTACKS", 1, UnitRef );
			}

			AnalyticsObject.AddTacticalValue( "ACC_UNIT_ATTACKS", 1, UnitRef );
		}

		if ( Tool != none && ((X2GrenadeTemplate( Tool.GetMyTemplate() ) != none) || (X2GrenadeTemplate( Tool.GetLoadedAmmoTemplate( Ability ) ) != none)))
		{
			AnalyticsObject.AddTacticalValue( "GRENADES_USED", 1, UnitRef );

			AnalyticsObject.AddTacticalValue( "ACC_UNIT_SUCCESSFUL_ATTACKS", 1, UnitRef );
			AnalyticsObject.AddTacticalValue( "ACC_UNIT_ATTACKS", 1, UnitRef );
		}

		if ((AbilityTemplate.DataName == 'FinalizeHaywire') && Target.bHasBeenHacked)
		{
			AnalyticsObject.AddTacticalValue( "SUCCESSFUL_HAYWIRES", 1, UnitRef );

			if (Target.UserSelectedHackReward > 0)
			{
				AnalyticsObject.AddValue( "HACK_REWARDS", 1 );
			}
		}
		else if ((AbilityTemplate.DataName == 'FinalizeSKULLJACK') || (AbilityTemplate.DataName == 'FinalizeSKULLMINE'))
		{
			if (Target.UserSelectedHackReward > 0)
			{
				AnalyticsObject.AddValue( "HACK_REWARDS", 1 );
			}
		}
		else if ((AbilityTemplate.DataName == 'FinalizeIntrusion') || (AbilityTemplate.DataName == 'FinalizeHack'))
		{
			HackTarget = XComGameState_InteractiveObject( `XCOMHISTORY.GetGameStateForObjectID( AbilityContext.InputContext.PrimaryTarget.ObjectID ) );
			if (HackTarget.bHasBeenHacked && HackTarget.UserSelectedHackReward > 0)
			{
				AnalyticsObject.AddValue( "HACK_REWARDS", 1 );
			}
		}
	}

	if ((Target != none) && (Target.GetTeam() == eTeam_XCom) && (Shooter.GetTeam() != eTeam_XCom))
	{
		UnitRef.ObjectID = Target.ObjectID;
		AnalyticsObject.AddTacticalValue( "ACC_UNIT_ABILITIES_RECIEVED", 1, UnitRef );
	}

	SubmitGameState( NewGameState, AnalyticsObject );
}

function AddUnitHealCompleted( XComGameState_Unit HealedUnit, int HoursHealed )
{
	local XComGameState NewGameState;
	local XComGameState_Analytics AnalyticsObject;
	local StateObjectReference UnitRef;

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState( "Analytics Unit Healed" );
	AnalyticsObject = XComGameState_Analytics( NewGameState.ModifyStateObject( class'XComGameState_Analytics', self.ObjectID ) );

	UnitRef.ObjectID = HealedUnit.ObjectID;
	AnalyticsObject.AddValue( "ACC_UNIT_HEALING", HoursHealed, UnitRef );

	SubmitGameState( NewGameState, AnalyticsObject );
}

function AddCrewAddition( XComGameState_Unit NewCrew )
{
	local XComGameState NewGameState;
	local XComGameState_Analytics AnalyticsObject;
	local X2SoldierClassTemplate SoldierClass;

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState( "Analytics Crew Added" );
	AnalyticsObject = XComGameState_Analytics( NewGameState.ModifyStateObject( class'XComGameState_Analytics', self.ObjectID ) );

	if (NewCrew.IsScientist())
	{
		AnalyticsObject.AddValue( "NUM_SCIENTISTS", 1 );
	}
	else if (NewCrew.IsEngineer())
	{
		AnalyticsObject.AddValue( "NUM_ENGINEERS", 1 );
	}
	else if (NewCrew.IsSoldier() && (NewCrew.GetNumMissions() == 0))
	{
		if (NewCrew.GetRank() == 7)
		{
			if (NewCrew.IsPsiOperative())
			{
				AnalyticsObject.AddValue( "NUM_MAGUSES", 1 );
			}
			else
			{
				AnalyticsObject.AddValue( "NUM_COLONELS", 1 );

				MaybeAddFirstColonel( AnalyticsObject, NewCrew );
			}
		}

		SoldierClass = NewCrew.GetSoldierClassTemplate();
		switch (SoldierClass.DataName)
		{
			case 'Skirmisher':
				AnalyticsObject.AddValue( "NUM_SKIRMISHERS", 1 );
				break;

			case 'Reaper':
				AnalyticsObject.AddValue( "NUM_REAPERS", 1 );
				break;

			case 'Templar':
				AnalyticsObject.AddValue( "NUM_TEMPLARS", 1 );
				break;
		}
	}

	SubmitGameState( NewGameState, AnalyticsObject );
}

function AddResearchCompletion( XComGameState_Tech CompletedTech, XComGameState_HeadquartersProjectResearch ResearchProject )
{
	local TDateTime GameStartDate, CurrentDate;
	local string TechAnalytic;
	local float TimeDiffHours;
	local int TimeToDays;
	local XComGameState NewGameState;
	local XComGameState_Analytics AnalyticsObject;

	switch (CompletedTech.GetMyTemplateName())
	{
		case 'MagnetizedWeapons': TechAnalytic = "MAGNETIC_WEAPONS";
			break;

		case 'PlasmaRifle': TechAnalytic = "BEAM_WEAPONS";
			break;

		case 'PlatedArmor': TechAnalytic = "PLATED_ARMOR";
			break;

		case 'PoweredArmor': TechAnalytic = "POWERED_ARMOR";
			break;

		case 'AlienEncryption': TechAnalytic = "ALIEN_ENCRYPTION";
			break;

		default:
			break;
	}

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState( "Analytics Research Completed" );
	AnalyticsObject = XComGameState_Analytics( NewGameState.ModifyStateObject( class'XComGameState_Analytics', self.ObjectID ) );

	CurrentDate = `STRATEGYRULES.GameTime;

	if (TechAnalytic != "")
	{
		class'X2StrategyGameRulesetDataStructures'.static.SetTime( GameStartDate, 0, 0, 0,
																	class'X2StrategyGameRulesetDataStructures'.default.START_MONTH,
																	class'X2StrategyGameRulesetDataStructures'.default.START_DAY,
																	class'X2StrategyGameRulesetDataStructures'.default.START_YEAR );

		TimeDiffHours = class'X2StrategyGameRulesetDataStructures'.static.DifferenceInHours( CurrentDate, GameStartDate );

		TimeToDays = Round( TimeDiffHours / 24.0f );

		AnalyticsObject.SetValue( TechAnalytic, TimeToDays );
	}

	if (CompletedTech.GetMyTemplate().bBreakthrough)
	{
		AnalyticsObject.AddValue( "NUM_TECH_BREAKTHROUGHS", 1 );
	}

	if (ResearchProject != none)
	{
		TimeDiffHours = class'X2StrategyGameRulesetDataStructures'.static.DifferenceInHours( CurrentDate, ResearchProject.StartDateTime );
		TimeDiffHours += ResearchProject.ProjectTimeBeforePausesHours;
		AnalyticsObject.AddValue( "TOTAL_RESEARCH_HOURS", TimeDiffHours );
	}

	SubmitGameState( NewGameState, AnalyticsObject );
}

function AddResistanceActivity( X2ResistanceActivityTemplate ActivityTemplate, int Delta )
{
	local XComGameState NewGameState;
	local XComGameState_Analytics AnalyticsObject;
	local string Analytic;

	if (Delta < 0)
	{
		return; // don't care about backwards progress for the analytics tracking
	}

	switch( ActivityTemplate.DataName )
	{
		case 'ResAct_OutpostsBuilt': Analytic = "BUILT_OUTPOST";
			break;

		case 'ResAct_AvatarProgress':  Analytic = "AVATAR_PROGRESS";
			break;

		default: // Don't care about this activity
			return;
	}

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState( "Analytics Resistance Activity" );
	AnalyticsObject = XComGameState_Analytics( NewGameState.ModifyStateObject( class'XComGameState_Analytics', self.ObjectID ) );

	AnalyticsObject.AddValue( Analytic, Delta );

	SubmitGameState( NewGameState, AnalyticsObject );
}

function AddResource( XComGameState_Item Resource, int Quantity )
{
	local XComGameState NewGameState;
	local XComGameState_Analytics AnalyticsObject;
	local string Analytic;

	switch (Resource.GetMyTemplateName())
	{
		case 'Intel': Analytic = ((Quantity > 0) ? "INTEL_GATHERED" : "");
			break;

		case 'AbilityPoint':
			if (Quantity > 0)
			{
				Analytic = "ABILITY_POINTS_GAINED";
			}
			else
			{
				Analytic = "ABILITY_POINTS_SPENT";
				Quantity *= -1; // we want to track this in positive numbers
			}
			break;

		default:
			break;
	}

	if (Analytic == "")
	{
		return; // Analytic case that we apparently don't care about
	}

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState( "Analytics Resource Changed" );
	AnalyticsObject = XComGameState_Analytics( NewGameState.ModifyStateObject( class'XComGameState_Analytics', self.ObjectID ) );

	AnalyticsObject.AddValue( Analytic, Quantity );

	SubmitGameState( NewGameState, AnalyticsObject );
}

function AddAbilityPointChange( XComGameState_Unit UnitState )
{
	local XComGameState NewGameState;
	local XComGameState_Analytics AnalyticsObject;
	local XComGameState_Unit PrevState;

	PrevState = XComGameState_Unit( UnitState.GetPreviousVersion( ) );

	if (PrevState.AbilityPoints == UnitState.AbilityPoints)
		return;

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState( "Analytics Ability Points Change" );
	AnalyticsObject = XComGameState_Analytics( NewGameState.ModifyStateObject( class'XComGameState_Analytics', self.ObjectID ) );

	if (PrevState.AbilityPoints > UnitState.AbilityPoints)
	{
		AnalyticsObject.AddValue( "ABILITY_POINTS_SPENT", PrevState.AbilityPoints - UnitState.AbilityPoints );
	}
	else
	{
		AnalyticsObject.AddValue( "ABILITY_POINTS_GAINED", UnitState.AbilityPoints - PrevState.AbilityPoints );
	}

	SubmitGameState( NewGameState, AnalyticsObject );
}

function AddUnitTraitsChange( XComGameState_Unit UnitState )
{
	local XComGameState NewGameState;
	local XComGameState_Analytics AnalyticsObject;
	local XComGameState_Unit PrevState;
	local array<name> CurrPending, CurrAcquired;
	local array<name> PrevPending, PrevAcquired;
	local int Index, FindIndex;
	local bool Remove;

	PrevState = XComGameState_Unit( UnitState.GetPreviousVersion( ) );

	CurrAcquired = UnitState.AcquiredTraits;
	CurrPending = UnitState.PendingTraits;

	PrevAcquired = PrevState.AcquiredTraits;
	PrevPending = PrevState.PendingTraits;

	for (Index = 0; Index < CurrPending.Length; ++Index)
	{
		FindIndex = PrevPending.Find( CurrPending[ Index ] );
		if (FindIndex != INDEX_NONE)
		{
			PrevPending.Remove( FindIndex, 1 );
			CurrPending.Remove( Index, 1 );
			--Index;
		}
	}

	for (Index = 0; Index < CurrAcquired.Length; ++Index)
	{
		Remove = false;

		FindIndex = PrevAcquired.Find( CurrAcquired[ Index ] );
		if (FindIndex != INDEX_NONE)
		{
			PrevAcquired.Remove( FindIndex, 1 );
			Remove = true;
		}

		FindIndex = PrevPending.Find( CurrAcquired[ Index ] );
		if (FindIndex != INDEX_NONE)
		{
			PrevPending.Remove( FindIndex, 1 );
			Remove = true;
		}

		if (Remove)
		{
			CurrAcquired.Remove( Index, 1 );
			--Index;
		}
	}


	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState( "Analytics Unit Traits" );
	AnalyticsObject = XComGameState_Analytics( NewGameState.ModifyStateObject( class'XComGameState_Analytics', self.ObjectID ) );

	if ((CurrAcquired.Length > 0) || (CurrPending.Length > 0))
		AnalyticsObject.AddValue( "TRAITS_ACQUIRED", CurrAcquired.Length + CurrPending.Length );

	if ((PrevAcquired.Length > 0) || (PrevPending.Length > 0))
		AnalyticsObject.AddValue( "TRAITS_REMOVED", PrevAcquired.Length + PrevPending.Length );

	SubmitGameState( NewGameState, AnalyticsObject );
}

function AddBlackMarketPurchase( XComGameState_BlackMarket BlackMarket, XComGameState_Reward RewardState )
{
	local XComGameState NewGameState;
	local XComGameState_Analytics AnalyticsObject;
	local int ItemIndex;
	local Commodity RewardCommodity;
	local StrategyCost ScaledCost;
	local ArtifactCost Cost;

	ItemIndex = BlackMarket.ForSaleItems.Find('RewardRef', RewardState.GetReference());
	RewardCommodity = BlackMarket.ForSaleItems[ItemIndex];
	ScaledCost = class'XComGameState_HeadquartersXCom'.static.GetScaledStrategyCost( RewardCommodity.Cost, RewardCommodity.CostScalars, RewardCommodity.DiscountPercent );

	foreach ScaledCost.ResourceCosts(Cost)
	{
		if (Cost.ItemTemplateName == 'Intel')
		{
			NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState( "Analytics Black Market Purchase" );
			AnalyticsObject = XComGameState_Analytics( NewGameState.ModifyStateObject( class'XComGameState_Analytics', self.ObjectID ) );

			AnalyticsObject.AddValue( "BLACKMARKET_INTEL", Cost.Quantity );

			SubmitGameState( NewGameState, AnalyticsObject );

			break;
		}
	}
}

function AddBlackMarketSupplies( int Supplies )
{
	local XComGameState NewGameState;
	local XComGameState_Analytics AnalyticsObject;

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState( "Analytics Black Market Supplies" );
	AnalyticsObject = XComGameState_Analytics( NewGameState.ModifyStateObject( class'XComGameState_Analytics', self.ObjectID ) );

	AnalyticsObject.AddValue( "BLACKMARKET_SUPPLIES", Supplies );

	SubmitGameState( NewGameState, AnalyticsObject );
}

function AddSupplyDropSupplies( int Supplies )
{
	local XComGameState NewGameState;
	local XComGameState_Analytics AnalyticsObject;

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState( "Analytics Supply Drop Supplies" );
	AnalyticsObject = XComGameState_Analytics( NewGameState.ModifyStateObject( class'XComGameState_Analytics', self.ObjectID ) );

	AnalyticsObject.AddValue( "SUPPLY_DROP_SUPPLIES", Supplies );

	SubmitGameState( NewGameState, AnalyticsObject );
}

function AddXComVictory( )
{
	local XComGameState NewGameState;
	local XComGameState_Analytics AnalyticsObject;
	local TDateTime GameStartDate, CurrentDate;
	local float TimeDiffHours;
	local int TimeToDays;

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState( "Analytics XCom Victory" );
	AnalyticsObject = XComGameState_Analytics( NewGameState.ModifyStateObject( class'XComGameState_Analytics', self.ObjectID ) );


	class'X2StrategyGameRulesetDataStructures'.static.SetTime( GameStartDate, 0, 0, 0,
																	class'X2StrategyGameRulesetDataStructures'.default.START_MONTH,
																	class'X2StrategyGameRulesetDataStructures'.default.START_DAY,
																	class'X2StrategyGameRulesetDataStructures'.default.START_YEAR );
	CurrentDate = `STRATEGYRULES.GameTime;

	TimeDiffHours = class'X2StrategyGameRulesetDataStructures'.static.DifferenceInHours( CurrentDate, GameStartDate );

	TimeToDays = Round( TimeDiffHours / 24.0f );

	AnalyticsObject.AddValue( "XCOM_VICTORY", TimeToDays );

	SubmitGameState( NewGameState, AnalyticsObject );
}

function AddUnitPromotion( XComGameState_Unit PromotedUnit, XComGameState_Unit PrevState )
{
	local XComGameState NewGameState;
	local XComGameState_Analytics AnalyticsObject;

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState( "Analytics Unit Promoted" );
	AnalyticsObject = XComGameState_Analytics( NewGameState.ModifyStateObject( class'XComGameState_Analytics', self.ObjectID ) );

	if (PromotedUnit.IsPsiOperative())
	{
		if (PromotedUnit.GetRank() == 1)
		{
			AnalyticsObject.AddValue( "NUM_PSIONICS", 1 );
		}
		else if ((PromotedUnit.GetRank() == 7) && (PrevState.GetRank() < 7))
		{
			AnalyticsObject.AddValue( "NUM_MAGUSES", 1 );
		}
	}
	else
	{
		AnalyticsObject.AddValue( "PROMOTIONS_EARNED", 1 );

		if (PromotedUnit.GetRank() == 7)
		{
			AnalyticsObject.AddValue( "NUM_COLONELS", 1 );

			MaybeAddFirstColonel( AnalyticsObject, PromotedUnit );
		}
	}

	SubmitGameState( NewGameState, AnalyticsObject );
}

function AddChosenDefeated( XComGameState_Unit KilledUnit )
{
	local XComGameState NewGameState;
	local XComGameState_Analytics AnalyticsObject;

	if (!KilledUnit.IsChosen()) // somehow not a chosen
		return;

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState( "Analytics Chosen Defeated" );
	AnalyticsObject = XComGameState_Analytics( NewGameState.ModifyStateObject( class'XComGameState_Analytics', self.ObjectID ) );

	switch (KilledUnit.GetMyTemplateName())
	{
		case 'ChosenAssassin':
		case 'ChosenAssassinM2':
		case 'ChosenAssassinM3':
		case 'ChosenAssassinM4': AnalyticsObject.AddValue( "CHOSEN_ASSASSIN_DEFEATED", 1 );
			break;

		case 'ChosenWarlock':
		case 'ChosenWarlockM2':
		case 'ChosenWarlockM3':
		case 'ChosenWarlockM4': AnalyticsObject.AddValue( "CHOSEN_WARLOCK_DEFEATED", 1 );
			break;

		case 'ChosenSniper':
		case 'ChosenSniperM2':
		case 'ChosenSniperM3':
		case 'ChosenSniperM4': AnalyticsObject.AddValue( "CHOSEN_HUNTER_DEFEATED", 1 );
			break;
	}

	MaybeAddFirstChosenDefeat( AnalyticsObject, KilledUnit );

	SubmitGameState( NewGameState, AnalyticsObject );
}

function AddChosenInterrogation( XComGameState_Unit Chosen, XComGameState_Unit InterrogatedUnit, XComGameState_Ability AbilityState, XComGameStateContext_Ability AbilityContext )
{
	local XComGameState NewGameState;
	local XComGameState_Analytics AnalyticsObject;

	if (!Chosen.IsChosen()) // somehow not a chosen
		return;

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState( "Analytics Chosen Interrogation" );
	AnalyticsObject = XComGameState_Analytics( NewGameState.ModifyStateObject( class'XComGameState_Analytics', self.ObjectID ) );

	switch (Chosen.GetMyTemplateName())
	{
		case 'ChosenAssassin':
		case 'ChosenAssassinM2':
		case 'ChosenAssassinM3':
		case 'ChosenAssassinM4': AnalyticsObject.AddValue( "CHOSEN_ASSASSIN_INTERROGATION", 1 );
			break;

		case 'ChosenWarlock':
		case 'ChosenWarlockM2':
		case 'ChosenWarlockM3':
		case 'ChosenWarlockM4': AnalyticsObject.AddValue( "CHOSEN_WARLOCK_INTERROGATION", 1 );
			break;

		case 'ChosenSniper':
		case 'ChosenSniperM2':
		case 'ChosenSniperM3':
		case 'ChosenSniperM4': AnalyticsObject.AddValue( "CHOSEN_HUNTER_INTERROGATION", 1 );
			break;
	}

	SubmitGameState( NewGameState, AnalyticsObject );
}

function AddChosenKidnapping( XComGameState_Unit Chosen, XComGameState_Unit KidnappedUnit, XComGameState_Ability AbilityState, XComGameStateContext_Ability AbilityContext )
{
	local XComGameState NewGameState;
	local XComGameState_Analytics AnalyticsObject;

	if (!Chosen.IsChosen()) // somehow not a chosen
		return;

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState( "Analytics Chosen Kidnapping" );
	AnalyticsObject = XComGameState_Analytics( NewGameState.ModifyStateObject( class'XComGameState_Analytics', self.ObjectID ) );

	switch (Chosen.GetMyTemplateName())
	{
		case 'ChosenAssassin':
		case 'ChosenAssassinM2':
		case 'ChosenAssassinM3':
		case 'ChosenAssassinM4': AnalyticsObject.AddValue( "CHOSEN_ASSASSIN_KIDNAP", 1 );
			break;

		case 'ChosenWarlock':
		case 'ChosenWarlockM2':
		case 'ChosenWarlockM3':
		case 'ChosenWarlockM4': AnalyticsObject.AddValue( "CHOSEN_WARLOCK_KIDNAP", 1 );
			break;

		case 'ChosenSniper':
		case 'ChosenSniperM2':
		case 'ChosenSniperM3':
		case 'ChosenSniperM4': AnalyticsObject.AddValue( "CHOSEN_HUNTER_KIDNAP", 1 );
			break;
	}

	SubmitGameState( NewGameState, AnalyticsObject );
}

function AddChosenCapture( XComGameState_AdventChosen Chosen, XComGameState_Unit KidnappedUnit, XComGameState_Ability AbilityState, XComGameStateContext_Ability AbilityContext )
{
	local XComGameState NewGameState;
	local XComGameState_Analytics AnalyticsObject;

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState( "Analytics Chosen Kidnapping" );
	AnalyticsObject = XComGameState_Analytics( NewGameState.ModifyStateObject( class'XComGameState_Analytics', self.ObjectID ) );

	switch (Chosen.GetMyTemplateName())
	{
		case 'Chosen_Assassin': AnalyticsObject.AddValue( "CHOSEN_ASSASSIN_CAPTURE", 1 );
			break;

		case 'Chosen_Warlock': AnalyticsObject.AddValue( "CHOSEN_WARLOCK_CAPTURE", 1 );
			break;

		case 'Chosen_Hunter': AnalyticsObject.AddValue( "CHOSEN_HUNTER_CAPTURE", 1 );
			break;
	}

	SubmitGameState( NewGameState, AnalyticsObject );
}

function AddPCSApplied( XComGameState_Unit UpdatedUnit, XComGameState_Item UpdatedImplant )
{
	local XComGameState NewGameState;
	local XComGameState_Analytics AnalyticsObject;
	local StateObjectReference UnitRef;

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState( "Analytics PCS Installed" );
	AnalyticsObject = XComGameState_Analytics( NewGameState.ModifyStateObject( class'XComGameState_Analytics', self.ObjectID ) );

	UnitRef = UpdatedUnit.GetReference();

	AnalyticsObject.AddValue( "TOTAL_SIMS_INSTALLED", 1, UnitRef );

	switch (UpdatedImplant.GetMyTemplateName())
	{
		case 'CommonPCSSpeed':
		case 'RarePCSSpeed':
		case 'EpicPCSSpeed': AnalyticsObject.AddValue( "TOTAL_SPEED_SIMS_INSTALLED", 1, UnitRef );
			break;

		case 'CommonPCSConditioning':
		case 'RarePCSConditioning':
		case 'EpicPCSConditioning': AnalyticsObject.AddValue( "TOTAL_CONDITIONING_SIMS_INSTALLED", 1, UnitRef );
			break;

		case 'CommonPCSFocus':
		case 'RarePCSFocus':
		case 'EpicPCSFocus': AnalyticsObject.AddValue( "TOTAL_FOCUS_SIMS_INSTALLED", 1, UnitRef );
			break;

		case 'CommonPCSPerception':
		case 'RarePCSPerception':
		case 'EpicPCSPerception': AnalyticsObject.AddValue( "TOTAL_PERCEPTION_SIMS_INSTALLED", 1, UnitRef );
			break;

		case 'CommonPCSAgility':
		case 'RarePCSAgility':
		case 'EpicPCSAgility': AnalyticsObject.AddValue( "TOTAL_AGILITY_SIMS_INSTALLED", 1, UnitRef );
			break;

		default:  AnalyticsObject.AddValue( "TOTAL_UNKNOWN_SIMS_INSTALLED", 1, UnitRef );
			break;
	}

	SubmitGameState( NewGameState, AnalyticsObject );
}

function AddWeaponUpgrade( XComGameState_Item UpdatedWeapon, XComGameState_Item UpdatedUpgrade )
{
	local XComGameState NewGameState;
	local XComGameState_Analytics AnalyticsObject;

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState( "Analytics Weapon Upgraded" );
	AnalyticsObject = XComGameState_Analytics( NewGameState.ModifyStateObject( class'XComGameState_Analytics', self.ObjectID ) );

	AnalyticsObject.AddValue( "TOTAL_WEAPON_UPGRADES_INSTALLED", 1 );

	switch (UpdatedWeapon.GetMyTemplateName())
	{
		case 'AssaultRifle_CV' :
		case 'AssaultRifle_MG' :
		case 'AssaultRifle_BM' : AnalyticsObject.AddValue( "TOTAL_RIFLE_UPGRADES_INSTALLED", 1 );
			break;

		case 'Shotgun_CV' :
		case 'Shotgun_MG' :
		case 'Shotgun_BM' : AnalyticsObject.AddValue( "TOTAL_SHOTGUN_UPGRADES_INSTALLED", 1 );
			break;

		case 'Cannon_CV' :
		case 'Cannon_MG' :
		case 'Cannon_BM' : AnalyticsObject.AddValue( "TOTAL_CANNON_UPGRADES_INSTALLED", 1 );
			break;

		case 'SniperRifle_CV' :
		case 'SniperRifle_MG' :
		case 'SniperRifle_BM' : AnalyticsObject.AddValue( "TOTAL_SNIPER_RIFLE_UPGRADES_INSTALLED", 1 );
			break;

		case 'SparkRifle_CV' :
		case 'SparkRifle_MG' :
		case 'SparkRifle_BM' : AnalyticsObject.AddValue( "TOTAL_SPARK_RIFLE_UPGRADES_INSTALLED", 1 );
			break;

		case 'VektorRifle_CV' :
		case 'VektorRifle_MG' :
		case 'VektorRifle_BM' : AnalyticsObject.AddValue( "TOTAL_VEKTOR_RIFLE_UPGRADES_INSTALLED", 1 );
			break;

		case 'Bullpup_CV' :
		case 'Bullpup_MG' :
		case 'Bullpup_BM' : AnalyticsObject.AddValue( "TOTAL_BULLPUP_UPGRADES_INSTALLED", 1 );
			break;

		default: AnalyticsObject.AddValue( "TOTAL_UNKNOWN_WEAPON_TYPE_UPGRADES_INSTALLED", 1 );
			break;
	}

	switch (UpdatedUpgrade.GetMyTemplateName())
	{
		case 'CritUpgrade_Bsc' :
		case 'CritUpgrade_Adv' :
		case 'CritUpgrade_Sup' : AnalyticsObject.AddValue( "TOTAL_LASER_SIGHT_UPGRADES_INSTALLED", 1 );
			break;

		case 'AimUpgrade_Bsc' :
		case 'AimUpgrade_Adv' :
		case 'AimUpgrade_Sup' : AnalyticsObject.AddValue( "TOTAL_SCOPE_UPGRADES_INSTALLED", 1 );
			break;

		case 'ClipSizeUpgrade_Bsc' :
		case 'ClipSizeUpgrade_Adv' :
		case 'ClipSizeUpgrade_Sup' : AnalyticsObject.AddValue( "TOTAL_CLIP_UPGRADES_INSTALLED", 1 );
			break;

		case 'FreeFireUpgrade_Bsc' :
		case 'FreeFireUpgrade_Adv' :
		case 'FreeFireUpgrade_Sup' : AnalyticsObject.AddValue( "TOTAL_HAIR_TRIGGER_UPGRADES_INSTALLED", 1 );
			break;

		case 'ReloadUpgrade_Bsc' :
		case 'ReloadUpgrade_Adv' :
		case 'ReloadUpgrade_Sup' : AnalyticsObject.AddValue( "TOTAL_AUTOLOADER_UPGRADES_INSTALLED", 1 );
			break;

		case 'MissDamageUpgrade_Bsc' :
		case 'MissDamageUpgrade_Adv' :
		case 'MissDamageUpgrade_Sup' : AnalyticsObject.AddValue( "TOTAL_STOCK_UPGRADES_INSTALLED", 1 );
			break;

		case 'FreeKillUpgrade_Bsc' :
		case 'FreeKillUpgrade_Adv' :
		case 'FreeKillUpgrade_Sup' : AnalyticsObject.AddValue( "TOTAL_REPEATER_UPGRADES_INSTALLED", 1 );
			break;

		default: AnalyticsObject.AddValue( "TOTAL_UNKNOWN_UPGRADES_INSTALLED", 1 );
			break;
	}

	SubmitGameState( NewGameState, AnalyticsObject );
}

function AddItemConstruction( XComGameState_Item NewItem, XComGameState_HeadquartersXCom XComHQ )
{
	local XComGameState NewGameState;
	local XComGameState_Analytics AnalyticsObject;
	local X2ItemTemplate ItemTemplate;
	local float EngBonus, SuppliesCost;
	local StrategyCost ScaledCost;
	local ArtifactCost Cost;
	local X2ItemTemplateManager ItemTemplateManager;

	ItemTemplate = NewItem.GetMyTemplate( );

	// Pay the strategy cost for the item
	EngBonus = class'UIUtilities_Strategy'.static.GetEngineeringDiscount(ItemTemplate.Requirements.RequiredEngineeringScore);
	ScaledCost = class'XComGameState_HeadquartersXCom'.static.GetScaledStrategyCost(ItemTemplate.Cost, XComHQ.ItemBuildCostScalars, EngBonus);

	foreach ScaledCost.ResourceCosts( Cost )
	{
		if (Cost.ItemTemplateName == 'Supplies')
			SuppliesCost += Cost.Quantity;
	}

	if (SuppliesCost <= 0.0)
		return;

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState( "Analytics Item Construction" );
	AnalyticsObject = XComGameState_Analytics( NewGameState.ModifyStateObject( class'XComGameState_Analytics', self.ObjectID ) );

	ItemTemplateManager = class'X2ItemTemplateManager'.static.GetItemTemplateManager();

	if(ItemTemplateManager.BuildItemWeaponCategories.Find(ItemTemplate.ItemCat) != INDEX_NONE)
		AnalyticsObject.AddValue( "SUPPLIES_SPENT_WEAPONS", SuppliesCost );
	else if(ItemTemplateManager.BuildItemArmorCategories.Find(ItemTemplate.ItemCat) != INDEX_NONE)
		AnalyticsObject.AddValue( "SUPPLIES_SPENT_ARMOR", SuppliesCost );
	else if(ItemTemplateManager.BuildItemMiscCategories.Find(ItemTemplate.ItemCat) != INDEX_NONE)
		AnalyticsObject.AddValue( "SUPPLIES_SPENT_ITEMS", SuppliesCost );

	SubmitGameState( NewGameState, AnalyticsObject );
}

function AddProvingGroundCompletion( XComGameState_Tech Tech, XComGameState_HeadquartersXCom XComHQ, XComGameState_HeadquartersProjectResearch ResearchProject, XComGameState GameState )
{
	local XComGameState NewGameState;
	local XComGameState_Analytics AnalyticsObject;
	local X2TechTemplate TechTemplate;
	local StrategyCost ScaledCost;
	local ArtifactCost Cost;
	local float SuppliesCost;
	local XComGameState_Item ItemState;
	local X2ItemTemplate ItemTemplate;
	local X2ItemTemplateManager ItemTemplateManager;
	local int TimeDiffHours;
	local TDateTime CurrentDate;

	TechTemplate = Tech.GetMyTemplate( );

	ScaledCost = TechTemplate.Cost;

	if (TechTemplate.bProvingGround)
		ScaledCost = class'XComGameState_HeadquartersXCom'.static.GetScaledStrategyCost(ScaledCost, XComHQ.ProvingGroundCostScalars, XComHQ.ProvingGroundPercentDiscount);
	else
		return;

	foreach ScaledCost.ResourceCosts( Cost )
	{
		if (Cost.ItemTemplateName == 'Supplies')
			SuppliesCost += Cost.Quantity;
	}

	if (SuppliesCost <= 0.0)
		return;

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState( "Analytics Item Construction (Proving Grounds)" );
	AnalyticsObject = XComGameState_Analytics( NewGameState.ModifyStateObject( class'XComGameState_Analytics', self.ObjectID ) );

	ItemTemplateManager = class'X2ItemTemplateManager'.static.GetItemTemplateManager();

	// assumes that all the item states that are in this gamestate were awarded by completing the proving ground "tech"
	foreach GameState.IterateByClassType( class'XComGameState_Item', ItemState )
	{
		ItemTemplate = ItemState.GetMyTemplate( );

		if(ItemTemplateManager.BuildItemWeaponCategories.Find(ItemTemplate.ItemCat) != INDEX_NONE)
			AnalyticsObject.AddValue( "SUPPLIES_SPENT_WEAPONS", SuppliesCost );
		else if(ItemTemplateManager.BuildItemArmorCategories.Find(ItemTemplate.ItemCat) != INDEX_NONE)
			AnalyticsObject.AddValue( "SUPPLIES_SPENT_ARMOR", SuppliesCost );
		else if(ItemTemplateManager.BuildItemMiscCategories.Find(ItemTemplate.ItemCat) != INDEX_NONE)
			AnalyticsObject.AddValue( "SUPPLIES_SPENT_ITEMS", SuppliesCost );
	}

	if (ResearchProject != none)
	{
		CurrentDate = `STRATEGYRULES.GameTime;
		TimeDiffHours = class'X2StrategyGameRulesetDataStructures'.static.DifferenceInHours( CurrentDate, ResearchProject.StartDateTime );
		TimeDiffHours += ResearchProject.ProjectTimeBeforePausesHours;
		AnalyticsObject.AddValue( "TOTAL_ITEM_BUILDING_HOURS", TimeDiffHours );
	}

	SubmitGameState( NewGameState, AnalyticsObject );
}

function AddCovertActionCompletion( )
{
	local XComGameState NewGameState;
	local XComGameState_Analytics AnalyticsObject;

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState( "Analytics Covert Action" );
	AnalyticsObject = XComGameState_Analytics( NewGameState.ModifyStateObject( class'XComGameState_Analytics', self.ObjectID ) );

	AnalyticsObject.AddValue( "COVERT_ACTIONS_COMPLETE", 1 );

	SubmitGameState( NewGameState, AnalyticsObject );
}

function AddFacilityConstruction( XComGameState_FacilityXCom Facility, XComGameState_HeadquartersProjectBuildFacility ProjectState )
{
	local XComGameState NewGameState;
	local XComGameState_Analytics AnalyticsObject;
	local int TimeDiffHours;
	local TDateTime CurrentDate;

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState( "Analytics Facility Construction" );
	AnalyticsObject = XComGameState_Analytics( NewGameState.ModifyStateObject( class'XComGameState_Analytics', self.ObjectID ) );

	CurrentDate = `STRATEGYRULES.GameTime;
	TimeDiffHours = class'X2StrategyGameRulesetDataStructures'.static.DifferenceInHours( CurrentDate, ProjectState.StartDateTime );
	TimeDiffHours += ProjectState.ProjectTimeBeforePausesHours;
	AnalyticsObject.AddValue( "TOTAL_FACILITY_BUILDING_HOURS", TimeDiffHours );

	SubmitGameState( NewGameState, AnalyticsObject );
}

function AddBondEvent( XComGameState_Unit Unit1, XComGameState_Unit Unit2, XComGameState_HeadquartersProjectBondSoldiers ProjectState )
{
	local XComGameState NewGameState;
	local XComGameState_Analytics AnalyticsObject;
	local int TimeDiffHours;
	local TDateTime CurrentDate;
	local SoldierBond BondData;

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState( "Analytics Soldier Bonds" );
	AnalyticsObject = XComGameState_Analytics( NewGameState.ModifyStateObject( class'XComGameState_Analytics', self.ObjectID ) );

	CurrentDate = `STRATEGYRULES.GameTime;
	TimeDiffHours = class'X2StrategyGameRulesetDataStructures'.static.DifferenceInHours( CurrentDate, ProjectState.StartDateTime );
	TimeDiffHours += ProjectState.ProjectTimeBeforePausesHours;
	AnalyticsObject.AddValue( "TOTAL_SOLDIER_BONDING_HOURS", TimeDiffHours );

	Unit1.GetBondData( Unit2.GetReference(), BondData );

	switch( BondData.BondLevel )
	{
		case 1: `assert( false ); // this should have gone through AddBondCreation!
			break;

		case 2: AnalyticsObject.AddValue( "NUM_SOLDIER_BONDS_2", 1 );
			break;

		case 3: AnalyticsObject.AddValue( "NUM_SOLDIER_BONDS_3", 1 );
			break;

		default: AnalyticsObject.AddValue( "NUM_UNKNOWN_SOLDIER_BOND_LEVELS", 1 );
			break;
	}

	SubmitGameState( NewGameState, AnalyticsObject );
}

function AddBondCreation( XComGameState_Unit Unit1, XComGameState_Unit Unit2 )
{
	local XComGameState NewGameState;
	local XComGameState_Analytics AnalyticsObject;

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState( "Analytics Soldier Bonds" );
	AnalyticsObject = XComGameState_Analytics( NewGameState.ModifyStateObject( class'XComGameState_Analytics', self.ObjectID ) );

	AnalyticsObject.AddValue( "NUM_SOLDIER_BONDS_1", 1 );

	SubmitGameState( NewGameState, AnalyticsObject );
}

function AddHavenScanning( XComGameState_Haven Haven )
{
	local XComGameState NewGameState;
	local XComGameState_Analytics AnalyticsObject;
	local XComGameState_Haven PrevHaven;
	local XComGameState_ResistanceFaction Faction;

	Faction = Haven.GetResistanceFaction( );
	if (Faction == none)
		return;

	PrevHaven = XComGameState_Haven( Haven.GetPreviousVersion( ) );

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState( "Analytics Soldier Bonds" );
	AnalyticsObject = XComGameState_Analytics( NewGameState.ModifyStateObject( class'XComGameState_Analytics', self.ObjectID ) );

	switch (Faction.GetMyTemplateName())
	{
		case 'Faction_Skirmishers': AnalyticsObject.AddValue( "HOURS_AT_SKIRMISHER_HQ", PrevHaven.TotalScanHours );
			break;

		case 'Faction_Reapers': AnalyticsObject.AddValue( "HOURS_AT_REAPER_HQ", PrevHaven.TotalScanHours );
			break;

		case 'Faction_Templars': AnalyticsObject.AddValue( "HOURS_AT_TEMPLAR_HQ", PrevHaven.TotalScanHours );
			break;
	}

	SubmitGameState( NewGameState, AnalyticsObject );
}

protected function string GetAlienStat( name TemplateName, bool WasKilled )
{
	switch (TemplateName)
	{
		case 'TutorialAdvTrooperM1':
		case 'AdvTrooperM1':		return WasKilled ? "ADVENT_TROOPER_MK1_KILLED" : "SOLDIERS_KILLED_BY_ADVENT_TROOPER_MK1";
			break;

		case 'AdvTrooperM2':		return WasKilled ? "ADVENT_TROOPER_MK2_KILLED" : "SOLDIERS_KILLED_BY_ADVENT_TROOPER_MK2";
			break;

		case 'AdvTrooperM3':		return WasKilled ? "ADVENT_TROOPER_MK3_KILLED" : "SOLDIERS_KILLED_BY_ADVENT_TROOPER_MK3";
			break;

		case 'AdvCaptainM1':		return WasKilled ? "ADVENT_CAPTAIN_MK1_KILLED" : "SOLDIERS_KILLED_BY_ADVENT_CAPTAIN_MK1";
			break;

		case 'AdvCaptainM2':		return WasKilled ? "ADVENT_CAPTAIN_MK2_KILLED" : "SOLDIERS_KILLED_BY_ADVENT_CAPTAIN_MK2";
			break;

		case 'AdvCaptainM3':		return WasKilled ? "ADVENT_CAPTAIN_MK3_KILLED" : "SOLDIERS_KILLED_BY_ADVENT_CAPTAIN_MK3";
			break;

		case 'AdvStunLancerM1':		return WasKilled ? "ADVENT_STUN_LANCER_MK1_KILLED" : "SOLDIERS_KILLED_BY_ADVENT_STUN_LANCER_MK1";
			break;

		case 'AdvStunLancerM2':		return WasKilled ? "ADVENT_STUN_LANCER_MK2_KILLED" : "SOLDIERS_KILLED_BY_ADVENT_STUN_LANCER_MK2";
			break;

		case 'AdvStunLancerM3':		return WasKilled ? "ADVENT_STUN_LANCER_MK3_KILLED" : "SOLDIERS_KILLED_BY_ADVENT_STUN_LANCER_MK3";
			break;

		case 'AdvShieldBearerM2':	return WasKilled ? "ADVENT_SHIELDBEARER_MK2_KILLED" : "SOLDIERS_KILLED_BY_ADVENT_SHIELDBEARER_MK2";
			break;

		case 'AdvShieldBearerM3':	return WasKilled ? "ADVENT_SHIELDBEARER_MK3_KILLED" : "SOLDIERS_KILLED_BY_ADVENT_SHIELDBEARER_MK3";
			break;

		case 'AdvPsiWitchM3':		return WasKilled ? "ADVENT_PSI_WITCH_MK3_KILLED" : "SOLDIERS_KILLED_BY_ADVENT_PSI_WITCH_MK3";
			break;

		case 'AdvMEC_M1':			return WasKilled ? "ADVENT_MEC_MK1_KILLED" : "SOLDIERS_KILLED_BY_ADVENT_MEC_MK1";
			break;

		case 'AdvMEC_M2':			return WasKilled ? "ADVENT_MEC_MK2_KILLED" : "SOLDIERS_KILLED_BY_ADVENT_MEC_MK2";
			break;

		case 'LostTowersTurretM1':
		case 'AdvShortTurretM3':
		case 'AdvShortTurretM2':
		case 'AdvShortTurretM1':
		case 'AdvShortTurret':
		case 'AdvTurretM3':
		case 'AdvTurretM2':
		case 'AdvTurretM1':			return WasKilled ? "ADVENT_TURRETS_KILLED" : "SOLDIERS_KILLED_BY_ADVENT_TURRETS";
			break;

		case 'PrototypeSectopod':
		case 'Sectopod':			return WasKilled ? "SECTOPODS_KILLED" : "SOLDIERS_KILLED_BY_SECTOPODS";
			break;

		case 'Sectoid':				return WasKilled ? "SECTOIDS_KILLED" : "SOLDIERS_KILLED_BY_SECTOIDS";
			break;

		case 'Archon':				return WasKilled ? "ARCHONS_KILLED" : "SOLDIERS_KILLED_BY_ARCHONS";
			break;

		case 'ArchonKing':			return WasKilled ? "ARCHON_KING_KILLED" : "SOLDIERS_KILLED_BY_ARCHON_KING";
			break;

		case 'ViperNeonate':
		case 'Viper':				return WasKilled ? "VIPERS_KILLED" : "SOLDIERS_KILLED_BY_VIPERS";
			break;

		case 'ViperKing':			return WasKilled ? "VIPER_KING_KILLED" : "SOLDIERS_KILLED_BY_VIPER_KING";
			break;

		case 'Muton':				return WasKilled ? "MUTONS_KILLED" : "SOLDIERS_KILLED_BY_MUTONS";
			break;

		case 'Berserker':			return WasKilled ? "MUTON_BERSERKERS_KILLED" : "SOLDIERS_KILLED_BY_MUTON_BERSERKERS";
			break;

		case 'BerserkerQueen':		return WasKilled ? "BERSERKER_QUEEN_KILLED" : "SOLDIERS_KILLED_BY_BERSERKER_QUEEN";
			break;

		case 'Cyberus':				return WasKilled ? "CYBERUS_KILLED" : "SOLDIERS_KILLED_BY_CYBERUS";
			break;

		case 'Gatekeeper':			return WasKilled ? "GATEKEEPERS_KILLED" : "SOLDIERS_KILLED_BY_GATEKEEPERS";
			break;

		case 'ChryssalidCocoonHuman':
		case 'ChryssalidCocoon':
		case 'Chryssalid':			return WasKilled ? "CHRYSSALIDS_KILLED" : "SOLDIERS_KILLED_BY_CHRYSSALIDS";
			break;

		case 'Andromedon':			return WasKilled ? "ANDROMEDONS_KILLED" : "SOLDIERS_KILLED_BY_ANDROMEDONS";
			break;

		case 'Faceless':			return WasKilled ? "FACELESS_KILLED" : "SOLDIERS_KILLED_BY_FACELESS";
			break;

		case 'PsiZombieHuman':
		case 'PsiZombie':			return WasKilled ? "ZOMBIES_KILLED" : "SOLDIERS_KILLED_BY_ZOMBIES";
			break;

		case 'AndromedonRobot':		return WasKilled ? "ANDROMEDON_ROBOT_KILLED" : "SOLDIERS_KILLED_BY_ANDROMEDON_ROBOT";
			break;

		case 'FeralMEC_M1':			
		case 'FeralMEC_M2':
		case 'FeralMEC_M3':			return WasKilled ? "FERAL_MEC_KILLED" : "SOLDIERS_KILLED_BY_FERAL_MEC";
			break;

		case 'Sectopod_Markov':		return WasKilled ? "MARKOV_SECTOPOD_KILLED" : "SOLDIERS_KILLED_BY_MARKOV_SECTOPOD";
			break;

		case 'AdvPurifierM1':		return WasKilled ? "ADVENT_PURIFIER_MK1_KILLED" : "SOLDIERS_KILLED_BY_ADVENT_PURIFIER_MK1";
			break;

		case 'AdvPurifierM2':		return WasKilled ? "ADVENT_PURIFIER_MK2_KILLED" : "SOLDIERS_KILLED_BY_ADVENT_PURIFIER_MK2";
			break;

		case 'AdvPurifierM3':		return WasKilled ? "ADVENT_PURIFIER_MK3_KILLED" : "SOLDIERS_KILLED_BY_ADVENT_PURIFIER_MK3";
			break;

		case 'AdvPriestM1':		return WasKilled ? "ADVENT_PRIEST_MK1_KILLED" : "SOLDIERS_KILLED_BY_ADVENT_PRIEST_MK1";
			break;

		case 'AdvPriestM2':		return WasKilled ? "ADVENT_PRIEST_MK2_KILLED" : "SOLDIERS_KILLED_BY_ADVENT_PRIEST_MK2";
			break;

		case 'AdvPriestM3':		return WasKilled ? "ADVENT_PRIEST_MK3_KILLED" : "SOLDIERS_KILLED_BY_ADVENT_PRIEST_MK3";
			break;

		case 'SpectreM1':		return WasKilled ? "SPECTRE_MK1_KILLED" : "SOLDIERS_KILLED_BY_SPECTRE_MK1";
			break;

		case 'SpectreM2':		return WasKilled ? "SPECTRE_MK2_KILLED" : "SOLDIERS_KILLED_BY_SPECTRE_MK2";
			break;

		case 'SpectralStunLancerM1':	return WasKilled ? "SPECTRAL_STUN_LANCER_KILLED" : "SOLDIERS_KILLED_BY_SPECTRAL_STUN_LANCER";
			break;

		case 'ShadowbindUnit': return WasKilled ? "SHADOWBIND_UNIT_KILLED" : "SOLDIERS_KILLED_BY_SHADOWBIND_UNIT";
			break;

		case 'AdvGeneralM1': return WasKilled ? "ADVENT_GENERAL_MK1_KILLED" : "SOLDIERS_KILLED_BY_ADVENT_GENERAL_MK1";
			break;

		case 'AdvGeneralM2': return WasKilled ? "ADVENT_GENERAL_MK2_KILLED" : "SOLDIERS_KILLED_BY_ADVENT_GENERAL_MK2";
			break;

		case 'AdvGeneralM3': return WasKilled ? "ADVENT_GENERAL_MK3_KILLED" : "SOLDIERS_KILLED_BY_ADVENT_GENERAL_MK3";
			break;

		case 'ChosenAssassin':
		case 'ChosenAssassinM2':
		case 'ChosenAssassinM3':
		case 'ChosenAssassinM4': return WasKilled ? "CHOSEN_ASSASSIN_KILLED" : "SOLDIERS_KILLED_BY_CHOSEN_ASSASSIN";
			break;

		case 'ChosenWarlock':
		case 'ChosenWarlockM2':
		case 'ChosenWarlockM3':
		case 'ChosenWarlockM4': return WasKilled ? "CHOSEN_WARLOCK_KILLED" : "SOLDIERS_KILLED_BY_CHOSEN_WARLOCK";
			break;

		case 'ChosenSniper':
		case 'ChosenSniperM2':
		case 'ChosenSniperM3':
		case 'ChosenSniperM4': return WasKilled ? "CHOSEN_HUNTER_KILLED" : "SOLDIERS_KILLED_BY_CHOSEN_HUNTER";
			break;

		case 'TheLostHP2':
		case 'TheLostHP3':
		case 'TheLostHP4':
		case 'TheLostHP5': return WasKilled ? "LOST_EASY_KILLED" : "SOLDIERS_KILLED_BY_LOST_EASY";
			break;

		case 'TheLostHP6':
		case 'TheLostHP7':
		case 'TheLostHP8':
		case 'TheLostHP9': return WasKilled ? "LOST_MEDIUM_KILLED" : "SOLDIERS_KILLED_BY_LOST_MEDIUM";
			break;

		case 'TheLostHP10':
		case 'TheLostHP11':
		case 'TheLostHP12': return WasKilled ? "LOST_HARD_KILLED" : "SOLDIERS_KILLED_BY_LOST_HARD";
			break;

		case 'TheLostDasherHP2':
		case 'TheLostDasherHP3':
		case 'TheLostDasherHP4':
		case 'TheLostDasherHP5':
		case 'TheLostDasherHP6':
		case 'TheLostDasherHP7':
		case 'TheLostDasherHP8': return WasKilled ? "LOST_DASHER_EASY_KILLED" : "SOLDIERS_KILLED_BY_LOST_DASHER_EASY";
			break;

		case 'TheLostDasherHP9':
		case 'TheLostDasherHP10':
		case 'TheLostDasherHP11':
		case 'TheLostDasherHP12':
		case 'TheLostDasherHP13':
		case 'TheLostDasherHP14':
		case 'TheLostDasherHP15': return WasKilled ? "LOST_DASHER_MEDIUM_KILLED" : "SOLDIERS_KILLED_BY_LOST_DASHER_MEDIUM";
			break;

		case 'TheLostDasherHP16':
		case 'TheLostDasherHP17':
		case 'TheLostDasherHP18':
		case 'TheLostDasherHP19':
		case 'TheLostDasherHP20':
		case 'TheLostDasherHP21':
		case 'TheLostDasherHP22': return WasKilled ? "LOST_DASHER_HARD_KILLED" : "SOLDIERS_KILLED_BY_LOST_DASHER_HARD";
			break;

		case 'TheLostHowlerHP4':
		case 'TheLostHowlerHP5':
		case 'TheLostHowlerHP6':
		case 'TheLostHowlerHP7':
		case 'TheLostHowlerHP8':
		case 'TheLostHowlerHP9':
		case 'TheLostHowlerHP10': return WasKilled ? "LOST_HOWLER_EASY_KILLED" : "SOLDIERS_KILLED_BY_LOST_HOWLER_EASY";
			break;

		case 'TheLostHowlerHP11':
		case 'TheLostHowlerHP12':
		case 'TheLostHowlerHP13':
		case 'TheLostHowlerHP14':
		case 'TheLostHowlerHP15':
		case 'TheLostHowlerHP16': return WasKilled ? "LOST_HOWLER_MEDIUM_KILLED" : "SOLDIERS_KILLED_BY_LOST_HOWLER_MEDIUM";
			break;

		case 'TheLostHowlerHP17':
		case 'TheLostHowlerHP18':
		case 'TheLostHowlerHP19':
		case 'TheLostHowlerHP20':
		case 'TheLostHowlerHP21':
		case 'TheLostHowlerHP22': return WasKilled ? "LOST_HOWLER_HARD_KILLED" : "SOLDIERS_KILLED_BY_LOST_HOWLER_HARD";
			break;
	}

	return WasKilled ? "UNKNOWN_ENEMY_TYPE_KILLED" : "SOLDIERS_KILLED_BY_UNKNOWN_ENEMY_TYPE";
}

protected function PlayerKilledOther(XComGameState_Unit SourceUnit, XComGameState_Unit KilledUnit)
{
	local name TemplateName;
	local X2SoldierClassTemplate SoldierClass;
	local StateObjectReference UnitRef;
	local X2CharacterTemplate SourceTemplate;

	TemplateName = KilledUnit.GetMyTemplateName();
	UnitRef.ObjectID = SourceUnit.ObjectID;

	`ANALYTICSLOG("STAT_KILLED:"@TemplateName);

	AddTacticalValue("ACC_UNIT_KILLS", 1, UnitRef);

	if (KilledUnit.bKilledByExplosion)
	{
		AddValue("ENEMIES_KILLED_BY_EXPLOSIVE_WEAPON", 1, UnitRef);
	}

	if (KilledUnit.IsFlanked())
	{
		`ANALYTICSLOG("STAT_KILLED_FLANKED");
	
		AddValue("TOTAL_NUMBER_OF_KILLS_AGAINST_FLANKED_ENEMIES", 1, UnitRef);
	}

	`ANALYTICSLOG("STAT_KILLED_COVER:"@KilledUnit.GetCoverTypeFromLocation());
	switch (KilledUnit.GetCoverTypeFromLocation())
	{
		case CT_None:
			AddValue("TOTAL_NUMBER_OF_KILLS_AGAINST_ENEMIES_IN_NO_COVER", 1, UnitRef);
			break;

		case CT_MidLevel:
			AddValue("TOTAL_NUMBER_OF_KILLS_AGAINST_ENEMIES_IN_LOW_COVER", 1, UnitRef);
			break;

		case CT_Standing:
			AddValue("TOTAL_NUMBER_OF_KILLS_AGAINST_ENEMIES_IN_HIGH_COVER", 1, UnitRef);
			break;
	}

	AddValue( GetAlienStat( TemplateName, true ), 1, UnitRef );

	// check source soldier class kills
	SourceTemplate = SourceUnit.GetMyTemplateManager().FindCharacterTemplate( SourceUnit.GetMyTemplateName() );
	SoldierClass = SourceUnit.GetSoldierClassTemplate();

	if (SoldierClass != None)
	{
		`ANALYTICSLOG("STAT_KILLED_BY:"@SoldierClass.DataName);

		switch (SoldierClass.DataName)
		{
			case 'Specialist':
				AddValue("TOTAL_SPECIALIST_KILLS", 1, UnitRef);
				break;

			case 'Grenadier':
				AddValue("TOTAL_GRENADIER_KILLS", 1, UnitRef);
				break;

			case 'Ranger':
				AddValue("TOTAL_RANGER_KILLS", 1, UnitRef);
				break;

			case 'Sharpshooter':
				AddValue("TOTAL_SHARPSHOOTER_KILLS", 1, UnitRef);
				break;

			case 'PsiOperative':
				AddValue("TOTAL_PSI_OPERATIVE_KILLS", 1, UnitRef);
				break;

			case 'Rookie':
				AddValue("TOTAL_ROOKIE_KILLS", 1, UnitRef);
				break;

			case 'CentralOfficer':
				AddValue("TOTAL_CENTRAL_KILLS", 1, UnitRef );
				break;

			case 'ChiefEngineer':
				AddValue( "TOTAL_SHEN_KILLS", 1, UnitRef );
				break;

			case 'Spark':
				AddValue( "TOTAL_SPARK_MEC_KILLS", 1, UnitRef );
				break;

			case 'Skirmisher':
				if (SourceTemplate.DataName != 'LostAndAbandonedMox')
					AddValue( "TOTAL_SKIRMISHER_KILLS", 1, UnitRef );
				else
					AddValue( "TOTAL_LOSTABANDONED_MOX_KILLS", 1, UnitRef );
				break;

			case 'Reaper':
				if (SourceTemplate.DataName != 'LostAndAbandonedElena')
					AddValue( "TOTAL_REAPER_KILLS", 1, UnitRef );
				else
					AddValue( "TOTAL_LOSTABANDONED_ANNA_KILLS", 1, UnitRef );
				break;

			case 'Templar':
				AddValue( "TOTAL_TEMPLAR_KILLS", 1, UnitRef );
				break;

			default:
				AddValue("TOTAL_UNKNOWN_SOLDIER_CLASS_KILLS", 1, UnitRef);
				break;
		}
	}
	else if (SourceTemplate.DataName == 'AdvPsiWitchM2')
	{
		AddValue("TOTAL_COMMANDER_KILLS", 1, UnitRef );
	}
	else if (SourceTemplate.DataName == class'X2StrategyElement_XpackResistanceActions'.default.VolunteerArmyCharacterTemplate)
	{
		AddValue("TOTAL_VOLUNTEER_ARMY_MILITIA_KILLS", 1, UnitRef );
	}
	else if ((SourceTemplate.DataName == 'XComTurretM1') ||
			 (SourceTemplate.DataName == 'XComTurretM2'))
	{
		AddValue("TOTAL_XCOM_TURRET_KILLS", 1, UnitRef);
	}
	else if (SourceTemplate.bIsRobotic)
	{
		if (SourceUnit.IsMindControlled())
			AddValue("TOTAL_HACKED_ROBOTIC_KILLS", 1, UnitRef );
		else
			AddValue("TOTAL_DOUBLE_AGENT_KILLS", 1, UnitRef );
	}
	else if (SourceTemplate.bIsAdvent)
	{
		if (SourceUnit.IsMindControlled())
			AddValue("TOTAL_CONTROLLED_ADVENT_KILLS", 1, UnitRef );
		else
			AddValue("TOTAL_DOUBLE_AGENT_KILLS", 1, UnitRef );
	}
	else if (SourceTemplate.bIsAlien)
	{
		AddValue( "TOTAL_CONTROLLED_ALIEN_KILLS", 1, UnitRef );
	}
	else
	{
		AddValue( "TOTAL_UNKNOWN_KILLS", 1, UnitRef );
	}
}


protected function OtherKilledPlayer(XComGameState_Unit SourceUnit, XComGameState_Unit KilledUnit)
{
	local name TemplateName;
	local X2SoldierClassTemplate SoldierClass;
	local int TimeDiffHours;
	local StateObjectReference UnitRef;
	local X2CharacterTemplate SourceTemplate;

	UnitRef.ObjectID = KilledUnit.ObjectID;

	if (!KilledUnit.bMissionProvided) // mission provided unit don't count as a unit loss for the endgame analytics
	AddValue("UNITS_LOST", 1);

	TimeDiffHours = class'X2StrategyGameRulesetDataStructures'.static.DifferenceInHours( KilledUnit.m_KIADate, KilledUnit.m_RecruitDate );
	AddValue("ACC_UNIT_SERVICE_LENGTH", TimeDiffHours, UnitRef );

	if (SourceUnit != none)
	{
		TemplateName = SourceUnit.GetMyTemplateName();
		`ANALYTICSLOG("STAT_KILLBY:"@TemplateName);

		if (!SourceUnit.IsSoldier() && !SourceUnit.IsMindControlled())
		{
			AddValue( GetAlienStat( TemplateName, false ), 1, UnitRef );
		}
		else
		{
			AddValue( "FRIENDLY_FIRE_DEATHS", 1, UnitRef );
		}
	}
	else
	{
		AddValue( "SOLDIERS_KILLED_BY_ENVIRONMENT", 1, UnitRef );
	}

	// check killed soldier rank
	switch (KilledUnit.GetRank())
	{
		case 0: AddValue("ROOKIES_KILLED", 1); break;
		case 1: AddValue("SQUADDIES_KILLED", 1); break;
		case 2: AddValue("CORPORALS_KILLED", 1); break;
		case 3: AddValue("SERGEANTS_KILLED", 1); break;
		case 4: AddValue("LIEUTENANTS_KILLED", 1); break;
		case 5: AddValue("CAPTAINS_KILLED", 1); break;
		case 6: AddValue("MAJORS_KILLED", 1); break;
		case 7: AddValue("COLONELS_KILLED", 1); break;
		case 8: AddValue("BRIGADIER_KILLED", 1); break;

		default: AddValue("UNKNOWN_RANK_KILLED", 1);
			break;
	}

	// check killed soldier class
	SourceTemplate = KilledUnit.GetMyTemplateManager().FindCharacterTemplate( KilledUnit.GetMyTemplateName() );
	SoldierClass = KilledUnit.GetSoldierClassTemplate();

	if (SoldierClass != None)
	{
		`ANALYTICSLOG("STAT_KILLBY_BY:"@SoldierClass.DataName);

		switch (SoldierClass.DataName)
		{
			case 'Specialist':
				AddValue("SPECIALISTS_KILLED", 1);
				break;

			case 'Grenadier':
				AddValue("GRENADIERS_KILLED", 1);
				break;

			case 'Ranger':
				AddValue("RANGERS_KILLED", 1);
				break;

			case 'Sharpshooter':
				AddValue("SHARPSHOOTERS_KILLED", 1);
				break;

			case 'PsiOperative':
				AddValue("PSI_OPERATIVES_KILLED", 1);
				break;

			case 'Rookie':
				AddValue("ROOKIE_SOLIDER_KILLED", 1);
				break;

			case 'CentralOfficer':
				AddValue( "CENTRALS_KILLED", 1, UnitRef );
				break;

			case 'ChiefEngineer':
				AddValue( "SHEN_KILLED", 1, UnitRef );
				break;

			case 'Spark':
				AddValue( "SPARK_MEC_KILLED", 1, UnitRef );
				break;

			case 'Skirmisher':
				if (SourceTemplate.DataName != 'LostAndAbandonedMox')
					AddValue( "SKIRMISHERS_KILLED", 1, UnitRef );
				else
					AddValue( "LOSTABANDONED_MOX_KILLED", 1, UnitRef );
				break;

			case 'Reaper':
				if (SourceTemplate.DataName != 'LostAndAbandonedElena')
					AddValue( "REAPERS_KILLED", 1, UnitRef );
				else
					AddValue( "LOSTABANDONED_ANNA_KILLED", 1, UnitRef );
				break;

			case 'Templar':
				AddValue( "TEMPLARS_KILLED", 1, UnitRef );
				break;

			default:
				AddValue( "UNKNOWN_SOLDIER_CLASS_KILLED", 1);
				break;
		}
	}
	else if (SourceTemplate.DataName == 'AdvPsiWitchM2')
	{
		AddValue("COMMANDERS_KILLED", 1, UnitRef );
	}
	else if (SourceTemplate.DataName == class'X2StrategyElement_XpackResistanceActions'.default.VolunteerArmyCharacterTemplate)
	{
		AddValue("VOLUNTEER_ARMY_MILITIA_KILLED", 1, UnitRef );
	}
	else if (!KilledUnit.IsMindControlled() && (SourceTemplate.bIsAdvent || SourceTemplate.bIsRobotic))
	{
		AddValue("DOUBLE_AGENTS_KILLED", 1, UnitRef );
	}
	else if ((SourceTemplate.DataName == 'XComTurretM1') ||
		(SourceTemplate.DataName == 'XComTurretM2'))
	{
		AddValue("XCOM_TURRET_KILLED", 1, UnitRef );
	}
	else
	{
		AddValue( "UNKNOWN_UNIT_TYPE_KILLED", 1, UnitRef );
	}
}


protected function HandleKillMail(XComGameState_Unit SourceUnit, XComGameState_Unit KilledUnit, XComGameState NewGameState)
{
	// player kills something
	if (SourceUnit != None && SourceUnit.IsPlayerControlled())
	{
		// Friendly fire
		if (KilledUnit.IsSoldier() && KilledUnit.IsPlayerControlled())
		{
			OtherKilledPlayer(SourceUnit, KilledUnit);
		}
		else
		{
			PlayerKilledOther(SourceUnit, KilledUnit);
		}
	}
	else
	if (KilledUnit.IsSoldier())
	{
		// player unit was killed
		OtherKilledPlayer(SourceUnit, KilledUnit);
	}
}


protected function HandleWeaponKill(XComGameState_Unit SourceUnit, XComGameState_Ability Ability)
{
	local XComGameState_Item Item;
	local XComGameStateHistory History;
	local name TemplateName;
	local StateObjectReference UnitRef;

	History = `XCOMHISTORY;
	Item = XComGameState_Item(History.GetGameStateForObjectID(Ability.SourceWeapon.ObjectID));
	TemplateName = Item.GetMyTemplateName();
	UnitRef.ObjectID = SourceUnit.ObjectID;

	switch (TemplateName)
	{
		case 'AssaultRifle_CV':
		case 'AssaultRifle_MG':
		case 'AssaultRifle_BM':
			AddValue("KILLS_WITH_RIFLES", 1, UnitRef);
			break;

		case 'Pistol_CV':
		case 'Pistol_MG':
		case 'Pistol_BM':
			AddValue("KILLS_WITH_PISTOLS", 1, UnitRef);
			break;

		case 'Shotgun_CV':
		case 'Shotgun_MG':
		case 'Shotgun_BM':
			AddValue("KILLS_WITH_SHOTGUNS", 1, UnitRef);

		case 'Cannon_CV':
		case 'Cannon_MG':
		case 'Cannon_BM':
			AddValue("KILLS_WITH_CANNON", 1, UnitRef);
			break;

		case 'RocketLauncher':
			AddValue("KILLS_WITH_HEAVY_WEAPONS", 1, UnitRef);
			AddValue("KILLS_WITH_ROCKET_LAUNCHER", 1, UnitRef);
			break;

		case 'ShredderGun':
			AddValue("KILLS_WITH_HEAVY_WEAPONS", 1, UnitRef);
			AddValue("KILLS_WITH_SHREDDER_GUN", 1, UnitRef);
			break;

		case 'Flamethrower':
			AddValue("KILLS_WITH_HEAVY_WEAPONS", 1, UnitRef);
			AddValue("KILLS_WITH_FLAMETHROWER", 1, UnitRef);
			break;

		case 'FlamethrowerMk2':
			AddValue( "KILLS_WITH_HEAVY_WEAPONS", 1, UnitRef );
			AddValue( "KILLS_WITH_HELLFIRE", 1, UnitRef );
			break;

		case 'BlasterLauncher':
			AddValue("KILLS_WITH_HEAVY_WEAPONS", 1, UnitRef);
			AddValue("KILLS_WITH_BLASTER_LAUNCHER", 1, UnitRef);
			break;

		case 'PlasmaBlaster':
			AddValue("KILLS_WITH_HEAVY_WEAPONS", 1, UnitRef);
			AddValue("KILLS_WITH_PLASMA_BLASTER", 1, UnitRef);
			break;

		case 'ShredstormCannon':
			AddValue("KILLS_WITH_HEAVY_WEAPONS", 1, UnitRef);
			AddValue("KILLS_WITH_SHREDSTORM_CANNON", 1, UnitRef);
			break;

		case 'Gremlin_CV':
		case 'Gremlin_MG':
		case 'Gremlin_BM':
		case 'Gremlin_Shen':
			AddValue("KILLS_WITH_GREMLIN", 1, UnitRef);
			break;

		case 'PsiAmp_CV':
		case 'PsiAmp_MG':
		case 'PsiAmp_BM':
			AddValue("KILLS_WITH_PSIONIC_ABILITIES", 1, UnitRef);
			break;

		case 'SniperRifle_CV':
		case 'SniperRifle_MG':
		case 'SniperRifle_BM':
			AddValue("KILLS_WITH_SNIPER_RIFLES", 1, UnitRef);
			break;

		case 'Sword_CV':
		case 'Sword_MG':
		case 'Sword_BM':
			AddValue("KILLS_WITH_SWORDS", 1, UnitRef);
			break;

		case 'AlienHunterRifle_CV':
		case 'AlienHunterRifle_MG':
		case 'AlienHunterRifle_BM':
			AddValue("KILLS_WITH_HUNTER_RIFLES", 1, UnitRef);
			break;

		case 'AlienHunterPistol_CV':
		case 'AlienHunterPistol_MG':
		case 'AlienHunterPistol_BM':
			AddValue("KILLS_WITH_HUNTER_PISTOLS", 1, UnitRef);
			break;

		case 'AlienHunterAxe_CV':
		case 'AlienHunterAxe_MG':
		case 'AlienHunterAxe_BM':
		case 'AlienHunterAxeThrown_CV':
		case 'AlienHunterAxeThrown_MG':
		case 'AlienHunterAxeThrown_BM':
			AddValue("KILLS_WITH_HUNTER_AXES", 1, UnitRef);
			break;

		case 'HeavyAlienArmor':
		case 'HeavyAlienArmorMk2':
			AddValue("KILLS_WITH_ALIEN_ARMOR", 1, UnitRef);
			break;

		case 'SparkRifle_CV':
		case 'SparkRifle_MG':
		case 'SparkRifle_BM':
			AddValue("KILLS_WITH_SPARK_RIFLE", 1, UnitRef);
			break;

		case 'SparkBit_CV':
		case 'SparkBit_MG':
		case 'SparkBit_BM':
			AddValue("KILLS_WITH_SPARK_BIT", 1, UnitRef);
			break;

		case 'VektorRifle_CV':
		case 'VektorRifle_MG':
		case 'VektorRifle_BM':
			AddValue("KILLS_WITH_VEKTOR_RIFLE", 1, UnitRef);
			break;

		case 'Bullpup_CV':
		case 'Bullpup_MG':
		case 'Bullpup_BM':
			AddValue("KILLS_WITH_BULLPUP", 1, UnitRef);
			break;

		case 'WristBlade_CV':
		case 'WristBlade_MG':
		case 'WristBlade_BM':
			AddValue("KILLS_WITH_WRISTBLADE", 1, UnitRef);
			break;

		case 'ShardGauntlet_CV':
		case 'ShardGauntlet_MG':
		case 'ShardGauntlet_BM':
			AddValue("KILLS_WITH_SHARD_GAUNTLET", 1, UnitRef);
			break;

		case 'Sidearm_CV':
		case 'Sidearm_MG':
		case 'Sidearm_BM':
			AddValue("KILLS_WITH_SIDEARM", 1, UnitRef);
			break;

		case 'ChosenShotgun_XCOM':
			AddValue("KILLS_WITH_XCOM_CHOSEN_SHOTGUN", 1, UnitRef );
			break;

		case 'ChosenRifle_XCOM':
			AddValue("KILLS_WITH_XCOM_CHOSEN_RIFLE", 1, UnitRef );
			break;

		case 'ChosenSword_XCOM':
			AddValue("KILLS_WITH_XCOM_CHOSEN_SWORD", 1, UnitRef );
			break;

		case 'ChosenSniperRifle_XCOM':
			AddValue("KILLS_WITH_XCOM_CHOSEN_SNIPER_RIFLE", 1, UnitRef );
			break;

		case 'ChosenSniperPistol_XCOM':
			AddValue("KILLS_WITH_XCOM_CHOSEN_PISTOL", 1, UnitRef );
			break;

		case 'Reaper_Claymore':
			AddValue("KILLS_WITH_CLAYMORE", 1, UnitRef);
			break;

		case 'MilitiaRifle_CV':
			AddValue("KILLS_WITH_MILITIA_RIFLE", 1, UnitRef);
			break;

		case 'XComTurretM1_WPN':
		case 'XComTurretM2_WPN':
			AddValue("KILLS_WITH_XCOM_TURRET", 1, UnitRef);
			break;

		default:
			if ((X2GrenadeTemplate( Item.GetMyTemplate( ) ) != none) || (X2GrenadeTemplate( Item.GetLoadedAmmoTemplate( Ability ) ) != none))
			{
				AddValue( "KILLS_WITH_GRENADE", 1, UnitRef );
			}
			else
			{
				// Some of the SPARK abilities deal damage without using an item
				TemplateName = Ability.GetMyTemplateName();
				switch (TemplateName)
				{
					case 'Strike':	AddValue( "KILLS_WITH_SPARK_STRIKE", 1, UnitRef );
						break;

					case 'Nova': AddValue( "KILLS_WITH_SPARK_NOVA", 1, UnitRef );
						break;

					case 'SparkDeathExplosion': AddValue( "KILLS_WITH_SPARK_DEATH_EXPLOSION", 1, UnitRef );
						break;

					default:
						AddValue( "KILLS_WITH_UNKNOWN_WEAPONS", 1, UnitRef );
						break;
				}
			}
			break;
	}
}

cpptext
{
	virtual void Serialize(FArchive& Ar);

	static TSet<FString> FiraxisMetrics;
	static void BuildFiraxisMetricsSet( );
}

DefaultProperties
{
	CampaignDifficulty=-1
	bSingletonStateType=true
	SubmitToFiraxisLive=true
	HasChanged=false
}