/**
 * This is a simple thumbnail renderer that uses a specified icon as the
 * thumbnail view for a resource. It will only render UClass objects with
 * the CLASS_Archetype flag
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class ArchetypeThumbnailRenderer extends IconThumbnailRenderer
	native;

cpptext
{
	/**
	 * Allows the thumbnail renderer object the chance to reject rendering a
	 * thumbnail for an object based upon the object's data. For instance, an
	 * archetype should only be rendered if it's flags have RF_ArchetypeObject.
	 *
	 * @param Object 			the object to inspect
	 * @param bCheckObjectState	TRUE indicates that the object's state should be inspected to determine whether it can be supported;
	 *							FALSE indicates that only the object's type should be considered (for caching purposes)
	 *
	 * @return TRUE if it needs a thumbnail, FALSE otherwise
	 */
	virtual UBOOL SupportsThumbnailRendering(UObject* Object,UBOOL bCheckObjectState=TRUE);

	/**  FIRAXIS: Dom/Justin: Copied from IconThumbnailRenderer
	 * Draws a thumbnail for the object that was specified
	 *
	 * @param Object the object to draw the thumbnail for
	 * @param PrimType ignored
	 * @param X the X coordinate to start drawing at
	 * @param Y the Y coordinate to start drawing at
	 * @param Width the width of the thumbnail to draw
	 * @param Height the height of the thumbnail to draw
	 * @param Viewport ignored
	 * @param Canvas the render interface to draw with
	 * @param BackgroundType type of background for the thumbnail
	 * @param PreviewBackgroundColor background color for material previews
	 * @param PreviewBackgroundColorTranslucent background color for translucent material previews
	 */
	virtual void Draw(UObject* Object,EThumbnailPrimType PrimType,INT X,INT Y,
		DWORD Width,DWORD Height,FRenderTarget* RenderTarget,FCanvas* Canvas,
		EThumbnailBackgroundType BackgroundType,
		FColor PreviewBackgroundColor,
		FColor PreviewBackgroundColorTranslucent);
}
