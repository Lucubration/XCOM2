//=============================================================================
// NavigationPoint.
//
// NavigationPoints are organized into a network to provide AIControllers
// the capability of determining paths to arbitrary destinations in a level
//
// Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
//=============================================================================
class NavigationPoint extends Actor
	hidecategories(Lighting,LightColor,Force)
	ClassGroup(Navigation)
	native;

const	INFINITE_PATH_COST	=	10000000;

//------------------------------------------------------------------------------
// NavigationPoint variables

/** structure for inserting things into the navigation octree */
struct native NavigationOctreeObject
{
	/** the bounding box to use */
	var Box BoundingBox;
	/** cached center of that box */
	var vector BoxCenter;
	/** if this object is in the octree, pointer to the node it's in, otherwise NULL */
	var native transient const pointer OctreeNode{class FNavigationOctreeNode};
	/** UObject that owns the entry in the octree */
	var noexport const Object Owner;
	/** bitfield representing common classes of Owner so we can avoid casts */
	var noexport const byte OwnerType;

	structcpptext
	{
	 enum ENavOctreeObjectType
	 {
	 	NAV_NavigationPoint = 0x01,
	 	NAV_ReachSpec = 0x02,
	 };
	 private:
	 	UObject* Owner;
	 	BYTE OwnerType;
	 public:
	 	/** constructor, makes sure OctreeNode is NULL */
	 	FNavigationOctreeObject()
	 	: OctreeNode(NULL), Owner(NULL), OwnerType(0)
	 	{}
	 	/** destructor, removes us from the octree if we're still there */
	 	~FNavigationOctreeObject();
		/** sets the object's owner and initializes the OwnerType for fast cast to common types */
		void SetOwner(UObject* InOwner);

		/** sets the object's bounding box
		 * if the object is currently in the octree, re-adds it
		 * @param InBoundingBox the new bounding box to use
		 */
		void SetBox(const FBox& InBoundingBox);

		/** overlap check function called after the axis aligned bounding box check succeeds
		 * allows for more precise checks for certain object types
		 * @param TestBox the box to check
		 * @return true if the box doesn't overlap this object, false if it does
		 */
		UBOOL OverlapCheck(const FBox& TestBox);

		/** templated accessor to Owner, to avoid casting for common cases
		 * @note T must be UObject or a subclass, or this function will not compile
		 */
		template<class T> FORCEINLINE T* GetOwner()
		{
			return Cast<T>(Owner);
		}
		//@note the specializations for this template are in UnPath.h because they must be outside the struct definition

		void Serialize(FArchive& Ar);
	}
};
var native transient const NavigationOctreeObject NavOctreeObject;

/** List of volumes containing this navigation point relevant for gameplay */
var() const editconst  array<ActorReference>	Volumes;

var	CylinderComponent		CylinderComponent;

/** GUID used for linking paths across levels */
var() editconst const duplicatetransient guid NavGuid;

/** Normal editor sprite */
var const transient SpriteComponent GoodSprite;
/** Used to draw bad collision intersection in editor */
var const transient SpriteComponent BadSprite;

/** Does this nav point point to others in separate levels? */
var const bool bHasCrossLevelPaths;

/** Which navigation network does this navigation point connect to? */
var() editconst const int NetworkID;

/** whether we need to save this in checkpoints because it has been modified by Kismet */
var transient bool bShouldSaveForCheckpoint;

cpptext
{
	virtual void FindBase();
	virtual void PostScriptDestroyed();
protected:
 	virtual void UpdateComponentsInternal(UBOOL bCollisionUpdate = FALSE);
public:
	void PostEditMove(UBOOL bFinished);
	void Spawned();
	virtual UBOOL ShouldBeBased();

	/** Checks to make sure the navigation is at a valid point */
	virtual void Validate();

#if WITH_EDITOR
	virtual void CheckForErrors();

	virtual void OnAddToPrefab();

#endif

	virtual void SetVolumes(const TArray<class AVolume*>& Volumes);
	virtual void SetVolumes();

	/**
	 * Fills the array of any nav references needing to be fixed up.
	 */
	virtual void GetActorReferences(TArray<FActorReference*> &ActorRefs, UBOOL bIsRemovingLevel);
	virtual void ClearCrossLevelReferences();
	virtual FGuid* GetGuid() { return &NavGuid; }


	/**
	 * Works through the component arrays marking entries as pending kill so references to them
	 * will be NULL'ed.
	 *
	 * @param	bAllowComponentOverride		Whether to allow component to override marking the setting
	 */
	virtual void MarkComponentsAsPendingKill(UBOOL bAllowComponentOverride = FALSE);
}

native function GetBoundingCylinder(out float CollisionRadius, out float CollisionHeight) const;


/** @return Debug abbrev for hud printing */
simulated event string GetDebugAbbrev()
{
	return "NP?";
}

defaultproperties
{
	Begin Object Class=SpriteComponent Name=Sprite
		Sprite=Texture2D'EditorResources.S_NavP'
		HiddenGame=true
		HiddenEditor=false
		AlwaysLoadOnClient=False
		AlwaysLoadOnServer=False
		SpriteCategoryName="Navigation"
	End Object
	Components.Add(Sprite)
	GoodSprite=Sprite

	Begin Object Class=SpriteComponent Name=Sprite2
		Sprite=Texture2D'EditorResources.Bad'
		HiddenGame=true
		HiddenEditor=true
		AlwaysLoadOnClient=False
		AlwaysLoadOnServer=False
		SpriteCategoryName="Navigation"
		Scale=0.25
	End Object
	Components.Add(Sprite2)
	BadSprite=Sprite2

	Begin Object Class=ArrowComponent Name=Arrow
		ArrowColor=(R=150,G=200,B=255)
		ArrowSize=0.5
		bTreatAsASprite=True
		HiddenGame=true
		AlwaysLoadOnClient=False
		AlwaysLoadOnServer=False
		SpriteCategoryName="Navigation"
	End Object
	Components.Add(Arrow)

	Begin Object Class=CylinderComponent Name=CollisionCylinder LegacyClassName=NavigationPoint_NavigationPointCylinderComponent_Class
		CollisionRadius=+0050.000000
		CollisionHeight=+0050.000000
	End Object
	CollisionComponent=CollisionCylinder
	CylinderComponent=CollisionCylinder
	Components.Add(CollisionCylinder)

	bStatic=true
	bNoDelete=true

	bHidden=FALSE

	bCollideWhenPlacing=true

	bCollideActors=false

	// default to no network id
	NetworkID=-1
	// NavigationPoints are generally server side only so we don't need to worry about client simulation
	bForceAllowKismetModification=true
}
