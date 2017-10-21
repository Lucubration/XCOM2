//Firaxis Change - JW

class MaterialExpressionMin extends MaterialExpression
	native(Material);
	
var ExpressionInput A;
var ExpressionInput B;

cpptext
{
	virtual INT Compile(FMaterialCompiler* Compiler, INT OutputIndex);
	virtual FString GetCaption() const;
}

defaultproperties
{
	MenuCategories(0)="Math"
}
