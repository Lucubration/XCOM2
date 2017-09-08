
class UIPosterScreen extends UIScreen
	config(UI);

var name DisplayTag;
var string CameraTag;

var delegate<OnImageSet> SoldierImageCreatedCallback;

delegate OnImageSet();

simulated function OnInit()
{
	super.OnInit();
}

// bsg_jrebar (5/2/17): Oberriding InitScreen to kill an errant sound being played
simulated function InitScreen(XComPlayerController InitController, UIMovie InitMovie, optional name InitName)
{
	Screen = self;
	Movie = InitMovie;
	PC = InitController;

	InitPanel(InitName);

	// Are we displaying in a 3D surface?
	bIsIn3D = Movie.Class == class'UIMovie_3D';
	
	// Setup watch for force hide via cinematics.
	if (PC != none)
	{
		if( Movie.Stack != none && Movie.Stack.bCinematicMode )
			HideForCinematics();
	}
	else
		`warn("UIMovie::BaseInit - PlayerController (PC) == none!");
}
// bsg_jrebar (5/2/17): end

simulated function SetCamLookAtNamedLocation()
{
	local XComPresentationLayerBase Pres;
	Pres = XComPlayerController(class'WorldInfo'.static.GetWorldInfo().GetALocalPlayerController()).Pres;
	Pres.CAMLookAtNamedLocation(CameraTag, 0.0, false);
}


simulated function OnSetSoldierPortrait(Texture2D NewTexture)
{
	MC.FunctionString("posterSetSoldier", class'UIUtilities_Image'.static.ValidateImagePath(PathName(NewTexture)));
}

simulated function OnCommand(string cmd, string arg)
{
	switch (cmd)
	{
	case "SoldierImageCreated":
		SetTimer(0.1f, false, 'SoldierImageCreated');
		break;
	}
}

simulated event SoldierImageCreated()
{
	SoldierImageCreatedCallback();
}

simulated function bool OnUnrealCommand(int cmd, int arg)
{
	return false;
}

//==============================================================================

defaultproperties
{
	Package = "/ package/gfxXPACK_Poster/XPACK_Poster";
	LibID = "PosterMC1";

	DisplayTag = "CameraPhotobooth";
	CameraTag = "CameraPhotobooth";
	bHideOnLoseFocus = false;

	InputState = eInputState_Evaluate;
}