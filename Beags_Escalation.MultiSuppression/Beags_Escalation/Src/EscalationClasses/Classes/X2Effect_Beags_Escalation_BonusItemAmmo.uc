class X2Effect_Beags_Escalation_BonusItemAmmo extends X2Effect_Persistent;

var int AmmoCount;
var array<name> ItemTemplateNames;

simulated function bool OnEffectTicked(const out EffectAppliedData ApplyEffectParameters, XComGameState_Effect kNewEffectState, XComGameState NewGameState, bool FirstApplication)
{
	local XComGameState_Unit UnitState;
	local array<XComGameState_Item> ItemStates;
	local XComGameState_Item ItemState, NewItemState;
			
	// Check all of the unit's inventory items
	UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(ApplyEffectParameters.TargetStateObjectRef.ObjectID));
	ItemStates = UnitState.GetAllInventoryItems(NewGameState);

	`LOG("Beags Escalation: Bonus Item Ammo effect checking " @ string(ItemStates.Length) @ " items for unit " @ UnitState.GetFullName() @ ".");

	foreach ItemStates(ItemState)
	{
		// If the item's template name was specified, add ammo
		if (ItemTemplateNames.Find(ItemState.GetMyTemplateName()) != INDEX_NONE)
		{
			NewItemState = XComGameState_Item(NewGameState.CreateStateObject(class'XComGameState_Item', ItemState.ObjectID));
			NewItemState.Ammo = ItemState.Ammo + AmmoCount;
			NewGameState.AddStateObject(NewItemState);
			
			`LOG("Beags Escalation: Bonus Item Ammo given to item " @ ItemState.GetMyTemplateName() @ " (" @ string(ItemState.Ammo) @ " + " @ string(AmmoCount) @ ").");
		}
		else
		{
			`LOG("Beags Escalation: Bonus Item Ammo not added to item " @ ItemState.GetMyTemplateName() @ ".");
		}
	}
	
	return false;
}
