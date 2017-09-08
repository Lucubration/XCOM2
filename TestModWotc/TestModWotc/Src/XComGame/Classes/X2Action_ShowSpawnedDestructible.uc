//---------------------------------------------------------------------------------------
//  FILE:    X2Action_ShowSpawnedDestructible.uc
//  AUTHOR:  Joshua Bouscher
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class X2Action_ShowSpawnedDestructible extends X2Action;

simulated function ShowDestructible()
{
	local XComDestructibleActor DestructActor;
	local ParticleSystemComponent PSC;

	DestructActor = XComDestructibleActor(Metadata.VisualizeActor);
	`assert(DestructActor != none);

	DestructActor.SetPrimitiveHidden(false);

	// these effects aren't shown when hiding the destructible. show them directly.
	foreach DestructActor.m_arrRemovePSCOnDeath( PSC )
	{
		if (PSC != none && PSC.bIsActive)
			PSC.SetHidden( false );
	}
}

simulated state Executing
{
Begin:

	ShowDestructible();

	CompleteAction();
}