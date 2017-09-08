class X2Effect_Lucu_Garage_ModifyUnitValue extends X2Effect;

var name UnitName;
var float Delta;
var EUnitValueCleanup CleanupType;

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameState_Unit TargetUnitState;
	local UnitValue Value;
	local float NewValue;

	TargetUnitState = XComGameState_Unit(kNewTargetState);
	if (TargetUnitState.GetUnitValue(UnitName, Value))
		NewValue = Value.fValue + Delta;
	else
		NewValue = Delta;
	TargetUnitState.SetUnitFloatValue(UnitName, NewValue, CleanupType);
}
