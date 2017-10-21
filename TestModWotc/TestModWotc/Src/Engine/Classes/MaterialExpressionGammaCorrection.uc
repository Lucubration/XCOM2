//Firaxis Change - JW
class MaterialExpressionGammaCorrection extends MaterialExpression
	native(Material);

var ExpressionInput	Input;

var() float Exponent;

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
	Exponent=2.2
	MenuCategories(0)="Utility"
}

