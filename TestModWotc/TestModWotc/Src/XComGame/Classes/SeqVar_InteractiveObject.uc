//---------------------------------------------------------------------------------------
//  FILE:    SeqVar_InteractiveObject.uc
//  AUTHOR:  Dan Kaplan  --  6/18/2014
//  PURPOSE: Stores a handle to an interactive object in kismet
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class SeqVar_InteractiveObject extends SeqVar_GameStateObject
	native
	dependson(XComGameState_InteractiveObject);

function XComGameState_InteractiveObject GetInteractiveObject()
{
	return XComGameState_InteractiveObject(`XCOMHISTORY.GetGameStateForObjectID(IntValue));
}

cpptext
{
	virtual FString GetValueStr()
	{
		return TEXT("Interactive Object");
	}
}

defaultproperties
{
	ObjName="Interactive Object"
	ObjCategory=""
	ObjColor=(R=255,G=100,B=100,A=255)
}