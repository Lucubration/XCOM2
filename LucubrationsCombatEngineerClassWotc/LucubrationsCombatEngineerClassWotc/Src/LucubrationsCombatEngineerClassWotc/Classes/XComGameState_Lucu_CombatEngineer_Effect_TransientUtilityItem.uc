// Gamestate object that hangs around and eventually removes an item from a soldier's inventory at the end of a tactical game.
// Using this to create totally fake items for abilities like BattleScanner
class XComGameState_Lucu_CombatEngineer_Effect_TransientUtilityItem extends XComGameState_BaseObject;

var StateObjectReference UnitRef, ItemRef, AbilityRef, ItemSetAbilityRef;

function EventListenerReturn OnTacticalGameEnd(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
	local XComGameStateHistory		History;
	local X2EventManager			EventManager;
	local Object					ListenerObj;
    local XComGameState				NewGameState;
	local XComGameState_Item		ItemState;
	local XComGameState_Unit		UnitState;
	local XComGameState_Ability		AbilityState;
	
    //`LOG("Lucubration Combat Engineer Class: Transient Item 'TacticalGameEnd' event listener delegate invoked.");
	
	History = `XCOMHISTORY;
	EventManager = `XEVENTMGR;

	// Unregister our callbacks
	ListenerObj = self;
	
	EventManager.UnRegisterFromEvent(ListenerObj, 'TacticalGameEnd');

    NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Transient Item states cleanup");

	// If an item was created, we need to destroy it now
	if (ItemRef.ObjectID > 0)
	{
		ItemState = XComGameState_Item(GameState.GetGameStateForObjectID(ItemRef.ObjectID));
		if (ItemState == none)
			ItemState = XComGameState_Item(History.GetGameStateForObjectID(ItemRef.ObjectID));
		if (ItemState != none)
		{
			UnitState = XComGameState_Unit(GameState.GetGameStateForObjectID(UnitRef.ObjectID));
			if (UnitState == none)
				UnitState = XComGameState_Unit(History.GetGameStateForObjectID(UnitRef.ObjectID));
			if (UnitState != none)
			{
				// Remove the item from the unit's inventory
				UnitState.RemoveItemFromInventory(ItemState);

				// Update the ability to remove the source weapon reference. This is probably not necessary because abilities are transient.
				AbilityState = XComGameState_Ability(NewGameState.GetGameStateForObjectID(ItemSetAbilityRef.ObjectID));
				if (AbilityState == none)
					AbilityState = XComGameState_Ability(History.GetGameStateForObjectID(ItemSetAbilityRef.ObjectID));
				if (AbilityState != none)
				{
					if (AbilityState.SourceWeapon.ObjectID == ItemRef.ObjectID)
						AbilityState.SourceWeapon.ObjectID = 0;
					if (AbilityState.SourceAmmo.ObjectID == ItemRef.ObjectID)
						AbilityState.SourceAmmo.ObjectID = 0;

					`LOG("Lucubration Combat Engineer Class: Transient Item " @ ItemState.GetMyTemplateName() @ " removed as source weapon for unit " @ UnitState.GetFullName() @ " ability " @ AbilityState.GetMyTemplateName() @ ".");
				}
				else
				{
					`LOG("Lucubration Combat Engineer Class: Transient Item " @ ItemState.GetMyTemplateName() @ " not removed as source weapon for unit " @ UnitState.GetFullName() @ " ability " @ AbilityState.GetMyTemplateName() @ " (ability state not found).");
				}

				// If an ability was created, we should destroy it now. This is probably not necessary because abilities are transient.
				if (AbilityRef.ObjectID > 0)
				{
					AbilityState = XComGameState_Ability(NewGameState.GetGameStateForObjectID(AbilityRef.ObjectID));
					if (AbilityState == none)
						AbilityState = XComGameState_Ability(History.GetGameStateForObjectID(AbilityRef.ObjectID));
					if (AbilityState != none)
					{
						AbilityState.SourceWeapon.ObjectID = 0;
						AbilityState.SourceAmmo.ObjectID = 0;
						
						// Remove the transient item's ability's gamestate object from history
						NewGameState.RemoveStateObject(AbilityRef.ObjectID);

						// I'm not removing the ability from the unit's ability list, but I don't think it's a problem only because the unit's
						// ability list is emptied at the end of tactical anyways, so there shouldn't be a reference to it lying around

						`LOG("Lucubration Combat Engineer Class: Transient Item " @ ItemState.GetMyTemplateName() @ " ability " @ AbilityState.GetMyTemplateName() @ " state removed from history.");
					}
					else
					{
						`LOG("Lucubration Combat Engineer Class: Transient Item " @ ItemState.GetMyTemplateName() @ " ability " @ AbilityState.GetMyTemplateName() @ " state not removed from history (item state not found).");
					}
				}

				`LOG("Lucubration Combat Engineer Class: Transient Item " @ ItemState.GetMyTemplateName() @ " removed from unit " @ UnitState.GetFullName() @ " inventory.");
			}
			else
			{
				`LOG("Lucubration Combat Engineer Class: Transient Item " @ ItemState.GetMyTemplateName() @ " not removed from unit inventory (unit state not found).");
			}
	
			// Remove the transient item's gamestate object from history
			NewGameState.RemoveStateObject(ItemRef.ObjectID);

			`LOG("Lucubration Combat Engineer Class: Transient " @ ItemState.GetMyTemplateName() @ " state removed from history.");
		}
		else
		{
			`LOG("Lucubration Combat Engineer Class: Transient Item not removed from unit inventory (item state not found).");
		}
	}
	
	// Remove this gamestate object from history
	NewGameState.RemoveStateObject(ObjectID);

	`GAMERULES.SubmitGameState(NewGameState);

	`LOG("Lucubration Combat Engineer Class: Transient Item passive effect unregistered from events.");
	
	return ELR_NoInterrupt;
}
