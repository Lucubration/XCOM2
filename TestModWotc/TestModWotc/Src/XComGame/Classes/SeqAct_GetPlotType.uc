//---------------------------------------------------------------------------------------
//  FILE:    SeqAct_GetPlotType.uc
//  AUTHOR:  James Brawley
//  PURPOSE: Fetch the plot type from the battle data.  Needed for multiple purposes,
//			 primarily to toggle reinforcement arrival types for underground missions.
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2017 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class SeqAct_GetPlotType extends SequenceAction;

var string PlotType;

event Activated()
{	
	local XComGameState_BattleData BattleData;
	local PlotDefinition PlotDef;

	BattleData = XComGameState_BattleData( `XCOMHISTORY.GetSingleGameStateObjectForClass( class'XComGameState_BattleData', true ) );

	if ((BattleData != none))
	{
		PlotDef = `PARCELMGR.GetPlotDefinition(BattleData.MapData.PlotMapName);
		PlotType = PlotDef.strType;
	}
	else
	{
		`Redscreen("SeqAct_GetPlotType: Could not find BattleData, something is horribly wrong.");
	}
}

defaultproperties
{
	ObjCategory="Level"
	ObjName="Get Plot Type"
	
	bConvertedForReplaySystem=true
	bCanBeUsedForGameplaySequence=true

	VariableLinks(0)=(ExpectedType=class'SeqVar_String',LinkDesc="Plot Type",PropertyName=PlotType, bWriteable=true)
}

