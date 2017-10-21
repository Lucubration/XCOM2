 //Firaxis Change - JW
class MaterialExpressionConstantScale extends MaterialExpression
	native(Material);

var ExpressionInput	Input;

var() float Scale;

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
	Scale=.5
	MenuCategories(0)="Utility"
}
