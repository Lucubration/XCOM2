/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class MaterialExpressionTextureSampleParameterMipBias extends MaterialExpressionTextureSampleParameter2D
	native(Material)
	collapsecategories
	hidecategories(Object);

cpptext
{
	virtual FString GetCaption() const;

	virtual const TArray<FExpressionInput*> GetInputs();
	virtual FExpressionInput* GetInput(INT InputIndex);
	virtual FString GetInputName(INT InputIndex) const;
}

defaultproperties
{
	Texture=Texture2D'EngineResources.DefaultTexture'
	MenuCategories(0)="Texture"
	MenuCategories(1)="Parameters"
}
