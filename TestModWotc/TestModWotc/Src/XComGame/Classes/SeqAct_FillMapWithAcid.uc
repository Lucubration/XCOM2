//---------------------------------------------------------------------------------------
//  FILE:    SeqAct_FillMapWithAcid.uc
//  AUTHOR:  David Burchanowski, et. al.  --  11/15/2016
//  PURPOSE: Causes an unfortunate chemical spill in the mission
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class SeqAct_FillMapWithAcid extends SequenceAction
	config(GameCore)
	native;

var protected const config int AcidBlobSpacing;

native static function SpawnAcid();

event Activated()
{
	SpawnAcid();
}

defaultproperties
{
	ObjCategory="Procedural Missions"
	ObjName="Fill Map With Acid"

	bConvertedForReplaySystem=true
	bCanBeUsedForGameplaySequence=true
	bAutoActivateOutputLinks=true

	VariableLinks.Empty
}
