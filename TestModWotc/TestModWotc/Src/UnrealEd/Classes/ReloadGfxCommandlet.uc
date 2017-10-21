/**
 * Copyright 1998-2010 Epic Games, Inc. All Rights Reserved.
 */

class ReloadGfxCommandlet extends Commandlet
	native;

cpptext
{
	virtual INT Main(const FString& Params);
}

/**
 * A utility that imports and/or re-imports SWF assets
 *
 * @param Params the string containing the parameters for the commandlet
 */
event int Main(string Params);