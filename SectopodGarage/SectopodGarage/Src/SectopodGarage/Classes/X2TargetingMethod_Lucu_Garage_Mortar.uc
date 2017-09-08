class X2TargetingMethod_Lucu_Garage_Mortar extends X2TargetingMethod_Grenade;

function Init(AvailableAction InAction)
{
	local X2AbilityTarget_Lucu_Garage_Cursor CursorTarget;

	super.Init(InAction);

	CursorTarget = X2AbilityTarget_Lucu_Garage_Cursor(Ability.GetMyTemplate().AbilityTargetStyle);
	Cursor.m_fMinChainedDistance = `TILESTOUNITS(CursorTarget.MinTargetingRange);
}
