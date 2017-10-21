/**
* GenericBrowserType_DLCMoniker: DLCMoniker
*
* Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
*/

class GenericBrowserType_DLCMoniker
	extends GenericBrowserType
	native;

cpptext
{
#if !SDKBUILD
	virtual void Init();
#endif
}

defaultproperties
{
	Description = "DLCMoniker"
}
