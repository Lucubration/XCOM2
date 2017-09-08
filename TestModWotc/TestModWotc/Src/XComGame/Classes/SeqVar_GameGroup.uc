//---------------------------------------------------------------------------------------
//  FILE:    SeqVar_GameStateObject.uc
//  AUTHOR:  Dan Kaplan  --  7/26/2016
//  PURPOSE: Stores a handle to an AIGroup in kismet
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class SeqVar_GameGroup extends SeqVar_GameStateObject
	native;

function XComGameState_AIGroup GetGroup()
{
	return XComGameState_AIGroup(`XCOMHISTORY.GetGameStateForObjectID(IntValue));
}

cpptext
{
	virtual FString GetValueStr()
	{
		return TEXT("Game Group");
	}
}

defaultproperties
{
	ObjName="Game Group"
	ObjCategory=""
	ObjColor=(R=255,G=100,B=100,A=255)
}