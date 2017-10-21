/**
 * FIRAXIS ADDITION
 */
class MaterialExpressionXComVectorParameter extends MaterialExpression
	native(Material)
	collapsecategories
	hidecategories(Object);

//If new types are added other than to the end, shaders must be forced rebuilt or
// materials that use this expression will retrieve incorrect values.
/** Parameter Type */
var() const enum EMaterialXComVectorType
{
	XCOMVECTOR_EnvironmentDirection,
	XCOMVECTOR_EnvironmentColor,
	XCOMVECTOR_WeatherParameters,
	XCOMVECTOR_BuildingVisParameters,
	XCOMVECTOR_EnvironmentColorAndEmissiveFade,
	XCOMVECTOR_TestVector,
	XCOMVECTOR_BuildingVisParameters2
} XComVectorType;

cpptext
{
	virtual INT Compile(FMaterialCompiler* Compiler, INT OutputIndex);
	virtual FString GetCaption() const;
}

defaultproperties
{
	MenuCategories(0)="Parameters"
	MenuCategories(1)="Vectors"

	Outputs(0)=(OutputName="",Mask=1,MaskR=1,MaskG=1,MaskB=1,MaskA=0)
	Outputs(1)=(OutputName="",Mask=1,MaskR=1,MaskG=0,MaskB=0,MaskA=0)
	Outputs(2)=(OutputName="",Mask=1,MaskR=0,MaskG=1,MaskB=0,MaskA=0)
	Outputs(3)=(OutputName="",Mask=1,MaskR=0,MaskG=0,MaskB=1,MaskA=0)
	Outputs(4)=(OutputName="",Mask=1,MaskR=0,MaskG=0,MaskB=0,MaskA=1)
	Outputs(5)=(OutputName="",Mask=1,MaskR=1,MaskG=1,MaskB=1,MaskA=1)
}
