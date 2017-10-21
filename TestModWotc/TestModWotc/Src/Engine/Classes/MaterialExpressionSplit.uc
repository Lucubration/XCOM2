/**
 * Copyright 1998-2008 Epic Games, Inc. All Rights Reserved.
 */

//Firaxis Change - JW
class MaterialExpressionSplit extends MaterialExpression
	native(Material)
	collapsecategories
	hidecategories(Object);

/** 
 * MaterialExpressionSplit: 
 */

var ExpressionInput	Input;

cpptext
{
	virtual INT Compile(FMaterialCompiler* Compiler, INT OutputIndex);
	virtual void SwapReferenceTo(UMaterialExpression* OldExpression,UMaterialExpression* NewExpression = NULL);

	virtual FString GetCaption() const;
}

defaultproperties
{
	MenuCategories(0)="Utility"
	MenuCategories(1)="VectorOps"

	Outputs(0)=(OutputName="",Mask=1,MaskR=1,MaskG=1,MaskB=1,MaskA=0)
	Outputs(1)=(OutputName="",Mask=1,MaskR=1,MaskG=0,MaskB=0,MaskA=0)
	Outputs(2)=(OutputName="",Mask=1,MaskR=0,MaskG=1,MaskB=0,MaskA=0)
	Outputs(3)=(OutputName="",Mask=1,MaskR=0,MaskG=0,MaskB=1,MaskA=0)
	Outputs(4)=(OutputName="",Mask=1,MaskR=0,MaskG=0,MaskB=0,MaskA=1)
	Outputs(5)=(OutputName="",Mask=1,MaskR=1,MaskG=1,MaskB=1,MaskA=1)
}
