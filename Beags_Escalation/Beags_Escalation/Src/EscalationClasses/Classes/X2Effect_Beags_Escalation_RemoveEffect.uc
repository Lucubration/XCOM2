class X2Effect_Beags_Escalation_RemoveEffect extends X2Effect;

var name		EffectNameToRemove;
var int			NumberToRemove;			// Max number of instances of the named effect to remove
var bool		bCheckSource;           // Match the source of each effect to the target of this one, rather than the target
var bool		bCleanse;				// Indicates the effect was removed "safely" for gameplay purposes so any bad "wearing off" effects should not trigger
										// (e.g. Bleeding Out normally kills the soldier it is removed from, but if cleansed, it won't)

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameState_Effect	EffectState;
	local X2Effect_Persistent	PersistentEffect;
	local int					NumberRemoved;

	foreach `XCOMHISTORY.IterateByClassType(class'XComGameState_Effect', EffectState)
	{
		if ((bCheckSource && (EffectState.ApplyEffectParameters.SourceStateObjectRef.ObjectID == ApplyEffectParameters.TargetStateObjectRef.ObjectID)) ||
			(!bCheckSource && (EffectState.ApplyEffectParameters.TargetStateObjectRef.ObjectID == ApplyEffectParameters.TargetStateObjectRef.ObjectID)))
		{
			PersistentEffect = EffectState.GetX2Effect();

			if (EffectNameToRemove == PersistentEffect.EffectName)
			{
				EffectState.RemoveEffect(NewGameState, NewGameState, bCleanse);
				
				NumberRemoved++;
				if (NumberRemoved >= NumberToRemove)
					break;
			}
		}
	}
}

simulated function AddX2ActionsForVisualization(XComGameState VisualizeGameState, out VisualizationTrack BuildTrack, const name EffectApplyResult)
{
	local XComGameState_Effect	EffectState;
	local X2Effect_Persistent	Effect;

	if (EffectApplyResult != 'AA_Success')
		return;

	//  We are assuming that any removed effects were removed by this RemoveEffects
	foreach VisualizeGameState.IterateByClassType(class'XComGameState_Effect', EffectState)
	{
		if (EffectState.bRemoved)
		{
			if (EffectState.ApplyEffectParameters.TargetStateObjectRef.ObjectID == BuildTrack.StateObject_NewState.ObjectID)
			{
				Effect = EffectState.GetX2Effect();
				Effect.AddX2ActionsForVisualization_Removed(VisualizeGameState, BuildTrack, EffectApplyResult, EffectState);
			}
			else if (EffectState.ApplyEffectParameters.SourceStateObjectRef.ObjectID == BuildTrack.StateObject_NewState.ObjectID)
			{
				Effect = EffectState.GetX2Effect();
				Effect.AddX2ActionsForVisualization_RemovedSource(VisualizeGameState, BuildTrack, EffectApplyResult, EffectState);
			}
		}
	}
}

DefaultProperties
{
	NumberToRemove=1
	bCheckSource=false
	bCleanse=true
}