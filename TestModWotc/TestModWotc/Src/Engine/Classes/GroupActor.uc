//=============================================================================
// GroupActor: Collects a group of actors, allowing for management and universal transformation.
// Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
//=============================================================================

class GroupActor extends Actor
	native(GameEngine)
	placeable;

//Editor-only vars
var editoronly bool bLocked;
var editoronly bool bAllowEmptyGroup;
var editoronly array<GroupActor> SubGroups;
var editoronly Actor PivotActor; //The actor whose pivot point the group is using as the group pivot

//Was editor-only, but is now stored so that we can ensure that our associated actors are in the right location
var array<Actor> GroupActors;

//Values stored in the archetype for this group actor
struct native GroupActorDefinition
{
	var Object  ActorArchetype;
	var Matrix  LocalTransform;
	var float   DrawScale;
	var Vector  DrawScale3D;	
	var bool    bPivot;
};
var() editinline array<GroupActorDefinition> GroupActorDefinitions;

//Stored immediately prior to save - indicates whether GroupActorDefinitions differs from the archetype at the point this actor is saved in a map.
var() editconst bool bUpdateFromArchetype;

cpptext
{
	virtual void Spawned();
	virtual void PreSave();
	virtual void PostLoad();	
	virtual void PostEditChangeProperty(FPropertyChangedEvent& PropertyChangedEvent);
	virtual void PostScriptDestroyed();
	virtual void PostEditUndo();
	virtual UBOOL IsSelected() const;

	/**
	 * Archetype / group prefab support
	 */
	virtual UBOOL HasArchetype() const;	

	/**
	 * Apply given deltas to all actors and subgroups for this group.
	 * @param	Viewport		The viewport to draw to apply our deltas
	 * @param	InDrag			Delta Transition
	 * @param	InRot			Delta Rotation
	 * @param	InScale			Delta Scale
	 */
	void GroupApplyDelta(FViewportClient* Viewport, const FVector& InDrag, const FRotator& InRot, const FVector& InScale );

	/**
	 * Changes the given array to remove any existing subgroups
	 * @param	GroupArray	Array to remove subgroups from
	 */
	static void RemoveSubGroupsFromArray(TArray<AGroupActor*>& GroupArray);
	
	/**
	 * Returns the highest found root for the given actor or null if one is not found. Qualifications of root can be specified via optional parameters.
	 * @param	InActor			Actor to find a group root for.
	 * @param	bMustBeLocked	Flag designating to only return the topmost locked group.
	 * @param	bMustBeSelected	Flag designating to only return the topmost selected group.
	 * @return	The topmost group actor for this actor. Returns null if none exists using the given conditions.
	 */
	static AGroupActor* GetRootForActor(AActor* InActor, UBOOL bMustBeLocked=FALSE, UBOOL bMustBeSelected=FALSE);

	/**
	 * Returns the direct parent for the actor or null if one is not found.
	 * @param	InActor	Actor to find a group parent for.
	 * @return	The direct parent for the given actor. Returns null if no group has this actor as a child.
	 */
	static AGroupActor* GetParentForActor(AActor* InActor);


	/**
	 * Lock this group and all subgroups.
	 */
	void Lock();
	
	/**
	 * Unlock this group
	 */
	FORCEINLINE void Unlock()
	{
		bLocked = false;
	};
	
	/**
	 * @return	Group's locked state
	 */
	FORCEINLINE UBOOL IsLocked() const
	{
		return bLocked;
	};

	/**
	 * @param	InActor	Actor to add to this group
	 */
	void Add(AActor& InActor);
	
	/**
	 * Removes the given actor from this group. If the group has no actors after this transaction, the group itself is removed.
	 * @param	InActor	Actor to remove from this group
	 */
	void Remove(AActor& InActor);

	/**
	 * @param InActor	Actor to search for
	 * @return True if the group contains the given actor.
	 */
	UBOOL Contains(AActor& InActor) const;

	/**
	 * @param bDeepSearch	Flag to check all subgroups as well. Defaults to TRUE.
	 * @return True if the group contains any selected actors.
	 */
	UBOOL HasSelectedActors(UBOOL bDeepSearch=TRUE) const;

	/**
	 * Detaches all children (actors and subgroups) from this group and then removes it.
	 */
	void ClearAndRemove();

	/**
	 * Sets this group's location to the center point based on current location of its children.
	 */
	void CenterGroupLocation();
	
	/**
	 * @param	OutGroupActors	Array to fill with all actors for this group.
	 * @param	bRecurse		Flag to recurse and gather any actors in this group's subgroups.
	 */
	void GetGroupActors(TArray<AActor*>& OutGroupActors, UBOOL bRecurse=FALSE) const;

	/**
	 * @param	OutSubGroups	Array to fill with all subgroups for this group.
	 * @param	bRecurse	Flag to recurse and gather any subgroups in this group's subgroups.
	 */
	void GetSubGroups(TArray<AGroupActor*>& OutSubGroups, UBOOL bRecurse=FALSE) const;

	/**
	 * @param	OutChildren	Array to fill with all children for this group.
	 * @param	bRecurse	Flag to recurse and gather any children in this group's subgroups.
	 */
	void GetAllChildren(TArray<AActor*>& OutChildren, UBOOL bRecurse=FALSE) const;

	friend class AVisGroupActor;
}

defaultproperties
{
	bLocked = true;
	bAllowEmptyGroup = false;
	bTickIsDisabled = true;
}
