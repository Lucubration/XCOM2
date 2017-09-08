//---------------------------------------------------------------------------------------
//  FILE:    SeqVar_GameStateList.uc
//  AUTHOR:  David Burchanowski  --  6/30/2016
//  PURPOSE: Stores a list of game state objects in kismet
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class SeqVar_GameStateList extends SequenceVariable
	native;

var array<StateObjectReference> GameStates;

cpptext
{
	virtual FString GetValueStr()
	{
		return TEXT("Game State List");
	}

	virtual UBOOL SupportsProperty(UProperty *Property)
	{
		return FALSE;
	}

	virtual void PublishValue(USequenceOp *Op, UProperty *Property, FSeqVarLink &VarLink);
	virtual void PopulateValue(USequenceOp *Op, UProperty *Property, FSeqVarLink &VarLink);
}

defaultproperties
{
	ObjName="Game State List"
	ObjCategory=""
	ObjColor=(R=255,G=165,B=0,A=255)
}