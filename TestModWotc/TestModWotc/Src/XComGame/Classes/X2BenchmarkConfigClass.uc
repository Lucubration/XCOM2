//---------------------------------------------------------------------------------------
//  FILE:    X2BenchmarkConfigClass.uc
//  AUTHOR:  Ryan McFall  --  1/10/2017
//  PURPOSE: Allows for creation of custom benchmarks. No manager for these templates, 
//			 the CDOs are passed in as the template.
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class X2BenchmarkConfigClass extends X2DataTemplate config(Benchmark);

struct ScenarioData
{
	var name SquadSizeSelectorName;
	var name ClassSelectorName;
	var name RankSelectorName;
	var name ArmorSelectorName;
	var name PrimaryWeaponSelectorName;
	var name SecondaryWeaponSelectorName;
	var name UtilityItemSelectorName;
	var name AlertForceLevelSelectorName;
	var name EnemyForcesSelectorName;

	var string MissionType;
	var string PlotName;
	var int LevelSeed;
};

var const config array<ScenarioData> BenchmarkTestScenarios;

//Return FALSE if the test should end, TRUE otherwise
function bool GetNextScenario(out ScenarioData NextScenario, optional int ScenarioIndex = 0)
{	
	NextScenario = BenchmarkTestScenarios[ScenarioIndex];
	return ScenarioIndex < BenchmarkTestScenarios.Length;
}