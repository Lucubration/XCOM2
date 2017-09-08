class X2TargetingMethod_Volt extends X2TargetingMethod_TopDown;

function DirectSetTarget(int TargetIndex)
{
	local XComGameStateHistory History;
	local array<Actor> TargetedActors;
	local int i;

	super.DirectSetTarget(TargetIndex);

	ClearTargetedActors();
	if (Action.AvailableTargets[LastTarget].AdditionalTargets.Length > 0)
	{
		History = `XCOMHISTORY;
		TargetedActors.AddItem(History.GetVisualizer(Action.AvailableTargets[LastTarget].PrimaryTarget.ObjectID));
		for (i = 0; i < Action.AvailableTargets[LastTarget].AdditionalTargets.Length; ++i)
		{
			TargetedActors.AddItem(History.GetVisualizer(Action.AvailableTargets[LastTarget].AdditionalTargets[i].ObjectID));
		}
		MarkTargetedActors(TargetedActors);
	}
}

function Committed()
{
	ClearTargetedActors();
	super.Committed();
}

function Canceled()
{
	ClearTargetedActors();
	super.Canceled();
}