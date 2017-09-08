//---------------------------------------------------------------------------------------
//  FILE:    XComGameState_Continent.uc
//  AUTHOR:  Mark Nauta
// 
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class XComGameState_Continent extends XComGameState_GeoscapeEntity
	native(Core)
	config(GameBoard);

var() protected name                   m_TemplateName;
var() protected X2ContinentTemplate    m_Template;

var name							   ContinentBonus; // Deprecated with the XPack
var StateObjectReference			   ContinentBonusCard;
var bool							   bHasHadContinentBonus; // Has ever had the continent bonus active
var bool							   bContinentBonusActive; // Continent bonus is currently active

var array<StateObjectReference>		   Regions;

var config float					   DesiredDistanceBetweenMapItems;
var config float					   MinDistanceBetweenMapItems;

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
simulated function X2ContinentTemplate GetMyTemplate()
{
	if(m_Template == none)
	{
		m_Template = X2ContinentTemplate(GetMyTemplateManager().FindStrategyElementTemplate(m_TemplateName));
	}
	return m_Template;
}

//---------------------------------------------------------------------------------------
event OnCreation(optional X2DataTemplate Template)
{
	super.OnCreation( Template );

	m_Template = X2ContinentTemplate(Template);
	m_TemplateName = Template.DataName;
}

//---------------------------------------------------------------------------------------
// Continents Created and given continent bonus randomnly
static function SetUpContinents(XComGameState StartState)
{
	local X2StrategyElementTemplateManager StratMgr;
	local array<X2StrategyElementTemplate> ContinentDefinitions;
	local XComGameState_Continent ContinentState;
	local X2ContinentTemplate ContinentTemplate;
	local int idx;

	StratMgr = GetMyTemplateManager();
	ContinentDefinitions = StratMgr.GetAllTemplatesOfClass(class'X2ContinentTemplate');
	
	for(idx = 0; idx < ContinentDefinitions.Length; idx++)
	{
		ContinentTemplate = X2ContinentTemplate(ContinentDefinitions[idx]);
		ContinentState = ContinentTemplate.CreateInstanceFromTemplate(StartState);
		ContinentState.Location = ContinentTemplate.LandingLocation;
		ContinentState.AssignRegions(StartState);
	}
}

//---------------------------------------------------------------------------------------
// Assign region refs to continent and continent ref to regions
function AssignRegions(XComGameState StartState)
{
	local XComGameState_WorldRegion RegionState;
	
	foreach StartState.IterateByClassType(class'XComGameState_WorldRegion', RegionState)
	{
		if(GetMyTemplate().Regions.Find(RegionState.GetMyTemplateName()) != INDEX_NONE)
		{
			Regions.AddItem(RegionState.GetReference());
			RegionState.Continent = self.GetReference();
		}
	}
}

//---------------------------------------------------------------------------------------
function Vector GetLocation()
{
	return GetMyTemplate().LandingLocation;
}

//---------------------------------------------------------------------------------------
function Vector2D Get2DLocation()
{
	local Vector2D v2Loc;

	v2Loc.x = GetMyTemplate().LandingLocation.x;
	v2Loc.y = GetMyTemplate().LandingLocation.y;

	return v2Loc;
}

//---------------------------------------------------------------------------------------
function bool ContainsRegion(StateObjectReference RegionRefToCheck)
{
	local StateObjectReference RegionRef;

	foreach Regions(RegionRef)
	{
		if (RegionRef.ObjectID == RegionRefToCheck.ObjectID)
		{
			return true;
		}
	}

	return false;
}

//#############################################################################################
//----------------   LOCATION HANDLING   ------------------------------------------------------
//#############################################################################################

//---------------------------------------------------------------------------------------
/// Utility method - returns a random point contained by the continent that does not fall in a region
function Vector GetRandomLocationInContinent(optional array<XComGameState_GeoscapeEntity> Entities, optional XComGameState_GeoscapeEntity NewEntity)
{
	local XComGameStateHistory History;
	local Vector RandomLocation;
	local Vector2D RandomLoc2D;
	local XComGameState_GeoscapeEntity EntityState;
	local array<XComGameState_GeoscapeEntity> TooltipEntities;
	local int Iterations;
	local TRect Bounds;
	local bool bFoundLocation;

	RandomLocation.X = -1.0;  RandomLocation.Y = -1.0;  RandomLocation.Z = -1.0;

	Bounds = GetMyTemplate().Bounds[0];
	
	// Grab other entities in the continent (to avoid placing near them)
	History = `XCOMHISTORY;
	foreach History.IterateByClassType(class'XComGameState_GeoscapeEntity', EntityState)
	{
		//First make sure that the entity is associated with this continent
		if (EntityState.Continent.ObjectID == ObjectID)
		{
			// ensure the entity is not the new addition
			if ((NewEntity != none) && (EntityState.ObjectID == NewEntity.ObjectID))
				continue;

			// ensure the entity has not already been saved
			if (Entities.Find(EntityState) != INDEX_NONE)
				continue;

			Entities.AddItem(EntityState);
			if (EntityState.HasTooltipBounds())
			{
				TooltipEntities.AddItem(EntityState);
			}
		}
	}
	
	do {
		RandomLocation.X = Bounds.fLeft + `SYNC_FRAND() * (Bounds.fRight - Bounds.fLeft);
		RandomLocation.Y = Bounds.fTop + `SYNC_FRAND() * (Bounds.fBottom - Bounds.fTop);
		RandomLocation.Z = 0.0f;
		RandomLoc2D = vect2d(RandomLocation.X, RandomLocation.Y);

		if (class'X2StrategyGameRulesetDataStructures'.static.IsOnLand(RandomLoc2D) && !IsLocationInContinentRegion(RandomLoc2D))
		{
			if (Iterations > 2000)
			{
				// Last resort, just find any place on land
				bFoundLocation = true;
			}
			else if (Iterations > 1000)
			{
				// Ignore tooltip overlaps now, just try to keep the 3D icons spaced apart
				if ((Iterations > 1500 && class'X2StrategyGameRulesetDataStructures'.static.MinDistanceFromOtherItems(RandomLocation, Entities, default.MinDistanceBetweenMapItems))
					|| class'X2StrategyGameRulesetDataStructures'.static.MinDistanceFromOtherItems(RandomLocation, Entities, default.DesiredDistanceBetweenMapItems))
				{
					bFoundLocation = true;
				}
			}
			else // Iterations will start here
			{
				// Try to find a location with the correct 3D icon spacing
				if ((Iterations > 500 && class'X2StrategyGameRulesetDataStructures'.static.MinDistanceFromOtherItems(RandomLocation, Entities, default.MinDistanceBetweenMapItems))
					|| class'X2StrategyGameRulesetDataStructures'.static.MinDistanceFromOtherItems(RandomLocation, Entities, default.DesiredDistanceBetweenMapItems))
				{
					// Along with tooltip overlaps
					if (class'X2StrategyGameRulesetDataStructures'.static.AvoidOverlapWithTooltipBounds(RandomLocation, TooltipEntities, NewEntity))
					{
						bFoundLocation = true;
					}
				}
			}
		}

		++Iterations;
	}
	until(bFoundLocation);

	return RandomLocation;
}

//---------------------------------------------------------------------------------------
function Vector2D GetRandom2DLocationInContinent()
{
	local Vector RandomLocation;
	local Vector2D RandomLoc2D;

	RandomLocation = GetRandomLocationInContinent();
	RandomLoc2D.x = RandomLocation.x;
	RandomLoc2D.y = RandomLocation.y;

	return RandomLoc2D;
}

//---------------------------------------------------------------------------------------
function XComGameState_WorldRegion GetRandomRegionInContinent(optional StateObjectReference RegionRef)
{
	local StateObjectReference RandomRegion;

	do
	{
		RandomRegion = Regions[`SYNC_RAND(Regions.Length)];
	} until(RandomRegion.ObjectID != RegionRef.ObjectID);
	
	return XComGameState_WorldRegion(`XCOMHISTORY.GetGameStateForObjectID(RandomRegion.ObjectID));
}

//---------------------------------------------------------------------------------------
function bool IsLocationInContinentRegion(Vector2D Location2D)
{
	local XComGameStateHistory History;
	local XComGameState_WorldRegion RegionState;
	local StateObjectReference RegionRef;

	History = `XCOMHISTORY;
	
	foreach Regions(RegionRef)
	{
		RegionState = XComGameState_WorldRegion(History.GetGameStateForObjectID(RegionRef.ObjectID));		
		if (RegionState.InRegion(Location2D))
		{
			return true;
		}
	}

	return false;
}

//---------------------------------------------------------------------------------------
function bool AreAllRegionLocationsUpdated()
{
	local XComGameStateHistory History;
	local XComGameState_WorldRegion RegionState;
	local StateObjectReference RegionRef;
	local UIStrategyMapItem MapItem;
		
	History = `XCOMHISTORY;
			
	foreach Regions(RegionRef)
	{
		RegionState = XComGameState_WorldRegion(History.GetGameStateForObjectID(RegionRef.ObjectID));
		
		// Check to see if the map item for the region exists
		MapItem = UIStrategyMapItem(RegionState.GetVisualizer());
		if (MapItem == none)
		{
			return false;
		}
	}

	return true;
}

//#############################################################################################
//----------------   RESISTANCE LEVEL   -------------------------------------------------------
//#############################################################################################

//---------------------------------------------------------------------------------------
function int GetMaxResistanceLevel()
{
	// 1.5 the number of regions, rounded up
	return FCeil(Regions.Length * 1.5f);
}

//---------------------------------------------------------------------------------------
function int GetResistanceLevel(optional XComGameState NewGameState)
{
	local XComGameStateHistory History;
	local XComGameState_WorldRegion RegionState;
	local int ResistanceLevel, idx;

	History = `XCOMHISTORY;
	ResistanceLevel = 0;

	for(idx = 0; idx < Regions.Length; idx++)
	{
		RegionState = none;

		if(NewGameState != none)
		{
			RegionState = XComGameState_WorldRegion(NewGameState.GetGameStateForObjectID(Regions[idx].ObjectID));
		}

		if(RegionState == none)
		{
			RegionState = XComGameState_WorldRegion(History.GetGameStateForObjectID(Regions[idx].ObjectID));
		}

		if(RegionState != none)
		{
			switch(RegionState.ResistanceLevel)
			{
			case eResLevel_Contact:
				ResistanceLevel += 1;
				break;
			case eResLevel_Outpost:
				ResistanceLevel += 2;
				break;
			default:
				break;
			}
		}
	}

	ResistanceLevel = Clamp(ResistanceLevel, 0, GetMaxResistanceLevel());

	return ResistanceLevel;
}

//---------------------------------------------------------------------------------------
function HandleRegionResistanceLevelChange(XComGameState NewGameState)
{
	local int ResistanceLevel;

	ResistanceLevel = GetResistanceLevel(NewGameState);

	if(ResistanceLevel >= GetMaxResistanceLevel() && !bContinentBonusActive)
	{
		`XEVENTMGR.TriggerEvent('ContinentBonusActivated', self, , NewGameState);
		ActivateContinentBonus(NewGameState);
	}
	else if(ResistanceLevel < GetMaxResistanceLevel() && bContinentBonusActive)
	{
		DeactivateContinentBonus(NewGameState);
	}
	RefreshMapItem();
}

//---------------------------------------------------------------------------------------
function XComGameState_StrategyCard GetContinentBonusCard()
{
	return XComGameState_StrategyCard(`XCOMHISTORY.GetGameStateForObjectID(ContinentBonusCard.ObjectID));
}

//---------------------------------------------------------------------------------------
function ActivateContinentBonus(XComGameState NewGameState)
{
	local XComGameState_StrategyCard CardState;

	CardState = GetContinentBonusCard();
	CardState.ActivateCard(NewGameState);
	bHasHadContinentBonus = true;
	bContinentBonusActive = true;
}

//---------------------------------------------------------------------------------------
function DeactivateContinentBonus(XComGameState NewGameState)
{
	local XComGameState_StrategyCard CardState;

	CardState = GetContinentBonusCard();
	CardState.DeactivateCard(NewGameState);
	bContinentBonusActive = false;
}

//#############################################################################################
//----------------   RADIO TOWERS   -------------------------------------------------------
//#############################################################################################

//---------------------------------------------------------------------------------------
function int GetMaxRadioTowers()
{
	return GetMaxResistanceLevel() - Regions.Length;
}

//---------------------------------------------------------------------------------------
function int GetNumRadioTowers(optional XComGameState NewGameState)
{
	local XComGameStateHistory History;
	local XComGameState_WorldRegion RegionState;
	local int NumTowers, idx;

	History = `XCOMHISTORY;
	NumTowers = 0;

	for( idx = 0; idx < Regions.Length; idx++ )
	{
		RegionState = none;

		if( NewGameState != none )
		{
			RegionState = XComGameState_WorldRegion(NewGameState.GetGameStateForObjectID(Regions[idx].ObjectID));
		}

		if( RegionState == none )
		{
			RegionState = XComGameState_WorldRegion(History.GetGameStateForObjectID(Regions[idx].ObjectID));
		}

		if( RegionState != none )
		{
			switch( RegionState.ResistanceLevel )
			{
			case eResLevel_Outpost:
				NumTowers += 1;
				break;
			default:
				break;
			}
		}
	}

	NumTowers = Clamp(NumTowers, 0, GetMaxRadioTowers());

	return NumTowers;
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
	return true;
}

//---------------------------------------------------------------------------------------
function class<UIStrategyMapItem> GetUIClass()
{
	return class'UIStrategyMapItem_Continent';
}

//---------------------------------------------------------------------------------------
function string GetUIWidgetFlashLibraryName()
{
	return "MI_continent";
}

//---------------------------------------------------------------------------------------
function string GetUIPinImagePath()
{
	return "";
}

function bool ShouldBeVisible()
{
	local XComGameStateHistory History;
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_WorldRegion RegionState;
	local int idx;

	History = `XCOMHISTORY;
	XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));

	if(XComHQ.IsOutpostResearched())
	{
		for(idx = 0; idx < Regions.Length; idx++)
		{
			RegionState = XComGameState_WorldRegion(History.GetGameStateForObjectID(Regions[idx].ObjectID));

			if(RegionState != none && RegionState.HaveUnlocked())
			{
				return true;
			}
		}
	}

	return false;
}

//---------------------------------------------------------------------------------------
protected function bool CanInteract()
{
	return false;
}

//---------------------------------------------------------------------------------------
function UpdateGameBoard()
{
}

//---------------------------------------------------------------------------------------
simulated function RefreshMapItem()
{
	local UIStrategyMap StrategyMap;
	local XComGameState_GeoscapeEntity Entity;

	Entity = self; // hack to get around "self is not allowed in out parameter" error
	StrategyMap = (`SCREENSTACK != none ? UIStrategyMap(`SCREENSTACK.GetScreen(class'UIStrategyMap')) : none);

	if( StrategyMap != none)
	{
		StrategyMap.GetMapItem(Entity).SetImage(GetUIPinImagePath());
	}
}