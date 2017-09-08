class UIModOptionsScreen_DisableAnyClass extends UIScreen;

var localized string				ModOptionsScreenTitle;

var int								Padding;
var array<X2SoldierClassTemplate>	ClassTemplates;
var array<name>						ExcludeClassTemplateNames;

var UINavigationHelp				NavHelp;
var UIPanel							Container;			// Top-level container
var UIBGBox							BG;					// Colored background
var UIX2PanelHeader					TitleHeader;		// Screen title
var UIList							List;				// Checkbox list with class display names
var UIButton						ApplyOptionsButton;	// Button for applying options

simulated function InitScreen(XComPlayerController InitController, UIMovie InitMovie, optional name InitName)
{
	super.InitScreen(InitController, InitMovie, InitName);

	// If the class template values haven't been initialized yet, do it now
	class'DisableAnyClass_Config'.static.InitClassValues();
	
	// Create Container
	Container = Spawn(class'UIPanel', self).InitPanel('').SetPosition(30, 70).SetSize(700, 850);

	// Create BG
	BG = Spawn(class'UIBGBox', Container).InitBG('', 0, 0, Container.Width, Container.Height);
	BG.SetAlpha( 80 );
	
	// Create Title text
	TitleHeader = Spawn(class'UIX2PanelHeader', Container);
	TitleHeader.InitPanelHeader('', default.ModOptionsScreenTitle, "");
	TitleHeader.SetHeaderWidth(Container.Width - 2*Padding);
	TitleHeader.SetPosition(Padding, Padding);
	
	// Create bottom button
	ApplyOptionsButton = Spawn(class'UIButton', Container);
	ApplyOptionsButton.InitButton(, "Apply", ApplyOptions);
	ApplyOptionsButton.SetPosition(Padding, Container.Height - ApplyOptionsButton.Height - Padding);
	
	// Create left side list
	List = Spawn(class'UIList', Container);
	List.bAnimateOnInit = false;
	List.InitList('', Padding, TitleHeader.Y + TitleHeader.Height + Padding, Container.Width - 2*Padding - 20, Container.Height - (TitleHeader.Y + TitleHeader.Height) - (Container.Height - ApplyOptionsButton.Y) - 2*Padding);

	CreateClassNameList();

	Show();

	Container.MC.FunctionVoid("AnimateIn");

	`LOG("Mod Options Menu: Example Mod options screen initialized.");
}

simulated function CreateClassNameList()
{
	local X2SoldierClassTemplateManager		ClassTemplateManager;
	local X2SoldierClassTemplate			ClassTemplate;
	local UIMechaListItem					ListItem;
	local int								i;
	
	ClassTemplateManager = class'X2SoldierClassTemplateManager'.static.GetSoldierClassTemplateManager();
	ClassTemplates = ClassTemplateManager.GetAllSoldierClassTemplates();

	for (i = ClassTemplates.Length - 1; i >= 0; i--)
	{
		// Some classes shouldn't appear in this list
		if (ExcludeClassTemplateNames.Find(ClassTemplates[i].DataName) != INDEX_NONE || ClassTemplates[i].bMultiplayerOnly || (/*ClassTemplates[i].NumInForcedDeck == 0 &&*/ ClassTemplates[i].NumInDeck == 0 && !class'DisableAnyClass_Config'.static.IsDisabledClass(ClassTemplates[i].DataName)))
			ClassTemplates.Remove(i, 1);
	}

	// Create list items for all class names in the same order as the class templates list
	foreach ClassTemplates(ClassTemplate)
	{
		ListItem = Spawn(class'UIMechaListItem', List.ItemContainer);
		ListItem.bAnimateOnInit = false;
		ListItem.InitListItem();
		ListItem.SetWidgetType(EUILineItemType_Checkbox);

		ListItem.UpdateDataCheckbox(
			ClassTemplate.DisplayName,
			"",
			!class'DisableAnyClass_Config'.static.IsDisabledClass(ClassTemplate.DataName));
	}
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
	local int	i;
	local bool	IsChecked, IsDisabled;
	
	// Update the list of disabled class names
	for (i = 0; i < List.ItemCount; i++)
	{
		IsChecked = UIMechaListItem(List.GetItem(i)).Checkbox.bChecked;
		IsDisabled = class'DisableAnyClass_Config'.static.IsDisabledClass(ClassTemplates[i].DataName);
		if (!IsChecked && !IsDisabled)
			class'DisableAnyClass_Config'.static.AddDisabledClass(ClassTemplates[i].DataName);
		else if (IsChecked && IsDisabled)
			class'DisableAnyClass_Config'.static.RemoveDisabledClass(ClassTemplates[i].DataName);
	}

	// Save the updated list
	class'DisableAnyClass_Config'.static.StaticSaveConfig();
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
	ExcludeClassTemplateNames(0)="Rookie"
	ExcludeClassTemplateNames(1)="PsiOperative"
}