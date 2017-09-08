class X2Effect_KineticPlating extends X2Effect_PersistentStatChange;

var int ShieldPerMiss;

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
	local X2EventManager EventMan;
	local Object EffectObj;

	EventMan = `XEVENTMGR;
	EffectObj = EffectGameState;
	EventMan.RegisterForEvent(EffectObj, 'AbilityActivated', class'XComGameState_Effect'.static.KineticPlatingListener, ELD_OnStateSubmitted);
}

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	super.OnEffectAdded(ApplyEffectParameters, kNewTargetState, NewGameState, NewEffectState);

	XComGameState_Unit(kNewTargetState).SetCurrentStat(eStat_ShieldHP, 0);
}

DefaultProperties
{
	DuplicateResponse = eDupe_Ignore
	EffectName = "ChosenKineticPlating"
}