/**
 * FIRAXIS ADDITION
 */
class MaterialExpressionDynamicSwitchParameter extends MaterialExpressionParameter
	native(Material)
	collapsecategories
	hidecategories(Object);

var() bool	DefaultValue;

var ExpressionInput IfTrue;
var ExpressionInput IfFalse;

cpptext
{
	virtual INT Compile(FMaterialCompiler* Compiler, INT OutputIndex);
	virtual FString GetCaption() const;
}

defaultproperties
{
	MenuCategories(0)="Parameters"
	DefaultValue=false
}
