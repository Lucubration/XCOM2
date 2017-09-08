
//----------------------------------------------------------------------------
//  *********   FIRAXIS SOURCE CODE   ******************
//  FILE:    UIStrategyPolicy_DeckList.uc
//  AUTHOR:  Brit Steiner
//  PURPOSE: Specialized UIList that will deistribute cards until a max overlap when realizing positions. 
//----------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//----------------------------------------------------------------------------

class UIStrategyPolicy_DeckList extends UIList;

const MAX_WIDTH_BEFORE_SCROLL = 1728; //As defined by the flash stage

var private bool bSpacedOut; 
var private bool bInitialDealAnimation; 

var private int CurrentPage;
var private int TotalPages;

var private array<StateObjectReference> AllHandCards;

const CARDS_PER_PAGE = 5.0;

simulated function UIList InitList(optional name InitName,
								   optional float initX, optional float initY,
								   optional float initWidth, optional float initHeight,
								   optional bool horizontalList, optional bool addBG, optional name bgLibID)
{
	return super.InitList(InitName, , , MAX_WIDTH_BEFORE_SCROLL, 210, true);
}

// Create a UIPanel of the specified type and add it to the ItemContainer.
simulated function UIPanel CreateItem(optional class<UIPanel> ItemClass = class'UIListItemString')
{
	local UIPanel Panel; 
	Panel = super.CreateItem(ItemClass);
	Panel.AddOnInitDelegate(ItemInited);
	return Panel; 
}

simulated function ItemInited(UIPanel Panel)
{
	local int i;

	super.ItemInited(Panel); 

	if (bInitialDealAnimation == false) return; 

	for (i = 0; i < ItemCount; i++)
	{
		if (!GetItem(i).bIsInited)
			return;
	}

	//Now that we're all loaded, animate dealing the cards: 
	for (i = 0; i < ItemCount; i++)
	{
		UIStrategyPolicy_Card(GetItem(i)).DealAnimation(i);
	}

	GeneratePageInfo();

	bInitialDealAnimation = false; 
}

function array<StateObjectReference> FilterCardsToDisplay(array<StateObjectReference> HandCards)
{
	local int idx, StartingValue, EndingValue;
	local array<StateObjectReference> FilteredCards; 

	AllHandCards = HandCards;

	// If we're using the mouse, do not reduce the cards displayed 
	if( !`ISCONTROLLERACTIVE )
	{
		return HandCards;
	}

	StartingValue = CurrentPage * CARDS_PER_PAGE;
	EndingValue = StartingValue + CARDS_PER_PAGE;
	if( EndingValue > HandCards.length )
		EndingValue = HandCards.length;

	for( idx = StartingValue; idx < EndingValue; idx++ )
	{
		FilteredCards.AddItem(HandCards[idx]);
	}
	return FilteredCards; 
}

simulated function int GetItemCount()
{
	if( !`ISCONTROLLERACTIVE )
	{
		return super.GetItemCount();
	}
	else
	{
		return AllHandCards.length;
	}
}

simulated function UIPanel GetItem(int HandIndex)
{
	local int VisualCardSelected;
	if( `ISCONTROLLERACTIVE )
	{
		VisualCardSelected = HandIndex % CARDS_PER_PAGE;
		return super.GetItem(VisualCardSelected);
	}
	else
	{
		return super.GetItem(HandIndex);
	}
}

function bool ShouldTriggerPageFlipNext(int HandIndex)
{
	local int VisualCardSelected;
	
	VisualCardSelected = HandIndex % CARDS_PER_PAGE;

	if( VisualCardSelected == 0 && CanNavNext() )
		return true;
	else
		return false; 
}

function NextPage()
{
	local int MaxPages; 

	CurrentPage++;
	
	MaxPages = FCeil(float(AllHandCards.length + 1) / CARDS_PER_PAGE);
	if( CurrentPage > MaxPages -1 ) CurrentPage = MaxPages -1;
}
function PrevPage()
{
	CurrentPage--;
	if( CurrentPage < 0 ) CurrentPage = 0; 
	
}

function bool ShouldTriggerPageFlipPrev(int HandIndex)
{
	local int VisualCardSelected;

	//Need to always keep in positive to evaluate properly. 
	VisualCardSelected = (HandIndex + CARDS_PER_PAGE) % CARDS_PER_PAGE;

	if( VisualCardSelected == CARDS_PER_PAGE - 1 && CanNavPrev() )
		return true;
	else
		return false;
}

function bool CanNavNext()
{
	local int MaxPages;
	
	MaxPages = FCeil(float(AllHandCards.length + 1) / CARDS_PER_PAGE);

	return (CurrentPage < MaxPages-1);
}

function bool CanNavPrev()
{
	return (CurrentPage > 0);
}

function int GetMaxCardsOnCurrentPage()
{
	if( CanNavNext() )
	{
		return CARDS_PER_PAGE;
	}
	else
	{
		return AllHandCards.length % CARDS_PER_PAGE;
	}
}

public function int GetTargetColumnNav(int HandIndex)
{
	local int VisualCardSelected;

	VisualCardSelected = HandIndex % CARDS_PER_PAGE;

	//Manually mapping these for a visual layout 
	switch( VisualCardSelected )
	{
		case(0): return 0;
		case(1): return 1;
		case(2): return 1;
		case(3): return 2;
		case(4): return 3;

		default: return 0; 
	}
}

public function int GetTargetHandNav(int iColIndex)
{
	local int VisualCardToSelect;

	//Manually mapping these for a visual layout 
	switch( iColIndex )
	{
	case(0): VisualCardToSelect = 0; break;
	case(1): VisualCardToSelect = 1; break;
	//note you don't hop down to card #2, grid mis-match 
	case(2): VisualCardToSelect = 3; break;
	case(3): VisualCardToSelect = 4; break;

	default: VisualCardToSelect = 0; break;
	}

	if( VisualCardToSelect > ItemCount -1 )
		VisualCardToSelect = ItemCount - 1;

	return ((CurrentPage * CARDS_PER_PAGE) + VisualCardToSelect);
}

private function GeneratePageInfo()
{
	TotalPages = int( float(ItemCount) / CARDS_PER_PAGE);

	//One page minimum: 
	if( TotalPages < 1 ) TotalPages = 1;
}

simulated function ClearItems()
{
	super.ClearItems();
	bSpacedOut = false;
}
function ClearPagination()
{
	CurrentPage = 0;
	TotalPages = 1;
}

simulated function RealizeItems(optional int StartingIndex)
{
	local int i;
	local float NextItemPosition;
	local UIStrategyPolicy_Card Card;
	local int CalculatedWidth; 

	CalculatedWidth = MAX_WIDTH_BEFORE_SCROLL / ItemCount;
	NextItemPosition = 0;

	if( CalculatedWidth > class'UIStrategyPolicy_Card'.const.NORMAL_BG_WIDTH )
	{
		//Cap at the max width of a card. 
		if( CalculatedWidth > class'UIStrategyPolicy_Card'.const.MAX_BG_WIDTH 
		   || `ISCONTROLLERACTIVE ) //NO OVERLAPPING ON CONTROLLER 
			CalculatedWidth = class'UIStrategyPolicy_Card'.const.MAX_BG_WIDTH;

		for( i = 0; i < ItemCount; ++i )
		{
			Card = UIStrategyPolicy_Card(GetItem(i));

			Card.SetX(NextItemPosition);
			NextItemPosition += CalculatedWidth + (i < ItemCount - 1) ? ItemPadding : 0;
			
		}

		TotalItemSize = NextItemPosition;
		bSpacedOut = true; 

	}
	else
	{
		if( bSpacedOut )
		{
			//Need to start from zero to update placement. 
			super.RealizeItems(0);
		}
		else
		{
			super.RealizeItems(StartingIndex);
		}
	}
}

simulated function AnimateIn(optional float Delay = -1.0)
{
	if( Delay == -1.0 && ParentPanel != none )
		Delay = ParentPanel.GetChildIndex(self) * class'UIUtilities'.const.INTRO_ANIMATION_DELAY_PER_INDEX;

	AddTweenBetween("_alpha", 0, Alpha, class'UIUtilities'.const.INTRO_ANIMATION_TIME, Delay);
}


simulated function RealizeMaskAndScrollbar()
{
	super.RealizeMaskAndScrollbar();

	//ALWAYS want a mask for this, for animations. 
	if (Mask == none && bInitialDealAnimation)
	{
		Mask = Spawn(class'UIMask', self).InitMask('ListMask');
		Mask.SetMask(ItemContainer);
		Mask.SetSize(Width, Height);
	}

	if( `ISCONTROLLERACTIVE )
	{
		if( ScrollBar != none )
		{
			Scrollbar.Remove();
			Scrollbar = none;
		}
	}
}


defaultproperties
{
	bAnimateOnInit = true;
	bInitialDealAnimation = true;
	CurrentPage = 1; 
	TotalPages = 1;
}
