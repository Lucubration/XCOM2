/**
 * FracturedBaseComponent.uc - Declaration of the base fractured component which handles rendering with a dynamic index buffer.
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class FracturedBaseComponent extends StaticMeshComponent
	native(Mesh)
	abstract;

// FIRAXIS BEGIN
/** Forces the use of an Override vertex color buffer */
var() bool bUseVertexColorDestruction;
var() bool bPreventChunkRemoval;
var() float fVertexColorGradientDistance;
// FIRAXIS END

/** This component's index buffer, used for rendering when bUseDynamicIndexBuffer is true. */
var protected{protected} const native transient pointer ComponentBaseResources{class FFracturedBaseResources};

/** A fence used to track when the rendering thread has released the component's resources. */
var protected{protected} native const transient RenderCommandFence_Mirror ReleaseResourcesFence{FRenderCommandFence};

/** Stores non-zero for each fragment that is visible, and 0 otherwise. */
var protected{protected} transient const init array<int> VisibleFragments;  // Firaxis change
var protected{protected} transient const init array<int> PendingVisibleFragments;  // Firaxis change

// Firaxis BEGIN
// RAM - support for the destruction painting tool
/** Keeps track of fragment visibility painted by the DestructionPaint tool */
var array<int> EditorPaintedVisibleFragments;
var array<Box> DestroyedChunks;
var bool bCollideAgainstPendingFragments;
// Firaxis END

/** If true, VisibleFragments has changed since the last attach and the dynamic index buffer needs to be updated. */
var protected{protected} transient bool	bVisibilityHasChanged;

/** True if VisibleFragments was reset to bInitialVisibilityValue since the last component attach. */
var protected{protected} transient const bool bVisibilityReset;

/** Initial visibility value for this component. */
var protected{protected} const bool bInitialVisibilityValue;

/** 
 *	If true, each element will be rendered with one draw call by using a dynamic index buffer that is repacked when visibility changes.
 *  If false, each element will be rendered with n draw calls, where n is the number of consecutive index ranges, and there will be no memory overhead.
 */
var protected{protected} const bool bUseDynamicIndexBuffer;

/** 
 *	If true, bUseDynamicIndexBuffer will be enabled when at least one fragment is hidden, otherwise it will be disabled.
 *  If false, bUseDynamicIndexBuffer will not be overridden.
 */
var protected{protected} const bool bUseDynamicIBWithHiddenFragments;

/**
 * Number of indices in the resource's index buffer the last time the component index buffer was built. 
 * Used to detect when the resource's index buffer has changed and the component's index buffer should be rebuilt.
 */
var private{private} const int NumResourceIndices;

/** TRUE whenever the static mesh is being reset during Reattach */
var protected{protected} transient const int bResetStaticMesh;

/** Enforce that the index buffer and vertex color buffer aren't updated if an attach occurs */
var     bool    bDelayVisualUpdate;
var     bool    bUpdateVertexColor;

cpptext
{
public:
	//UObject

	/** Blocks until the component's render resources have been released so that they can safely be modified */
	virtual void PreEditChange(UProperty* PropertyAboutToChange);
	virtual void PostEditChangeProperty(FPropertyChangedEvent& PropertyChangedEvent);

	/** 
	 * Signals to the object to begin asynchronously releasing resources
	 */
	virtual void BeginDestroy();

	/**
	 * Check for asynchronous resource cleanup completion
	 * @return	TRUE if the rendering resources have been released
	 */
	virtual UBOOL IsReadyForFinishDestroy();

	//Accessors
	INT GetNumVisibleTriangles() const;
	UBOOL GetInitialVisibilityValue() const;

// Firaxis BEGIN
// RAM - support for painting building destruction
	/** 
	 * Resets VisibleFragments to bInitialVisibilityValue. 
	 * Does not cause a reattach, so the results won't be propagated to the render thread until the next reattach. 
	 */
	void ResetVisibility();
// Firaxis END

    virtual UMaterialInterface* GetMaterial(INT ElementIndex, INT LOD) const; // FIRAXIS ADDITION

	/** Determine if the component vertex color buffer is in-sync with the static mesh vertex buffer */
	UBOOL OverrideVertColorIsValid() const; // FIRAXIS ADDITION

	/** Setup component vertex color buffer for use with the destruction color functionality */
	void InitOverrideVertColorBuffer(); // FIRAXIS ADDITION



protected:

	/**
	 * Called after all objects referenced by this object have been serialized. Order of PostLoad routed to 
	 * multiple objects loaded in one set is not deterministic though ConditionalPostLoad can be forced to
	 * ensure an object has been "PostLoad"ed.
	 */
	virtual void PostLoad();

	virtual void InitResources();
	virtual void ReleaseResources();
	void ReleaseBaseResources();

	/** Attaches the component to the scene, and initializes the component's resources if they have not been yet. */
	virtual void Attach();	

	/** Checks if the given fragment is visible. */
	virtual UBOOL IsElementFragmentVisible( INT ElementIndex, INT FragmentIndex, INT InteriorElementIndex, INT CoreFragmentIndex, UBOOL bAnyFragmentsHidden ) const;
	virtual UBOOL IsElementFragmentPendingVisible( INT ElementIndex, INT FragmentIndex, INT InteriorElementIndex, INT CoreFragmentIndex, UBOOL bAnyFragmentsHidden ) const; // Firaxis Add

	/** 
	 * Updates the fragments of this component that are visible.  
	 * @param NewVisibleFragments - visibility factors for this component, corresponding to FracturedStaticMesh's Fragments array
	 * @param bForceUpdate - whether to update this component's resources even if no fragments have changed visibility
	 */
	virtual void UpdateVisibleFragments(const TArray<INT>& NewVisibleFragments, UBOOL bForceUpdate);  // Firaxis change

	/** Clear out all destruction information from the vertex color buffer. */
	virtual void ClearDestructionVertexColorBuffer(const BYTE ClearValue); // FIRAXIS ADDITION

	/** 
	* Determine if the mesh currently has any hidden fragments
	* @return TRUE if >0 hidden fragments
	*/
	UBOOL HasHiddenFragments() const;

private:

	/** Helper function for calculating vertex colors based on fragment hidden state. */
	void CalculateVertexValuesFromFragments( UFracturedStaticMesh* InFracturedMesh, TMap<INT,INT>& VertToValue );

	/** Update the vertex color buffer if appropriate. */
	virtual void InitializeVertexColorBuffer(); // FIRAXIS ADDITION

	/** Update the vertex color buffer. Requires knowledge of the fracture chunks removed during last damage. */
	virtual void UpdateVertexColorBuffer(); // FIRAXIS ADDITION

	/** Enqueues a rendering command to update the component's dynamic index buffer. */
	void UpdateComponentIndexBuffer();

	friend class FFracturedBaseSceneProxy;
	friend class FFracturedStaticLightingMesh; // FIRAXIS ADDITION
	friend class UXComFracDecoComponent; // FIRAXIS ADDITION
}

native function SwitchToFractureCollision( ); // FIRAXIS ADDITION
native function RestoreToRenderMatchCollision( ); // FIRAXIS ADDITION

/** 
 * Change the StaticMesh used by this instance, and resets VisibleFragments to all be visible if NewMesh is valid.
 * @param NewMesh - StaticMesh to set.  If this is not also a UFracturedStaticMesh, assignment will fail.
 * @return bool - TRUE if assignment succeeded.
 */
simulated native function bool SetStaticMesh( StaticMesh NewMesh, optional bool bForce );

/** Returns array of currently visible fragments. */
simulated native function array<int> GetVisibleFragments() const;  // Firaxis change

/** Returns whether the specified fragment is currently visible or not. */
simulated native function bool IsFragmentVisible(INT FragmentIndex) const;
simulated native function bool IsFragmentPendingVisible(INT FragmentIndex) const; // Firaxis Addition

/** Get the number of chunks in the assigned fractured mesh. */
native function int GetNumFragments() const;

/** Get the number of chunks that are currently visible. */
native function int GetNumVisibleFragments() const;

/**
 *	Return set of fragments that are hidden, but who have at least one visible neighbour.
 *	@param AdditionalVisibleFragments	Additional fragments to consider 'visible' when finding fragments. Will not end up in resulting array.
 */
native final function array<int> GetBoundaryHiddenFragments(array<int> AdditionalVisibleFragments);

/**
 *	Return set of fragments that are visible, but who have at least one hidden neighbour.
 */
native function GetBoundaryVisibleFragments(out array<int> BoundaryVisibleFragments); // FIRAXIS ADDITION

native final function array<int> GetAllVisibleFragments() const; // FIRAXIS ADDITION
native final function array<int> GetAllPendingVisibleFragments() const; // FIRAXIS ADDITION

/** Hook into set material so we can reset our destruction materials */
native function SetMaterial(int ElementIndex, MaterialInterface Material); // FIRAXIS ADDITION

native function MaterialInterface GetMaterial(int ElementIndex) const; // FIRAXIS ADDITION

native function PostApplyCheckpoint(); // FIRAXIS ADDITION

defaultproperties
{
	bUseVertexColorDestruction=false
	bUseDynamicIndexBuffer=true
	bInitialVisibilityValue=true
	bAcceptsDecalsDuringGameplay=FALSE
	bAcceptsStaticDecals=FALSE
	bAcceptsDynamicDecals=TRUE
	bPreventChunkRemoval=FALSE // FIRAXIS
	bDelayVisualUpdate=FALSE
	bUpdateVertexColor=FALSE
	fVertexColorGradientDistance=150.0; // FIRAXIS
	bCollideAgainstPendingFragments=false // FIRAXIS
}
