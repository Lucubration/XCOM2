//---------------------------------------------------------------------------------------
//  *********   FIRAXIS SOURCE CODE   ******************
//  FILE:    X2DataTemplateConverter.uc
//  AUTHOR:  David Burchanowski
//
//  PURPOSE: Utility class to convert X2DataTemplate objects defined in script into editor objects
//
//---------------------------------------------------------------------------------------
//  Copyright (c) 2009-2016 Firaxis Games, Inc. All rights reserved.
//--------------------------------------------------------------------------------------- 

class X2DataTemplateConverter extends Object
	native(Core)
	config(GameCore);

cpptext
{
	UObject* DuplicateObjectProperty(UPackage* Package, UObject* Object, UObject* PropertyObject, UObjectProperty* ObjectProperty);
	void DuplicateProperties(UPackage* Package, UObject* InObject, UStructProperty* InnerStruct = nullptr, BYTE* InnerStructAddress = 0);

	void ConvertDataTemplates(UClass& TemplateClass, TArray<FString>& SavedPackageNames);
}

// only people with one of the following source control usernames will run the script updater
var private const config array<string> SourceControlUserWhiteList;

// package of objects that are shared by all objects (DefaultLivingShooterProperty, etc)
var private Object SharedObjectsPackage;

// keep track of which objects we have already cloned, so we don't dupe them more than once
var private native map_mirror ClonedObjects { TMap<FName, UObject*> }; 

// cached data templates to prevent us having to scan all objects in the scene repea
var private array<X2DataTemplate> AllTemplates;

// Intended to be called post load, automatically 
function native FindAndConvertNewDataTemplates();

