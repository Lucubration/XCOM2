class X2Effect_Beags_Escalation_Staggered extends X2Effect_Persistent;
	
//Occurs once per turn during the Unit Effects phase
simulated function bool OnEffectTicked(const out EffectAppliedData ApplyEffectParameters, XComGameState_Effect kNewEffectState, XComGameState NewGameState, bool FirstApplication)
{
	local XComGameState_Unit kOldTargetUnitState, kNewTargetUnitState;	
	local bool bContinueTicking;
	local int i;
	local name ActionPointType;

	bContinueTicking = super.OnEffectTicked(ApplyEffectParameters, kNewEffectState, NewGameState, FirstApplication);

	kOldTargetUnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(ApplyEffectParameters.TargetStateObjectRef.ObjectID));
	if( kOldTargetUnitState != None )
	{
		ActionPointType = class'X2CharacterTemplateManager'.default.StandardActionPoint;

		//`LOG("Lucubration Infantry Class: Staggered tick started with " @ string(kOldTargetUnitState.ActionPoints.Length) @ " action points on unit " @ kOldTargetUnitState.GetFullName() @ ".");

		kNewTargetUnitState = XComGameState_Unit(NewGameState.CreateStateObject(class'XComGameState_Unit', kOldTargetUnitState.ObjectID));
		for (i = kNewTargetUnitState.ActionPoints.Length - 1; i >= 0; --i)
		{
			if (kNewTargetUnitState.ActionPoints[i] == ActionPointType)
			{
				// Remove action point
				kNewTargetUnitState.ActionPoints.Remove(i, 1);

				//`LOG("Lucubration Infantry Class: Staggered tick removed 1 " @ string(ActionPointType) @ " action point from unit " @ kNewTargetUnitState.GetFullName() @ ".");

				break;
			}
		}

		NewGameState.AddStateObject(kNewTargetUnitState);

		//`LOG("Lucubration Infantry Class: Staggered tick ended with " @ string(kNewTargetUnitState.ActionPoints.Length) @ " action points on unit " @ kNewTargetUnitState.GetFullName() @ ".");
	}
	else
	{
		//`LOG("Lucubration Infantry Class: Staggered tick skipped (no primary target).");
	}

	return bContinueTicking;
}