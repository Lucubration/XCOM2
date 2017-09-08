//-----------------------------------------------------------
// Rotates the specified unit to face the given direction/actor
//-----------------------------------------------------------
class SeqAct_SetUnitFacing extends SequenceAction
	implements(X2KismetSeqOpVisualizer);

// the angle, in degrees, of the desired facing for this unit
var private float FacingDegrees;

// if specified, the unit will look at this specified actor
var() private Actor ActorToFace;

function BuildVisualization(XComGameState GameState)
{
	local XComGameStateHistory History;
	local VisualizationActionMetadata ActionMetadata;
	local X2Action_SetUnitFacing FacingAction;
	local SequenceVariable SeqVar;
	local SeqVar_GameUnit UnitVar;
	local XComGameState_Unit Unit;
	local XGUnit UnitVisualizer;

	History = `XCOMHISTORY;

	foreach VariableLinks[0].LinkedVariables(SeqVar)
	{
		UnitVar = SeqVar_GameUnit(SeqVar);
		Unit = XComGameState_Unit(History.GetGameStateForObjectID(UnitVar.IntValue));
		if(Unit == none)
		{
			`Redscreen("Invalid unit passed to SeqAct_SetUnitFacing");
			continue;
		}

		if(ActorToFace != none)
		{
			UnitVisualizer = XGUnit(Unit.GetVisualizer());
			if(UnitVisualizer != none)
			{
				FacingDegrees = Rotator(ActorToFace.Location - UnitVisualizer.GetLocation()).Yaw * UnrRotToDeg;
			}
		}

		ActionMetadata.StateObject_OldState = Unit;
		ActionMetadata.StateObject_NewState = Unit;
		FacingAction = X2Action_SetUnitFacing(class'X2Action_SetUnitFacing'.static.AddToVisualizationTree(ActionMetadata, GameState.GetContext()));
		FacingAction.FacingDegrees = FacingDegrees;

		
	}
}

function ModifyKismetGameState(out XComGameState GameState);

defaultproperties
{
	ObjCategory="Unit"
	ObjName="Set Unit Facing"

	bConvertedForReplaySystem=true
	bCanBeUsedForGameplaySequence=true

	VariableLinks(0)=(ExpectedType=class'SeqVar_GameUnit',LinkDesc="Units")
	VariableLinks(1)=(ExpectedType=class'SeqVar_Float',LinkDesc="Facing Degrees",PropertyName=FacingDegrees)
}
