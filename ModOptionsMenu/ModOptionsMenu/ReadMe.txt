Mod Options Menu

A simple API designed to provide a unified, in-game options menu framework for mod developers.

To listen for the Mod Options Menu display, create a UIScreenListener that listens for the 'UIModOptionsMenu_ModOptionsMenu' class and fires an event to advertise your mod's options UIScreen to the framework.

You more more specifically listen for the 'UIModOptionsMenu_ShellModOptionsMenu', 'UIModOptionsMenu_HQModOptionsMenu', and 'UIModOptionsMenu_TacticalModOptionsMenu' subclasses to discriminate between different game modes.

The class name passed to the Event Manager must include the package name as a prefix (as seen below), and must be a subclass of the UIScreen class.

if (Screen.IsA('UIModOptionsMenu_ModOptionsMenu'))
{
	MenuTextParams = new class'XGParamTag';
	MenuTextParams.StrValue0 = "My Test Mod";
	MenuTextParams.StrValue1 = "ModOptionsMenu.UIModOptionsMenu_TestOptionsScreen";

	`XEVENTMGR.TriggerEvent('ModOptionsMenu_AddItem', MenuTextParams,, none);	
}