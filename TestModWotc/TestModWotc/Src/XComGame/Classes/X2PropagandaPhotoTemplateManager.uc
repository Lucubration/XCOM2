//---------------------------------------------------------------------------------------
//  *********   FIRAXIS SOURCE CODE   ******************
//  FILE:    X2PropagandaPhotoTemplateManager.uc
//  AUTHOR:  Joe Cortese  --  10/25/2016
//---------------------------------------------------------------------------------------
//  Copyright (c) 2013 Firaxis Games Inc. All rights reserved.
//--------------------------------------------------------------------------------------- 

class X2PropagandaPhotoTemplateManager extends X2DataTemplateManager
    native(Core)
	config(Content);

var protected config array<X2PhotoboothInfo> PhotoboothTemplateConfig;
var private native Map_Mirror   PhotoboothInfoTemplateCache{ TMap<FName, TMap<FName, UX2PropagandaPhotoTemplate*> *> };

native static function X2PropagandaPhotoTemplateManager GetPropagandaPhotoTemplateManager();

native function bool AddUberTemplate(string PhotoboothType, X2PropagandaPhotoTemplate Template, bool ReplaceDuplicate = false);
native function X2PropagandaPhotoTemplate FindUberTemplate(string PhotoboothType, name PartName);
native function GetUberTemplates(string PhotoboothType, out array<X2PropagandaPhotoTemplate> Templates);
native function GetFilteredUberTemplates(string PhotoboothType, Object CallbackObject, delegate<X2BodyPartFilter.FilterCallback> CallbackFn, out array<X2PropagandaPhotoTemplate> Templates);
native function X2PropagandaPhotoTemplate GetRandomUberTemplate(string PhotoboothType, Object CallbackObject, delegate<X2BodyPartFilter.FilterCallback> CallbackFn);
native function array<name> GetPropagandaPackNames();

native function InitTemplates();

protected event InitTemplatesInternal()
{
	local int i;
	local X2PhotoboothInfo PhotoboothInfo;
	local X2PropagandaPhotoTemplate Template;

	//== General Parts
	for (i = 0; i < PhotoboothTemplateConfig.Length; ++i)
	{
		PhotoboothInfo = PhotoboothTemplateConfig[i];

		// This is the "new", proper way of instantiating a template (requires unique TemplateName)
		Template = new(None, string(PhotoboothInfo.TemplateName)) class'X2PropagandaPhotoTemplate';

		Template.NumSoldiers = PhotoboothInfo.NumSoldiers;

		Template.LayoutBlueprint = PhotoboothInfo.LayoutBlueprint;
		Template.LocationTags = PhotoboothInfo.LocationTags;
		Template.CameraFocus = PhotoboothInfo.CameraFocus;

		Template.AllowedClasses = PhotoboothInfo.AllowedClasses;
		Template.BlockedClasses = PhotoboothInfo.BlockedClasses;
		Template.DefaultPose = PhotoboothInfo.DefaultPose;

		Template.DisplayName = PhotoboothInfo.DisplayName;

		// Which content pack this part belongs to, either DLC or Mod
		Template.DLCName = PhotoboothInfo.DLCName;

		Template.SetTemplateName(PhotoboothInfo.TemplateName);
		AddUberTemplate("Formation", Template, true);
	}

}

cpptext
{
	TMap<FName, UX2PropagandaPhotoTemplate*> *GetPhotoboothMap(const TCHAR *PhotoboothType);

}