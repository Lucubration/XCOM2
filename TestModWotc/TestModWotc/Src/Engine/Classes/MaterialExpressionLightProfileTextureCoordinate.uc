/**
 * Author: Jeremy Shopf
 *			Firaxis Games
 * Purpose: Use the Cone Angle of a Light to Compute a Texture Coordinate used for indexing a light profile
 */
class MaterialExpressionLightProfileTextureCoordinate extends MaterialExpression
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
	MenuCategories(0)="Coordinates"
}
