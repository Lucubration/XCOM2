class X2Effect_HoloTarget extends X2Effect_Persistent;

var int HitMod;

function GetToHitAsTargetModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
	local ShotModifierInfo ModInfo;

	ModInfo.ModType = eHit_Success;
	ModInfo.Reason = FriendlyName;
	ModInfo.Value = HitMod;

	ShotModifiers.AddItem(ModInfo);
}

DefaultProperties
{
	EffectName = "HoloTarget"
	DuplicateResponse = eDupe_Refresh;
	bApplyOnHit = true;
	bApplyOnMiss = true;
}