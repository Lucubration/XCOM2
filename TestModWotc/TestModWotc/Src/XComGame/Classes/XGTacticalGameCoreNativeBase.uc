//-----------------------------------------------------------
//
//-----------------------------------------------------------
class XGTacticalGameCoreNativeBase extends Actor
	dependson (XGTacticalGameCoreData)
	native(Core)
	config(GameCore)
	abstract;

// Gameplay values
const SCREEN_PC_BUFFER = 0.25f;           //  percent of screen space to consider as "off screen" for PC input purposes
const GRENADE_TOUCH_RADIUS = 46.0f;

// Close Combat Values
const CC_RANGE = 3.0f;                  // The radius, in meters, at which close combat is triggered

// UI Values
const HP_PER_TICK = 1;                  // How may HP are represented by an individual block displayed by the UI
const HP_PULSE_PCT = 25;                // If the HP are at or below this percentage, then we will pulse the controller.

// Jetpack
const JETPACK_FUEL_HOVER_COST = 1;

// MHU - Slow motion parameters. 
const TIMEDILATION_APPROACHRATE = 15.0f;  // MHU - Linear approach rate (how fast) to reach the desired time dilation values specified below.

const TIMEDILATION_MODE_NORMAL = 1.0f;
const TIMEDILATION_MODE_VICTIMOFOVERWATCH = 0.01f;
const TIMEDILATION_MODE_REACTIONFIRING = 0.4f;
// MHU - DO NOT CHANGE THE BELOW VALUE. We don't trigger reaction fire when pod activations are playing (too many things fighting for camera control)
const TIMEDILATION_MODE_TRIGGEREDPODACTIVATION = 0.0f; 

const NATIVE_RADTODEG = 57.295779513082321600f;
const NATIVE_DEGTORAD = 0.017453292519943296f;
const FLANKINGTOLERANCE = 3.0f; //Degrees - gives the flank check some wiggle room in case the target or the shooter are not centered in their tiles

const MAX_FORCE_LEVEL_UI_VAL = 20;
// jboswell: these are here because they need to be native
enum EGender
{
	eGender_None,
	eGender_Male,
	eGender_Female
};

enum ECharacterRace
{
	eRace_Caucasian,
	eRace_African,
	eRace_Asian,
	eRace_Hispanic,
};

enum ECivilianType
{
	eCivilian_Warm,
	eCivilian_Cold,
	eCivilian_Formal,
	eCivilian_Soldier,
};

//World Data Structures
//==========================================================================================

enum ECoverDir
{
	eCD_North,
	eCD_South,
	eCD_East,
	eCD_West,
};

enum ETraversalType
{
	eTraversal_None,
	eTraversal_Normal,
	eTraversal_ClimbOver,
	eTraversal_ClimbOnto,
	eTraversal_ClimbLadder,
	eTraversal_DropDown,
	eTraversal_Grapple,
	eTraversal_Landing,
	eTraversal_BreakWindow,
	eTraversal_KickDoor,
	eTraversal_WallClimb, //Chryssalid invisible ladder - Keep wall climb before JumpUp because chrysallid can do both, and this makes him use wall climbs rather than Jump up where possible.
	eTraversal_JumpUp, //Thin man multi-story leap ( reverse drop down )
	eTraversal_Ramp, //The traversal type entering or leaving a ramp
	eTraversal_BreakWall, // This is not strictly a traversal type, but instructs the pathing system that the unit can pass through walls like large units can (and apply damage to the environment)
	eTraversal_Phasing, // This is not strictly a traversal type, but instructs the pathing system that the unit can pass through walls like large units can
	
	// the next three flying traversals are not baked into the level data, they are generated at pathing time
	// and exist as means to describe these traversals to the 
	eTraversal_Launch, // transitioning from running to flying
	eTraversal_Flying, // in flight
	eTraversal_Land, // transitioning from flying to landing
	eTraversal_Teleport,
	eTraversal_Unreachable,
};

enum EPathType
{
	ePathType_Normal,
	ePathType_PathObject,
	ePathType_Dropdown
};

struct native XComCoverPoint
{
	var int X;
	var int Y;
	var int Z;

	var Vector TileLocation;
	var Vector ShieldLocation;
	var Vector CoverLocation;
	var int Flags;

	structcpptext
	{
		FXComCoverPoint()
			: X(0), Y(0), Z(0)
			, TileLocation(0.0f, 0.0f, 0.0f)
			, ShieldLocation(0.0f, 0.0f, 0.0f)
			, CoverLocation(0.0f, 0.0f, 0.0f)
			, Flags(0)
		{
		}

		explicit FXComCoverPoint(INT ThankYouEpic)
			: X(0), Y(0), Z(0)
			, TileLocation(0.0f, 0.0f, 0.0f)
			, ShieldLocation(0.0f, 0.0f, 0.0f)
			, CoverLocation(0.0f, 0.0f, 0.0f)
			, Flags(0)
		{
		}

		FORCEINLINE void SetIndices(INT InX, INT InY, INT InZ)
		{
			X = InX;
			Y = InY;
			Z = InZ;
		}

		UBOOL operator==(const FXComCoverPoint &Other) const
		{
			return X == Other.X && Y == Other.Y && Z == Other.Z;
		}

		UBOOL operator!=(const FXComCoverPoint &Other) const
		{  
			return !(*this == Other);
		}

		friend inline DWORD GetTypeHash(const FXComCoverPoint &Cover)
		{
			return Cover.X*1024+Cover.Y*128+Cover.Z;
		}
	}
};

struct native ViewerInfo
{
	var int TileX;
	var int TileY;
	var int TileZ;
	var float SightRadius;
	var int SightRadiusRaw;
	var int SightRadiusTiles;
	var int SightRadiusTilesSq;
	var Actor AssociatedActor;
	var Vector PositionOffset;
	var bool bNeedsTextureUpdate;
	var bool bHasSeenXCom; //RAM - a flag for aliens to store whether an XCom unit has ever been within their sight radius

	var bool bShouldFrameUpdate;
	var int ShouldUpdateRefCount;

	structcpptext
	{
	FViewerInfo() :
	AssociatedActor(NULL), ShouldUpdateRefCount(0), bShouldFrameUpdate(FALSE)
	{
	}

	FViewerInfo(EEventParm)
	{
		appMemzero(this, sizeof(FViewerInfo));
	}
	}
};

struct native PathingTraversalData
{
	var TTile Tile;
	var float AStarG_Modifier;		
	var bool bLargeUnitOnly;
	var bool bPhasingUnitOnly;

	//Cached information relating to path object traversals ( climb onto, drop down, etc. )
	var Actor PathObject;
	var init array<ETraversalType>  TraversalTypes;
	var init array<Vector>          Positions;

	structcpptext
	{
		FPathingTraversalData()
			: PathObject(NULL)
			, Tile(0, 0, 0)
			, AStarG_Modifier(0.0f)
			, bLargeUnitOnly(false)
			, bPhasingUnitOnly(false)
		{
		}
	}
};

struct native FloorTileData
{
	var Vector FloorLocation;
	var Vector FloorNormal;	
	var Vector AltFloorNormal;
	var Actor  FloorActor;	
	var init array<PathingTraversalData> Neighbors;
	var byte RampDirection; //Uses flag setup of TileDataBlocksPathingXXX
	var byte SupportedUnitSize;

	structcpptext //RAM - the bizarre formatting is necessary for it to be properly formatted in the H
	{

	FFloorTileData() :
		FloorLocation( 0, 0, 0 ),
		FloorNormal( 0, 0, 0 ),
		AltFloorNormal(0, 0, 0),
		FloorActor(NULL),
		RampDirection(0),
		SupportedUnitSize(0)
	{		
	}

	}
};

struct native FlightTraversalNeighbor
{
	var TTile NeighborTile;
	var Actor BlockingActor;

	structcpptext
	{
		FFlightTraversalNeighbor() : BlockingActor(0)
		{		
		}
	}
};

// note that unlike floor traversal data, flight tile data is not exhaustive. If there is no
// entry in the matrix for an air tile, it does not mean that flight is invalid. It means it is valid
// and unrestricted.
struct native FlightTileData
{
	var array<FlightTraversalNeighbor> Neighbors;

	structcpptext
	{
		FFlightTileData()
		{		
			memset(this, 0, sizeof(FFlightTileData));
		}
	}
};

struct native VolumeEffectTileData
{
	/**This is the X2Effect associated with creating this tile data*/
	var name EffectName;

	/**This X2Effect is applied each turn*/
	var name TurnUpdateEffectName;

	var int SourceStateObjectID;      //  if effect was applied by an ability from a unit, this is that unit
	var int ItemStateObjectID;        //  the weapon associated with the ability that created the effect, if any

	/**This tracks how many turns this effect has remaining. This is not an absolute value, it depends on how the effect is updated*/
	var int NumTurns;
	/**If > 0, will cause this effect to spread from this tile out to a tile radius of NumHops*/
	var int NumHops;
	/**The template to use for the fire particles*/
	var ParticleSystem VolumeEffectParticleTemplate;
	/**Tracks the fire effect for this tile*/
	var ParticleSystemComponent VolumeEffectParticles;
	/**Controls for the particle effect*/
	var int Intensity;
	/**ADVANCED USE: If non-zero, specifies that in addition to updating the game play tile data in world data this effect also modifies the dynamic flags for the tile. This
	 *               permits the effect status to modify voxel ray trace results. This is a flag, so it must be a power of 2*/
	var int DynamicFlagUpdateValue;

	var bool LDEffectTile; // This tile data was placed by an LD and should follow slightly different rules than normal.
	// turns don't decrement as normal, only spread when in view of the player

	var init array<TTile> ParticleSystemCoveredTiles;	// all the tiles that this effect data is covering.
	var TTile CoveringTile;								// the tile that has the particle effect covering this tile

	structcpptext
	{
		FVolumeEffectTileData() :
		EffectName(NAME_None),
		TurnUpdateEffectName(NAME_None),
		NumTurns(0),
		NumHops(0),
		VolumeEffectParticleTemplate(NULL),
		VolumeEffectParticles(NULL),
		Intensity(0),
		DynamicFlagUpdateValue(0),
		SourceStateObjectID(0),
		ItemStateObjectID(0),
		LDEffectTile(false),
		ParticleSystemCoveredTiles(0),
		CoveringTile( -1, -1, -1 )
		{
		}
		FVolumeEffectTileData( EEventParm )
		{
			appMemzero( this, sizeof(FVolumeEffectTileData) );
		}
	}
};

struct native CoverTileData
{
	var Vector ShieldLocation;
	var Vector CoverLocation;

	structcpptext
	{

	FCoverTileData( ) : 
		CoverLocation(0, 0, 0), ShieldLocation(0, 0, 0)
	{
	}

	}
};

struct native XComInteractPoint
{
	var Vector Location;
	var Rotator Rotation;
	var XComInteractiveLevelActor InteractiveActor;
	var name InteractSocketName;
	var int ModifyTileStaticFlags; //TileStatic flags that should be set / unset based on interactions

	structcpptext
	{
		FXComInteractPoint() :
			Location(0,0,0),
			Rotation(0,0,0),
			InteractiveActor(NULL),
			InteractSocketName(NAME_None)
		{
		}

		UBOOL operator==(const FXComInteractPoint &Other)
		{
			return (Location == Other.Location && 
				Rotation == Other.Rotation && 
				InteractiveActor == Other.InteractiveActor && 
				InteractSocketName == Other.InteractSocketName &&
				ModifyTileStaticFlags == Other.ModifyTileStaticFlags);
		}
	}
};

struct native PeekAroundInfo
{
	var int     bHasPeekaround;
	var int		bRequiresLean;	//Set to 1 if this peek around does not allow for full step out animation. The character will lean instead.
	var vector  PeekaroundLocation;
	var vector	DistanceCheckLocation;	//Cached value representing a point near the top of the tile that can be used in distance comparisons against the 'default' tile
	var vector  PeekaroundDirectionFromCoverPt;
	var TTile   PeekTile;

	structcpptext
	{
	FPeekAroundInfo()
	{
		appMemzero(this, sizeof(FPeekAroundInfo));
	}
	FPeekAroundInfo(EEventParm)
	{
		appMemzero(this, sizeof(FPeekAroundInfo));
	}
	FORCEINLINE UBOOL operator==(const FPeekAroundInfo &Other) const
	{
		return (bHasPeekaround == Other.bHasPeekaround) && 
			   PeekaroundLocation == Other.PeekaroundLocation &&
			   PeekaroundDirectionFromCoverPt == Other.PeekaroundDirectionFromCoverPt &&
			   PeekTile == Other.PeekTile;		
	}
	}
};

struct native CoverDirectionPeekData
{
	var PeekAroundInfo LeftPeek;
	var PeekAroundInfo RightPeek;
	var vector  CoverDirection;
	var int     bHasCover;

	structcpptext
	{
	FCoverDirectionPeekData()
	{
		appMemzero(this, sizeof(FCoverDirectionPeekData));
	}
	FCoverDirectionPeekData(EEventParm)
	{
		appMemzero(this, sizeof(FCoverDirectionPeekData));
	}
	FORCEINLINE UBOOL operator==(const FCoverDirectionPeekData &Other) const
	{
		return (LeftPeek == Other.LeftPeek) && 
			   RightPeek == Other.RightPeek &&
			   CoverDirection == Other.CoverDirection &&
			   bHasCover == Other.bHasCover;
	}
	}
};

struct native CachedCoverAndPeekData
{
	var CoverDirectionPeekData CoverDirectionInfo[4];
	var vector  DefaultVisibilityCheckLocation;	
	var TTile   DefaultVisibilityCheckTile;
	var int     bDefaultTileValid;	

	structcpptext
	{
	FCachedCoverAndPeekData()
	{
		appMemzero(this, sizeof(FCachedCoverAndPeekData));
	}
	FCachedCoverAndPeekData(EEventParm)
	{
		appMemzero(this, sizeof(FCachedCoverAndPeekData));
	}
	FORCEINLINE UBOOL operator==(const FCachedCoverAndPeekData &Other) const
	{
		return (CoverDirectionInfo[0] == Other.CoverDirectionInfo[0]) && 
			   (CoverDirectionInfo[1] == Other.CoverDirectionInfo[1]) && 
			   (CoverDirectionInfo[2] == Other.CoverDirectionInfo[2]) && 
			   (CoverDirectionInfo[3] == Other.CoverDirectionInfo[3]) && 
			   DefaultVisibilityCheckLocation == Other.DefaultVisibilityCheckLocation &&
			   DefaultVisibilityCheckTile == Other.DefaultVisibilityCheckTile &&
			   bDefaultTileValid == Other.bDefaultTileValid;
	}
	}
};

const TINVENTORY_MAX_LARGE_ITEMS = 16;
const TINVENTORY_MAX_SMALL_ITEMS = 16;
const TINVENTORY_MAX_CUSTOM_ITEMS = 16;

const RELATIVE_HEIGHT_BONUS_ZDIFF = 192.0f;
const RELATIVE_HEIGHT_BONUS_WEAPON_RANGE = 1.5f;

struct native TInventory
{
	/***************************************************************************
	 * WARNING!!!
	 * if this struct grows beyond 256 bytes you need to replicate each piece
	 * seperately in whatever instanced object it is attached to.
	 * see XGCharacter::ReplicatedTCharacter_XXX for the pattern.
	 ***************************************************************************/
	var int iArmor<BoundEnum=EItemType>;                 				// EItemType
	var int iPistol<BoundEnum=EItemType>;                				// The pistol slot (A pistol is required)
	var const   int arrLargeItems[TINVENTORY_MAX_LARGE_ITEMS];
	var const   int iNumLargeItems;
	var const   int arrSmallItems[TINVENTORY_MAX_SMALL_ITEMS]; 	    // Any small items this unit is carrying 
	var const   int iNumSmallItems;
	var const   int arrCustomItems[TINVENTORY_MAX_CUSTOM_ITEMS];    // This array holds custom items (psionics/plague/etc)
	var const   int iNumCustomItems;
	/***************************************************************************
	 * WARNING!!!
	 * if this struct grows beyond 256 bytes you need to replicate each piece
	 * seperately in whatever instanced object it is attached to.
	 * see XGCharacter::ReplicatedTCharacter_XXX for the pattern.
	 ***************************************************************************/
};

struct native TCharacter
{
	/***************************************************************************
	 * WARNING!!!
	 * if you change/add ANY data members of the struct then you MUST change/add
	 * the corresponing XGCharacter::ReplicatedTCharacter_XXX variable -tsmith
	 ***************************************************************************/
	var string      strName<FGDEIndex=0>;
	var name        TemplateName;              // CharacterTemplate Name
	var TInventory  kInventory;
	var int         aTraversals[ETraversalType.EnumCount]<FGDEIgnore=true>;
	var bool        bHasPsiGift;
	var class<XGAIBehavior> BehaviorClass<FGDEIgnore=true>;
	/***************************************************************************
	 * WARNING!!!
	 * if you change/add ANY data members of the struct then you MUST change/add
	 * the corresponing XGCharacter::ReplicatedTCharacter_XXX variable -tsmith
	 ***************************************************************************/
};

struct native TAppearance
{
	/***************************************************************************
	 * WARNING!!!
	 * if this struct grows beyond 256 bytes you need to replicate each piece
	 * seperately in whatever instanced object it is attached to.
	 * see XGCharacter::ReplicatedTCharacter_XXX for the pattern.
	 ***************************************************************************/
	var name nmHead; // Head content to use ( morphs + additive anim )	
	var int iGender; // EGender
	var int iRace; // ECharacterRace
	var name nmHaircut;
	var int iHairColor; // jboswell: Pixel in the color palette texture (0, iHairColor)
	var int iFacialHair; // jboswell: Index into MIC for face/skin material
	var name nmBeard;		
	var int iSkinColor; // jboswell: which color from the skin color palette, if needed
	var int iEyeColor; // jboswell: which color from the eye color palette, if needed
	var name nmFlag; // jboswell: name of Country Template, copied from TSoldier during creation	
	var int iVoice; // mdomowicz 2015_05_26 : no longer used, but kept to avoid serialization changes in CharacterPoolManager.cpp, for now.
	var int iAttitude; // ECharacterAttitude
	var int iArmorDeco; // EArmorKit
	var int iArmorTint;
	var int iArmorTintSecondary;
	var int iWeaponTint;	
	var int iTattooTint;
	var name nmWeaponPattern;
	var name nmPawn; //Specifies the base pawn to use ( for humans, this is set from gender )
	var name nmTorso;
	var name nmArms;
	var name nmLegs;
	var name nmHelmet;
	var name nmEye;
	var name nmTeeth;
	var name nmFacePropLower;
	var name nmFacePropUpper;
	var name nmPatterns;
	var name nmVoice;
	var name nmLanguage;
	var name nmTattoo_LeftArm;
	var name nmTattoo_RightArm;
	var name nmScars;
	var name nmTorso_Underlay;
	var name nmArms_Underlay;
	var name nmLegs_Underlay;
	var name nmFacePaint;

	//Added to support armors that allow left arm / right arm customization
	var name nmLeftArm;		
	var name nmRightArm;	
	var name nmLeftArmDeco;	
	var name nmRightArmDeco;

	//Added to support Xpack faction hero armor deco
	var name nmLeftForearm;
	var name nmRightForearm;
	var name nmThighs;
	var name nmShins;
	var name nmTorsoDeco;
	var bool bGhostPawn;
};

struct native ExtensibleAppearanceElement
{
	var name PartType;
	var name Selection;
};

struct native TWeaponAppearance
{
	/***************************************************************************
	 * WARNING!!!
	 * if this struct grows beyond 256 bytes you need to replicate each piece
	 * seperately in whatever instanced object it is attached to.
	 * see XGCharacter::ReplicatedTCharacter_XXX for the pattern.
	 ***************************************************************************/
	var int iWeaponTint;
	var int iWeaponDeco;
	var name nmWeaponPattern;

	structdefaultproperties
	{
		iWeaponTint=INDEX_NONE
		iWeaponDeco=INDEX_NONE
	}
};

struct native TSoldier
{
	/***************************************************************************
	 * WARNING!!!
	 * if you change/add ANY data members of the struct then you MUST change/add
	 * the corresponing XGCharacter::ReplicatedTCharacter_XXX variable -tsmith
	 ***************************************************************************/
	var int             iID;
	var string      	strFirstName;
	var string      	strLastName;
	var string      	strNickName;
	var int         	iRank;
	var int             iPsiRank;
	var name         	nmCountry;
	var int             iXP;
	var int             iPsiXP;
	var TAppearance     kAppearance;
	/***************************************************************************
	 * WARNING!!!
	 * if you change/add ANY data members of the struct then you MUST change/add
	 * the corresponing XGCharacter::ReplicatedTCharacter_XXX variable -tsmith
	 ***************************************************************************/
};

struct native TVolume
{
	/***************************************************************************
	 * WARNING!!!
	 * if this struct grows beyond 256 bytes you need to replicate each piece
	 * seperately in whatever instanced object it is attached to.
	 * see XGCharacter::ReplicatedTCharacter_XXX for the pattern.
	 ***************************************************************************/
	var EVolumeType     eType;        // The type of volume
	var int             iDuration;    // The duration, if any, of this volume.
	var float           fRadius;      // The radius of this volume
	var float           fHeight;      // The height of this volume
	var Color           clrVolume;    // What is the color of this volume?
	var int             aEffects[EVolumeEffect.EnumCount];    // The effects applied to any unit who enters this volume
	/***************************************************************************
	 * WARNING!!!
	 * if this struct grows beyond 256 bytes you need to replicate each piece
	 * seperately in whatever instanced object it is attached to.
	 * see XGCharacter::ReplicatedTCharacter_XXX for the pattern.
	 ***************************************************************************/
};

var localized string m_strYearSuffix;
var localized string m_strMonthSuffix;
var localized string m_strDaySuffix;

var config int AI_REINFORCEMENTS_DEFAULT_ARRIVAL_TIME;

// SOLDIER VALUES
var config int NUM_STARTING_SOLDIERS;
var config int LOW_AIM;
var config int HIGH_AIM;
var config int LOW_MOBILITY;
var config int HIGH_MOBILITY;
var config int LOW_WILL;
var config int HIGH_WILL;

var config array<int> REINFORCEMENTS_COOLDOWN;

var config float RADIAL_DAMAGE_GLASS_BREAK_DISTANCE; //In tiles

cpptext
{
	virtual void PostReloadConfig(UProperty *Property);
}

simulated event Init();

//Needs to be accessed potentially in native code
native simulated function bool IsOptionEnabled( int eOption );

/**
 * Functions to modify TInventory's static arrays as if they were dynamic arrays.
 * 
 * XXXAdd: equivalent to dynamicarray.Add
 * 
 * XXXRemove: equivalent to dynamicarray.Remove
 * 
 * XXXAddItem: equivalent to dynamicarray.AddItem
 * 
 * XXXRemoveItem: equivalent to dynamicyarray.RemoveItem 
 * 
 * XXXSetItem: equivalent to dynamic array [] operator. i.e. passing in an index > num elements
 * will increase the number of elements in the array to fit. the only works if index is < the
 * static size of the array.
 * 
 * XXXClear: equivalent to dynamicarray.Length = 0. it clears the arrays elements and sets # of elements to zero.
 */
native static final function int    TInventoryLargeItemsAdd(out TInventory kInventory, int iCount);
native static final function int    TInventoryLargeItemsRemove(out TInventory kInventory, int idx, int iCount);
native static final function int    TInventoryLargeItemsAddItem(out TInventory kInventory, int iItem);
native static final function int    TInventoryLargeItemsRemoveItem(out TInventory kInventory, int iItem);
native static final function int    TInventoryLargeItemsSetItem(out TInventory kInventory, int idx, int iItem);
native static final function        TInventoryLargeItemsClear(out TInventory kInventory);

native static final function int    TInventorySmallItemsAdd(out TInventory kInventory, int iCount);
native static final function int    TInventorySmallItemsRemove(out TInventory kInventory, int idx, int iCount);
native static final function int    TInventorySmallItemsAddItem(out TInventory kInventory, int iItem);
native static final function int    TInventorySmallItemsRemoveItem(out TInventory kInventory, int iItem);
native static final function int    TInventorySmallItemsSetItem(out TInventory kInventory, int idx, int iItem);
native static final function        TInventorySmallItemsClear(out TInventory kInventory);

native static final function int    TInventoryCustomItemsAdd(out TInventory kInventory, int iCount);
native static final function int    TInventoryCustomItemsRemove(out TInventory kInventory, int idx, int iCount);
native static final function int    TInventoryCustomItemsAddItem(out TInventory kInventory, int iItem);
native static final function int    TInventoryCustomItemsRemoveItem(out TInventory kInventory, int iItem);
native static final function int    TInventoryCustomItemsSetItem(out TInventory kInventory, int idx, int iItem);
native static final function        TInventoryCustomItemsClear(out TInventory kInventory);
native static final function int    TInventoryCustomItemsFind(out TInventory kInventory, int iItem);

native static final function bool   TInventoryHasItemType(const out TInventory kInventory, int iItem);

native static final function class<XGAIBehavior> LookupBehaviorClass(string BehaviorName);

static final function EGender RandomGender()
{
	return EGender(1+rand(2));
}

//---PROXIMITY WEAPONS--------------------------------------------------
// the CLOSE_RANGE here refers to meters, not unreal units; this means that the closeness penalty for sniper rifles kicks in 
// when target is closer than about 8.6 cursor-steps (tiles), and the distance penalty for other weapons kicks in 
// beyond that distance
//--------------------------------------------------------------------
native simulated function int CalcRangeModForWeapon(int iWeapon, XGUnit kViewer, XGUnit kTarget);
native simulated function int CalcRangeModForWeaponAt(int iWeapon, XGUnit kViewer, XGUnit kTarget, vector vViewerLoc);

native simulated function Vector GetRocketLauncherFirePos( XComUnitPawnNativeBase kPawn, Vector TargetLocation, bool bRocketShot );

//native simulated function int CalcAimingAngleMod( XGUnitNativeBase FiringUnit, XGUnitNativeBase TargetUnit );

defaultproperties
{

}	
