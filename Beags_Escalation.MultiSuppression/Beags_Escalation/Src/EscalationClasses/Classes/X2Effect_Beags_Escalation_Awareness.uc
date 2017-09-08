// This is the Awareness target effect that plays an effect animation for the human player to see
class X2Effect_Beags_Escalation_Awareness extends X2Effect_Persistent
	config(Beags_Escalation_Ability);

var config string AwarenessEffectName;

var name FXLocationXName, FXLocationYName, FXLocationZName;

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
	local X2EventManager EventMgr;
	local XComGameState_Unit UnitState;
	local Object EffectObj;

	EventMgr = `XEVENTMGR;
	EffectObj = EffectGameState;
	UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectGameState.ApplyEffectParameters.TargetStateObjectRef.ObjectID));
	// This generic enough to remove the effect when the target object moves
	EventMgr.RegisterForEvent(EffectObj, 'ObjectMoved', EffectGameState.GenerateCover_ObjectMoved, ELD_OnStateSubmitted, , UnitState);
}

private function DoTargetFX(XComGameState_Effect TargetEffect, out VisualizationTrack BuildTrack, XComGameStateContext Context, name EffectApplyResult, bool bStopEffect)
{
	local XComGameState_Unit PrimaryTarget;
	local X2Action_PlayEffect PlayEffectAction;
	local UnitValue TargetUnitValue;
	local vector FXLocation;

	PrimaryTarget = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(TargetEffect.ApplyEffectParameters.AbilityInputContext.PrimaryTarget.ObjectID));
	
	if (PrimaryTarget != none)
	{
		// Play the effect animation for the detected unit
		PlayEffectAction = X2Action_PlayEffect(class'X2Action_PlayEffect'.static.AddToVisualizationTrack(BuildTrack, Context));

		if (bStopEffect)
		{
			// Get the FX location
			PrimaryTarget.GetUnitValue(default.FXLocationXName, TargetUnitValue);
			FXLocation.X = TargetUnitValue.fValue;

			PrimaryTarget.GetUnitValue(default.FXLocationYName, TargetUnitValue);
			FXLocation.Y = TargetUnitValue.fValue;

			PrimaryTarget.GetUnitValue(default.FXLocationZName, TargetUnitValue);
			FXLocation.Z = TargetUnitValue.fValue;
		}
		else
		{
			FXLocation = `XWORLD.GetPositionFromTileCoordinates(PrimaryTarget.TileLocation);

			// Set the FX location
			PrimaryTarget.SetUnitFloatValue(default.FXLocationXName, FXLocation.X, eCleanup_BeginTactical);
			PrimaryTarget.SetUnitFloatValue(default.FXLocationYName, FXLocation.Y, eCleanup_BeginTactical);
			PrimaryTarget.SetUnitFloatValue(default.FXLocationZName, FXLocation.Z, eCleanup_BeginTactical);
		}

		PlayEffectAction.EffectName = default.AwarenessEffectName;
		PlayEffectAction.EffectLocation = FXLocation;
		PlayEffectAction.bStopEffect = bStopEffect;

		`LOG("Beags Escalation: Awareness FX " @ (bStopEffect ? "stopped" : "started") @ " playing on target " @ PrimaryTarget.GetFullName() @ ".");
	}
	else
	{
		`RedScreen("Beags Escalation: Could not find Awareness effect primary target state.");
	}
}

simulated function AddX2ActionsForVisualization(XComGameState VisualizeGameState, out VisualizationTrack BuildTrack, name EffectApplyResult)
{
	local XComGameState_Effect TargetEffect;

	if (EffectApplyResult != 'AA_Success')
	{
		// We're only going to visualize the Awareness active effect when it applies successfully
		return;
	}

	foreach VisualizeGameState.IterateByClassType(class'XComGameState_Effect', TargetEffect)
	{
		if( TargetEffect.GetX2Effect() == self )
		{
			break;
		}
	}

	if (TargetEffect == none)
	{
		`RedScreen("Beags Escalation: Could not find Awareness effect state.");
		return;
	}

	DoTargetFX(TargetEffect, BuildTrack, VisualizeGameState.GetContext(), EffectApplyResult, false);
}

simulated function AddX2ActionsForVisualization_Sync(XComGameState VisualizeGameState, out VisualizationTrack BuildTrack)
{
	// We assume 'AA_Success', because otherwise the effect wouldn't be here (on load) to get sync'd
	AddX2ActionsForVisualization(VisualizeGameState, BuildTrack, 'AA_Success');
}

simulated function AddX2ActionsForVisualization_Removed(XComGameState VisualizeGameState, out VisualizationTrack BuildTrack, const name EffectApplyResult, XComGameState_Effect RemovedEffect)
{
	DoTargetFX(RemovedEffect, BuildTrack, VisualizeGameState.GetContext(), EffectApplyResult, true);
}

DefaultProperties
{
	FXLocationXName="Beags_Escalation_Awareness_FX_X"
	FXLocationYName="Beags_Escalation_Awareness_FX_Y"
	FXLocationZName="Beags_Escalation_Awareness_FX_Z"
}