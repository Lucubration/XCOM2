//---------------------------------------------------------------------------------------
//  FILE:    WatchVariableMgr.uc
//  AUTHOR:  Ryan McFall  --  04/04/2012
//  PURPOSE: This object creates a map of all variables in kismet so that classes
//           that need to access these variables by name don't recurse through
//           the kismet graph burning our frame time away.
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class KismetVariableMgr extends Actor native;

var native transient Map_Mirror VariableMap{TMap< FName, TArray<class USequenceVariable*> >};
var native transient Map_Mirror ClassMap{TMap< UClass*, TArray<class USequenceObject*> >};

native function RebuildVariableMap();
native function GetVariable(name VariableName, out array<SequenceVariable> OutVariables);
native function GetVariableStartingWith(name VariableName, out array<SequenceVariable> OutVariables);

native function RebuildClassMap();
native function array<SequenceObject> GetObjectByClass( class SequenceClass );

defaultproperties
{
}