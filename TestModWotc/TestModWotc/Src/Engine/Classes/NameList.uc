//---------------------------------------------------------------------------------------
//  FILE:    NameList.uc
//  AUTHOR:  Ryan McFall  --  3/3/2015
//  PURPOSE: Replaces enums in situations where a list of IDs or names needs to be 
//			 extended without modifying base game code or data. Provides mechanisms
//			 for enumerating names in the editor via drop down similar to enums. Derive
//			 from this class and add names in default properties. All methods should
//			 be static as the class default object is the data container.
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class NameList extends Object native;

var protected array<Name> NameList;

//Interface for users of name list to assign out names, validates that the requested name is in the list
native static final function name FetchName(const out name RequestedName);

//Hook for engine initialization to allow additional processing of the name list. Called on the class default object.
event OnEngineInit() {}

cpptext
{
public:
	void InitializeNameLists(); //Calls OnEngineInit on all NameList CDOs
}

defaultproperties
{
}
