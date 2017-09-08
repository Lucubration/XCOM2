class PA_RegenerateProperty extends X2Condition_UnitProperty;

function name MeetsCondition(XComGameState_BaseObject kTarget)
{
	local name retVal;
	retVal = super.MeetsCondition(kTarget);
	`log ("davea debug pa_regen_prop enter " @ retVal);
	return retVal;
}
