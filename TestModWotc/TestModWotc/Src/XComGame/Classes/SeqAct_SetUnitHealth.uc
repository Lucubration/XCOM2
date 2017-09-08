//---------------------------------------------------------------------------------------
//  FILE:    SeqAct_SetUnitHealth.uc
//  AUTHOR:  James Brawley -- 12/19/2016
//  PURPOSE: Directly modify a units health in Kismet.  Added to adjust the HP of the Chosen
//			 When it spawns because the sarcophagus exploded.  Since the Chosen is not fully
//			 restored, we adjust the HP down to match the "restoration percentage"
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class SeqAct_SetUnitHealth extends SequenceAction
	implements(X2KismetSeqOpVisualizer);

enum SeqAct_SetUnitHealth_SetMethod
{
	SetMethod_FlatValue,
	SetMethod_PercentageOfMaxHealth,
};

var XComGameState_Unit Unit;
var() int HealthAmount;
var() SeqAct_SetUnitHealth_SetMethod SetMethod;

function Activated();
function BuildVisualization(XComGameState GameState);

function ModifyKismetGameState(out XComGameState GameState)
{
	local int MaxHP;
	local int NewHPAmount;

	if(HealthAmount > 0)
	{
		if(Unit != none)
		{
			Unit = XComGameState_Unit(GameState.ModifyStateObject(class'XComGameState_Unit', Unit.ObjectID));

			MaxHP = Unit.GetMaxStat(eStat_HP);

			switch(SetMethod)
			{
			case SetMethod_FlatValue:
				// If the user sets the health to an amount higher than the unit's Max HP, update Max HP to match
				if(HealthAmount > MaxHP)
				{
					Unit.SetBaseMaxStat(eStat_HP, HealthAmount);
				}

				Unit.SetCurrentStat(eStat_HP, HealthAmount);
				break;

			case SetMethod_PercentageOfMaxHealth:
				// If the user sets the health to an amount greater than 100%, update the Max HP to match
				NewHPAmount = MaxHP * HealthAmount / 100;

				if(HealthAmount > 100)
				{
					Unit.SetBaseMaxStat(eStat_HP, NewHPAmount);
				}

				Unit.SetCurrentStat(eStat_HP, Max(1, NewHPAmount));
				break;
			}

			Unit.LowestHP = Min(Unit.LowestHP, Unit.GetCurrentStat(eStat_HP));
		}
		else
		{
			`Redscreen("SeqAct_SetUnitHealth: Called on a null unit reference.");
		}
	}
	else
	{
		`Redscreen("SeqAct_SetUnitHealth: Called with a negative or zero health value, which is not okay.");
	}
}

defaultproperties
{
	ObjCategory="Unit"
	ObjName="Set Unit Health"

	bConvertedForReplaySystem=true
	bCanBeUsedForGameplaySequence=true

	InputLinks(0)=(LinkDesc="In")
	
	bAutoActivateOutputLinks=true
	VariableLinks(0)=(ExpectedType=class'SeqVar_GameUnit',LinkDesc="Unit",PropertyName=Unit)
	VariableLinks(1)=(ExpectedType=class'SeqVar_Int',LinkDesc="Amount",PropertyName=HealthAmount)
}
