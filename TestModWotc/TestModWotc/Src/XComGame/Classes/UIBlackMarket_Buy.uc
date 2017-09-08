class UIBlackMarket_Buy extends UISimpleCommodityScreen;

var StateObjectReference	BlackMarketRef;
var localized String	m_strBuyConfirmTitle;
var localized String	m_strBuyConfirmText;

simulated function InitScreen(XComPlayerController InitController, UIMovie InitMovie, optional name InitName)
{
	m_strTitle = ""; //Clear the header out intentionally. 	
	super.InitScreen(InitController, InitMovie, InitName);
	SetBlackMarketLayout();

	MC.BeginFunctionOp("SetGreeble");
	MC.QueueString(class'UIAlert'.default.m_strBlackMarketFooterLeft);
	MC.QueueString(class'UIAlert'.default.m_strBlackMarketFooterRight);
	MC.QueueString(class'UIAlert'.default.m_strBlackMarketLogoString);
	MC.EndOp();
}

//-------------- EVENT HANDLING --------------------------------------------------------
simulated function OnPurchaseClicked(UIList kList, int itemIndex)
{
	if (itemIndex != iSelectedItem)
	{
		iSelectedItem = itemIndex;
	}

	if( CanAffordItem(iSelectedItem) )
	{
		if(`ISCONTROLLERACTIVE == false)
		{
			DisplayConfirmBuyDialog();
			return; //will copy the functions below into the confirmation callback function
		}
		PlaySFX("StrategyUI_Purchase_Item");
		GetMarket().BuyBlackMarketItem(arrItems[iSelectedItem].RewardRef);
		GetItems();
		PopulateData();
	}
	else
	{
		PlayNegativeSound(); // bsg-jrebar (4/20/17): New PlayNegativeSound Function in Parent Class
	}
	XComHQPresentationLayer(Movie.Pres).m_kAvengerHUD.UpdateResources();
}

//bsg-crobinson (5.4.17): Clear navhelp when we lose focus
simulated function OnLoseFocus()
{
	super.OnLoseFocus();
	`HQPRES.m_kAvengerHUD.NavHelp.ClearButtonHelp(); 
}
//bsg-crobinson (5.4.17): end

function DisplayConfirmBuyDialog()
{
	local TDialogueBoxData kConfirmData;
	local Commodity ItemCommodity;
	local String ItemCost;

	ItemCommodity = arrItems[iSelectedItem];
	ItemCost = class'UIUtilities_Strategy'.static.GetStrategyCostString(ItemCommodity.Cost, ItemCommodity.CostScalars, ItemCommodity.DiscountPercent);

	kConfirmData.eType = eDialog_Warning;
	kConfirmData.strTitle = m_strBuyConfirmTitle;
	kConfirmData.strText = Repl(m_strBuyConfirmText,"<amount>",Caps(ItemCost));
	kConfirmData.strAccept = class'UIUtilities_Text'.default.m_strGenericConfirm;
	kConfirmData.strCancel = class'UIUtilities_Text'.default.m_strGenericCancel;

	kConfirmData.fnCallback = OnDisplayConfirmBuyDialogAction;

	Movie.Pres.UIRaiseDialog(kConfirmData);
}

function OnDisplayConfirmBuyDialogAction(Name eAction)
{
	if (eAction == 'eUIAction_Accept')
	{
		PlaySFX("StrategyUI_Purchase_Item");
		GetMarket().BuyBlackMarketItem(arrItems[iSelectedItem].RewardRef);
		GetItems();
		PopulateData();
		XComHQPresentationLayer(Movie.Pres).m_kAvengerHUD.UpdateResources();
	}
}

//-------------- GAME DATA HOOKUP --------------------------------------------------------
simulated function XComGameState_BlackMarket GetMarket()
{
	return class'UIUtilities_Strategy'.static.GetBlackMarket();
}

simulated function String GetButtonString(int ItemIndex)
{
	local StateObjectReference RewardRef;
	local XComGameState_Reward RewardState;
	local XComGameState_Unit UnitState;

	RewardRef = arrItems[ItemIndex].RewardRef;

	RewardState = XComGameState_Reward(History.GetGameStateForObjectID(RewardRef.ObjectID));
	UnitState = XComGameState_Unit(History.GetGameStateForObjectID(RewardState.RewardObjectReference.ObjectID));

	if( UnitState != none )
	{
		return class'UIRecruitmentListItem'.default.RecruitConfirmLabel;
	}
	else
	{
		return m_strBuy;
	}
}

simulated function GetItems()
{
	local XComGameState NewGameState;
	local XComGameState_BlackMarket BlackMarketState;

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Update Tech Rushes");
	BlackMarketState = XComGameState_BlackMarket(NewGameState.ModifyStateObject(class'XComGameState_BlackMarket', GetMarket().ObjectID));
	BlackMarketState.UpdateTechRushItems(NewGameState);
	BlackMarketState.UpdateHuntChosenItems(NewGameState);
	`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);

	XComHQ = class'UIUtilities_Strategy'.static.GetXComHQ();
	arrItems = GetMarket().GetForSaleList();

	if(arrItems.Length <= 0)
		CloseScreen(); //bsg-crobinson (5.22.17): Force player out if they run out of items to buy
}

defaultproperties
{
	bConsumeMouseEvents = true;
}
