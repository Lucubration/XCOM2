/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class MeshComponent extends PrimitiveComponent
	native(Mesh)
	noexport
	abstract;

enum EMatPriority
{
	eMatPriority_Original,	
	eMatPriority_LootSparkles,
	eMatPriority_Objective,
	eMatPriority_AnimNotify,
	eMatPriority_ScanningProtocol,
	eMatPriority_TargetDefinition,
	eMatPriority_AOEDamage,
};

/** Per-Component material overrides.  These must NOT be set directly or a race condition can occur between GC and the rendering thread. */
var(Rendering) const array<MaterialInterface>	Materials;

struct MaterialDelayedReference
{
	var MaterialInterface	Mat;
	var int					FrameNumber;
};

/** This is a container array for use specifically in the editor. Holds references to materials pushed out by other materials. */
var const transient array<MaterialDelayedReference>	m_aDelayedMaterialReference;

// FIRAXIS BEGIN
var(Rendering) const array<MaterialInterface>   AuxMaterials;

struct PrioritizedMat
{
	var MaterialInterface Mat;
	var byte Priority;
};

struct PrioritizedMatList
{
	var array<PrioritizedMat> List;
};

var native transient array<PrioritizedMatList> m_aPriorityMaterials;
// FIRAXIS END

/**
 * @param ElementIndex - The element to access the material of.
 * @return the material used by the indexed element of this mesh.
 */
native function MaterialInterface GetMaterial(int ElementIndex);


// FIRAXIS BEGIN
/**
 * @param ElementIndex - The element to access the material of.
 * @param LOD Lod level to query from
 * @return the material used by the indexed element of this mesh.
 */
//native function MaterialInterface GetMaterial(int ElementIndex, int LOD );
// FIRAXIS END

// FIRAXIS BEGIN
native function MaterialInterface GetAuxMaterial(int ElementIndex);
native function SetAuxMaterial(int ElementIndex, MaterialInterface AuxMaterial);
// FIRAXIS END

/**
 * Changes the material applied to an element of the mesh.
 * @param ElementIndex - The element to access the material of.
 * @return the material used by the indexed element of this mesh.
 */
native virtual function SetMaterial(int ElementIndex, MaterialInterface Material);

native virtual function PushMaterial(int ElementIndex, MaterialInterface Material, EMatPriority Priority);
native virtual function PopMaterial(int ElementIndex, EMatPriority Priority);

/** @return The total number of elements in the mesh. */
native function int GetNumElements();

/**
 *	Tell the streaming system to start loading all textures with all mip-levels.
 *	@param Seconds							Number of seconds to force all mip-levels to be resident
 *	@param bPrioritizeCharacterTextures		Whether character textures should be prioritized for a while by the streaming system
 *	@param CinematicTextureGroups			Bitfield indicating which texture groups that use extra high-resolution mips
 */
native final function PrestreamTextures( float Seconds, bool bPrioritizeCharacterTextures, optional int CinematicTextureGroups = 0 );

/**
 * Creates a material instance for the specified element index.  The parent of the instance is set to the material being replaced.
 * @param ElementIndex - The index of the skin to replace the material for.
 */
function MaterialInstanceConstant CreateAndSetMaterialInstanceConstant(int ElementIndex)
{
	local MaterialInstanceConstant Instance;

	// Create the material instance.
	Instance = new(self) class'MaterialInstanceConstant';
	Instance.SetParent(GetMaterial(ElementIndex));

	// Assign it to the given mesh element.
	// This MUST be done after setting the parent; otherwise the component will use the default material in place of the invalid material instance.
	SetMaterial(ElementIndex,Instance);

	return Instance;
}

/**
* Creates a material instance for the specified element index.  The parent of the instance is set to the material being replaced.
* @param ElementIndex - The index of the skin to replace the material for.
*/
function MaterialInstanceTimeVarying CreateAndSetMaterialInstanceTimeVarying(int ElementIndex)
{
	local MaterialInstanceTimeVarying Instance;

	// Create the material instance.
	Instance = new(self) class'MaterialInstanceTimeVarying';
	Instance.SetParent(GetMaterial(ElementIndex));

	// Assign it to the given mesh element.
	SetMaterial(ElementIndex,Instance);

	return Instance;
}


defaultproperties
{
	CastShadow=TRUE
	bAcceptsLights=TRUE
	bUseAsOccluder=TRUE
}
