// This class it not intended to have children, waiting for an additive to finish
// usually defeats the purpose of an additive
class X2Action_PlayAdditiveAnim extends X2Action;

var	public CustomAnimParams AdditiveAnimParams;

simulated state Executing
{
Begin:
	FinishAnim(UnitPawn.GetAnimTreeController().PlayAdditiveDynamicAnim(AdditiveAnimParams));
	UnitPawn.GetAnimTreeController().RemoveAdditiveDynamicAnim(AdditiveAnimParams);

	CompleteAction();
}
