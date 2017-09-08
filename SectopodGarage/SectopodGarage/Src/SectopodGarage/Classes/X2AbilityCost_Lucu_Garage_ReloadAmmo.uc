class X2AbilityCost_Lucu_Garage_ReloadAmmo extends X2AbilityCost;

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

	if (Xtopod.AmmoReserve > 0)
		return 'AA_Success';
		
	return 'AA_CannotAfford_AmmoCost';
}

simulated function ApplyCost(XComGameStateContext_Ability AbilityContext, XComGameState_Ability kAbility, XComGameState_BaseObject AffectState, XComGameState_Item AffectWeapon, XComGameState NewGameState)
{
	local XComGameStateHistory History;
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_Lucu_Garage_Facility Facility;
	local XComGameState_Lucu_Garage_XtopodUnitState Xtopod;
	local StateObjectReference XtopodRef;
	local int Cost;
	
	Cost = CalculateCost(kAbility, AffectWeapon);

	if (Cost > 0)
	{
		History = `XCOMHISTORY;

		XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
		Facility = class'Lucu_Garage_Utilities'.static.GetFacilityComponent(XComHQ);
		Xtopod = class'Lucu_Garage_Utilities'.static.GetXtopodComponent(XComGameState_Unit(AffectState), Facility);
		XtopodRef = Xtopod.GetReference();
		Xtopod = XComGameState_Lucu_Garage_XtopodUnitState(NewGameState.GetGameStateForObjectID(XtopodRef.ObjectID));
		if (Xtopod == none)
		{
			Xtopod = XComGameState_Lucu_Garage_XtopodUnitState(NewGameState.CreateStateObject(class'XComGameState_Lucu_Garage_XtopodUnitState', XtopodRef.ObjectID));
			NewGameState.AddStateObject(Xtopod);
		}
		Xtopod.AmmoReserve -= Cost;
		kAbility.iAmmoConsumed = Cost;
	}
}

simulated function int CalculateCost(XComGameState_Ability AbilityState, XComGameState_Item ItemState)
{
	local XComGameStateHistory History;
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_Lucu_Garage_Facility Facility;
	local XComGameState_Lucu_Garage_XtopodUnitState Xtopod;
	local XComGameState_Unit UnitState;
	local int Cost;

	History = `XCOMHISTORY;
	UnitState = XComGameState_Unit(History.GetGameStateForObjectID(AbilityState.OwnerStateObject.ObjectID));
	
	if (bFreeCost || ItemState.HasInfiniteAmmo() || (`CHEATMGR != none && `CHEATMGR.bUnlimitedAmmo && UnitState.GetTeam() == eTeam_XCom))	
		return 0;

	XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
	Facility = class'Lucu_Garage_Utilities'.static.GetFacilityComponent(XComHQ);
	Xtopod = class'Lucu_Garage_Utilities'.static.GetXtopodComponent(UnitState, Facility);

	Cost = ItemState.GetClipSize() - ItemState.Ammo;
	if (Cost > Xtopod.AmmoReserve)
		Cost = Xtopod.AmmoReserve;

	return Cost;
}