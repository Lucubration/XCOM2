class X2AbilityCost_Lucu_Garage_Power extends X2AbilityCost;

var int Amount;

simulated function name CanAfford(XComGameState_Ability kAbility, XComGameState_Unit ActivatingUnit)
{
	local XComGameStateHistory History;
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_Lucu_Garage_Facility Facility;
	local XComGameState_Lucu_Garage_XtopodUnitState Xtopod;
	
	History = `XCOMHISTORY;

	XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
	Facility = class'Lucu_Garage_Utilities'.static.GetFacilityComponent(XComHQ);
	Xtopod = class'Lucu_Garage_Utilities'.static.GetXtopodComponent(ActivatingUnit, Facility);

	if (Xtopod.PowerCurrent >= Amount)
		return 'AA_Success';

	return 'AA_CannotAfford_Charges';
}

simulated function ApplyCost(XComGameStateContext_Ability AbilityContext, XComGameState_Ability kAbility, XComGameState_BaseObject AffectState, XComGameState_Item AffectWeapon, XComGameState NewGameState)
{
	local XComGameStateHistory History;
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_Lucu_Garage_Facility Facility;
	local XComGameState_Unit Source;
	local XComGameState_Lucu_Garage_XtopodUnitState Xtopod;
	local StateObjectReference XtopodRef;
	
	History = `XCOMHISTORY;

	foreach NewGameState.IterateByClassType(class'XComGameState_HeadquartersXCom', XComHQ)
		break;

	if (XComHQ == none)
		XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
	
	Source = XComGameState_Unit(AffectState);
	if (Source != none)
	{
		Facility = class'Lucu_Garage_Utilities'.static.GetFacilityComponent(XComHQ);
		Xtopod = class'Lucu_Garage_Utilities'.static.GetXtopodComponent(Source, Facility);
		XtopodRef = Xtopod.GetReference();
		Xtopod = XComGameState_Lucu_Garage_XtopodUnitState(NewGameState.GetGameStateForObjectID(XtopodRef.ObjectID));
		if (Xtopod == none)
		{
			Xtopod = XComGameState_Lucu_Garage_XtopodUnitState(NewGameState.CreateStateObject(class'XComGameState_Lucu_Garage_XtopodUnitState', XtopodRef.ObjectID));
			NewGameState.AddStateObject(Xtopod);
		}

		Xtopod.PowerCurrent -= Amount;
		if (Xtopod.PowerCurrent < 0)
			Xtopod.PowerCurrent = 0;
	}
}

DefaultProperties
{
	Amount = 1
}