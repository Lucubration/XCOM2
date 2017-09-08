class X2Effect_Beags_Escalation_Reload extends X2Effect;

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameState_Unit	TargetState;
	local XComGameState_Item	WeaponState, NewWeaponState;

	TargetState = XComGameState_Unit(kNewTargetState);
	if (TargetState != none && TargetState.ObjectID > 0)
	{
		WeaponState = TargetState.GetItemInSlot(eInvSlot_PrimaryWeapon);
		if (WeaponState != none && WeaponState.ObjectID > 0)
		{
			// Find or create the weapon state
			NewWeaponState = XComGameState_Item(NewGameState.GetGameStateForObjectID(WeaponState.ObjectID));
			if (NewWeaponState == none)
			{
				NewWeaponState = XComGameState_Item(NewGameState.CreateStateObject(class'XComGameState_Item', WeaponState.ObjectID));
				NewGameState.AddStateObject(NewWeaponState);
			}

			// Refill the weapon's ammo	
			NewWeaponState.Ammo = NewWeaponState.GetClipSize();
		}
	}

	super.OnEffectAdded(ApplyEffectParameters, kNewTargetState, NewGameState, NewEffectState);
}
