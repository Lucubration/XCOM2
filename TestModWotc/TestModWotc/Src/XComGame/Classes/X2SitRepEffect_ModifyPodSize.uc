//---------------------------------------------------------------------------------------
//  FILE:    X2SitRepEffect_ModifyPodSize.uc
//  AUTHOR:  Russell Aasland  --  1/20/2017
//  PURPOSE: Allows sitreps to modify pod spawn sizes
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class X2SitRepEffect_ModifyPodSize extends X2SitRepEffectTemplate
	native(Core);

var eTeam TeamToApplyTo;
var int MinPodSize;
var int MaxPodSize;
var int PodSizeDelta; // adds this number to the overall force level before clamping to the min and max

defaultproperties
{
	MinPodSize=1
	MaxPodSize=10000
	PodSizeDelta=0
	TeamToApplyTo=eTeam_Alien
}