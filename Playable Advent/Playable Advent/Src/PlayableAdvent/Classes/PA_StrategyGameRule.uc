class PA_StrategyGameRule extends XComGameStateContext_StrategyGameRule;


static function CompleteStrategyFromTacticalTransfer()
{
	local XComGameState NewGameState;
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_Unit UnitState;
	local array<StateObjectReference> SoldiersToTransfer;
	local int idx, PA_healthReturned;
	local XComGameStateHistory History;
	local XComGameState_BattleData BattleData;
	local name PA_tplName;

	`Log("davea debug overrode strat-from-tac");
	History = `XCOMHISTORY;

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Post Mission Squad Cleanup");
	XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
	XComHQ = XComGameState_HeadquartersXCom(NewGameState.CreateStateObject(class'XComGameState_HeadquartersXCom', XComHQ.ObjectID));
	NewGameState.AddStateObject(XComHQ);

	BattleData = XComGameState_BattleData(History.GetSingleGameStateObjectForClass(class'XComGameState_BattleData'));
	BattleData = XComGameState_BattleData(NewGameState.CreateStateObject(class'XComGameState_BattleData', BattleData.ObjectID));
	NewGameState.AddStateObject(BattleData);

	// If the unit is in the squad or was spawned from the avenger on the mission, add them to the SoldiersToTransfer array
	SoldiersToTransfer = XComHQ.Squad;
	for (idx = 0; idx < XComHQ.Crew.Length; idx++)
	{
		if (XComHQ.Crew[idx].ObjectID != 0)
		{
			UnitState = XComGameState_Unit(History.GetGameStateForObjectID(XComHQ.Crew[idx].ObjectID));
			if (UnitState.bSpawnedFromAvenger)
			{
				SoldiersToTransfer.AddItem(XComHQ.Crew[idx]);
			}
		}
	}
	for( idx = 0; idx < SoldiersToTransfer.Length; idx++ )
	{
		if(SoldiersToTransfer[idx].ObjectID != 0)
		{
			UnitState = XComGameState_Unit(NewGameState.CreateStateObject(class'XComGameState_Unit', SoldiersToTransfer[idx].ObjectID));
			PA_tplName = UnitState.GetMyTemplateName();
			NewGameState.AddStateObject(UnitState);

			if(!UnitState.IsDead() && !UnitState.bCaptured && UnitState.IsInjured() && UnitState.GetStatus() != eStatus_Healing)
			{
				`Log("davea debug found wounded: " @ UnitState.GetFullName() @ " Base Health: " @ UnitState.GetBaseStat(eStat_HP) @ "Lowest Health: " @ UnitState.LowestHP @ " Current Health: " @ UnitState.GetCurrentStat(eStat_HP) @ " Carried Out: " @  UnitState.bBodyRecovered @ " template " @ PA_tplName);
				if (PA_tplName == 'PA_Mec') // yeah, sue me, its hardcoded
				{
					PA_healthReturned = 0.75 * (UnitState.GetBaseStat(eStat_HP) - UnitState.LowestHP);
				 	`Log("davea debug jiffylube returned " @ PA_healthReturned @ " health");
				 	UnitState.LowestHP += PA_healthReturned;
				 	if (UnitState.GetCurrentStat(eStat_HP) < UnitState.LowestHP)
					{
				 		UnitState.SetCurrentStat(eStat_HP, UnitState.LowestHP);
					}
				}
			}
		}
	}

	`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);
	UpdateSkyranger();
	CleanupProxyVips();
	ProcessMissionResults();
	SquadTacticalToStrategyTransfer();
}
