
class UIFacilitySummary extends UIScreen;

enum EFacilitySortType
{
	eFacilitySortType_Name,
	eFacilitySortType_Staff,
	eFacilitySortType_Power,
	eFacilitySortType_ConstructionDate,
	eFacilitySortType_Status,
};

// these are set in UIFacilitySummary_HeaderButton
var bool m_bFlipSort;
var EFacilitySortType m_eSortType;

var UIPanel       m_kHeader;
var UIPanel       m_kContainer; // contains all controls bellow
var UIList  m_kList;
var UIBGBox  m_kListBG;

//bsg-crobinson (5.15.17): sorting variables
var int m_iSortTypeOrderIndex;
var array<EFacilitySortType> m_aSortTypeOrder;
var bool m_bDirtySortHeaders;
//bsg-crobinson (5.15.17): end

var array<XComGameState_FacilityXCom> m_arrFacilities;

var localized string m_strTitle;

var public localized string m_strChangeColumn; //bsg-crobinson (5.15.17): Add in change column string
var public localized string m_strToggleSort;

var UIX2ScreenHeader Header;

simulated function InitScreen(XComPlayerController InitController, UIMovie InitMovie, optional name InitName)
{
	super.InitScreen(InitController, InitMovie, InitName);
	
	m_kContainer = Spawn(class'UIPanel', self).InitPanel();
	m_kContainer.SetPosition(300, 85);
	
	// add BG
	m_kListBG = Spawn(class'UIBGBox', m_kContainer);
	m_kListBG.InitPanel('', class'UIUtilities_Controls'.const.MC_X2Background).SetSize(1310, 940);

	Header = `HQPRES.m_kAvengerHUD.FacilityHeader;
	Header.SetText(class'UIFacility'.default.m_strAvengerLocationName, m_strTitle);
	Header.Show();

	m_kList = Spawn(class'UIList', m_kContainer).InitList('', 15, 60, 1265, 840);
	m_kList.OnItemClicked = OnFacilitySelectedCallback;
	m_kList.OnSelectionChanged = SelectedItemChanged; //bsg-crobinson (4.26.17): Update the navhelp on selection change

	// allows list to scroll when mouse is touching the BG
	m_kListBG.ProcessMouseEvents(m_kList.OnChildMouseEvent);

	m_eSortType = eFacilitySortType_Name;

	m_kHeader = Spawn(class'UIPanel', self).InitPanel('', 'FacilitySummaryHeader');

	Spawn(class'UIFacilitySummary_HeaderButton', m_kHeader).InitHeaderButton("name", eFacilitySortType_Name);
	Spawn(class'UIFacilitySummary_HeaderButton', m_kHeader).InitHeaderButton("staff", eFacilitySortType_Staff);
	Spawn(class'UIFacilitySummary_HeaderButton', m_kHeader).InitHeaderButton("power", eFacilitySortType_Power);
	Spawn(class'UIFacilitySummary_HeaderButton', m_kHeader).InitHeaderButton("construction", eFacilitySortType_ConstructionDate);
	Spawn(class'UIFacilitySummary_HeaderButton', m_kHeader).InitHeaderButton("status", eFacilitySortType_Status);

	UpdateNavHelp();
	UpdateData();
}

//bsg-crobinson (4.26.17): Update the navhelp on selection change
simulated function SelectedItemChanged(UIList ContainerList, int ItemIndex)
{
	UpdateNavHelp();
}
//bsg-crobinson (4.26.17): end

simulated function UpdateData()
{
	local int i;
	local XComGameState_FacilityXCom Facility;
	local UIFacilitySummary_ListItem FacilityItem;

	if(m_arrFacilities.Length == 0)
	{
		foreach `XCOMHISTORY.IterateByClassType(class'XComGameState_FacilityXCom', Facility)
		{
			//if( Facility.StaffSlots.length > 0 || Facility.UpkeepCost > 0) //Include all facilities that have staffing slots or an upkeep cost
			m_arrFacilities.AddItem(Facility);
		}
	}

	//bsg-crobinson (5.15.17): Add headers to the sort array
	m_aSortTypeOrder.Length = 0;
	m_aSortTypeOrder.AddItem(eFacilitySortType_Name);
	m_aSortTypeOrder.AddItem(eFacilitySortType_Staff);
	m_aSortTypeOrder.AddItem(eFacilitySortType_Power);
	m_aSortTypeOrder.AddItem(eFacilitySortType_ConstructionDate);
	m_aSortTypeOrder.AddItem(eFacilitySortType_Status);

	m_iSortTypeOrderIndex = m_aSortTypeOrder.Find(m_eSortType);

	if (m_iSortTypeOrderIndex == INDEX_NONE)
	{
		m_iSortTypeOrderIndex = 0;
	}
	//bsg-crobinson (5.15.17): end

	SortFacilities();

	// Clear old data
	m_kList.ClearItems();

	for(i = 0; i < m_arrFacilities.Length; ++i)
	{
		FacilityItem = UIFacilitySummary_ListItem(m_kList.CreateItem(class'UIFacilitySummary_ListItem')).InitListItem();
		FacilityItem.UpdateData(m_arrFacilities[i].GetReference());
	}
	
	m_bDirtySortHeaders = false;

	// bsg-jrebar (4.4.17): Reset the active index to 0 so the highlight reengages after losing focus.
	if(`ISCONTROLLERACTIVE)
	{
		m_kList.SetSelectedIndex(0);
	}
	// bsg-jrebar (4.4.17): end
}

//bsg-crobinson (5.15.17): Update headers
simulated function UpdateSortHeaders()
{
	local int i;
	local array<UIPanel> SortButtons;
	local UIFacilitySummary_HeaderButton SortButton;

	m_kHeader.GetChildrenOfType(class'UIFacilitySummary_HeaderButton', SortButtons);
	for (i = 0; i < SortButtons.Length; ++i)
	{
		SortButton = UIFacilitySummary_HeaderButton(SortButtons[i]);
		SortButton.RealizeSortOrder();
		SortButton.SetArrow(m_bFlipSort);
		if (SortButton.IsSelected())
		{
			SortButton.OnReceiveFocus();
		}
	}
}
//bsg-crobinson (5.15.17): end

simulated function UpdateNavHelp()
{
	`HQPRES.m_kAvengerHUD.NavHelp.ClearButtonHelp();
	`HQPRES.m_kAvengerHUD.NavHelp.bIsVerticalHelp = `ISCONTROLLERACTIVE;
	`HQPRES.m_kAvengerHUD.NavHelp.AddBackButton(OnCancel);

	if( UIFacilitySummary_ListItem(m_kList.GetSelectedItem()).m_FacilityName != 'CommandersQuarters') //bsg-crobinson (4.26.17): Assure we arent looking at commanders quarters
		`HQPRES.m_kAvengerHUD.NavHelp.AddSelectNavHelp(); //bsg-jrebar (4.3.17): Add Select Help Button

	if( `ISCONTROLLERACTIVE )
	{
		`HQPRES.m_kAvengerHUD.NavHelp.AddLeftHelp(m_strToggleSort, class'UIUtilities_Input'.static.GetGamepadIconPrefix() $ class'UIUtilities_Input'.const.ICON_X_SQUARE);
		`HQPRES.m_kAvengerHUD.NavHelp.AddLeftHelp(m_strChangeColumn, class'UIUtilities_Input'.const.ICON_DPAD_HORIZONTAL); //bsg-crobinson (5.15.17): add change col navhelp
	}
}

simulated function OnReceiveFocus()
{
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_FacilityXCom FacilityState;

	super.OnReceiveFocus();
	UpdateData();
	UpdateNavHelp(); //bsg-jrebar (4.3.17): On receive focus, update the Nav Help fresh.
	Show();

	// Move the camera back to the Commander's Quarters
	XComHQ = XComGameState_HeadquartersXCom(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
	FacilityState = XComHQ.GetFacilityByName('CommandersQuarters');
	`HQPRES.CAMLookAtRoom(FacilityState.GetRoom(), `HQINTERPTIME);
}

simulated function OnLoseFocus()
{
	super.OnLoseFocus();
	`HQPRES.m_kAvengerHUD.FacilityHeader.Hide();
	Hide();
}

simulated function OnFacilitySelectedCallback(UIList list, int itemIndex)
{
	if(UIFacilitySummary_ListItem(m_kList.GetSelectedItem()).m_FacilityName != 'CommandersQuarters') //bsg-crobinson (4.26.17): Be sure we dont select the commanders quarters if we're already in it
		class'UIUtilities_Strategy'.static.SelectFacility(UIFacilitySummary_ListItem(list.GetItem(itemIndex)).FacilityRef);
}

simulated function OnCancel()
{
	// TODO: Make sure items are decrypted before continuing
	Movie.Stack.Pop(self);
}

simulated function bool OnUnrealCommand(int cmd, int arg)
{
	// Only pay attention to presses or repeats; ignoring other input types
	// NOTE: Ensure repeats only occur with arrow keys
	if ( !CheckInputIsReleaseOrDirectionRepeat(cmd, arg) )
		return false;

	if (m_kList.GetSelectedItem().OnUnrealCommand(cmd, arg))
	{
		return true;
	}
	switch( cmd )
	{
		// OnAccept
		case class'UIUtilities_Input'.const.FXS_BUTTON_B:
		case class'UIUtilities_Input'.const.FXS_KEY_ESCAPE:
		case class'UIUtilities_Input'.const.FXS_R_MOUSE_DOWN:
			OnCancel();
			return true;
		case class'UIUtilities_Input'.const.FXS_BUTTON_START:
			`HQPRES.UIPauseMenu( ,true );
			return true;

		//bsg-crobinson (5.15.17): X does flipsort, dpad changes columns
		case class'UIUtilities_Input'.const.FXS_BUTTON_X:
			m_bFlipSort = !m_bFlipSort;
			UpdateData();
			m_kList.SetSelectedIndex(0, true);
			return true;

		case class'UIUtilities_Input'.const.FXS_DPAD_LEFT:
		case class'UIUtilities_Input'.const.FXS_VIRTUAL_LSTICK_LEFT:			
			m_bFlipSort = false;
			m_iSortTypeOrderIndex--;
			if (m_iSortTypeOrderIndex < 0)
			{
				m_iSortTypeOrderIndex = m_aSortTypeOrder.Length - 1;
			}

			m_eSortType = EFacilitySortType(m_aSortTypeOrder[m_iSortTypeOrderIndex]);
			m_bDirtySortHeaders = true;
			UpdateSortHeaders();
			return true;

		case class'UIUtilities_Input'.const.FXS_DPAD_RIGHT:
		case class'UIUtilities_Input'.const.FXS_VIRTUAL_LSTICK_RIGHT:
			m_bFlipSort = false;
			m_iSortTypeOrderIndex++;
			if (m_iSortTypeOrderIndex >= m_aSortTypeOrder.Length)
			{
				m_iSortTypeOrderIndex = 0;
			}

			m_eSortType = EFacilitySortType(m_aSortTypeOrder[m_iSortTypeOrderIndex]);
			m_bDirtySortHeaders = true;
			UpdateSortHeaders();
			return true;
			//bsg-crobinson (5.15.17): end
	}
	return super.OnUnrealCommand(cmd, arg);
}

function SortFacilities()
{
	local int i;
	local array<UIPanel> SortButtons;
	local UIFacilitySummary_HeaderButton SortButton;
	switch(m_eSortType)
	{
	case eFacilitySortType_Name: m_arrFacilities.Sort(SortByName); break;
	case eFacilitySortType_Staff: m_arrFacilities.Sort(SortByStaff); break;
	case eFacilitySortType_Power: m_arrFacilities.Sort(SortByPower); break;
	case eFacilitySortType_ConstructionDate: m_arrFacilities.Sort(SortByConstructionDate); break;
	case eFacilitySortType_Status: m_arrFacilities.Sort(SortByStatus); break;
	}
	//INS:
	m_kHeader.GetChildrenOfType(class'UIFacilitySummary_HeaderButton', SortButtons);
	for (i = 0; i < SortButtons.Length; ++i)
	{
		SortButton = UIFacilitySummary_HeaderButton(SortButtons[i]);
		SortButton.SetArrow(m_bFlipSort);
		if (SortButton.IsSelected())
		{
			SortButton.OnReceiveFocus();
			SortButton.MC.FunctionBool("setArrowVisible", true);
		}
		else
		{
			SortButton.OnLoseFocus();
			SortButton.MC.FunctionBool("setArrowVisible", false);
		}
	}
}

simulated function int SortByName(XComGameState_FacilityXCom A, XComGameState_FacilityXCom B)
{
	local string NameA, NameB;

	NameA = A.GetMyTemplate().DisplayName;
	NameB = B.GetMyTemplate().DisplayName;

	if(NameA < NameB) return m_bFlipSort ? -1 : 1;
	else if(NameA > NameB) return m_bFlipSort ? 1 : -1;
	else return 0;
}

simulated function int SortByStaff(XComGameState_FacilityXCom A, XComGameState_FacilityXCom B)
{
	local int StaffA, StaffB;

	StaffA = A.GetNumFilledStaffSlots();
	StaffB = B.GetNumFilledStaffSlots();

	if(StaffA < StaffB) return m_bFlipSort ? -1 : 1;
	else if(StaffA > StaffB) return m_bFlipSort ? 1 : -1;
	return 0;
}

simulated function int SortByPower(XComGameState_FacilityXCom A, XComGameState_FacilityXCom B)
{
	local int PowerA, PowerB;

	PowerA = A.GetPowerOutput();
	PowerB = B.GetPowerOutput();

	if(PowerA < PowerB) return m_bFlipSort ? -1 : 1;
	else if(PowerA > PowerB) return m_bFlipSort ? 1 : -1;
	else return 0;
}

simulated function int SortByConstructionDate(XComGameState_FacilityXCom A, XComGameState_FacilityXCom B)
{
	if(class'X2StrategyGameRulesetDataStructures'.static.LessThan(A.ConstructionDateTime, B.ConstructionDateTime)) return m_bFlipSort ? -1 : 1;
	else if(class'X2StrategyGameRulesetDataStructures'.static.LessThan(B.ConstructionDateTime, A.ConstructionDateTime)) return m_bFlipSort ? 1 : -1;
	else return 0;
}

simulated function int SortByStatus(XComGameState_FacilityXCom A, XComGameState_FacilityXCom B)
{
	local string StatusA, StatusB, QueueA, QueueB;

	StatusA = A.GetStatusMessage();
	StatusB = B.GetStatusMessage();
	QueueA = A.GetQueueMessage();
	QueueB = B.GetQueueMessage();

	if( StatusA == StatusB )
	{
		if(QueueA < QueueB) return m_bFlipSort ? -1 : 1;
		else if(QueueA > QueueB) return m_bFlipSort ? 1 : -1;
		else return 0;
	}
	if(StatusA < StatusB) 
	{
		return m_bFlipSort ? -1 : 1;
	}
	else if(StatusA > StatusB) 
	{
		return m_bFlipSort ? 1 : -1;
	}
	else 
		return 0;
}

defaultproperties
{
	Package   = "/ package/gfxFacilitySummary/FacilitySummary";
	InputState = eInputState_Evaluate; //bsg-crobinson (5.1.17): Don't consume the input so facility changes dont lose functionality
}