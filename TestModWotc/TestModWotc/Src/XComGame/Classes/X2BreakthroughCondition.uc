//---------------------------------------------------------------------------------------
//  FILE:    X2BreakthroughCondition.uc
//  AUTHOR:  Russell Aasland
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class X2BreakthroughCondition extends Object 
	editinlinenew
	hidecategories(Object)
	abstract;

function bool MeetsCondition(XComGameState_BaseObject kTarget);