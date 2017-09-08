class X2Effect_TrackingShotMarkTarget extends X2Effect_Persistent;

var float ConeLength;
var float ConeEndDiameter;

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComWorldData World;

	super.OnEffectAdded(ApplyEffectParameters, kNewTargetState, NewGameState, NewEffectState);

	World = `XWORLD;
	World.CollectConeTiles(NewEffectState.AffectedTiles, ApplyEffectParameters.SourceStateObjectRef.ObjectID, ApplyEffectParameters.TargetStateObjectRef.ObjectID, ConeLength, ConeEndDiameter);
}


function OnUnitChangedTile(const out TTile NewTileLocation, XComGameState_Effect EffectState, XComGameState_Unit TargetUnit)
{
	local XGUnit Unit;
	local XComUnitPawn UnitPawn;
	Unit = XGUnit(TargetUnit.GetVisualizer());
	UnitPawn = Unit.GetPawn();
	UnitPawn.UpdateTrackingShotMark(NewTileLocation); 
}

defaultproperties
{
}