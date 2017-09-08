//---------------------------------------------------------------------------------------
//  FILE:    SeqVar_ParameterizedBool.uc
//  AUTHOR:  David Burchanowski  --  6/29/2016
//  PURPOSE: Allows config file values to be accessed from the kismet stage
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class SeqVar_ParameterizedBool extends SeqVar_Bool
	native;

// path in the config files for this value
var() private const string ParameterPath; 

cpptext
{
	virtual FString GetValueStr()
	{
		return ParameterPath;
	}

	virtual void PostLoad();

	// don't populate, after we load from the config file this value is effectively immutable
	virtual void PopulateValue(USequenceOp *Op, UProperty *Property, FSeqVarLink &VarLink) {}
}

defaultproperties
{
	ObjName="Parameterized Bool"
	ObjColor=(R=196,G=0,B=0,A=255)			// dark red
}