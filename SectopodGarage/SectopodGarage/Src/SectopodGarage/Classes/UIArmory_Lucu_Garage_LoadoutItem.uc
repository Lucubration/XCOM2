class UIArmory_Lucu_Garage_LoadoutItem extends UIPanel;

var string title;
var string subTitle;
var string disabledText;
var array<string> Images;
var string PrototypeIcon;
var string SlotType;
var int    Count;

var bool IsLocked;
var bool IsInfinite;
var bool IsDisabled;

var name ItemCat;
var StateObjectReference ItemRef;
var X2ItemTemplate ItemTemplate;
var bool bLoadoutSlot;

var UIPanel UpgradeContainer;
var UIButton DropItemButton;

var localized string m_strCount;
var localized string m_strDropItem;

var int TooltipID;

simulated function UIArmory_Lucu_Garage_LoadoutItem InitLoadoutItem(XComGameState_Item Item, name InitItemCat, optional bool InitSlot, optional string InitDisabledReason)
{
	InitPanel();

	ItemRef = Item.GetReference();
	ItemTemplate = Item.GetMyTemplate();
	ItemCat = InitItemCat;

	if (InitSlot)
	{
		bLoadoutSlot = true;
		SetSlotType(class'UIArmory_Lucu_Garage_Loadout'.static.GetSlotType(ItemCat));
	}
	else
	{
		if (Item != None)
		{
			if ((ItemTemplate.bInfiniteItem || ItemTemplate.StartingItem) && !Item.HasBeenModified())
			{
				SetInfinite(true);
			}
			else
			{
				SetCount(class'UIUtilities_Strategy'.static.GetXComHQ().GetNumItemInInventory(ItemTemplate.DataName));
			}
		}
	}

	if (InitDisabledReason != "")
	{
		SetDisabled(true, class'UIUtilities_Text'.static.GetColoredText(InitDisabledReason, eUIState_Bad));
	}

	// Create the Drop Item button
	if (bLoadoutSlot)
	{
		// add a custom text box since the flash component reports back with from the bg subcomponent
		TooltipID = Movie.Pres.m_kTooltipMgr.AddNewTooltipTextBox(m_strDropItem, 0, 0, MCPath $ ".DropItemButton.bg");
	}

	PopulateData(Item);

	return self;
}

simulated function PopulateData(optional XComGameState_Item Item)
{
	if (Item == None)
		Item = XComGameState_Item(`XCOMHISTORY.GetGameStateForObjectID(ItemRef.ObjectID));

	SetImage(Item); // passing none to SetImage clears the image
	SetTitle(ItemTemplate != none ? ItemTemplate.GetItemFriendlyName(Item.ObjectID) : "");
	SetSubTitle(ItemTemplate != none ? string(ItemTemplate.ItemCat) : "");

	UpdateCategoryIcons(Item);
	UpdateDropItemButton(Item);
}

simulated function UIArmory_Lucu_Garage_LoadoutItem SetTitle(string txt)
{
	if (title != txt)
	{
		title = txt;
		MC.FunctionString("setTitle", title);
	}
	return self;
}

simulated function UIArmory_Lucu_Garage_LoadoutItem SetSubTitle(string txt)
{
	if (subTitle != txt)
	{
		subTitle = txt;
		MC.FunctionString("setSubTitle", subTitle);
	}
	return self;
}

simulated function UIArmory_Lucu_Garage_LoadoutItem SetImage(XComGameState_Item Item, optional bool needsMask)
{
	local int i;
	local bool bUpdate;
	local array<string> NewImages;

	if (Item == none)
	{
		MC.FunctionVoid("setImages");
		return self;
	}

	NewImages = Item.GetWeaponPanelImages();

	bUpdate = false;
	for (i = 0; i < NewImages.Length; i++)
	{
		if (Images.Length <= i || Images[i] != NewImages[i])
		{
			bUpdate = true;
			break;
		}
	}

	// If no image at all is defined, mark it as empty 
	if (NewImages.length == 0)
	{
		NewImages.AddItem("");
		bUpdate = true;
	}

	if (bUpdate)
	{
		Images = NewImages;
		
		MC.BeginFunctionOp("setImages");
		MC.QueueBoolean(needsMask); // always first

		for (i = 0; i < Images.Length; i++)
			MC.QueueString(Images[i]); 

		MC.EndOp();
	}
	return self;
}

simulated function UIArmory_Lucu_Garage_LoadoutItem SetCount(int newCount) // -1 for infinite
{
	local XGParamTag kTag;
	
	if (Count != newCount)
	{
		Count = newCount;
		if (Count < 0)
		{
			MC.FunctionBool("setInfinite", true);
		}
		else
		{
			kTag = XGParamTag(`XEXPANDCONTEXT.FindTag("XGParam"));
			kTag.IntValue0 = Count;
			
			MC.FunctionString("setCount", `XEXPAND.ExpandString(m_strCount));
			MC.FunctionBool("setInfinite", false);
		}
	}
	return self;
}

simulated function UIArmory_Lucu_Garage_LoadoutItem SetSlotType(string NewSlotType)
{
	if (NewSlotType != SlotType)
	{
		SlotType = NewSlotType;
		MC.FunctionString("setSlotType", SlotType);
	}
	return self;
}

simulated function UIArmory_Lucu_Garage_LoadoutItem SetLocked(bool Locked)
{
	if (IsLocked != Locked)
	{
		IsLocked = Locked;
		MC.FunctionBool("setLocked", IsLocked);

		if (!IsLocked)
			OnLoseFocus();
	}
	return self;
}

simulated function UIArmory_Lucu_Garage_LoadoutItem SetDisabled(bool bDisabled, optional string Reason)
{
	if (IsDisabled != bDisabled)
	{
		IsDisabled = bDisabled;
		MC.BeginFunctionOp("setDisabled");
		MC.QueueBoolean(bDisabled);
		MC.QueueString(Reason);
		MC.EndOp();
	}
	return self;
}

simulated function UIArmory_Lucu_Garage_LoadoutItem SetInfinite(bool infinite)
{
	if (IsInfinite != infinite)
	{
		IsInfinite = infinite;
		MC.FunctionBool("setInfinite", IsInfinite);
	}
	return self;
}

simulated function UIArmory_Lucu_Garage_LoadoutItem SetPrototypeIcon(optional string icon) // pass empty string to hide PrototypeIcon
{
	if (PrototypeIcon != icon)
	{
		PrototypeIcon = icon;
		MC.FunctionString("setPrototype", icon);
	}
	return self;
}

simulated function UpdateCategoryIcons(optional XComGameState_Item Item)
{
	local int Index;
	local array<string> Icons;

	if (Item == none)
		Item = XComGameState_Item(`XCOMHISTORY.GetGameStateForObjectID(ItemRef.ObjectID));

	if (Item != none)
	{
		Icons = Item.GetMyWeaponUpgradeTemplatesCategoryIcons();

		if (Icons.Length == 0)
		{
			ClearIcons();
		}
		else
		{
			for (Index = 0; Index < Icons.Length; Index++)
			{
				AddIcon(Index, Icons[Index]);
			}
		}
	}
}

simulated private function AddIcon(int index, string path)
{
	MC.BeginFunctionOp("addIcon");
	MC.QueueNumber(index);
	MC.QueueString(path);
	MC.EndOp();
}

simulated private function ClearIcons()
{
	MC.FunctionVoid("clearIcons");
}

simulated function UpdateDropItemButton(optional XComGameState_Item Item)
{
	local bool bShowClearButton;

	if (!bLoadoutSlot) return;

	if (Item == none)
		Item = XComGameState_Item(`XCOMHISTORY.GetGameStateForObjectID(ItemRef.ObjectID));

	bShowClearButton = Item != none && (!ItemTemplate.bInfiniteItem && !ItemTemplate.StartingItem && ItemTemplate.ItemCat != 'lucu_garage_chassis') || Item.HasBeenModified();

	MC.SetBool("showClearButton", bShowClearButton);
	MC.FunctionVoid("realize");

	if (!bShowClearButton)
		Movie.Pres.m_kTooltipMgr.DeactivateTooltipByID(TooltipID);
}

simulated function OnReceiveFocus()
{
	if (!IsLocked && !bIsFocused)
	{
		bIsFocused = true;
		MC.FunctionVoid("onReceiveFocus");
	}
}

simulated function OnLoseFocus()
{
	if (bIsFocused)
	{
		bIsFocused = false;
		MC.FunctionVoid("onLoseFocus");
	}
}

function OnDropItemClicked(UIButton kButton)
{
	local XComGameState NewGameState;
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_Lucu_Garage_Facility FacilityState;
	local XComGameState_Item ItemState, ReplacementItemState;
	local XComGameState_Unit OwnerState;
	local XComGameState_Lucu_Garage_XtopodUnitState XtopodState;
	local array<X2ItemTemplate> BestGearTemplates;
	local bool bUpgradeSucceeded;

	if (UIArmory_Loadout_MP(Screen) != none)
	{
		UIArmory_Loadout_MP(Screen).OnStripItemsDialogCallback(eUIAction_Accept);
		return;
	}

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Drop Item From Unit Loadout");
	
	XComHQ = XComGameState_HeadquartersXCom(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
	XComHQ = XComGameState_HeadquartersXCom(NewGameState.CreateStateObject(class'XComGameState_HeadquartersXCom', XComHQ.ObjectID));
	NewGameState.AddStateObject(XComHQ);
	
	ItemState = XComGameState_Item(NewGameState.CreateStateObject(class'XComGameState_Item', ItemRef.ObjectID));
	NewGameState.AddStateObject(ItemState);

	if (ItemState.OwnerStateObject.ObjectID != 0)
	{
		OwnerState = XComGameState_Unit(NewGameState.CreateStateObject(class'XComGameState_Unit', ItemState.OwnerStateObject.ObjectID));
		NewGameState.AddStateObject(OwnerState);

		FacilityState = class'Lucu_Garage_Utilities'.static.GetFacilityComponent(XComHQ);
		FacilityState = XComGameState_Lucu_Garage_Facility(NewGameState.CreateStateObject(class'XComGameState_Lucu_Garage_Facility', FacilityState.ObjectID));
		NewGameState.AddStateObject(FacilityState);

		XtopodState = class'Lucu_Garage_Utilities'.static.GetXtopodComponent(OwnerState, FacilityState);
		XtopodState = XComGameState_Lucu_Garage_XtopodUnitState(NewGameState.CreateStateObject(class'XComGameState_Lucu_Garage_XtopodUnitState', XtopodState.ObjectID));
		NewGameState.AddStateObject(XtopodState);
		
		if (XtopodState.RemoveItemFromInventory(ItemState, NewGameState))
		{
			FacilityState.PutItemInInventory(NewGameState, ItemState); // Add the dropped item back to the Facility

			// Give the owner the best infinite item in its place
			BestGearTemplates = XtopodState.GetBestGearForItemCat(ItemCat);
			bUpgradeSucceeded = XtopodState.UpgradeEquipment(NewGameState, none, BestGearTemplates, ItemState.GetMyTemplate().ItemCat, ReplacementItemState);
			XtopodState.ValidateLoadout(NewGameState);

			`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);
			
			if (bUpgradeSucceeded)
			{
				ItemRef = ReplacementItemState.GetReference();
				ItemTemplate = ReplacementItemState.GetMyTemplate();
			}
			else
			{
				ItemRef.ObjectID = 0;
				ItemTemplate = None;
			}

			UIArmory_Lucu_Garage_Loadout(Screen).UpdateData();
			return;
		}
	}

	`XCOMHISTORY.CleanupPendingGameState(NewGameState);
}

simulated function OnCommand(string cmd, string arg)
{
	if (cmd == "DropItemClicked")
		OnDropItemClicked(DropItemButton);
}

defaultproperties
{
	Width = 342;
	Height = 145;
	bAnimateOnInit = false;
	bProcessesMouseEvents = false;
	LibID = "LoadoutListItem";
}