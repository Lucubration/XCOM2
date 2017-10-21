/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class ParticleLightEmitter extends ParticleSpriteEmitter
	native(Particle)
	collapsecategories		
	hidecategories(Object)
	dependson(ParticleSpriteEmitter)
	editinlinenew;

cpptext
{
	virtual void SetToSensibleDefaults();
}
