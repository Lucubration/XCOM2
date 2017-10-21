//---------------------------------------------------------------------------------------
//  FILE:    XComVisGroupData.uc
//  AUTHOR:  Jeremy Shopf  --  01/18/2012
//  PURPOSE: Maintains data re: membership in groups of actors that behave as one with 
//				respect to visibility changes. Also maintains states of these groups.
//              In the editor, all group information is maintained by AVisGroupActor actors
//              but this class flattens all that data for run-time use. All AVisGroupActors
//              are cooked out
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------


class XComVisGroupData extends Object
	native(GameEngine);

// !!! Make sure the length of bStatesUpdatedThisFrame matches EVisibilityStateType
enum EVisibilityStateType{
	eCutout,
	eCutdown,
	eToggleHidden,
	eFloorHidden,
	ePeripheryHidden,
};

// All groups should be updated each frame so if it hasn't
// !!!! Make sure the length of bStatesUpdatedThisFrame matches EVisibilityStateType
var byte bStatesUpdatedThisFrame[5];

// Map an actor to the indices of the vis groups its an element of
var	const private native MultiMap_Mirror ActorToActorGroups{TMultiMap<class AActor*, TArray<INT> >};

// Array of vis group data
var	const private array<VisGroupEntry> VisActorGroups; 

var transient native bool bMouseIsActive;
var transient native float fCutoutBox_CutdownHeight;
var transient native float fCutoutBox_CutoutHeight;

cpptext
{
	// Return the vis group data singleton
	static UXComVisGroupData *Instance();

	virtual void Serialize(FArchive& Ar);

	virtual void PostLoad();

	// Flush all existing data
	void Flush();

	// Initialize all vis group information
	void InitializeGroups();

	// Add a group actor to the data
	void AddGroupActor( FVisGroupEntry& pNewActor );

	// All groups need to have their state reset so that we know if they were updated this
	//  frame
	void ResetGroups();

	// Set visibility state on the specified actor's groups. If no groups are present,
	//      the appropriate functions are called on pActor
	UBOOL SetVisibilityState( AActor* pActor, EVisibilityStateType Type, UBOOL bValue );

	// Set the cutout height on the specified actor's groups. Assumes that it is called directly
	//     before SetVisibilityState as it leverages the cutout state change tracking functionality
	//      to know if pActor has already been updated.
	void SetVisHeights( AActor* pActor, FLOAT fCutdownHeight, FLOAT fCutoutHeight );

	void SetActorHidden( AActor* pActor, UBOOL bHidden );
	void PostProcessHiddenGroups();

	// Dump all group actor information
	void Dump();
}

defaultproperties
{
}