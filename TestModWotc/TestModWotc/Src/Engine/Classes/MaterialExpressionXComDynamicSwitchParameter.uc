/**
 * FIRAXIS ADDITION
 */
class MaterialExpressionXComDynamicSwitchParameter extends MaterialExpression
	native(Material)
	collapsecategories
	hidecategories(Object);

//If new types are added other than to the end, shaders must be forced rebuilt or
// materials that use this expression will retrieve incorrect values.
/** Parameter Type */
var() const enum EMaterialXComDynamicSwitchType
{
	XCOMDS_Raining
} XComDynamicSwitchType;

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
}
