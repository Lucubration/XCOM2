//---------------------------------------------------------------------------------------
//  FILE:    X2Action_ATT.uc
//  AUTHOR:  Dan Kaplan  --  4/28/2015
//  PURPOSE: Starts and controls the ATT sequence when dropping off reinforcements
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class X2Action_ATT extends X2Action_PlayMatinee config(GameData);

var const config string MatineeCommentPrefix;
var const config int NumDropSlots;

var private array<StateObjectReference> MatineeUnitRefs;

function Init()
{
	// need to find the matinee before calling super, which will init it
	FindATTMatinee();

	super.Init();

	AddUnitsToMatinee(StateChangeContext);

	SetMatineeBase('CIN_Advent_Base');
	SetMatineeLocation(XComGameState_AIReinforcementSpawner(Metadata.StateObject_NewState).SpawnInfo.SpawnLocation);
}

private function AddUnitsToMatinee(XComGameStateContext InContext)
{
	local XComGameState_Unit GameStateUnit;
	local int UnitIndex;
	local bool IsMec;

	UnitIndex = 1;

	foreach InContext.AssociatedState.IterateByClassType(class'XComGameState_Unit', GameStateUnit)
	{
		IsMec = GameStateUnit.GetMyTemplate().CharacterGroupName == 'AdventMEC';
		AddUnitToMatinee(name("Mec" $ UnitIndex), IsMec ? GameStateUnit : none);
		AddUnitToMatinee(name("Advent" $ UnitIndex), (!IsMec) ? GameStateUnit : none);
	
		UnitIndex++;

		MatineeUnitRefs.AddItem(GameStateUnit.GetReference());
	}

	while(UnitIndex < NumDropSlots)
	{
		AddUnitToMatinee(name("Mec" $ UnitIndex), none);
		AddUnitToMatinee(name("Advent" $ UnitIndex), none);
		UnitIndex++;
	}
}

//We never time out
function bool IsTimedOut()
{
	return false;
}

private function FindATTMatinee()
{
	local array<SequenceObject> FoundMatinees;
	local SeqAct_Interp Matinee;
	local Sequence GameSeq;
	local int Index;
	local string DesiredMatineePrefix;
	local XComGameState_BattleData BattleData;
	local PlotDefinition PlotDef;
	local PlotTypeDefinition PlotTypeDef;

	DesiredMatineePrefix = MatineeCommentPrefix; // default to the general config data

	// see if the plot type defines an override
	BattleData = XComGameState_BattleData( `XCOMHISTORY.GetSingleGameStateObjectForClass( class'XComGameState_BattleData', true ) );
	if ((BattleData != none) && (`TACTICALRULES != none))
	{
		PlotDef = `PARCELMGR.GetPlotDefinition(BattleData.MapData.PlotMapName);
		PlotTypeDef = `PARCELMGR.GetPlotTypeDefinition(PlotDef.strType);

		if (PlotTypeDef.ATTMatineeOverride != "")
			DesiredMatineePrefix = PlotTypeDef.ATTMatineeOverride;
	}

	GameSeq = class'WorldInfo'.static.GetWorldInfo().GetGameSequence();
	GameSeq.FindSeqObjectsByClass(class'SeqAct_Interp', true, FoundMatinees);
	FoundMatinees.RandomizeOrder();

	for (Index = 0; Index < FoundMatinees.length; Index++)
	{
		Matinee = SeqAct_Interp(FoundMatinees[Index]);
		`log("Matinee:"@ Matinee.ObjComment);
		if( Instr(Matinee.ObjComment, DesiredMatineePrefix, , true) >= 0 )
		{
			Matinees.AddItem(Matinee);
			return;
		}
	}

	`Redscreen("Could not find the ATT matinee!");
	Matinee = none;
}

simulated state Executing
{
	simulated event BeginState(name PrevStateName)
	{
		super.BeginState(PrevStateName);
		
		`BATTLE.SetFOW(false);
	}

	simulated event EndState(name NextStateName)
	{

		super.EndState(NextStateName);

		`BATTLE.SetFOW(true);
	}
}


DefaultProperties
{
}
