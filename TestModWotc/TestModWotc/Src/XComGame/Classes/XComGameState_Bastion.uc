//---------------------------------------------------------------------------------------
//  FILE:    XComGameState_Bastion.uc
//  AUTHOR:  Mark Nauta  --  04/26/2016
//  PURPOSE: This object represents the instance data for a Bastion on the world map 
//           in the XCOM 2 strategy game
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class XComGameState_Bastion extends XComGameState_GeoscapeEntity
	config(GameBoard);

// Template info
var protected name						m_TemplateName;
var protected X2BastionTemplate         m_Template;

var StateObjectReference				ControllingEntity; // Faction or Chosen controlling this Bastion (can be empty)

// Config vars
var const config int					BastionsPerRegion;

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
simulated function X2BastionTemplate GetMyTemplate()
{
	if(m_Template == none)
	{
		m_Template = X2BastionTemplate(GetMyTemplateManager().FindStrategyElementTemplate(m_TemplateName));
	}
	return m_Template;
}

//---------------------------------------------------------------------------------------
event OnCreation(optional X2DataTemplate Template)
{
	super.OnCreation( Template );

	m_Template = X2BastionTemplate(Template);
	m_TemplateName = Template.DataName;
}

//---------------------------------------------------------------------------------------
static function SetUpBastions(XComGameState StartState)
{
	local XComGameState_Bastion BastionState;
	local XComGameState_WorldRegion RegionState;
	local X2StrategyElementTemplateManager StratMgr;
	local array<X2StrategyElementTemplate> AllBastionTemplates;
	local X2BastionTemplate BastionTemplate;
	local int idx;
	
	StratMgr = class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager();
	AllBastionTemplates = StratMgr.GetAllTemplatesOfClass(class'X2BastionTemplate');

	foreach StartState.IterateByClassType(class'XComGameState_WorldRegion', RegionState)
	{
		for(idx = 0; idx < default.BastionsPerRegion; idx++)
		{
			BastionTemplate = X2BastionTemplate(AllBastionTemplates[`SYNC_RAND_STATIC(AllBastionTemplates.Length)]);
			BastionState = BastionTemplate.CreateInstanceFromTemplate(StartState);
			BastionState.Region = RegionState.GetReference();
			BastionState.bNeedsLocationUpdate = true;
			RegionState.Bastions.AddItem(BastionState.GetReference());
		}
	}
}

//#############################################################################################
//----------------   CONTROLLING ENTITY   -----------------------------------------------------	
//#############################################################################################

//---------------------------------------------------------------------------------------
function bool IsFactionControlled()
{
	return (GetControllingFaction() != none);
}

//---------------------------------------------------------------------------------------
function bool IsChosenControlled()
{
	return (GetControllingChosen() != none);
}

//---------------------------------------------------------------------------------------
function bool IsNeutral()
{
	return (GetControllingEntity() == none);
}

//---------------------------------------------------------------------------------------
function XComGameState_ResistanceFaction GetControllingFaction()
{
	return XComGameState_ResistanceFaction(GetControllingEntity());
}

//---------------------------------------------------------------------------------------
function XComGameState_AdventChosen GetControllingChosen()
{
	return XComGameState_AdventChosen(GetControllingEntity());
}

//---------------------------------------------------------------------------------------
function XComGameState_GeoscapeCharacter GetControllingEntity()
{
	return XComGameState_GeoscapeCharacter(`XCOMHISTORY.GetGameStateForObjectID(ControllingEntity.ObjectID));
}

//---------------------------------------------------------------------------------------
function GainControllingEntity(XComGameState NewGameState, StateObjectReference CharRef)
{
	local XComGameState_GeoscapeCharacter CharState;

	LoseControllingEntity(NewGameState);

	CharState = XComGameState_GeoscapeCharacter(NewGameState.GetGameStateForObjectID(ControllingEntity.ObjectID));

	if(CharState == none)
	{
		CharState = XComGameState_GeoscapeCharacter(NewGameState.ModifyStateObject(class'XComGameState_GeoscapeCharacter', CharRef.ObjectID));
	}

	CharState.ControlledBastions.AddItem(self.GetReference());
	ControllingEntity = CharRef;
}

//---------------------------------------------------------------------------------------
function LoseControllingEntity(XComGameState NewGameState)
{
	local XComGameState_GeoscapeCharacter CharState;
	local StateObjectReference EmptyRef;

	if(ControllingEntity.ObjectID <= 0)
	{
		return;
	}

	CharState = XComGameState_GeoscapeCharacter(NewGameState.GetGameStateForObjectID(ControllingEntity.ObjectID));

	if(CharState == none)
	{
		CharState = XComGameState_GeoscapeCharacter(NewGameState.ModifyStateObject(class'XComGameState_GeoscapeCharacter', ControllingEntity.ObjectID));
	}

	CharState.ControlledBastions.RemoveItem(self.GetReference());
	ControllingEntity = EmptyRef;
}


//#############################################################################################
//----------------   GEOSCAPE ENTITY IMPLEMENTATION   -----------------------------------------
//#############################################################################################

//---------------------------------------------------------------------------------------
function bool RequiresAvenger()
{
	return true;
}

//---------------------------------------------------------------------------------------
function bool HasTooltipBounds()
{
	return false;
}

//---------------------------------------------------------------------------------------
function bool ShouldBeVisible()
{
	//return GetWorldRegion().HaveMadeContact();

	// Hiding for now
	return false;
}

//---------------------------------------------------------------------------------------
function bool CanBeScanned()
{
	return false;
}

//---------------------------------------------------------------------------------------
protected function bool CanInteract()
{
	return false;
}

//---------------------------------------------------------------------------------------
function DestinationReached()
{
}

//---------------------------------------------------------------------------------------
function class<UIStrategyMapItem> GetUIClass()
{
	return class'UIStrategyMapItem_Bastion';
}

//---------------------------------------------------------------------------------------
function StaticMesh GetStaticMesh()
{
	return StaticMesh'UI_3D.Overworld.GoldenPath_Icon';
}

//---------------------------------------------------------------------------------------
DefaultProperties
{

}