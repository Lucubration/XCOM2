class UIPhotoboothReview extends UIScreen;

var name DisplayTag;
var string CameraTag;
var UINavigationHelp NavHelp;

var localized string m_strPrevious;
var localized string m_strNext;
var localized string m_strDelete;
var localized string m_strFavorite;
var localized string m_strOpen;

var localized string m_strDeletePhotoTitle;
var localized string m_strDeletePhotoBody;

var UIButton m_PreviousButton;
var UIButton m_NextButton;
var UIButton m_DeleteButton;
var UIButton m_FavoriteButton;
var UIButton m_OpenButton;

var int m_CurrentPosterIndex;
var int m_MaxPosterIndex;
var int m_iGameIndex;

var array<int> PosterIndices;

simulated function OnInit()
{
	local XComGameStateHistory History;
	local XComGameState_CampaignSettings SettingsState;

	`XENGINE.m_kPhotoManager.SetHasViewedPhotos();

	NavHelp = `HQPRES.m_kAvengerHUD.NavHelp;

	super.OnInit();

	UpdateNavHelp();

	m_NextButton = Spawn(class'UIButton', self).InitButton('NextButton', , NextButton);
	m_PreviousButton = Spawn(class'UIButton', self).InitButton('PrevButton', , PreviousButton);
	m_FavoriteButton = Spawn(class'UIButton', self).InitButton('FavButton', , FavoriteButton);
	m_DeleteButton = Spawn(class'UIButton', self).InitButton('DeleteButton', , DeleteButton);
	m_OpenButton = Spawn(class'UIButton', self).InitButton('OpenButton', , OpenButton);
	
	//bsg-jneal (3.22.17): do not show with controller, moving to navhelp
	if(`ISCONTROLLERACTIVE)
	{
		m_PreviousButton.Hide();
		m_NextButton.Hide();
		m_DeleteButton.Hide();
		m_FavoriteButton.Hide();
		m_OpenButton.Hide();
	}
	//bsg-jneal (3.22.17): end

	History = `XCOMHISTORY;
	SettingsState = XComGameState_CampaignSettings(History.GetSingleGameStateObjectForClass(class'XComGameState_CampaignSettings'));
	m_iGameIndex = SettingsState.GameIndex;
	
	m_MaxPosterIndex = `XENGINE.m_kPhotoManager.GetNumOfPosterForCampaign(m_iGameIndex, true);
	m_CurrentPosterIndex = m_MaxPosterIndex;

	`XENGINE.m_kPhotoManager.GetPosterIndices(m_iGameIndex, PosterIndices, true);

	if (m_MaxPosterIndex < 2)
	{
		m_NextButton.SetDisabled(true);
		m_PreviousButton.SetDisabled(true);
		Navigator.RemoveControl(m_NextButton);
		Navigator.RemoveControl(m_PreviousButton);
	}

	MC.BeginFunctionOp("setScreenData");
	MC.QueueString(m_strPrevious);
	MC.QueueString(m_strNext);
	MC.QueueString(m_strDelete);
	MC.QueueString(m_strFavorite);	
	MC.QueueString(m_strOpen);
	MC.EndOp();

	MC.BeginFunctionOp("setPosterImage");
	MC.QueueString(class'UIUtilities_Image'.static.ValidateImagePath(PathName(`XENGINE.m_kPhotoManager.GetPosterTexture(m_iGameIndex, PosterIndices[m_CurrentPosterIndex - 1]))));
	MC.QueueString(String(m_CurrentPosterIndex)$"/"$String(m_MaxPosterIndex));
	MC.EndOp();

	MC.BeginFunctionOp("setPosterFavorite");
	MC.QueueBoolean(`XENGINE.m_kPhotoManager.GetPosterIsFavorite(m_iGameIndex, PosterIndices[m_CurrentPosterIndex-1]));
	MC.EndOp();

	SetTimer(0.1f, false, nameof(UpdateNavHelp)); // bsg-jneal (4.4.17): force a navhelp update to correctly fix wide icon sizing issues when first entering photo review
}

function UpdateNavHelp()
{
	if (NavHelp == none)
	{
		NavHelp = Spawn(class'UINavigationHelp', self).InitNavHelp();
	}

	NavHelp.ClearButtonHelp();
	NavHelp.AddBackButton(CloseScreen);

	//bsg-jneal (3.21.17): move controls to navigation help for controller
	if(`ISCONTROLLERACTIVE)
	{
		NavHelp.AddLeftHelp(m_strOpen, class'UIUtilities_Input'.const.ICON_A_X);
		NavHelp.AddLeftHelp(m_strFavorite, class'UIUtilities_Input'.const.ICON_X_SQUARE);
		NavHelp.AddLeftHelp(m_strDelete, class'UIUtilities_Input'.const.ICON_Y_TRIANGLE);
		NavHelp.AddRightHelp(m_strPrevious, class'UIUtilities_Input'.const.ICON_LB_L1);
		NavHelp.AddRightHelp(m_strNext, class'UIUtilities_Input'.const.ICON_RB_R1);
	}
	//bsg-jneal (3.21.17): end

	NavHelp.Show();
}

simulated function bool OnUnrealCommand(int cmd, int arg)
{
	if (!CheckInputIsReleaseOrDirectionRepeat(cmd, arg))
		return false;
	
	switch (cmd)
	{
	case class'UIUtilities_Input'.const.FXS_BUTTON_B :
	case class'UIUtilities_Input'.const.FXS_KEY_ESCAPE :
	case class'UIUtilities_Input'.const.FXS_R_MOUSE_DOWN :
		CloseScreen();
		return true;
	//bsg-jneal (3.21.17): adding controller shortcuts for photobooth review
	case class'UIUtilities_Input'.const.FXS_BUTTON_X :
		FavoriteButton(none);
		return true;
	case class'UIUtilities_Input'.const.FXS_BUTTON_A :
		OpenButton(none);
		return true;
	case class'UIUtilities_Input'.const.FXS_BUTTON_Y :
		DeleteButton(none);
		return true;
	case class'UIUtilities_Input'.const.FXS_BUTTON_LBUMPER:
		if (m_MaxPosterIndex >= 2)
		{
			PreviousButton(none);
		}
		return true;
	case class'UIUtilities_Input'.const.FXS_BUTTON_RBUMPER:
		if (m_MaxPosterIndex >= 2)
		{
			NextButton(none);
		}
		return true;
	//bsg-jneal (3.21.17): end
	}

	return super.OnUnrealCommand(cmd, arg);
}

simulated function PreviousButton(UIButton ButtonControl)
{
	m_CurrentPosterIndex = m_CurrentPosterIndex - 1;
	if (m_CurrentPosterIndex < 1)
		m_CurrentPosterIndex = m_MaxPosterIndex;

	MC.BeginFunctionOp("setPosterImage");
	MC.QueueString(class'UIUtilities_Image'.static.ValidateImagePath(PathName(`XENGINE.m_kPhotoManager.GetPosterTexture(m_iGameIndex, PosterIndices[m_CurrentPosterIndex - 1]))));
	MC.QueueString(String(m_CurrentPosterIndex)$"/"$String(m_MaxPosterIndex));
	MC.EndOp();

	MC.BeginFunctionOp("setPosterFavorite");
	MC.QueueBoolean(`XENGINE.m_kPhotoManager.GetPosterIsFavorite(m_iGameIndex, PosterIndices[m_CurrentPosterIndex - 1]));
	MC.EndOp();
}

simulated function NextButton(UIButton ButtonControl)
{
	m_CurrentPosterIndex = m_CurrentPosterIndex + 1;
	if (m_CurrentPosterIndex > m_MaxPosterIndex)
		m_CurrentPosterIndex = 1;

	MC.BeginFunctionOp("setPosterImage");
	MC.QueueString(class'UIUtilities_Image'.static.ValidateImagePath(PathName(`XENGINE.m_kPhotoManager.GetPosterTexture(m_iGameIndex, PosterIndices[m_CurrentPosterIndex - 1]))));
	MC.QueueString(String(m_CurrentPosterIndex)$"/"$String(m_MaxPosterIndex));
	MC.EndOp();

	MC.BeginFunctionOp("setPosterFavorite");
	MC.QueueBoolean(`XENGINE.m_kPhotoManager.GetPosterIsFavorite(m_iGameIndex, PosterIndices[m_CurrentPosterIndex - 1]));
	MC.EndOp();
}

simulated function FavoriteButton(UIButton ButtonControl)
{
	local bool isFavorite;

	isFavorite = `XENGINE.m_kPhotoManager.GetPosterIsFavorite(m_iGameIndex, PosterIndices[m_CurrentPosterIndex - 1]);
	isFavorite = !isFavorite;
	`XENGINE.m_kPhotoManager.SetPosterIsFavorite(m_iGameIndex, PosterIndices[m_CurrentPosterIndex - 1], isFavorite);

	MC.BeginFunctionOp("setPosterFavorite");
	MC.QueueBoolean(isFavorite);
	MC.EndOp();
}

function DestructiveActionPopup()
{
	local TDialogueBoxData kConfirmData;


	kConfirmData.strTitle  = m_strDeletePhotoTitle;
	kConfirmData.strText   = m_strDeletePhotoBody;
	kConfirmData.strAccept = class'UIUtilities_Text'.default.m_strGenericYes;
	kConfirmData.strCancel = class'UIUtilities_Text'.default.m_strGenericNo;

	kConfirmData.fnCallback = OnDestructiveActionPopupExitDialog;

	Movie.Pres.UIRaiseDialog(kConfirmData);
}

function OnDestructiveActionPopupExitDialog(Name eAction)
{
	if (eAction == 'eUIAction_Accept')
	{
		m_MaxPosterIndex = m_MaxPosterIndex - 1;

		if (m_MaxPosterIndex < 2)
		{
			m_NextButton.SetDisabled(true);
			m_PreviousButton.SetDisabled(true);
		}

		`XENGINE.m_kPhotoManager.DeletePoster(m_iGameIndex, PosterIndices[m_CurrentPosterIndex - 1]);
		`XENGINE.m_kPhotoManager.GetPosterIndices(m_iGameIndex, PosterIndices, true);
		if (m_MaxPosterIndex <= 0)
		{
			CloseScreen();
			return;
		}
		if (m_CurrentPosterIndex > m_MaxPosterIndex)
			m_CurrentPosterIndex = m_MaxPosterIndex;

		MC.BeginFunctionOp("setPosterImage");
		MC.QueueString(class'UIUtilities_Image'.static.ValidateImagePath(PathName(`XENGINE.m_kPhotoManager.GetPosterTexture(m_iGameIndex, PosterIndices[m_CurrentPosterIndex - 1]))));
		MC.QueueString(String(m_CurrentPosterIndex)$"/"$String(m_MaxPosterIndex));
		MC.EndOp();

		MC.BeginFunctionOp("setPosterFavorite");
		MC.QueueBoolean(`XENGINE.m_kPhotoManager.GetPosterIsFavorite(m_iGameIndex, PosterIndices[m_CurrentPosterIndex - 1]));
		MC.EndOp();
	}
}

simulated function DeleteButton(UIButton ButtonControl)
{
	DestructiveActionPopup();
}

simulated function OpenButton(UIButton ButtonControl)
{
	class'Helpers'.static.OpenWindowsExplorerToPhotos(m_iGameIndex);
}

simulated function CloseScreen()
{
	local XComGameState_CampaignSettings SettingsState;

	SettingsState = XComGameState_CampaignSettings(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_CampaignSettings'));
	`XENGINE.m_kPhotoManager.FillPropagandaTextureArray(ePWM_Campaign, SettingsState.GameIndex);

	super.CloseScreen();
}

defaultproperties
{
	InputState = eInputState_Consume;
	bHideOnLoseFocus = false;

	Package = "/ package/gfxPhotobooth/Photobooth";
	LibID = "PhotoboothReviewScreen";
	DisplayTag = "CameraPhotobooth";
	CameraTag = "CameraPhotobooth";
}