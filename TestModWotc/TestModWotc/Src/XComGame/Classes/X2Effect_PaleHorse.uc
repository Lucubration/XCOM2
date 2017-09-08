class X2Effect_PaleHorse extends X2Effect_Persistent;

var int CritBoostPerKill;
var int MaxCritBoost;

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
	local X2EventManager EventMgr;
	local XComGameState_Unit UnitState;
	local Object EffectObj;
	local XComGameState_Effect_PaleHorse EffectState;

	EffectState = XComGameState_Effect_PaleHorse(EffectGameState);
	`assert(EffectState != none);
	EventMgr = `XEVENTMGR;
	EffectObj = EffectGameState;
	UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectGameState.ApplyEffectParameters.SourceStateObjectRef.ObjectID));
	EventMgr.RegisterForEvent(EffectObj, 'OnAPaleHorse', EffectState.TriggerAbilityFlyover, ELD_OnStateSubmitted, , UnitState);
	EventMgr.RegisterForEvent(EffectObj, 'KillMail', EffectState.KillMailListener, ELD_OnStateSubmitted, , UnitState);
}

function GetToHitModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
	local ShotModifierInfo ModInfo;
	local XComGameState_Effect_PaleHorse PaleHorseEffectState;
		
	PaleHorseEffectState = XComGameState_Effect_PaleHorse(EffectState);

	if (AbilityState.SourceWeapon == PaleHorseEffectState.ApplyEffectParameters.ItemStateObjectRef)
	{
		ModInfo.ModType = eHit_Crit;
		ModInfo.Value = PaleHorseEffectState.CurrentCritBoost;
		ModInfo.Reason = FriendlyName;
		ShotModifiers.AddItem(ModInfo);
	}
}

DefaultProperties
{
	EffectName = "PaleHorse"
	DuplicateResponse = eDupe_Ignore
	GameStateEffectClass = class'XComGameState_Effect_PaleHorse'
}