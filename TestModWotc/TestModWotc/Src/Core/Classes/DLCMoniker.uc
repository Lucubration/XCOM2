


class DLCMoniker
	extends Object
	native;


var() int SteamContentId;			// appId to check for entitlements to load a package with this object in it
var() string sourceDirectory;		// directory this file must live in to be able to be loaded, with the exception of the package that holds them
									//	exceptions must be made for the non-Mod editor

cpptext
{

	virtual void PostLoad();		// will check and make sure you are in the correct directory, and have the entitlement
};
