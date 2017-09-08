//---------------------------------------------------------------------------------------
//  *********   FIRAXIS SOURCE CODE   ******************
//  FILE:    UITactical_Photobooth.uc
//  AUTHOR:  Scott Boeckmann
//  PURPOSE: Used as a basis for taking a photograph of soldier after a mission
//---------------------------------------------------------------------------------------
//  Copyright (c) 2009-2016 Firaxis Games, Inc. All rights reserved.
//--------------------------------------------------------------------------------------- 

class UITactical_Photobooth extends UIPhotoboothBase
	config(Content);

var XComGameState_BattleData BattleData;

var X2Photobooth_TacticalLocationController m_kTacticalLocation;

var X2Camera_Photobooth m_kStudioCamera;

var localized string m_LocationStr;
var localized string m_LocationTitle;

var float m_fCameraZoomStep;
var float m_fCameraRotateStep;

var Rotator m_fLastCamRotation;
var Vector m_vLastCamOffset;
var float m_fLastViewDistance;
var bool bChangingLocation;
simulated function OnInit()
{
	local XComChallengeModeManager ChallengeModeManager;

	m_kTacticalLocation = new class'X2Photobooth_TacticalLocationController';

	class'Engine'.static.GetEngine().GameViewport.bRenderEmptyScene = true;

	super.OnInit();

	m_PresetLow.SetDisabled(true);

	DefaultSetupSettings.CameraPresetDisplayName = "Full Frontal";
	if (bChallengeMode)
	{
		ChallengeModeManager = XComEngine(Class'GameEngine'.static.GetEngine()).ChallengeModeManager;

		DefaultSetupSettings.GeneratedText.AddItem(`PHOTOBOOTH.m_ChallengeModeStr);
		DefaultSetupSettings.GeneratedText.AddItem(`PHOTOBOOTH.m_ChallengeModeScoreLabel @ string(ChallengeModeManager.GetTotalScore()));
	}
	
	BATTLE().SetFOW(false);

	//bsg-jedwards (5.4.17) : Changed to accomodate 5 presets instead of 6
	if(`ISCONTROLLERACTIVE)
	{
		m_CameraPresets_Labels.AddItem(m_strCameraPresetLabel_Headshot);
		m_CameraPresets_Labels.AddItem(m_strCameraPresetLabel_Tight);
		m_CameraPresets_Labels.AddItem(m_strCameraPresetLabel_FullBody);
		m_CameraPresets_Labels.AddItem(m_strCameraPresetLabel_High);
		m_CameraPresets_Labels.AddItem(m_strCameraPresetLabel_Profile);
		max_SpinnerVal = 4;
	}
	//bsg-jedwards (5.4.17) : end
}

function ZoomIn()
{
	m_kStudioCamera.ZoomCamera(-m_fCameraZoomStep);
}
function ZoomOut()
{
	m_kStudioCamera.ZoomCamera(m_fCameraZoomStep);
}
event Tick(float DeltaTime)
{
	local Vector2D MouseDelta;
	if (bIsFocused)
	{
		super.Tick(DeltaTime);

		// KDERDA - Move this to it's respective subclass to avoid log spam.
		if (XComTacticalInput(PC.PlayerInput) != none)
		{
			StickVectorLeft.x = XComTacticalInput(PC.PlayerInput).m_fLSXAxis;
			StickVectorLeft.y = XComTacticalInput(PC.PlayerInput).m_fLSYAxis;
			StickVectorRight.x = XComTacticalInput(PC.PlayerInput).m_fRSXAxis;
			StickVectorRight.y = XComTacticalInput(PC.PlayerInput).m_fRSYAxis;
		}

		if (m_bRightMouseIn && !m_bRotatingPawn)
		{
			MouseDelta = Movie.Pres.m_kUIMouseCursor.m_v2MouseFrameDelta;
			Movie.Pres.m_kUIMouseCursor.UpdateMouseLocation();
			
			//bsg-jneal (5.2.17): controller input for camera, right stick for rotation, left for pan
			if (!`ISCONTROLLERACTIVE)
			{
				m_kStudioCamera.AddRotation(MouseDelta.Y * DragRotationMultiplier, -1 * MouseDelta.X * DragRotationMultiplier, 0);
			}
			else
			{
				m_kStudioCamera.AddRotation(StickVectorRight.Y * StickRotationMultiplier * DeltaTime, StickVectorRight.X * StickRotationMultiplier * DeltaTime, 0);
			}
			//bsg-jneal (5.2.17): end
		}

		if (m_bMouseIn && !m_bRotatingPawn)
		{
			MouseDelta = Movie.Pres.m_kUIMouseCursor.m_v2MouseFrameDelta;
			Movie.Pres.m_kUIMouseCursor.UpdateMouseLocation();
			
			//bsg-jneal (5.2.17): controller input for camera, right stick for rotation, left for pan
			if (!`ISCONTROLLERACTIVE)
			{
				m_kStudioCamera.MoveFocusPointOnRotationAxes(0, -1 * MouseDelta.X * DragPanMultiplier * m_kStudioCamera.GetZoomPercentage(), MouseDelta.Y * DragPanMultiplier * m_kStudioCamera.GetZoomPercentage());
			}
			else
			{
				m_kStudioCamera.MoveFocusPointOnRotationAxes(0, -StickVectorLeft.X * DragPanMultiplierController * DeltaTime, -StickVectorLeft.Y * DragPanMultiplierController * DeltaTime);
			}
			//bsg-jneal (5.2.17): end
		}
	}
}

function InitTabButtons()
{
	InitCameraButton();
}

function UpdateNavHelp()
{
	if (NavHelp == none)
	{
		NavHelp = Spawn(class'UINavigationHelp', self).InitNavHelp();
	}

	//bsg-jneal (5.2.17): navhelp fixes for controller
	NavHelp.ClearButtonHelp();
	NavHelp.bIsVerticalHelp = `ISCONTROLLERACTIVE; //bsg-hlee (05.16.17): Should only do vertical nav help for controllers.

	NavHelp.AddBackButton(OnCancel);

	//bsg-jneal (5.30.17): no select navhelp if in camera mode
	if(!m_bGamepadCameraActive)
	{
		NavHelp.AddSelectNavHelp();
	}
	//bsg-jneal (5.30.17): end

	if( `ISCONTROLLERACTIVE )
	{
		NavHelp.AddLeftHelp(m_strTakePhoto, class'UIUtilities_Input'.const.ICON_X_SQUARE);

		if (!m_bGamepadCameraActive)
		{
			EnableConsoleControls(false);
		}
		else
		{
			EnableConsoleControls(true);
		}
	}
	else
	{
		//bsg-hlee (05.15.17): Using AddLeftHelp instead of AddLeftButton because AddLeftButton was adding in a two buttons.
		NavHelp.AddLeftHelp(class'UIUtilities_Text'.default.m_strGenericContinue, , CloseScreen); 
	}
	//bsg-jneal (5.2.17): end
}

simulated function InitScreen(XComPlayerController InitController, UIMovie InitMovie, optional name InitName)
{
	super.InitScreen(InitController, InitMovie, InitName);

	if(`ISCONTROLLERACTIVE)
	{
		List.OnSelectionChanged = SelectedItemChanged; //bsg-jneal (4.27.17): update navhelp on list change
	}

	BattleData = XComGameState_BattleData(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_BattleData'));
}

//bsg-jneal (4.27.17): update navhelp on list change
simulated function SelectedItemChanged(UIList ContainerList, int ItemIndex)
{
	UpdateNavHelp();
}
//bsg-jneal (4.27.17): end

function OnChangeStudioLocation(UIListItemSpinner SpinnerControl, int Direction)
{
	local XGParamTag ParamTag;
	local Vector VecX, VecY, VecZ, CamOffset;

	GetAxes(m_vOldCaptureRotator, VecX, VecY, VecZ);

	bChangingLocation = true;
	m_fLastCamRotation = m_kStudioCamera.GetCameraRotation() - m_vOldCaptureRotator;
	CamOffset = m_kStudioCamera.GetCameraOffset() - m_vOldCaptureLocation;
	m_fLastViewDistance = m_kStudioCamera.GetCameraDistance();
	m_vLastCamOffset.X = VecX Dot CamOffset;
	m_vLastCamOffset.Y = VecY Dot CamOffset;
	m_vLastCamOffset.Z = VecZ Dot CamOffset;

	if (Direction == 1)
		m_kTacticalLocation.NextStudio(StudioLoadedUpdateCamera);
	else if(Direction == -1)
		m_kTacticalLocation.PreviousStudio(StudioLoadedUpdateCamera);

	ParamTag = XGParamTag(`XEXPANDCONTEXT.FindTag("XGParam"));
	ParamTag.IntValue0 = m_kTacticalLocation.m_iCurrentStudioIndex + 1;
	SpinnerControl.SetValue(`XEXPAND.ExpandString(m_LocationStr));
}

function PopulateDefaultList(out int Index)
{
	local XGParamTag ParamTag;

	ParamTag = XGParamTag(`XEXPANDCONTEXT.FindTag("XGParam"));
	ParamTag.IntValue0 = m_kTacticalLocation.m_iCurrentStudioIndex + 1;

	GetListItem(Index++).UpdateDataSpinner(m_LocationTitle, `XEXPAND.ExpandString(m_LocationStr), OnChangeStudioLocation);

	super.PopulateDefaultList(Index);
}

/*function PopulateCameraData(out int Index)
{
	GetListItem(Index++).UpdateDataSpinner("Map Location", "Default", OnChangeStudioLocation);

	super.PopulateCameraData(Index);
}*/

function SetupContent()
{
	m_kTacticalLocation.Init(StudioLoaded);
}

function StudioLoaded()
{
	SetupInitialCameraAndCapturePositions();

	`PHOTOBOOTH.MoveFormation(m_kTacticalLocation.GetFormationPlacementActor());
}

function StudioLoadedUpdateCamera()
{
	SetupInitialCameraAndCapturePositions();

	`PHOTOBOOTH.MoveFormation(m_kTacticalLocation.GetFormationPlacementActor());
	NumPawnsNeedingUpdateAfterFormationChange = `PHOTOBOOTH.SetPawnCreatedDelegate(OnFormationLoaded);
}

function TPOV GetCameraPOV()
{
	local TPOV outPOV;
	
	outPOV = m_kStudioCamera.GetCameraLocationAndOrientation();
	outPOV.FOV = m_fCameraFOV;

	return outPOV;
}

function UpdateCameraToPOV(PhotoboothCameraSettings CameraSettings, bool SnapToFinal)
{
	local Vector VecX, VecY, VecZ;
	
	m_kStudioCamera.SetFocusPoint(CameraSettings.RotationPoint);
	m_kStudioCamera.SetCameraRotation(CameraSettings.Rotation);
	m_kStudioCamera.SetViewDistance(CameraSettings.ViewDistance);

	m_vOldCaptureLocation = CameraSettings.RotationPoint;
	m_vOldCaptureRotator = CameraSettings.Rotation;

	if (bChangingLocation)
	{
		GetAxes(m_vOldCaptureRotator, VecX, VecY, VecZ);
		m_kStudioCamera.AddCameraRotation(m_fLastCamRotation);
		m_kStudioCamera.MoveFocusPoint(m_vLastCamOffset.X  * VecX.X, m_vLastCamOffset.X  * VecX.Y, m_vLastCamOffset.X  * VecX.Z);
		m_kStudioCamera.MoveFocusPoint(m_vLastCamOffset.Y  * VecY.X, m_vLastCamOffset.Y  * VecY.Y, m_vLastCamOffset.Y  * VecY.Z);
		m_kStudioCamera.MoveFocusPoint(m_vLastCamOffset.Z  * VecZ.X, m_vLastCamOffset.Z  * VecZ.Y, m_vLastCamOffset.Z  * VecZ.Z);

		CameraSettings.RotationPoint = m_kStudioCamera.GetCameraOffset();
		CameraSettings.Rotation = m_kStudioCamera.GetCameraTargetRotation();
		CameraSettings.ViewDistance = m_fLastViewDistance;
		`PHOTOBOOTH.UpdateViewDistance(CameraSettings);
		m_kStudioCamera.SetViewDistance(CameraSettings.ViewDistance);

		bChangingLocation = false;
	}

	if (SnapToFinal)
	{
		m_kStudioCamera.MoveToFinal();
	}
}

function OnCameraPreset(string selection, optional bool bUpdateViewDistance = true)
{
	super.OnCameraPreset(selection, !bChangingLocation);
}

function SetupInitialCameraAndCapturePositions()
{
	local CameraActor CamActor;

	CamActor = m_kTacticalLocation.GetCameraActor();

	if (CamActor != none)
	{
		if (m_kStudioCamera != none)
		{
			`CAMERASTACK.RemoveCamera(m_kStudioCamera);
		}

		m_kStudioCamera = new class'X2Camera_Photobooth';
		m_kStudioCamera.InitCamera(CamActor, m_kTacticalLocation.GetFormationPlacementActor().Location);
		m_kStudioCamera.SetFOV(m_fCameraFOV);

		`CAMERASTACK.AddCamera(m_kStudioCamera);

		m_bNeedsCaptureOutlineReset = true;
	}
}

function GenerateDefaultSoldierSetup()
{
	local int i, j;
	local array<XComGameState_Unit> arrSoldiers;

	BATTLE().GetHumanPlayer().GetOriginalUnits(arrSoldiers, true, true, true);

	j = 0;
	for (i = 0; i < arrSoldiers.Length && j < 6; ++i) // Check that we are not adding more than 6 units as no formation holds more than 6.
	{
		if (arrSoldiers[i].UnitIsValidForPhotobooth())
		{
			`PHOTOBOOTH.SetSoldier(j, arrSoldiers[i].GetReference());
			DefaultSetupSettings.PossibleSoldiers.AddItem(arrSoldiers[i].GetReference());
			++j;
		}
	}

	Super.GenerateDefaultSoldierSetup();
}

function UpdateSoldierData()
{
	local int i, j;
	local array<XComGameState_Unit> arrSoldiers;

	BATTLE().GetHumanPlayer().GetOriginalUnits(arrSoldiers, true, true, true);

	j = 0;
	for (i = 0; i < arrSoldiers.Length && j < 6; i++) // Check that we are not adding more than 6 units as no formation holds more than 6.
	{
		if (arrSoldiers[i].UnitIsValidForPhotobooth())
		{
			m_arrSoldiers.AddItem(arrSoldiers[i].GetReference());
			++j;
		}
	}

	Super.UpdateSoldierData();
}

//bsg-jneal (3.24.17): override poster creation for tactical photobooth on consoles to improve UI flow
function OnMakePosterSelected(UIButton ButtonControl)
{
	local XComGameState NewGameState;

	if(`ISCONSOLE)
	{
		if (class'X2StrategyGameRulesetDataStructures'.static.Roll(default.PhotoCommentChance))
		{
			NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Trigger Event: Photobooth Comment");
			`XEVENTMGR.TriggerEvent('OnPhotoTaken', , , NewGameState);
			`GAMERULES.SubmitGameState(NewGameState);
		}

		PlayAKEvent(AkEvent'XPACK_SoundStrategyUI.PhotoBooth_CameraFlash');
		MC.FunctionVoid("AnimateFlash");
		`PHOTOBOOTH.CreatePoster(4, OnContinueFromTactical);
		`PHOTOBOOTH.m_kAutoGenCaptureState = eAGCS_Capturing; //bsg-hlee (4.10.17): Need to state to capturing so that SavePosterAndFinish() can complete and popup can close.
	}
	else
	{
		super.OnMakePosterSelected(ButtonControl);
	}
}

function OnContinueFromTactical(StateObjectReference UnitRef)
{
	Movie.Pres.UICloseProgressDialog();
	OnDestructiveActionPopupExitDialog('eUIAction_Accept');
}
//bsg-jneal (3.24.17): end

static function XGBattle_SP BATTLE()
{
	return XGBattle_SP(`BATTLE);
}

//==============================================================================
//		CAMERA HANDLING:
//==============================================================================

//bsg-jedwards (5.4.17) : Uses less camera presets than the Armory Photobooth
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
		OnCameraPresetProfile();
		PresetIndex = 4;
		break;
	}

	MC.FunctionNum("setPresetHighlight", PresetIndex);
	MC.FunctionNum("setPresetDisabled", 3);//disable the low camera icon for tactical
}
//bsg-jedwards (5.4.17) : end

//==============================================================================
//		INPUT HANDLING:
//==============================================================================
simulated function bool OnUnrealCommand(int ucmd, int arg)
{
	switch (ucmd)
	{
		// Tactical is weird with scrollbar.
	case class'UIUtilities_Input'.const.FXS_KEY_F:
		if (IsMouseInPoster())
		{
			ZoomIn();
		}
		break;
	case class'UIUtilities_Input'.const.FXS_KEY_C:
		if (IsMouseInPoster())
		{
			ZoomOut();
		}
		break;
	}

	return super.OnUnrealCommand(ucmd, arg);
}

//==============================================================================
//		CLEANUP:
//==============================================================================
simulated function CloseScreen()
{
	local bool bUserPhotoTaken;
	class'Engine'.static.GetEngine().GameViewport.bRenderEmptyScene = false;

	bUserPhotoTaken = false;
	if (`ScreenStack.IsInStack(class'UIMissionSummary'))
	{
		bUserPhotoTaken = UIMissionSummary(`ScreenStack.GetFirstInstanceOf(class'UIMissionSummary')).bUserPhotoTaken;
	}
	else if (`ScreenStack.IsInStack(class'UIChallengePostScreen'))
	{
		bUserPhotoTaken = UIChallengePostScreen(`ScreenStack.GetFirstInstanceOf(class'UIChallengePostScreen')).bUserPhotoTaken;
	}

	if (!bUserPhotoTaken)
	{
		`PRESBASE.GetPhotoboothMovie().RemoveScreen(`PHOTOBOOTH.m_backgroundPoster);
		Movie.Pres.PlayUISound(eSUISound_MenuClose);

		Movie.Pres.ScreenStack.Pop(self);

		if (`ScreenStack.IsInStack(class'UIMissionSummary'))
		{
			UIMissionSummary(`ScreenStack.GetFirstInstanceOf(class'UIMissionSummary')).CloseScreenTakePhoto();
		}
		else if (`ScreenStack.IsInStack(class'UIChallengePostScreen'))
		{
			UIChallengePostScreen(`ScreenStack.GetFirstInstanceOf(class'UIChallengePostScreen')).CloseScreenTakePhoto();
		}
	}
	else
	{
		super.CloseScreen();
	}
}

function InitializeFormation()
{
	local array<X2PropagandaPhotoTemplate> arrFormations;
	local array<int> arrFilteredFormationIndices;
	local int i, FormationIndex;

	FormationIndex = INDEX_NONE;
	`PHOTOBOOTH.GetFormations(arrFormations);

	if (m_arrSoldiers.Length == 1)
	{
		for (i = 0; i < arrFormations.Length; ++i)
		{
			if (arrFormations[i].DataName == name("Solo"))
			{
				FormationIndex = i;
				break;
			}
		}
	}
	else if (m_arrSoldiers.Length == 2)
	{
		for (i = 0; i < arrFormations.Length; ++i)
		{
			if (arrFormations[i].DataName == name("Duo"))
			{
				FormationIndex = i;
				break;
			}
		}
	}
	else
	{
		for (i = 0; i < arrFormations.Length; ++i)
		{
			if (arrFormations[i].DataName != name("Solo") && arrFormations[i].DataName != name("Duo"))
			{
				arrFilteredFormationIndices.AddItem(i);
			}
		}

		if (arrFilteredFormationIndices.Length > 0)
		{
			FormationIndex = arrFilteredFormationIndices[`SYNC_RAND(arrFilteredFormationIndices.Length)];
		}
	}

	FormationIndex = FormationIndex != INDEX_NONE ? FormationIndex : `SYNC_RAND(arrFormations.Length);

	if (DefaultSetupSettings.FormationTemplate == none)
	{
		DefaultSetupSettings.FormationTemplate = arrFormations[FormationIndex];
	}

	SetFormation(FormationIndex);
}

function RandomSetBackground()
{
	local array<string> ItemNames;
	local int ItemIndex, i;

	GetBackgroundData(ItemNames, ItemIndex, ePBT_XCOM);

	ItemIndex = INDEX_NONE;
	for (i = 0; i < ItemNames.Length; ++i)
	{
		if (ItemNames[i] == "None")
		{
			ItemIndex = i;
			break;
		}
	}

	SetBackground(ItemIndex != INDEX_NONE ? ItemIndex : `SYNC_RAND(ItemNames.Length), ePBT_XCOM, false);
}

function bool RandomSetCamera()
{
	local array<PhotoboothCameraPreset> arrCameraPresets;
	local PhotoboothCameraSettings CameraSettings;
	local int CameraIndex, i;

	`PHOTOBOOTH.GetCameraPresets(arrCameraPresets);
	for (i = 0; i < arrCameraPresets.Length; ++i)
	{
		if (arrCameraPresets[i].TemplateName == "Low")
		{
			arrCameraPresets.Remove(i, 1);
			break;
		}
	}

	CameraIndex = `SYNC_RAND(arrCameraPresets.Length);

	//bsg-jedwards (5.1.17) : Allows the photobooth base to update from the random camera index
	if(`ISCONTROLLERACTIVE)
		ModeSpinnerVal = CameraIndex;
	//bsg-jedwards (5.1.17) : end

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
	if (`ScreenStack.IsInStack(class'UIMissionSummary'))
	{
		UIMissionSummary(`ScreenStack.GetFirstInstanceOf(class'UIMissionSummary')).bUserPhotoTaken = true;
	}
	else if (`ScreenStack.IsInStack(class'UIChallengePostScreen'))
	{
		UIChallengePostScreen(`ScreenStack.GetFirstInstanceOf(class'UIChallengePostScreen')).bUserPhotoTaken = true;
	}
	Movie.Pres.UICloseProgressDialog();
}

DefaultProperties
{
	InputState = eInputState_Consume;
	
	bChangingLocation = false;
	bConsumeMouseEvents = true;
	bShowDuringCinematic = true;
	//bUpdateCameraWithFormation = false;

	m_fCameraFOV=75

	m_fCameraZoomStep = 8.0f
	m_fCameraRotateStep = 2.5f

	bDestroyPhotoboothPawnsOnCleanup = false
}
