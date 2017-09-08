class X2Effect_Lucu_Garage_ShattererDamage extends X2Effect_Persistent;

var int MinDistance;
var float DamageFalloff;
var float MaxDamageFalloff;

function int GetAttackingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage)
{
	local XComGameState_Unit Target;
	local XComGameState_Item SourceWeapon;
	local int Tiles;
	local float Mult;
	
	Target = XComGameState_Unit(TargetDamageable);
	SourceWeapon = XComGameState_Item(`XCOMHISTORY.GetGameStateForObjectID(AbilityState.SourceWeapon.ObjectID));

	if (Attacker.ObjectID == AbilityState.OwnerStateObject.ObjectID &&
		Target != none &&
		SourceWeapon != none &&
		SourceWeapon.InventorySlot == eInvSlot_PrimaryWeapon)
	{
		Tiles = Attacker.TileDistanceBetween(Target);
		
		if (Tiles > MinDistance)
		{
			Mult = DamageFalloff * float(Tiles - MinDistance);
			if (Mult > MaxDamageFalloff)
				Mult = MaxDamageFalloff;

			return -1 * Mult * float(CurrentDamage);
		}
	}

	return 0; 
}
