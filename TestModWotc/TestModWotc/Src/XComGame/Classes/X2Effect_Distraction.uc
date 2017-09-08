class X2Effect_Distraction extends X2Effect_Persistent;

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
	local Object EffectObj;
	local X2EventManager EventMan;

	EffectObj = EffectGameState;
	EventMan = `XEVENTMGR;
	EventMan.RegisterForEvent(EffectObj, 'KilledByDestructible', EffectGameState.DistractionListener, ELD_OnStateSubmitted);
	EventMan.RegisterForEvent(EffectObj, 'HomingMineDetonated', EffectGameState.DistractionListener, ELD_OnStateSubmitted);
}

DefaultProperties
{
	EffectName = "Distraction"
	DuplicateResponse = eDupe_Ignore
}