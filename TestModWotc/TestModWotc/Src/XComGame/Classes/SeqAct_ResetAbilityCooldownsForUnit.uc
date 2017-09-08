//---------------------------------------------------------------------------------------
//  FILE:    SeqAct_ResetAbilityCooldownsForUnit.uc
//  AUTHOR:  James Brawley -- 12/19/2016
//  PURPOSE: Directly add an ability to a unit via Kismet
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class SeqAct_ResetAbilityCooldownsForUnit extends SequenceAction
	implements(X2KismetSeqOpVisualizer);

var XComGameState_Unit Unit;
var bool bResetAllAbilities;
var() string AbilityToReset;

function Activated();
function BuildVisualization(XComGameState GameState);

function ModifyKismetGameState(out XComGameState GameState)
{
	local XComGameState_Ability NewAbilityState;
	local XComGameState_Player NewPlayerState;
	local XComGameState_Unit UnitState;

	local XComGameStateHistory History;
	local name AbilityTemplateName;
	local name CurrentAbilityName;

	AbilityTemplateName = name(AbilityToReset);

	// Preliminary data checks
	if(!bResetAllAbilities && AbilityToReset == "")
	{
		`Redscreen("SeqAct_ResetAbilityCooldownsForUnit: Called with illegal parameters. No ability name specified and not set to reset all ability cooldowns.");
	}

	// If we have a valid unit
	if(Unit != none)
	{
		History = `XCOMHISTORY;

		foreach History.IterateByClassType(class'XComGameState_Ability', NewAbilityState)
		{
			// Get name of ability we're iterating over
			CurrentAbilityName = NewAbilityState.GetMyTemplateName();

			// Get the owner unit of this ability
			UnitState = XComGameState_Unit(History.GetGameStateForObjectID(NewAbilityState.OwnerStateObject.ObjectID));

			// If the ability in question belongs to the unit we've passed to this node
			if( UnitState.ObjectID == Unit.ObjectID)
			{
				// If the ability is cooling down AND If this is the requested ability, or if we're resetting all abilities...
				if( (bResetAllAbilities || AbilityTemplateName == CurrentAbilityName) && NewAbilityState.IsCoolingDown())
				{
					// update the cooldown on the ability itself
					NewAbilityState = XComGameState_Ability(GameState.ModifyStateObject(class'XComGameState_Ability', NewAbilityState.ObjectID));
					NewAbilityState.iCooldown = 0;

					// update the cooldown on the player
					NewPlayerState = XComGameState_Player(GameState.GetGameStateForObjectID(UnitState.GetAssociatedPlayerID()));
					if( NewPlayerState == None )
					{
						NewPlayerState = XComGameState_Player(History.GetGameStateForObjectID(UnitState.GetAssociatedPlayerID()));
					}
					if( NewPlayerState.GetCooldown(CurrentAbilityName) > 0)
					{
						NewPlayerState = XComGameState_Player(GameState.ModifyStateObject(class'XComGameState_Player', NewPlayerState.ObjectID));
						NewPlayerState.SetCooldown(CurrentAbilityName, 0);
					}
				}
			}
		}
	}
	else
	{
		`Redscreen("SeqAct_ResetAbilityCooldownsForUnit: Called on a null unit reference.");
	}
}

static event int GetObjClassVersion()
{
	return super.GetObjClassVersion() + 0;
}

defaultproperties
{
	ObjCategory="Unit"
	ObjName="Reset Ability Cooldowns for Unit"

	bConvertedForReplaySystem=true
	bCanBeUsedForGameplaySequence=true
	
	bAutoActivateOutputLinks=true
	VariableLinks(0)=(ExpectedType=class'SeqVar_GameUnit',LinkDesc="Unit",PropertyName=Unit)
	VariableLinks(1)=(ExpectedType=class'SeqVar_String',LinkDesc="AbilityToReset",PropertyName=AbilityToReset)
}
