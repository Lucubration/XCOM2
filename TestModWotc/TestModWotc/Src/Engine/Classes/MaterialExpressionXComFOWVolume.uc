//---------------------------------------------------------------------------------------
//  FILE:    MaterialExpressionXComFOWVolume.uc
//  AUTHOR:  Jeremy Shopf  --  06/23/2011
//  PURPOSE: Allows the FOW 3D Volume to be sampled through the material editor
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2010 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class MaterialExpressionXComFOWVolume extends MaterialExpression
	native(Material)
	collapsecategories
	hidecategories(Object);

/** 
 * MaterialExpressionFOWVolume: 
 * samples the FOW volume texture
 */

/** texture coordinate inputt expression for this node */
var ExpressionInput	Coordinates;

/** Uses linear filtering on all scene textures in this material */
var() bool LinearFiltering;

cpptext
{
	virtual INT Compile(FMaterialCompiler* Compiler, INT OutputIndex);
	virtual void SwapReferenceTo(UMaterialExpression* OldExpression,UMaterialExpression* NewExpression = NULL);

	virtual FString GetCaption() const;
}

defaultproperties
{
	MenuCategories(0)="Texture"
	Outputs(0)=(OutputName="",Mask=1,MaskR=1,MaskG=1,MaskB=1,MaskA=0)
	Outputs(1)=(OutputName="",Mask=1,MaskR=1,MaskG=0,MaskB=0,MaskA=0)
	Outputs(2)=(OutputName="",Mask=1,MaskR=0,MaskG=1,MaskB=0,MaskA=0)
	Outputs(3)=(OutputName="",Mask=1,MaskR=0,MaskG=0,MaskB=1,MaskA=0)
	Outputs(4)=(OutputName="",Mask=1,MaskR=0,MaskG=0,MaskB=0,MaskA=1)
}
