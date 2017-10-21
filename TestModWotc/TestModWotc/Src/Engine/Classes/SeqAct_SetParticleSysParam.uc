/**
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */


class SeqAct_SetParticleSysParam extends SequenceAction;

var() editinline array<ParticleSystem.ParticleSysParam>	InstanceParameters; // FIRAXIS Change -sboeckmann

/** Should ScalarValue override any entries to InstanceParameters? */
var() bool bOverrideScalar;

/** Override scalar value */
var() float ScalarValue;

defaultproperties
{
	ObjName="Set Particle Param"
	ObjCategory="Particles"

	bOverrideScalar=TRUE

	VariableLinks(1)=(ExpectedType=class'SeqVar_Float',LinkDesc="Scalar Value",PropertyName=ScalarValue)
}
