/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class Texture2DArray extends Texture
	native(Texture)
	hidecategories(Object)
	hidecategories(Texture)
	hidecategories(Mobile)
	collapsecategories;

/** Cached width of the texture array. */
var const int SizeX;

/** Cached height of the texture array. */
var const int SizeY;

/** Cached format of the cubemap */
var const EPixelFormat Format;

/** Cached number of textures in the array */
var const int NumTextures;

/** Cached number of mips in the texture array */
var const int NumMips;

/** Cached information on whether the cubemap is valid, aka all faces are non NULL and match in width, height and format. */
var transient const bool bIsTextureArrayValid;

var() const bool bIsMutable;

var const TextureAddress AddressX;
var const TextureAddress AddressY;

var() const Array<Texture2D> Textures;

var bool bGeneratePhotoboothMips;

var native const IndirectArray_Mirror MipData{TIndirectArray<FByteBulkData>};

native function SetTexture(int Index, Texture2D Texture);

cpptext
{
	// UObject interface.
	void InitializeIntrinsicPropertyValues();
	virtual void Serialize(FArchive& Ar);
	virtual void PostEditChangeProperty(FPropertyChangedEvent& PropertyChangedEvent);
	virtual void PostLoad();

	// Thumbnail interface.
	/** 
	 * Returns a one line description of an object for viewing in the thumbnail view of the generic browser
	 */
	virtual FString GetDesc();

	/** 
	 * Returns detailed info to populate listview columns
	 */
	virtual FString GetDetailedDescription( INT InIndex );

	// USurface interface
	virtual FLOAT GetSurfaceWidth() const { return SizeX; }
	virtual FLOAT GetSurfaceHeight() const { return SizeY; }

	// UTexture interface
	virtual FTextureResource* CreateResource();
	virtual EMaterialValueType GetMaterialType() { return MCT_Texture2DArray; }
	
	// UTextureCube interface

	/**
	 * Validates cubemap which entails verifying that all faces are non-NULL and share the same format, width, height and number of
	 * miplevels. The results are cached in the respective mirrored properties and bIsCubemapValid is set accordingly.
	 */
	void Validate();

	void GetMipDataFromBaseTexture(INT TextureIndex, INT MipIndex);

	/**
	 * Returns the face associated with the passed in index.
	 *
	 * @param	FaceIndex	index of face to return
	 * @return	texture object associated with passed in face index
	 */
	UTexture2D* GetTexture( INT Index ) const;

	/**
	 * Calculates the size of this texture if it had MipCount miplevels streamed in.
	 *
	 * @param	MipCount	Which mips to calculate size for.
	 * @return	Total size of all specified mips, in bytes
	 */
	virtual INT CalcTextureMemorySize( ETextureMipCount MipCount ) const;

	/**
	* Update the resource's mips from the Textures array mips.
	*/
	void UpdateMipsFromTextures_RenderThread();
}

defaultproperties
{
	bGeneratePhotoboothMips=false
}