
class UIArmory_Photobooth extends UIPhotoboothBase
	config(Content)
	native(UI);

var StateObjectReference m_kDefaultSoldierRef;

var XComCamState_HQ_Photobooth m_kCamState;
var XComHeadquartersCamera m_kHQCamera;

var float m_fCameraZoomStep;
var float m_fCameraMoveStep;
var float m_fCameraRotateStep;

simulated function OnInit()
{
	if (`ScreenStack.IsInStack(class'UIArmory_MainMenu'))
	{
		UIArmory(`ScreenStack.GetFirstInstanceOf(class'UIArmory_MainMenu')).ReleasePawn();
	}
	
	`PHOTOBOOTH.InterruptAutoGen();

	class'Engine'.static.GetEngine().GameViewport.bRenderEmptyScene = true;

	`PHOTOBOOTH.SetCamLookAtNamedLocation();

	super.OnInit();	

	//bsg-jedwards (5.4.17) : Allows Armory Photobooth to use all 6 camera presets
	if(`ISCONTROLLERACTIVE)
	{
		m_CameraPresets_Labels.AddItem(m_strCameraPresetLabel_Headshot);
		m_CameraPresets_Labels.AddItem(m_strCameraPresetLabel_Tight);
		m_CameraPresets_Labels.AddItem(m_strCameraPresetLabel_FullBody);
		m_CameraPresets_Labels.AddItem(m_strCameraPresetLabel_High);
		m_CameraPresets_Labels.AddItem(m_strCameraPresetLabel_Low);
		m_CameraPresets_Labels.AddItem(m_strCameraPresetLabel_Profile);
		max_SpinnerVal = 5;
	}
	//bsg-jedwards (5.4.17) : end
}

function ZoomIn()
{
	m_kCamState.AddZoom(-m_fCameraZoomStep);
}
function ZoomOut()
{
	m_kCamState.AddZoom(m_fCameraZoomStep);
}


function GenerateDefaultSoldierSetup()
{
	`PHOTOBOOTH.SetSoldier(0, m_kDefaultSoldierRef);

	if(DefaultSetupSettings.PossibleSoldiers.Length == 0)
		DefaultSetupSettings.PossibleSoldiers.AddItem(m_kDefaultSoldierRef);

	Super.GenerateDefaultSoldierSetup();
}

function InitPropaganda(StateObjectReference UnitRef, optional bool bInstantTransition, optional UIPosterScreen posterScreen)
{
	m_kDefaultSoldierRef = UnitRef;
}

function InitTabButtons()
{
	InitCameraButton();
	InitPosterButton();
}

simulated function OnReceiveFocus()
{
	UpdateNavHelp();
	super.OnReceiveFocus();
}

function UpdateNavHelp()
{
	if (NavHelp == none)
	{
		NavHelp = Spawn(class'UINavigationHelp', self).InitNavHelp();
	}

	NavHelp.ClearButtonHelp();
	NavHelp.bIsVerticalHelp = true;
	NavHelp.AddBackButton(OnCancel);

	//bsg-jneal (5.30.17): no select navhelp if in camera mode
	if(!m_bGamepadCameraActive)
	{
		NavHelp.AddSelectNavHelp(); //bsg-crobinson (3.17.17) Add select button to photobooth
	}
	//bsg-jneal (5.30.17): end

	//bsg-jneal (5.2.17): navhelp fixes for controller
	if( `ISCONTROLLERACTIVE )
	{
		if (XComHQPresentationLayer(Movie.Pres) != none)
		{
			NavHelp.AddLeftHelp(m_strTakePhoto, class'UIUtilities_Input'.const.ICON_X_SQUARE);
		}

		if(!m_bGamepadCameraActive)
		{
			EnableConsoleControls(false);
		}
		else
		{
			EnableConsoleControls(true);
		}
	}
	//bsg-jneal (5.2.17): end

	NavHelp.Show();
}

function SetupContent()
{
	MoveFormation();
}

function TPOV GetCameraPOV()
{
	local TPOV outPOV;

	if(m_kHQCamera != none)
		m_kHQCamera.GetCameraViewPoint(outPOV.Location, outPOV.Rotation);

	outPOV.FOV = m_fCameraFOV;

	return outPOV;
}

function UpdateCameraToPOV(PhotoboothCameraSettings CameraSettings, bool SnapToFinal)
{
	m_kCamState.SetFocusPoint(CameraSettings.RotationPoint);
	m_kCamState.SetCameraRotation(CameraSettings.Rotation);
	m_kCamState.SetViewDistance(CameraSettings.ViewDistance);
	if (SnapToFinal)
	{
		m_kCamState.MoveToFinal();
	}
}

function OnCameraPreset(string selection, optional bool bUpdateViewDistance = true)
{
	super.OnCameraPreset(selection);
	m_kCamState.SetUseCameraPreset(true);
}

function SetupCamera()
{
	local CameraActor camActor;
	local XComHQPresentationLayer HQPres;

	HQPres = XComHQPresentationLayer(Movie.Pres);
	if (HQPres == none)
		return;

	camActor = GetSetupCameraActor();
	m_kHQCamera = HQPres.GetCamera();

	if (m_kHQCamera != none && camActor != none)
	{
		m_kHQCamera.SetZoom(1.0f);
		m_kCamState = XComCamState_HQ_Photobooth(m_kHQCamera.SetCameraState(class'XComCamState_HQ_Photobooth', 0.0f));
		m_kCamState.Init(m_kHQCamera.PCOwner, camActor, GetFormationPlacementActor());
		m_bNeedsCaptureOutlineReset = true;
		
		// Turn on the Radio DJ ambient VO in the Photobooth
		if (m_kHQCamera.EnteringPhotoboothView != none)
		{
			m_kHQCamera.EnteringPhotoboothView();
		}
	}	
}

function UpdateSoldierData()
{
	local int i;
	local XComGameState_Unit Unit;
	local XComGameState_HeadquartersXCom HQState;

	m_arrSoldiers.Length = 0;

	if(m_kDefaultSoldierRef.ObjectID != 0)
	{
		m_arrSoldiers.AddItem(m_kDefaultSoldierRef);
	}

	//Need to get the latest state here, else you may have old data in the list upon refreshing at OnReceiveFocus, such as 
	//still showing dismissed soldiers. 
	HQState = class'UIUtilities_Strategy'.static.GetXComHQ();

	for (i = 0; i < HQState.Crew.Length; i++)
	{
		Unit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(HQState.Crew[i].ObjectID));

		if (Unit.IsAlive())
		{
			if (Unit.IsSoldier() && m_arrSoldiers.Find('ObjectID', Unit.ObjectID) == INDEX_NONE)
			{
				m_arrSoldiers.AddItem(Unit.GetReference());
			}
		}
	}

	Super.UpdateSoldierData();
}

event Tick(float DeltaTime)
{
	local Vector2D MouseDelta;
	if (bIsFocused)
	{
		super.Tick(DeltaTime);

		// KDERDA - Move this to it's respective subclass to avoid log spam.
		if (`HQINPUT != none)
		{
			StickVectorLeft.x = `HQINPUT.m_fLSXAxis;
			StickVectorLeft.y = `HQINPUT.m_fLSYAxis;
			StickVectorRight.x = `HQINPUT.m_fRSXAxis;
			StickVectorRight.y = `HQINPUT.m_fRSYAxis;
		}

		if (m_bRightMouseIn && !m_bRotatingPawn)
		{
			m_kCamState.SetUseCameraPreset(false);
			MouseDelta = Movie.Pres.m_kUIMouseCursor.m_v2MouseFrameDelta;
			Movie.Pres.m_kUIMouseCursor.UpdateMouseLocation();
			
			//bsg-jneal (5.2.17): controller input for camera, right stick for rotation, left for pan
			if (!`ISCONTROLLERACTIVE)
			{
				m_kCamState.AddRotation(MouseDelta.Y * DragRotationMultiplier,  -1 * MouseDelta.X * DragRotationMultiplier, 0);
			}
			else
			{
				m_kCamState.AddRotation(StickVectorRight.Y * StickRotationMultiplier * DeltaTime, StickVectorRight.X * StickRotationMultiplier * DeltaTime, 0);
			}
			//bsg-jneal (5.2.17): end
		}

		if (m_bMouseIn && !m_bRotatingPawn)
		{
			m_kCamState.SetUseCameraPreset(false);
			MouseDelta = Movie.Pres.m_kUIMouseCursor.m_v2MouseFrameDelta;
			Movie.Pres.m_kUIMouseCursor.UpdateMouseLocation();
			
			//bsg-jneal (5.2.17): controller input for camera, right stick for rotation, left for pan
			if (!`ISCONTROLLERACTIVE)
			{
				m_kCamState.MoveFocusPointOnRotationAxes(0, -1 * MouseDelta.X * DragPanMultiplier * m_kCamState.GetZoomPercentage(), MouseDelta.Y * DragPanMultiplier * m_kCamState.GetZoomPercentage());
			}
			else
			{
				m_kCamState.MoveFocusPointOnRotationAxes(0, -StickVectorLeft.X * DragPanMultiplierController * DeltaTime, -StickVectorLeft.Y * DragPanMultiplierController * DeltaTime);
			}
			//bsg-jneal (5.2.17): end
		}
	}
}

simulated function RotateInPlace(int Dir)
{
	if (m_bRotationEnabled)
	{
		m_kCamState.AddRotation(0, m_fCameraRotateStep * Dir, 0);
	}

	super.RotateInPlace(Dir);
}

function InitializeFormation()
{
	local array<X2PropagandaPhotoTemplate> arrFormations;
	local int i, FormationIndex;

	FormationIndex = INDEX_NONE;
	`PHOTOBOOTH.GetFormations(arrFormations);
	for (i = 0; i < arrFormations.Length; ++i)
	{
		if (arrFormations[i].DataName == name("Solo"))
		{
			FormationIndex = i;
			break;
		}
	}

	FormationIndex = FormationIndex != INDEX_NONE ? FormationIndex : `SYNC_RAND(arrFormations.Length);

	if (DefaultSetupSettings.FormationTemplate == none)
	{
		DefaultSetupSettings.FormationTemplate = arrFormations[FormationIndex];
	}

	SetFormation(FormationIndex);
}

//bsg-jedwards (5.4.17) : Moved to child to handle all 6 presets
public function ChangeCameraPresetView(int SpinnerValue)
{
	local int PresetIndex;

	switch (SpinnerValue)
	{
	case 0 :
		OnCameraPresetHeadshot();
		PresetIndex = 1;
		break;
	case 1:
		OnCameraPresetTight();
		PresetIndex = 5;
		break;
	case 2:
		OnCameraPresetFullBody();
		PresetIndex = 0;
		break;
	case 3:
		OnCameraPresetHigh();
		PresetIndex = 2;
		break;
	case 4:
		OnCameraPresetLow();
		PresetIndex = 3;
		break;
	case 5:
		OnCameraPresetProfile();
		PresetIndex = 4;
		break;
	}

	MC.FunctionNum("setPresetHighlight", PresetIndex);
}
//bsg-jedwards (5.4.17) : end

function RandomSetBackground()
{
	local array<string> ItemNames;
	local int ItemIndex;

	GetBackgroundData(ItemNames, ItemIndex, ePBT_XCOM);
	SetBackground(`SYNC_RAND(ItemNames.length), ePBT_XCOM, false);
}

function bool RandomSetCamera()
{
	local array<PhotoboothCameraPreset> arrCameraPresets;
	local PhotoboothCameraSettings CameraSettings;
	local int CameraIndex;

	//bsg-jedwards (5.1.17) : Allows the spinner value in photobooth base to update 
	`PHOTOBOOTH.GetCameraPresets(arrCameraPresets);

	CameraIndex = `SYNC_RAND(arrCameraPresets.Length);

	
	if(`ISCONTROLLERACTIVE)
		ModeSpinnerVal = CameraIndex;
	//bsg-jedwards (5.1.17) : end

	`PHOTOBOOTH.GetCameraPresets(arrCameraPresets);
	if (`PHOTOBOOTH.GetCameraPOVForPreset(arrCameraPresets[CameraIndex], CameraSettings))
	{
		UpdateCameraToPOV(CameraSettings, false);
		return true;
	}

	return false;
}

function CreatePosterCallback(StateObjectReference UnitRef)
{
	bWaitingOnPhoto = false;
	`HQPres.PhotoboothReview();
	Movie.Pres.UICloseProgressDialog();
}

simulated function CloseScreen()
{
	class'Engine'.static.GetEngine().GameViewport.bRenderEmptyScene = false;

	super.CloseScreen();
}

defaultproperties
{
	bProcessMouseEventsIfNotFocused = false
	m_fCameraZoomStep=2.0f
	m_fCameraRotateStep=2.5f
	m_fCameraMoveStep = 4.0f

	m_fCameraFOV = 90
}
