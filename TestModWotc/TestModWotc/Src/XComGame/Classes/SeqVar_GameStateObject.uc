//---------------------------------------------------------------------------------------
//  FILE:    SeqVar_GameStateObject.uc
//  AUTHOR:  Dan Kaplan  --  7/26/2016
//  PURPOSE: Stores a handle to a game state object in kismet
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class SeqVar_GameStateObject extends SeqVar_Int
	native
	dependson(XComGameState_BaseObject);

function XComGameState_BaseObject GetObject()
{
	return `XCOMHISTORY.GetGameStateForObjectID(IntValue);
}

cpptext
{
	virtual FString GetValueStr()
	{
		return TEXT("Game State Object");
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
	ObjName="Game State Object"
	ObjCategory=""
	ObjColor=(R=255,G=100,B=100,A=255)
}