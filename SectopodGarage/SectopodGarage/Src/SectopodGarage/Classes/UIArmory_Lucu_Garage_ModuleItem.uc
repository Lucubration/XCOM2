class UIArmory_Lucu_Garage_ModuleItem extends UIPanel;

var int Slot;
var name ModuleName;

var UIArmory_Lucu_Garage_ModuleSlot ModuleSlot;
var UIScrollingText Label;

var bool bIsDisabled;

var localized string m_strNewRank;

simulated function UIArmory_Lucu_Garage_ModuleItem InitModuleItem(int InitSlot)
{
	Slot = InitSlot;

	InitPanel();

	Navigator.HorizontalNavigation = true;

	ModuleSlot = Spawn(class'UIArmory_Lucu_Garage_ModuleSlot', self).InitModuleSlot(InitSlot);
	ModuleSlot.Hide();

	Label = Spawn(class'UIScrollingText', self).InitScrollingText(,, Width - 200, 190, 15, true);

	return self;
}

simulated function SetDisabled(bool bDisabled)
{
	bIsDisabled = bDisabled;

	ModuleSlot.SetLocked();
	ModuleSlot.Show();

	SetText(class'UIUtilities_Text'.static.GetColoredText("Module Locked", eUIState_Disabled));
	
	MC.FunctionBool("setDisabled", bIsDisabled);
}

simulated function SetModuleData(optional XComGameState_Item Module, optional eUIState TextState = eUIState_Normal)
{
	if (Module == none)
	{
		SetText(class'UIUtilities_Text'.static.GetColoredText("Module Available", eUIState_Highlight));
	}
	else
	{
		SetText(class'UIUtilities_Text'.static.GetColoredText("Module Installed", eUIState_Normal));
	}

	ModuleSlot.SetAvailable(Module);
	ModuleSlot.Show();
}

simulated function SetText(string Text)
{
	Label.SetTitle(class'UIUtilities_Text'.static.AlignLeft(Text));
}

simulated function RealizeVisuals()
{
	MC.FunctionVoid("realizeFocus");
}

simulated function OnReceiveFocus()
{
	local UIArmory_Lucu_Garage_Modules ModulesScreen;

	super.OnReceiveFocus();

	ModulesScreen = UIArmory_Lucu_Garage_Modules(Screen);

	if (ModulesScreen != none)
	{
		ModulesScreen.ClassRowItem.OnLoseFocus();

		if (ModulesScreen.List.GetItemIndex(self) != INDEX_NONE)
			ModulesScreen.List.SetSelectedItem(self);
		else
			ModulesScreen.List.SetSelectedIndex(-1);
	}
}

simulated function OnLoseFocus()
{
	// Leave highlighted when confirming ability selection
	if (Movie.Pres.ScreenStack.GetCurrentScreen() == Screen)
	{
		super.OnLoseFocus();
	}
}

defaultproperties
{
	width = 724;
	height = 156;
	bCascadeFocus = false;
}