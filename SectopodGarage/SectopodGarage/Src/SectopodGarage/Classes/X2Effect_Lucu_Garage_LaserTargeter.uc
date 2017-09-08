class X2Effect_Lucu_Garage_LaserTargeter extends X2Effect_Persistent;

var array<int> CritBoostArray;
var int CritBonus;

function GetToHitModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
	local int Tiles;
	local XComGameState_Item SourceWeapon;
	local ShotModifierInfo ShotInfo;

	if (CritBoostArray.Length == 0)
		CritBoostArray = class'X2Effect_LaserSight'.default.CritBoostArray;

	SourceWeapon = AbilityState.GetSourceWeapon();
	if (SourceWeapon != none && SourceWeapon.InventorySlot == eInvSlot_PrimaryWeapon)
	{
		Tiles = Attacker.TileDistanceBetween(Target);
		if (CritBoostArray.Length > 0)
		{
			if (Tiles < CritBoostArray.Length)
				ShotInfo.Value = CritBoostArray[Tiles];
			else  //  if this tile is not configured, use the last configured tile	
				ShotInfo.Value = CritBoostArray[CritBoostArray.Length - 1];

			ShotInfo.Value += CritBonus;

			ShotInfo.ModType = eHit_Crit;
			ShotInfo.Reason = FriendlyName;
			ShotModifiers.AddItem(ShotInfo);
		}
	}
}
