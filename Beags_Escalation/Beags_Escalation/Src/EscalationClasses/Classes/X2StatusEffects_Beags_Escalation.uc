class X2StatusEffects_Beags_Escalation extends Object;

var localized string StaggeredFriendlyName;
var localized string StaggeredFriendlyDesc;
var localized string StaggeredEffectAcquiredString;
var localized string StaggeredEffectTickedString;
var localized string StaggeredEffectLostString;
var localized string SuppressingFiredFriendlyName;
var localized string SuppressingFiredFriendlyDesc;
var localized string SuppressingFiredEffectAcquiredString;

static function StaggeredVisualization(XComGameState VisualizeGameState, out VisualizationTrack BuildTrack, const name EffectApplyResult)
{
	if( EffectApplyResult != 'AA_Success' )
	{
		return;
	}
	if (XComGameState_Unit(BuildTrack.StateObject_NewState) == none)
		return;

	class'X2StatusEffects'.static.AddEffectSoundAndFlyOverToTrack(BuildTrack, VisualizeGameState.GetContext(), default.StaggeredFriendlyName, '', eColor_Bad, class'UIUtilities_Image'.const.UnitStatus_Marked);
	class'X2StatusEffects'.static.AddEffectMessageToTrack(BuildTrack, default.StaggeredEffectAcquiredString, VisualizeGameState.GetContext());
	class'X2StatusEffects'.static.UpdateUnitFlag(BuildTrack, VisualizeGameState.GetContext());
}

static function StaggeredVisualizationTicked(XComGameState VisualizeGameState, out VisualizationTrack BuildTrack, const name EffectApplyResult)
{
	local XComGameState_Unit UnitState;

	UnitState = XComGameState_Unit(BuildTrack.StateObject_NewState);
	if (UnitState == none)
		return;

	// dead units should not be reported
	if( !UnitState.IsAlive() )
	{
		return;
	}

	class'X2StatusEffects'.static.AddEffectSoundAndFlyOverToTrack(BuildTrack, VisualizeGameState.GetContext(), default.StaggeredFriendlyName, '', eColor_Bad, class'UIUtilities_Image'.const.UnitStatus_Marked);
	class'X2StatusEffects'.static.AddEffectMessageToTrack(BuildTrack, default.StaggeredEffectTickedString, VisualizeGameState.GetContext());
	class'X2StatusEffects'.static.UpdateUnitFlag(BuildTrack, VisualizeGameState.GetContext());
}

static function StaggeredVisualizationRemoved(XComGameState VisualizeGameState, out VisualizationTrack BuildTrack, const name EffectApplyResult)
{
	local XComGameState_Unit UnitState;

	UnitState = XComGameState_Unit(BuildTrack.StateObject_NewState);
	if (UnitState == none)
		return;

	// dead units should not be reported
	if( !UnitState.IsAlive() )
	{
		return;
	}

	class'X2StatusEffects'.static.AddEffectMessageToTrack(BuildTrack, default.StaggeredEffectLostString, VisualizeGameState.GetContext());
	class'X2StatusEffects'.static.UpdateUnitFlag(BuildTrack, VisualizeGameState.GetContext());
}

static function SuppressingFiredVisualization(XComGameState VisualizeGameState, out VisualizationTrack BuildTrack, const name EffectApplyResult)
{
	if( EffectApplyResult != 'AA_Success' )
	{
		return;
	}
	if (XComGameState_Unit(BuildTrack.StateObject_NewState) == none)
		return;

	class'X2StatusEffects'.static.AddEffectSoundAndFlyOverToTrack(BuildTrack, VisualizeGameState.GetContext(), default.SuppressingFiredFriendlyName, '', eColor_Bad, class'UIUtilities_Image'.const.UnitStatus_Marked);
	class'X2StatusEffects'.static.AddEffectMessageToTrack(BuildTrack, default.SuppressingFiredEffectAcquiredString, VisualizeGameState.GetContext());
	class'X2StatusEffects'.static.UpdateUnitFlag(BuildTrack, VisualizeGameState.GetContext());
}
