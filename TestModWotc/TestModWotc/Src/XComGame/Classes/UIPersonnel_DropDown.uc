
class UIPersonnel_DropDown extends UIPanel
	dependson(UIPersonnel);

//----------------------------------------------------------------------------
// MEMBERS

// UI
var int m_iMaskWidth;
var int m_iMaskHeight;

var UIList m_kList;

// Gameplay
var XComGameState GameState; // setting this allows us to display data that has not yet been submitted to the history 
var XComGameState_HeadquartersXCom HQState;
var array<StaffUnitInfo> m_staff;
var StateObjectReference SlotRef;

// Delegates
var bool m_bRemoveWhenUnitSelected;
var public delegate<OnPersonnelSelected> onSelectedDelegate;
var public delegate<OnDropDownSizeRealized> OnDropDownSizeRealizedDelegate;

delegate OnPersonnelSelected(StaffUnitInfo selectedUnitInfo);
delegate OnButtonClickedDelegate(UIButton ButtonControl);
delegate OnDropDownSizeRealized(float CtlWidth, float CtlHeight);

//----------------------------------------------------------------------------
// FUNCTIONS

simulated function InitDropDown(optional delegate<OnDropDownSizeRealized> OnDropDownSizeRealizedDel)
{	
	// Init UI
	super.InitPanel();

	m_kList = Spawn(class'UIList', self);
	m_kList.bIsNavigable = true;
	m_kList.InitList('listAnchor', , 5, m_iMaskWidth, m_iMaskHeight);
	m_kList.bStickyHighlight = false;
	m_kList.OnItemClicked = OnStaffSelected;
	
	OnDropDownSizeRealizedDelegate = OnDropDownSizeRealizedDel;
	
	HQState = class'UIUtilities_Strategy'.static.GetXComHQ();

	RefreshData();
}

simulated function ClearDelayTimer()
{
	ClearTimer('CloseMenu');
}

simulated function TryToStartDelayTimer(optional array<string> args)
{	
	local string TargetPath; 
	local int iFoundIndex, iPathBit; 

	TargetPath = Movie.GetPathUnderMouse();

	if (TargetPath == "undefined" && args.length > 0)
	{
		TargetPath = args[0];
		for(iPathBit = 1; iPathBit < args.length; iPathBit++)
		{
			TargetPath $= ("." $ args[iPathBit]);
		}
	}

	iFoundIndex = InStr(TargetPath, MCName);

	if (iFoundIndex == -1)
	{
		//Try to see if something else in the screen has the mouse, like the background art.
		iFoundIndex = InStr(TargetPath, Screen.MCName);
	}

	if( iFoundIndex == -1 ) //We're moused completely off this movie clip, which includes all children.
	{
		SetTimer(1.0, false, 'CloseMenu');
	}
}

simulated function CloseMenu()
{
	Hide();
}

simulated function Show()
{
	RefreshData();
	super.Show();
}

simulated function RefreshData()
{
	UpdateData();
	UpdateList();
}

simulated function UpdateData()
{
	local XComGameStateHistory History;
	local XComGameState_StaffSlot SlotState;
	local array<StaffUnitInfo> ValidUnits;
	local StaffUnitInfo UnitInfo;

	// Destroy old data
	m_staff.Length = 0;
		
	History = `XCOMHISTORY;
	SlotState = XComGameState_StaffSlot(History.GetGameStateForObjectID(SlotRef.ObjectID));
		
	// If staff slot is filled and can be relocated, add an Empty Ref unit to represent the slot
	if (SlotState.IsSlotFilled())
	{
		m_staff.AddItem(UnitInfo);
	}
	
	// Get the valid units for this staff slot and add them to the list
	ValidUnits = SlotState.GetValidUnitsForSlot();
	foreach ValidUnits(UnitInfo)
	{
		m_staff.AddItem(UnitInfo);
	}
		
	m_staff.Sort(SortByRank);
	m_staff.Sort(SortStaff);
}

simulated function int SortStaff(StaffUnitInfo UnitInfoA, StaffUnitInfo UnitInfoB)
{
	local EStaffStatus UnitAStatus;
	local EStaffStatus UnitBStatus;

	UnitAStatus = class'X2StrategyGameRulesetDataStructures'.static.GetStafferStatus(UnitInfoA);
	UnitBStatus = class'X2StrategyGameRulesetDataStructures'.static.GetStafferStatus(UnitInfoB);

	if (UnitAStatus > UnitBStatus)
	{
		return -1;
	}

	if (UnitAStatus < UnitBStatus)
	{
		return 1;
	}		

	return 0;
}

simulated function int SortByRank(StaffUnitInfo UnitInfoA, StaffUnitInfo UnitInfoB)
{
	local XComGameState_Unit UnitA, UnitB;
	local int RankA, RankB;

	UnitA = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(UnitInfoA.UnitRef.ObjectID));
	UnitB = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(UnitInfoB.UnitRef.ObjectID));

	// Do not try to sort Sci and Eng by rank
	if (UnitA.IsSoldier() && UnitB.IsSoldier())
	{
		RankA = UnitA.GetRank();
		RankB = UnitB.GetRank();

		if (RankA < RankB)
		{
			return -1;
		}
		else if (RankA > RankB)
		{
			return 1;
		}
	}
	
	return 0;
}

simulated function UpdateList()
{
	m_kList.ClearItems();
	PopulateListInstantly();
	m_kList.Navigator.SelectFirstAvailable();
}

simulated function UpdateItemWidths()
{
	local int Idx;
	local float MaxWidth, MaxHeight;

	for ( Idx = 0; Idx < m_kList.itemCount; ++Idx )
	{
		if ( !UIPersonnel_DropDownListItem(m_kList.GetItem(Idx)).bSizeRealized )
		{
			return;
		}

		MaxWidth = Max(MaxWidth, m_kList.GetItem(Idx).Width);
		MaxHeight += m_kList.GetItem(Idx).Height;
	}

	Width = MaxWidth;
	Height = MaxHeight;

	for ( Idx = 0; Idx < m_kList.itemCount; ++Idx )
	{
		m_kList.GetItem(Idx).SetWidth(Width);
	}

	if (OnDropDownSizeRealizedDelegate != none)
	{
		OnDropDownSizeRealizedDelegate(Width, Height);
	}

	m_kList.SetWidth(MaxWidth);
}

// calling this function will add items instantly
simulated function PopulateListInstantly()
{
	local UIPersonnel_DropDownListItem kItem;

	while( m_kList.itemCount < m_staff.Length )
	{
		kItem = Spawn(class'UIPersonnel_DropDownListItem', m_kList.itemContainer);
		kItem.OnDimensionsRealized = UpdateItemWidths;
		kItem.InitListItem(self, m_staff[m_kList.itemCount], SlotRef);
	}
}

// calling this function will add items sequentially, the next item loads when the previous one is initialized
simulated function PopulateListSequentially( UIPanel Control )
{
	local UIPersonnel_DropDownListItem kItem;

	if(m_kList.itemCount < m_staff.Length)
	{
		kItem = Spawn(class'UIPersonnel_DropDownListItem', m_kList.itemContainer);
		kItem.OnDimensionsRealized = UpdateItemWidths;
		kItem.InitListItem(self, m_staff[m_kList.itemCount], SlotRef);
		kItem.AddOnInitDelegate(PopulateListSequentially);
	}
}

//------------------------------------------------------

simulated function bool OnUnrealCommand(int cmd, int arg)
{
	if( !CheckInputIsReleaseOrDirectionRepeat(cmd, arg) )
		return false;

	switch( cmd )
	{
`if(`notdefined(FINAL_RELEASE))
		case class'UIUtilities_Input'.const.FXS_KEY_TAB:
`endif
		case class'UIUtilities_Input'.const.FXS_BUTTON_A:
		case class'UIUtilities_Input'.const.FXS_KEY_ENTER:
		case class'UIUtilities_Input'.const.FXS_KEY_SPACEBAR:
			OnAccept();
			return true;

		case class'UIUtilities_Input'.const.FXS_BUTTON_B:
		case class'UIUtilities_Input'.const.FXS_KEY_ESCAPE:
		case class'UIUtilities_Input'.const.FXS_R_MOUSE_DOWN:
			OnCancel();
			return true;
	}

	if (m_kList.Navigator.OnUnrealCommand(cmd, arg))
		return true;

	return super.OnUnrealCommand(cmd, arg);
}

//------------------------------------------------------

simulated function OnStaffSelected( UIList kList, int index )
{
	if( onSelectedDelegate != none )
	{
		onSelectedDelegate(m_staff[index]);
		Hide();
	}
}

//------------------------------------------------------

simulated function OnAccept()
{
	OnStaffSelected(m_kList, m_kList.selectedIndex  < 0 ? 0 : m_kList.selectedIndex);
}

simulated function OnCancel()
{
	`XSTRATEGYSOUNDMGR.PlaySoundEvent("Stop_AvengerAmbience");
	`XSTRATEGYSOUNDMGR.PlaySoundEvent("Play_AvengerNoRoom");
	Hide();
}

//==============================================================================

defaultproperties
{
	LibID = "EmptyControl"; // the dropdown itself is just an empty container

	bIsNavigable = false;
	m_iMaskWidth = 420;
	m_iMaskHeight = 794;
}
