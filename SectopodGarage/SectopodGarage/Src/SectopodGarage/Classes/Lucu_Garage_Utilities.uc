class Lucu_Garage_Utilities extends Object;

static function GiveSecto()
{
	local XComGameStateHistory History;
	local XComGameState NewGameState;
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_Lucu_Garage_Facility FacilityState;
	local XComGameState_Unit NewUnitState;
	local XComGameState_Lucu_Garage_XtopodUnitState XtopodState;
	local int i, idx, NewRank;

	History = `XCOMHISTORY;

	XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));

	FacilityState = GetFacilityComponent(XComHQ);
	if (FacilityState == none)
	{
		`LOG("Xtopod Garage: Aborting GiveSecto (facility state not found).");
		return;
	}

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Give Mini Sectopod");
	XComHQ = XComGameState_HeadquartersXCom(NewGameState.CreateStateObject(class'XComGameState_HeadquartersXCom', XComHQ.ObjectID));
	NewGameState.AddStateObject(XComHQ);
	FacilityState = XComGameState_Lucu_Garage_Facility(NewGameState.CreateStateObject(class'XComGameState_Lucu_Garage_Facility', FacilityState.ObjectID));
	NewGameState.AddStateObject(FacilityState);

	// Use the character pool's creation method to retrieve a unit
	NewUnitState = `CHARACTERPOOLMGR.CreateCharacter(NewGameState, `XPROFILESETTINGS.Data.m_eCharPoolUsage, 'Lucu_Garage_Xtopod');
	NewUnitState.RandomizeStats();
	NewUnitState.SetCountry('Lucu_Garage_Country_Xtopod');
	NewGameState.AddStateObject(NewUnitState);

	NewRank = 1;
	NewUnitState.SetCharacterName("Default", "Xtopod", "Stompy");
	NewUnitState.SetXPForRank(NewRank);
	NewUnitState.StartingRank = NewRank;
	for (idx = 0; idx < NewRank; idx++)
	{
		// Rank up to squaddie
		if (idx == 0)
		{
			NewUnitState.RankUpSoldier(NewGameState, 'Lucu_Garage_Xtopod');
			NewUnitState.ApplySquaddieLoadout(NewGameState);
			for (i = 0; i < NewUnitState.GetSoldierClassTemplate().GetAbilityTree(0).Length; ++i)
			{
				NewUnitState.BuySoldierProgressionAbility(NewGameState, 0, i);
			}
		}
		else
		{
			NewUnitState.RankUpSoldier(NewGameState, NewUnitState.GetSoldierClassTemplate().DataName);
		}
	}
	
	NewUnitState.ApplySquaddieLoadout(NewGameState, XComHQ);
	
	XComHQ.AddToCrew(NewGameState, NewUnitState);
	NewUnitState.SetHQLocation(eSoldierLoc_Barracks);
	XComHQ.HandlePowerOrStaffingChange(NewGameState);
	
	XtopodState = XComGameState_Lucu_Garage_XtopodUnitState(NewGameState.CreateStateObject(class'XComGameState_Lucu_Garage_XtopodUnitState'));
	XtopodState.InitComponent(NewUnitState.GetReference());
	XtopodState.ValidateLoadout(NewGameState);
	FacilityState.XtopodUnitStates.AddItem(XtopodState.GetReference());
	NewGameState.AddStateObject(XtopodState);

	History.AddGameStateToHistory(NewGameState);
}

static function XComGameState_Lucu_Garage_XtopodUnitState GetXtopodComponent(XComGameState_Unit Unit, XComGameState_Lucu_Garage_Facility FacilityState = none)
{
	local XComGameStateHistory History;
	local XComGameState_HeadquartersXCom XComHQ;
	local StateObjectReference XtopodRef;
	local XComGameState_Lucu_Garage_XtopodUnitState XtopodState;

	if (Unit.ObjectID == 0)
		return none;

	History = `XCOMHISTORY;

	if (FacilityState == none)
	{
		XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
		FacilityState = GetFacilityComponent(XComHQ);
	}
	if (FacilityState == none)
		return none;

	foreach FacilityState.XtopodUnitStates(XtopodRef)
	{
		XtopodState = XComGameState_Lucu_Garage_XtopodUnitState(History.GetGameStateForObjectID(XtopodRef.ObjectID));
		if (XtopodState != none && XtopodState.UnitRef.ObjectID == Unit.ObjectID)
			return XtopodState;
	}

	return none;
}

static function XComGameState_Lucu_Garage_Facility GetFacilityComponent(XComGameState_HeadquartersXCom XComHQ)
{
	if (XComHQ != none) 
		return XComGameState_Lucu_Garage_Facility(XComHQ.FindComponentObject(class'XComGameState_Lucu_Garage_Facility'));
	return none;
}