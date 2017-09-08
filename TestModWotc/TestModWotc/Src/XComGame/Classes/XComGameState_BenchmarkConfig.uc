//---------------------------------------------------------------------------------------
//  FILE:    XComGameState_BenchmarkConfig.uc
//  AUTHOR:  Russell Aasland  --  9/6/2016
//  PURPOSE: Represents the battle configuration currently being tested.
//				Default contains the list of all configurations to test.
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class XComGameState_BenchmarkConfig extends XComGameState_BaseObject	
	dependson(X2BenchmarkConfigClass);

var X2BenchmarkConfigClass BenchmarkConfig;
var int ActiveScenarioIdx;
var ScenarioData ActiveScenario;

event OnCreation(optional X2DataTemplate InitTemplate)
{
	local X2BenchmarkConfigClass Config;

	//Save off the template
	Config = X2BenchmarkConfigClass(InitTemplate);
	BenchmarkConfig = Config;

	//ActiveScenario is retrieved from the BenchmarkConfig object's GetNextScenario
}