//---------------------------------------------------------------------------------------
//  FILE:    XComGameState_StrategyCard.uc
//  AUTHOR:  Mark Nauta  --  10/4/2016
//  PURPOSE: This object represents the instance data for a strategy action card
//           in the XCOM 2 strategy game
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class XComGameState_StrategyCard extends XComGameState_BaseObject;

// Template info
var protected name								  m_TemplateName;
var protected X2StrategyCardTemplate	          m_Template;

var bool										  bNewCard; // Is this a new card
var bool										  bDrawn; // Has this card been drawn from the deck of playable cards

//#############################################################################################
//----------------   INITIALIZATION   ---------------------------------------------------------
//#############################################################################################

//---------------------------------------------------------------------------------------
static function X2StrategyElementTemplateManager GetMyTemplateManager()
{
	return class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager();
}

//---------------------------------------------------------------------------------------
simulated function name GetMyTemplateName()
{
	return m_TemplateName;
}

//---------------------------------------------------------------------------------------
simulated function X2StrategyCardTemplate GetMyTemplate()
{
	if(m_Template == none)
	{
		m_Template = X2StrategyCardTemplate(GetMyTemplateManager().FindStrategyElementTemplate(m_TemplateName));
	}
	return m_Template;
}

//---------------------------------------------------------------------------------------
function OnCreation(optional X2DataTemplate Template)
{
	m_Template = X2StrategyCardTemplate(Template);
	m_TemplateName = Template.DataName;
}

//---------------------------------------------------------------------------------------
static function SetUpStrategyCards(XComGameState StartState)
{
	local X2StrategyElementTemplateManager StratMgr;
	local array<X2StrategyElementTemplate> AllCardTemplates;
	local X2StrategyCardTemplate CardTemplate;
	local XComGameState_StrategyCard CardState;
	local array<XComGameState_StrategyCard> PossibleContinentBonusCards;
	local XComGameState_Continent ContinentState;
	local int idx, RandIndex;

	StratMgr = class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager();
	AllCardTemplates = StratMgr.GetAllTemplatesOfClass(class'X2StrategyCardTemplate');

	for(idx = 0; idx < AllCardTemplates.Length; idx++)
	{
		CardTemplate = X2StrategyCardTemplate(AllCardTemplates[idx]);

		// Only Create Resistance Cards here, Chosen cards need to be created on the fly
		if(CardTemplate != none && CardTemplate.Category == "ResistanceCard")
		{
			CardState = CardTemplate.CreateInstanceFromTemplate(StartState);

			if (CardTemplate.bContinentBonus)
			{
				PossibleContinentBonusCards.AddItem(CardState);
			}
		}
	}

	// Grab All Continents and assign cards as their bonus
	foreach StartState.IterateByClassType(class'XComGameState_Continent', ContinentState)
	{
		if (PossibleContinentBonusCards.Length > 0)
		{
			RandIndex = `SYNC_RAND_STATIC(PossibleContinentBonusCards.Length);
			CardState = PossibleContinentBonusCards[RandIndex];
			ContinentState.ContinentBonusCard = CardState.GetReference();
			CardState.bDrawn = true; // Flag the card as drawn so it doesn't show up elsewhere in the game
			PossibleContinentBonusCards.Remove(RandIndex, 1);
		}
		else
		{
			`RedScreen("@Design Not enough Strategy Cards are flagged as possible continent bonuses!");
		}
	}
}

//#############################################################################################
//----------------   DISPLAY INFO   -----------------------------------------------------------
//#############################################################################################

//---------------------------------------------------------------------------------------
function string GetDisplayName()
{
	if(GetMyTemplate().GetDisplayNameFn != none)
	{
		return GetMyTemplate().GetDisplayNameFn(self.GetReference());
	}

	return GetMyTemplate().DisplayName;
}

//---------------------------------------------------------------------------------------
function string GetSummaryText()
{
	if(GetMyTemplate().GetSummaryTextFn != none)
	{
		return GetMyTemplate().GetSummaryTextFn(self.GetReference());
	}

	return GetMyTemplate().SummaryText;
}

//---------------------------------------------------------------------------------------
function string GetQuote()
{
	return (class'UIUtilities_Text'.default.m_strOpenQuote $ GetMyTemplate().QuoteText $ class'UIUtilities_Text'.default.m_strCloseQuote  @ "-" @ GetMyTemplate().QuoteTextAuthor);
}

//---------------------------------------------------------------------------------------
function string GetImagePath()
{
	return GetMyTemplate().ImagePath;
}
// --------------------------------------------------------------------------------------
function bool GetNeedsAttention()
{
	return bNewCard;
}

//#############################################################################################
//----------------   ACTIVATE/DEACTIVATE   ----------------------------------------------------
//#############################################################################################

//---------------------------------------------------------------------------------------
function ActivateCard(XComGameState NewGameState)
{
	if(GetMyTemplate().OnActivatedFn != none)
	{
		GetMyTemplate().OnActivatedFn(NewGameState, self.GetReference());
	}
}

//---------------------------------------------------------------------------------------
function DeactivateCard(XComGameState NewGameState)
{
	if(GetMyTemplate().OnDeactivatedFn != none)
	{
		GetMyTemplate().OnDeactivatedFn(NewGameState, self.GetReference());
	}
}

//---------------------------------------------------------------------------------------
function bool CanBePlayed()
{
	if(GetMyTemplate().CanBePlayedFn != none)
	{
		return GetMyTemplate().CanBePlayedFn(self.GetReference());
	}

	return true;
}

//---------------------------------------------------------------------------------------
function bool CanBeRemoved(optional StateObjectReference ReplacementRef)
{
	if(GetMyTemplate().CanBeRemovedFn != none)
	{
		return GetMyTemplate().CanBeRemovedFn(self.GetReference(), ReplacementRef);
	}

	return true;
}

//---------------------------------------------------------------------------------------
function bool CanBeDrawn()
{
	return !bDrawn;
}

//#############################################################################################
//----------------   CARD CATEGORY   ----------------------------------------------------------
//#############################################################################################

//---------------------------------------------------------------------------------------
function bool IsResistanceCard()
{
	return (GetMyTemplate().Category == "ResistanceCard");
}

//---------------------------------------------------------------------------------------
function XComGameState_ResistanceFaction GetAssociatedFaction()
{
	local XComGameStateHistory History;
	local XComGameState_ResistanceFaction FactionState;

	if(!IsResistanceCard())
	{
		return none;
	}

	History = `XCOMHISTORY;

	foreach History.IterateByClassType(class'XComGameState_ResistanceFaction', FactionState)
	{
		if(FactionState.GetMyTemplateName() == GetAssociatedFactionName())
		{
			return FactionState;
		}
	}

	return none;
}

//---------------------------------------------------------------------------------------
function name GetAssociatedFactionName()
{
	if(!IsResistanceCard())
	{
		return '';
	}

	return (GetMyTemplate().AssociatedEntity);
}

//---------------------------------------------------------------------------------------
function int GetCardStrength()
{
	return (GetMyTemplate().Strength);
}

//---------------------------------------------------------------------------------------
function StackedUIIconData GetFactionIcon()
{
	local XComGameState_ResistanceFaction FactionState;
	local StackedUIIconData EmptyIcon; 

	FactionState = GetAssociatedFaction();
	if( FactionState == none )
		return EmptyIcon;
	else
		return FactionState.FactionIconData; 
}

//---------------------------------------------------------------------------------------
function string GetSlotHint()
{
	return ""; //TODO @mnauta: return a hint string if relevant. 
}

//---------------------------------------------------------------------------------------
DefaultProperties
{
}