//---------------------------------------------------------------------------------------
//  *********   FIRAXIS SOURCE CODE   ******************
//  FILE:    UIDebugMarketing
//  AUTHOR:  Ryan McFall
//
//  PURPOSE: Provides a user interface for manipulating marketing controls
//
//---------------------------------------------------------------------------------------
//  Copyright (c) 2009-2016 Firaxis Games, Inc. All rights reserved.
//--------------------------------------------------------------------------------------- 

class UIDebugMarketing extends UIScreen;

var XComOnlineProfileSettings	ProfileSettings;
var XComPresentationLayer		Pres;
var XComPlayerController		PlayerController;
var XComTacticalInput			TacticalInput;

var XComCheatManager				GeneralCheatManager;
var XComTacticalCheatManager		TacticalCheatManager;
var XComHeadquartersCheatManager	StrategyCheatManager;

//UI controls
var UIPanel		AllContainer;
var UIPanel     FrameInfoContainer;
var UIBGBox		InfoBG;
var UIText		InfoTitle;
var UIText		InfoText;

var UIButton	Button_AcceptChanges;
var UICheckbox  Checkbox_2DUI;
var UICheckbox  Checkbox_3DUI;
var UICheckbox  Checkbox_UnitFlags;
var UICheckbox  Checkbox_WorldMessages;
var UICheckbox  Checkbox_DisableTutorialPopups;
var UICheckbox  Checkbox_LootEffects;
var UICheckbox  Checkbox_Narrative;
var UICheckbox  Checkbox_FOW;
var UICheckbox  Checkbox_BuildingVisibility;
var UICheckbox  Checkbox_ProximityDither;
var UICheckbox  Checkbox_CutoutBox;
var UICheckbox	Checkbox_PeripheryHiding;
var UICheckbox  Checkbox_Pathing;
var UICheckbox  Checkbox_SoldierChatter;
var UICheckbox  Checkbox_DisableMusic;
var UICheckbox  Checkbox_DisableAmbience;
var UICheckbox  Checkbox_ConcealmentTiles;
var UICheckbox  Checkbox_DisableUnitShaders;
var UICheckbox  Checkbox_DisableTooltips;
var UICheckbox  Checkbox_DisableLookAtBack;

var UIButton	Button_AcceptDOFChanges;
var UIButton	Button_ClearDOFChanges;
var UICheckbox	Checkbox_DOF;
var UISlider	Slider_DOFFocusDistance;
var UISlider	Slider_DOFFocusInnerRadius;
var UISlider	Slider_DOFMaxNearFocus;
var UISlider	Slider_DOFMaxFarFocus;

var PostProcessSettings PPSettings;

//----------------------------------------------------------------------------
// MEMBERS

simulated function InitScreen(XComPlayerController InitController, UIMovie InitMovie, optional name InitName)
{	
	super.InitScreen(InitController, InitMovie, InitName);

	AllContainer         = Spawn(class'UIPanel', self);

	FrameInfoContainer = Spawn(class'UIPanel', self);
	InfoBG   = Spawn(class'UIBGBox', FrameInfoContainer);
	InfoTitle= Spawn(class'UIText', FrameInfoContainer);
	InfoText = Spawn(class'UIText', FrameInfoContainer);

	AllContainer.InitPanel('allContainer');
	AllContainer.SetPosition(50, 50);
	AllContainer.SetAnchor(class'UIUtilities'.const.ANCHOR_TOP_LEFT);

	FrameInfoContainer.InitPanel('InfoContainer');
	FrameInfoContainer.SetPosition(50, 50);
	FrameInfoContainer.SetAnchor(class'UIUtilities'.const.ANCHOR_TOP_LEFT);

	InfoBG.InitBG('infoBox', 0, 0, 500, 800);
	InfoTitle.InitText('infoBoxTitle', "<Empty>", true);
	InfoTitle.SetWidth(300);
	InfoTitle.SetX(10);
	InfoTitle.SetY(60);
	InfoText.InitText('infoBoxText', "<Empty>", true);
	InfoText.SetWidth(300);
	InfoText.SetX(10);
	InfoText.SetY(50);

	Button_AcceptChanges = Spawn(class'UIButton', FrameInfoContainer);
	Button_AcceptChanges.InitButton('applyChanges', "Apply Changes", ApplyChanges, eUIButtonStyle_HOTLINK_BUTTON);
	Button_AcceptChanges.SetAnchor(class'UIUtilities'.const.ANCHOR_TOP_LEFT);
	Button_AcceptChanges.SetX(100);
	Button_AcceptChanges.SetY(850);
	
	Button_AcceptDOFChanges = Spawn(class'UIButton', FrameInfoContainer);
	Button_AcceptDOFChanges.InitButton('applyDofChanges', "Apply DOF Changes", ApplyDOFChanges, eUIButtonStyle_HOTLINK_BUTTON);
	Button_AcceptDOFChanges.SetAnchor(class'UIUtilities'.const.ANCHOR_TOP_LEFT);
	Button_AcceptDOFChanges.SetX(100);
	Button_AcceptDOFChanges.SetY(900);


	Button_ClearDOFChanges = Spawn(class'UIButton', FrameInfoContainer);
	Button_ClearDOFChanges.InitButton('clearDofChanges', "Clear DOF Changes", ClearDOFChanges, eUIButtonStyle_HOTLINK_BUTTON);
	Button_ClearDOFChanges.SetAnchor(class'UIUtilities'.const.ANCHOR_TOP_LEFT);
	Button_ClearDOFChanges.SetX(300);
	Button_ClearDOFChanges.SetY(900);
	

	InitializeMarketingControls();

	SetTimer(0.1f, false, nameof(InitCheckboxes));

	PlayerController = InitController;
	TacticalInput = XComTacticalInput(PlayerController.PlayerInput);
	
	Pres = XComPresentationLayer(PC.Pres);	

	TacticalCheatManager = XComTacticalCheatManager(PC.CheatManager);
	StrategyCheatManager = XComHeadquartersCheatManager(PC.CheatManager);
	GeneralCheatManager = XComCheatManager(PC.CheatManager);

	//Automatically disable redscreens when entering marketing mode
	`XENGINE.TemporarilyDisableRedscreens();

	ProfileSettings = `XPROFILESETTINGS;
}

function CreatePPSettings()
{
	PPSettings.bOverride_EnableBloom = FALSE;
	PPSettings.bOverride_EnableDOF = FALSE;
	PPSettings.bOverride_EnableMotionBlur = FALSE;
	PPSettings.bOverride_EnableSceneEffect = FALSE;
	PPSettings.bOverride_AllowAmbientOcclusion = FALSE;
	PPSettings.bOverride_OverrideRimShaderColor = FALSE;
	PPSettings.bOverride_Bloom_Scale = FALSE;
	PPSettings.bOverride_Bloom_Threshold = FALSE;
	PPSettings.bOverride_Bloom_Variance = FALSE;
	PPSettings.bOverride_Bloom_TemporalLowEnd = FALSE;
	PPSettings.bOverride_Bloom_TemporalHighEnd = FALSE;
	PPSettings.bOverride_DirtyLens_Texture = FALSE;
	PPSettings.bOverride_DirtyLens_Scale = FALSE;
	PPSettings.bOverride_DirtyLens_TileTexture = FALSE;
	PPSettings.bOverride_Bloom_InterpolationDuration = FALSE;
	PPSettings.bOverride_DOF_FalloffExponent = FALSE;
	PPSettings.bOverride_DOF_BlurKernelSize = FALSE;
	PPSettings.bOverride_DOF_MaxNearBlurAmount = FALSE;
	PPSettings.bOverride_DOF_MinBlurAmount = FALSE;
	PPSettings.bOverride_DOF_MaxFarBlurAmount = FALSE;
	PPSettings.bOverride_DOF_FocusType = FALSE;
	PPSettings.bOverride_DOF_FocusInnerRadius = FALSE;
	PPSettings.bOverride_DOF_FocusDistance = FALSE;
	PPSettings.bOverride_DOF_FocusPosition = FALSE;
	PPSettings.bOverride_DOF_InterpolationDuration = TRUE;
	PPSettings.bOverride_DOF_BokehTexture = FALSE;
	PPSettings.bOverride_DOF_NearFocusStart = FALSE;
	PPSettings.bOverride_DOF_NearFocusEnd = FALSE;
	PPSettings.bOverride_DOF_FarFocusStart = FALSE;
	PPSettings.bOverride_DOF_FarFocusEnd = FALSE;
	PPSettings.bOverride_MotionBlur_MaxVelocity = FALSE;
	PPSettings.bOverride_MotionBlur_Amount = FALSE;
	PPSettings.bOverride_MotionBlur_FullMotionBlur = FALSE;
	PPSettings.bOverride_MotionBlur_CameraRotationThreshold = FALSE;
	PPSettings.bOverride_MotionBlur_CameraTranslationThreshold = FALSE;
	PPSettings.bOverride_MotionBlur_InterpolationDuration = FALSE;
	PPSettings.bOverride_Scene_Desaturation = FALSE;
	PPSettings.bOverride_Scene_Colorize = FALSE;
	PPSettings.bOverride_Scene_TonemapperScale = FALSE;
	PPSettings.bOverride_Scene_ImageGrainScale = FALSE;
	PPSettings.bOverride_Scene_HighLights = FALSE;
	PPSettings.bOverride_Scene_MidTones = FALSE;
	PPSettings.bOverride_Scene_Shadows = FALSE;
	PPSettings.bOverride_Scene_InterpolationDuration = FALSE;
	PPSettings.bOverride_Scene_ColorGradingLUT = FALSE;
	PPSettings.bOverride_RimShader_Color = FALSE;
	PPSettings.bOverride_RimShader_InterpolationDuration = FALSE;
	PPSettings.bOverride_MagneticChromaticAbberation = FALSE;
	PPSettings.bOverride_SSAO_InterpolationDuration = FALSE;
	PPSettings.bOverride_SSAO_Power = FALSE;
	PPSettings.bOverride_SSAO_Scale = FALSE;
	PPSettings.bOverride_SSAO_Bias = FALSE;
	PPSettings.bOverride_SSAO_MinOcclusion = FALSE;
	PPSettings.bOverride_SSAO_OcclusionRadius = FALSE;
	PPSettings.bOverride_SSAO_HaloDistanceThreshold = FALSE;
	PPSettings.bOverride_SSAO_FadeoutMinDistance = FALSE;
	PPSettings.bOverride_SSAO_FadeoutMaxDistance = FALSE;
	PPSettings.bOverride_Scene_ExposureAdjustment = FALSE;
	PPSettings.bOverride_Scene_CurveOutputAdjustment = FALSE;
	PPSettings.bOverride_ShowFog = FALSE;
}

function InitializeMarketingControls()
{
	local int PositionX;
	local int PositionY;
	local int Spacing;

	PositionX = 10;
	PositionY = 10;
	Spacing = 30;

	Checkbox_2DUI = Spawn(class'UICheckbox', FrameInfoContainer);
	Checkbox_2DUI.InitCheckbox('Checkbox_UI2D', "Hide 2D UI", false, ToggleCheckbox);
	Checkbox_2DUI.SetTextStyle(class'UICheckbox'.const.STYLE_TEXT_ON_THE_RIGHT).SetPosition(PositionX, PositionY);	

	PositionY += Spacing;

	Checkbox_3DUI = Spawn(class'UICheckbox', FrameInfoContainer);
	Checkbox_3DUI.InitCheckbox('Checkbox_UI3D', "Hide 3D UI", false, ToggleCheckbox);
	Checkbox_3DUI.SetTextStyle(class'UICheckbox'.const.STYLE_TEXT_ON_THE_RIGHT).SetPosition(PositionX, PositionY);

	PositionY += Spacing;

	Checkbox_UnitFlags = Spawn(class'UICheckbox', FrameInfoContainer);
	Checkbox_UnitFlags.InitCheckbox('Checkbox_UnitFlags', "Hide Unit Flags", false, ToggleCheckbox);
	Checkbox_UnitFlags.SetTextStyle(class'UICheckbox'.const.STYLE_TEXT_ON_THE_RIGHT).SetPosition(PositionX, PositionY);

	PositionY += Spacing;

	Checkbox_WorldMessages = Spawn(class'UICheckbox', FrameInfoContainer);
	Checkbox_WorldMessages.InitCheckbox('Checkbox_WorldMessages', "Hide Flyovers", false, ToggleCheckbox);
	Checkbox_WorldMessages.SetTextStyle(class'UICheckbox'.const.STYLE_TEXT_ON_THE_RIGHT).SetPosition(PositionX, PositionY);

	PositionY += Spacing;

	Checkbox_DisableTutorialPopups = Spawn(class'UICheckbox', FrameInfoContainer);
	Checkbox_DisableTutorialPopups.InitCheckbox('Checkbox_DisableTutorialPopups', "Tutorial Popups OFF", false, ToggleCheckbox);
	Checkbox_DisableTutorialPopups.SetTextStyle(class'UICheckbox'.const.STYLE_TEXT_ON_THE_RIGHT).SetPosition(PositionX, PositionY);

	PositionY += Spacing;

	Checkbox_LootEffects = Spawn(class'UICheckbox', FrameInfoContainer);
	Checkbox_LootEffects.InitCheckbox('Checkbox_LootEffects', "Hide Loot UI", false, ToggleCheckbox);
	Checkbox_LootEffects.SetTextStyle(class'UICheckbox'.const.STYLE_TEXT_ON_THE_RIGHT).SetPosition(PositionX, PositionY);

	PositionY += Spacing;

	Checkbox_Narrative = Spawn(class'UICheckbox', FrameInfoContainer);
	Checkbox_Narrative.InitCheckbox('Checkbox_HideNarrative', "Hide Narrative", false, ToggleCheckbox);
	Checkbox_Narrative.SetTextStyle(class'UICheckbox'.const.STYLE_TEXT_ON_THE_RIGHT).SetPosition(PositionX, PositionY);

	PositionY += Spacing;

	Checkbox_FOW = Spawn(class'UICheckbox', FrameInfoContainer);
	Checkbox_FOW.InitCheckbox('Checkbox_FOW', "Hide FOW", false, ToggleCheckbox);
	Checkbox_FOW.SetTextStyle(class'UICheckbox'.const.STYLE_TEXT_ON_THE_RIGHT).SetPosition(PositionX, PositionY);

	PositionY += Spacing;

	Checkbox_BuildingVisibility = Spawn(class'UICheckbox', FrameInfoContainer);
	Checkbox_BuildingVisibility.InitCheckbox('Checkbox_BuildingVisibility', "Building Visibility OFF", false, ToggleCheckbox);
	Checkbox_BuildingVisibility.SetTextStyle(class'UICheckbox'.const.STYLE_TEXT_ON_THE_RIGHT).SetPosition(PositionX, PositionY);

	PositionY += Spacing;

	Checkbox_ProximityDither = Spawn(class'UICheckbox', FrameInfoContainer);
	Checkbox_ProximityDither.InitCheckbox('Checkbox_ProximityDither', "Proximity Dither Off", false, ToggleCheckbox);
	Checkbox_ProximityDither.SetTextStyle(class'UICheckbox'.const.STYLE_TEXT_ON_THE_RIGHT).SetPosition(PositionX, PositionY);
	
	PositionY += Spacing;

	Checkbox_CutoutBox = Spawn(class'UICheckbox', FrameInfoContainer);
	Checkbox_CutoutBox.InitCheckbox('Checkbox_CutoutBox', "Cutout Box OFF", false, ToggleCheckbox);
	Checkbox_CutoutBox.SetTextStyle(class'UICheckbox'.const.STYLE_TEXT_ON_THE_RIGHT).SetPosition(PositionX, PositionY);

	PositionY += Spacing;
	
	Checkbox_PeripheryHiding = Spawn(class'UICheckbox', FrameInfoContainer);
	Checkbox_PeripheryHiding.InitCheckbox('Checkbox_PeripheryHiding', "Periphery Hiding OFF", false, ToggleCheckbox);
	Checkbox_PeripheryHiding.SetTextStyle(class'UICheckbox'.const.STYLE_TEXT_ON_THE_RIGHT).SetPosition(PositionX, PositionY);

	PositionY += Spacing;

	Checkbox_Pathing = Spawn(class'UICheckbox', FrameInfoContainer);
	Checkbox_Pathing.InitCheckbox('Checkbox_Pathing', "Pathing & Cover UI OFF", false, ToggleCheckbox);
	Checkbox_Pathing.SetTextStyle(class'UICheckbox'.const.STYLE_TEXT_ON_THE_RIGHT).SetPosition(PositionX, PositionY);

	PositionY += Spacing;

	Checkbox_SoldierChatter = Spawn(class'UICheckbox', FrameInfoContainer);
	Checkbox_SoldierChatter.InitCheckbox('Checkbox_SoldierChatter', "Soldier Chatter OFF", false, ToggleCheckbox);
	Checkbox_SoldierChatter.SetTextStyle(class'UICheckbox'.const.STYLE_TEXT_ON_THE_RIGHT).SetPosition(PositionX, PositionY);

	PositionY += Spacing;

	Checkbox_DisableMusic = Spawn(class'UICheckbox', FrameInfoContainer);
	Checkbox_DisableMusic.InitCheckbox('Checkbox_DisableMusic', "Music OFF", false, ToggleCheckbox);
	Checkbox_DisableMusic.SetTextStyle(class'UICheckbox'.const.STYLE_TEXT_ON_THE_RIGHT).SetPosition(PositionX, PositionY);

	PositionY += Spacing;

	Checkbox_DisableAmbience = Spawn(class'UICheckbox', FrameInfoContainer);
	Checkbox_DisableAmbience.InitCheckbox('Checkbox_DisableAmbience', "Ambience OFF", false, ToggleCheckbox);
	Checkbox_DisableAmbience.SetTextStyle(class'UICheckbox'.const.STYLE_TEXT_ON_THE_RIGHT).SetPosition(PositionX, PositionY);

	PositionY += Spacing;

	Checkbox_ConcealmentTiles = Spawn(class'UICheckbox', FrameInfoContainer);
	Checkbox_ConcealmentTiles.InitCheckbox('Checkbox_ConcealmentTiles', "Concealment Tiles OFF", false, ToggleCheckbox);
	Checkbox_ConcealmentTiles.SetTextStyle(class'UICheckbox'.const.STYLE_TEXT_ON_THE_RIGHT).SetPosition(PositionX, PositionY);

	PositionY += Spacing;

	Checkbox_DisableUnitShaders = Spawn(class'UICheckbox', FrameInfoContainer);
	Checkbox_DisableUnitShaders.InitCheckbox('Checkbox_DisableUnitShaders', "Unit Shaders (scanline/outline) OFF", false, ToggleCheckbox);
	Checkbox_DisableUnitShaders.SetTextStyle(class'UICheckbox'.const.STYLE_TEXT_ON_THE_RIGHT).SetPosition(PositionX, PositionY);

	PositionY += Spacing;

	Checkbox_DisableTooltips = Spawn(class'UICheckbox', FrameInfoContainer);
	Checkbox_DisableTooltips.InitCheckbox('Checkbox_DisableTooltips', "Tooltips OFF", false, ToggleCheckbox);
	Checkbox_DisableTooltips.SetTextStyle(class'UICheckbox'.const.STYLE_TEXT_ON_THE_RIGHT).SetPosition(PositionX, PositionY);

	PositionY += Spacing;

	Checkbox_DisableLookAtBack = Spawn(class'UICheckbox', FrameInfoContainer);
	Checkbox_DisableLookAtBack.InitCheckbox('Checkbox_DisableLookAtBack', "OTS LookAtBack Penalty OFF", false, ToggleCheckbox);
	Checkbox_DisableLookAtBack.SetTextStyle(class'UICheckbox'.const.STYLE_TEXT_ON_THE_RIGHT).SetPosition(PositionX, PositionY);

	PositionY += Spacing;

	Checkbox_DOF = Spawn(class'UICheckbox', FrameInfoContainer);
	Checkbox_DOF.InitCheckbox('Checkbox_DOF', "Enable DOF", false, ToggleCheckbox);
	Checkbox_DOF.SetTextStyle(class'UICheckbox'.const.STYLE_TEXT_ON_THE_RIGHT).SetPosition(PositionX, PositionY);

	PositionY += Spacing;

	Slider_DOFFocusDistance = Spawn(class'UISlider', FrameInfoContainer);
	Slider_DOFFocusDistance.InitSlider('Slider_FocusDist', "Focus Distance", 30, DOFPercentChanged, 1).SetPosition(PositionX, PositionY);

	PositionY += Spacing;

	Slider_DOFFocusInnerRadius = Spawn(class'UISlider', FrameInfoContainer);
	Slider_DOFFocusInnerRadius.InitSlider('Slider_FocusInnerRadius', "Focus Radius", 30, DOFPercentChanged, 1).SetPosition(PositionX, PositionY);

	PositionY += Spacing;

	Slider_DOFMaxNearFocus = Spawn(class'UISlider', FrameInfoContainer);
	Slider_DOFMaxNearFocus.InitSlider('Slider_FocusNearMax', "Max Near Blur", 30, DOFPercentChanged, 1).SetPosition(PositionX, PositionY);

	PositionY += Spacing;

	Slider_DOFMaxFarFocus = Spawn(class'UISlider', FrameInfoContainer);
	Slider_DOFMaxFarFocus.InitSlider('Slider_FocusFarMaxs', "Max Far Blur", 80, DOFPercentChanged, 1).SetPosition(PositionX, PositionY);
}

simulated function InitCheckboxes()
{
	if (LocalPlayer(PlayerController.Player).GetMainActivePPOverride(PPSettings) == false)
	{
		CreatePPSettings();
	}

	if(!GeneralCheatManager.bLoadedMarketingPresets)
	{
		GeneralCheatManager.bLoadedMarketingPresets = true;
				
		Checkbox_2DUI.SetChecked(ProfileSettings.Data.MarketingPresets.CheckboxSettings.Find('Checkbox_2DUI') != INDEX_NONE);
		Checkbox_3DUI.SetChecked(ProfileSettings.Data.MarketingPresets.CheckboxSettings.Find('Checkbox_3DUI') != INDEX_NONE);

		if(TacticalCheatManager != none)
		{
			Checkbox_UnitFlags.SetChecked(ProfileSettings.Data.MarketingPresets.CheckboxSettings.Find('Checkbox_UnitFlags') != INDEX_NONE);
			Checkbox_WorldMessages.SetChecked(ProfileSettings.Data.MarketingPresets.CheckboxSettings.Find('Checkbox_WorldMessages') != INDEX_NONE);
			Checkbox_LootEffects.SetChecked(ProfileSettings.Data.MarketingPresets.CheckboxSettings.Find('Checkbox_LootEffects') != INDEX_NONE);
			Checkbox_FOW.SetChecked(ProfileSettings.Data.MarketingPresets.CheckboxSettings.Find('Checkbox_FOW') != INDEX_NONE);
			Checkbox_BuildingVisibility.SetChecked(ProfileSettings.Data.MarketingPresets.CheckboxSettings.Find('Checkbox_BuildingVisibility') != INDEX_NONE);
			Checkbox_ProximityDither.SetChecked(ProfileSettings.Data.MarketingPresets.CheckboxSettings.Find('Checkbox_ProximityDither') != INDEX_NONE);
			Checkbox_CutoutBox.SetChecked(ProfileSettings.Data.MarketingPresets.CheckboxSettings.Find('Checkbox_CutoutBox') != INDEX_NONE);
			Checkbox_PeripheryHiding.SetChecked(ProfileSettings.Data.MarketingPresets.CheckboxSettings.Find('Checkbox_PeripheryHiding') != INDEX_NONE);
			Checkbox_Pathing.SetChecked(ProfileSettings.Data.MarketingPresets.CheckboxSettings.Find('Checkbox_Pathing') != INDEX_NONE);
			Checkbox_SoldierChatter.SetChecked(ProfileSettings.Data.MarketingPresets.CheckboxSettings.Find('Checkbox_SoldierChatter') != INDEX_NONE);
			Checkbox_DisableAmbience.SetChecked(ProfileSettings.Data.MarketingPresets.CheckboxSettings.Find('Checkbox_DisableAmbience') != INDEX_NONE);
			Checkbox_ConcealmentTiles.SetChecked(ProfileSettings.Data.MarketingPresets.CheckboxSettings.Find('Checkbox_ConcealmentTiles') != INDEX_NONE);
			Checkbox_DisableUnitShaders.SetChecked(ProfileSettings.Data.MarketingPresets.CheckboxSettings.Find('Checkbox_DisableUnitShaders') != INDEX_NONE);
			Checkbox_DisableLookAtBack.SetChecked(ProfileSettings.Data.MarketingPresets.CheckboxSettings.Find('Checkbox_DisableLookAtBack') != INDEX_NONE);
			Checkbox_DisableTutorialPopups.SetChecked(ProfileSettings.Data.MarketingPresets.CheckboxSettings.Find('Checkbox_DisableTutorialPopups') != INDEX_NONE);
			
		}

		if(GeneralCheatManager != none)
		{
			Checkbox_Narrative.SetChecked(ProfileSettings.Data.MarketingPresets.CheckboxSettings.Find('Checkbox_Narrative') != INDEX_NONE);
			Checkbox_DisableMusic.SetChecked(ProfileSettings.Data.MarketingPresets.CheckboxSettings.Find('Checkbox_DisableMusic') != INDEX_NONE);
			Checkbox_DisableTooltips.SetChecked(ProfileSettings.Data.MarketingPresets.CheckboxSettings.Find('Checkbox_DisableTooltips') != INDEX_NONE);
		}
	}
	else
	{
		Checkbox_2DUI.SetChecked(!Pres.Get2DMovie().bIsVisible);
		Checkbox_3DUI.SetChecked(!Pres.Get3DMovie().bIsVisible);

		if(TacticalCheatManager != none)
		{
			Checkbox_UnitFlags.SetChecked(!TacticalCheatManager.bShowUnitFlags);
			Checkbox_WorldMessages.SetChecked(TacticalCheatManager.bDisableWorldMessages);
			Checkbox_LootEffects.SetChecked(class'XComGameState_Cheats'.static.GetCheatsObject().DisableLooting);
			Checkbox_FOW.SetChecked(!`XWORLD.bDebugEnableFOW);
			Checkbox_BuildingVisibility.SetChecked(!TacticalCheatManager.m_bEnableBuildingVisibility_Cheat);
			Checkbox_ProximityDither.SetChecked(!TacticalCheatManager.bEnableProximityDither_Cheat);
			Checkbox_CutoutBox.SetChecked(!TacticalCheatManager.m_bEnableCutoutBox_Cheat);		
			Checkbox_PeripheryHiding.SetChecked(!TacticalCheatManager.m_bEnablePeripheryHiding_Cheat);
			Checkbox_Pathing.SetChecked(TacticalCheatManager.bHidePathingPawn);
			Checkbox_SoldierChatter.SetChecked(!`XPROFILESETTINGS.Data.m_bEnableSoldierSpeech);
			Checkbox_DisableAmbience.SetChecked(GeneralCheatManager.bAmbienceDisabled);
			Checkbox_ConcealmentTiles.SetChecked(GeneralCheatManager.bConcealmentTilesHidden);
			Checkbox_DisableUnitShaders.SetChecked(TacticalCheatManager.bDisableTargetingOutline);
			Checkbox_DisableLookAtBack.SetChecked(TacticalCheatManager.bDisableLookAtBackPenalty);
			Checkbox_DisableTutorialPopups.SetChecked(TacticalCheatManager.bDisableTutorialPopups);
		}

		if(GeneralCheatManager != none)
		{
			Checkbox_Narrative.SetChecked(GeneralCheatManager.bNarrativeDisabled);
			Checkbox_DisableMusic.SetChecked(GeneralCheatManager.bMusicDisabled);
			Checkbox_DisableTooltips.SetChecked(!PlayerController.Pres.m_kTooltipMgr.bEnableTooltips);
		}
	}

	Checkbox_DOF.SetChecked(ProfileSettings.Data.MarketingPresets.bDOFEnable);
	Slider_DOFFocusDistance.SetPercent(ProfileSettings.Data.MarketingPresets.DOFFocusDistance);
	Slider_DOFFocusInnerRadius.SetPercent(ProfileSettings.Data.MarketingPresets.DOFFocusRadius);
	Slider_DOFMaxNearFocus.SetPercent(ProfileSettings.Data.MarketingPresets.DOFMaxNearBlur);
	Slider_DOFMaxFarFocus.SetPercent(ProfileSettings.Data.MarketingPresets.DOFMaxFarBlur);
}

simulated function bool OnUnrealCommand(int cmd, int arg)
{
	if ( !CheckInputIsReleaseOrDirectionRepeat(cmd, arg) )
		return false;

	switch( cmd )
	{
		case class'UIUtilities_Input'.const.FXS_BUTTON_A:
		case class'UIUtilities_Input'.const.FXS_BUTTON_B:
		case class'UIUtilities_Input'.const.FXS_BUTTON_Y:
		case class'UIUtilities_Input'.const.FXS_BUTTON_X:
		case class'UIUtilities_input'.const.FXS_BUTTON_L3:
			return true;
	}

	return super.OnUnrealCommand(cmd, arg);
}

simulated function ApplyDOFChanges(UIButton button)
{
	PPSettings.bOverride_EnableDOF = TRUE;
	PPSettings.bEnableDOF = Checkbox_DOF.bChecked;

	PPSettings.bOverride_DOF_FocusDistance = TRUE;
	PPSettings.DOF_FocusDistance = Slider_DOFFocusDistance.percent * 20.0f;

	PPSettings.bOverride_DOF_FocusInnerRadius = TRUE;
	PPSettings.DOF_FocusInnerRadius = Slider_DOFFocusInnerRadius.percent * 10.0f;	

	PPSettings.bOverride_DOF_InterpolationDuration = TRUE;
	PPSettings.DOF_InterpolationDuration = 0.0f;

	PPSettings.bOverride_DOF_MaxNearBlurAmount = TRUE;
	PPSettings.DOF_MaxNearBlurAmount = Slider_DOFMaxNearFocus.percent * 0.01f;

	PPSettings.bOverride_DOF_MaxFarBlurAmount = TRUE;
	PPSettings.DOF_MaxFarBlurAmount = Slider_DOFMaxFarFocus.percent * 0.01f;

	LocalPlayer(PlayerController.Player).OverridePostProcessSettings(PPSettings, 0.0f);

	SaveDOFChanges();

	`ONLINEEVENTMGR.SaveProfileSettings();
}

simulated function SaveDOFChanges()
{
	ProfileSettings.Data.MarketingPresets.bDOFEnable = Checkbox_DOF.bChecked;
	ProfileSettings.Data.MarketingPresets.DOFFocusDistance = Slider_DOFFocusDistance.percent;
	ProfileSettings.Data.MarketingPresets.DOFFocusRadius = Slider_DOFFocusInnerRadius.percent;
	ProfileSettings.Data.MarketingPresets.DOFMaxNearBlur = Slider_DOFMaxNearFocus.percent;
	ProfileSettings.Data.MarketingPresets.DOFMaxFarBlur = Slider_DOFMaxFarFocus.percent;
}

simulated function ClearDOFChanges(UIButton button)
{
	LocalPlayer(PlayerController.Player).ClearPostProcessSettingsOverride(0.0f);
}

simulated function ApplyChanges(UIButton button)
{
	local XComWorldData WorldData;
	local XGUnit Unit;	

	SaveMarketingPresetToProfile('Checkbox_2DUI', Checkbox_2DUI.bChecked);
	if(Checkbox_2DUI.bChecked)
	{
		if(Pres.Get2DMovie().bIsVisible)
		{
			Pres.Get2DMovie().Hide();
		}
	}
	else
	{
		if(!Pres.Get2DMovie().bIsVisible)
		{
			Pres.Get2DMovie().Show();
		}
	}

	SaveMarketingPresetToProfile('Checkbox_3DUI', Checkbox_3DUI.bChecked);
	if(Checkbox_3DUI.bChecked)
	{
		if(Pres.Get3DMovie().bIsVisible)
		{
			Pres.Get3DMovie().Hide();
		}
	}
	else
	{
		if(!Pres.Get3DMovie().bIsVisible)
		{
			Pres.Get3DMovie().Show();
		}
	}
	
	if(TacticalCheatManager != none)
	{
		SaveMarketingPresetToProfile('Checkbox_UnitFlags', Checkbox_UnitFlags.bChecked);
		TacticalCheatManager.bShowUnitFlags = !Checkbox_UnitFlags.bChecked;

		SaveMarketingPresetToProfile('Checkbox_WorldMessages', Checkbox_WorldMessages.bChecked);
		TacticalCheatManager.bDisableWorldMessages = Checkbox_WorldMessages.bChecked;

		SaveMarketingPresetToProfile('Checkbox_LootEffects', Checkbox_LootEffects.bChecked);
		TacticalCheatManager.SetLootDisabled(Checkbox_LootEffects.bChecked);

		SaveMarketingPresetToProfile('Checkbox_FOW', Checkbox_FOW.bChecked);
		if(Checkbox_FOW.bChecked == `XWORLD.bDebugEnableFOW) TacticalCheatManager.ToggleFOW();
			if(!`XWORLD.bDebugEnableFOW)

		SaveMarketingPresetToProfile('Checkbox_BuildingVisibility', Checkbox_BuildingVisibility.bChecked);
		TacticalCheatManager.BuildingVisEnable(!Checkbox_BuildingVisibility.bChecked);

		SaveMarketingPresetToProfile('Checkbox_ProximityDither', Checkbox_ProximityDither.bChecked);
		TacticalCheatManager.ProximityDitherEnable(!Checkbox_ProximityDither.bChecked);

		SaveMarketingPresetToProfile('Checkbox_CutoutBox', Checkbox_CutoutBox.bChecked);
		TacticalCheatManager.CutoutBoxEnable(!Checkbox_CutoutBox.bChecked);

		SaveMarketingPresetToProfile('Checkbox_PeripheryHiding', Checkbox_PeripheryHiding.bChecked);
		TacticalCheatManager.PeripheryHidingEnable(!Checkbox_PeripheryHiding.bChecked);

		SaveMarketingPresetToProfile('Checkbox_Pathing', Checkbox_Pathing.bChecked);
		if(Checkbox_Pathing.bChecked)
		{
			TacticalCheatManager.bHidePathingPawn = true;
			TacticalCheatManager.m_bAllowTether = false;

			WorldData = class'XComWorldData'.static.GetWorldData();
			if(WorldData != none && WorldData.Volume != none)
			{
				class'XComWorldData'.static.GetWorldData().Volume.BorderComponent.SetCinematicHidden(!TacticalCheatManager.m_bAllowTether);
				class'XComWorldData'.static.GetWorldData().Volume.BorderComponentDashing.SetCinematicHidden(!TacticalCheatManager.m_bAllowTether);
			}
						
			TacticalCheatManager.UISetDiscState(false);
			foreach AllActors(class'XGUnit', Unit)
			{
				Unit.RefreshUnitDisc();
			}
		}
		else
		{
			TacticalCheatManager.bHidePathingPawn = false;
			TacticalCheatManager.m_bAllowTether = true;

			WorldData = class'XComWorldData'.static.GetWorldData();
			if(WorldData != none && WorldData.Volume != none)
			{
				class'XComWorldData'.static.GetWorldData().Volume.BorderComponent.SetCinematicHidden(!TacticalCheatManager.m_bAllowTether);
				class'XComWorldData'.static.GetWorldData().Volume.BorderComponentDashing.SetCinematicHidden(!TacticalCheatManager.m_bAllowTether);
			}

			TacticalCheatManager.UISetDiscState(true);

			foreach AllActors(class'XGUnit', Unit)
			{
				Unit.RefreshUnitDisc();
			}
		}

		SaveMarketingPresetToProfile('Checkbox_SoldierChatter', Checkbox_SoldierChatter.bChecked);
		`XPROFILESETTINGS.Data.m_bEnableSoldierSpeech = !Checkbox_SoldierChatter.bChecked;

		SaveMarketingPresetToProfile('Checkbox_DisableAmbience', Checkbox_DisableAmbience.bChecked);
		if(Checkbox_DisableAmbience.bChecked)
		{
			GeneralCheatManager.bAmbienceDisabled = true;
			`XTACTICALSOUNDMGR.StopAllAmbience();
		}
		else
		{
			GeneralCheatManager.bAmbienceDisabled = false;
			`XTACTICALSOUNDMGR.StartAllAmbience();
		}

		SaveMarketingPresetToProfile('Checkbox_ConcealmentTiles', Checkbox_ConcealmentTiles.bChecked);
		GeneralCheatManager.bConcealmentTilesHidden = Checkbox_ConcealmentTiles.bChecked;
		XComTacticalController(PlayerController).m_kPathingPawn.UpdateConcealmentTilesVisibility(Checkbox_ConcealmentTiles.bChecked);

		SaveMarketingPresetToProfile('Checkbox_DisableUnitShaders', Checkbox_DisableUnitShaders.bChecked);
		TacticalCheatManager.bDisableTargetingOutline = Checkbox_DisableUnitShaders.bChecked;
		
		SaveMarketingPresetToProfile('Checkbox_DisableLookAtBack', Checkbox_DisableLookAtBack.bChecked);
		TacticalCheatManager.bDisableLookAtBackPenalty = Checkbox_DisableLookAtBack.bChecked;

		SaveMarketingPresetToProfile('Checkbox_DisableTutorialPopups', Checkbox_DisableTutorialPopups.bChecked);
		TacticalCheatManager.bDisableLookAtBackPenalty = Checkbox_DisableTutorialPopups.bChecked;
	}
	
	if(GeneralCheatManager != none)
	{
		SaveMarketingPresetToProfile('Checkbox_Narrative', Checkbox_Narrative.bChecked);
		GeneralCheatManager.bNarrativeDisabled = Checkbox_Narrative.bChecked;

		SaveMarketingPresetToProfile('Checkbox_DisableMusic', Checkbox_DisableMusic.bChecked);
		GeneralCheatManager.bMusicDisabled = Checkbox_DisableMusic.bChecked;
		PlayerController.SetAudioGroupVolume('Music', 0.0f);

		SaveMarketingPresetToProfile('Checkbox_DisableTooltips', Checkbox_DisableTooltips.bChecked);
		if(Checkbox_DisableTooltips.bChecked)
		{
			GeneralCheatManager.UIDisableTooltips();
		}
		else
		{
			GeneralCheatManager.UIEnableTooltips();
		}		
	}

	SaveDOFChanges();

	`ONLINEEVENTMGR.SaveProfileSettings();

	Movie.Stack.Pop(self);
}

simulated protected function SaveMarketingPresetToProfile(name Preset, bool Enabled)
{
	// rather than copy and paste this for each setting, pulled off into a separate function.
	// Guarantees that we will only ever add one instance of Preset if enabled, and that we
	// clear every instance of instance if we remove it
	if(Enabled)
	{
		if(ProfileSettings.Data.MarketingPresets.CheckboxSettings.Find(Preset) == INDEX_NONE)
		{
			ProfileSettings.Data.MarketingPresets.CheckboxSettings.AddItem(Preset);
		}
	}
	else
	{
		while(ProfileSettings.Data.MarketingPresets.CheckboxSettings.Find(Preset) != INDEX_NONE)
		{
			ProfileSettings.Data.MarketingPresets.CheckboxSettings.RemoveItem(Preset);
		}
	}
}

simulated function ToggleCheckbox(UICheckbox checkboxControl)
{
	
}

simulated function DOFPercentChanged(UISlider sliderControl)
{

}

simulated function OnRemoved()
{
	super.OnRemoved();
}

//==============================================================================
//		DEFAULTS:
//==============================================================================

simulated function OnReceiveFocus()
{
	Show();
}

simulated function OnLoseFocus()
{
	Hide();
}

defaultproperties
{
}
