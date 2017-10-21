/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class PostProcessChain extends Object
	native;

/** Post process effects active in this chain. Rendered in order */
var array<PostProcessEffect> Effects;

// FIRAXIS BEGIN jboswell
var transient array<byte> SavedEffectState;
// FIRAXIS END

/**
 * Returns the index of the named post process effect, None if not found.
 */
final function PostProcessEffect FindPostProcessEffect(name EffectName)
{
	local int Idx;
	for (Idx = 0; Idx < Effects.Length; Idx++)
	{
		if (Effects[Idx] != None && Effects[Idx].EffectName == EffectName)
		{
			return Effects[Idx];
		}
	}
	// not found
	return None;
}

// FIRAXIS BEGIN jboswell
final function SaveEffectState()
{
	local int Idx;
	SavedEffectState.Length = 0;
	SavedEffectState.Add(Effects.Length);
	for (Idx = 0; Idx < Effects.Length; Idx++)
	{
		if (Effects[Idx] != None)
		{
			SavedEffectState[Idx] = Effects[Idx].bShowInGame ? 1 : 0;
		}
	}
}

final function bool HasSavedEffectState()
{
	return SavedEffectState.Length == Effects.Length;
}

final function RestoreEffectState()
{
	local int Idx;
	// If this isn't true, then SaveEffectState() wasn't called, or modifications
	// were made to the chain after the state was saved. Either way, our data is
	// invalid and all will go wrong -- jboswell
	`assert(SavedEffectState.Length == Effects.Length); 

	for (Idx = 0; Idx < Effects.Length; Idx++)
	{
		if (Effects[Idx] != None)
		{
			Effects[Idx].bShowInGame = SavedEffectState[Idx] != 0;
		}
	}
	SavedEffectState.Length = 0;
}

final function DumpEffectState()
{
	local int Idx;

	for (Idx = 0; Idx < Effects.Length; ++Idx)
	{
		if (Effects[Idx] != none)
		{
			`log("DumpEffectState:" @ Effects[Idx].EffectName $ ":" @ (Effects[Idx].bShowInGame ? "Enabled" : "Disabled"));
		}
	}
}
// FIRAXIS END

