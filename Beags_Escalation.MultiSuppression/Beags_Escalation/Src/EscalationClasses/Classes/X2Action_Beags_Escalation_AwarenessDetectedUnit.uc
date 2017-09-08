//-----------------------------------------------------------
// Used by the visualizer system to control a Visualization Actor
//-----------------------------------------------------------
class X2Action_Beags_Escalation_AwarenessDetectedUnit extends X2Action;

//Cached info for performing the action
//*************************************
var XGUnit					DetectedUnit;
//*************************************

var string NoiseIndicatorMeshName; // mesh to use when visualizing the noise direction
var int MaxNoiseIndicatorSizeInTiles; // maximum size the indicator mesh can reach, in tiles
var Vector DetectedUnitLocation; // The location of the unit that generated this alert
var private int DetectedUnitObjectID; // The object ID of the unit that generated this alert

var private X2Camera_LookAtActor TargetingCamera;
var private AnimNodeSequence PlayingAnim;

var private StaticMeshComponent NoiseIndicatorMesh; // mesh component that draws the noise direction visualizer

static function bool AddHiddenMovementActionToBlock(XComGameState GameState, out array<VisualizationTrack> VisualizationTracks)
{
	local XComGameStateHistory								History;
	local XComGameStateContext_Ability						Context;
	local StateObjectReference								InteractingUnitRef, TargetUnitRef;
	local XComGameState_Unit								InteractingUnit, TargetUnit;
	local VisualizationTrack								BuildTrack;
	local X2Action_CameraLookAt								CameraAction;
	local X2Action_Beags_Escalation_AwarenessDetectedUnit	Action;
	
	History = `XCOMHISTORY;
	
	Context = XComGameStateContext_Ability(GameState.GetContext());
	InteractingUnitRef = Context.InputContext.SourceObject;
	InteractingUnit = XComGameState_Unit(History.GetGameStateForObjectID(InteractingUnitRef.ObjectID, eReturnType_Reference, GameState.HistoryIndex - 1));

	TargetUnitRef = Context.InputContext.PrimaryTarget;
	TargetUnit = XComGameState_Unit(History.GetGameStateForObjectID(TargetUnitRef.ObjectID, eReturnType_Reference, GameState.HistoryIndex - 1));

	// Add a camera to center on the source unit for this effect
	BuildTrack.StateObject_OldState = InteractingUnit;
	BuildTrack.StateObject_NewState = GameState.GetGameStateForObjectID(InteractingUnitRef.ObjectID);
	BuildTrack.TrackActor = History.GetVisualizer(InteractingUnitRef.ObjectID);

	CameraAction = X2Action_CameraLookAt(class'X2Action_CameraLookAt'.static.AddToVisualizationTrack(BuildTrack, Context));
	CameraAction.LookAtActor = BuildTrack.TrackActor;
	CameraAction.UseTether = false; // need to fully center on him so the sound indicator doesn't overlap him
	CameraAction.BlockUntilActorOnScreen = true;

	// Add the action for the hidden movement
	Action = X2Action_Beags_Escalation_AwarenessDetectedUnit(class'X2Action_Beags_Escalation_AwarenessDetectedUnit'.static.AddToVisualizationTrack(BuildTrack, Context));

	// Just use the target unit's location
	Action.DetectedUnitLocation = `XWORLD.GetPositionFromTileCoordinates(TargetUnit.TileLocation);
	Action.DetectedUnitObjectID = TargetUnit.ObjectID;
	
	VisualizationTracks.AddItem(BuildTrack);
	return true;
}

function Init(const out VisualizationTrack InTrack)
{
	super.Init(InTrack);

	if (DetectedUnitObjectID > 0)
	{
		DetectedUnit = XGUnit(`XCOMHISTORY.GetVisualizer(DetectedUnitObjectID));
	}
}

function PlayAnimation()
{
	local CustomAnimParams AnimParams;

	AnimParams.AnimName = 'HL_SignalReactToNoise';
	AnimParams.Looping = false;
	if( Unit.GetPawn().GetAnimTreeController().CanPlayAnimation(AnimParams.AnimName) )
	{
		PlayingAnim = Unit.GetPawn().GetAnimTreeController().PlayFullBodyDynamicAnim(AnimParams);
	}
}

//------------------------------------------------------------------------------------------------
simulated state Executing
{
	function ShowNoiseIndicator()
	{
		local StaticMesh StaticMeshData;
		local vector ToEnemy;
		local Rotator MeshOrientation;
		local float EffectiveScalingDistance;
		local vector Scale;

		// load the static mesh
		StaticMeshData = StaticMesh(DynamicLoadObject(NoiseIndicatorMeshName, class'StaticMesh'));

		// move the indicator to the unit and then orient it to the pod locations center
		NoiseIndicatorMesh.SetStaticMesh(StaticMeshData);
		NoiseIndicatorMesh.SetHidden(false);
		NoiseIndicatorMesh.SetTranslation(Unit.GetLocation());

		// orient toward the enemy
		ToEnemy = DetectedUnitLocation - Unit.Location;
		MeshOrientation = Rotator(ToEnemy);
		MeshOrientation.Roll = 0;
		NoiseIndicatorMesh.SetRotation(MeshOrientation);

		// set the scale of the indicator
		EffectiveScalingDistance = FMin(VSize(ToEnemy), MaxNoiseIndicatorSizeInTiles * class'XComWorldData'.const.WORLD_StepSize);
		Scale.X = EffectiveScalingDistance / (NoiseIndicatorMesh.Bounds.BoxExtent.X * 2); // BoxExtent.x since we are oriented along the x-axis
		Scale.Y = Scale.X;
		Scale.Z = 1;
		NoiseIndicatorMesh.SetScale3D(Scale);
	}

Begin:
	if( !bNewUnitSelected )
	{
		TargetingCamera = new class'X2Camera_LookAtActor';
		TargetingCamera.ActorToFollow = Unit;
		`CAMERASTACK.AddCamera(TargetingCamera);
	}

	// Make the alien sounds if available
	if (DetectedUnit != none)
	{
		DetectedUnit.UnitSpeak('HiddenMovementVox');
	}

	// Dramatic pause / give the camera a moment to settle
	Sleep(1.5 * GetDelayModifier());

	ShowNoiseIndicator();	
		
	//Have the x-com unit start their speech
	//Note: these two cues are both used for this situation, so select one randomly.
	if (`SYNC_RAND(100)<50)
	{
		Unit.UnitSpeak('TargetHeard');
	}
	else
	{
		Unit.UnitSpeak('AlienMoving');
	}

	// play the animation and wait for it to finish
	PlayAnimation();

	if( PlayingAnim != None )
	{
		FinishAnim(PlayingAnim);

		// keep the camera looking this way for a few moments
		Sleep(1.0 * GetDelayModifier());
	}

	NoiseIndicatorMesh.SetHidden(true);

	if( TargetingCamera != None )
	{
		`CAMERASTACK.RemoveCamera(TargetingCamera);
		TargetingCamera = None;
	}

	CompleteAction();
}

event HandleNewUnitSelection()
{
	if( TargetingCamera != None )
	{
		`CAMERASTACK.RemoveCamera(TargetingCamera);
		TargetingCamera = None;
	}
}

defaultproperties
{
	Begin Object Class=StaticMeshComponent Name=NoiseIndicatorMeshObject
		StaticMesh=none
		HiddenGame=true
		bOwnerNoSee=FALSE
		CastShadow=FALSE
		BlockNonZeroExtent=false
		BlockZeroExtent=false
		BlockActors=false
		CollideActors=false
		TranslucencySortPriority=1000
		bTranslucentIgnoreFOW=true
		AbsoluteTranslation=true
		AbsoluteRotation=true
		Scale=1.0
	End Object
	NoiseIndicatorMeshName="UI_3D.Range.NoiseDirection"
	MaxNoiseIndicatorSizeInTiles=10
	Components.Add(NoiseIndicatorMeshObject)
}

