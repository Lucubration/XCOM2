//-----------------------------------------------------------
// Used by the visualizer system to control a Visualization Actor
//-----------------------------------------------------------
class X2Action_FacelessChangeForm extends X2Action;

//Cached info for the unit performing the action
//*************************************
var protected XGUnit			FacelessUnit;
var protected TTile				CurrentTile;
var protected CustomAnimParams	AnimParams;

var private XComGameStateContext_Ability StartingAbility;
var private XComGameState_Ability AbilityState;
var private XComGameState_Unit FacelessUnitState;
var private AnimNodeSequence ChangeSequence;

// Set by visualizer so we know who to change form from
var XGUnit						SourceUnit;
//*************************************

function Init()
{
	local XComGameStateHistory History;
	super.Init();

	History = `XCOMHISTORY;
	FacelessUnit = XGUnit(Metadata.VisualizeActor);
	StartingAbility = XComGameStateContext_Ability(StateChangeContext);
	AbilityState = XComGameState_Ability(History.GetGameStateForObjectID(StartingAbility.InputContext.AbilityRef.ObjectID));
	FacelessUnitState = XComGameState_Unit(History.GetGameStateForObjectID(FacelessUnit.ObjectID));
}

function bool CheckInterrupted()
{
	return false;
}

function bool IsTimedOut()
{
	return false;
}

simulated state Executing
{
	function ChangePerkTarget()
	{
		local XComUnitPawn CasterPawn;
		local array<XComPerkContentInst> Perks;
		local int x;

		CasterPawn = XGUnit(`XCOMHISTORY.GetVisualizer(StartingAbility.InputContext.SourceObject.ObjectID)).GetPawn();

		class'XComPerkContent'.static.GetAssociatedPerkInstances( Perks, CasterPawn, StartingAbility.InputContext.AbilityTemplateName, StateChangeContext.AssociatedState.HistoryIndex );
		for (x = 0; x < Perks.Length; ++x)
		{
			Perks[x].ReplacePerkTarget( SourceUnit, FacelessUnit, none );
		}
	}

	function CopyFacing()
	{
		FacelessUnit.GetPawn().SetLocation(SourceUnit.GetPawn().Location);
		FacelessUnit.GetPawn().SetRotation(SourceUnit.GetPawn().Rotation);
		FacelessUnit.GetPawn().EnableFootIK(false);
	}

Begin:
	VisualizationMgr.SetInterruptionSloMoFactor(FacelessUnit, 1.0f);

	// Show the faceless and play its change form animation
	FacelessUnit.GetPawn().EnableRMA(true, true);
	FacelessUnit.GetPawn().EnableRMAInteractPhysics(true);

	// Then copy the facing to match the source
	CopyFacing();

	AnimParams = default.AnimParams;
	AnimParams.AnimName = 'NO_ChangeForm';
	AnimParams.BlendTime = 0.0f;
	
	ChangeSequence = FacelessUnit.GetPawn().GetAnimTreeController().PlayFullBodyDynamicAnim(AnimParams);

	FacelessUnit.m_bForceHidden = false;
	FacelessUnit.SetForceVisibility(eForceVisible); // Force faceless unit visible.
	CurrentTile = `XWORLD.GetTileCoordinatesFromPosition(FacelessUnit.Location);
	`TACTICALRULES.VisibilityMgr.ActorVisibilityMgr.VisualizerUpdateVisibility(FacelessUnit, CurrentTile);

	ChangePerkTarget();

	FinishAnim(ChangeSequence);

	FacelessUnit.GetPawn().EnableFootIK(true);	

	FacelessUnit.SetForceVisibility(eForceNone); // Remove forced visibility.
	CompleteAction();
}