//---------------------------------------------------------------------------------------
//  FILE:    X2BenchmarkAutoTestMgr_PrecacheTextures.uc
//  AUTHOR:  Ryan McFall
//  PURPOSE: Auto test mgr variant that loads levels and then captures stats / disconnects
//			 once the level is fully loaded
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class X2BenchmarkAutoTestMgr_PrecacheTextures extends X2BenchmarkAutoTestMgr
	config(Benchmark)
	native(Core);

//Instead of giving orders, record stats and move on
function GiveTurnOrders()
{
	local PlotDefinition PlotDef;
	local XComGameState_BattleData BattleData;

	BattleData = XComGameState_BattleData(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_BattleData'));
	PlotDef = `PARCELMGR.GetPlotDefinition(BattleData.MapData.PlotMapName);
	RecordLoadedTextures(PlotDef.strType);
	ExportPlotTypeTextureList();

	ConsoleCommand("disconnect");
}

native function RecordLoadedTextures(string PlotType);
native function ExportPlotTypeTextureList();

