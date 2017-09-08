class UIModOptionsMenu_ModOptionsMenu extends UIScreen;

var localized string			XcomOptionsString;
var localized string			ModOptionsString;

var int							Padding;

var UINavigationHelp			NavHelp;
var UIPanel						Container;			// Top-level container
var UIBGBox						BG;					// Colored background
var UIList						List;				// Left side list for mod titles
var array<string>				ModDisplayNames;	// Item names for sorting
var array<string>				ModUIClassNames;	// The UI object class names for the mod items
var UIX2PanelHeader				TitleHeader;		// Screen title
var UIButton					XcomOptionsButton;	// Button for returning to Xcom 2 Options menu

simulated function InitScreen(XComPlayerController InitController, UIMovie InitMovie, optional name InitName)
{
	local X2EventManager  EventManager;
	local Object ThisObj;

	EventManager = `XEVENTMGR;
	ThisObj = self;
	EventManager.RegisterForEvent(ThisObj, 'ModOptionsMenu_AddItem', OnAddItem, ELD_Immediate);

	super.InitScreen(InitController, InitMovie, InitName);
	
	// Create Container
	Container = Spawn(class'UIPanel', self).InitPanel('').SetPosition(30, 70).SetSize(600, 850);

	// Create BG
	BG = Spawn(class'UIBGBox', Container).InitBG('', 0, 0, Container.Width, Container.Height);
	BG.SetAlpha( 80 );
	
	// Create Title text
	TitleHeader = Spawn(class'UIX2PanelHeader', Container);
	TitleHeader.InitPanelHeader('', ModOptionsString, "");
	TitleHeader.SetHeaderWidth(Container.Width - 2*Padding);
	TitleHeader.SetPosition(Padding, Padding);
	
	// Create bottom button
	XcomOptionsButton = Spawn(class'UIButton', Container);
	XcomOptionsButton.InitButton(, XcomOptionsString, XcomOptions);
	XcomOptionsButton.SetPosition(Padding, Container.Height - XComOptionsButton.Height - Padding);

	// Create left side list
	List = Spawn(class'UIList', Container);
	List.bAnimateOnInit = false;
	List.InitList('', Padding, TitleHeader.Y + TitleHeader.Height + Padding, Container.Width - 2*Padding - 20, Container.Height - (TitleHeader.Y + TitleHeader.Height) - (Container.Height - XcomOptionsButton.Y) - 2*Padding);
	List.bStickyHighlight = true;
	BG.ProcessMouseEvents(List.OnChildMouseEvent);

	Show();

	Container.MC.FunctionVoid("AnimateIn");

	`LOG("Mod Options Menu: Mod Options menu initialized.");
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
	
	`LOG("Mod Options Menu: Mod Options menu shown.");
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

simulated function EventListenerReturn OnAddItem(Object EventData, Object EventSource, XComGameState GameState, Name EventID)
{
	local XGParamTag MenuTextParams;
	
	MenuTextParams = XGParamTag(EventData);

	`LOG("Mod Options Menu: Mod Options Menu received event " @ MenuTextParams.StrValue0 @ ", " @ MenuTextParams.StrValue1 @ ".");

	if (MenuTextParams == none || MenuTextParams.StrValue0 == "" || MenuTextParams.StrValue1 == "")
		return ELR_NoInterrupt;

	CreateListItem(MenuTextParams.StrValue0, MenuTextParams.StrValue1);

	return ELR_NoInterrupt;
}

simulated function CreateListItem(string ModDisplayName, string ModUIClassName)
{
	local int i;

	`LOG("Mod Options Menu: Mod Options Menu creating list item for mod " @ ModDisplayName @ ".");

	// List is alphabetical. Find the index at which to the insert the new item
	for (i = 0; i <= ModDisplayNames.Length; i++)
	{
		if (i == ModDisplayNames.Length)
		{
			ModDisplayNames.AddItem(ModDisplayName);
			ModUIClassNames.AddItem(ModUIClassName);

			InsertListItem(ModDisplayName, ModDisplayNames.Length);
			break;
		}
		else if (ModDisplayNames[i] > ModDisplayName)
		{
			ModDisplayNames.InsertItem(i, ModDisplayName);
			ModUIClassNames.InsertItem(i, ModUIClassName);

			InsertListItem(ModDisplayName, i);
			break;
		}
	}
}

simulated function InsertListItem(string ModDisplayName, int Index)
{
	local UIMechaListItem	ModItem;

	// Create the mod item in the list
	ModItem = Spawn(class'UIMechaListItem', List.ItemContainer);
	ModItem.bAnimateOnInit = false;
	ModItem.InitListItem();
	ModItem.SetWidgetType(EUILineItemType_Checkbox);

	ModItem.UpdateDataCheckbox(
		ModDisplayName,
		"",
		false,
		SelectMod,
		OpenModOptions);
}

simulated function SelectMod(UICheckbox CheckBox)
{
	// To-do: Use the checkboxes to do some sort of Favorites filtering for long mod options lists
}

simulated function OpenModOptions()
{
	local int				ItemIndex;
	local string			ModUIClassName;
	local class<UIScreen>	ModUIClass;
	local UIScreen			ModOptionsScreen;

	`LOG("Mod Options Menu: Mod Options button clicked.");

	ItemIndex = List.GetItemIndex(List.GetSelectedItem());
	ModUIClassName = ModUIClassNames[ItemIndex];
	ModUIClass = class<UIScreen>(PC.Pres.DynamicLoadObject(ModUIClassName, class'Class'));

	if (ModUIClass != none)
	{
		if (Movie.Stack.GetScreen(ModUIClass) == none)
		{
			ModOptionsScreen = PC.Pres.Spawn(ModUIClass, PC.Pres);
			Movie.Stack.Push(ModOptionsScreen);

			`LOG("Mod Options Menu: Mod " @ ModUIClassName @ " UI spawned.");
		}
	}
	else
	{
		`REDSCREEN("Mod Options Menu: Failed to create mod " @ ModDisplayNames[ItemIndex] @ " options screen class " @ ModUIClassName @ ".");
	}
}

simulated function XcomOptions(UIButton Button)
{
	ExitScreen();

	`LOG("Mod Options Menu: Xcom Options button clicked.");
}

simulated function ExitScreen()
{
	local X2EventManager  EventManager;
	local Object ThisObj;

	EventManager = `XEVENTMGR;
	ThisObj = self;
	EventManager.UnRegisterFromEvent(ThisObj, 'ModOptionsMenu_AddItem');

	NavHelp.ClearButtonHelp();

	Movie.Stack.Pop(self);
	Movie.Pres.PlayUISound(eSUISound_MenuClose);
}

DefaultProperties
{
	bConsumeMouseEvents=true
	Padding=10
}