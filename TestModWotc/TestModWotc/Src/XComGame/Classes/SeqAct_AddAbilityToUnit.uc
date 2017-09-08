//---------------------------------------------------------------------------------------
//  FILE:    SeqAct_AddAbilityToUnit.uc
//  AUTHOR:  James Brawley -- 12/19/2016
//  PURPOSE: Directly add an ability to a unit via Kismet
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class SeqAct_AddAbilityToUnit extends SequenceAction
	implements(X2KismetSeqOpVisualizer);

var XComGameState_Unit Unit;
var() string AbilityToAdd;

function Activated();
function BuildVisualization(XComGameState GameState);

function ModifyKismetGameState(out XComGameState GameState)
{
	local X2TacticalGameRuleset TacticalRules;
	local X2AbilityTemplate AbilityTemplate, TestAbilityTemplate;
	local X2AbilityTemplateManager AbilityTemplateManager;
	local bool UnitAlreadyHasAbility;
	local name AbilityTemplateName, AdditionalTemplateName;
	local array<X2AbilityTemplate> AddAbilityTemplates;

	AbilityTemplateName = name(AbilityToAdd);

	AbilityTemplateManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();
	AbilityTemplate = AbilityTemplateManager.FindAbilityTemplate(AbilityTemplateName);

	if(Unit != none)
	{
		if( AbilityTemplate != None )
		{
			// May need to add additional abilities
			AddAbilityTemplates.AddItem(AbilityTemplate);

			TacticalRules = `TACTICALRULES;

			Unit = XComGameState_Unit(GameState.ModifyStateObject(class'XComGameState_Unit', Unit.ObjectID));

			foreach AddAbilityTemplates(TestAbilityTemplate)
			{
				// Add any additional ability templates to the array to add later
				foreach TestAbilityTemplate.AdditionalAbilities(AdditionalTemplateName)
				{
					AbilityTemplate = AbilityTemplateManager.FindAbilityTemplate(AdditionalTemplateName);
					if (AbilityTemplate != none)
					{
						AddAbilityTemplates.AddItem(AbilityTemplate);
					}
				}

				if (TestAbilityTemplate.OverrideAbilities.Length > 0)
				{
					`Redscreen("SeqAct_AddAbilityToUnit: OverrideAbilities are not currently supported when adding through this SeqAct.");
				}

				UnitAlreadyHasAbility = (Unit.FindAbility(TestAbilityTemplate.DataName).ObjectID > 0);

			if( !UnitAlreadyHasAbility )
			{
					TacticalRules.InitAbilityForUnit(TestAbilityTemplate, Unit, GameState);
				}
			}
		}
		else
		{
			`Redscreen("SeqAct_AddAbilityToUnit: Called without an ability template specified or with a bad ability name.");
		}
	}
	else
	{
		`Redscreen("SeqAct_AddAbilityToUnit: Called on a null unit reference.");
	}
}

static event int GetObjClassVersion()
{
	return super.GetObjClassVersion() + 0;
}

defaultproperties
{
	ObjCategory="Unit"
	ObjName="Add Ability To Unit"

	bConvertedForReplaySystem=true
	bCanBeUsedForGameplaySequence=true
	
	bAutoActivateOutputLinks=true
	VariableLinks(0)=(ExpectedType=class'SeqVar_GameUnit',LinkDesc="Unit",PropertyName=Unit)
	VariableLinks(1)=(ExpectedType=class'SeqVar_String',LinkDesc="AbilityToAdd",PropertyName=AbilityToAdd)
}
