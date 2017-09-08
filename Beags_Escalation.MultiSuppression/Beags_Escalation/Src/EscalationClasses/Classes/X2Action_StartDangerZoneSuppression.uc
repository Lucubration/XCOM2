class X2Action_StartDangerZoneSuppression extends X2Action;

var private XGUnit              SourceUnit;
var private array<XGUnit>		TargetUnits;
var private int					i;

function Init(const out VisualizationTrack InTrack)
{
	local XComGameStateContext_Ability AbilityContext;

	super.Init(InTrack);

	SourceUnit = XGUnit(Track.TrackActor);
	AbilityContext = XComGameStateContext_Ability(StateChangeContext);
	for (i = 0; i < AbilityContext.InputContext.MultiTargets.Length; i++)
		TargetUnits.AddItem(XGUnit(`XCOMHISTORY.GetGameStateForObjectID(AbilityContext.InputContext.PrimaryTarget.ObjectID).GetVisualizer()));
}

function bool CheckInterrupted()
{
	return false;
}

simulated state Executing
{
Begin:
	if (SourceUnit.IsMine())
		SourceUnit.UnitSpeak('Suppressing');

	for (i = 0; i < TargetUnits.Length; i++)
		if (TargetUnits[i].IsMine())
			TargetUnits[i].UnitSpeak('Suppressed');

	SourceUnit.ConstantCombatSuppressArea(true);
	SourceUnit.ConstantCombatSuppress(false, none);
	SourceUnit.IdleStateMachine.CheckForStanceUpdate();

	CompleteAction();
}