//---------------------------------------------------------------------------------------
//  FILE:    X2SitRepEffect_ModifyWillPenalties.uc
//  AUTHOR:  Russell Aasland  --  3/13/2017
//  PURPOSE: Allows sitreps to modify pod spawn sizes
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class X2SitRepEffect_ModifyWillPenalties extends X2SitRepEffectTemplate;

var array<name> WillEventNames;
var float ModifyScalar;