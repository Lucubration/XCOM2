//---------------------------------------------------------------------------------------
//  FILE:    X2SabotageTemplate.uc
//  AUTHOR:  Mark Nauta
//  PURPOSE: Define Chosen Sabotage Types
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class X2SabotageTemplate extends X2GameplayMutatorTemplate config(GameData);

var config string ImagePath;
var config array<TemplateNarrative> OnActivatedNarrativeMoments;

var localized string					ShortSummaryText;

var Delegate<CanActivateDelegate> CanActivateFn;

delegate bool CanActivateDelegate();

//---------------------------------------------------------------------------------------
DefaultProperties
{
}