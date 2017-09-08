class X2Effect_Beags_Escalation_BreachingCharge extends X2Effect_Persistent;


function RegisterForEvents(XComGameState_Effect EffectGameState)
{
	local X2EventManager EventMgr;
	local Object EffectObj;

	EventMgr = `XEVENTMGR;

	EffectObj = EffectGameState;

	EventMgr.RegisterForEvent(EffectObj, 'ObjectMoved', EffectGameState.ProximityMine_ObjectMoved, ELD_OnStateSubmitted);
	EventMgr.RegisterForEvent(EffectObj, 'AbilityActivated', EffectGameState.ProximityMine_AbilityActivated, ELD_OnStateSubmitted);
}

simulated function AddX2ActionsForVisualization(XComGameState VisualizeGameState, out VisualizationTrack BuildTrack, name EffectApplyResult)
{
	local XComGameState_Effect MineEffect, EffectState;
	local X2Action_StartStopSound SoundAction;

	if (EffectApplyResult != 'AA_Success' || BuildTrack.TrackActor == none)
		return;

	foreach VisualizeGameState.IterateByClassType(class'XComGameState_Effect', EffectState)
	{
		if (EffectState.GetX2Effect() == self)
		{
			MineEffect = EffectState;
			break;
		}
	}
	`assert(MineEffect != none);

	//For multiplayer: don't visualize mines on the enemy team.
	if (MineEffect.GetSourceUnitAtTimeOfApplication().ControllingPlayer.ObjectID != `TACTICALRULES.GetLocalClientPlayerObjectID())
		return;

	SoundAction = X2Action_StartStopSound(class'X2Action_StartStopSound'.static.AddToVisualizationTrack(BuildTrack, VisualizeGameState.GetContext()));
	SoundAction.Sound = new class'SoundCue';
	SoundAction.Sound.AkEventOverride = AkEvent'SoundX2CharacterFX.Item_Proximity_Mine_Active_Ping';
	SoundAction.iAssociatedGameStateObjectId = MineEffect.ObjectID;
	SoundAction.bStartPersistentSound = true;
	SoundAction.bIsPositional = true;
	SoundAction.vWorldPosition = MineEffect.ApplyEffectParameters.AbilityInputContext.TargetLocations[0];
}

simulated function AddX2ActionsForVisualization_Sync(XComGameState VisualizeGameState, out VisualizationTrack BuildTrack)
{
	//We assume 'AA_Success', because otherwise the effect wouldn't be here (on load) to get sync'd
	AddX2ActionsForVisualization(VisualizeGameState, BuildTrack, 'AA_Success');
}

simulated function AddX2ActionsForVisualization_Removed(XComGameState VisualizeGameState, out VisualizationTrack BuildTrack, const name EffectApplyResult, XComGameState_Effect RemovedEffect)
{
	local XComGameState_Effect MineEffect, EffectState;
	local X2Action_StartStopSound SoundAction;

	if (EffectApplyResult != 'AA_Success' || BuildTrack.TrackActor == none)
		return;

	foreach VisualizeGameState.IterateByClassType(class'XComGameState_Effect', EffectState)
	{
		if (EffectState.GetX2Effect() == self)
		{
			MineEffect = EffectState;
			break;
		}
	}
	`assert(MineEffect != none);

	//For multiplayer: don't visualize mines on the enemy team.
	if (MineEffect.GetSourceUnitAtTimeOfApplication().ControllingPlayer.ObjectID != `TACTICALRULES.GetLocalClientPlayerObjectID())
		return;

	SoundAction = X2Action_StartStopSound(class'X2Action_StartStopSound'.static.AddToVisualizationTrack(BuildTrack, VisualizeGameState.GetContext()));
	SoundAction.Sound = new class'SoundCue';
	SoundAction.Sound.AkEventOverride = AkEvent'SoundX2CharacterFX.Stop_Proximity_Mine_Active_Ping';
	SoundAction.iAssociatedGameStateObjectId = MineEffect.ObjectID;
	SoundAction.bIsPositional = true;
	SoundAction.bStopPersistentSound = true;
}

DefaultProperties
{
	EffectName="ProximityMine"
	DuplicateResponse = eDupe_Allow;
}