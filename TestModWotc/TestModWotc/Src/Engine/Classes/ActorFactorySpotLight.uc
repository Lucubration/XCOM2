//---------------------------------------------------------------------------------------
//  *********   FIRAXIS SOURCE CODE   ******************
//  FILE:    ActorFactorySpotLight.uc
//  AUTHOR:  Jeremy Shopf
//  PURPOSE: Actor factory for spot lights
//---------------------------------------------------------------------------------------
//  Copyright (c) 2010 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class ActorFactorySpotLight extends ActorFactory
	config(Editor)
	collapsecategories
	hidecategories(Object)
	native;

defaultproperties
{
	MenuName="Add Light (Spot)"
	NewActorClass=class'Engine.SpotLight'
}
