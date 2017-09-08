//---------------------------------------------------------------------------------------
//  FILE:    X2TraitTemplate.uc
//  AUTHOR:  David Burchanowsk
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class X2TraitTemplate extends X2EventListenerTemplate
	config(GameCore)
	native(Core);

var localized string TraitFriendlyName; // short name of the trait, e.g. "Fear of Missed Shots"
var localized string TraitScientificName; // flavor name that will sometimes appear, "Demonophobia"
var localized string TraitDescription; // Description of the trait effects. e.g. "Chance to lose will when missing a shot."
var localized array<string> TraitQuotes; // Quotes from soldiers expressing their thoughts on the trait

// Icon path
var config string IconImage;

// Will roll config to use when testing a roll with this trait
var const config WillEventRollData WillRollData;

// if true, this is a positive trait, else this is a negative trait
var config bool bPositiveTrait;

// if true, this trait does not require a specific trigger to be acquired
var config bool bGenericTrait;

// only applicable to negative traits, when this trait is cured, always replace it with the specified replacement trait
var config Name PositiveReplacementTrait;

// The following list of abilities will be added to any unit possessing this trait
var config array<Name> Abilities;

static function RollForTrait(XComGameState_Unit Unit, 
							 name TraitTemplateName, 
							 optional float BaseRollModifier = 1, 
							 optional XComGameState NewGameState = none)
{
	//local XComGameStateContext_ChangeContainer ChangeContext;
	local float Roll;
	local bool CreatedState;

	if(!Unit.UsesWillSystem() || Unit.IsDead())
	{
		return;
	}

	if(Unit.HasTrait(TraitTemplateName) || Unit.EverHadTrait(TraitTemplateName))
	{
		// this unit already has this trait
		return;
	}

	Roll = class'Engine'.static.GetEngine().SyncFRand("RollForTrait");
	if(Roll < (BaseRollModifier - Unit.GetCurrentStat(eStat_Will) * 0.01))
	{
		if(NewGameState == none)
		{
			CreatedState = true;
			NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState('Adding trait ' $ TraitTemplateName);

			// dkaplan - removing world message preview - 12/2/16
			//// temporary visualization so that milestone reviewers can see traits being acquired
			//ChangeContext = XComGameStateContext_ChangeContainer(NewGameState.GetContext());
			//ChangeContext.BuildVisualizationFn = BuildAcquireTraitVisualization;
		}

		Unit = XComGameState_Unit(NewGameState.ModifyStateObject(Unit.Class, Unit.ObjectID));
		Unit.AcquireTrait(NewGameState, TraitTemplateName);

		if(CreatedState)
		{
			`TACTICALRULES.SubmitGameState(NewGameState);
		}
	}
}

protected static function BuildAcquireTraitVisualization(XComGameState VisualizeGameState)
{
	local X2Action_PlayMessageBanner WorldMessageAction;
	local XComGameState_Unit UnitState;
	local XComGameState_Unit PreviousUnitState;
	local VisualizationActionMetadata BuildTrack;
	local X2TraitTemplate TraitTemplate;
	local name TraitTemplateName;
	local XGParamTag Tag;

	Tag = XGParamTag(`XEXPANDCONTEXT.FindTag("XGParam"));

	foreach VisualizeGameState.IterateByClassType(class'XComGameState_Unit', UnitState)
	{
		PreviousUnitState = XComGameState_Unit(UnitState.GetPreviousVersion());

		Tag.StrValue0 = UnitState.GetFullName();

		// find the trait we added to the unit and show a flyover
		foreach UnitState.PendingTraits(TraitTemplateName)
		{
			if(PreviousUnitState.PendingTraits.Find(TraitTemplateName) == INDEX_NONE)
			{
				TraitTemplate = X2TraitTemplate(class'X2EventListenerTemplateManager'.static.GetEventListenerTemplateManager().FindEventListenerTemplate(TraitTemplateName));
				if(TraitTemplate != none)
				{
					BuildTrack.StateObject_NewState = UnitState;
					BuildTrack.StateObject_OldState = PreviousUnitState;

					// unlocalized concatenation is okay here because this function is intended to be removed once
					// the final trait acquired UI has been completed.
					WorldMessageAction = X2Action_PlayMessageBanner(class'X2Action_PlayMessageBanner'.static.AddToVisualizationTree(BuildTrack, VisualizeGameState.GetContext()));
					Tag.StrValue1 = TraitTemplate.TraitFriendlyName;
					WorldMessageAction.AddMessageBanner(`XEXPAND.ExpandString(class'XGLocalizedData'.default.TraitAcquiredFormatString), "");
				}
			}
		}
	}
}

static function array<name> GetAllGenericTraitNames()
{
	local X2EventListenerTemplateManager EventMgr;
	local X2DataTemplate EventTemplate;
	local X2TraitTemplate TraitTemplate;
	local array<name> GenericTraits;

	EventMgr = class'X2EventListenerTemplateManager'.static.GetEventListenerTemplateManager();
	GenericTraits.Length = 0;

	foreach EventMgr.IterateTemplates(EventTemplate)
	{
		TraitTemplate = X2TraitTemplate(EventTemplate);

		if(TraitTemplate != none && TraitTemplate.bGenericTrait)
		{
			GenericTraits.AddItem(TraitTemplate.DataName);
		}
	}

	return GenericTraits;
}

defaultproperties
{
	RegisterInTactical=true
}