class X2Effect_ExplosiveActionRecovery extends X2Effect_Persistent;
	
var int RecoveryActionPoints;

simulated function OnEffectRemoved(const out EffectAppliedData ApplyEffectParameters, XComGameState NewGameState, bool bCleansed, XComGameState_Effect RemovedEffectState)
{
	local XComGameState_Unit kOldTargetUnitState, kNewTargetUnitState;	
	local int i;
	local int ActionPointsRemoved;
	local name ActionPointType;

	super.OnEffectRemoved(ApplyEffectParameters, NewGameState, bCleansed, RemovedEffectState);
	
	kOldTargetUnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(ApplyEffectParameters.TargetStateObjectRef.ObjectID));
	if( kOldTargetUnitState != None )
	{
		ActionPointType = class'X2CharacterTemplateManager'.default.StandardActionPoint;

		//`LOG("Lucubration Infantry Class: Explosive Action Recovery removal started with " @ string(UnitState.ActionPoints.Length) @ " action points on unit " @ UnitState.GetFullName() @ ".");

		ActionPointsRemoved = 0;

		kNewTargetUnitState = XComGameState_Unit(NewGameState.CreateStateObject(class'XComGameState_Unit', kOldTargetUnitState.ObjectID));
		for (i = kNewTargetUnitState.ActionPoints.Length - 1; i >= 0 && ActionPointsRemoved < RecoveryActionPoints; --i)
		{
			if (kNewTargetUnitState.ActionPoints[i] == ActionPointType)
			{
				// Remove recovery action point
				kNewTargetUnitState.ActionPoints.Remove(i, RecoveryActionPoints);
				ActionPointsRemoved++;

				//`LOG("Lucubration Infantry Class: Explosive Action Recovery removed " @ string(RecoveryActionPoints) @ string(ActionPointType) @ " action points from unit " @ UnitState.GetFullName() @ ".");
			}
		}

		NewGameState.AddStateObject(kNewTargetUnitState);

		//`LOG("Lucubration Infantry Class: Explosive Action Recovery removal ended with " @ string(UnitState.ActionPoints.Length) @ " action points on unit " @ UnitState.GetFullName() @ ".");
	}
}

simulated function AddX2ActionsForVisualization_Removed(XComGameState VisualizeGameState, out VisualizationTrack BuildTrack, const name EffectApplyResult, XComGameState_Effect RemovedEffect)
{
	local X2Action_PlaySoundAndFlyOver SoundAndFlyOver;
	
	SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTrack(BuildTrack, VisualizeGameState.GetContext()));
	SoundAndFlyOver.SetSoundAndFlyOverParameters(None, FriendlyName, '', eColor_Bad);
}