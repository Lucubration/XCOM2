class ExampleMod_UIHQModOptionsScreen extends UIScreen;

var int							Padding;

var UINavigationHelp			NavHelp;
var UIPanel						Container;			// Top-level container
var UIBGBox						BG;					// Colored background
var UIX2PanelHeader				TitleHeader;		// Screen title
var UIButton					ApplyOptionsButton;	// Button for applying options

simulated function InitScreen(XComPlayerController InitController, UIMovie InitMovie, optional name InitName)
{
	super.InitScreen(InitController, InitMovie, InitName);
	
	// Create Container
	Container = Spawn(class'UIPanel', self).InitPanel('').SetPosition(30, 70).SetSize(700, 850);

	// Create BG
	BG = Spawn(class'UIBGBox', Container).InitBG('', 0, 0, Container.Width, Container.Height);
	BG.SetAlpha( 80 );
	
	// Create Title text
	TitleHeader = Spawn(class'UIX2PanelHeader', Container);
	TitleHeader.InitPanelHeader('', "Example Mod: HQ Options", "");
	TitleHeader.SetHeaderWidth(Container.Width - 2*Padding);
	TitleHeader.SetPosition(Padding, Padding);
	
	// Create bottom button
	ApplyOptionsButton = Spawn(class'UIButton', Container);
	ApplyOptionsButton.InitButton(, "Apply", ApplyOptions);
	ApplyOptionsButton.SetPosition(Padding, Container.Height - ApplyOptionsButton.Height - Padding);
	
	Show();

	Container.MC.FunctionVoid("AnimateIn");

	`LOG("Mod Options Menu: Example Mod options screen initialized.");
}

simulated function OnInit()
{
	super.OnInit();
		
	NavHelp = PC.Pres.GetNavHelp();
	if (NavHelp == none)
		NavHelp = Spawn(class'UINavigationHelp',self).InitNavHelp();
	NavHelp.ClearButtonHelp();
	NavHelp.AddBackButton(ExitScreen);

	AnimateIn();
	Show();
	
	`LOG("Mod Options Menu: Example Mod options screen shown.");
}

simulated function OnReceiveFocus() 
{
	Show(); 
	
	NavHelp.ClearButtonHelp();
	NavHelp.AddBackButton(ExitScreen);
}	
simulated function OnLoseFocus()    
{
	Hide(); 
	NavHelp.ClearButtonHelp();
}

simulated function bool OnUnrealCommand(int cmd, int ActionMask)
{
	if (!bIsInited)
		return true; 

	// Ignore releases, only pay attention to presses.
	if (!CheckInputIsReleaseOrDirectionRepeat(cmd, ActionMask))
		return true; // Consume All Input!

	switch(cmd)
	{
		case class'UIUtilities_Input'.const.FXS_BUTTON_B:
		case class'UIUtilities_Input'.const.FXS_KEY_ESCAPE:
		case class'UIUtilities_Input'.const.FXS_R_MOUSE_DOWN:
			ExitScreen();
			break;
			
		default:
			// Do not reset handled, consume input since this
			// is (an) options menu which stops any other systems.
			break;
	}

	// Assume input is handled unless told otherwise
	return super.OnUnrealCommand(cmd, ActionMask);
}

simulated function OnMouseEvent(int cmd, array<string> args)
{
	if (bShouldPlayGenericUIAudioEvents)
	{
		switch( cmd )
		{
			case class'UIUtilities_Input'.const.FXS_L_MOUSE_UP:
			case class'UIUtilities_Input'.const.FXS_L_MOUSE_DOUBLE_UP:
				`SOUNDMGR.PlaySoundEvent("Generic_Mouse_Click");
				break;
			case class'UIUtilities_Input'.const.FXS_L_MOUSE_IN:
			case class'UIUtilities_Input'.const.FXS_L_MOUSE_OVER:
			case class'UIUtilities_Input'.const.FXS_L_MOUSE_DRAG_OVER:
				`SOUNDMGR.PlaySoundEvent("Play_Mouseover");
				break;
		}
	}
}

simulated function ApplyOptions(UIButton Button)
{
	// To-do: Use the checkboxes to do some sort of Favorites filtering for long mod options lists
}

simulated function ExitScreen()
{
	local Object ThisObj;

	`XEVENTMGR.UnRegisterFromAllEvents(ThisObj);

	NavHelp.ClearButtonHelp();

	Movie.Stack.Pop(self);
	Movie.Pres.PlayUISound(eSUISound_MenuClose);
}

DefaultProperties
{
	bConsumeMouseEvents=true
	Padding=10
}