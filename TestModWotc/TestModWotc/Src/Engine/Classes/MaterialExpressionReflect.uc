/**
 * Copyright 1998-2008 Epic Games, Inc. All Rights Reserved.
 */

//Firaxis Change -JW
class MaterialExpressionReflect extends MaterialExpression
	native(Material);

var ExpressionInput	Input;
var ExpressionInput	Normal;

cpptext
{
	virtual INT Compile(FMaterialCompiler* Compiler, INT OutputIndex);
	virtual FString GetCaption() const;

	/**
	 * Replaces references to the passed in expression with references to a different expression or NULL.
	 * @param	OldExpression		Expression to find reference to.
	 * @param	NewExpression		Expression to replace reference with.
	 */
	virtual void SwapReferenceTo(UMaterialExpression* OldExpression,UMaterialExpression* NewExpression = NULL);
}

defaultproperties
{
	MenuCategories(0)="Math"
	MenuCategories(1)="VectorOps"
}