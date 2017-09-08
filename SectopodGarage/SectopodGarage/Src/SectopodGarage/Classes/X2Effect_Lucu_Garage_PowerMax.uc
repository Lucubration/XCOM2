class X2Effect_Lucu_Garage_PowerMax extends X2Effect_Persistent;

var int Amount;
var bool PerArmorTier;

simulated function int GetAmount(XComGameState_Lucu_Garage_XtopodUnitState Xtopod)
{
	local XComGameState_Item ChassisUpgrade;

	if (!PerArmorTier)
		return Amount;

	ChassisUpgrade = Xtopod.GetItemInCategory('lucu_garage_chassis');
	if (ChassisUpgrade == none)
		return Amount;

	return ChassisUpgrade.GetMyTemplate().Tier * Amount;
}

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameStateHistory History;
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_Lucu_Garage_Facility Facility;
	local XComGameState_Lucu_Garage_XtopodUnitState Xtopod;
	local XComGameState_Unit Target;
	local StateObjectReference XtopodRef;
	local int FinalAmount;

	History = `XCOMHISTORY;

	super.OnEffectAdded(ApplyEffectParameters, kNewTargetState, NewGameState, NewEffectState);

	foreach NewGameState.IterateByClassType(class'XComGameState_HeadquartersXCom', XComHQ)
		break;

	if (XComHQ == none)
		XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));

	Target = XComGameState_Unit(kNewTargetState);
	if (Target != none)
	{
		Facility = class'Lucu_Garage_Utilities'.static.GetFacilityComponent(XComHQ);
		Xtopod = class'Lucu_Garage_Utilities'.static.GetXtopodComponent(Target, Facility);
		XtopodRef = Xtopod.GetReference();
		Xtopod = XComGameState_Lucu_Garage_XtopodUnitState(NewGameState.GetGameStateForObjectID(XtopodRef.ObjectID));
		if (Xtopod == none)
		{
			Xtopod = XComGameState_Lucu_Garage_XtopodUnitState(NewGameState.CreateStateObject(class'XComGameState_Lucu_Garage_XtopodUnitState', XtopodRef.ObjectID));
			NewGameState.AddStateObject(Xtopod);
		}

		FinalAmount = GetAmount(Xtopod);

		Xtopod.PowerMax += FinalAmount;
		Xtopod.PowerCurrent += FinalAmount;
	}
}

//Occurs once per turn during the Unit Effects phase
simulated function OnEffectRemoved(const out EffectAppliedData ApplyEffectParameters, XComGameState NewGameState, bool bCleansed, XComGameState_Effect RemovedEffectState)
{
	local XComGameStateHistory History;
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_Lucu_Garage_Facility Facility;
	local XComGameState_Lucu_Garage_XtopodUnitState Xtopod;
	local XComGameState_Unit Target;
	local StateObjectReference XtopodRef;
	local int FinalAmount;
	
	History = `XCOMHISTORY;

	super.OnEffectRemoved(ApplyEffectParameters, NewGameState, bCleansed, RemovedEffectState);
	
	foreach NewGameState.IterateByClassType(class'XComGameState_HeadquartersXCom', XComHQ)
		break;

	if (XComHQ == none)
		XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));

	Target = XComGameState_Unit(History.GetGameStateForObjectID(ApplyEffectParameters.TargetStateObjectRef.ObjectID));
	if (Target != none)
	{
		Facility = class'Lucu_Garage_Utilities'.static.GetFacilityComponent(XComHQ);
		Xtopod = class'Lucu_Garage_Utilities'.static.GetXtopodComponent(Target, Facility);
		XtopodRef = Xtopod.GetReference();
		Xtopod = XComGameState_Lucu_Garage_XtopodUnitState(NewGameState.GetGameStateForObjectID(XtopodRef.ObjectID));
		if (Xtopod == none)
		{
			Xtopod = XComGameState_Lucu_Garage_XtopodUnitState(NewGameState.CreateStateObject(class'XComGameState_Lucu_Garage_XtopodUnitState', XtopodRef.ObjectID));
			NewGameState.AddStateObject(Xtopod);
		}

		FinalAmount = GetAmount(Xtopod);

		Xtopod.PowerMax -= FinalAmount;
		if (Xtopod.PowerCurrent > Xtopod.PowerMax)
			Xtopod.PowerCurrent = Xtopod.PowerMax;
	}
}

function UnitEndedTacticalPlay(XComGameState_Effect EffectState, XComGameState_Unit UnitState)
{
	local XComGameStateHistory History;
	local XComGameState NewGameState;
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_Lucu_Garage_Facility Facility;
	local XComGameState_Lucu_Garage_XtopodUnitState Xtopod;
	local StateObjectReference XtopodRef;
	local int FinalAmount;

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Remove Max Power Effect");
	
	History = `XCOMHISTORY;
	
	foreach NewGameState.IterateByClassType(class'XComGameState_HeadquartersXCom', XComHQ)
		break;

	if (XComHQ == none)
		XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));

	Facility = class'Lucu_Garage_Utilities'.static.GetFacilityComponent(XComHQ);
	Xtopod = class'Lucu_Garage_Utilities'.static.GetXtopodComponent(UnitState, Facility);
	XtopodRef = Xtopod.GetReference();
	Xtopod = XComGameState_Lucu_Garage_XtopodUnitState(NewGameState.GetGameStateForObjectID(XtopodRef.ObjectID));
	if (Xtopod == none)
	{
		Xtopod = XComGameState_Lucu_Garage_XtopodUnitState(NewGameState.CreateStateObject(class'XComGameState_Lucu_Garage_XtopodUnitState', XtopodRef.ObjectID));
		NewGameState.AddStateObject(Xtopod);
	}

	FinalAmount = GetAmount(Xtopod);

	Xtopod.PowerMax -= FinalAmount;
	if (Xtopod.PowerCurrent > Xtopod.PowerMax)
		Xtopod.PowerCurrent = Xtopod.PowerMax;
}
