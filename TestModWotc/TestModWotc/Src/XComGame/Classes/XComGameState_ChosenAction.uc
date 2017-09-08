//---------------------------------------------------------------------------------------
//  FILE:    XComGameState_ChosenAction.uc
//  AUTHOR:  Mark Nauta  --  1/19/2017
//  PURPOSE: This object represents the instance data for a chosen action
//           in the XCOM 2 strategy game
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class XComGameState_ChosenAction extends XComGameState_BaseObject;

// Template info
var protected name								  m_TemplateName;
var protected X2ChosenActionTemplate	          m_Template;

// Reference to Chosen
var StateObjectReference						  ChosenRef;

// Knowledge gain if action successful (stored here b/c it is pre-rolled)
var int											  KnowledgeGain;

// Action success vars - some actions can fail
var bool										  bActionFailed;
var int											  RollValue; // Some actions pre-roll when selected

// Storage vars, probably accessed in template delegate funcions
var StateObjectReference						  StoredReference; // Use if action needs to store an extra reference
var name										  StoredTemplateName; // Use if action needs a reference to another template (e.g. Sabotage)
var int											  StoredIntValue; // Use if action needs to store some in value (e.g. a value rolled upon choosing action)
var int											  StoredFloatValue; // Use if action needs to store some float value
var string										  StoredDescription; // Use if action needs to store a description string
var string										  StoredShortDescription; // Used for display sabotage message during Chosen Assault missions


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
simulated function X2ChosenActionTemplate GetMyTemplate()
{
	if(m_Template == none)
	{
		m_Template = X2ChosenActionTemplate(GetMyTemplateManager().FindStrategyElementTemplate(m_TemplateName));
	}
	return m_Template;
}

//---------------------------------------------------------------------------------------
function OnCreation(optional X2DataTemplate Template)
{
	m_Template = X2ChosenActionTemplate(Template);
	m_TemplateName = Template.DataName;
}

//---------------------------------------------------------------------------------------
function SetKnowledgeGain()
{
	KnowledgeGain = GetMyTemplate().MinKnowledgeGain + `SYNC_RAND(GetMyTemplate().MaxKnowledgeGain - GetMyTemplate().MinKnowledgeGain + 1);
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
	if(GetMyTemplate().QuoteText == "")
	{
		return "";
	}

	return (GetMyTemplate().QuoteText @ "< /br>-" @ GetMyTemplate().QuoteTextAuthor);
}

//---------------------------------------------------------------------------------------
function string GetImagePath()
{
	return GetMyTemplate().ImagePath;
}

//#############################################################################################
//----------------   ACTIVATE   ----------------------------------------------------
//#############################################################################################

//---------------------------------------------------------------------------------------
function ActivateAction(XComGameState NewGameState)
{
	if(GetMyTemplate().OnActivatedFn != none)
	{
		GetMyTemplate().OnActivatedFn(NewGameState, self.GetReference());
	}
}

//---------------------------------------------------------------------------------------
DefaultProperties
{
}