class X2Effect_Beags_Escalation_TransientWeaponUpgrade extends X2Effect_Persistent;

var EInventorySlot InventorySlot;
var name UpgradeTemplateName;

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local X2EventManager												EventMgr;
	local Object														ListenerObj;
	local XComGameState_Unit											UnitState;
	local XComGameState_Item											WeaponState;
	local StateObjectReference											WeaponRef;
	local X2WeaponUpgradeTemplate										UpgradeTemplate;
	local XComGameState_Beags_Escalation_Effect_TransientWeaponUpgrade	TransientUpgradeEffectState;

	if (GetEffectComponent(NewEffectState) == none)
	{
		UnitState = XComGameState_Unit(kNewTargetState);
		if (UnitState != none)
		{
			WeaponState = UnitState.GetItemInSlot(InventorySlot);
			if (WeaponState != none)
			{
				UpgradeTemplate = GetWeaponUpgradeTemplate(WeaponState);
				if (UpgradeTemplate != none)
				{
					// Get or add the weapon state to the new game state
					WeaponRef = WeaponState.GetReference();
					WeaponState = XComGameState_Item(NewGameState.GetGameStateForObjectID(WeaponRef.ObjectID));
					if (WeaponState == none)
					{
						WeaponState = XComGameState_Item(NewGameState.CreateStateObject(class'XComGameState_Item', WeaponRef.ObjectID));
						NewGameState.AddStateObject(WeaponState);
					}

					// Apply the upgrade to the weapon
					WeaponState.ApplyWeaponUpgradeTemplate(UpgradeTemplate);

					`LOG("Beags Escalation: Transient Weapon Upgrade " @ string(UpgradeTemplate.DataName) @ " added to unit " @ UnitState.GetFullName() @ " inventory item " @ WeaponState.GetMyTemplateName() @ ".");

					// Create effect component and attach it to GameState_Effect, adding the new state object to the NewGameState container
					TransientUpgradeEffectState = XComGameState_Beags_Escalation_Effect_TransientWeaponUpgrade(NewGameState.CreateStateObject(class'XComGameState_Beags_Escalation_Effect_TransientWeaponUpgrade'));
					TransientUpgradeEffectState.WeaponRef = WeaponState.GetReference();
					TransientUpgradeEffectState.UpgradeIndex = WeaponState.GetMyWeaponUpgradeTemplateNames().Length - 1;
					NewEffectState.AddComponentObject(TransientUpgradeEffectState);
					NewGameState.AddStateObject(TransientUpgradeEffectState);

					EventMgr = `XEVENTMGR;
	
					// The gamestate component should handle the callback
					ListenerObj = TransientUpgradeEffectState;

					// Some missions the effect will be removed (e.g. extraction), some missions the tactical gameplay just stops. We'll GC our gamestate
					// by having the gamestate itself handle this callback
					EventMgr.RegisterForEvent(ListenerObj, 'TacticalGameEnd', TransientUpgradeEffectState.OnTacticalGameEnd, ELD_OnStateSubmitted);

					`LOG("Beags Escalation: Transient Weapon Upgrade passive effect registered for events.");
				}
				else
				{
					`LOG("Beags Escalation: Transient Weapon Upgrade effect weapon upgrade not added (weapon upgrade template not found).");
				}
			}
			else
			{
				`LOG("Beags Escalation: Transient Weapon Upgrade effect weapon upgrade not added (weapon state not found).");
			}
		}
		else
		{
			`LOG("Beags Escalation: Transient Weapon Upgrade effect weapon upgrade not added (unit state not found).");
		}
	}

	super.OnEffectAdded(ApplyEffectParameters, kNewTargetState, NewGameState, NewEffectState);
}

static function XComGameState_Beags_Escalation_Effect_TransientWeaponUpgrade GetEffectComponent(XComGameState_Effect Effect)
{
    if (Effect != none) 
        return XComGameState_Beags_Escalation_Effect_TransientWeaponUpgrade(Effect.FindComponentObject(class'XComGameState_Beags_Escalation_Effect_TransientWeaponUpgrade'));
    return none;
}

simulated function X2WeaponUpgradeTemplate GetWeaponUpgradeTemplate(XComGameState_Item WeaponState)
{
	return X2WeaponUpgradeTemplate(class'X2ItemTemplateManager'.static.GetItemTemplateManager().FindItemTemplate(UpgradeTemplateName));
}