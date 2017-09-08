//---------------------------------------------------------------------------------------
//  FILE:    X2SitRep.uc
//  AUTHOR:  David Burchanowski  --  8/5/2016
//  PURPOSE: Interface for adding new sitreps to X-Com 2. Extend this class and then
//           implement CreateTemplates to produce one or more sitrep templates
//           defining new sitreps.
//
//           SitReps should go in data eventually, however while they are in initial development
//           it will be useful to have them in script
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class X2SitRep extends X2DataSet;