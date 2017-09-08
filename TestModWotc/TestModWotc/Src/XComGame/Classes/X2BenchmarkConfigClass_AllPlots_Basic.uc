//---------------------------------------------------------------------------------------
//  FILE:    X2BenchmarkConfigClass_AllPlots_Basic.uc
//  AUTHOR:  Ryan McFall  --  1/10/2017
//  PURPOSE: This benchmark loads all plots several times.
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class X2BenchmarkConfigClass_AllPlots_Basic extends X2BenchmarkConfigClass config(Game);

//Return FALSE if the test should end, TRUE otherwise
function bool GetNextScenario(out ScenarioData NextScenario, optional int ScenarioIndex = 0)
{	
	local X2CardManager CardManager;	
	local string DeckMissionType;

	//BenchmarkTestScenarios[0] defines stock / basic properties for most of the scenario values, such as squad size, weapons, classes, etc.
	NextScenario = BenchmarkTestScenarios[0];

	//Move on to the next mission type, which will determine the plot / parcels used.
	CardManager = class'X2CardManager'.static.GetCardManager();
	CardManager.SelectNextCardFromDeck('MissionTypes', DeckMissionType);
	if (DeckMissionType == "Multiplayer")
	{
		//If it was multiplayer, choose another one
		CardManager.SelectNextCardFromDeck('MissionTypes', DeckMissionType);
	}
	NextScenario.MissionType = DeckMissionType;

	return ScenarioIndex < 100;
}