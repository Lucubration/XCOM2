// Basically a cursor, but it's going to use the weapon radius rather than the weapon range
class X2AbilityTarget_Beags_Escalation_RadiusCursor extends X2AbilityTargetStyle;

var bool    bRestrictToWeaponRadius;
var int FixedAbilityRange;

simulated function bool IsFreeAiming(const XComGameState_Ability Ability)
{
	return true;
}

simulated function float GetCursorRangeMeters(XComGameState_Ability AbilityState)
{
	local XComGameState_Item SourceWeapon;
	local int RangeInTiles;
	local float RangeInMeters;

	if (bRestrictToWeaponRadius)
	{
		SourceWeapon = AbilityState.GetSourceWeapon();
		if (SourceWeapon != none)
		{
			RangeInTiles = SourceWeapon.GetItemRadius(AbilityState);

			if (RangeInTiles == 0)
			{
				// This is melee range
				RangeInMeters = class'XComWorldData'.const.WORLD_Melee_Range_Meters;
			}
			else
			{
				RangeInMeters = `UNITSTOMETERS(`TILESTOUNITS(RangeInTiles));
			}

			return RangeInMeters;
		}
	}
	return FixedAbilityRange;
}

DefaultProperties
{
	FixedAbilityRange = -1
}