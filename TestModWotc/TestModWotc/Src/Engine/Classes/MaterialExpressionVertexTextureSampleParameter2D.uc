//---------------------------------------------------------------------------------------
//  *********   FIRAXIS SOURCE CODE   ******************
//  FILE:    MaterialExpressionVertexTextureSampleParameter2D.uc
//  AUTHOR:  Jeremy Shopf  --  mm/dd/yyyy
//  PURPOSE: Material expression for a vertex texture fetch
//---------------------------------------------------------------------------------------
//  Copyright (c) 2009 Firaxis Games, Inc. All rights reserved.
//--------------------------------------------------------------------------------------- 
class MaterialExpressionVertexTextureSampleParameter2D extends MaterialExpressionTextureSampleParameter2D
	native(Material)
	collapsecategories
	hidecategories(Object);

cpptext
{
	virtual INT Compile(FMaterialCompiler* Compiler, INT OutputIndex);
	
	/**
	 *	Sets the default texture if none is set
	 */
	virtual void SetDefaultTexture();
}

defaultproperties
{
	Texture=Texture2D'EngineResources.DefaultTexture'
	MenuCategories(0)="Texture"
	MenuCategories(1)="Parameters"
}
