class UIResistanceOps extends UISimpleCommodityScreen;

var StateObjectReference RegionRef;

//-------------- EVENT HANDLING --------------------------------------------------------
simulated function OnPurchaseClicked(UIList kList, int itemIndex)
{
	if (itemIndex != iSelectedItem)
	{
		iSelectedItem = itemIndex;
	}

	if( CanAffordItem(iSelectedItem) )
	{
		PlaySFX("BuildItem");
		GetItems();
		PopulateData();
	}
	else
	{
		PlayNegativeSound(); // bsg-jrebar (4/20/17): New PlayNegativeSound Function in Parent Class
	}
}

//-------------- GAME DATA HOOKUP --------------------------------------------------------
simulated function GetItems()
{
	XComHQ = class'UIUtilities_Strategy'.static.GetXComHQ();
	arrItems.Length = 0;
}

simulated function XComGameState_Haven GetHaven()
{
	return XComGameState_WorldRegion(`XCOMHISTORY.GetGameStateForObjectID(RegionRef.ObjectID)).GetHaven();
}

defaultproperties
{
	m_eStyle = eUIConfirmButtonStyle_BuyCash;
}