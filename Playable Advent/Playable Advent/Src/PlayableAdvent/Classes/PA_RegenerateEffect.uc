class PA_RegenerateEffect extends X2Effect;

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameState_Ability Ability;
	local XComGameState_Unit TargetUnit;

	Ability = XComGameState_Ability(NewGameState.GetGameStateForObjectID(ApplyEffectParameters.AbilityStateObjectRef.ObjectID));
	TargetUnit = XComGameState_Unit(kNewTargetState);
	if (Ability != none && TargetUnit != none)
	{
		`log ("davea debug regenerate ability shred was: " @ TargetUnit.Shredded);
		TargetUnit.Shredded = 0;
		TargetUnit.ModifyCurrentStat(eStat_HP, 4); // NYI unhardcode later
	}
}

simulated function AddX2ActionsForVisualization(XComGameState VisualizeGameState, out VisualizationTrack BuildTrack, const name EffectApplyResult)
{
	local XComGameState_Unit OldUnit, NewUnit;
	local X2Action_PlaySoundAndFlyOver SoundAndFlyOver;
	local int Healed, Unshredded;
	local string Msg;

	OldUnit = XComGameState_Unit(BuildTrack.StateObject_OldState);
	NewUnit = XComGameState_Unit(BuildTrack.StateObject_NewState);

	if (OldUnit != none && NewUnit != None)
	{
		Healed = NewUnit.GetCurrentStat(eStat_HP) - OldUnit.GetCurrentStat(eStat_HP);
		Unshredded = OldUnit.Shredded - NewUnit.Shredded;
	
		SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTrack(BuildTrack, VisualizeGameState.GetContext()));
		Msg = "Regenerated XXX HP, YYY armor";
		Msg = Repl(Msg, "XXX", Healed);
		Msg = Repl(Msg, "YYY", Unshredded);
		SoundAndFlyOver.SetSoundAndFlyOverParameters(None, Msg, '', eColor_Good);
	}
}

simulated function AddX2ActionsForVisualization_Tick(XComGameState VisualizeGameState, out VisualizationTrack BuildTrack, const int TickIndex, XComGameState_Effect EffectState)
{
	AddX2ActionsForVisualization(VisualizeGameState, BuildTrack, 'AA_Success');
}
