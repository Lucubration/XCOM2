//---------------------------------------------------------------------------------------
//  FILE:    SeqVar_GameUnit.uc
//  AUTHOR:  David Burchanowski  --  1/23/2014
//  PURPOSE: Stores a handle to a game unit in kismet
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class SeqVar_GameUnit extends SeqVar_GameStateObject
	native;

cpptext
{
	virtual FString GetValueStr()
	{
		return TEXT("Game Unit");
	}
}

defaultproperties
{
	ObjName="Game Unit"
	ObjCategory=""
	ObjColor=(R=255,G=165,B=0,A=255)
}