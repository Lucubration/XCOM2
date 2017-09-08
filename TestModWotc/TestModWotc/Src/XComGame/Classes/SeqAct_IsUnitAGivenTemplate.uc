//---------------------------------------------------------------------------------------
//  *********   FIRAXIS SOURCE CODE   ******************
//  FILE:    SeqAct_IsUnitAGivenTemplate.uc
//  AUTHOR:  James Brawley
//  PURPOSE: Indicates if a given unit matches any entry in an array of template names
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//--------------------------------------------------------------------------------------- 

class SeqAct_IsUnitAGivenTemplate extends SequenceAction;

var XComGameState_Unit Unit;

var() array<string> CharacterTemplateFilters; // Returns true if the unit's template is found in this list
var() bool bIgnoreGhostUnits; // If true, units that are ghosts are ignored (templars)

event Activated()
{
	OutputLinks[0].bHasImpulse = false;
	OutputLinks[1].bHasImpulse = true;

	if (Unit != none)
	{
		if(CharacterTemplateFilters.Length != 0)
		{
			if(Unit.GhostSourceUnit.ObjectID > 0 && bIgnoreGhostUnits) // Unit is a ghost, so ignore it
			{
				return;
			}
			else if(CharacterTemplateFilters.Find(string(Unit.GetMyTemplateName())) != INDEX_NONE)
			{
				OutputLinks[0].bHasImpulse = true;
				OutputLinks[1].bHasImpulse = false;
			}
		}
		else
		{
			`Redscreen("SeqAct_IsUnitAGivenTemplate: No template names added to check unit template against");
		}
	}
	else
	{
		`Redscreen("SeqAct_IsUnitAGivenTemplate: No unit or invalid unit passed to kismet action");
	}
}

defaultproperties
{
	ObjName="Is Unit A Given Template"
	ObjCategory="Unit"

	OutputLinks(0)=(LinkDesc="Yes")
	OutputLinks(1)=(LinkDesc="No")

	bConvertedForReplaySystem=true
	bCanBeUsedForGameplaySequence=true
	bAutoActivateOutputLinks=false

	bIgnoreGhostUnits=true

	VariableLinks.Empty;
	VariableLinks(0)=(ExpectedType=class'SeqVar_GameUnit',LinkDesc="Unit", PropertyName=Unit, bWriteable=false)
}