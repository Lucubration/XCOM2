//---------------------------------------------------------------------------------------
//  FILE:    X2BenchmarkAutoTestMgr_LevelLoadStats.uc
//  AUTHOR:  Ryan McFall
//  PURPOSE: Auto test mgr variant that loads levels and then captures stats / disconnects
//			 once the level is fully loaded
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class X2BenchmarkAutoTestMgr_LevelLoadStats extends X2BenchmarkAutoTestMgr
	config(Benchmark)
	native(Core);

//Instead of giving orders, record stats and move on
function GiveTurnOrders()
{
	ConsoleCommand("memleakcheck");
	ConsoleCommand("disconnect");
}

