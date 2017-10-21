/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 *
 *	A material expression that routes particle emitter parameters to the
 *	material.
 */
class MaterialExpressionDynamicParameter1 extends MaterialExpressionDynamicParameter
	native(Material)
	collapsecategories
	hidecategories(Object);

cpptext
{
	virtual INT Compile(FMaterialCompiler* Compiler, INT OutputIndex);
	virtual FString GetCaption() const;
}

defaultproperties
{
}