class X2Effect_Lucu_Garage_AmmoReserveModify extends X2Effect;

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

		Xtopod.AmmoReserve += FinalAmount;
	}
}
