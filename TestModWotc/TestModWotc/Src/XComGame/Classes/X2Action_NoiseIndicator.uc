//-----------------------------------------------------------
// Used by the visualizer system to control a Visualization Actor
//-----------------------------------------------------------
class X2Action_NoiseIndicator extends X2Action
	native(Core)
	config(GameCore);

//Cached info for performing the action
//*************************************
var XGUnit HeardUnit; // The unit that is generating the sound
//*************************************

var const config string NoiseIndicatorMeshName; // mesh to use when visualizing the noise direction
var const config int MaxNoiseIndicatorSizeInTiles; // maximum size the indicator mesh can reach, in tiles

var private X2Camera_LookAtActor TargetingCamera;
var private AnimNodeSequence PlayingAnim;
var private StaticMeshComponent NoiseIndicatorMeshComponent; // mesh component that draws the noise direction visualizer

var StateObjectReference HeardUnitReference;	// Stores the object ID of the nearest unit making noise
var name HeardUnitCallout;                      // The UnitSpeak sound that will play on the heardunit
var Vector TargetLocation;                      // the location the noise indicator will point to 

function Init()
{
	super.Init();

	if(HeardUnitReference.ObjectID > 0)
	{
		HeardUnit = XGUnit(`XCOMHISTORY.GetVisualizer(HeardUnitReference.ObjectID));
	}
}

function SetNoiseIndicatorMesh(StaticMesh Mesh)
{
	if(Mesh == none)
	{
		`Redscreen("X2Action_NoiseIndicator::SetNoiseIndicatorMesh was provided a null mesh.");
		return;
	}

	NoiseIndicatorMeshComponent.SetStaticMesh(Mesh);
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
		local vector ToSoundOrigin;
		local Rotator MeshOrientation;
		local float EffectiveScalingDistance;
		local vector Scale;

		// move the indicator to the unit and then orient it to the pod locations center

		// if no mesh was specified, use the default in the ini
		if(NoiseIndicatorMeshComponent.StaticMesh == none)
		{
			SetNoiseIndicatorMesh(StaticMesh(DynamicLoadObject(default.NoiseIndicatorMeshName, class'StaticMesh')));
		}

		NoiseIndicatorMeshComponent.SetHidden(false);
		NoiseIndicatorMeshComponent.SetTranslation(Unit.GetLocation());

		// orient toward the sound origin
		ToSoundOrigin = TargetLocation - Unit.Location;
		MeshOrientation = Rotator(ToSoundOrigin);
		MeshOrientation.Roll = 0;
		NoiseIndicatorMeshComponent.SetRotation(MeshOrientation);

		// set the scale of the indicator
		EffectiveScalingDistance = FMin(VSize(ToSoundOrigin), MaxNoiseIndicatorSizeInTiles * class'XComWorldData'.const.WORLD_StepSize);
		Scale.X = EffectiveScalingDistance / (NoiseIndicatorMeshComponent.Bounds.BoxExtent.X * 2); // BoxExtent.x since we are oriented along the x-axis
		Scale.Y = Scale.X;
		Scale.Z = 1;
		NoiseIndicatorMeshComponent.SetScale3D(Scale);
	}

Begin:
	if( !bNewUnitSelected )
	{
		TargetingCamera = new class'X2Camera_LookAtActor';
		TargetingCamera.ActorToFollow = Unit;
		`CAMERASTACK.AddCamera(TargetingCamera);
	}

	//Make the alien sounds if available
	if(HeardUnit != none && HeardUnitCallout != '')
	{
		HeardUnit.UnitSpeak(HeardUnitCallout);
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

	NoiseIndicatorMeshComponent.SetHidden(true);

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
	NoiseIndicatorMeshComponent=NoiseIndicatorMeshObject
	Components.Add(NoiseIndicatorMeshObject)

	HeardUnitCallout="HiddenMovementVox"
}

