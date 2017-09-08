//---------------------------------------------------------------------------------------
//  FILE:    X2Effect_PersistentStatChangeRestoreDefault.uc
//  AUTHOR:  Dan Kaplan
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class X2Effect_PersistentStatChangeRestoreDefault extends X2Effect_ModifyStats;

// For each stat type defined, this effect will restore the affected unit's stat of that type to it's default value 
// (by modifying it from whatever it is currently)
var array<ECharStatType>	StatTypesToRestore;

simulated function AddPersistentStatChange(ECharStatType StatType)
{
	StatTypesToRestore.AddItem(StatType);
}

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local StatChange NewChange;
	local int Index;
	local XComGameState_Unit NewUnitState;
	local X2CharacterTemplate UnitTemplate;

	NewUnitState = XComGameState_Unit(kNewTargetState);

	if( NewUnitState != None )
	{
		UnitTemplate = NewUnitState.GetMyTemplate();
		NewEffectState.StatChanges.Length = 0;

		for( Index = 0; Index < StatTypesToRestore.Length; ++Index )
		{
			NewChange.StatType = StatTypesToRestore[Index];
			NewChange.StatAmount = UnitTemplate.GetCharacterBaseStat(NewChange.StatType) - NewUnitState.GetMaxStat(NewChange.StatType);
			NewChange.ModOp = MODOP_Addition;

			NewEffectState.StatChanges.AddItem(NewChange);
		}
	}

	super.OnEffectAdded(ApplyEffectParameters, kNewTargetState, NewGameState, NewEffectState);
}