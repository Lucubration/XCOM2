//---------------------------------------------------------------------------------------
//  FILE:    GroupActorThumbnailRenderer.uc
//  AUTHOR:  Ryan McFall  --  4/11/2014
//  PURPOSE: Renders a group actor into a thumbnail image for the content browser
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2014 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class GroupActorThumbnailRenderer extends DefaultSizedThumbnailRenderer
	native
	config(Editor);

cpptext
{
	/**
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
	virtual void Draw(UObject* Object,EThumbnailPrimType,INT X,INT Y,
		DWORD Width,DWORD Height,FRenderTarget*,FCanvas* Canvas,
		EThumbnailBackgroundType BackgroundType,
		FColor PreviewBackgroundColor,
		FColor PreviewBackgroundColorTranslucent);
}
