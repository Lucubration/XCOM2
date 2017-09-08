class X2Effect_Lucu_Garage_AmmoModify extends X2Effect;

var float Amount;
var EStatModOp ModOp;
var name ItemName;
var EInventorySlot ItemSlot;
var bool PerArmorTier;

simulated function int GetAmount(XComGameState_Lucu_Garage_XtopodUnitState Xtopod, XComGameState_Item Item)
{
	local XComGameState_Item ChassisUpgrade;
	local float FinalAmount;

	switch (ModOp)
	{
		case MODOP_Multiplication:
			FinalAmount = Amount * float(Item.Ammo);
			break;

		default:
			FinalAmount = Amount;
			break;
	}

	if (PerArmorTier)
	{
		ChassisUpgrade = Xtopod.GetItemInCategory('lucu_garage_chassis');
		if (ChassisUpgrade != none)
			FinalAmount = ChassisUpgrade.GetMyTemplate().Tier * FinalAmount;
	}

	FinalAmount = int(FinalAmount);
	if (FinalAmount < 1)
		FinalAmount = 1;

	return FinalAmount;
}


simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameStateHistory History;
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_Lucu_Garage_Facility Facility;
	local XComGameState_Lucu_Garage_XtopodUnitState Xtopod;
	local StateObjectReference XtopodRef;
	local XComGameState_Unit Target;
	local XComGameState_Item Item;
	local int i, FinalAmount;
	
	History = `XCOMHISTORY;
	
	foreach NewGameState.IterateByClassType(class'XComGameState_HeadquartersXCom', XComHQ)
		break;

	if (XComHQ == none)
		XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
	
	Target = XComGameState_Unit(kNewTargetState);
	if (Target != none)
	{
		for (i = 0; i < Target.InventoryItems.Length; i++)
		{
			Item = XComGameState_Item(NewGameState.GetGameStateForObjectID(Target.InventoryItems[i].ObjectID));
			if (Item != none && ((ItemName != '' && Item.GetMyTemplateName() == ItemName) || Item.InventorySlot == ItemSlot))
				break;

			Item = XComGameState_Item(History.GetGameStateForObjectID(Target.InventoryItems[i].ObjectID));
			if (Item != none && ((ItemName != '' && Item.GetMyTemplateName() == ItemName) || Item.InventorySlot == ItemSlot))
			{
				Item = XComGameState_Item(NewGameState.CreateStateObject(class'XComGameState_Item', Item.ObjectID));
				NewGameState.AddStateObject(Item);
				break;
			}

			Item = none;
		}

		if (Item != none)
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

			FinalAmount = GetAmount(Xtopod, Item);
			Item.Ammo += FinalAmount;
		}
	}
}
