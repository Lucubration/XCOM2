// This is a fake world effect that really only effects the source unit, but plays an animation in a remote location.
// For our purposes, that remote animation will end up being the Advent troop transport flare
class X2Effect_ApplyFlareTargetToWorld extends X2Effect_Persistent;

private function DoTargetFX(XComGameState_Effect TargetEffect, out VisualizationTrack BuildTrack, XComGameStateContext Context, name EffectApplyResult, bool bStopEffect)
{
	local X2Action_PlayEffect FlarePlayEffect;
	local X2Action_StartStopSound SoundAction;

	if( EffectApplyResult != 'AA_Success' )
	{
		`LOG("Lucubration Infantry Class: Flare effect skipped (" @ EffectApplyResult @ ").");
		return;
	}

	//`LOG("Lucubration Infantry Class: " @ bStopEffect ? "Removing" : "Adding" @ " Flare effect to world.");
	
	// The first value in the InputContext.TargetLocations is the desired landing posiiton. Either start or stop showing the flare effect there
	FlarePlayEffect = X2Action_PlayEffect(class'X2Action_PlayEffect'.static.AddToVisualizationTrack(BuildTrack, Context));
	FlarePlayEffect.EffectName = `CONTENT.ATTFlareEffectPathName;
	FlarePlayEffect.bStopEffect = bStopEffect;
	FlarePlayEffect.EffectLocation = TargetEffect.ApplyEffectParameters.AbilityInputContext.TargetLocations[0];
	
	if (!bStopEffect)
	{
		//`LOG("Lucubration Infantry Class: Playing Flare audio effect.");

		// Play Target audio
		SoundAction = X2Action_StartStopSound(class'X2Action_StartStopSound'.static.AddToVisualizationTrack(BuildTrack, Context));
		SoundAction.Sound = new class'SoundCue';
		SoundAction.Sound.AkEventOverride = AkEvent'SoundTacticalUI.TacticalUI_DropZonePlacement';
		SoundAction.iAssociatedGameStateObjectId = TargetEffect.ObjectID;
		SoundAction.bStartPersistentSound = !bStopEffect;
		SoundAction.bStopPersistentSound = bStopEffect;
		SoundAction.bIsPositional = true;
		SoundAction.vWorldPosition = TargetEffect.ApplyEffectParameters.AbilityInputContext.TargetLocations[0];
	}

	//`LOG("Lucubration Infantry Class: " @ bStopEffect ? "Removed" : "Added" @ " Flare world effect.");
}

simulated function AddX2ActionsForVisualization(XComGameState VisualizeGameState, out VisualizationTrack BuildTrack, name EffectApplyResult)
{
	local XComGameState_Effect TargetEffect;

	foreach VisualizeGameState.IterateByClassType(class'XComGameState_Effect', TargetEffect)
	{
		if( TargetEffect.GetX2Effect() == self )
		{
			break;
		}
	}

	if( TargetEffect == none )
	{
		`RedScreen("Lucubration Infantry Class: Could not find Flare world effect state.");
		return;
	}

	DoTargetFX(TargetEffect, BuildTrack, VisualizeGameState.GetContext(), EffectApplyResult, false);
}

simulated function AddX2ActionsForVisualization_Removed(XComGameState VisualizeGameState, out VisualizationTrack BuildTrack, const name EffectApplyResult, XComGameState_Effect RemovedEffect)
{
	DoTargetFX(RemovedEffect, BuildTrack, VisualizeGameState.GetContext(), EffectApplyResult, true);
}

defaultproperties
{
	EffectName="ApplyFlareTargetToWorld"
}