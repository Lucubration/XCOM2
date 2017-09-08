class X2Effect_SuspendMissionTimer extends X2Effect;

var bool bResumeMissionTimer;

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	class'XComGameState_UITimer'.static.SuspendTimer(bResumeMissionTimer, NewGameState);
}