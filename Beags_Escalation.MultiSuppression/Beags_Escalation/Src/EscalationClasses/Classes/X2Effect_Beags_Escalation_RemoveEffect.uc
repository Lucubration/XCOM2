class X2Effect_Beags_Escalation_RemoveEffect extends X2Effect;

var name		EffectNameToRemove;
var int			NumberToRemove;			// 0: all stacks, 1+: # of stacks
var bool		bMatchSourceToTarget;   // Match the source of each effect to the target of this one
var bool		bMatchSourceToSource;   // Match the source of each effect to the source of this one
var bool		bMatchTargetToTarget;	// Match the target of each effect to the target of this one
var bool		bMatchTargetToSource;	// Match the target of each effect to the source of this one
var bool		bCleanse;				// Indicates the effect was removed "safely" for gameplay purposes so any bad "wearing off" effects should not trigger
										// (e.g. Bleeding Out normally kills the soldier it is removed from, but if cleansed, it won't)

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameState_Effect	EffectState;
	local X2Effect_Persistent	PersistentEffect;
	local int					NumberRemoved;

	foreach `XCOMHISTORY.IterateByClassType(class'XComGameState_Effect', EffectState)
	{
		if ((!bMatchSourceToTarget || (EffectState.ApplyEffectParameters.SourceStateObjectRef.ObjectID == ApplyEffectParameters.TargetStateObjectRef.ObjectID)) ||
			(!bMatchSourceToTarget || (EffectState.ApplyEffectParameters.SourceStateObjectRef.ObjectID == ApplyEffectParameters.SourceStateObjectRef.ObjectID)) ||
			(!bMatchTargetToTarget || (EffectState.ApplyEffectParameters.TargetStateObjectRef.ObjectID == ApplyEffectParameters.TargetStateObjectRef.ObjectID)) ||
			(!bMatchTargetToSource || (EffectState.ApplyEffectParameters.TargetStateObjectRef.ObjectID == ApplyEffectParameters.SourceStateObjectRef.ObjectID)))
		{
			PersistentEffect = EffectState.GetX2Effect();

			if (EffectNameToRemove == PersistentEffect.EffectName)
			{
				EffectState.RemoveEffect(NewGameState, NewGameState, bCleanse);
				
				NumberRemoved++;
				if (NumberToRemove > 0 && NumberRemoved >= NumberToRemove)
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
	bMatchSourceToTarget=false
	bMatchSourceToSource=false
	bMatchTargetToTarget=false
	bMatchTargetToSource=false
	bCleanse=true
}