class UIArmory_Lucu_Garage_ModuleSlot extends UIPanel;

var int SlotIndex;
var bool bIsLocked;

var XComGameState_Item ModuleItem;

var UIButton Button;
var UIImage Icon;

var localized string m_strAvailableLabel;
var localized string m_strAvailableDescription;

var localized string m_strLockedLabel;
var localized string m_strLockedDescription;

simulated function UIArmory_Lucu_Garage_ModuleSlot InitModuleSlot(int InitIndex)
{
	SlotIndex = InitIndex;

	InitPanel();

	Button = Spawn(class'UIButton', self).InitButton();
	Button.SetSize(Width, Height);
	Button.SetPosition(50, 0);
	Button.OnMouseEventDelegate = OnChildMouseEvent;
	
	Icon = Spawn(class'UIImage', self).InitImage();
	Icon.SetPosition(65, 15);

	return self;
}

simulated function SetAvailable(optional XComGameState_Item Module)
{
	local X2ItemTemplate ItemTemplate;

	ModuleItem = Module;

	if (ModuleItem != none)
	{
		//ItemTemplate = ImplantItem.GetMyTemplate();
		//Icon.LoadImage(class'UIUtilities_Image'.static.GetPCSImage(Item));
		Icon.LoadImage("img:///UILibrary_Common.implants_psi");
	}
	else
	{
		Icon.LoadImage(class'UIUtilities_Image'.const.PersonalCombatSim_Empty);
	}

	bIsLocked = false;
}

simulated function SetLocked()
{
	Icon.LoadImage(class'UIUtilities_Image'.const.PersonalCombatSim_Locked);

	ModuleItem = none;
	bIsLocked = true;
}

simulated function OnChildMouseEvent(UIPanel Control, int Cmd)
{
	switch(Cmd)
	{
		case class'UIUtilities_Input'.const.FXS_L_MOUSE_UP:
			if(!bIsLocked)
				`HQPRES.UIInventory_Implants();
			else
				`HQPRES.PlayUISound(eSUISound_MenuClickNegative);
		break;
		case class'UIUtilities_Input'.const.FXS_L_MOUSE_IN:
			if(!bIsLocked)
				SetAvailable(ModuleItem);
		break;
		case class'UIUtilities_Input'.const.FXS_L_MOUSE_OUT:
			if(!bIsLocked)
				SetAvailable(ModuleItem);
		break;
	}
}

defaultproperties
{
	Width = 95;
	Height = 95;
}