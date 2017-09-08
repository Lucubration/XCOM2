// I don't yet know if the facility will be its own facility in the Xcom HQ or whatnot, but for our purposes any Garage-specific
// equipment or other things that would normally be stored in the HQ
class XComGameState_Lucu_Garage_Facility extends XComGameState_BaseObject;

var() array<StateObjectReference>   Inventory;
var() array<Name>					EverAcquiredInventoryTypes; // list (and counts) of all inventory ever acquired by the facility
var() array<int>					EverAcquiredInventoryCounts; // list (and counts) of all inventory ever acquired by the facility

// I wanted to keep these as component objects of the unit states themselves, but Firaxis hasn't given us a hook for dismissed
// units yet, and the LW team has bogarted the Dismiss soldier button, so really I can't do that an reliably clean up the state
// if the Xtopod is dismissed. Instead, I'm just going to store an array of object references here and retrieve them as necessary
var() array<StateObjectReference>	XtopodUnitStates;

function Initialize()
{
	Inventory.Length = 0;
	XtopodUnitStates.Length = 0;
	EverAcquiredInventoryTypes.Length = 0;
	EverAcquiredInventoryCounts.Length = 0;
}

function AddItemToInventory(XComGameState_Item ItemState)
{
	local Name ItemTemplateName;
	local int EverAcquireInventoryIndex;

	ItemTemplateName = ItemState.GetMyTemplateName();

	EverAcquireInventoryIndex = EverAcquiredInventoryTypes.Find(ItemTemplateName);
	if (EverAcquireInventoryIndex == INDEX_NONE)
	{
		EverAcquiredInventoryTypes.AddItem(ItemTemplateName);
		EverAcquiredInventoryCounts.AddItem(ItemState.Quantity);
	}
	else
	{
		EverAcquiredInventoryCounts[EverAcquireInventoryIndex] += ItemState.Quantity;
	}

	Inventory.AddItem(ItemState.GetReference());
}

function bool PutItemInInventory(XComGameState AddToGameState, XComGameState_Item ItemState)
{
	local bool FacilityModified;
	local XComGameState_Item InventoryItemState, NewInventoryItemState;
	local X2ItemTemplate ItemTemplate;

	ItemTemplate = ItemState.GetMyTemplate();

	if (ItemState.HasBeenModified() || ItemTemplate.bAlwaysUnique)
	{
		FacilityModified = true;

		AddItemToInventory(ItemState);
	}
	else
	{
		if (!ItemState.IsStartingItem() && !ItemState.GetMyTemplate().bInfiniteItem)
		{
			if (HasUnModifiedItem(AddToGameState, ItemTemplate, InventoryItemState, ItemState))
			{
				FacilityModified = false;
				
				if (InventoryItemState.ObjectID != ItemState.ObjectID)
				{
					NewInventoryItemState = XComGameState_Item(AddToGameState.CreateStateObject(class'XComGameState_Item', InventoryItemState.ObjectID));
					NewInventoryItemState.Quantity += ItemState.Quantity;
					AddToGameState.AddStateObject(NewInventoryItemState);
					AddToGameState.RemoveStateObject(ItemState.ObjectID);
				}
			}
			else
			{
				FacilityModified = true;

				AddItemToInventory(ItemState);
			}
		}
		else
		{
			FacilityModified = false;
			AddToGameState.RemoveStateObject(ItemState.ObjectID);
		}
	}

	if (ItemTemplate.OnAcquiredFn != None)
	{
		FacilityModified = ItemTemplate.OnAcquiredFn(AddToGameState) || FacilityModified;
	}

	// this item awards other items when acquired
	if (ItemTemplate.ResourceTemplateName != '' && ItemTemplate.ResourceQuantity > 0)
	{
		ItemTemplate = class'X2ItemTemplateManager'.static.GetItemTemplateManager().FindItemTemplate(ItemTemplate.ResourceTemplateName);
		ItemState = ItemTemplate.CreateInstanceFromTemplate(AddToGameState);
		AddToGameState.AddStateObject(ItemState);
		ItemState.Quantity = ItemTemplate.ResourceQuantity;

		if (ItemState != none)
		{
			FacilityModified = PutItemInInventory(AddToGameState, ItemState) || FacilityModified;
		}
	}

	return FacilityModified;
}

function bool HasUnModifiedItem(XComGameState AddToGameState, X2ItemTemplate ItemTemplate, out XComGameState_Item ItemState, optional XComGameState_Item CombatSimTest)
{
	local int idx;

	for (idx = 0; idx < Inventory.Length; idx++)
	{
		ItemState = XComGameState_Item(`XCOMHISTORY.GetGameStateForObjectID(Inventory[idx].ObjectID));

		if (ItemState == none)
		{
			ItemState = XComGameState_Item(AddToGameState.GetGameStateForObjectID(Inventory[idx].ObjectID));
		}

		if (ItemState != none)
		{
			if (ItemState.GetMyTemplateName() == ItemTemplate.DataName && ItemState.Quantity > 0 && !ItemState.HasBeenModified())
			{
				return true;
			}
		}
	}
	
	return false;
}

function bool HasItem(X2ItemTemplate ItemTemplate, optional int Quantity = 1)
{
	local XComGameState_Item ItemState;
	local int idx;

	for (idx = 0; idx < Inventory.Length; idx++)
	{
		ItemState = XComGameState_Item(`XCOMHISTORY.GetGameStateForObjectID(Inventory[idx].ObjectID));

		if (ItemState != none)
		{
			if (ItemState.GetMyTemplateName() == ItemTemplate.DataName && ItemState.Quantity >= Quantity)
			{
				return true;
			}
		}
	}

	return false;
}

function XComGameState_Item GetItemByName(name ItemTemplateName)
{
	local XComGameStateHistory History;
	local XComGameState_Item InventoryItemState;
	local int i;

	History = `XCOMHISTORY;

	for (i = 0; i < Inventory.Length; i++)
	{
		InventoryItemState = XComGameState_Item(History.GetGameStateForObjectID(Inventory[i].ObjectId));

		if (InventoryItemState != none && InventoryItemState.GetMyTemplateName() == ItemTemplateName)
		{
			return InventoryItemState;
		}
	}

	return none;
}

function int GetNumItemInInventory(name ItemTemplateName)
{
	local XComGameState_Item ItemState;

	ItemState = GetItemByName(ItemTemplateName);
	if (ItemState != none)
	{
		return ItemState.Quantity;
	}

	return 0;
}
function bool GetItemFromInventory(XComGameState AddToGameState, StateObjectReference ItemRef, out XComGameState_Item ItemState)
{
	local XComGameState_Item InventoryItemState, NewInventoryItemState;
	local bool FacilityModified;

	InventoryItemState = XComGameState_Item(`XCOMHISTORY.GetGameStateForObjectID(ItemRef.ObjectID));

	if(InventoryItemState != none)
	{
		if((!InventoryItemState.IsStartingItem() && !InventoryItemState.GetMyTemplate().bInfiniteItem) || InventoryItemState.HasBeenModified())
		{
			if(InventoryItemState.Quantity > 1)
			{
				FacilityModified = false;
				NewInventoryItemState = XComGameState_Item(AddToGameState.CreateStateObject(class'XComGameState_Item', InventoryItemState.ObjectID));
				NewInventoryItemState.Quantity--;
				AddToGameState.AddStateObject(NewInventoryItemState);
				ItemState = XComGameState_Item(AddToGameState.CreateStateObject(class'XComGameState_Item'));
				ItemState.OnCreation(InventoryItemState.GetMyTemplate());
				ItemState.StatBoosts = NewInventoryItemState.StatBoosts; // Make sure the stat boosts are the same. Used for PCS.
				AddToGameState.AddStateObject(ItemState);
			}
			else
			{
				FacilityModified = true;
				Inventory.RemoveItem(ItemRef);
				ItemState = InventoryItemState;
			}
		}
		else
		{
			FacilityModified = false;
			ItemState = XComGameState_Item(AddToGameState.CreateStateObject(class'XComGameState_Item'));
			ItemState.OnCreation(InventoryItemState.GetMyTemplate());
			AddToGameState.AddStateObject(ItemState);
		}
	}

	return FacilityModified;
}
function bool RemoveItemFromInventory(XComGameState AddToGameState, StateObjectReference ItemRef, int Quantity)
{
	local XComGameState_Item InventoryItemState, NewInventoryItemState;
	local bool FacilityModified;

	InventoryItemState = XComGameState_Item(`XCOMHISTORY.GetGameStateForObjectID(ItemRef.ObjectID));

	if (InventoryItemState != none)
	{
		if (!InventoryItemState.IsStartingItem() && !InventoryItemState.GetMyTemplate().bInfiniteItem)
		{
			if (InventoryItemState.Quantity > Quantity)
			{
				FacilityModified = false;
				NewInventoryItemState = XComGameState_Item(AddToGameState.CreateStateObject(class'XComGameState_Item', InventoryItemState.ObjectID));
				NewInventoryItemState.Quantity -= Quantity;
				AddToGameState.AddStateObject(NewInventoryItemState);
			}
			else
			{
				FacilityModified = true;
				Inventory.RemoveItem(ItemRef);
			}
		}
		else
		{
			return false;
		}
	}

	return FacilityModified;
}