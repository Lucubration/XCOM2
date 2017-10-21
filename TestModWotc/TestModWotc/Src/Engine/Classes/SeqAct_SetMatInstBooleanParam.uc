/**
 * FIRAXIS ADDITION
 */
class SeqAct_SetMatInstBooleanParam extends SequenceAction
	native(Sequence);

cpptext
{
	void Activated();
}

var() MaterialInstanceConstant	MatInst;
var() Name						ParamName;

var() bool BooleanValue;

defaultproperties
{
	ObjName="Set BooleanParam"
	ObjCategory="Material Instance"
	VariableLinks.Empty
	VariableLinks(0)=(ExpectedType=class'SeqVar_Bool',LinkDesc="BooleanValue",PropertyName=BooleanValue)
}
