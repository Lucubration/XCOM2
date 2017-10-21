class X2Effect_DLC_2RulerActionPoint extends X2Effect_GrantActionPoints;

simulated function AddX2ActionsForVisualization(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, const name EffectApplyResult)
{
	super.AddX2ActionsForVisualization(VisualizeGameState, ActionMetadata, EffectApplyResult);
	
	if (EffectApplyResult == 'AA_Success' && XComGameState_Unit(ActionMetadata.StateObject_NewState) != none)
	{
		class'X2Action_SpecialTurnOverlay'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext(), false, ActionMetadata.LastActionAdded);
	}
}

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameState_Unit UnitState;
	local UnitValue RulerActionsValue;
	local int RulerActionsCount;
	
	UnitState = XComGameState_Unit(kNewTargetState);
	
	if (UnitState != none)
	{
		UnitState.ActionPoints.Length = 0; // Clear the alien rulers action points each time they get a turn
	}

	// Then grant them the points they need
	super.OnEffectAdded(ApplyEffectParameters, kNewTargetState, NewGameState, NewEffectState);

	// If the ruler has an action point available (not stunned or frozen)...
	if (UnitState.ActionPoints.Length > 0)
	{
		// Increment the number of actions the ruler has taken
		if (UnitState.GetUnitValue('RulerActionsCount', RulerActionsValue))
		{
			RulerActionsCount = int(RulerActionsValue.fValue);
		}
		UnitState.SetUnitFloatValue('RulerActionsCount', float(RulerActionsCount + 1), eCleanup_Never);
	}
}	