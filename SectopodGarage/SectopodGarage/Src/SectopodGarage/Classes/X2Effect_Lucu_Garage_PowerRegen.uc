class X2Effect_Lucu_Garage_PowerRegen extends X2Effect_Persistent;

var int Amount;

simulated function bool OnEffectTicked(const out EffectAppliedData ApplyEffectParameters, XComGameState_Effect kNewEffectState, XComGameState NewGameState, bool FirstApplication)
{
	local XComGameStateHistory History;
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_Lucu_Garage_Facility Facility;
	local XComGameState_Lucu_Garage_XtopodUnitState Xtopod;
	local XComGameState_Unit Target;
	local StateObjectReference XtopodRef;
	local bool bContinueTicking;

	History = `XCOMHISTORY;

	bContinueTicking = super.OnEffectTicked(ApplyEffectParameters, kNewEffectState, NewGameState, FirstApplication);
	
	foreach NewGameState.IterateByClassType(class'XComGameState_HeadquartersXCom', XComHQ)
		break;

	if (XComHQ == none)
		XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
	
	Target = XComGameState_Unit(NewGameState.GetGameStateForObjectID(ApplyEffectParameters.TargetStateObjectRef.ObjectID));
	if (Target == none)
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

		Xtopod.PowerCurrent += Amount;
		if (Xtopod.PowerCurrent > Xtopod.PowerMax)
			Xtopod.PowerCurrent = Xtopod.PowerMax;
	}

	return bContinueTicking;
}
