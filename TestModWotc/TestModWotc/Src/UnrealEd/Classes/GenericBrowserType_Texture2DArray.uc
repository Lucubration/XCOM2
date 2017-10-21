/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
//=============================================================================
// GenericBrowserType_Texture2DArray: Generic browser type for texture arrays
//=============================================================================

class GenericBrowserType_Texture2DArray
	extends GenericBrowserType_Texture
	native;

cpptext
{
	/** Initialize this generic browser type */
	virtual void Init();
}
	
defaultproperties
{
	Description="Texture2DArray"
}
