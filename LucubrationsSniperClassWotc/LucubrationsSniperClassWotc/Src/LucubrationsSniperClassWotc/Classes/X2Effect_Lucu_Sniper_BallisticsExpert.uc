class X2Effect_Lucu_Sniper_BallisticsExpert extends X2Effect_Persistent;

var float HitModRoot;

function GetToHitModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
	local ShotModifierInfo AccuracyInfo;
	local int SquadsightPenalty;

	SquadsightPenalty = GetActualSquadsightPenalty(Attacker, Target);

	AccuracyInfo.ModType = eHit_Success;
	AccuracyInfo.Value = GetDesiredSquadsightPenalty(SquadsightPenalty) - SquadsightPenalty;
	AccuracyInfo.Reason = FriendlyName;
	ShotModifiers.AddItem(AccuracyInfo);
}

function int GetActualSquadsightPenalty(XComGameState_Unit Attacker, XComGameState_Unit Target)
{
	local int Tiles;

	Tiles = Attacker.TileDistanceBetween(Target);
	// Remove number of tiles within visible range (which is in meters, so convert to units, and divide that by tile size)
	Tiles -= Attacker.GetVisibilityRadius() * class'XComWorldData'.const.WORLD_METERS_TO_UNITS_MULTIPLIER / class'XComWorldData'.const.WORLD_StepSize;
	if (Tiles > 0)
		return class'X2AbilityToHitCalc_StandardAim'.default.SQUADSIGHT_DISTANCE_MOD * Tiles;

	return 0;
}

function int GetDesiredSquadsightPenalty(int SquadsightPenalty)
{
	local float Product;
	
	Product = (-1 * SquadsightPenalty) ** HitModRoot;

	return -1 * Product;
}
