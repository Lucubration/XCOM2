//---------------------------------------------------------------------------------------
//  FILE:    X2EventListener_DefaultWillEvents.uc
//  AUTHOR:  David Burchanowski
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class X2EventListener_DefaultWillEvents extends X2EventListener
	dependson(XComGameStateContext_WillRoll)
	config(GameCore)
	native(Core);

var const localized string SawEnemyUnit;
var const localized string SawLostUnit;
var const localized string Wounded;
var const localized string BondmateDied;
var const localized string BondmateCaptured;
var const localized string BondmatePanicked;
var const localized string BondmateMindControlled;
var const localized string BondmateUnconscious;
var const localized string BondmateWounded;
var const localized string SquadmateDied;
var const localized string SquadmateCaptured;
var const localized string SquadmatePanicked;
var const localized string SquadmateMindControlled;
var const localized string SquadmateUnconscious;
var const localized string SquadmateWounded;
var const localized string HorrorActivated;

var protected const config WillEventRollData SawEnemyUnitWillRollData;
var protected const config WillEventRollData SawLostUnitWillRollData;
var protected const config WillEventRollData CivilianDiedWillRollData;
var protected const config WillEventRollData WoundedWillRollData;
var protected const config WillEventRollData SquadmateDiedWillRollData;
var protected const config WillEventRollData SquadmateCapturedWillRollData;
var protected const config WillEventRollData SquadmatePanickedWillRollData;
var protected const config WillEventRollData SquadmateMindControlledWillRollData;
var protected const config WillEventRollData SquadmateWoundedWillRollData;
var protected const config WillEventRollData SquadmateOnUnitUnconsciousWillRollData;
var protected const config WillEventRollData BondmateDiedWillRollData;
var protected const config WillEventRollData BondmateCapturedWillRollData;
var protected const config WillEventRollData BondmatePanickedWillRollData;
var protected const config WillEventRollData BondmateMindControlledWillRollData;
var protected const config WillEventRollData BondmateWoundedWillRollData;
var protected const config WillEventRollData BondmateOnUnitUnconsciousWillRollData;
var protected const config WillEventRollData HorrorM1WillRollData;
var const config WillEventRollData AggressivePistolWillRollData;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem(CreateSawEnemyUnitTemplate());
	Templates.AddItem(CreateUnitDiedTemplate());
	Templates.AddItem(CreateUnitTookDamageTemplate());
	Templates.AddItem(CreateUnitPanickedTemplate());
	Templates.AddItem(CreateMindControlledTemplate());
	Templates.AddItem(CreateUnitUnconsciousTemplate());
	Templates.AddItem(CreateUnitCapturedTemplate());

	// Spectre Horror Listener
	Templates.AddItem(CreateHorrorActivatedTemplate());

	return Templates;
}

static function X2EventListenerTemplate CreateSawEnemyUnitTemplate()
{
	local X2EventListenerTemplate Template;

	`CREATE_X2TEMPLATE(class'X2EventListenerTemplate', Template, 'EnemyGroupSighted');

	Template.RegisterInTactical = true;
	Template.AddEvent('EnemyGroupSighted', OnSightedEnemyGroup);

	return Template;
}

static protected native function EventListenerReturn OnSightedEnemyGroup(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData);

static function X2EventListenerTemplate CreateUnitDiedTemplate()
{
	local X2EventListenerTemplate Template;

	`CREATE_X2TEMPLATE(class'X2EventListenerTemplate', Template, 'UnitDied');

	Template.RegisterInTactical = true;
	Template.AddEvent('UnitDied', OnUnitDied);

	return Template;
}

static protected function EventListenerReturn OnUnitDied(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local XComGameStateHistory History;
	local XComGameStateContext_WillRoll WillRollContext;
	local XComGameState_HeadquartersXCom XComHQ;
	local StateObjectReference SquadRef;
	local StateObjectReference BondmateRef;
	local XComGameState_Unit DeadUnit;
	local XComGameState_Unit SquadUnit;

	DeadUnit = XComGameState_Unit(EventSource);
	`assert(DeadUnit != none);

	History = `XCOMHISTORY;
	XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class' XComGameState_HeadquartersXCom'));

	if(DeadUnit.IsCivilian())
	{
		// this unit was a civilian, all XCom units lose will
		foreach XComHQ.Squad(SquadRef)
		{
			SquadUnit = XComGameState_Unit(History.GetGameStateForObjectID(SquadRef.ObjectID));
			if( class'XComGameStateContext_WillRoll'.static.ShouldPerformWillRoll(default.CivilianDiedWillRollData, SquadUnit) )
			{
				WillRollContext = class'XComGameStateContext_WillRoll'.static.CreateWillRollContext(SquadUnit, 'UnitDied', default.SquadmateDied, false);
				WillRollContext.DoWillRoll(default.CivilianDiedWillRollData);
				WillRollContext.Submit();
			}
		}
	}
	else if(XComHQ.Squad.Find('ObjectID', DeadUnit.ObjectID) != INDEX_NONE)
	{
		// this unit was an XCom squadmate, all XCom units lose will

		// see of the dead unit had a buddy
		if(!DeadUnit.HasSoldierBond(BondmateRef))
		{
			BondmateRef.ObjectID = 0;
		}

		foreach XComHQ.Squad(SquadRef)
		{
			SquadUnit = XComGameState_Unit(History.GetGameStateForObjectID(SquadRef.ObjectId));
			
			if(SquadUnit.ObjectId == BondmateRef.ObjectID)
			{
				if( class'XComGameStateContext_WillRoll'.static.ShouldPerformWillRoll(default.BondmateDiedWillRollData, SquadUnit) )
				{
					WillRollContext = class'XComGameStateContext_WillRoll'.static.CreateWillRollContext(SquadUnit, 'UnitDied', default.BondmateDied);
					WillRollContext.DoWillRoll(default.BondmateDiedWillRollData, SquadUnit);
					WillRollContext.Submit();
				}
			}
			else
			{
				if( class'XComGameStateContext_WillRoll'.static.ShouldPerformWillRoll(default.SquadmateDiedWillRollData, SquadUnit) )
				{
					WillRollContext = class'XComGameStateContext_WillRoll'.static.CreateWillRollContext(SquadUnit, 'UnitDied', default.SquadmateDied);
					WillRollContext.DoWillRoll(default.SquadmateDiedWillRollData, SquadUnit);
					WillRollContext.Submit();
				}
			}
		}
	}

	return ELR_NoInterrupt;
}

static function X2EventListenerTemplate CreateUnitPanickedTemplate()
{
	local X2EventListenerTemplate Template;

	`CREATE_X2TEMPLATE(class'X2EventListenerTemplate', Template, 'UnitPanicked');

	Template.RegisterInTactical = true;
	Template.AddEvent('UnitPanicked', OnUnitPanicked);

	return Template;
}

static protected function EventListenerReturn OnUnitPanicked(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local XComGameStateHistory History;
	local XComGameStateContext_WillRoll WillRollContext;
	local XComGameState_HeadquartersXCom XComHQ;
	local StateObjectReference SquadRef;
	local XComGameState_Unit PanickedUnit;
	local XComGameState_Unit SquadUnit;
	local StateObjectReference BondmateRef;

	PanickedUnit = XComGameState_Unit(EventSource);
	`assert(PanickedUnit != none);

	if(PanickedUnit.GetTeam() == eTeam_XCom)
	{
		History = `XCOMHISTORY;
		XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class' XComGameState_HeadquartersXCom'));

		// this unit was a civilian, all XCom units lose will
		foreach XComHQ.Squad(SquadRef)
		{
			SquadUnit = XComGameState_Unit(History.GetGameStateForObjectID(SquadRef.ObjectID));

			if( SquadUnit != PanickedUnit )
			{
				if( !PanickedUnit.HasSoldierBond(BondmateRef) )
				{
					BondmateRef.ObjectID = 0;
				}

				if( SquadUnit.ObjectId == BondmateRef.ObjectID )
				{
					if( class'XComGameStateContext_WillRoll'.static.ShouldPerformWillRoll(default.BondmatePanickedWillRollData, SquadUnit) )
					{
						WillRollContext = class'XComGameStateContext_WillRoll'.static.CreateWillRollContext(SquadUnit, 'UnitPanicked', default.BondmatePanicked);
						WillRollContext.DoWillRoll(default.BondmatePanickedWillRollData, SquadUnit);
						WillRollContext.Submit();
					}
				}
				else
				{
					if( class'XComGameStateContext_WillRoll'.static.ShouldPerformWillRoll(default.SquadmatePanickedWillRollData, SquadUnit) )
					{
						WillRollContext = class'XComGameStateContext_WillRoll'.static.CreateWillRollContext(SquadUnit, 'UnitPanicked', default.SquadmatePanicked);
						WillRollContext.DoWillRoll(default.SquadmatePanickedWillRollData, SquadUnit);
						WillRollContext.Submit();
					}
				}
			}
		}
	}

	return ELR_NoInterrupt;
}

static function X2EventListenerTemplate CreateUnitTookDamageTemplate()
{
	local X2EventListenerTemplate Template;

	`CREATE_X2TEMPLATE(class'X2EventListenerTemplate', Template, 'UnitTookDamage');

	Template.RegisterInTactical = true;
	Template.AddEvent('UnitTakeEffectDamage', OnUnitTookDamage);

	return Template;
}

static protected function EventListenerReturn OnUnitTookDamage(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local XComGameState_Unit WoundedUnit;
	local XComGameStateContext_WillRoll WillRollContext;
	local XComGameStateHistory History;
	local XComGameState_HeadquartersXCom XComHQ;
	local StateObjectReference SquadRef;
	local XComGameState_Unit SquadUnit;
	local StateObjectReference BondmateRef;

	WoundedUnit = XComGameState_Unit(EventSource);
	`assert(WoundedUnit != none);

	History = `XCOMHISTORY;
	XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));

	if( XComHQ.Squad.Find('ObjectID', WoundedUnit.ObjectID) != INDEX_NONE )
	{
		if( class'XComGameStateContext_WillRoll'.static.ShouldPerformWillRoll(default.WoundedWillRollData, WoundedUnit) )
		{
			WillRollContext = class'XComGameStateContext_WillRoll'.static.CreateWillRollContext(WoundedUnit, 'UnitTookDamage', default.Wounded);
			WillRollContext.DoWillRoll(default.WoundedWillRollData, WoundedUnit);
			WillRollContext.Submit();
		}

		if( !WoundedUnit.HasSoldierBond(BondmateRef) )
		{
			BondmateRef.ObjectID = 0;
		}

		if( XComHQ != none )
		{
			foreach XComHQ.Squad(SquadRef)
			{
				SquadUnit = XComGameState_Unit(History.GetGameStateForObjectID(SquadRef.ObjectId));
				if( SquadUnit != none && SquadUnit != WoundedUnit )
				{
					if( SquadUnit.ObjectId == BondmateRef.ObjectID )
					{
						if( class'XComGameStateContext_WillRoll'.static.ShouldPerformWillRoll(default.BondmateWoundedWillRollData, SquadUnit) )
						{
							WillRollContext = class'XComGameStateContext_WillRoll'.static.CreateWillRollContext(SquadUnit, 'UnitTookDamage', default.BondmateWounded);
							WillRollContext.DoWillRoll(default.BondmateWoundedWillRollData, SquadUnit);
							WillRollContext.Submit();
						}
					}
					else
					{
						if( class'XComGameStateContext_WillRoll'.static.ShouldPerformWillRoll(default.SquadmateWoundedWillRollData, SquadUnit) )
						{
							WillRollContext = class'XComGameStateContext_WillRoll'.static.CreateWillRollContext(SquadUnit, 'UnitTookDamage', default.SquadmateWounded);
							WillRollContext.DoWillRoll(default.SquadmateWoundedWillRollData, SquadUnit);
							WillRollContext.Submit();
						}
					}
				}
			}
		}
	}

	return ELR_NoInterrupt;
}

static function X2EventListenerTemplate CreateMindControlledTemplate()
{
	local X2EventListenerTemplate Template;

	`CREATE_X2TEMPLATE(class'X2EventListenerTemplate', Template, 'MindControlled');

	Template.RegisterInTactical = true;
	Template.AddEvent('MindControlled', OnUnitMindControlled);

	return Template;
}

static protected function EventListenerReturn OnUnitMindControlled(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local XComGameStateHistory History;
	local XComGameStateContext_WillRoll WillRollContext;
	local XComGameState_HeadquartersXCom XComHQ;
	local StateObjectReference SquadRef;
	local XComGameState_Unit SquadUnit;
	local XComGameState_Unit SourceUnit;
	local StateObjectReference BondmateRef;

	SourceUnit = XComGameState_Unit(EventSource);
	`assert(SourceUnit != none);

	History = `XCOMHISTORY;
	XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));

	if(XComHQ.Squad.Find('ObjectID', SourceUnit.ObjectID) != INDEX_NONE)
	{
		if( !SourceUnit.HasSoldierBond(BondmateRef) )
		{
			BondmateRef.ObjectID = 0;
		}

		// this unit was an XCom squadmate, all XCom units lose will
		foreach XComHQ.Squad(SquadRef)
		{
			SquadUnit = XComGameState_Unit(History.GetGameStateForObjectID(SquadRef.ObjectId));
			if(SquadUnit != SourceUnit && SquadUnit != none)
			{
				if( SquadUnit.ObjectId == BondmateRef.ObjectID )
				{
					if( class'XComGameStateContext_WillRoll'.static.ShouldPerformWillRoll(default.BondmateMindControlledWillRollData, SquadUnit) )
					{
						WillRollContext = class'XComGameStateContext_WillRoll'.static.CreateWillRollContext(SquadUnit, 'MindControlled', default.BondmateMindControlled);
						WillRollContext.DoWillRoll(default.BondmateMindControlledWillRollData, SquadUnit);
						WillRollContext.Submit();
					}
				}
				else
				{
					if( class'XComGameStateContext_WillRoll'.static.ShouldPerformWillRoll(default.SquadmateMindControlledWillRollData, SquadUnit) )
					{
						WillRollContext = class'XComGameStateContext_WillRoll'.static.CreateWillRollContext(SquadUnit, 'MindControlled', default.SquadmateMindControlled);
						WillRollContext.DoWillRoll(default.SquadmateMindControlledWillRollData, SquadUnit);
						WillRollContext.Submit();
					}
				}
			}
		}
	}

	return ELR_NoInterrupt;
}

static function X2EventListenerTemplate CreateUnitUnconsciousTemplate()
{
	local X2EventListenerTemplate Template;

	`CREATE_X2TEMPLATE(class'X2EventListenerTemplate', Template, 'UnitUnconscious');

	Template.RegisterInTactical = true;
	Template.AddEvent('UnitUnconscious', OnUnitUnconscious);

	return Template;
}

static protected function EventListenerReturn OnUnitUnconscious(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local XComGameStateHistory History;
	local XComGameStateContext_WillRoll WillRollContext;
	local XComGameState_HeadquartersXCom XComHQ;
	local StateObjectReference SquadRef;
	local XComGameState_Unit SquadUnit;
	local XComGameState_Unit SourceUnit;
	local StateObjectReference BondmateRef;

	SourceUnit = XComGameState_Unit(EventSource);
	`assert(SourceUnit != none);

	History = `XCOMHISTORY;
	XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));

	if(XComHQ.Squad.Find('ObjectID', SourceUnit.ObjectID) != INDEX_NONE)
	{
		if( !SourceUnit.HasSoldierBond(BondmateRef) )
		{
			BondmateRef.ObjectID = 0;
		}

		// this unit was an XCom squadmate, all XCom units lose will
		foreach XComHQ.Squad(SquadRef)
		{
			if (SquadRef.ObjectID > 0)
			{
				SquadUnit = XComGameState_Unit(History.GetGameStateForObjectID(SquadRef.ObjectId));
				if (SquadUnit != SourceUnit)
				{
					if (SquadUnit.ObjectId == BondmateRef.ObjectID)
					{
						if (class'XComGameStateContext_WillRoll'.static.ShouldPerformWillRoll(default.BondmateOnUnitUnconsciousWillRollData, SquadUnit))
						{
							WillRollContext = class'XComGameStateContext_WillRoll'.static.CreateWillRollContext(SquadUnit, 'UnitUnconscious', default.BondmateUnconscious);
							WillRollContext.DoWillRoll(default.BondmateOnUnitUnconsciousWillRollData, SquadUnit);
							WillRollContext.Submit();
						}
					}
					else
					{
						if (class'XComGameStateContext_WillRoll'.static.ShouldPerformWillRoll(default.SquadmateOnUnitUnconsciousWillRollData, SquadUnit))
						{
							WillRollContext = class'XComGameStateContext_WillRoll'.static.CreateWillRollContext(SquadUnit, 'UnitUnconscious', default.SquadmateUnconscious);
							WillRollContext.DoWillRoll(default.SquadmateOnUnitUnconsciousWillRollData, SquadUnit);
							WillRollContext.Submit();
						}
					}
				}
			}
		}
	}

	return ELR_NoInterrupt;
}

static function X2EventListenerTemplate CreateUnitCapturedTemplate()
{
	local X2EventListenerTemplate Template;

	`CREATE_X2TEMPLATE(class'X2EventListenerTemplate', Template, 'UnitCaptured');

	Template.RegisterInTactical = true;
	Template.AddEvent('UnitCaptured', OnUnitCaptured);

	return Template;
}

static protected function EventListenerReturn OnUnitCaptured(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local XComGameStateHistory History;
	local XComGameStateContext_WillRoll WillRollContext;
	local XComGameState_HeadquartersXCom XComHQ;
	local StateObjectReference SquadRef;
	local XComGameState_Unit SquadUnit;
	local XComGameState_Unit SourceUnit;
	local StateObjectReference BondmateRef;

	SourceUnit = XComGameState_Unit(EventSource);
	`assert(SourceUnit != none);

	History = `XCOMHISTORY;
	XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));

	if( XComHQ.Squad.Find('ObjectID', SourceUnit.ObjectID) != INDEX_NONE )
	{
		if( !SourceUnit.HasSoldierBond(BondmateRef) )
		{
			BondmateRef.ObjectID = 0;
		}

		// this unit was an XCom squadmate, all XCom units lose will
		foreach XComHQ.Squad(SquadRef)
		{
			SquadUnit = XComGameState_Unit(History.GetGameStateForObjectID(SquadRef.ObjectId));
			if( SquadUnit != SourceUnit )
			{
				if( SquadUnit.ObjectId == BondmateRef.ObjectID )
				{
					if( class'XComGameStateContext_WillRoll'.static.ShouldPerformWillRoll(default.BondmateCapturedWillRollData, SquadUnit) )
					{
						WillRollContext = class'XComGameStateContext_WillRoll'.static.CreateWillRollContext(SquadUnit, 'UnitCaptured', default.BondmateCaptured);
						WillRollContext.DoWillRoll(default.BondmateCapturedWillRollData, SquadUnit);
						WillRollContext.Submit();
					}
				}
				else
				{
					if( class'XComGameStateContext_WillRoll'.static.ShouldPerformWillRoll(default.SquadmateCapturedWillRollData, SquadUnit) )
					{
						WillRollContext = class'XComGameStateContext_WillRoll'.static.CreateWillRollContext(SquadUnit, 'UnitCaptured', default.SquadmateCaptured);
						WillRollContext.DoWillRoll(default.SquadmateCapturedWillRollData, SquadUnit);
						WillRollContext.Submit();
					}
				}
			}
		}
	}

	return ELR_NoInterrupt;
}

static function X2EventListenerTemplate CreateHorrorActivatedTemplate()
{
	local X2EventListenerTemplate Template;

	`CREATE_X2TEMPLATE(class'X2EventListenerTemplate', Template, 'HorrorActivated');

	Template.RegisterInTactical = true;
	Template.AddEvent('HorrorActivated', OnHorrorActivated);

	return Template;
}

static protected function EventListenerReturn OnHorrorActivated(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local XComGameStateHistory History;
	local XComGameStateContext_WillRoll WillRollContext;
	local XComGameState_Unit TargetUnit;
	local XComGameStateContext_Ability AbilityContext;

	AbilityContext = XComGameStateContext_Ability(GameState.GetContext());
	if (AbilityContext != none && class'XComGameStateContext_Ability'.static.IsHitResultHit(AbilityContext.ResultContext.HitResult))
	{
		History = `XCOMHISTORY;

		TargetUnit = XComGameState_Unit(History.GetGameStateForObjectID(AbilityContext.InputContext.PrimaryTarget.ObjectID));
		`assert(TargetUnit != none);

		if( class'XComGameStateContext_WillRoll'.static.ShouldPerformWillRoll(default.HorrorM1WillRollData, TargetUnit) )
		{
			WillRollContext = class'XComGameStateContext_WillRoll'.static.CreateWillRollContext(TargetUnit, 'HorrorActivated', default.HorrorActivated, false);
			WillRollContext.DoWillRoll(default.HorrorM1WillRollData);
			WillRollContext.Submit();
		}
	}

	return ELR_NoInterrupt;
}