//---------------------------------------------------------------------------------------
//  FILE:    X2EventListener_DefaultTraits.uc
//  AUTHOR:  David Burchanowsk
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class X2EventListener_DefaultTraits extends X2EventListener
	config(GameCore)
	native(Core)
	dependson(X2EventListener_DefaultWillEvents);

// To get the fear of missed shots trait, you need to miss this many shots over
// the specified percentage chance to hit.
var protected const config int FearOfMissedShotMinMissPercentage;
var protected const config int FearOfMissedShotMinMissCount;

var private const config float AcquireFearOfBreakingConcealmentDamageThreshold;
var private const config float AcquireFearOfMecsDamageThreshold;
var private const config float AcquireFearOfSectoidsDamageThreshold;
var private const config float AcquireFearOfTheLostDamageThreshold;

var protected const config int InsubordinateWhenInLOSOfXEnemies;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	// common listener to apply all pending traits on tactical->strategy transfer
	Templates.AddItem(CreateAcquireTraitsTemplate());

	// alien specific phobias
	Templates.AddItem(CreateFearOfChosenTemplate());
	Templates.AddItem(CreateFearOfVipersTemplate());
	Templates.AddItem(CreateFearOfArchonsTemplate());
	Templates.AddItem(CreateFearOfStunLancersTemplate());
	Templates.AddItem(CreateFearOfMutonsTemplate());
	Templates.AddItem(CreateFearOfTheLostTemplate());
	Templates.AddItem(CreateFearOfMecsTemplate());
	Templates.AddItem(CreateFearOfFacelessTemplate());
	Templates.AddItem(CreateFearOfSectoidsTemplate());

	Templates.AddItem(CreateFearOfMissedShotsTemplate());
//	Templates.AddItem(CreateFearOfBreakingConcealmentTemplate());
	Templates.AddItem(CreateFearOfExplosivesTemplate());
	Templates.AddItem(CreateFearOfFireTemplate());
	Templates.AddItem(CreateFearOfPoisonTemplate());
	Templates.AddItem(CreateFearOfPsionicsTemplate());

	Templates.AddItem(CreateFearOfPanicTemplate());
//	Templates.AddItem(CreateFearOfVertigoTemplate());
//	Templates.AddItem(CreateFearOfSquadmateMissedShotsTemplate());
//	Templates.AddItem(CreateFearOfNoMovementTemplate());

	// behaviour traits
	Templates.AddItem(CreateGenericTraitTemplate('Trait_Cautious', 'AbilityActivated', OnUnitMoveFinished_CheckForCautious));
	Templates.AddItem(CreateGenericTraitTemplate('Trait_ObsessiveReloader', 'AbilityActivated', OnUnitMoveFinished_CheckForObsessiveReloader));
	Templates.AddItem(CreateGenericTraitTemplate('Trait_Aggressive', 'AbilityActivated', OnAbilityActivated_CheckForAggressive));
	//Templates.AddItem(CreateGenericTraitTemplate('Trait_Insubordinate', 'UnitMoveFinished', OnUnitMoveFinished_CheckForInsubordinate));
	//Templates.AddItem(CreateGenericTraitTemplate('Trait_Critic', 'AbilityActivated', OnAbilityActivated_CheckForCritic));

	// positive traits
	//Templates.AddItem(CreateHunterOfVipersTemplate());
	//Templates.AddItem(CreateHunterOfArchonsTemplate());
	//Templates.AddItem(CreateHunterOfStunLancersTemplate());
	//Templates.AddItem(CreateHunterOfMutonsTemplate());
	//Templates.AddItem(CreateHunterOfTheLostTemplate());
	//Templates.AddItem(CreateHunterOfMecsTemplate());
	//Templates.AddItem(CreateHunterOfFacelessTemplate());

	return Templates;
}

static protected function X2EventListenerTemplate CreateGenericTraitTemplate(name TemplateName, optional name EventName, optional delegate<X2EventManager.OnEventDelegate> EventFn)
{
	local X2TraitTemplate Template;

	`CREATE_X2TEMPLATE(class'X2TraitTemplate', Template, TemplateName);

	if( EventName != '' )
	{
		Template.AddEvent(EventName, EventFn);
	}

	return Template;
}

static protected function X2TraitTemplate GetTraitTemplate(name TraitTemplateName)
{
	local X2EventListenerTemplateManager TemplateManager;
	local X2TraitTemplate TraitTemplate;

	TemplateManager = class'X2EventListenerTemplateManager'.static.GetEventListenerTemplateManager();
	TraitTemplate = X2TraitTemplate(TemplateManager.FindEventListenerTemplate(TraitTemplateName));
	if(TraitTemplate == none)
	{
		`Redscreen("GetTemplateFriendlyName(): Could not find TraitTemplate " $ TraitTemplateName);
	}

	return TraitTemplate;
}

static protected function X2EventListenerTemplate CreateAcquireTraitsTemplate()
{
	local X2EventListenerTemplate Template;

	`CREATE_X2TEMPLATE(class'X2EventListenerTemplate', Template, 'AcquireTraits');
	Template.RegisterInTactical = true;
	Template.AddEvent('TacticalGameEnd', OnTacticalGameEnd);

	return Template;
}

static protected function EventListenerReturn OnTacticalGameEnd(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackDataI)
{
	local XComGameStateHistory History;
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_Unit TransferUnit;

	History = `XCOMHISTORY;
	XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));

	if(XComHQ.bCanCureNegativeTraits)
	{
		// apply traits to all units that have acquired them
		foreach `XCOMHISTORY.IterateByClassType(class'XComGameState_Unit', TransferUnit)
		{
			//TransferUnit.AcquirePendingTraits();

			// if this was a perfect mission (no injuries/capture), chance to recover negative traits
			if(!TransferUnit.IsDead() && !TransferUnit.bCaptured && !TransferUnit.WasInjuredOnMission())
			{
				TransferUnit.RecoverFromTraits();
			}
		}
	}
	
	return ELR_NoInterrupt;
}

static protected function X2EventListenerTemplate CreateFearOfChosenTemplate()
{
	local X2TraitTemplate Template;

	`CREATE_X2TEMPLATE(class'X2TraitTemplate', Template, 'FearOfChosen');
	Template.AddEvent('UnitTakeEffectDamage', OnUnitTakeDamage);

	return Template;
}

static protected function X2EventListenerTemplate CreateHunterOfVipersTemplate()
{
	local X2TraitTemplate Template;

	`CREATE_X2TEMPLATE(class'X2TraitTemplate', Template, 'HunterOfVipers');

	return Template;
}

static protected function X2EventListenerTemplate CreateFearOfVipersTemplate()
{
	local X2TraitTemplate Template;

	`CREATE_X2TEMPLATE(class'X2TraitTemplate', Template, 'FearOfVipers');
	Template.AddEvent('UnitBound', OnUnitBound);

	return Template;
}

static protected function EventListenerReturn OnUnitBound(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackDataI)
{
	local XComGameState_Unit BoundUnit;

	BoundUnit = XComGameState_Unit(EventData);

	if(BoundUnit != none && BoundUnit.GetTeam() == eTeam_XCom)
	{
		// roll for the fear of vipers trait
		class'X2TraitTemplate'.static.RollForTrait(BoundUnit, 'FearOfVipers');
	}

	return ELR_NoInterrupt;
}

static protected function X2EventListenerTemplate CreateHunterOfStunLancersTemplate()
{
	local X2TraitTemplate Template;

	`CREATE_X2TEMPLATE(class'X2TraitTemplate', Template, 'HunterOfStunLancers');

	return Template;
}

static protected function X2EventListenerTemplate CreateFearOfStunLancersTemplate()
{
	local X2TraitTemplate Template;

	`CREATE_X2TEMPLATE(class'X2TraitTemplate', Template, 'FearOfStunLancers');
	Template.AddEvent('UnitStunned', OnUnitStunned);

	return Template;
}

static protected function EventListenerReturn OnUnitStunned(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local XComGameState_Unit StunningUnit;
	local XComGameState_Unit StunnedUnit;

	StunningUnit = XComGameState_Unit(EventData);
	StunnedUnit = XComGameState_Unit(EventSource);

	// Check if this unit should acquire a fear of stun lancers
	if(StunningUnit.GetMyTemplateGroupName() == 'AdventStunLancer' && !StunnedUnit.HasTrait('FearOfStunLancers'))
	{
		class'X2TraitTemplate'.static.RollForTrait(StunnedUnit, 'FearOfStunLancers');
	}

	return ELR_NoInterrupt;
}

static protected function X2EventListenerTemplate CreateHunterOfArchonsTemplate()
{
	local X2TraitTemplate Template;

	`CREATE_X2TEMPLATE(class'X2TraitTemplate', Template, 'HunterOfArchons');

	return Template;
}

static protected function X2EventListenerTemplate CreateFearOfArchonsTemplate()
{
	local X2TraitTemplate Template;

	`CREATE_X2TEMPLATE(class'X2TraitTemplate', Template, 'FearOfArchons');
	Template.AddEvent('UnitTakeEffectDamage', OnUnitTakeDamage);

	return Template;
}

static protected function X2EventListenerTemplate CreateHunterOfMutonsTemplate()
{
	local X2TraitTemplate Template;

	`CREATE_X2TEMPLATE(class'X2TraitTemplate', Template, 'HunterOfMutons');

	return Template;
}

static protected function X2EventListenerTemplate CreateFearOfMutonsTemplate()
{
	local X2TraitTemplate Template;

	`CREATE_X2TEMPLATE(class'X2TraitTemplate', Template, 'FearOfMutons');
	Template.AddEvent('UnitTakeEffectDamage', OnUnitTakeDamage);

	return Template;
}

static protected function X2EventListenerTemplate CreateHunterOfTheLostTemplate()
{
	local X2TraitTemplate Template;

	`CREATE_X2TEMPLATE(class'X2TraitTemplate', Template, 'HunterOfTheLost');

	return Template;
}

static protected function X2EventListenerTemplate CreateFearOfTheLostTemplate()
{
	local X2TraitTemplate Template;

	`CREATE_X2TEMPLATE(class'X2TraitTemplate', Template, 'FearOfTheLost');
	Template.AddEvent('UnitTakeEffectDamage', OnUnitTakeDamage);

	return Template;
}

static protected function X2EventListenerTemplate CreateHunterOfMecsTemplate()
{
	local X2TraitTemplate Template;

	`CREATE_X2TEMPLATE(class'X2TraitTemplate', Template, 'HunterOfMecs');

	return Template;
}

static protected function X2EventListenerTemplate CreateFearOfMecsTemplate()
{
	local X2TraitTemplate Template;

	`CREATE_X2TEMPLATE(class'X2TraitTemplate', Template, 'FearOfMecs');
	Template.AddEvent('UnitTakeEffectDamage', OnUnitTakeDamage);

	return Template;
}

static protected function X2EventListenerTemplate CreateHunterOfFacelessTemplate()
{
	local X2TraitTemplate Template;

	`CREATE_X2TEMPLATE(class'X2TraitTemplate', Template, 'HunterOfFaceless');

	return Template;
}

static protected function X2EventListenerTemplate CreateFearOfFacelessTemplate()
{
	local X2TraitTemplate Template;

	`CREATE_X2TEMPLATE(class'X2TraitTemplate', Template, 'FearOfFaceless');
	Template.AddEvent('UnitTakeEffectDamage', OnUnitTakeDamage);

	return Template;
}

static protected function X2EventListenerTemplate CreateFearOfSectoidsTemplate()
{
	local X2TraitTemplate Template;

	`CREATE_X2TEMPLATE(class'X2TraitTemplate', Template, 'FearOfSectoids');
	Template.AddEvent('UnitTakeEffectDamage', OnUnitTakeDamage);

	return Template;
}

// common handler to check for acquiring of default traits based on damage criteria 
static protected function EventListenerReturn OnUnitTakeDamage(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local XComGameState_Unit DamagedUnit;
	local XComGameState_Unit SourceUnit; // unit that caused the damage
	local XComGameState_Unit OtherUnit;
	local X2CharacterTemplate SourceUnitTemplate;
	local XComGameStateContext_Ability AbilityContext;
	local DamageResult LastDamageResult;
	local XComGameStateHistory History;
	local XComGameState_HeadquartersXCom XComHQ;
	local StateObjectReference SquadMemberRef;
	local X2TraitTemplate Template;
	local XComGameStateContext_WillRoll WillRollContext;

	DamagedUnit = XComGameState_Unit(EventData);

	// these are only available on xcom units
	if(DamagedUnit == none 
		|| DamagedUnit.GetTeam() != eTeam_XCom 
		|| !DamagedUnit.UsesWillSystem()
		|| DamagedUnit.IsDead())
	{
		return ELR_NoInterrupt;
	}

	AbilityContext = XComGameStateContext_Ability(GameState.GetContext());
	if(AbilityContext == none)
	{
		return ELR_NoInterrupt;
	}

	SourceUnit = XComGameState_Unit(GameState.GetGameStateForObjectID(AbilityContext.InputContext.SourceObject.ObjectID));
	if(SourceUnit == none)
	{
		return ELR_NoInterrupt; 
	}

	History = `XCOMHISTORY;
	XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
	SourceUnitTemplate = SourceUnit.GetMyTemplate();

	// Check for FearOfArchons. Procs when taking damage from melee or blazing pinions
	if(SourceUnitTemplate.CharacterGroupName == 'Archon' && !DamagedUnit.HasTrait('FearOfArchons'))
	{
		if(AbilityContext.InputContext.AbilityTemplateName == 'StandardMelee'
			|| AbilityContext.InputContext.AbilityTemplateName == 'BlazingPinionsStage2')
		{
			class'X2TraitTemplate'.static.RollForTrait(DamagedUnit, 'FearOfArchons');
		}
	}

	// Check for FearOfMutons. Procs when taking melee damage from a muton or berserker
	if((SourceUnitTemplate.CharacterGroupName == 'Muton' || SourceUnitTemplate.CharacterGroupName == 'Berserker')
		&& !DamagedUnit.HasTrait('FearOfMutons'))
	{
		if(AbilityContext.InputContext.AbilityTemplateName == 'Bayonet'
			|| AbilityContext.InputContext.AbilityTemplateName == 'DevastatingPunch')
		{
			class'X2TraitTemplate'.static.RollForTrait(DamagedUnit, 'FearOfMutons');
		}
	}

	// Check for FearOfTheLost and FearOfMECs
	if(SourceUnitTemplate.CharacterGroupName == 'TheLost' 
		&& !DamagedUnit.HasTrait('FearOfTheLost')
		&& HasUnitTakenThresholdDamageFromCharacterGroup(DamagedUnit, SourceUnitTemplate.CharacterGroupName, default.AcquireFearOfTheLostDamageThreshold))
	{
		class'X2TraitTemplate'.static.RollForTrait(DamagedUnit, 'FearOfTheLost');
	}

	if(SourceUnitTemplate.CharacterGroupName == 'AdventMEC' 
		&& !DamagedUnit.HasTrait('FearOfMecs')
		&& HasUnitTakenThresholdDamageFromCharacterGroup(DamagedUnit, SourceUnitTemplate.CharacterGroupName, default.AcquireFearOfMecsDamageThreshold))
	{
		class'X2TraitTemplate'.static.RollForTrait(DamagedUnit, 'FearOfMecs');
	}

	if( SourceUnitTemplate.CharacterGroupName == 'Sectoid'
	   && !DamagedUnit.HasTrait('FearOfSectoids')
	   && HasUnitTakenThresholdDamageFromCharacterGroup(DamagedUnit, SourceUnitTemplate.CharacterGroupName, default.AcquireFearOfSectoidsDamageThreshold) )
	{
		class'X2TraitTemplate'.static.RollForTrait(DamagedUnit, 'FearOfSectoids');
	}

	if(SourceUnitTemplate.bIsChosen && !DamagedUnit.HasTrait('FearOfChosen') )
	{
		class'X2TraitTemplate'.static.RollForTrait(DamagedUnit, 'FearOfChosen');
	}

	// FearOfPsionics
	LastDamageResult = DamagedUnit.DamageResults[DamagedUnit.DamageResults.Length - 1];

	if( LastDamageResult.DamageTypes.Find('Psi') != INDEX_NONE )
	{
		if( !DamagedUnit.HasTrait('FearOfPsionics') )
		{
			class'X2TraitTemplate'.static.RollForTrait(DamagedUnit, 'FearOfPsionics');
		}

		foreach XComHQ.Squad(SquadMemberRef)
		{
			OtherUnit = XComGameState_Unit(History.GetGameStateForObjectID(SquadMemberRef.ObjectID));

			if( OtherUnit.HasActiveTrait('FearOfPsionics') )
			{
				Template = GetTraitTemplate('FearOfPsionics');
				if( class'XComGameStateContext_WillRoll'.static.ShouldPerformWillRoll(Template.WillRollData, OtherUnit) )
				{
					WillRollContext = class'XComGameStateContext_WillRoll'.static.CreateWillRollContext(OtherUnit, Template.DataName, Template.TraitFriendlyName);
					WillRollContext.DoWillRoll(Template.WillRollData);
					WillRollContext.Submit();
				}
			}
		}
	}

	return ELR_NoInterrupt;
}

static protected function EventListenerReturn OnUnitBurned(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local XComGameState_Unit DamagedUnit;
	local XComGameState_Unit OtherUnit;
	local XComGameStateHistory History;
	local XComGameState_HeadquartersXCom XComHQ;
	local StateObjectReference SquadMemberRef;
	local X2TraitTemplate Template;
	local XComGameStateContext_WillRoll WillRollContext;

	DamagedUnit = XComGameState_Unit(EventData);

	// these are only available on xcom units
	if( DamagedUnit == none
	   || DamagedUnit.GetTeam() != eTeam_XCom
	   || !DamagedUnit.UsesWillSystem()
	   || DamagedUnit.IsDead() )
	{
		return ELR_NoInterrupt;
	}

	// FearOfFire
	History = `XCOMHISTORY;
	XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));

	if( !DamagedUnit.HasTrait('FearOfFire') )
	{
		class'X2TraitTemplate'.static.RollForTrait(DamagedUnit, 'FearOfFire');
	}

	foreach XComHQ.Squad(SquadMemberRef)
	{
		OtherUnit = XComGameState_Unit(History.GetGameStateForObjectID(SquadMemberRef.ObjectID));

		if( OtherUnit.HasActiveTrait('FearOfFire') )
		{
			Template = GetTraitTemplate('FearOfFire');
			if( class'XComGameStateContext_WillRoll'.static.ShouldPerformWillRoll(Template.WillRollData, OtherUnit) )
			{
				WillRollContext = class'XComGameStateContext_WillRoll'.static.CreateWillRollContext(OtherUnit, Template.DataName, Template.TraitFriendlyName);
				WillRollContext.DoWillRoll(Template.WillRollData);
				WillRollContext.Submit();
			}
		}
	}

	return ELR_NoInterrupt;
}

static protected function EventListenerReturn OnUnitPoisoned(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local XComGameState_Unit DamagedUnit;
	local XComGameState_Unit OtherUnit;
	local XComGameStateHistory History;
	local XComGameState_HeadquartersXCom XComHQ;
	local StateObjectReference SquadMemberRef;
	local X2TraitTemplate Template;
	local XComGameStateContext_WillRoll WillRollContext;

	DamagedUnit = XComGameState_Unit(EventData);

	// these are only available on xcom units
	if( DamagedUnit == none
	   || DamagedUnit.GetTeam() != eTeam_XCom
	   || !DamagedUnit.UsesWillSystem()
	   || DamagedUnit.IsDead() )
	{
		return ELR_NoInterrupt;
	}

	// FearOfPoison
	History = `XCOMHISTORY;
	XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));

	if( !DamagedUnit.HasTrait('FearOfPoison') )
	{
		class'X2TraitTemplate'.static.RollForTrait(DamagedUnit, 'FearOfPoison');
	}

	foreach XComHQ.Squad(SquadMemberRef)
	{
		OtherUnit = XComGameState_Unit(History.GetGameStateForObjectID(SquadMemberRef.ObjectID));

		if( OtherUnit.HasActiveTrait('FearOfPoison') )
		{
			Template = GetTraitTemplate('FearOfPoison');
			if( class'XComGameStateContext_WillRoll'.static.ShouldPerformWillRoll(Template.WillRollData, OtherUnit) )
			{
				WillRollContext = class'XComGameStateContext_WillRoll'.static.CreateWillRollContext(OtherUnit, Template.DataName, Template.TraitFriendlyName);
				WillRollContext.DoWillRoll(Template.WillRollData);
				WillRollContext.Submit();
			}
		}
	}

	return ELR_NoInterrupt;
}

// Returns true if the specified unit has taken at least Threshold fraction of their max health in 
// damage from the specified unit this match
static protected native function bool HasUnitTakenThresholdDamageFromCharacterGroup(XComGameState_Unit UnitState, name CharacterGroupName, float Threshold);

static protected function X2EventListenerTemplate CreateFearOfMissedShotsTemplate()
{
	local X2EventListenerTemplate Template;

	`CREATE_X2TEMPLATE(class'X2TraitTemplate', Template, 'FearOfMissedShots');

	Template.AddEvent('AbilityActivated', OnAbilityActivated_CheckFearOfMissedShots);

	return Template;
}

static protected function X2EventListenerTemplate CreateFearOfSquadmateMissedShotsTemplate()
{
	local X2EventListenerTemplate Template;

	`CREATE_X2TEMPLATE(class'X2TraitTemplate', Template, 'FearOfSquadmateMissedShots');

	Template.AddEvent('AbilityActivated', OnAbilityActivated_CheckFearOfMissedShots);

	return Template;
}

static protected function EventListenerReturn OnAbilityActivated_CheckFearOfMissedShots(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local XComGameStateContext_Ability AbilityContext;
	local XComGameStateContext_WillRoll WillRollContext;
	local XComGameState_Unit SourceUnit, OtherUnit;
	local X2AbilityTemplate AbilityTemplate;
	local X2TraitTemplate Template;
	local XComGameState_Ability AbilityState;
	local XComGameState_HeadquartersXCom XComHQ;
	local StateObjectReference SquadmateRef;
	local XComGameStateHistory History;

	if (GameState.GetContext().InterruptionStatus == eInterruptionStatus_Interrupt)
		return ELR_NoInterrupt;

	AbilityContext = XComGameStateContext_Ability(GameState.GetContext());
	AbilityState = XComGameState_Ability(EventData);
	AbilityTemplate = AbilityState.GetMyTemplate();
	SourceUnit = XComGameState_Unit(EventSource);

	if(AbilityContext.bFirstEventInChain && AbilityContext.ResultContext.HitResult == eHit_Miss && AbilityTemplate.Hostility == eHostility_Offensive )
	{
		if(SourceUnit.AcquiredTraits.Find('FearOfMissedShots') != INDEX_NONE)
		{
			Template = GetTraitTemplate('FearOfMissedShots');
			if( class'XComGameStateContext_WillRoll'.static.ShouldPerformWillRoll(Template.WillRollData, SourceUnit) )
			{
				WillRollContext = class'XComGameStateContext_WillRoll'.static.CreateWillRollContext(SourceUnit, Template.DataName, Template.TraitFriendlyName);
				WillRollContext.DoWillRoll(Template.WillRollData);
				WillRollContext.Submit();
			}
		}
		else if(!SourceUnit.HasTrait('FearOfMissedShots'))
		{
			// check to see if we've acquired this trait
			if(HasMissedTooManyEasyShotsThisMission(SourceUnit))
			{
				class'X2TraitTemplate'.static.RollForTrait(SourceUnit, 'FearOfMissedShots');
			}
		}

		History = `XCOMHISTORY;
		XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));

		foreach XComHQ.Squad(SquadmateRef)
		{
			if( SquadmateRef.ObjectID != SourceUnit.ObjectID )
			{
				OtherUnit = XComGameState_Unit(History.GetGameStateForObjectID(SquadmateRef.ObjectID));

				if( OtherUnit.HasActiveTrait('FearOfSquadmateMissedShots') )
				{
					Template = GetTraitTemplate('FearOfSquadmateMissedShots');
					if( class'XComGameStateContext_WillRoll'.static.ShouldPerformWillRoll(Template.WillRollData, OtherUnit) )
					{
						WillRollContext = class'XComGameStateContext_WillRoll'.static.CreateWillRollContext(OtherUnit, Template.DataName, Template.TraitFriendlyName);
						WillRollContext.DoWillRoll(Template.WillRollData);
						WillRollContext.Submit();
					}
				}
			}
		}
	}

	return ELR_NoInterrupt;
}

static protected function EventListenerReturn OnAbilityActivated_CheckForCritic(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local XComGameStateContext_Ability AbilityContext;
	local XComGameStateContext_WillRoll WillRollContext;
	local XComGameState_Unit SourceUnit, SquadUnit;
	local X2AbilityTemplate AbilityTemplate;
	local X2TraitTemplate Template;
	local XComGameState_HeadquartersXCom XComHQ;
	local StateObjectReference SquadmateRef;
	local XComGameStateHistory History;
	local XComGameState_Ability AbilityState;

	if (GameState.GetContext().InterruptionStatus == eInterruptionStatus_Interrupt)
		return ELR_NoInterrupt;

	AbilityContext = XComGameStateContext_Ability(GameState.GetContext());
	AbilityState = XComGameState_Ability(EventData);
	AbilityTemplate = AbilityState.GetMyTemplate();
	SourceUnit = XComGameState_Unit(EventSource);

	if( AbilityContext.bFirstEventInChain && AbilityContext.ResultContext.HitResult == eHit_Miss && AbilityTemplate.Hostility == eHostility_Offensive )
	{
		// critic trait - check for squadmates missing their shots
		History = `XCOMHISTORY;
			XComHQ = `XCOMHQ;
			foreach XComHQ.Squad(SquadmateRef)
		{
			if( SquadmateRef.ObjectID != SourceUnit.ObjectID )
			{
				SquadUnit = XComGameState_Unit(History.GetGameStateForObjectID(SquadmateRef.ObjectID));

				if( SquadUnit.AcquiredTraits.Find('Trait_Critic') != INDEX_NONE )
				{
					Template = GetTraitTemplate('Trait_Critic');
					if( class'XComGameStateContext_WillRoll'.static.ShouldPerformWillRoll(Template.WillRollData, SquadUnit) )
					{
						WillRollContext = class'XComGameStateContext_WillRoll'.static.CreateWillRollContext(SquadUnit, Template.DataName, Template.TraitFriendlyName);
						WillRollContext.DoWillRoll(Template.WillRollData);
						WillRollContext.Submit();
					}
				}
			}
		}
	}

	return ELR_NoInterrupt;
}

static protected function EventListenerReturn OnAbilityActivated_CheckForAggressive(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local XComGameStateContext_WillRoll WillRollContext;
	local XComGameState_Unit SourceUnit;
	local X2AbilityTemplate AbilityTemplate;
	local X2TraitTemplate Template;
	local XComGameState_Ability AbilityState;
	local array<StateObjectReference> arrVisibleUnits;

	if (GameState.GetContext().InterruptionStatus == eInterruptionStatus_Interrupt)
		return ELR_NoInterrupt;

	AbilityState = XComGameState_Ability(EventData);
	AbilityTemplate = AbilityState.GetMyTemplate();
	SourceUnit = XComGameState_Unit(EventSource);

	// aggressive trait - check for overwatch attempts
	if( (AbilityTemplate.DataName == 'Overwatch' || AbilityTemplate.DataName == 'PistolOverwatch') && (SourceUnit.AcquiredTraits.Find('Trait_Aggressive') != INDEX_NONE) )
	{
		// have to also check if an enemy is within LOS
		class'X2TacticalVisibilityHelpers'.static.GetAllVisibleEnemyTargetsForUnit(SourceUnit.ObjectID, arrVisibleUnits);
		if( arrVisibleUnits.Length > 0 )
		{
			Template = GetTraitTemplate('Trait_Aggressive');
			if( class'XComGameStateContext_WillRoll'.static.ShouldPerformWillRoll(Template.WillRollData, SourceUnit) )
			{
				WillRollContext = class'XComGameStateContext_WillRoll'.static.CreateWillRollContext(SourceUnit, Template.DataName, Template.TraitFriendlyName);
				if( AbilityTemplate.DataName == 'Overwatch' )
				{
					WillRollContext.DoWillRoll(Template.WillRollData);
				}
				else
				{
					WillRollContext.DoWillRoll(class'X2EventListener_DefaultWillEvents'.default.AggressivePistolWillRollData);
				}
				WillRollContext.Submit();
			}
		}
	}

	return ELR_NoInterrupt;
}

static protected function EventListenerReturn OnUnitMoveFinished_CheckForInsubordinate(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local XComGameStateContext_WillRoll WillRollContext;
	local XComGameState_Unit SourceUnit;
	local X2TraitTemplate Template;

	if (GameState.GetContext().InterruptionStatus == eInterruptionStatus_Interrupt)
		return ELR_NoInterrupt;

	SourceUnit = XComGameState_Unit(EventSource);

	// insubordinate trait - check for line of sight to multiple enemies OR flanked by at least 1 enemy
	if( (SourceUnit.AcquiredTraits.Find('Trait_Insubordinate') != INDEX_NONE) && IsUnitInABadPosition(SourceUnit) )
	{
		Template = GetTraitTemplate('Trait_Insubordinate');
		if( class'XComGameStateContext_WillRoll'.static.ShouldPerformWillRoll(Template.WillRollData, SourceUnit) )
		{
			WillRollContext = class'XComGameStateContext_WillRoll'.static.CreateWillRollContext(SourceUnit, Template.DataName, Template.TraitFriendlyName);
			WillRollContext.DoWillRoll(Template.WillRollData);
			WillRollContext.Submit();
		}
	}

	return ELR_NoInterrupt;
}

static protected function EventListenerReturn OnUnitMoveFinished_CheckForObsessiveReloader(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local XComGameStateContext_WillRoll WillRollContext;
	local XComGameState_Unit SourceUnit;
	local XComGameState_Item SourceWeapon;
	local X2TraitTemplate Template;

	if (GameState.GetContext().InterruptionStatus == eInterruptionStatus_Interrupt)
		return ELR_NoInterrupt;

	SourceUnit = XComGameState_Unit(EventSource);

	if( SourceUnit.NumActionPoints() > 0 )
	{
		// only if the source weapon exists and is low on ammo
		SourceWeapon = SourceUnit.GetPrimaryWeapon();
		if( SourceWeapon != None && SourceWeapon.Ammo < SourceWeapon.GetClipSize() )
		{
			// obsessive reloader - chance to reload after move
			if( (SourceUnit.AcquiredTraits.Find('Trait_ObsessiveReloader') != INDEX_NONE) /*&& SourceUnit.ammo needs to be reloaded ???*/ )
			{
				Template = GetTraitTemplate('Trait_ObsessiveReloader');
				if( class'XComGameStateContext_WillRoll'.static.ShouldPerformWillRoll(Template.WillRollData, SourceUnit) )
				{
					WillRollContext = class'XComGameStateContext_WillRoll'.static.CreateWillRollContext(SourceUnit, Template.DataName, Template.TraitFriendlyName);
					WillRollContext.DoWillRoll(Template.WillRollData);
					WillRollContext.Submit();
				}
			}
		}
	}

	return ELR_NoInterrupt;
}

static protected function EventListenerReturn OnUnitMoveFinished_CheckForCautious(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local XComGameStateContext_WillRoll WillRollContext;
	local XComGameState_Unit SourceUnit;
	local X2TraitTemplate Template;
	local X2AbilityTemplate AbilityTemplate;
	local XComGameState_Ability AbilityState;
	local ECoverType CoverType;

	if (GameState.GetContext().InterruptionStatus == eInterruptionStatus_Interrupt)
		return ELR_NoInterrupt;

	SourceUnit = XComGameState_Unit(EventSource);

	if( SourceUnit.NumActionPoints() > 0 )
	{
		AbilityState = XComGameState_Ability(EventData);
		AbilityTemplate = AbilityState.GetMyTemplate();

		// only consider standard moves, no melee moves
		if( AbilityTemplate.Hostility == eHostility_Movement )
		{
			// cautious trait - chance to hunker after move
			if( SourceUnit.AcquiredTraits.Find('Trait_Cautious') != INDEX_NONE )
			{
				// but only in cover
				CoverType = SourceUnit.GetCoverTypeFromLocation();
				if( CoverType != CT_None )
				{
					Template = GetTraitTemplate('Trait_Cautious');
					if( class'XComGameStateContext_WillRoll'.static.ShouldPerformWillRoll(Template.WillRollData, SourceUnit) )
					{
						WillRollContext = class'XComGameStateContext_WillRoll'.static.CreateWillRollContext(SourceUnit, Template.DataName, Template.TraitFriendlyName);
						WillRollContext.DoWillRoll(Template.WillRollData);
						WillRollContext.Submit();
					}
				}
			}
		}
	}

	return ELR_NoInterrupt;
}

static function bool IsUnitInABadPosition(XComGameState_Unit UnitState)
{
	// unit in a bad position if it is being flanked
	if( class'X2TacticalVisibilityHelpers'.static.GetNumFlankingEnemiesOfTarget(UnitState.ObjectID) > 0 )
	{
		return true;
	}

	// unit in a bad position if there are too many enemies in LOS
	if( class'X2TacticalVisibilityHelpers'.static.GetNumEnemyViewersOfTarget(UnitState.ObjectID) >= default.InsubordinateWhenInLOSOfXEnemies )
	{
		return true;
	}

	return false;
}

static protected function bool HasMissedTooManyEasyShotsThisMission(XComGameState_Unit UnitState)
{
	local XComGameStateContext_Ability AbilityContext;
	local int MissCount;

	while(UnitState != none)
	{
		AbilityContext = XComGameStateContext_Ability(UnitState.GetParentGameState().GetContext()); 
		if(AbilityContext != none 
			&& AbilityContext.InputContext.SourceObject.ObjectID == UnitState.ObjectID
			&& AbilityContext.bFirstEventInChain
			&& AbilityContext.ResultContext.CalculatedHitChance > default.FearOfMissedShotMinMissPercentage
			&& AbilityContext.ResultContext.HitResult == eHit_Miss)
		{
			MissCount++;
			if(MissCount >= default.FearOfMissedShotMinMissCount)
			{
				return true;
			}
		}

		UnitState = XComGameState_Unit(UnitState.GetPreviousVersion());
	}

	return false;
}

static protected function X2EventListenerTemplate CreateFearOfBreakingConcealmentTemplate()
{
	local X2EventListenerTemplate Template;

	`CREATE_X2TEMPLATE(class'X2TraitTemplate', Template, 'FearOfBreakingConcealment');

	Template.AddEvent('UnitConcealmentBroken', OnConcealmentBroken);
	Template.AddEvent('UnitTakeEffectDamage', CheckAcquireFearOfBreakingConcealment);

	return Template;
}

static protected function EventListenerReturn OnConcealmentBroken(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local XComGameStateContext_WillRoll WillRollContext;
	local XComGameState_Unit SourceUnit;
	local X2TraitTemplate Template;

	SourceUnit = XComGameState_Unit(EventSource);

	if(SourceUnit.AcquiredTraits.Find('FearOfBreakingConcealment') != INDEX_NONE)
	{
		Template = GetTraitTemplate('FearOfBreakingConcealment');
		if( class'XComGameStateContext_WillRoll'.static.ShouldPerformWillRoll(Template.WillRollData, SourceUnit) )
		{
			WillRollContext = class'XComGameStateContext_WillRoll'.static.CreateWillRollContext(SourceUnit, Template.DataName, Template.TraitFriendlyName);
			WillRollContext.DoWillRoll(Template.WillRollData);
			WillRollContext.Submit();
		}
	}

	return ELR_NoInterrupt;
}

static protected native function bool HasTakenTooMuchDamageAfterBreakingConcealment(XComGameState_Unit UnitState);
static protected function EventListenerReturn CheckAcquireFearOfBreakingConcealment(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local XComGameState_Unit DamagedUnit;
	local XComGameState_Unit SourceUnit; // unit that caused the damage
	local XComGameStateContext_Ability AbilityContext;

	DamagedUnit = XComGameState_Unit(EventData);
	AbilityContext = XComGameStateContext_Ability(GameState.GetContext());
	
	if (AbilityContext == none) // ignore other sources of damage
		return ELR_NoInterrupt;

	SourceUnit = XComGameState_Unit(GameState.GetGameStateForObjectID(AbilityContext.InputContext.SourceObject.ObjectID));

	// these are only available on xcom units
	if(DamagedUnit != none
		&& !DamagedUnit.HasTrait('FearOfBreakingConcealment') 
		&& HasTakenTooMuchDamageAfterBreakingConcealment(DamagedUnit))
	{
		class'X2TraitTemplate'.static.RollForTrait(SourceUnit, 'FearOfBreakingConcealment');
	}

	return ELR_NoInterrupt;
}

static protected function X2EventListenerTemplate CreateFearOfExplosivesTemplate()
{
	local X2TraitTemplate Template;

	`CREATE_X2TEMPLATE(class'X2TraitTemplate', Template, 'FearOfExplosives');
	//Template.AddEvent('UnitTakeEffectDamage', OnUnitTakeDamage); // todo

	return Template;
}

static protected function X2EventListenerTemplate CreateFearOfFireTemplate()
{
	local X2TraitTemplate Template;

	`CREATE_X2TEMPLATE(class'X2TraitTemplate', Template, 'FearOfFire');
	Template.AddEvent(class'X2Effect_Burning'.default.BurningEffectAddedEventName, OnUnitBurned);

	return Template;
}

static protected function X2EventListenerTemplate CreateFearOfPoisonTemplate()
{
	local X2TraitTemplate Template;

	`CREATE_X2TEMPLATE(class'X2TraitTemplate', Template, 'FearOfPoison');
	Template.AddEvent('PoisonedEffectAdded', OnUnitPoisoned);

	return Template;
}

static protected function X2EventListenerTemplate CreateFearOfPsionicsTemplate()
{
	local X2TraitTemplate Template;

	`CREATE_X2TEMPLATE(class'X2TraitTemplate', Template, 'FearOfPsionics');
	Template.AddEvent('UnitTakeEffectDamage', OnUnitTakeDamage);

	return Template;
}

static protected function X2EventListenerTemplate CreateFearOfPanicTemplate()
{
	local X2EventListenerTemplate Template;

	`CREATE_X2TEMPLATE(class'X2TraitTemplate', Template, 'FearOfPanic');

	Template.AddEvent('PanickedEffectApplied', OnEffectApplied_CheckFearOfPanic);

	return Template;
}

static protected function EventListenerReturn OnEffectApplied_CheckFearOfPanic(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local XComGameStateContext_WillRoll WillRollContext;
	local XComGameState_Unit SourceUnit, SquadUnit;
	local X2TraitTemplate Template;
	local XComGameState_HeadquartersXCom XComHQ;
	local StateObjectReference SquadmateRef;
	local XComGameStateHistory History;

	History = `XCOMHISTORY;
	XComHQ = `XCOMHQ;

	SourceUnit = XComGameState_Unit(EventData);

	// these are only available on xcom units
	if( SourceUnit == none
	   || SourceUnit.GetTeam() != eTeam_XCom
	   || SourceUnit.IsDead() )
	{
		return ELR_NoInterrupt;
	}

	// panic trait - check for panic behaviors from friendly units
	if( XComHQ.Squad.Find('ObjectID', SourceUnit.ObjectID) != INDEX_NONE )
	{
		foreach XComHQ.Squad(SquadmateRef)
		{
			if( SquadmateRef.ObjectID != SourceUnit.ObjectID )
			{
				SquadUnit = XComGameState_Unit(History.GetGameStateForObjectID(SquadmateRef.ObjectID));

				if( SquadUnit.AcquiredTraits.Find('FearOfPanic') != INDEX_NONE )
				{
					Template = GetTraitTemplate('FearOfPanic');
					if( class'XComGameStateContext_WillRoll'.static.ShouldPerformWillRoll(Template.WillRollData, SquadUnit) )
					{
						WillRollContext = class'XComGameStateContext_WillRoll'.static.CreateWillRollContext(SquadUnit, Template.DataName, Template.TraitFriendlyName);
						WillRollContext.DoWillRoll(Template.WillRollData);
						WillRollContext.Submit();
					}
				}
			}
		}
	}

	return ELR_NoInterrupt;
}

static protected function X2EventListenerTemplate CreateFearOfVertigoTemplate()
{
	local X2EventListenerTemplate Template;

	`CREATE_X2TEMPLATE(class'X2TraitTemplate', Template, 'FearOfVertigo');

	Template.AddEvent('UnitGroupTurnBegun', OnTurnBegun_CheckFearOfVertigo);

	return Template;
}

static protected function EventListenerReturn OnTurnBegun_CheckFearOfVertigo(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local XComGameStateContext_WillRoll WillRollContext;
	local XComGameState_Unit SquadUnit;
	local X2TraitTemplate Template;
	local XComGameState_HeadquartersXCom XComHQ;
	local StateObjectReference SquadmateRef;
	local XComGameStateHistory History;
	local XComWorldData WorldData;
	local int LowestFloorTileZ;
	local TTile TileTestLocation;
	local XComGameState_AIGroup GroupState;

	GroupState = XComGameState_AIGroup(EventData);

	if( GroupState.TeamName != eTeam_XCom )
	{
		return ELR_NoInterrupt;
	}

	History = `XCOMHISTORY;
	XComHQ = `XCOMHQ;
	WorldData = `XWORLD;

	// vertigo trait - check for a floor tile beneath starting tile
	foreach XComHQ.Squad(SquadmateRef)
	{
		SquadUnit = XComGameState_Unit(History.GetGameStateForObjectID(SquadmateRef.ObjectID));

		if( SquadUnit.AcquiredTraits.Find('FearOfVertigo') != INDEX_NONE )
		{
			TileTestLocation = SquadUnit.TurnStartLocation;
			--TileTestLocation.Z;
			LowestFloorTileZ = WorldData.GetFloorTileZ(TileTestLocation, true);

			if( LowestFloorTileZ < SquadUnit.TurnStartLocation.Z && LowestFloorTileZ >= 0 )
			{
				Template = GetTraitTemplate('FearOfVertigo');
				if( class'XComGameStateContext_WillRoll'.static.ShouldPerformWillRoll(Template.WillRollData, SquadUnit) )
				{
					WillRollContext = class'XComGameStateContext_WillRoll'.static.CreateWillRollContext(SquadUnit, Template.DataName, Template.TraitFriendlyName);
					WillRollContext.DoWillRoll(Template.WillRollData);
					WillRollContext.Submit();
				}
			}
		}
	}

	return ELR_NoInterrupt;
}

static protected function X2EventListenerTemplate CreateFearOfNoMovementTemplate()
{
	local X2EventListenerTemplate Template;

	`CREATE_X2TEMPLATE(class'X2TraitTemplate', Template, 'FearOfNoMovement');

	Template.AddEvent('AbilityActivated', OnAbilityActivated_CheckFearOfNoMovement);

	return Template;
}

static protected function EventListenerReturn OnAbilityActivated_CheckFearOfNoMovement(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local XComGameStateContext_WillRoll WillRollContext;
	local XComGameState_Unit SourceUnit;
	local X2TraitTemplate Template;
	local X2TacticalGameRuleset TacticalRules;

	TacticalRules = `TACTICALRULES;

	SourceUnit = XComGameState_Unit(EventSource);

	// Antsy trait - check for no action points remaining and ending tile == TurnStartLocation
	if( (SourceUnit.AcquiredTraits.Find('FearOfNoMovement') != INDEX_NONE) && 
	   !TacticalRules.UnitHasActionsAvailable(SourceUnit) &&
	   SourceUnit.TurnStartLocation == SourceUnit.TileLocation )
	{
		Template = GetTraitTemplate('FearOfNoMovement');
		if( class'XComGameStateContext_WillRoll'.static.ShouldPerformWillRoll(Template.WillRollData, SourceUnit) )
		{
			WillRollContext = class'XComGameStateContext_WillRoll'.static.CreateWillRollContext(SourceUnit, Template.DataName, Template.TraitFriendlyName);
			WillRollContext.DoWillRoll(Template.WillRollData);
			WillRollContext.Submit();
		}
	}

	return ELR_NoInterrupt;
}

