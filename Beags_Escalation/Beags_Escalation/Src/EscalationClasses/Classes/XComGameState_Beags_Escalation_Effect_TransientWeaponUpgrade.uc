// Gamestate object that hangs around and eventually removes a weapon upgrade from an item at the end of a tactical game.
// Using this to create abilities that can only be duplicated by using a totally fake weapon upgrade
class XComGameState_Beags_Escalation_Effect_TransientWeaponUpgrade extends XComGameState_BaseObject;

var StateObjectReference WeaponRef;
var int UpgradeIndex;

function EventListenerReturn OnTacticalGameEnd(Object EventData, Object EventSource, XComGameState GameState, Name EventID)
{
	local XComGameStateHistory		History;
	local X2EventManager			EventManager;
	local Object					ListenerObj;
    local XComGameState				NewGameState;
	local XComGameState_Item		WeaponState;
	
    //`LOG("Beags Escalation: Transient Weapon Upgrade 'TacticalGameEnd' event listener delegate invoked.");
	
	History = `XCOMHISTORY;
	EventManager = `XEVENTMGR;

	// Unregister our callbacks
	ListenerObj = self;
	
	EventManager.UnRegisterFromEvent(ListenerObj, 'TacticalGameEnd');

    NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Transient Weapon Upgrade states cleanup");

	// If a weapon upgrade was added to the item, we need to remove it now
	if (UpgradeIndex > -1)
	{
		if (WeaponRef.ObjectID > 0)
		{
			WeaponState = XComGameState_Item(GameState.GetGameStateForObjectID(WeaponRef.ObjectID));
			if (WeaponState == none)
				WeaponState = XComGameState_Item(History.GetGameStateForObjectID(WeaponRef.ObjectID));
			if (WeaponState != none)
			{
				// Remove the upgrade from the item
				WeaponState.DeleteWeaponUpgradeTemplate(UpgradeIndex);
				NewGameState.AddStateObject(WeaponState);

				`LOG("Beags Escalation: Transient Weapon Upgrade removed from inventory item " @ WeaponState.GetMyTemplateName() @ ".");
			}
			else
			{
				`LOG("Beags Escalation: Transient Weapon Upgrade not removed from inventory item (weapon state not found).");
			}
		}
	}
	else
	{
		`LOG("Beags Escalation: Transient Weapon Upgrade not removed from inventory item (upgrade index not found).");
	}
	
	// Remove this gamestate object from history
	NewGameState.RemoveStateObject(ObjectID);

	if (NewGameState.GetNumGameStateObjects() > 0)
		`GAMERULES.SubmitGameState(NewGameState);
	else
		History.CleanupPendingGameState(NewGameState);

	`LOG("Beags Escalation: Transient Weapon Upgrade passive effect unregistered from events.");
	
	return ELR_NoInterrupt;
}

DefaultProperties
{
	UpgradeIndex = -1
}