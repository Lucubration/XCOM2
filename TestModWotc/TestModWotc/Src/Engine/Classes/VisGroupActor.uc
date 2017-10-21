//=============================================================================
// VisGroupActor
// Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
//=============================================================================
class VisGroupActor extends GroupActor
	native(GameEngine);


struct native VisGroupEntry
{
	var array<Actor> Actors;
	var array<int> ChildGroups;


	var bool bUpdatedThisFrame;
	var bool bCutout;
	var bool bCutdown;
	var bool bToggleHidden;
	var bool bFloorHidden;
	var bool bPeripheryHidden;
	var bool bAssociateWithNeighborGroups;
	var transient bool bUpdatedHiddenStateThisFrame;

	var transient array<float> HiddenState;
};


var() array<VisGroupActor> DependentOn;

/** Should this vis group add any neighbor vis groups that are oriented similarly as a child group. */
var() bool bAssociateWithNeighborGroups;

cpptext
{
	void FlattenVisGroupActorToEntry( FVisGroupEntry& OutEntry );
}

defaultproperties
{
	m_bNoDeleteOnClientInitializeActors=true
	bAssociateWithNeighborGroups=false
	bTickIsDisabled=true
}